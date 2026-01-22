pub mod sqlite;
pub mod schema;

use async_trait::async_trait;
use diesel::prelude::*;

pub use sqlite::{SqliteDatabase};
pub use diesel::result::{Error as ResultError, DatabaseErrorKind};
pub use diesel::r2d2::Error as PoolError;

/// Backend‑agnostic async database abstraction.
///
/// - `Conn` is the concrete Diesel connection type (e.g., `SqliteConnection`, `PgConnection`).
/// - `Error` is the error type (here we’ll use `diesel::result::Error`).
#[async_trait]
pub trait Database: Clone + Send + Sync + 'static {
    type Conn: Connection + Send;
    type Error: From<ResultError> + Send + 'static;

    fn new(connetion_str: &str) -> Self;

    fn run_migrations(&self);

    async fn run<F, T>(&self, f: F) -> Result<T, Self::Error>
    where
        F: FnOnce(&mut Self::Conn) -> Result<T, Self::Error> + Send + 'static,
        T: Send + 'static;

    async fn transaction<F, T>(&self, f: F) -> Result<T, Self::Error>
    where
        F: FnOnce(&mut Self::Conn) -> Result<T, Self::Error> + Send + 'static,
        T: Send + 'static;
}
