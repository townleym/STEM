## ----, echo=FALSE, eval = T, collapse = T, results='hide'----------------
setwd('~/Documents/Geog/MigProject/STEM/analysis')
source('finaldb_connect-all.R', echo = F)
source('~/Documents/diss/tools/plotfuns.R')

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
        AND (acs.empstat = 1 or acs.empstat = 2)
        AND (acs.age >=25 and acs.age <=65);"


q.obj = dbSendQuery(conn, query)
a = fetch(q.obj, n=-1)
dbClearResult(q.obj)

#### Some different denominators
sumXdomain.nat = a %>% with(tapply(perwt, list(stem_domain), sum))
sumXdomain.allcities = a[a$geog_curr > 0,] %>% with(tapply(perwt, list(stem_domain), sum))
sumXdomain.bigcities = acs %>% with(tapply(perwt, list(stem_domain), sum))

counts = rbind(sumXdomain.nat, sumXdomain.allcities, sumXdomain.bigcities) %>% data.frame 
colnames(counts) = c("STEM 0", "STEM 1", "STEM 2", "STEM 3", "STEM 4")
proportions = apply(counts, 1, sum) %>% sweep(counts, 1, ., "/")

# national count of stem degree holders
sumXstemdeg.nat = a[a$ed >=4,] %>% with(tapply(perwt, list(stemdeg), sum))

# clean up
rm("a")

####
# Now LQs 3 different ways
stemjobcounts = with(acs, tapply(perwt, list(geog_curr, stem_domain), sum)) %>% data.frame
stemjobprops = apply(stemjobcounts, 1, sum) %>% sweep(stemjobcounts, 1, ., "/")
hist(stemjobprops$X1)


# Well, that's good to know. Use as.matrix()
lq.nats = as.matrix(proportions["sumXdomain.nat",]) %>% sweep(as.matrix(stemjobprops), 2, ., "/")
lq.allcities = as.matrix(proportions["sumXdomain.allcities",]) %>% sweep(as.matrix(stemjobprops), 2, ., "/")
lq.bigcities = as.matrix(proportions["sumXdomain.bigcities",]) %>% sweep(as.matrix(stemjobprops), 2, ., "/")

# other way to calculate, should be the same as lq.nats
# localjobshare = apply(stemjobcounts, 1, sum) / sum(counts["sumXdomain.nat",])
# lq2 = as.matrix(counts["sumXdomain.nat",]) %>% sweep(as.matrix(stemjobcounts), 2, ., "/") %>% sweep(., 1, localjobshare, "/")
# cbind(lq.nats[,2], lq2[,2])

#### 
# How different do they look?
lq.stem1 = data.frame(nat = lq.nats[,"X1"], all = lq.allcities[,"X1"], big = lq.bigcities[,"X1"])

ta = lq.stem1[order(lq.stem1[,"nat"]),]
vals = ta[,"nat"]
labl = as.numeric(rownames(ta))

ind = match(labl, citymapper[,"code"])
citylabels = citymapper[ind, "geogname"]
# citylabels = rev(citymapper[ind, "geogname"])

xlabel = "LQ"
titletext = "STEM 1 Employment"

png(filename = "../results/denominators.png", width = 600, height = 800, res = 100)

s.dot(vals = vals, nticks = 7, lmarspc = 7, ylabels = citylabels, x.lab = xlabel, titletext = titletext)

# you have to remember that I (inexplicably) multiplied the y values by 10
y.ats = 1:length(vals) * 10

vals = ta[,"all"]
points(x = vals, y = y.ats, pch = 15, col = "blue", cex = 0.65)

vals = ta[,"big"]
points(x = vals, y = y.ats, pch = 17, col = "purple", cex = 0.65)

legend(x = 3, y = 50, col = c("black", "blue", "purple"), pch = c(20, 15, 17), legend = c("National", "All cities", "Big cities"), cex = 0.65)
title(sub = "Effect of different denominators", cex = 0.85)

# par(mar = c(5, 4, 4, 2) + 0.1)
# mtext("National proportion of STEM 1 jobs: 6.7%", side = 1, line = 3, adj = 1, cex = 0.65)

