use crate::db::schema::bid_class;
use diesel::{Queryable, Selectable, Insertable, AsChangeset};

#[derive(Debug, Clone, Queryable, Selectable)]
#[diesel(table_name = bid_class)]
pub struct BidClass {
    pub bid_class_id: i32,
    pub bid_class_name: String,
    pub bid_class_desc: String,
}

#[derive(Debug, Clone, Insertable, AsChangeset)]
#[diesel(table_name = bid_class)]
pub struct NewBidClass {
    pub bid_class_name: String,
    pub bid_class_desc: String,
}
