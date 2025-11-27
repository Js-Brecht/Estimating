/******************************************************************/
/* THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT EDIT IT!!!!!! */
/******************************************************************/
typedef struct _MonthList
{
	long	val;
	char *	title;

} MonthList ;

typedef struct _tblChangeOrderHistory
{
	long	cohistid;
	long	coid;
coamount;
codate;

} tblChangeOrderHistory ;

typedef struct _tblChangeOrders
{
	long	coid;
	long	jobid;
	long	coseq;
	char *	description;
	long	costatus;

} tblChangeOrders ;

typedef struct _tblCity
{
	long	cityid;
	char *	cityname;
	long	stateid;
	long	islandid;

} tblCity ;

typedef struct _tblContractorContacts
{
	long	contactid;
	long	contractorid;
	char *	firstname;
	char *	middlename;
	char *	lastname;
	char *	extension;
	char *	mobile;
	char *	emailaddress;
sendto;

} tblContractorContacts ;

typedef struct _tblContractorGroups
{
	long	contractorid;
	long	groupid;

} tblContractorGroups ;

typedef struct _tblContractorsBidding
{
	long	jobid;
	long	contractorid;
	long	jv;

} tblContractorsBidding ;

typedef struct _tblCOP
{
	long	copid;
	long	jobid;
	long	copnum;
	char *	rfi;
	char *	title;
	char *	desc;

} tblCOP ;

typedef struct _tblCOPNotes
{
	long	noteid;
	long	copid;
	long	revid;
	char *	usersid;
timestamp;
	char *	note;

} tblCOPNotes ;

typedef struct _tblCOPRev
{
	long	revid;
	long	copid;
	long	rev;
revdate;
amount;
	long	status;

} tblCOPRev ;

typedef struct _tblIsland
{
	long	islandid;
	char *	islandname;

} tblIsland ;

typedef struct _tblJobNotes
{
	long	noteid;
	long	jobid;
timestamp;
	char *	user;
	char *	note;

} tblJobNotes ;

typedef struct _tblJobs
{
	long	jobid;
	char *	jobname;
	long	cityid;
	char *	addendums;
bidamount;
biddate;
bidtime;
jobwalkdate;
jobwalktime;
	int	bidstatus;
leedtracking;
demolition;
acm;
lead;
pcb;
mercury;
arsenic;
mold;
soil;
createddate;
	char *	createdby;

} tblJobs ;

typedef struct _tblState
{
	long	stateid;
	char *	stateinitial;
	char *	statename;

} tblState ;

typedef struct _tblUsers
{
	char *	sid;
	char *	username;
	char *	fullname;
	char *	email;

} tblUsers ;

typedef struct _tblBidClass
{
	long	bidclassid;
	char *	bidclassname;
	char *	bidclassdesc;

} tblBidClass ;

typedef struct _tblContractors
{
	long	contractorid;
	char *	contractorname;
	char *	acronym;
	char *	address1;
	char *	address2;
	char *	phonenumber;
	char *	faxnumber;
	char *	zipcode;
	long	cityid;
bow;
dot;
hepselectrical;
hepsmech;
hpha;
macc;
military;
private;
university;

} tblContractors ;

