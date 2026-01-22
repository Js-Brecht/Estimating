use std::sync::Arc;

use async_trait::async_trait;
use diesel::prelude::*;
use diesel::r2d2::{ConnectionManager, CustomizeConnection, Pool};
use diesel::sqlite::SqliteConnection;
use diesel_migrations::{EmbeddedMigrations, MigrationHarness, embed_migrations};
use tokio::task;

use super::{Database, ResultError, DatabaseErrorKind, PoolError};

const MIGRATIONS: EmbeddedMigrations = embed_migrations!("migrations/sqlite");

/// Enforce foreign keys and other pragmas on each new SQLite connection from the pool.
#[derive(Debug)]
struct SqliteConnectionCustomizer;

impl CustomizeConnection<SqliteConnection, PoolError> for SqliteConnectionCustomizer {
    fn on_acquire(&self, conn: &mut SqliteConnection) -> Result<(), PoolError> {
        diesel::sql_query("PRAGMA foreign_keys = ON;")
            .execute(conn)
            .map_err(PoolError::QueryError)?;

        diesel::sql_query("PRAGMA journal_mode = WAL;")
            .execute(conn)
            .map_err(PoolError::QueryError)?;

        Ok(())
    }
}

/// Concrete SQLite backend implementing the `Database` abstraction.
#[derive(Clone)]
pub struct SqliteDatabase {
    pool: Arc<Pool<ConnectionManager<SqliteConnection>>>,
}

#[async_trait]
impl Database for SqliteDatabase {
    type Conn = SqliteConnection;
    type Error = ResultError;

    fn new(database_url: &str) -> Self {
        let manager = ConnectionManager::<Self::Conn>::new(database_url);

        let pool = Pool::builder()
            .max_size(8)
            .connection_customizer(Box::new(SqliteConnectionCustomizer))
            .build(manager)
            .expect("failed to create SQLite pool");

        Self {
            pool: Arc::new(pool),
        }
    }

    /// Run embedded migrations once at startup.
    fn run_migrations(&self) {
        let mut conn = self.pool.get().expect("get connection for migrations");

        conn.run_pending_migrations(MIGRATIONS)
            .expect("migrations failed");
    }

    async fn run<F, T>(&self, f: F) -> Result<T, Self::Error>
    where
        F: FnOnce(&mut Self::Conn) -> Result<T, Self::Error> + Send + 'static,
        T: Send + 'static,
    {
        let pool = Arc::clone(&self.pool);

        task::spawn_blocking(move || {
            let mut conn = pool.get().map_err(|e| {
                Self::Error::DatabaseError(
                    DatabaseErrorKind::UnableToSendCommand,
                    Box::new(format!("Pool error: {e}")),
                )
            })?;

            f(&mut conn)
        })
        .await
        .expect("blocking task panicked")
    }

    async fn transaction<F, T>(&self, f: F) -> Result<T, Self::Error>
    where
        F: FnOnce(&mut Self::Conn) -> Result<T, Self::Error> + Send + 'static,
        T: Send + 'static,
    {
        let pool = Arc::clone(&self.pool);

        task::spawn_blocking(move || {
            let mut conn = pool.get().map_err(|e| {
                Self::Error::DatabaseError(
                    DatabaseErrorKind::UnableToSendCommand,
                    Box::new(format!("Pool error: {e}")),
                )
            })?;

            conn.transaction(|tx_conn| f(tx_conn))
        })
        .await
        .expect("spawn_blocking panicked")
    }
}
