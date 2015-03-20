## Really, for real this time

## ----, echo=FALSE, eval = T, collapse = T, results='hide'----------------
setwd('~/Documents/Geog/MigProject/STEM/res')
# source('finaldb_connect-all.R', echo = F)
source('~/Documents/rfuns/plotfuns.R')

require(magrittr)
require(knitr)
# From here until about line 75 is a bunch of data conditioning, prep
###############################################################################

# Calculate the stem job lq as for all STEM workers in the 55 cities
# so, I'm doing the LQ/proportion with the whole population (i.e. + non degree holders)

# Calculate some different denominators 
require(RSQLite)

sqlite = dbDriver("SQLite")
dbpath = "~/Documents/Geog/MigProject/data/sql/acs2011.sqlite"
conn = dbConnect(sqlite, dbpath)

query = "select 
        acs.perwt,        
        acs.stemdeg,
        acs.geog_curr,
        acs.ethrace,
        acs.ed,
        acs.degfield,
        acs.inctot,
        codematch.ipums_code,
    	codematch.stem as stemjob,
		codematch.stem_domain,
		codematch.stem1,
		codematch.stem4,
		degreclass.degreclass as degreclass,
    degreclass.deglabel as deglabel,
		reclasscodes.reclasslabel as reclasslabel,
        citymapper.code,
        citymapper.geogname,
        citymapper.pop2010
	from acs 
	LEFT JOIN codematch ON acs.occsoc = codematch.ipums_code
	LEFT JOIN degreclass ON acs.degfield = degreclass.degfield
	LEFT JOIN reclasscodes ON degreclass.degreclass = reclasscodes.reclasscode
	LEFT JOIN citymapper on acs.geog_curr = citymapper.code
	where 
		acs.civ_hh = 1
        AND	(acs.gq != 3 and acs.gq !=4) 
        AND (acs.empstat = 1 or acs.empstat = 2)
        AND (acs.age >=25 and acs.age <=65);"


q.obj = dbSendQuery(conn, query)
a = fetch(q.obj, n=-1)
dbClearResult(q.obj)

sumXdomain.nat = a %>% with(tapply(perwt, list(stem_domain), sum))
sumXdomain.allcities = a[a$geog_curr > 0,] %>% with(tapply(perwt, list(stem_domain), sum))
sumXdomain.bigcities = a[a$geog_curr > 0 & a$pop2010 > 1e6,] %>% with(tapply(perwt, list(stem_domain), sum))

counts = rbind(sumXdomain.nat, sumXdomain.allcities, sumXdomain.bigcities)
cbind(counts, apply(counts, 1, sum))

propXdomain.nat = sumXdomain.nat / sum(sumXdomain.nat)
propXdomain.allcities = sumXdomain.allcities / sum(sumXdomain.allcities)
propXdomain.bigcities = sumXdomain.bigcities/ sum(sumXdomain.bigcities)

rbind(propXdomain.nat, propXdomain.allcities, propXdomain.bigcities) %>% round(3)

count.geogXdomain = a[a$geog_curr > 0 & a$pop2010 > 1e6,] %>% with(tapply(perwt, list(geogname, stem_domain), sum)) 
prop.geogXdomain = apply(count.geogXdomain, 1, sum) %>% sweep(count.geogXdomain, 1, ., "/")
apply(prop.geogXdomain, 1, sum)

# LQ with the national proportion (of course)
lq.geogXdomain = sweep(prop.geogXdomain, 2, propXdomain.nat, "/")
lq.geogXdomain %>% kable(digits = 3)


apply(prop.geogXdomain, 2, sd) # right, bitten by the mean/variance relationship
apply(lq.geogXdomain, 2, sd)

### <><><><><><> ###

stem1 = data.frame(lq = lq.geogXdomain[,"1"], count = count.geogXdomain[,"1"])
stem1 = data.frame(count = count.geogXdomain[,"1"], prop = prop.geogXdomain[,"1"], lq = lq.geogXdomain[,"1"])
stem1 = stem1[order(stem1$count, decreasing = F),]
citynames = rownames(stem1)

## Use the nicename() function to make the names... um, nicer
source('~/Documents/rfuns/nicenames.R')
nicenames = sapply(citynames, nicename)
cbind(sort(nicenames))
## It's not very smart...
nicenames[grep("Winston", names(nicenames))] = "Winston-Salem, NC"
nicenames[grep("Dallas", names(nicenames))] = "Dallas-Ft. Worth, TX"
nicenames[grep("Minneapolis", names(nicenames))] = "Minneapolis-St. Paul, MN"
nicenames[grep("Seattle", names(nicenames))] = "Seattle-Tacoma, WA"
nicenames[grep("Tampa", names(nicenames))] = "Tampa-St. Petersburg, FL"
names(nicenames) = NULL
nicenames[55] = "New York, NY"

