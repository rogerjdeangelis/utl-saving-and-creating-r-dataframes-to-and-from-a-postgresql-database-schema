%let pgm=utl-saving-and-creating-r-dataframes-to-and-from-a-postgresql-database-schema;

Saving and creating r dataframes to and from a postgresql database schema

You need to install postgreSQL

It looks like R is imbedded in postgresql.
Postgresql can read, write and execute R code;

github
https://tinyurl.com/5n87zmsb
https://github.com/rogerjdeangelis/utl-saving-and-creating-r-dataframes-to-and-from-a-postgresql-database-schema

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

  Process (postgresql reading, manipulating and outputting R dataframes)

     1 create a database 'devel' in postgresql
     2 create a schema 'demographics' in postgresql
     3 create sas dataset sd1.class
     4 convert sas dataset to r dataframe class
     5 save r dataframe as postgresql table class
     6 select males from postgresql table class
     7 create r dataframe  males postgresql table class
     8 convert r dataframe males to sas dataset (uses stattransfer)


/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

libname sd1 "d:/sd1";

options validvarname=any;

data sd1.class;
  set sashelp.class;
run;quit;

/* when mixing three or more R applications lower case simplifies coding */
/* especially running R inside postgresql                                */
proc datasets lib=sd1 nolist;
  modify class;
  rename Sex=sex;
run;
quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* SD1.CLASS total obs=19                                                                                                 */
/*                                                                                                                        */
/*  Obs    NAME       SEX    AGE    HEIGHT    WEIGHT                                                                      */
/*                                                                                                                        */
/*    1    Alfred      M      14     69.0      112.5                                                                      */
/*    2    Alice       F      13     56.5       84.0                                                                      */
/*    3    Barbara     F      13     65.3       98.0                                                                      */
/*    4    Carol       F      14     62.8      102.5                                                                      */
/*    5    Henry       M      14     63.5      102.5                                                                      */
/*    6    James       M      12     57.3       83.0                                                                      */
/*    7    Jane        F      12     59.8       84.5                                                                      */
/*    8    Janet       F      15     62.5      112.5                                                                      */
/*    9    Jeffrey     M      13     62.5       84.0                                                                      */
/*   10    John        M      12     59.0       99.5                                                                      */
/*   11    Joyce       F      11     51.3       50.5                                                                      */
/*   12    Judy        F      14     64.3       90.0                                                                      */
/*   13    Louise      F      12     56.3       77.0                                                                      */
/*   14    Mary        F      15     66.5      112.0                                                                      */
/*   15    Philip      M      16     72.0      150.0                                                                      */
/*   16    Robert      M      12     64.8      128.0                                                                      */
/*   17    Ronald      M      15     67.0      133.0                                                                      */
/*   18    Thomas      M      11     57.5       85.0                                                                      */
/*   19    William     M      15     66.5      112.0                                                                      */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*               _                            _
 _ __   ___  ___| |_ __ _ _ __ ___  ___  __ _| |
