use crate::db::schema::city;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = city)]
pub struct City {
    pub city_id: i32,
    pub city_name: String,
    pub state_id: Option<i32>,
    pub region_id: Option<i32>,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = city)]
pub struct NewCity {
    pub city_name: String,
    pub state_id: Option<i32>,
    pub region_id: Option<i32>,
}
