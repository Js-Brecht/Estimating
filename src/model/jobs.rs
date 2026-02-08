use crate::db::schema::jobs;
use chrono::NaiveDateTime;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = jobs)]
pub struct Job {
    pub job_id: i32,
    pub job_name: String,
    pub city_id: Option<i32>,
    pub addendums: Option<String>,
    pub bid_amount: Option<f32>,
    pub bid_date: Option<NaiveDateTime>,
    pub bid_time: Option<NaiveDateTime>,
    pub job_walk_date: Option<NaiveDateTime>,
    pub job_walk_time: Option<NaiveDateTime>,
    pub bid_status: Option<i32>,
    pub leed_tracking: i32,
    pub demolition: i32,
    pub acm: i32,
    pub lead: i32,
    pub pcb: i32,
    pub mercury: i32,
    pub arsenic: i32,
    pub mold: i32,
    pub soil: i32,
    pub created: Option<NaiveDateTime>,
    pub created_by: Option<String>,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = jobs)]
pub struct NewJob {
    pub job_name: String,
    pub city_id: Option<i32>,
    pub addendums: Option<String>,
    pub bid_amount: Option<f32>,
    pub bid_date: Option<NaiveDateTime>,
    pub bid_time: Option<NaiveDateTime>,
    pub job_walk_date: Option<NaiveDateTime>,
    pub job_walk_time: Option<NaiveDateTime>,
    pub bid_status: Option<i32>,
    pub leed_tracking: i32,
    pub demolition: i32,
    pub acm: i32,
    pub lead: i32,
    pub pcb: i32,
    pub mercury: i32,
    pub arsenic: i32,
    pub mold: i32,
    pub soil: i32,
    pub created: Option<NaiveDateTime>,
    pub created_by: Option<String>,
}