dev.off()
###### End plot
################################################################################

stemjobcount = stemjobcounts[,2]
stemjobprop = stemjobprops[,2]

stemjoblq = lq.nats[,2]
stemjobprop = round(stemjobprop, 3)

# hist(stemjobcount)
# hist(stemjoblq)
# hist(stemjobprop)

# plot(stemjoblq ~ stemjobcount, bty = "n")
# lines(lowess(stemjoblq ~ stemjobcount))

# Calculate proportion with STEM degrees
stemdegtab = with(acs[acs$ed >=4,], tapply(perwt, list(geog_curr, stemdeg), sum))
stemdegcount = stemdegtab[,2]
stemdegprop = stemdegcount / apply(stemdegtab, 1, sum)

stemdeglq = stemdegprop / (sumXstemdeg.nat[2] / sum(sumXstemdeg.nat))

# hist(stemdegcount)
# hist(stemdeglq)
# hist(stemdegprop)

# Stick those values on the data frame
cityvars = data.frame(city = as.numeric(names(stemjoblq)), stemjobcount, stemjoblq, stemdegcount, stemdeglq, pipe = round(stemjobcount / stemdegcount, 2))

acs = merge(x = acs, y = cityvars, by.x = "geog_curr", by.y = "city")

# Now subset down to just degree holders and the race categories we want
acs.all = acs[acs$ethrace < 4,]
acs = acs[acs$ethrace < 4 & acs$ed >= 4,]

# Remember, 'matched' means STEM degree holders in stem jobs. 
# aggregate(perwt ~ stem1 + stemdeg, sum, data = acs)

acs = transform(acs, match = as.numeric(stemdeg & stem1))
with(acs, table(stemdeg, match))
with(acs, table(stemdeg, stem_domain))
with(acs, table(match, stem_domain))

# aggregate(perwt ~ stem1 + stemdeg + match, sum, data = acs)

# Annnnd, factor race & sex & nativity
acs = transform(acs, f_race = factor(ethrace, levels = 0:3))
levels(acs$f_race) = c("H", "W", "B", "A")
acs[,"f_race"] = relevel(acs[,"f_race"], ref = "W")

acs = transform(acs, f_sex = factor(sex, levels = 1:2))
levels(acs$f_sex) = c("M", "F")
acs[,"f_sex"] = relevel(acs[,"f_sex"], ref = "M")

acs = transform(acs, f_fb = factor(fb, levels = 0:1))
levels(acs$f_fb) = c("nb", "fb")
acs[,"f_fb"] = relevel(acs[,"f_fb"], ref = "nb")

################################################################################
# Now some descriptives
head(acs.all)
with(acs.all, table(stem_domain, stemjob))

# Employment by STEM domain 
# Section: Defining STEM
bydomain = aggregate(perwt ~ stem_domain, FUN = sum, data = acs.all)
bydomain[,"perwt"] / sum(bydomain[,"perwt"])


# STEM employment by degree (and income)
# Section: STEM degrees
acs.all = transform(acs.all, income = perwt * inctot)
acs.all = transform(acs.all, stemdeg2 = stemdeg + 1)
acs.all[acs.all$ed < 4, "stemdeg2"] = 0

# First, proportions by degree
aggregate(perwt ~ stemdeg2, FUN = sum, data = acs.all) / sum(acs.all$perwt)
aggregate(perwt ~ stemdeg, FUN = sum, data = acs) / sum(acs$perwt)

income = aggregate(income ~ stem_domain + stemdeg2, FUN = function(x) {sum(as.numeric(x))}, data = acs.all)
persons = aggregate(perwt ~ stem_domain + stemdeg2, FUN = function(x) {sum(as.numeric(x))}, data = acs.all) 
ta = data.frame(income[,1:2], meanincome = income[,3] / persons[,3])
#fuckwankbugger

income = with(acs.all, tapply(income, list(stemdeg2, stem_domain), FUN = function(x) {sum(as.numeric(x))}))
persons = with(acs.all, tapply(perwt, list(stemdeg2, stem_domain), FUN = function(x) {sum(as.numeric(x))}))
(income / persons) %>% kable(digits = 0, format="pandoc")

