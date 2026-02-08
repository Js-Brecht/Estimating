use crate::db::schema::month_list;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = month_list)]
pub struct MonthList {
    pub val: i32,
    pub title: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = month_list)]
pub struct NewMonthList {
    pub val: i32,
    pub title: String,
}
