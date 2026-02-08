use crate::db::schema::contractors;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = contractors)]
pub struct Contractor {
    pub contractor_id: i32,
    pub contractor_name: String,
    pub acronym: Option<String>,
    pub address1: Option<String>,
    pub address2: Option<String>,
    pub phone_number: Option<String>,
    pub fax_number: Option<String>,
    pub zip_code: Option<String>,
    pub city_id: Option<i32>,
    pub bow: i32,
    pub dot: i32,
    pub heps_electrical: i32,
    pub heps_mech: i32,
    pub hpha: i32,
    pub macc: i32,
    pub military: i32,
    pub private: i32,
    pub university: i32,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = contractors)]
pub struct NewContractor {
    pub contractor_name: String,
    pub acronym: Option<String>,
    pub address1: Option<String>,
    pub address2: Option<String>,
    pub phone_number: Option<String>,
    pub fax_number: Option<String>,
    pub zip_code: Option<String>,
    pub city_id: Option<i32>,
    pub bow: i32,
    pub dot: i32,
    pub heps_electrical: i32,
    pub heps_mech: i32,
    pub hpha: i32,
    pub macc: i32,
    pub military: i32,
    pub private: i32,
    pub university: i32,
}
