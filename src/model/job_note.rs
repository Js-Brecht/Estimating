use crate::db::schema::job_notes;
use chrono::NaiveDateTime;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = job_notes)]
pub struct JobNote {
    pub note_id: i32,
    pub job_id: i32,
    pub created: NaiveDateTime,
    pub user: String,
    pub note: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = job_notes)]
pub struct NewJobNote {
    pub job_id: i32,
    pub created: NaiveDateTime,
    pub user: String,
    pub note: String,
}
