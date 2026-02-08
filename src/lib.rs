#![allow(dead_code)]
#![allow(unused)]
#![allow(non_snake_case)]

use dotenvy::dotenv;
use std::env;
use std::error::Error;
use std::rc::Rc;
use std::sync::{Arc, Mutex};
use dioxus::prelude::*;

mod db;
use crate::db::{DatabaseBackend, Database};

mod model;
use crate::model::Job;

mod vm;
use crate::vm::{JobsListViewModel};

mod repository;
use crate::repository::jobs_repo::JobsRepository;

mod view;
use crate::view::Route;


pub async fn launch() -> Result<(), Box<dyn Error>>{
    // Load environment variables from a `.env` file if present
    dotenv().ok();
    let database_url = env::var("DATABASE_URL").expect("The environment variable `DATABASE_URL` must be set");

    // Choose your backend here. Later you can swap `SqliteDatabase` with `PostgresDatabase`
    // once implemented.
    let db = DatabaseBackend::new(&database_url);

    // Run migrations at startup (blocking, but only once)
    db.run_migrations();

    dioxus::launch(App);

    Ok(())
}

fn App() -> Element {
    rsx!{
        Router::<Route> {}
    }
}
