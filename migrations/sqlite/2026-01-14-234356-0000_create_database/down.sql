DROP TABLE IF EXISTS `month_list`;

DROP INDEX IF EXISTS `bid_class_group_id_idx`;
DROP TABLE IF EXISTS `bid_class`;

DROP INDEX IF EXISTS `state_state_id_idx`;
DROP INDEX IF EXISTS `state_state_name_idx`;
DROP TABLE IF EXISTS `state`;

DROP INDEX IF EXISTS `region_region_id_idx`;
DROP INDEX IF EXISTS `region_region_name_idx`;
DROP TABLE IF EXISTS `region`;

DROP INDEX IF EXISTS `city_city_id_idx`;
DROP INDEX IF EXISTS `city_city_name_idx`;
DROP INDEX IF EXISTS `city_region_id_idx`;
DROP INDEX IF EXISTS `city_state_id_idx`;
DROP TABLE IF EXISTS `city`;

DROP INDEX IF EXISTS `users_sid_idx`;
DROP TABLE IF EXISTS `users`;

DROP INDEX IF EXISTS `jobs_fk_city_id_idx`;
DROP INDEX IF EXISTS `jobs_job_id_idx`;
DROP INDEX IF EXISTS `jobs_job_name_idx`;
DROP TABLE IF EXISTS `jobs`;

DROP INDEX IF EXISTS `job_notes_job_id_idx`;
DROP TABLE IF EXISTS `job_notes`;

DROP INDEX IF EXISTS `contractors_city_id_idx`;
DROP INDEX IF EXISTS `contractors_company_id_idx`;
DROP INDEX IF EXISTS `contractors_company_name_idx`;
DROP TABLE IF EXISTS `contractors`;

DROP INDEX IF EXISTS `contractor_contacts_contact_company_id_idx`;
DROP INDEX IF EXISTS `contractor_contacts_contact_id_idx`;
DROP TABLE IF EXISTS `contractor_contacts`;

DROP INDEX IF EXISTS `contractors_bidding_company_id_idx`;
DROP INDEX IF EXISTS `contractors_bidding_job_id_idx`;
DROP INDEX IF EXISTS `contractors_bidding_jv_idx`;
DROP TABLE IF EXISTS `contractors_bidding`;

DROP INDEX IF EXISTS `contractor_groups_contractor_id_idx`;
DROP INDEX IF EXISTS `contractor_groups_group_id_idx`;
DROP TABLE IF EXISTS `contractor_groups`;

DROP INDEX IF EXISTS `cop_job_id_idx`;
DROP TABLE IF EXISTS `cop`;

DROP INDEX IF EXISTS `cop_rev_cop_id_idx`;
DROP TABLE IF EXISTS `cop_rev`;

DROP INDEX IF EXISTS `cop_notes_cop_rev_id_idx`;
DROP INDEX IF EXISTS `cop_notes_cop_cop_id_idx`;
DROP INDEX IF EXISTS `cop_notes_id_idx`;
DROP TABLE IF EXISTS `cop_notes`;
