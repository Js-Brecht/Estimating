/******************************************************************/
/* THIS IS AN AUTOMATICALLY GENERATED FILE.  DO NOT EDIT IT!!!!!! */
/******************************************************************/
#include <stdio.h>
#include "dumptypes.h"
void dump_MonthList (MonthList x)
{
	fprintf (stdout, "**************** MonthList ****************\n");
	fprintf (stdout, "x.val = ");
	dump_long (x.val);
	fprintf (stdout, "x.title = ");
	dump_string (x.title);
}

void dump_tblChangeOrderHistory (tblChangeOrderHistory x)
{
	fprintf (stdout, "**************** tblChangeOrderHistory ****************\n");
	fprintf (stdout, "x.cohistid = ");
	dump_long (x.cohistid);
	fprintf (stdout, "x.coid = ");
	dump_long (x.coid);
	fprintf (stdout, "x.coamount = ");
coamount);
	fprintf (stdout, "x.codate = ");
codate);
}

void dump_tblChangeOrders (tblChangeOrders x)
{
	fprintf (stdout, "**************** tblChangeOrders ****************\n");
	fprintf (stdout, "x.coid = ");
	dump_long (x.coid);
	fprintf (stdout, "x.jobid = ");
	dump_long (x.jobid);
	fprintf (stdout, "x.coseq = ");
	dump_long (x.coseq);
	fprintf (stdout, "x.description = ");
	dump_string (x.description);
	fprintf (stdout, "x.costatus = ");
	dump_long (x.costatus);
}

void dump_tblCity (tblCity x)
{
	fprintf (stdout, "**************** tblCity ****************\n");
	fprintf (stdout, "x.cityid = ");
	dump_long (x.cityid);
	fprintf (stdout, "x.cityname = ");
	dump_string (x.cityname);
	fprintf (stdout, "x.stateid = ");
	dump_long (x.stateid);
	fprintf (stdout, "x.islandid = ");
	dump_long (x.islandid);
}

void dump_tblContractorContacts (tblContractorContacts x)
{
	fprintf (stdout, "**************** tblContractorContacts ****************\n");
	fprintf (stdout, "x.contactid = ");
	dump_long (x.contactid);
	fprintf (stdout, "x.contractorid = ");
	dump_long (x.contractorid);
	fprintf (stdout, "x.firstname = ");
	dump_string (x.firstname);
	fprintf (stdout, "x.middlename = ");
	dump_string (x.middlename);
	fprintf (stdout, "x.lastname = ");
	dump_string (x.lastname);
	fprintf (stdout, "x.extension = ");
	dump_string (x.extension);
	fprintf (stdout, "x.mobile = ");
	dump_string (x.mobile);
	fprintf (stdout, "x.emailaddress = ");
	dump_string (x.emailaddress);
	fprintf (stdout, "x.sendto = ");
sendto);
}

void dump_tblContractorGroups (tblContractorGroups x)
{
	fprintf (stdout, "**************** tblContractorGroups ****************\n");
	fprintf (stdout, "x.contractorid = ");
	dump_long (x.contractorid);
	fprintf (stdout, "x.groupid = ");
	dump_long (x.groupid);
}

void dump_tblContractorsBidding (tblContractorsBidding x)
{
	fprintf (stdout, "**************** tblContractorsBidding ****************\n");
	fprintf (stdout, "x.jobid = ");
	dump_long (x.jobid);
	fprintf (stdout, "x.contractorid = ");
	dump_long (x.contractorid);
	fprintf (stdout, "x.jv = ");
	dump_long (x.jv);
}

void dump_tblCOP (tblCOP x)
{
	fprintf (stdout, "**************** tblCOP ****************\n");
	fprintf (stdout, "x.copid = ");
	dump_long (x.copid);
	fprintf (stdout, "x.jobid = ");
	dump_long (x.jobid);
	fprintf (stdout, "x.copnum = ");
	dump_long (x.copnum);
	fprintf (stdout, "x.rfi = ");
	dump_string (x.rfi);
	fprintf (stdout, "x.title = ");
	dump_string (x.title);
	fprintf (stdout, "x.desc = ");
	dump_string (x.desc);
}

void dump_tblCOPNotes (tblCOPNotes x)
{
	fprintf (stdout, "**************** tblCOPNotes ****************\n");
	fprintf (stdout, "x.noteid = ");
	dump_long (x.noteid);
	fprintf (stdout, "x.copid = ");
	dump_long (x.copid);
	fprintf (stdout, "x.revid = ");
	dump_long (x.revid);
	fprintf (stdout, "x.usersid = ");
	dump_string (x.usersid);
	fprintf (stdout, "x.timestamp = ");
timestamp);
	fprintf (stdout, "x.note = ");
	dump_string (x.note);
}

void dump_tblCOPRev (tblCOPRev x)
{
	fprintf (stdout, "**************** tblCOPRev ****************\n");
	fprintf (stdout, "x.revid = ");
	dump_long (x.revid);
	fprintf (stdout, "x.copid = ");
	dump_long (x.copid);
	fprintf (stdout, "x.rev = ");
	dump_long (x.rev);
	fprintf (stdout, "x.revdate = ");
revdate);
	fprintf (stdout, "x.amount = ");