| `_ \ / _ \/ __| __/ _` | `__/ _ \/ __|/ _` | |
| |_) | (_) \__ \ || (_| | | |  __/\__ \ (_| | |
| .__/ \___/|___/\__\__, |_|  \___||___/\__, |_|
|_|                 |___/                  |_|
                     _             _ _           _                _
  ___ _ __ ___  __ _| |_ ___    __| | |__     __| | _____   _____| |
 / __| `__/ _ \/ _` | __/ _ \  / _` | `_ \   / _` |/ _ \ \ / / _ \ |
| (__| | |  __/ (_| | ||  __/ | (_| | |_) | | (_| |  __/\ V /  __/ |
 \___|_|  \___|\__,_|\__\___|  \__,_|_.__/   \__,_|\___| \_/ \___|_|

*/

%utl_rbeginx;
parmcards4;
# Load the necessary libraries
library(RPostgres)
library(DBI)
library(haven)
a<-read_sas("d:/sd1/a.sas7bdat")
con <- dbConnect(RPostgres::Postgres(),
            dbname = "postgres",  # Use the default 'postgres' database
            host = "localhost",   # Replace with your PostgreSQL server address if not local
            port = 5432,          # Default PostgreSQL port
            user = "postgres",
            password = "12345678")
dbExecute(con, "CREATE DATABASE devel")
dbDisconnect(con)
;;;;
%utl_rendx;

/*                   _                  _                                _                                            _     _
  ___ _ __ ___  __ _| |_ ___   ___  ___| |__   ___ _ __ ___   __ _    __| | ___ _ __ ___   ___   __ _ _ __ __ _ _ __ | |__ (_) ___ ___
 / __| `__/ _ \/ _` | __/ _ \ / __|/ __| `_ \ / _ \ `_ ` _ \ / _` |  / _` |/ _ \ `_ ` _ \ / _ \ / _` | `__/ _` | `_ \| `_ \| |/ __/ __|
| (__| | |  __/ (_| | ||  __/ \__ \ (__| | | |  __/ | | | | | (_| | | (_| |  __/ | | | | | (_) | (_| | | | (_| | |_) | | | | | (__\__ \
 \___|_|  \___|\__,_|\__\___| |___/\___|_| |_|\___|_| |_| |_|\__,_|  \__,_|\___|_| |_| |_|\___/ \__, |_|  \__,_| .__/|_| |_|_|\___|___/
                                                                                                |___/          |_|
*/

%utl_rbeginx;
parmcards4;
# Load the necessary libraries
library(RPostgres)
library(DBI)
library(haven)
a<-read_sas("d:/sd1/a.sas7bdat")
con <- dbConnect(RPostgres::Postgres(),
            dbname = "devel",
            host = "localhost",
            port = 5432,
            user = "postgres",
            password = "12345678")
dbExecute(con, "CREATE SCHEMA demographics")
dbDisconnect(con)
;;;;
%utl_rendx;

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

%utl_rbeginx;
parmcards4;
# Load the necessary libraries
library(RPostgres)
library(DBI)
library(haven)
source("c:/oto/fn_tosas9x.R");
class<-read_sas("d:/sd1/class.sas7bdat")
con <- dbConnect(RPostgres::Postgres(),
            dbname = "devel",  # Use the default 'postgres' database
            host = "localhost",   # Replace with your PostgreSQL server address if not local
            port = 5432,          # Default PostgreSQL port
            user = "postgres",
            password = "12345678")
dbExecute(con, "SET search_path TO demographics")
dbWriteTable(con, "class", class, row.names = FALSE, overwrite = TRUE)
result <- dbGetQuery(con, paste("SELECT * FROM", "class", "LIMIT 5"))
print(result)
query <- "
  SELECT *
  FROM class
  where sex = 'M'
"
df <- dbGetQuery(con, query)
dbListObjects(con, Id(schema = 'demographics'))
dbDisconnect(con)
df;
fn_tosas9x(
      inp    = df
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     );
');
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* R/postgreSQL                                                                                                           */
/* ============                                                                                                           */
/*                                                                                                                        */
/* > df;                                                                                                                  */
/*       Name sex Age Height Weight                                                                                       */
/* 1   Alfred   M  14   69.0  112.5                                                                                       */
/* 2    Henry   M  14   63.5  102.5                                                                                       */
/* 3    James   M  12   57.3   83.0                                                                                       */
/* 4  Jeffrey   M  13   62.5   84.0                                                                                       */
/* 5     John   M  12   59.0   99.5                                                                                       */
/* 6   Philip   M  16   72.0  150.0                                                                                       */
/* 7   Robert   M  12   64.8  128.0                                                                                       */
/* 8   Ronald   M  15   67.0  133.0                                                                                       */
/* 9   Thomas   M  11   57.5   85.0                                                                                       */
/* 10 William   M  15   66.5  112.0                                                                                       */
/*                                                                                                                        */
/* SAS                                                                                                                    */
/* ===                                                                                                                    */
/*                                                                                                                        */
/* Obs    rownames    Name       sex    Age    Height    Weight                                                           */
/*                                                                                                                        */
/*   1        1       Alfred      M      14     69.0      112.5                                                           */
/*   2        2       Henry       M      14     63.5      102.5                                                           */
/*   3        3       James       M      12     57.3       83.0                                                           */
/*   4        4       Jeffrey     M      13     62.5       84.0                                                           */
/*   5        5       John        M      12     59.0       99.5                                                           */
/*   6        6       Philip      M      16     72.0      150.0                                                           */
/*   7        7       Robert      M      12     64.8      128.0                                                           */
/*   8        8       Ronald      M      15     67.0      133.0                                                           */
/*   9        9       Thomas      M      11     57.5       85.0                                                           */
/*  10       10       William     M      15     66.5      112.0                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
