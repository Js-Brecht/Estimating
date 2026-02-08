use crate::db::schema::cop;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = cop)]
pub struct COP {
    pub cop_id: i32,
    pub job_id: i32,
    pub cop_num: Option<i32>,
    pub rfi: Option<String>,
    pub title: Option<String>,
    pub desc: Option<String>,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = cop)]
pub struct NewCOP {
    pub job_id: i32,
    pub cop_num: Option<i32>,
    pub rfi: Option<String>,
    pub title: Option<String>,
    pub desc: Option<String>,
}