amount);
	fprintf (stdout, "x.status = ");
	dump_long (x.status);
}

void dump_tblIsland (tblIsland x)
{
	fprintf (stdout, "**************** tblIsland ****************\n");
	fprintf (stdout, "x.islandid = ");
	dump_long (x.islandid);
	fprintf (stdout, "x.islandname = ");
	dump_string (x.islandname);
}

void dump_tblJobNotes (tblJobNotes x)
{
	fprintf (stdout, "**************** tblJobNotes ****************\n");
	fprintf (stdout, "x.noteid = ");
	dump_long (x.noteid);
	fprintf (stdout, "x.jobid = ");
	dump_long (x.jobid);
	fprintf (stdout, "x.timestamp = ");
timestamp);
	fprintf (stdout, "x.user = ");
	dump_string (x.user);
	fprintf (stdout, "x.note = ");
	dump_string (x.note);
}

void dump_tblJobs (tblJobs x)
{
	fprintf (stdout, "**************** tblJobs ****************\n");
	fprintf (stdout, "x.jobid = ");
	dump_long (x.jobid);
	fprintf (stdout, "x.jobname = ");
	dump_string (x.jobname);
	fprintf (stdout, "x.cityid = ");
	dump_long (x.cityid);
	fprintf (stdout, "x.addendums = ");
	dump_string (x.addendums);
	fprintf (stdout, "x.bidamount = ");
bidamount);
	fprintf (stdout, "x.biddate = ");
biddate);
	fprintf (stdout, "x.bidtime = ");
bidtime);
	fprintf (stdout, "x.jobwalkdate = ");
jobwalkdate);
	fprintf (stdout, "x.jobwalktime = ");
jobwalktime);
	fprintf (stdout, "x.bidstatus = ");
	dump_int (x.bidstatus);
	fprintf (stdout, "x.leedtracking = ");
leedtracking);
	fprintf (stdout, "x.demolition = ");
demolition);
	fprintf (stdout, "x.acm = ");
acm);
	fprintf (stdout, "x.lead = ");
lead);
	fprintf (stdout, "x.pcb = ");
pcb);
	fprintf (stdout, "x.mercury = ");
mercury);
	fprintf (stdout, "x.arsenic = ");
arsenic);
	fprintf (stdout, "x.mold = ");
mold);
	fprintf (stdout, "x.soil = ");
soil);
	fprintf (stdout, "x.createddate = ");
createddate);
	fprintf (stdout, "x.createdby = ");
	dump_string (x.createdby);
}

void dump_tblState (tblState x)
{
	fprintf (stdout, "**************** tblState ****************\n");
	fprintf (stdout, "x.stateid = ");
	dump_long (x.stateid);
	fprintf (stdout, "x.stateinitial = ");
	dump_string (x.stateinitial);
	fprintf (stdout, "x.statename = ");
	dump_string (x.statename);
}

void dump_tblUsers (tblUsers x)
{
	fprintf (stdout, "**************** tblUsers ****************\n");
	fprintf (stdout, "x.sid = ");
	dump_string (x.sid);
	fprintf (stdout, "x.username = ");
	dump_string (x.username);
	fprintf (stdout, "x.fullname = ");
	dump_string (x.fullname);
	fprintf (stdout, "x.email = ");
	dump_string (x.email);
}

void dump_tblBidClass (tblBidClass x)
{
	fprintf (stdout, "**************** tblBidClass ****************\n");
	fprintf (stdout, "x.bidclassid = ");
	dump_long (x.bidclassid);
	fprintf (stdout, "x.bidclassname = ");
	dump_string (x.bidclassname);
	fprintf (stdout, "x.bidclassdesc = ");
	dump_string (x.bidclassdesc);
}

void dump_tblContractors (tblContractors x)
{
	fprintf (stdout, "**************** tblContractors ****************\n");
	fprintf (stdout, "x.contractorid = ");
	dump_long (x.contractorid);
	fprintf (stdout, "x.contractorname = ");
	dump_string (x.contractorname);
	fprintf (stdout, "x.acronym = ");
	dump_string (x.acronym);
	fprintf (stdout, "x.address1 = ");
	dump_string (x.address1);
	fprintf (stdout, "x.address2 = ");
	dump_string (x.address2);
	fprintf (stdout, "x.phonenumber = ");
	dump_string (x.phonenumber);
	fprintf (stdout, "x.faxnumber = ");
	dump_string (x.faxnumber);
	fprintf (stdout, "x.zipcode = ");
	dump_string (x.zipcode);
	fprintf (stdout, "x.cityid = ");
	dump_long (x.cityid);
	fprintf (stdout, "x.bow = ");
bow);
	fprintf (stdout, "x.dot = ");
dot);
	fprintf (stdout, "x.hepselectrical = ");
hepselectrical);
	fprintf (stdout, "x.hepsmech = ");
hepsmech);
	fprintf (stdout, "x.hpha = ");
hpha);
	fprintf (stdout, "x.macc = ");
macc);
	fprintf (stdout, "x.military = ");
military);
	fprintf (stdout, "x.private = ");
private);
	fprintf (stdout, "x.university = ");
university);
}

