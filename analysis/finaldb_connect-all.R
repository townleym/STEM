# Now make a dataset for analysis

# Note, this gets only persons in the labor force and with a BA (no advanced degrees!)
# Descriptives will probably require a wider net, so adjust accordingly

# rm(list=ls())
setwd('~/Documents/Geog/MigProject/STEM/analysis')

require(RSQLite)

sqlite = dbDriver("SQLite")
dbpath = "~/Documents/Geog/MigProject/data/sql/acs2011.sqlite"

conn = dbConnect(sqlite, dbpath)

query = "SELECT    
        acs.uid,
		acs.region,
		acs.metaread,
		acs.state_curr,
		acs.state_prev,
		acs.county,
		acs.perwt,
		acs.age,
		acs.sex,
		acs.citizen,
		acs.fb,
		acs.bpl,
		acs.yrsusa1,
		acs.yrsusa2,
		acs.educ,
		acs.degfield,
		acs.degfieldd,
		acs.empstat,
		acs.occsoc,
		acs.poverty,
		acs.inctot,
		acs.migrate1,
		acs.vetstat,
		acs.ed,
		acs.ethrace,
		acs.geog_prev,
		acs.geog_curr,
		acs.geog2_prev,
		acs.geog2_curr,
		acs.state_prev2,
		acs.movedstate,
		acs.movedmetro,
		acs.classwkr,
		acs.workedyr,
        acs.stemdeg,
		codematch.ipums_code,
		codematch.stem as stemjob,
		codematch.stem_domain,
		codematch.stem1,
		codematch.stem4,
		degreclass.degreclass as degreclass,
		reclasscodes.reclasslabel as reclasslabel,
        citymapper.code,
        citymapper.geogname
	from acs 
	LEFT JOIN codematch ON acs.occsoc = codematch.ipums_code
	LEFT JOIN degreclass ON acs.degfield = degreclass.degfield
	LEFT JOIN reclasscodes ON degreclass.degreclass = reclasscodes.reclasscode
	LEFT JOIN citymapper on acs.geog_curr = citymapper.code
	where 
		acs.civ_hh = 1
        AND	(acs.gq != 3 and acs.gq !=4) 
        AND citymapper.pop2010 > 1000000
		AND acs.geog_curr > 0
        AND (acs.empstat = 1 or acs.empstat = 2)
        AND (acs.age >=25 and acs.age <=65);"


# Restrict these to get people in Labor Force
# (stemdata.empstat < 3) and
# Restrict these to eliminate people who might identify as in the labor force but with no occupation given
# (stemdata.occsoc <> '000000') and

#         AND acs.ethrace < 4
#         AND acs.ed = 4;"

########################################################
start.time  =  proc.time()

q.obj = dbSendQuery(conn, query)

# Retrieve Query results into a data frame
acs = fetch(q.obj, n=-1)

print(paste("time in minutes: ", round(proc.time()[3] - start.time[3], 3) / 60, sep=""))
########################################################

# Clean up the query object (no longer needed)
dbClearResult(q.obj)


########################################################
# Now do it again for the citymapper data
########################################################

query = "SELECT * from citymapper;"

########################################################
start.time  =  proc.time()

q.obj = dbSendQuery(conn, query)

# Retrieve Query results into a data frame
citymapper = fetch(q.obj, n=-1)

print(paste("time in minutes: ", round(proc.time()[3] - start.time[3], 3) / 60, sep=""))
########################################################

# Clean up the query object (no longer needed)
dbClearResult(q.obj)



