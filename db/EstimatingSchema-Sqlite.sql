
PRAGMA foreign_keys = ON;

-- TABLE MonthList
DROP TABLE IF EXISTS `MonthList`;
CREATE TABLE `MonthList`
 (
	`Val`				INTEGER NOT NULL DEFAULT 0, 
	`Title`				varchar,
	PRIMARY KEY (`Val`)
);

-- TABLE BidClass
DROP TABLE IF EXISTS `BidClass`;
CREATE TABLE `BidClass` (
	`BidClassID`		INTEGER,
	`BidClassName`		varchar,
	`BidClassDesc`		varchar,
	PRIMARY KEY (`BidClassID`)
);
-- CREATE INDEXES ...
CREATE INDEX `BidClass_GroupID_idx` ON `BidClass` (`BidClassID`);

-- TABLE State
DROP TABLE IF EXISTS `State`;
CREATE TABLE `State` (
	`StateID`			INTEGER,
	`StateInitial`		varchar,
	`StateName`			varchar,
	PRIMARY KEY (`StateID`)
);
-- CREATE INDEXES ...
CREATE INDEX `State_StateID_idx` ON `State` (`StateID`);
CREATE UNIQUE INDEX `State_StateName_idx` ON `State` (`StateName`);

-- TABLE Region
DROP TABLE IF EXISTS `Region`;
CREATE TABLE `Region`
 (
	`RegionID`			INTEGER, 
	`RegionName`		varchar NOT NULL,
	PRIMARY KEY (`RegionID`)
);
-- CREATE INDEXES ...
CREATE INDEX `Region_RegionID_idx` ON `Region` (`RegionID`);
CREATE UNIQUE INDEX `Region_RegionName_idx` ON `Region` (`RegionName`);