png(file = "../results/figs/stem1jobmarket.png", height = 800, width = 600, units = "px", res = 100, type = "cairo", bg = "transparent")

dotchart.ann(vals = stem1[,"count"], annot = round(stem1[,"lq"], 2), 
             titletext = "STEM 1 Employment",
             x.lab = "Total Jobs (count)",
             y.lab = nicenames,
             annot.lab = "LQ",
             mnote = "(1 dot = 10,000)")

dev.off()

cor(stem1[,"count"], stem1[,"lq"])
quickscatter(stem1[,"count"], stem1[,"lq"])
quickscatter(stem1[,"lq"], stem1[,"count"], line = "straight")
quickscatter(stem1[,"lq"], stem1[,"count"], line = "lowess")

stem1[order(stem1$lq),]
pdesc(data.frame(prop.geogXdomain))

### <><><><><><> ###

# STEM 1 descriptives
stem1 = data.frame(count = count.geogXdomain[,"1"], prop = prop.geogXdomain[,"1"], lq = lq.geogXdomain[,"1"])
ta = pdesc(stem1)
kable(ta[,1:7], format = "pandoc")

# Highest STEM 1 LQs
stem1lq = lq.geogXdomain

nicenames = sapply(rownames(stem1lq), nicename)
cbind(sort(nicenames))
## It's not very smart...
nicenames[grep("Winston", names(nicenames))] = "Winston-Salem, NC"
nicenames[grep("Dallas", names(nicenames))] = "Dallas-Ft. Worth, TX"
nicenames[grep("Minneapolis", names(nicenames))] = "Minneapolis-St. Paul, MN"
nicenames[grep("Seattle", names(nicenames))] = "Seattle-Tacoma, WA"
nicenames[grep("Tampa", names(nicenames))] = "Tampa-St. Petersburg, FL"
names(nicenames) = NULL
nicenames[31] = "New York, NY"

rownames(stem1lq) = nicenames

stem1lq = stem1lq[order(stem1lq[,"1"], decreasing = T),]
cbind(lq = stem1lq[1:5,"1"]) %>% kable(digits = 2, format = "pandoc")

###############################################################################
# STEM Degrees

head(a)
with(a, table(reclasslabel, stemdeg))
bydeg = with(a[a$ed == 4 & a$stemdeg == 1,], tapply(perwt, list(deglabel, stemdeg), sum))
propbydeg = bydeg / sum(bydeg)
propbydegframe = data.frame(row.names = 1:34, label = rownames(propbydeg), proportion = propbydeg)
propbydegframe[order(propbydegframe$X1, decreasing = T),]
propbydegframe[order(propbydegframe$X1, decreasing = T),][1:7,]
propbydegframe[order(propbydegframe$X1, decreasing = T),][c(1:6,8),] %>% kable(digits = 3, format = "pandoc", row.names = F)

bydegfield = with(a[a$ed == 4 & a$stemdeg == 1,], tapply(perwt, list(degfield, stemdeg), sum))
propta = bydegfield / sum(bydegfield)
proptafield = data.frame(row.names = 1:34, label = rownames(propta), proportion = propta)
proptafield[order(proptafield$X1, decreasing = T),][c(1:6,8),] %>% kable(digits = 3, format = "pandoc", row.names = F)

ta1 = propbydegframe[order(propbydegframe$X1, decreasing = T),][c(1:6,8),]
ta2 = proptafield[order(proptafield$X1, decreasing = T),][c(1:6,8),] 
cbind(degfield = ta2[,"label"], ta1) %>% kable(digits = 3, format = "pandoc", row.names = F)

# clean up!
rm(list = c("ta1", "ta2", "propta", "proptafield", "bydegfield"))

a = transform(a, stemdeg2 = stemdeg + 1)
a[a$degfield == 0,"stemdeg2"] = 0
with(a, tapply(perwt, list(stemdeg2, stem_domain), sum)) %>% prop.table
with(a, tapply(perwt, list(stemdeg2, stem_domain), sum)) %>% prop.table %>% kable(digits = 3, format = "pandoc")

## degree holder count
# National
with(a, tapply(perwt, list(cut(ed, breaks = c(0,3,6))), sum)) 
with(a, tapply(perwt, list(cut(ed, breaks = c(0,3,6))), sum)) / sum(with(a, tapply(perwt, list(cut(ed, breaks = c(0,3,6))), sum)) ) 

a[a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum))
a[a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) %>% sum

# proportion
a[a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) / (a[a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) %>% sum)

# proportion with a graduate degree
# a[a$ed > 3,] %>% with(tapply(perwt, list(ed), sum)) / sum(a[a$ed > 3,] %>% with(tapply(perwt, list(ed), sum)))

