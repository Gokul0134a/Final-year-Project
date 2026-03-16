/* Generated Code (IMPORT) */
/* Source File: Follow up data.xlsx */
/* Source Path: /home/u63985153/Train */
/* Code generated on: 3/3/26, 10:17 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/home/u63985153/Train/Follow up data.xlsx';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLSX
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);

proc lifetest data=WORK.IMPORT plots=survival;
   time time*status(0);
   strata sex;
run;

data WORK.IMPORT;
    set WORK.IMPORT;

    /* Convert numeric YYYYMMDD to SAS date */
    start_date = input(put(DFD,8.), yymmdd8.);
    format start_date date9.;
run;

proc means data=WORK.IMPORT min;
    var start_date;
run;
proc sql;
    select min(start_date) format=date9. as Dataset_Start_Date
    from WORK.IMPORT;
quit;

data WORK.IMPORT;
    set WORK.IMPORT;

    /* Convert years to days */
    followup_days = Time * 365.25;

    /* Calculate end date */
    end_date = start_date + followup_days;

    format end_date date9.;
run;

proc means data=WORK.IMPORT median mean min max;
   var followup_days;
run;

proc lifetest data=WORK.IMPORT plots=survival;
   time followup_days*Status(0);
run;

proc lifetest data=WORK.IMPORT plots=survival;
   time followup_days*Status(0);
   strata Sex;
run;



proc phreg data=WORK.IMPORT;
   model followup_days*Status(0) = Sex Age / ties=efron;
   assess ph / resample;
run;