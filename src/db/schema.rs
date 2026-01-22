// @generated automatically by Diesel CLI.

diesel::table! {
    bid_class (bid_class_id) {
        bid_class_id -> Integer,
        bid_class_name -> Text,
        bid_class_desc -> Text,
    }
}

diesel::table! {
    city (city_id) {
        city_id -> Integer,
        city_name -> Text,
        state_id -> Nullable<Integer>,
        region_id -> Nullable<Integer>,
    }
}

diesel::table! {
    contractor_contacts (contact_id) {
        contact_id -> Integer,
        contractor_id -> Integer,
        first_name -> Text,
        middle_name -> Nullable<Text>,
        last_name -> Nullable<Text>,
        extension -> Nullable<Text>,
        mobile -> Nullable<Text>,
        email_address -> Nullable<Text>,
        send_to -> Integer,
    }
}

diesel::table! {
    contractor_groups (contractor_id, group_id) {
        contractor_id -> Integer,
        group_id -> Integer,
    }
}

diesel::table! {
    contractors (contractor_id) {
        contractor_id -> Integer,
        contractor_name -> Text,
        acronym -> Nullable<Text>,
        address1 -> Nullable<Text>,
        address2 -> Nullable<Text>,
        phone_number -> Nullable<Text>,
        fax_number -> Nullable<Text>,
        zip_code -> Nullable<Text>,
        city_id -> Nullable<Integer>,
        bow -> Integer,
        dot -> Integer,
        heps_electrical -> Integer,
        heps_mech -> Integer,
        hpha -> Integer,
        macc -> Integer,
        military -> Integer,
        private -> Integer,
        university -> Integer,
    }
}

diesel::table! {
    contractors_bidding (job_id, contractor_id) {
        job_id -> Integer,
        contractor_id -> Integer,
        jv -> Nullable<Integer>,
    }
}

diesel::table! {
    cop (cop_id) {
        cop_id -> Integer,
        job_id -> Integer,
        cop_num -> Nullable<Integer>,
        rfi -> Nullable<Text>,
        title -> Nullable<Text>,
        desc -> Nullable<Text>,
    }
}

diesel::table! {
    cop_notes (note_id) {
        note_id -> Integer,
        cop_id -> Integer,
        rev_id -> Integer,
        user_sid -> Nullable<Text>,
        created -> Timestamp,
        note -> Text,
    }
}

diesel::table! {
    cop_rev (rev_id) {
        rev_id -> Integer,
        cop_id -> Integer,
        rev -> Nullable<Integer>,
        rev_date -> Timestamp,
        amount -> Nullable<Float>,
        status -> Integer,
    }
}

diesel::table! {
    job_notes (note_id) {
        note_id -> Integer,
        job_id -> Integer,
        created -> Timestamp,
        user -> Text,
        note -> Text,
    }
}

diesel::table! {
    jobs (job_id) {
        job_id -> Integer,
        job_name -> Text,
        city_id -> Nullable<Integer>,
        addendums -> Nullable<Text>,
        bid_amount -> Nullable<Float>,
        bid_date -> Nullable<Timestamp>,
        bid_time -> Nullable<Timestamp>,
        job_walk_date -> Nullable<Timestamp>,
        job_walk_time -> Nullable<Timestamp>,
        bid_status -> Nullable<Integer>,
        leed_tracking -> Integer,
        demolition -> Integer,
        acm -> Integer,
        lead -> Integer,
        pcb -> Integer,
        mercury -> Integer,
        arsenic -> Integer,
        mold -> Integer,
        soil -> Integer,
        created_date -> Nullable<Timestamp>,
        created_by -> Nullable<Text>,
    }
}

diesel::table! {
    month_list (val) {
        val -> Integer,
        title -> Text,
    }
}

diesel::table! {
    region (region_id) {
        region_id -> Integer,
        region_name -> Text,
    }
}

diesel::table! {
    state (state_id) {
        state_id -> Integer,
        state_initial -> Text,
        state_name -> Text,
    }
}

diesel::table! {
    users (sid) {
        sid -> Text,
        user_name -> Text,
        full_name -> Text,
        email -> Nullable<Text>,
    }
}

diesel::joinable!(city -> region (region_id));
diesel::joinable!(city -> state (state_id));
diesel::joinable!(contractor_contacts -> contractors (contractor_id));
diesel::joinable!(contractor_groups -> bid_class (group_id));
diesel::joinable!(contractor_groups -> contractors (contractor_id));
diesel::joinable!(contractors -> city (city_id));
diesel::joinable!(contractors_bidding -> jobs (job_id));
diesel::joinable!(cop -> jobs (job_id));
diesel::joinable!(cop_notes -> cop (cop_id));
diesel::joinable!(cop_notes -> cop_rev (rev_id));
diesel::joinable!(cop_notes -> users (user_sid));
diesel::joinable!(cop_rev -> cop (cop_id));
diesel::joinable!(job_notes -> jobs (job_id));
diesel::joinable!(jobs -> city (city_id));
diesel::joinable!(jobs -> users (created_by));

diesel::allow_tables_to_appear_in_same_query!(
    bid_class,
    city,
    contractor_contacts,
    contractor_groups,
    contractors,
    contractors_bidding,
    cop,
    cop_notes,
    cop_rev,
    job_notes,
    jobs,
    month_list,
    region,
    state,
    users,
);
