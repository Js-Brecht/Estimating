use crate::db::schema::cop_notes;
use chrono::NaiveDateTime;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = cop_notes)]
pub struct COPNote {
    pub note_id: i32,
    pub cop_id: i32,
    pub rev_id: i32,
    pub user_sid: Option<String>,
    pub created: NaiveDateTime,
    pub note: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = cop_notes)]
pub struct NewCOPNote {
    pub cop_id: i32,
    pub rev_id: i32,
    pub user_sid: Option<String>,
    pub created: NaiveDateTime,
    pub note: String,
}
