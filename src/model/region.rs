use crate::db::schema::region;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = region)]
pub struct Region {
    pub region_id: i32,
    pub region_name: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = region)]
pub struct NewRegion {
    pub region_name: String,
}
