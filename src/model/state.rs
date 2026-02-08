use crate::db::schema::state;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = state)]
pub struct State {
    pub state_id: i32,
    pub state_initial: String,
    pub state_name: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = state)]
pub struct NewState {
    pub state_initial: String,
    pub state_name: String,
}
