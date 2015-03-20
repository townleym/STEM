# Model Output
November 12, 2014  


```
## Loading required package: sandwich
## Loading required package: msm
## Loading required package: knitr
## Loading required package: RSQLite
## Loading required package: DBI
```

# Model

Main effects, then interact sex, nativity, race. The intercept is a white male of average age (about 43.6 yrs) in a city with a mean STEM job LQ (about 1.12).



## LQ or log(count)?



I don't like the latter bic.test method since it seems a little weird with the degrees of freedom. I don't know that the algebra is correct, because we just apply the penalty to the difference in doubled log likelihoods, rather than penalizing each and taking the difference. Plus, the way Chris was doing it, the parameter penalty will always be 1 (if you're just adding a single factor between models). Dunno. Seems fishy. Especially when we can calculate the BICs and take the differences?

How to present the above:



|variable          |      model1|      model2|      model3|      model4|
|:-----------------|-----------:|-----------:|-----------:|-----------:|
|(Intercept)       |       0.419|       0.357|       0.417|       0.499|
|f_raceA           |       1.216|       1.212|       1.177|       1.180|
|f_raceB           |       0.792|       0.791|       0.801|       0.802|
|f_raceH           |       0.710|       0.711|       0.738|       0.738|
|f_sexF            |       0.645|       0.645|       0.646|       0.646|
|f_fbfb            |       1.091|       1.088|       1.086|       1.089|
|agec              |       0.987|       0.987|       0.987|       0.987|
|I(agec^2)         |       1.000|       1.000|       1.000|       1.000|
|stemjoblqc        |          NA|          NA|       1.271|       1.276|
|log(stemjobcount) |          NA|       1.014|          NA|       0.985|
|------------------|------------|------------|------------|------------|
|log Likelihood    |     -130573|     -130569|     -130048|     -130043|
|BIC               |      261255|      261259|      260216|      260219|


## Main effects




## Add LQ



---

|            |mod.me.coef   |mod.lq.coef   |
|:-----------|:-------------|:-------------|
|(Intercept) |0.419 (0.002) |0.417 (0.002) |
|f_raceA     |1.216 (0.010) |1.177 (0.010) |
|f_raceB     |0.792 (0.012) |0.801 (0.012) |
|f_raceH     |0.710 (0.011) |0.738 (0.011) |
|f_sexF      |0.645 (0.005) |0.646 (0.005) |
|f_fbfb      |1.091 (0.009) |1.086 (0.009) |
|agec        |0.987 (0.000) |0.987 (0.000) |
|I(agec^2)   |1.000 (0.000) |1.000 (0.000) |
|stemjoblqc  |              |1.271 (0.006) |
|logLik      |-130573       |-130048       |
|BIC         |261255        |260216        |


## Interact sex



|                  | Estimate| robust.se|   lcl|   ucl|
|:-----------------|--------:|---------:|-----:|-----:|
|(Intercept)       |    0.418|     0.002| 0.414| 0.422|
|stemjoblqc        |    1.249|     0.007| 1.236| 1.262|
|f_sexF            |    0.641|     0.005| 0.631| 0.651|
|f_raceA           |    1.177|     0.010| 1.157| 1.197|
|f_raceB           |    0.801|     0.012| 0.777| 0.826|
|f_raceH           |    0.738|     0.011| 0.716| 0.761|
|f_fbfb            |    1.085|     0.009| 1.069| 1.102|
|agec              |    0.987|     0.000| 0.986| 0.988|
|I(agec^2)         |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc:f_sexF |    1.086|     0.014| 1.060| 1.113|

Being in a high STEM job LQ city has a positive effect on the probability of a match for a woman. About the same in magnitude as for foreign born in the previous model.

## Interact nativity


|                  | Estimate| robust.se|   lcl|   ucl|
|:-----------------|--------:|---------:|-----:|-----:|
|(Intercept)       |    0.417|     0.002| 0.413| 0.422|
|stemjoblqc        |    1.289|     0.010| 1.270| 1.309|
|f_fbfb            |    1.088|     0.009| 1.071| 1.105|
|f_sexF            |    0.646|     0.005| 0.636| 0.655|
|f_raceA           |    1.178|     0.010| 1.159| 1.198|
|f_raceB           |    0.800|     0.012| 0.776| 0.825|
|f_raceH           |    0.737|     0.011| 0.715| 0.760|
|agec              |    0.987|     0.000| 0.986| 0.988|
|I(agec^2)         |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc:f_fbfb |    0.974|     0.010| 0.956| 0.993|

Note the direction change from the previous version of this file I sent. Calculating the LQ of STEM jobs correctly, now has made the effect modification for the foreign born *negative*. Being in a higher LQ city **lowers** (slightly) the effect modification for a match.

This is hard to believe. And I can hear Mark saying that maybe the relative risk estimation does not work...

Although, an anecdote might inform. Kristi Copeland's husband is from the subcontinent, and his first job was in Cleveland with Booz, Allen, and Hamilton. There were *lots* of foreign born in that office and they all joked that they accepted the job in Cleveland because they didn't know better. 

## Interact race


|                   | Estimate| robust.se|   lcl|   ucl|
|:------------------|--------:|---------:|-----:|-----:|
|(Intercept)        |    0.417|     0.002| 0.413| 0.421|
|stemjoblqc         |    1.301|     0.010| 1.282| 1.320|
|f_raceA            |    1.187|     0.010| 1.167| 1.208|
|f_raceB            |    0.801|     0.012| 0.777| 0.826|
|f_raceH            |    0.747|     0.012| 0.725| 0.770|
|f_sexF             |    0.646|     0.005| 0.636| 0.655|
|f_fbfb             |    1.086|     0.009| 1.069| 1.103|
|agec               |    0.987|     0.000| 0.986| 0.988|
|I(agec^2)          |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc:f_raceA |    0.940|     0.009| 0.922| 0.959|
|stemjoblqc:f_raceB |    1.056|     0.036| 0.987| 1.130|
|stemjoblqc:f_raceH |    1.098|     0.029| 1.042| 1.156|

Perhaps a little surprisingly, Asian men, are a little *less* likely to be matched in high STEM job LQ cities than white men. For Black men it is marginally positive, but not well estimated enough to be definitive, and for Hispanic men, strongly positive --of roughly the same magnitude as for women above.

# Model-based assessment of interactions

I think the more standard way is to put all interactions into a single model, then test the differences between models, pulling one out at a time.

But, here I will just present a table of each model estimated separately. There are many roads to Rome...


|                   | Estimate| robust.se|   lcl|   ucl|
|:------------------|--------:|---------:|-----:|-----:|
|(Intercept)        |    0.418|     0.002| 0.413| 0.422|
|stemjoblqc         |    1.274|     0.011| 1.254| 1.296|
|f_raceA            |    1.189|     0.010| 1.169| 1.210|
|f_raceB            |    0.803|     0.012| 0.778| 0.827|
|f_raceH            |    0.748|     0.012| 0.725| 0.771|
|f_sexF             |    0.641|     0.005| 0.631| 0.651|
|f_fbfb             |    1.084|     0.009| 1.067| 1.101|
|agec               |    0.987|     0.000| 0.986| 0.988|
|I(agec^2)          |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc:f_raceA |    0.923|     0.012| 0.900| 0.947|
|stemjoblqc:f_raceB |    1.043|     0.036| 0.975| 1.116|
|stemjoblqc:f_raceH |    1.085|     0.029| 1.029| 1.144|
|stemjoblqc:f_sexF  |    1.089|     0.014| 1.063| 1.117|
|stemjoblqc:f_fbfb  |    1.021|     0.013| 0.996| 1.047|

Now figure out a way to display all of that together



This was hand-coded

|var                |Model 1 (sex) |Model 2 (nat) |Model 3 (race)|Model 4 (all) |
|:------------------|-------------:|-------------:|-------------:|-------------:|
|(Intercept)        |0.418 (0.002) |0.418 (0.002) |0.417 (0.002) |0.418 (0.002) |
|stemjoblqc         |1.249 (0.011) |1.289 (0.011) |1.301 (0.010) |1.274 (0.011) |
|f_raceA            |1.177 (0.010) |1.178 (0.010) |1.187 (0.010) |1.189 (0.010) |
|f_raceB            |0.801 (0.012) |0.800 (0.012) |0.801 (0.012) |0.803 (0.012) |
|f_raceH            |0.738 (0.011) |0.737 (0.011) |0.747 (0.012) |0.748 (0.012) |
|f_sexF             |0.641 (0.005) |0.646 (0.005) |0.646 (0.005) |0.641 (0.005) |
|f_fbfb             |1.085 (0.009) |1.088 (0.009) |1.086 (0.009) |1.084 (0.009) |
|agec               |0.987 (0.000) |0.987 (0.000) |0.987 (0.000) |0.987 (0.000) |
|I(agec^2)          |1.000 (0.000) |1.000 (0.000) |1.000 (0.000) |1.000 (0.000) |
|stemjoblqc:f_raceA |              |              |0.940 (0.009) |0.923 (0.012) |
|stemjoblqc:f_raceB |              |              |1.056 (0.036) |1.043 (0.036) |
|stemjoblqc:f_raceH |              |              |1.098 (0.029) |1.085 (0.029) |
|stemjoblqc:f_sexF  |1.086 (0.014) |              |              |1.089 (0.014) |
|stemjoblqc:f_fbfb  |              |0.974 (0.010) |              |1.021 (0.013) | 
|log Likelihood     |-130036       |-130046       |-130031       |-130018       |
|BIC                |260206        |260225        |260219        |260218        |



## Model Comparison 

Now remove factors and compare the models. (not shown)




# Predicted probabilities

(not shown)


