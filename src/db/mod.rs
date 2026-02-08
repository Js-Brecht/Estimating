pub mod sqlite;
pub mod schema;

use async_trait::async_trait;
use diesel::prelude::*;

#[cfg(feature = "sqlite")]
pub use sqlite::{SqliteDatabase as DatabaseBackend, SqliteConnection as DatabaseConnection};

pub use diesel::result::{Error as ResultError, DatabaseErrorKind};
pub use diesel::r2d2::Error as PoolError;

/// Backend‑agnostic async database abstraction.
///
/// Note: While this trait is generic, the actual backend is determined at compile-time
/// via Cargo features (either `sqlite` or `postgres`). This allows Diesel's type system
/// to properly resolve query fragments for the selected backend.
///
/// - `Conn` is the concrete Diesel connection type (e.g., `SqliteConnection`, `PgConnection`).
/// - `Error` is the error type (here we'll use `diesel::result::Error`).
#[async_trait]
pub trait Database: Clone + Send + Sync + 'static {
    type Conn: Connection + Send;
    type Error: From<diesel::result::Error> + Send + 'static;

    fn new(connetion_str: &str) -> Self;

    fn run_migrations(&self);

    async fn run<F, T>(&self, f: F) -> Result<T, diesel::result::Error>
    where
        for <'a> F: FnOnce(&'a mut Self::Conn) -> Result<T, diesel::result::Error> + Send + 'static,
        T: Send + 'static;

    async fn transaction<F, T>(&self, f: F) -> Result<T, Self::Error>
    where
        F: FnOnce(&mut Self::Conn) -> Result<T, Self::Error> + Send + 'static,
        T: Send + 'static;
}