-- TABLE City
DROP TABLE IF EXISTS `City`;
CREATE TABLE `City` (
	`CityID`			INTEGER,
	`CityName`			varchar,
	`StateID`			INTEGER,
	`RegionID`			INTEGER DEFAULT 0,
	PRIMARY KEY (`CityID`),
	FOREIGN KEY (`StateID`) REFERENCES `State`(`StateID`) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (`RegionID`) REFERENCES `Region`(`RegionID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `City_CityID_idx` ON `City` (`CityID`);
CREATE UNIQUE INDEX `City_CityName_idx` ON `City` (`CityName`);
CREATE INDEX `City_RegionID_idx` ON `City` (`RegionID`);
CREATE INDEX `City_StateID_idx` ON `City` (`StateID`);

-- TABLE Users 
DROP TABLE IF EXISTS `Users`;
CREATE TABLE `Users` (
	`SID`				varchar NOT NULL,
	`UserName`			varchar NOT NULL,
	`FullName`			varchar NOT NULL,
	`Email`				varchar,
	PRIMARY KEY (`SID`)
);
-- CREATE INDEXES ...
CREATE INDEX `Users_SID_idx` ON `Users` (`SID`);

-- TABLE Jobs
DROP TABLE IF EXISTS `Jobs`;
CREATE TABLE `Jobs`
 (
	`JobID`				INTEGER, 
	`JobName`			varchar, 
	`CityID`			INTEGER, 
	`Addendums`			varchar, 
	`BidAmount`			REAL, 
	`BidDate`			DateTime, 
	`BidTime`			DateTime, 
	`JobWalkDate`		DateTime, 
	`JobWalkTime`		DateTime, 
	`BidStatus`			INTEGER DEFAULT Null, 
	`LeedTracking`		INTEGER NOT NULL DEFAULT FALSE, 
	`Demolition`		INTEGER NOT NULL DEFAULT FALSE, 
	`ACM`				INTEGER NOT NULL DEFAULT FALSE, 
	`Lead`				INTEGER NOT NULL DEFAULT FALSE, 
	`PCB`				INTEGER NOT NULL DEFAULT FALSE, 
	`Mercury`			INTEGER NOT NULL DEFAULT FALSE, 
	`Arsenic`			INTEGER NOT NULL DEFAULT FALSE, 
	`Mold`				INTEGER NOT NULL DEFAULT FALSE, 
	`Soil`				INTEGER NOT NULL DEFAULT FALSE, 
	`CreatedDate`		DateTime DEFAULT CURRENT_TIMESTAMP, 
	`CreatedBy`			varchar,
	PRIMARY KEY (`JobID`),
	FOREIGN KEY (`CityID`) REFERENCES `City`(`CityID`) ON DELETE RESTRICT ON UPDATE CASCADE,
	FOREIGN KEY (`CreatedBy`) REFERENCES `Users`(`SID`) ON DELETE SET NULL ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `Jobs_FKCityID_idx` ON `Jobs` (`CityID`);
CREATE INDEX `Jobs_JobID_idx` ON `Jobs` (`JobID`);
CREATE UNIQUE INDEX `Jobs_JobName_idx` ON `Jobs` (`JobName`);

-- TABLE JobNotes
DROP TABLE IF EXISTS `JobNotes`;
CREATE TABLE `JobNotes`
 (
	`NoteID`			INTEGER, 
	`JobID`				INTEGER DEFAULT 0, 
	`Timestamp`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`User`				varchar NOT NULL, 
	`Note`				TEXT NOT NULL,
	PRIMARY KEY (`NoteID`),
	FOREIGN KEY (`JobID`) REFERENCES `Jobs`(`JobID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `JobNotes_JobID_idx` ON `JobNotes` (`JobID`);

-- TABLE ChangeOrders
DROP TABLE IF EXISTS `ChangeOrders`;
CREATE TABLE `ChangeOrders`
 (
	`COID`				INTEGER, 
	`JobID`				INTEGER DEFAULT 0, 
	`COSeq`				INTEGER DEFAULT 0, 
	`Description`		varchar, 
	`COStatus`			INTEGER DEFAULT 0,
	PRIMARY KEY (`COID`),
	FOREIGN KEY (`JobID`) REFERENCES `Jobs`(`JobID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `ChangeOrders_COID_idx` ON `ChangeOrders` (`COID`);
CREATE INDEX `ChangeOrders_JobID_idx` ON `ChangeOrders` (`JobID`);

-- TABLE Contractors
DROP TABLE IF EXISTS `Contractors`;
CREATE TABLE `Contractors` (
	`ContractorID`		INTEGER,
	`ContractorName`	varchar,
	`Acronym`			varchar,
	`Address1`			varchar,
	`Address2`			varchar,
	`PhoneNumber`		varchar,
	`FaxNumber`			varchar,
	`ZipCode`			varchar,
	`CityID`			INTEGER,
	`BOW`				INTEGER NOT NULL DEFAULT FALSE,
	`DOT`				INTEGER NOT NULL DEFAULT FALSE,
	`HEPSElectrical`	INTEGER NOT NULL DEFAULT FALSE,
	`HEPSMech`			INTEGER NOT NULL DEFAULT FALSE,
	`HPHA`				INTEGER NOT NULL DEFAULT FALSE,
	`MACC`				INTEGER NOT NULL DEFAULT FALSE,
	`Military`			INTEGER NOT NULL DEFAULT FALSE,
	`Private`			INTEGER NOT NULL DEFAULT FALSE,
	`University`		INTEGER NOT NULL DEFAULT FALSE,
	PRIMARY KEY (`ContractorID`),
	FOREIGN KEY (`CityID`) REFERENCES `City`(`CityID`) ON DELETE RESTRICT ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `Contractors_CityID_idx` ON `Contractors` (`CityID`);
CREATE INDEX `Contractors_CompanyID_idx` ON `Contractors` (`ContractorID`);
CREATE UNIQUE INDEX `Contractors_CompanyName_idx` ON `Contractors` (`ContractorName`);

-- TABLE ContractorContacts
DROP TABLE IF EXISTS `ContractorContacts`;
CREATE TABLE `ContractorContacts`
 (
	`ContactID`			INTEGER, 
	`ContractorID`		INTEGER DEFAULT 0, 
	`FirstName`			varchar, 
	`MiddleName`		varchar, 
	`LastName`			varchar, 
	`Extension`			varchar, 
	`Mobile`			varchar, 
	`EmailAddress`		varchar, 
	`SendTo`			INTEGER NOT NULL DEFAULT FALSE,
	PRIMARY KEY (`ContactID`),
	FOREIGN KEY (`ContractorID`) REFERENCES `Contractors`(`ContractorID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `ContractorContacts_ContactCompanyID_idx` ON `ContractorContacts` (`ContractorID`);
CREATE INDEX `ContractorContacts_ContactID_idx` ON `ContractorContacts` (`ContactID`);

-- TABLE ContractorsBidding
DROP TABLE IF EXISTS `ContractorsBidding`;
CREATE TABLE `ContractorsBidding` (
	`JobID`				INTEGER NOT NULL DEFAULT 0,
	`ContractorID`		INTEGER NOT NULL DEFAULT 0,
	`JV`				INTEGER,
	PRIMARY KEY (`JobID`, `ContractorID`)
);
-- CREATE INDEXES ...
CREATE INDEX `ContractorsBidding_CompanyID_idx` ON `ContractorsBidding` (`ContractorID`);
CREATE INDEX `ContractorsBidding_JobID_idx` ON `ContractorsBidding` (`JobID`);
CREATE INDEX `ContractorsBidding_JV_idx` ON `ContractorsBidding` (`JV`);

-- TABLE ContractorGroups
DROP TABLE IF EXISTS `ContractorGroups`;
CREATE TABLE `ContractorGroups`
 (
	`ContractorID`		INTEGER NOT NULL, 
	`GroupID`			INTEGER NOT NULL,
	PRIMARY KEY (`GroupID`, `ContractorID`),
	FOREIGN KEY (`ContractorID`) REFERENCES `Contractors`(`ContractorID`) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (`GroupID`) REFERENCES `BidClass`(`BidClassID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `ContractorGroups_ContractorID_idx` ON `ContractorGroups` (`ContractorID`);
CREATE INDEX `ContractorGroups_GroupID_idx` ON `ContractorGroups` (`GroupID`);

-- TABLE COP
DROP TABLE IF EXISTS `COP`;
CREATE TABLE `COP`
 (
	`COPID`				INTEGER, 
	`JobID`				INTEGER DEFAULT 0, 
	`COPNum`			INTEGER DEFAULT 0, 
	`RFI`				varchar, 
	`Title`				varchar, 
	`Desc`				TEXT,
	PRIMARY KEY (`COPID`),
	FOREIGN KEY (`JobID`) REFERENCES `Jobs`(`JobID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `COP_JobID_idx` ON `COP` (`JobID`);

-- TABLE COPRev
DROP TABLE IF EXISTS `COPRev`;
CREATE TABLE `COPRev`
 (
	`RevID`				INTEGER, 
	`COPID`				INTEGER DEFAULT 0, 
	`Rev`				INTEGER DEFAULT 0, 
	`RevDate`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`Amount`			REAL DEFAULT 0, 
	`Status`			INTEGER NOT NULL,
	PRIMARY KEY (`RevID`),
	FOREIGN KEY (`COPID`) REFERENCES `COP`(`COPID`) ON DELETE CASCADE ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `COPRev_COPID_idx` ON `COPRev` (`COPID`);

-- TABLE COPNotes
DROP TABLE IF EXISTS `COPNotes`;
CREATE TABLE `COPNotes`
 (
	`NoteID`			INTEGER, 
	`CopID`				INTEGER DEFAULT 0, 
	`RevID`				INTEGER DEFAULT 0, 
	`UserSID`			varchar, 
	`Timestamp`			DateTime NOT NULL DEFAULT CURRENT_TIMESTAMP, 
	`Note`				TEXT NOT NULL,
	PRIMARY KEY (`NoteID`),
	FOREIGN KEY (`CopID`) REFERENCES `COP`(`COPID`) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (`RevID`) REFERENCES `COPRev`(`RevID`) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (`UserSID`) REFERENCES `Users`(`SID`) ON DELETE SET NULL ON UPDATE CASCADE
);
-- CREATE INDEXES ...
CREATE INDEX `COPNotes_COP_RevID_idx` ON `COPNotes` (`RevID`);
CREATE INDEX `COPNotes_COP_CopID_idx` ON `COPNotes` (`CopID`);
CREATE INDEX `COPNotes_ID_idx` ON `COPNotes` (`NoteID`);

-- TABLE ChangeOrderHistory
DROP TABLE IF EXISTS `ChangeOrderHistory`;
CREATE TABLE `ChangeOrderHistory`
 (
	`COHistID`		INTEGER, 
	`COID`			INTEGER DEFAULT 0, 
	`COAmount`		REAL DEFAULT 0, 
	`CODate`		DateTime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`COHistID`)
);
-- CREATE INDEXES ...
CREATE INDEX `ChangeOrderHistory_COID_idx` ON `ChangeOrderHistory` (`COID`);
CREATE INDEX `ChangeOrderHistory_CORevID_idx` ON `ChangeOrderHistory` (`COHistID`);

-- vim: ft=sql ts=8 sw=8 sts=8 noet ai sc si
