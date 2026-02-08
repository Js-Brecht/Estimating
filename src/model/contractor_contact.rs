use crate::db::schema::contractor_contacts;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = contractor_contacts)]
pub struct ContractorContact {
    pub contact_id: i32,
    pub contractor_id: i32,
    pub first_name: String,
    pub middle_name: Option<String>,
    pub last_name: Option<String>,
    pub extension: Option<String>,
    pub mobile: Option<String>,
    pub email_address: Option<String>,
    pub send_to: i32,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = contractor_contacts)]
pub struct NewContractorContact {
    pub contractor_id: i32,
    pub first_name: String,
    pub middle_name: Option<String>,
    pub last_name: Option<String>,
    pub extension: Option<String>,
    pub mobile: Option<String>,
    pub email_address: Option<String>,
    pub send_to: i32,
}
