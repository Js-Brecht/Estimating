-- ----------------------------------------------------------
-- MDB Tools - A library for reading MS Access database files
-- Copyright (C) 2000-2011 Brian Bruns and others.
-- Files in libmdb are licensed under LGPL and the utilities under
-- the GPL, see COPYING.LIB and COPYING files respectively.
-- Check out http://mdbtools.sourceforge.net
-- ----------------------------------------------------------

SET client_encoding = 'UTF-8';

DROP TABLE IF EXISTS "MonthList";
CREATE TABLE IF NOT EXISTS "MonthList"
 (
	"val"			INTEGER NOT NULL DEFAULT 0, 
	"title"			VARCHAR (255)
);

-- CREATE INDEXES ...
ALTER TABLE "MonthList" ADD CONSTRAINT "MonthList_pkey" PRIMARY KEY ("val");

DROP TABLE IF EXISTS "ChangeOrderHistory";
CREATE TABLE IF NOT EXISTS "ChangeOrderHistory"
 (
	"cohistid"		SERIAL, 
	"coid"			INTEGER DEFAULT 0, 
	"coamount"		NUMERIC(15,2) DEFAULT 0, 
	"codate"		TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE INDEXES ...
CREATE INDEX "changeorderhistory_coid_idx" ON "ChangeOrderHistory" ("coid");
CREATE INDEX "changeorderhistory_corevid_idx" ON "ChangeOrderHistory" ("cohistid");
ALTER TABLE "ChangeOrderHistory" ADD CONSTRAINT "changeorderhistory_pkey" PRIMARY KEY ("cohistid");

DROP TABLE IF EXISTS "ChangeOrders";
CREATE TABLE IF NOT EXISTS "ChangeOrders"
 (
	"coid"			SERIAL, 
	"jobid"			INTEGER DEFAULT 0, 
	"coseq"			INTEGER DEFAULT 0, 
	"description"		VARCHAR (255), 
	"costatus"		INTEGER DEFAULT 0
);

-- CREATE INDEXES ...
CREATE INDEX "changeorders_coid_idx" ON "ChangeOrders" ("coid");
CREATE INDEX "changeorders_jobid_idx" ON "ChangeOrders" ("jobid");
ALTER TABLE "ChangeOrders" ADD CONSTRAINT "changeorders_pkey" PRIMARY KEY ("coid");

DROP TABLE IF EXISTS "City";
CREATE TABLE IF NOT EXISTS "City"
 (
	"cityid"		SERIAL, 
	"cityname"		VARCHAR (30), 
	"stateid"		INTEGER, 
	"regionid"		INTEGER DEFAULT 0
);

-- CREATE INDEXES ...
ALTER TABLE "City" ADD CONSTRAINT "City_pkey" PRIMARY KEY ("cityid");
CREATE INDEX "city_cityid_idx" ON "City" ("cityid");
CREATE UNIQUE INDEX "city_cityname_idx" ON "City" ("cityname");
CREATE INDEX "city_regionid_idx" ON "City" ("regionid");
CREATE INDEX "city_stateid_idx" ON "City" ("stateid");

DROP TABLE IF EXISTS "ContractorContacts";
CREATE TABLE IF NOT EXISTS "ContractorContacts"
 (
	"contactid"		SERIAL, 
	"contractorid"		INTEGER DEFAULT 0, 
	"firstname"		VARCHAR (30), 
	"middlename"		VARCHAR (255), 
	"lastname"		VARCHAR (30), 
	"extension"		VARCHAR (15), 
	"mobile"		VARCHAR (15), 
	"emailaddress"		VARCHAR (50), 
	"sendto"		BOOLEAN NOT NULL DEFAULT FALSE
);

-- CREATE INDEXES ...
CREATE INDEX "contractorcontacts_contactcompanyid_idx" ON "ContractorContacts" ("contractorid");
CREATE INDEX "contractorcontacts_contactid_idx" ON "ContractorContacts" ("contactid");
ALTER TABLE "ContractorContacts" ADD CONSTRAINT "contractorcontacts_pkey" PRIMARY KEY ("contactid");

DROP TABLE IF EXISTS "ContractorGroups";
CREATE TABLE IF NOT EXISTS "ContractorGroups"
 (
	"contractorid"		INTEGER NOT NULL,
	"groupid"		INTEGER NOT NULL
);

-- CREATE INDEXES ...
CREATE INDEX "contractorgroups_contractorid_idx" ON "ContractorGroups" ("contractorid");
CREATE INDEX "contractorgroups_groupid_idx" ON "ContractorGroups" ("groupid");
ALTER TABLE "ContractorGroups" ADD CONSTRAINT "contractorgroups_pkey" PRIMARY KEY ("groupid", "contractorid");

DROP TABLE IF EXISTS "ContractorsBidding";
CREATE TABLE IF NOT EXISTS "ContractorsBidding"
 (
	"jobid"			INTEGER NOT NULL DEFAULT 0, 
	"contractorid"		INTEGER NOT NULL DEFAULT 0, 
	"jv"			INTEGER
);

-- CREATE INDEXES ...
CREATE INDEX "contractorsbidding_companyid_idx" ON "ContractorsBidding" ("contractorid");
CREATE INDEX "contractorsbidding_jobid_idx" ON "ContractorsBidding" ("jobid");
CREATE INDEX "contractorsbidding_jv_idx" ON "ContractorsBidding" ("jv");
ALTER TABLE "ContractorsBidding" ADD CONSTRAINT "contractorsbidding_pkey" PRIMARY KEY ("jobid", "contractorid");

DROP TABLE IF EXISTS "COP";
CREATE TABLE IF NOT EXISTS "COP"
 (
	"copid"			SERIAL, 
	"jobid"			INTEGER DEFAULT 0, 
	"copnum"		INTEGER DEFAULT 0, 
	"rfi"			VARCHAR (255), 
	"title"			VARCHAR (255), 
	"desc"			TEXT
);

-- CREATE INDEXES ...
CREATE INDEX "cop_jobid_idx" ON "COP" ("jobid");
ALTER TABLE "COP" ADD CONSTRAINT "cop_pkey" PRIMARY KEY ("copid");

DROP TABLE IF EXISTS "COPNotes";
CREATE TABLE IF NOT EXISTS "COPNotes"
 (
	"noteid"		SERIAL, 
	"copid"			INTEGER DEFAULT 0, 
	"revid"			INTEGER DEFAULT 0, 
	"usersid"		VARCHAR (255), 
	"timestamp"		DATE NOT NULL DEFAULT =Now(), 
	"note"			TEXT NOT NULL
);
ALTER TABLE "COPNotes" ADD CHECK ("note" <>'');

-- CREATE INDEXES ...
CREATE INDEX "copnotes_copid_idx" ON "COPNotes" ("revid");
CREATE INDEX "copnotes_copid1_idx" ON "COPNotes" ("copid");
CREATE INDEX "copnotes_id_idx" ON "COPNotes" ("noteid");
ALTER TABLE "COPNotes" ADD CONSTRAINT "copnotes_pkey" PRIMARY KEY ("noteid");

DROP TABLE IF EXISTS "COPRev";
CREATE TABLE IF NOT EXISTS "COPRev"
 (
	"revid"			SERIAL, 
	"copid"			INTEGER DEFAULT 0, 
	"rev"			INTEGER DEFAULT 0, 
	"revdate"		DATE NOT NULL DEFAULT =Now(), 
	"amount"		NUMERIC(15,2) DEFAULT 0, 
	"status"		INTEGER NOT NULL
);

-- CREATE INDEXES ...
CREATE INDEX "coprev_copid_idx" ON "COPRev" ("copid");
ALTER TABLE "COPRev" ADD CONSTRAINT "coprev_pkey" PRIMARY KEY ("revid");

DROP TABLE IF EXISTS "Region";
CREATE TABLE IF NOT EXISTS "Region"
 (
	"regionid"		SERIAL, 
	"regionname"		VARCHAR (255) NOT NULL
);
ALTER TABLE "Region" ADD CHECK ("regionname" <>'');

-- CREATE INDEXES ...
CREATE INDEX "region_regionid_idx" ON "Region" ("regionid");
CREATE UNIQUE INDEX "region_regionname_idx" ON "Region" ("regionname");
ALTER TABLE "Region" ADD CONSTRAINT "region_pkey" PRIMARY KEY ("regionid");

DROP TABLE IF EXISTS "JobNotes";
CREATE TABLE IF NOT EXISTS "JobNotes"
 (
	"noteid"		SERIAL, 
	"jobid"			INTEGER DEFAULT 0, 
	"timestamp"		TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT =Now(), 
	"user"			VARCHAR (255) NOT NULL, 
	"note"			TEXT NOT NULL
);
ALTER TABLE "JobNotes" ADD CHECK ("user" <>'');
ALTER TABLE "JobNotes" ADD CHECK ("note" <>'');

-- CREATE INDEXES ...
CREATE INDEX "jobnotes_jobid_idx" ON "JobNotes" ("jobid");
ALTER TABLE "JobNotes" ADD CONSTRAINT "jobnotes_pkey" PRIMARY KEY ("noteid");

DROP TABLE IF EXISTS "Jobs";
CREATE TABLE IF NOT EXISTS "Jobs"
 (
	"jobid"			SERIAL, 
	"jobname"		VARCHAR (255), 
	"cityid"		INTEGER, 
	"addendums"		VARCHAR (255), 
	"bidamount"		NUMERIC(15,2), 
	"biddate"		TIMESTAMP WITHOUT TIME ZONE, 
	"bidtime"		TIMESTAMP WITHOUT TIME ZONE, 
	"jobwalkdate"		TIMESTAMP WITHOUT TIME ZONE, 
	"jobwalktime"		TIMESTAMP WITHOUT TIME ZONE, 
	"bidstatus"		INTEGER DEFAULT Null, 
	"leedtracking"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"demolition"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"acm"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"lead"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"pcb"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"mercury"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"arsenic"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"mold"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"soil"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"createddate"		TIMESTAMP WITHOUT TIME ZONE DEFAULT =Now(), 
	"createdby"		VARCHAR (255)
);
ALTER TABLE "Jobs" ADD CHECK ("jobname" <>'');

-- CREATE INDEXES ...
CREATE INDEX "jobs_fkcityid_idx" ON "Jobs" ("cityid");
CREATE INDEX "jobs_jobid_idx" ON "Jobs" ("jobid");
CREATE UNIQUE INDEX "jobs_jobname_idx" ON "Jobs" ("jobname");
ALTER TABLE "Jobs" ADD CONSTRAINT "jobs_pkey" PRIMARY KEY ("jobid");

DROP TABLE IF EXISTS "State";
CREATE TABLE IF NOT EXISTS "State"
 (
	"stateid"		SERIAL, 
	"stateinitial"		VARCHAR (2), 
	"statename"		VARCHAR (60)
);

-- CREATE INDEXES ...
ALTER TABLE "State" ADD CONSTRAINT "state_pkey" PRIMARY KEY ("stateid");
CREATE INDEX "state_stateid_idx" ON "State" ("stateid");
CREATE UNIQUE INDEX "state_statename_idx" ON "State" ("statename");

DROP TABLE IF EXISTS "Users";
CREATE TABLE IF NOT EXISTS "Users"
 (
	"sid"			VARCHAR (255) NOT NULL, 
	"username"		VARCHAR (255) NOT NULL, 
	"fullname"		VARCHAR (255) NOT NULL, 
	"email"			VARCHAR (255)
);
COMMENT ON COLUMN "Users"."sid" IS 'User Account Security ID, as listed in Active Directory ''objectSid'' property';
COMMENT ON COLUMN "Users"."username" IS 'User login name, as listed in Active Directory ''sAMAccountName'' property';
COMMENT ON COLUMN "Users"."fullname" IS 'User''s full name, as listed in Active Directory ''name'' property';
COMMENT ON COLUMN "Users"."email" IS 'User''s email address, as listed in Active Directory ''email'' property';

-- CREATE INDEXES ...
ALTER TABLE "users" ADD CONSTRAINT "users_pkey" PRIMARY KEY ("sid");
CREATE INDEX "users_sid_idx" ON "users" ("sid");

DROP TABLE IF EXISTS "BidClass";
CREATE TABLE IF NOT EXISTS "BidClass"
 (
	"bidclassid"		SERIAL, 
	"bidclassname"		VARCHAR (255), 
	"bidclassdesc"		VARCHAR (255)
);

-- CREATE INDEXES ...
CREATE INDEX "bidclass_groupid_idx" ON "BidClass" ("bidclassid");
ALTER TABLE "BidClass" ADD CONSTRAINT "bidclass_pkey" PRIMARY KEY ("bidclassid");

DROP TABLE IF EXISTS "Contractors";
CREATE TABLE IF NOT EXISTS "Contractors"
 (
	"contractorid"		SERIAL, 
	"contractorname"	VARCHAR (80), 
	"acronym"		VARCHAR (255), 
	"address1"		VARCHAR (50), 
	"address2"		VARCHAR (255), 
	"phonenumber"		VARCHAR (50), 
	"faxnumber"		VARCHAR (15), 
	"zipcode"		VARCHAR (15), 
	"cityid"		INTEGER, 
	"bow"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"dot"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"hepselectrical"	BOOLEAN NOT NULL DEFAULT FALSE, 
	"hepsmech"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"hpha"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"macc"			BOOLEAN NOT NULL DEFAULT FALSE, 
	"military"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"private"		BOOLEAN NOT NULL DEFAULT FALSE, 
	"university"		BOOLEAN NOT NULL DEFAULT FALSE
);

-- CREATE INDEXES ...
CREATE INDEX "contractors_cityid_idx" ON "Contractors" ("cityid");
CREATE INDEX "contractors_companyid_idx" ON "Contractors" ("contractorid");
CREATE UNIQUE INDEX "contractors_companyname_idx" ON "Contractors" ("contractorname");
ALTER TABLE "Contractors" ADD CONSTRAINT "contractors_pkey" PRIMARY KEY ("contractorid");


-- CREATE Relationships ...
ALTER TABLE "ContractorGroups" ADD CONSTRAINT "contractorgroups_groupid_fk" FOREIGN KEY ("groupid") REFERENCES "BidClass"("bidclassid") ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "Contractors" ADD CONSTRAINT "contractors_cityid_fk" FOREIGN KEY ("cityid") REFERENCES "City"("cityid") DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "Jobs" ADD CONSTRAINT "jobs_cityid_fk" FOREIGN KEY ("cityid") REFERENCES "City"("cityid") DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "ContractorContacts" ADD CONSTRAINT "contractorcontacts_contractorid_fk" FOREIGN KEY ("contractorid") REFERENCES "Contractors"("contractorid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "ContractorGroups" ADD CONSTRAINT "contractorgroups_contractorid_fk" FOREIGN KEY ("contractorid") REFERENCES "Contractors"("contractorid") ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "ContractorsBidding" ADD CONSTRAINT "contractorsbidding_contractorid_fk" FOREIGN KEY ("contractorid") REFERENCES "Contractors"("contractorid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- Relationship from "ContractorsBidding" ("jv") to "Contractors"("contractorid") does not enforce integrity.
-- Relationship from "COPNotes" ("revid") to "COPRev"("revid") does not enforce integrity.
ALTER TABLE "COPNotes" ADD CONSTRAINT "copnotes_copid_fk" FOREIGN KEY ("copid") REFERENCES "COP"("copid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "COPRev" ADD CONSTRAINT "coprev_copid_fk" FOREIGN KEY ("copid") REFERENCES "COP"("copid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "City" ADD CONSTRAINT "city_regionid_fk" FOREIGN KEY ("regionid") REFERENCES "Region"("regionid") ON UPDATE CASCADE ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "ContractorsBidding" ADD CONSTRAINT "contractorsbidding_jobid_fk" FOREIGN KEY ("jobid") REFERENCES "Jobs"("jobid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "COP" ADD CONSTRAINT "cop_jobid_fk" FOREIGN KEY ("jobid") REFERENCES "Jobs"("jobid") DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "JobNotes" ADD CONSTRAINT "jobnotes_jobid_fk" FOREIGN KEY ("jobid") REFERENCES "Jobs"("jobid") ON DELETE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "City" ADD CONSTRAINT "city_stateid_fk" FOREIGN KEY ("stateid") REFERENCES "State"("stateid") DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "COPNotes" ADD CONSTRAINT "copnotes_usersid_fk" FOREIGN KEY ("usersid") REFERENCES "Users"("sid") DEFERRABLE INITIALLY IMMEDIATE;
ALTER TABLE "JobNotes" ADD CONSTRAINT "jobnotes_user_fk" FOREIGN KEY ("user") REFERENCES "Users"("sid") DEFERRABLE INITIALLY IMMEDIATE;
-- Relationship from "Jobs" ("createdby") to "Users"("sid") does not enforce integrity.


-- vim: ft=sql ts=8 sw=8 sts=8 noet
