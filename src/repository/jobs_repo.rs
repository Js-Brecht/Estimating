use diesel::prelude::*;
use diesel::ExpressionMethods;

use crate::db::DatabaseConnection;
use crate::db::{Database, ResultError};

use crate::db::schema::jobs::dsl::*;
use crate::model::{Job, NewJob};

#[derive(Clone)]
pub struct JobsRepository<D: Database> {
    db: D,
}

impl<D: Database<Conn = DatabaseConnection>> JobsRepository<D> {
    pub fn new(db: D) -> Self {
        Self { db }
    }

    pub async fn get_jobs(&self, page: i64, limit: i64) -> Result<Vec<Job>, ResultError> {
        self.db.run(move |conn| {
            jobs.order_by(job_id.asc()).offset((page-1) * limit).limit(limit).load::<Job>(conn)
        }).await
    }

    pub async fn create_job(&self, new_job: NewJob) -> Result<Job, ResultError> {
        self.db.run(move |conn| {
            diesel::insert_into(jobs).values(&new_job).execute(conn)?;
            jobs.order_by(job_id.desc()).first(conn)
        }).await
    }
}
