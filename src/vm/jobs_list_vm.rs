use std::rc::Rc;

use crate::db::{Database, DatabaseConnection, ResultError};
use crate::model::Job;
use crate::repository::jobs_repo::JobsRepository; 

pub struct JobsListViewModel<D: Database> {
    pub jobs_repo: JobsRepository<D>
}

impl<D: Database<Conn = DatabaseConnection>> JobsListViewModel<D> {
    pub fn new(db: D) -> Self {
        Self {
            jobs_repo: JobsRepository::new(db),
        }
    }

    async fn fetch_jobs(&self, page: u32) -> Result<Vec<Job>, ResultError> {
        let jobs = self.jobs_repo.get_jobs(page.into(), 10).await?;

        eprintln!("Fetched jobs: {:#?}", jobs);

        Ok(jobs)
    }
}
