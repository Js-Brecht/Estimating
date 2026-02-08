use crate::db::schema::users;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = users)]
pub struct User {
    pub sid: String,
    pub user_name: String,
    pub full_name: String,
    pub email: Option<String>,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = users)]
pub struct NewUser {
    pub sid: String,
    pub user_name: String,
    pub full_name: String,
    pub email: Option<String>,
}