# Big cities
a[a$geog_curr > 0 & a$pop2010 > 1e6,] %>% with(tapply(perwt, list(cut(ed, breaks = c(0,3,6))), sum)) / sum(a[a$geog_curr > 0 & a$pop2010 > 1e6,] %>% with(tapply(perwt, list(cut(ed, breaks = c(0,3,6))), sum)))

a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum))
a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) %>% sum

# proportion
a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) / ( a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,] %>% with(tapply(perwt, list(stemdeg2), sum)) %>% sum)

# I don't know what this is 
sumXdomain.nat = a %>% with(tapply(perwt, list(stemdeg2), sum))
sumXdomain.allcities = a[a$geog_curr > 0,] %>% with(tapply(perwt, list(stemdeg2), sum))
sumXdomain.bigcities = a[a$geog_curr > 0 & a$pop2010 > 1e6,] %>% with(tapply(perwt, list(stemdeg2), sum))

counts = rbind(sumXdomain.nat, sumXdomain.allcities, sumXdomain.bigcities)
cbind(counts, apply(counts, 1, sum))

propXdomain.nat = sumXdomain.nat / sum(sumXdomain.nat)
propXdomain.allcities = sumXdomain.allcities / sum(sumXdomain.allcities)
propXdomain.bigcities = sumXdomain.bigcities/ sum(sumXdomain.bigcities)

rbind(propXdomain.nat, propXdomain.allcities, propXdomain.bigcities) %>% round(3)

deg.all = a[a$stemdeg2 > 0,]
deg.natXcount = with(deg.all, tapply(perwt, stemdeg2, sum))
deg.natXprop = deg.natXcount / sum(deg.natXcount)

deg = a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,]

deg.cityXcount = with(deg, tapply(perwt, list(geogname, stemdeg2), sum))
deg.cityXprop = apply(deg.cityXcount, 1, sum) %>% sweep(deg.cityXcount, 1, ., "/")
deg.cityXlq = sweep(deg.cityXprop, 2, deg.natXprop, "/")

## Just BA holders
ba.all = a[a$ed == 4,]
ba = a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$ed == 4,]

ba.natXcount = with(ba.all, tapply(perwt, stemdeg2, sum))
ba.natXprop = ba.natXcount / sum(ba.natXcount)

ba = a[a$geog_curr > 0 & a$pop2010 > 1e6 & a$stemdeg2 > 0,]

ba.cityXcount = with(ba, tapply(perwt, list(geogname, stemdeg2), sum))
ba.cityXprop = apply(ba.cityXcount, 1, sum) %>% sweep(ba.cityXcount, 1, ., "/")
ba.cityXlq = sweep(ba.cityXprop, 2, ba.natXprop, "/")

ta = data.frame(count = ba.cityXcount[,"2"], proportion = ba.cityXprop[,"2"], lq = ba.cityXlq[,"2"]) 
options(scipen = 5)
pdesc(ta)[,1:7] %>% kable(digits = 3, format = "pandoc")


lq.geogXdomain %>% kable(digits = 3)
ba.cityXlq %>% kable(digits = 3) 

tt.jobs = lq.geogXdomain[order(lq.geogXdomain[,"1"], decreasing = T),"1"][1:10]
tt.deg = ba.cityXlq[order(ba.cityXlq[,"2"], decreasing = T), "2"][1:10] 
data.frame(city = names(tt.jobs), lqstem1 = tt.jobs, city = names(tt.deg), lqdeg = tt.deg, row.names = 1:1)
data.frame(city = names(tt.jobs), lqstem1 = tt.jobs, city = names(tt.deg), lqdeg = tt.deg, row.names = 1:1) %>% kable(digits = 2, format = "pandoc")

# plot jobs ~ degrees
STEMDegLQ = ba.cityXlq[,"2"] 
STEMJobLQ = lq.geogXdomain[,"1"] 
quickscatter(predictor = STEMJobLQ, outcome =  STEMDegLQ)

png(file = "../results/figs/degreesvsjobs.png")
quickscatter(predictor = STEMJobLQ, outcome =  STEMDegLQ)
title(main = "STEM degrees as a function of STEM jobs")
dev.off()

### <><><><><><><><><><> ###
### Proportion by degree/domain
degXdomain.count = with(a, tapply(perwt, list(stemdeg2, stem_domain), sum))
degXdomain.count / sum(degXdomain.count)

### Income by degree/domain
head(a)
a = transform(a, wtdinc = inctot * perwt)
degXdomain.totinc = with(a, tapply(wtdinc, list(stemdeg2, stem_domain), function(x) {sum(as.numeric(x))}))

(degXdomain.totinc / degXdomain.count) %>% kable(digits = 0, format="pandoc")