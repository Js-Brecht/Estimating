use dotenvy::dotenv;
use slint::ComponentHandle;
use std::env;
use std::error::Error;

pub mod db;
use db::{Database, SqliteDatabase};

slint::include_modules!();

pub async fn launch() -> Result<(), Box<dyn Error>>{
    // Load environment variables from a `.env` file if present
    dotenv().ok();
    let database_url = env::var("DATABASE_URL").expect("The environment variable `DATABASE_URL` must be set");

    // Choose your backend here. Later you can swap `SqliteDatabase` with `PostgresDatabase`
    // once implemented.
    let db = SqliteDatabase::new(&database_url);

    // Run migrations at startup (blocking, but only once)
    db.run_migrations();

    let ui = MainWindow::new()?;

    ui.run()?;

    Ok(())
}
