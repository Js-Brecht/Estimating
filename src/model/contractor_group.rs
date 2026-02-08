use crate::db::schema::contractor_groups;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = contractor_groups)]
pub struct ContractorGroup {
    pub contractor_id: i32,
    pub group_id: i32,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = contractor_groups)]
pub struct NewContractorGroup {
    pub contractor_id: i32,
    pub group_id: i32,
}
