
## ----, echo=FALSE, eval = T, collapse = T, results='hide'----------------
setwd('~/Documents/Geog/MigProject/STEM/analysis')
source('finaldb_connect-all.R', echo = F)

# Calculate the stem job lq as for all STEM workers in the 55 cities
# so, I'm doing the LQ/proportion with the whole population (i.e. + non degree holders)
stemjobtab = with(acs, tapply(perwt, list(geog_curr, stem1), sum))
stemjobcount = stemjobtab[,2]
stemjobprop = stemjobcount / apply(stemjobtab, 1, sum)

overallct = apply(stemjobtab, 2, sum)
overallprop = overallct[2] / sum(overallct)

stemjoblq = round(stemjobprop / overallprop, 2)
stemjobprop = round(stemjobprop, 3)

# hist(stemjobcount)
# hist(stemjoblq)
# hist(stemjobprop)

# plot(stemjoblq ~ stemjobcount, bty = "n")
# lines(lowess(stemjoblq ~ stemjobcount))

stemdegtab = with(acs, tapply(perwt, list(geog_curr, stemdeg), sum))
stemdegcount = stemdegtab[,2]
stemdegprop = stemdegcount / apply(stemdegtab, 1, sum)

overalldegct = apply(stemdegtab, 2, sum)
overalldegprop = overalldegct[2] / sum(overalldegct)

stemdeglq = round(stemdegprop / overalldegprop, 2)
stemdegprop = round(stemdegprop, 3)

# hist(stemdegcount)
# hist(stemdeglq)
# hist(stemdegprop)

# Stick those values on the data frame
cityvars = data.frame(city = as.numeric(names(stemjobcount)), stemjobcount, stemjoblq, stemdegcount, stemdeglq, pipe = round(stemjobcount / stemdegcount, 2))

acs = merge(x = acs, y = cityvars, by.x = "geog_curr", by.y = "city")

# Now subset down to just degree holders and the race categories we want
acs.all = acs
acs = acs[acs$ethrace < 4 & acs$ed == 4,]

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