((persons / sum(persons)) * 100) %>% kable(digits = 2, format="pandoc")

# lots of those STEM 4 are medical doctors. Here's what it looks like without graduate degrees
acs = transform(acs, income = perwt * inctot)
acs = transform(acs, stemdeg2 = stemdeg + 1)
acs[acs$ed < 4, "stemdeg2"] = 0
income = with(acs[acs$ed == 4,], tapply(income, list(stemdeg2, stem_domain), FUN = function(x) {sum(as.numeric(x))}))
persons = with(acs[acs$ed == 4,], tapply(perwt, list(stemdeg2, stem_domain), FUN = function(x) {sum(as.numeric(x))}))
(income / persons) %>% kable(digits = 0, format="pandoc")

((persons / sum(persons)) * 100) %>% kable(digits = 2, format="pandoc")


## Now do the dotplots like before and the correlations.
# use s.dot from source('~/Documents/diss/tools/plotfuns.R')

bydomain = with(acs.all, tapply(perwt, list(geog_curr, stem_domain), sum))
bydomainprop = sweep(bydomain, 1, apply(bydomain, 1, sum), "/")
allcity = apply(bydomain, 2, sum) 
allcityprop = allcity / sum(allcity)

lq = sweep(bydomainprop, 2, allcityprop, "/")

# Plot STEM 1
vals = lq[order(lq[,"1"]),"1"]
labl = as.numeric(names(lq[order(lq[,"1"]),"1"]))

ind = match(labl, citymapper[,"code"])
citylabels = citymapper[ind, "geogname"]
# citylabels = rev(citymapper[ind, "geogname"])

xlabel = "LQ"
titletext = "STEM 1 Employment"

height = 4
# pdf(file = "../results/stem1.pdf", width = height / 1.618, height = height, onefile = F)
# png(filename = "../results/stem1.png", width = height / 1.618, height = height, units = "in", res = 300)
# You really have to fiddle with the size/resolution of the device region to make it work
png(filename = "../results/stem1.png", width = 600, height = 800, res = 100)

s.dot(vals = vals, nticks = 7, lmarspc = 7, ylabels = citylabels, x.lab = xlabel, titletext = titletext)
# par(mar = c(5, 4, 4, 2) + 0.1)
mtext("National proportion of STEM 1 jobs: 6.7%", side = 1, line = 3, adj = 1, cex = 0.65)

dev.off()

# Plot STEM 4
vals = lq[order(lq[,"4"]),"4"]
labl = as.numeric(names(lq[order(lq[,"1"]),"1"]))

ind = match(labl, citymapper[,"code"])
citylabels = citymapper[ind, "geogname"]
# citylabels = rev(citymapper[ind, "geogname"])

xrange = c(0, 3.0) # for consistency with the STEM 1 chart
xlabel = "LQ"
titletext = "STEM 4 Employment"

# pdf(file = "stem4.pdf", width = 8 / 1.618, height = 8, onefile = F)
png(filename = "../results/stem4.png", width = 600, height = 800, res = 100)

s.dot(vals = vals, nticks = 7, lmarspc = 7, ylabels = citylabels, x.lab = xlabel, xrange = xrange, titletext = titletext)
# par(mar = c(5, 4, 4, 2) + 0.1)
mtext("National proportion of STEM 4 jobs: 5.8%", side = 1, line = 3, adj = 1, cex = 0.65)

dev.off()

## correlate city population and STEM1/4
citypop = with(acs.all, tapply(perwt, list(geog_curr), sum))
cor(bydomain[,"1"], citypop)
cor(bydomain[,"4"], citypop)

summary(lq)
apply(lq, 2, sd)

byfield = with(acs[acs$degreclass == 18,], tapply(perwt, list(degfield), sum))
propbyfield = round(stemdegbyfield / sum(stemdegbyfield), 3)
data.frame(degfields[degfields$degreclass == 18, c("degfield", "deglabel")], propbyfield) %>% kable(row.names = F, format = "pandoc")
