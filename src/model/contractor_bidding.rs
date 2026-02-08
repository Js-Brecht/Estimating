use crate::db::schema::contractors_bidding;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = contractors_bidding)]
pub struct ContractorBidding {
    pub job_id: i32,
    pub contractor_id: i32,
    pub jv: Option<i32>,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = contractors_bidding)]
pub struct NewContractorBidding {
    pub job_id: i32,
    pub contractor_id: i32,
    pub jv: Option<i32>,
}
