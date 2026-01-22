-- SQLite Estimating DB Schema

-- PRAGMA journal_mode = WAL;

-- TABLE month_list
DROP TABLE IF EXISTS `month_list`;
CREATE TABLE `month_list`
 (
	`val`				INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`title`				varchar NOT NULL
);

-- TABLE bid_class
DROP TABLE IF EXISTS `bid_class`;
CREATE TABLE `bid_class` (
	`bid_class_id`		INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`bid_class_name`	varchar NOT NULL,
	`bid_class_desc`	varchar NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `bid_class_group_id_idx` ON `bid_class` (`bid_class_id`);

-- TABLE state
DROP TABLE IF EXISTS `state`;
CREATE TABLE `state` (
	`state_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`state_initial`		varchar NOT NULL,
	`state_name`		varchar NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `state_state_id_idx` ON `state` (`state_id`);
CREATE UNIQUE INDEX `state_state_name_idx` ON `state` (`state_name`);

-- TABLE region
DROP TABLE IF EXISTS `region`;
CREATE TABLE `region`
 (
	`region_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`region_name`		varchar NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `region_region_id_idx` ON `region` (`region_id`);
CREATE UNIQUE INDEX `region_region_name_idx` ON `region` (`region_name`);

-- TABLE city
DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
	`city_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`city_name`			varchar NOT NULL,
	`state_id`			INTEGER REFERENCES `state`(`state_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	`region_id`			INTEGER REFERENCES `region`(`region_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `city_city_id_idx` ON `city` (`city_id`);
CREATE UNIQUE INDEX `city_city_name_idx` ON `city` (`city_name`);
CREATE INDEX `city_region_id_idx` ON `city` (`region_id`);
CREATE INDEX `city_state_id_idx` ON `city` (`state_id`);

-- TABLE users 
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
	`sid`				varchar NOT NULL PRIMARY KEY NOT NULL,
	`user_name`			varchar NOT NULL,
	`full_name`			varchar NOT NULL,
	`email`				varchar
);
-- CREATE INDEXES ...
CREATE INDEX `users_sid_idx` ON `users` (`sid`);

-- TABLE jobs
DROP TABLE IF EXISTS `jobs`;
CREATE TABLE `jobs`
 (
	`job_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`job_name`			varchar NOT NULL, 
	`city_id`			INTEGER REFERENCES `city`(`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE, 
	`addendums`			varchar, 
	`bid_amount`		REAL DEFAULT 0, 
	`bid_date`			DateTime, 
	`bid_time`			DateTime, 
	`job_walk_date`		DateTime, 
	`job_walk_time`		DateTime, 
	`bid_status`		INTEGER DEFAULT NULL, 
	`leed_tracking`		INTEGER NOT NULL DEFAULT FALSE, 
	`demolition`		INTEGER NOT NULL DEFAULT FALSE, 
	`acm`				INTEGER NOT NULL DEFAULT FALSE, 
	`lead`				INTEGER NOT NULL DEFAULT FALSE, 
	`pcb`				INTEGER NOT NULL DEFAULT FALSE, 
	`mercury`			INTEGER NOT NULL DEFAULT FALSE, 
	`arsenic`			INTEGER NOT NULL DEFAULT FALSE, 
	`mold`				INTEGER NOT NULL DEFAULT FALSE, 
	`soil`				INTEGER NOT NULL DEFAULT FALSE, 
	`created_date`		DateTime DEFAULT CURRENT_TIMESTAMP, 
	`created_by`		varchar REFERENCES `users`(`sid`) ON DELETE SET NULL ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `jobs_fk_city_id_idx` ON `jobs` (`city_id`);
CREATE INDEX `jobs_job_id_idx` ON `jobs` (`job_id`);
CREATE UNIQUE INDEX `jobs_job_name_idx` ON `jobs` (`job_name`);

-- TABLE job_notes
DROP TABLE IF EXISTS `job_notes`;
CREATE TABLE `job_notes`
 (
	`note_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`job_id`			INTEGER NOT NULL REFERENCES `jobs`(`job_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`created`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`user`				varchar NOT NULL, 
	`note`				TEXT NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `job_notes_job_id_idx` ON `job_notes` (`job_id`);

-- TABLE contractors
DROP TABLE IF EXISTS `contractors`;
CREATE TABLE `contractors` (
	`contractor_id`		INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`contractor_name`	varchar NOT NULL,
	`acronym`			varchar,
	`address1`			varchar,
	`address2`			varchar,
	`phone_number`		varchar,
	`fax_number`		varchar,
	`zip_code`			varchar,
	`city_id`			INTEGER REFERENCES `city`(`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
	`bow`				INTEGER NOT NULL DEFAULT FALSE,
	`dot`				INTEGER NOT NULL DEFAULT FALSE,
	`heps_electrical`	INTEGER NOT NULL DEFAULT FALSE,
	`heps_mech`			INTEGER NOT NULL DEFAULT FALSE,
	`hpha`				INTEGER NOT NULL DEFAULT FALSE,
	`macc`				INTEGER NOT NULL DEFAULT FALSE,
	`military`			INTEGER NOT NULL DEFAULT FALSE,
	`private`			INTEGER NOT NULL DEFAULT FALSE,
	`university`		INTEGER NOT NULL DEFAULT FALSE
);
-- CREATE INDEXES ...
CREATE INDEX `contractors_city_id_idx` ON `contractors` (`city_id`);
CREATE INDEX `contractors_company_id_idx` ON `contractors` (`contractor_id`);
CREATE UNIQUE INDEX `contractors_company_name_idx` ON `contractors` (`contractor_name`);

-- TABLE contractor_contacts
DROP TABLE IF EXISTS `contractor_contacts`;
CREATE TABLE `contractor_contacts`
 (
	`contact_id`		INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`contractor_id`		INTEGER NOT NULL REFERENCES `contractors`(`contractor_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`first_name`		varchar NOT NULL, 
	`middle_name`		varchar, 
	`last_name`			varchar, 
	`extension`			varchar, 
	`mobile`			varchar, 
	`email_address`		varchar, 
	`send_to`			INTEGER NOT NULL DEFAULT FALSE
);
-- CREATE INDEXES ...
CREATE INDEX `contractor_contacts_contact_company_id_idx` ON `contractor_contacts` (`contractor_id`);
CREATE INDEX `contractor_contacts_contact_id_idx` ON `contractor_contacts` (`contact_id`);

-- TABLE contractors_bidding
DROP TABLE IF EXISTS `contractors_bidding`;
CREATE TABLE `contractors_bidding` (
	`job_id`			INTEGER NOT NULL,
	`contractor_id`		INTEGER NOT NULL,
	`jv`				INTEGER,
	PRIMARY KEY (`job_id`, `contractor_id`),
    FOREIGN KEY (`job_id`) REFERENCES `jobs`(`job_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`contractor_id`) REFERENCES `contractors`(`contractor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`jv`) REFERENCES `contractors`(`contractor_id`) ON DELETE SET NULL ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `contractors_bidding_company_id_idx` ON `contractors_bidding` (`contractor_id`);
CREATE INDEX `contractors_bidding_job_id_idx` ON `contractors_bidding` (`job_id`);
CREATE INDEX `contractors_bidding_jv_idx` ON `contractors_bidding` (`jv`);

-- TABLE contractor_groups
DROP TABLE IF EXISTS `contractor_groups`;
CREATE TABLE `contractor_groups`
 (
	`contractor_id`		INTEGER NOT NULL, 
	`group_id`			INTEGER NOT NULL,
    PRIMARY KEY (`contractor_id`, `group_id`),
	FOREIGN KEY (`contractor_id`) REFERENCES `contractors`(`contractor_id`) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (`group_id`) REFERENCES `bid_class`(`bid_class_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `contractor_groups_contractor_id_idx` ON `contractor_groups` (`contractor_id`);
CREATE INDEX `contractor_groups_group_id_idx` ON `contractor_groups` (`group_id`);

-- TABLE cop
DROP TABLE IF EXISTS `cop`;
CREATE TABLE `cop`
 (
	`cop_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`job_id`			INTEGER NOT NULL REFERENCES `jobs`(`job_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`cop_num`			INTEGER DEFAULT 0, 
	`rfi`				varchar, 
	`title`				varchar, 
	`desc`				TEXT
);
-- CREATE INDEXES ...
CREATE INDEX `cop_job_id_idx` ON `cop` (`job_id`);

-- TABLE cop_rev
DROP TABLE IF EXISTS `cop_rev`;
CREATE TABLE `cop_rev`
 (
	`rev_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`cop_id`			INTEGER NOT NULL REFERENCES `cop`(`cop_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`rev`				INTEGER DEFAULT 0, 
	`rev_date`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`amount`			REAL DEFAULT 0, 
	`status`			INTEGER NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `cop_rev_cop_id_idx` ON `cop_rev` (`cop_id`);

-- TABLE cop_notes
DROP TABLE IF EXISTS `cop_notes`;
CREATE TABLE `cop_notes`
 (
	`note_id`			INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
	`cop_id`			INTEGER NOT NULL REFERENCES `cop`(`cop_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`rev_id`			INTEGER NOT NULL REFERENCES `cop_rev`(`rev_id`) ON DELETE CASCADE ON UPDATE CASCADE, 
	`user_sid`			varchar REFERENCES `users`(`sid`) ON DELETE SET NULL ON UPDATE CASCADE, 
	`created`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`note`				TEXT NOT NULL
);
-- CREATE INDEXES ...
CREATE INDEX `cop_notes_cop_rev_id_idx` ON `cop_notes` (`rev_id`);
CREATE INDEX `cop_notes_cop_cop_id_idx` ON `cop_notes` (`cop_id`);
CREATE INDEX `cop_notes_id_idx` ON `cop_notes` (`note_id`);

-- vim: ft=sql ts=8 sw=8 sts=8 noet ai sc si
