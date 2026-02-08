use crate::db::schema::cop_rev;
use chrono::NaiveDateTime;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = cop_rev)]
pub struct COPRevision {
    pub rev_id: i32,
    pub cop_id: i32,
    pub rev: Option<i32>,
    pub rev_date: NaiveDateTime,
    pub amount: Option<f32>,
    pub status: i32,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = cop_rev)]
pub struct NewCOPRevision {
    pub cop_id: i32,
    pub rev: Option<i32>,
    pub rev_date: NaiveDateTime,
    pub amount: Option<f32>,
    pub status: i32,
}
