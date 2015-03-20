# Model Output
November 12, 2014  


```
## Loading required package: sandwich
## Loading required package: msm
## Loading required package: knitr
## Loading required package: magrittr
## Loading required package: RSQLite
## Loading required package: DBI
```

The big difference is that we lose almost *half* of the observations once we eliminate those with advanced degrees. By classifying second degree fields, we picked up about 1,000 additional STEM degree holders to bring the number to about 92,000. But by eliminating those with an advanced degree, we lost about 85,000. 

That is astounding.

# Model

Main effects, then interact sex, nativity, race. The intercept is a white male of average age (about 42.8 yrs) in a city with a STEM job LQ of 1.



## LQ or log(count)?



We have four models, one with neither stem job count nor the LQ, then three with all possible combinations.


|variable      | model1| model2| model3| model4|
|:-------------|------:|------:|------:|------:|
|(Intercept)   |  0.494|  0.490|  0.482|  0.478|
|f_raceH       |  0.722|  0.723|  0.742|  0.744|
|f_raceB       |  0.795|  0.800|  0.800|  0.806|
|f_raceA       |  1.214|  1.228|  1.182|  1.196|
|f_sexF        |  0.616|  0.617|  0.617|  0.617|
|f_fbfb        |  0.893|  0.902|  0.896|  0.906|
|agec          |  0.988|  0.988|  0.988|  0.988|
|I(agec^2)     |  1.000|  1.000|  1.000|  1.000|
|stemjobcountc |     NA|     NA|  1.227|  1.000|
|stemjoblqc    |     NA|  1.000|     NA|  1.229|


|variable       |     model1|     model2|     model3|     model4|
|:--------------|----------:|----------:|----------:|----------:|
|(Intercept)    |      0.494|      0.490|      0.482|      0.478|
|f_raceH        |      0.722|      0.723|      0.742|      0.744|
|f_raceB        |      0.795|      0.800|      0.800|      0.806|
|f_raceA        |      1.214|      1.228|      1.182|      1.196|
|f_sexF         |      0.616|      0.617|      0.617|      0.617|
|f_fbfb         |      0.893|      0.902|      0.896|      0.906|
|agec           |      0.988|      0.988|      0.988|      0.988|
|I(agec^2)      |      1.000|      1.000|      1.000|      1.000|
|stemjobcountc  |         NA|         NA|      1.227|      1.000|
|stemjoblqc     |         NA|      1.000|         NA|      1.229|
|log Likelihood | -70982.000| -70960.000| -70798.000| -70772.000|
|BIC            | 142067.000| 142034.000| 141711.000| 141669.000|

This result is different from what we got before in which the centered LQ did all the work. The evidence is mixed. By itself, the stem job count does not improve model fit. But in the model with LQ, we have evidence that it does. Furthermore they pull in opposite directions.

This is a pretty big change from when we ran the models with STEM degree holders with either a BA or an advanced degree. Why?


[1] "time in minutes: 0.264266666666667"
[1] TRUE


Table: Attainment X STEM Degree: all LF

           0        1
---  -------  -------
1     237035        0
2     496502        0
3     683713        0
4     421437   102208
5     233293    91771


Table: Attainment X STEM Degree: all LF aged 25 - 65

           0       1
---  -------  ------
1     171473       0
2     400065       0
3     557362       0
4     378748   92647
5     217495   85794

The rows correspond to highest educational attainment. 4 is a BA, and 5 is an advanced degree. When we exclude advanced degree holders, we will lose almost half the STEM degree holders.

That is just because advanced degree attainment among STEM degree holders is astounding:


Table: Advanced degree attainment, non-STEM and STEM degree holders (observations).

---  -----
0     0.36
1     0.48
---  -----


Table: Advanced degree attainment, non-STEM and STEM degree holders (counts).

---  -----
0     0.35
1     0.46
---  -----

And below is the effect on matching


Table: STEM Degree X Match: all degree holders

            0       1
---  --------  ------
0     1725143       0
1      109494   68947


Table: STEM Degree X Match: excluding advanced degree holders

           0       1
---  -------  ------
0     378748       0
1      54097   38550

## Main effects

As a baseline, we will first estimate just the main effects for age, race, sex, and nativity.


|            | Estimate| robust.se|   lcl|   ucl|
|:-----------|--------:|---------:|-----:|-----:|
|(Intercept) |    0.494|     0.003| 0.487| 0.500|
|f_raceH     |    0.722|     0.014| 0.695| 0.749|
|f_raceB     |    0.795|     0.015| 0.766| 0.824|
|f_raceA     |    1.214|     0.015| 1.186| 1.244|
|f_sexF      |    0.616|     0.007| 0.604| 0.629|
|f_fbfb      |    0.893|     0.010| 0.873| 0.913|
|agec        |    0.988|     0.000| 0.987| 0.989|
|I(agec^2)   |    1.000|     0.000| 1.000| 1.000|


## Add LQ and STEM Job count

And from here on I will include both. 


|              | Estimate| robust.se|   lcl|   ucl|
|:-------------|--------:|---------:|-----:|-----:|
|(Intercept)   |    0.478|     0.003| 0.472| 0.484|
|f_raceH       |    0.744|     0.014| 0.717| 0.772|
|f_raceB       |    0.806|     0.015| 0.777| 0.836|
|f_raceA       |    1.196|     0.015| 1.167| 1.224|
|f_sexF        |    0.617|     0.007| 0.604| 0.630|
|f_fbfb        |    0.906|     0.010| 0.886| 0.927|
|agec          |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)     |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc    |    1.229|     0.009| 1.212| 1.246|
|stemjobcountc |    1.000|     0.000| 1.000| 1.000|


 
## Now interact race and nativity

Given that the coefficient for foreign born is less than 1, I suspect that national origin might change that. Our baseline category is a white male, so it is conceivable that a white, foreign born male would have a lower probabilty of a match than a native born one. But I suspect the same is *not* true for, say, Asian males. 

Let's look.


|               | Estimate| robust.se|   lcl|   ucl|
|:--------------|--------:|---------:|-----:|-----:|
|(Intercept)    |    0.478|     0.003| 0.472| 0.484|
|f_sexF         |    0.616|     0.007| 0.603| 0.629|
|f_raceH        |    0.875|     0.019| 0.838| 0.914|
|f_raceB        |    0.822|     0.017| 0.790| 0.856|
|f_raceA        |    1.033|     0.020| 0.994| 1.074|
|f_fbfb         |    0.905|     0.015| 0.876| 0.935|
|agec           |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)      |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc     |    1.228|     0.009| 1.211| 1.245|
|stemjobcountc  |    1.000|     0.000| 1.000| 1.000|
|f_raceH:f_fbfb |    0.699|     0.028| 0.647| 0.756|
|f_raceB:f_fbfb |    0.916|     0.043| 0.835| 1.004|
|f_raceA:f_fbfb |    1.198|     0.031| 1.138| 1.261|

Look at that. The effect for Asian alone is no longer statistically significant, but the interaction with Asian and Foreign Born does all the work that Asian did *without* the interaction. In other words, the matching effect for Asian men is *only* for foreign-born Asian men. Also, as expected, the effect is negative for foreign born Hispanic men, and unsurprisingly not statistically significant for foreign born blacks (given the relatively small number).

# Interaction between demography and geography

In the following sections we will interact each demographic variable (race, sex, nativity) with the LQ variable to see whether place attenuates or exaggerates the demographic effects.

In each of the following sections we will interact race, sex, and nativity with the geographic variables. We expect better matching probabilities in high LQ locations.

In this section I have maintained the interaction between race and nativity. That means we have three way interactions between race/nativity/LQ.

Since it does more work, I only interact with the stemjob LQ variable. To be thorough, we should probably do both... but then the number of coefficients gets pretty crazy.

## Interact sex

What is the effect of geography for women?


|                  | Estimate| robust.se|   lcl|   ucl|
|:-----------------|--------:|---------:|-----:|-----:|
|(Intercept)       |    0.479|     0.003| 0.473| 0.485|
|stemjoblqc        |    1.215|     0.009| 1.197| 1.233|
|f_sexF            |    0.611|     0.007| 0.597| 0.624|
|f_raceH           |    0.875|     0.019| 0.838| 0.913|
|f_raceB           |    0.823|     0.017| 0.790| 0.857|
|f_raceA           |    1.034|     0.020| 0.994| 1.074|
|f_fbfb            |    0.905|     0.015| 0.877| 0.935|
|agec              |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)         |    1.000|     0.000| 1.000| 1.000|
|stemjobcountc     |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc:f_sexF |    1.058|     0.020| 1.019| 1.099|
|f_raceH:f_fbfb    |    0.699|     0.028| 0.647| 0.756|
|f_raceB:f_fbfb    |    0.915|     0.043| 0.835| 1.003|
|f_raceA:f_fbfb    |    1.197|     0.031| 1.137| 1.260|

Being in a high STEM job LQ city has a small but positive effect on the probability of a match for a woman, increasing anywhere between 2% and 10%.

This effect might be a result of a lower relative number of women in STEM job concentrations.


Table: Proportion of women

      citynames                    lqs   fprop
----  -------------------------  -----  ------
52    Atlanta, GA                 0.98    0.30
64    Austin, TX                  1.48    0.26
72    Baltimore, MD               1.35    0.31
112   Boston, MA                  1.45    0.28
128   Buffalo, NY                 0.71    0.24
152   Charlotte, NC               0.83    0.24
160   Chicago, IL                 0.84    0.27
164   Cincinnati, OH              0.90    0.28
168   Cleveland, OH               0.82    0.22
184   Columbus, OH                0.99    0.23
192   Dallas-Fort Worth, TX       1.03    0.25
208   Denver, CO                  1.38    0.25
216   Detroit, MI                 1.00    0.27
268   Fort Lauderdale, FL         0.57    0.27
284   Fresno, CA                  0.38    0.20
300   Grand Rapids, MI            0.79    0.27
312   Greensboro, NC              0.64    0.30
336   Houston, TX                 1.09    0.25
348   Indianapolis, IN            0.88    0.23
359   Jacksonville, FL            0.75    0.26
376   Kansas City, MO             1.05    0.25
412   Las Vegas, NV               0.42    0.27
448   Los Angeles, CA             0.78    0.26
492   Memphis, TN                 0.63    0.30
500   Miami, FL                   0.43    0.29
508   Milwaukee, WI               0.89    0.24
512   Minneapolis-St. Paul, MN    1.25    0.23
519   Monmouth-Ocean, NJ          0.86    0.29
536   Nashville, TN               0.78    0.31
556   New Orleans, LA             0.58    0.28
560   New York, NY                0.78    0.29
572   Norfolk, VA                 1.01    0.27
588   Oklahoma City, OK           0.76    0.22
596   Orlando, FL                 0.75    0.23
616   Philadelphia, PA            0.99    0.30
620   Phoenix, AZ                 0.96    0.24
628   Pittsburgh, PA              0.93    0.27
644   Portland, OR                1.17    0.24
648   Providence, RI              0.76    0.27
664   Raleigh-Durham, NC          1.66    0.31
676   Richmond, VA                1.05    0.30
678   Riverside, CA               0.48    0.26
684   Rochester, NY               1.06    0.25
692   Sacramento, CA              1.02    0.26
704   Salt Lake City, UT          0.93    0.24
716   San Antonio, TX             1.01    0.19
724   San Diego, CA               0.73    0.26
732   San Francisco, CA           1.29    0.25
736   San Jose, CA                1.42    0.28
740   Seattle, WA                 2.85    0.25
760   St. Louis, MO               1.85    0.24
828   Tampa-St. Petersburg, FL    0.78    0.27
856   Tulsa, OK                   0.76    0.20
884   Washington, DC              1.82    0.29
896   West Palm Beach, FL         0.55    0.29
![plot of chunk sextab](./finalfinalmods_files/figure-html/sextab.png) 
Call:
lm(formula = fprop ~ lqs)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.06729 -0.01851  0.00223  0.01800  0.05160 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.25856    0.00986   26.22   <2e-16 ***
lqs          0.00333    0.00928    0.36     0.72    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.0283 on 53 degrees of freedom
Multiple R-squared:  0.00242,	Adjusted R-squared:  -0.0164 
F-statistic: 0.128 on 1 and 53 DF,  p-value: 0.721

Except that there is not much variation in the proportion of STEM degree holders who are women. What about proportion matched?


Table: Proportion of women

      citynames                    lqs   fprop   fpropmatch
----  -------------------------  -----  ------  -----------
52    Atlanta, GA                 0.98    0.30         0.21
64    Austin, TX                  1.48    0.26         0.17
72    Baltimore, MD               1.35    0.31         0.25
112   Boston, MA                  1.45    0.28         0.20
128   Buffalo, NY                 0.71    0.24         0.16
152   Charlotte, NC               0.83    0.24         0.18
160   Chicago, IL                 0.84    0.27         0.19
164   Cincinnati, OH              0.90    0.28         0.23
168   Cleveland, OH               0.82    0.22         0.14
184   Columbus, OH                0.99    0.23         0.15
192   Dallas-Fort Worth, TX       1.03    0.25         0.17
208   Denver, CO                  1.38    0.25         0.17
216   Detroit, MI                 1.00    0.27         0.16
268   Fort Lauderdale, FL         0.57    0.27         0.16
284   Fresno, CA                  0.38    0.20         0.10
300   Grand Rapids, MI            0.79    0.27         0.16
312   Greensboro, NC              0.64    0.30         0.17
336   Houston, TX                 1.09    0.25         0.17
348   Indianapolis, IN            0.88    0.23         0.18
359   Jacksonville, FL            0.75    0.26         0.18
376   Kansas City, MO             1.05    0.25         0.19
412   Las Vegas, NV               0.42    0.27         0.20
448   Los Angeles, CA             0.78    0.26         0.17
492   Memphis, TN                 0.63    0.30         0.24
500   Miami, FL                   0.43    0.29         0.18
508   Milwaukee, WI               0.89    0.24         0.16
512   Minneapolis-St. Paul, MN    1.25    0.23         0.15
519   Monmouth-Ocean, NJ          0.86    0.29         0.17
536   Nashville, TN               0.78    0.31         0.15
556   New Orleans, LA             0.58    0.28         0.23
560   New York, NY                0.78    0.29         0.19
572   Norfolk, VA                 1.01    0.27         0.17
588   Oklahoma City, OK           0.76    0.22         0.14
596   Orlando, FL                 0.75    0.23         0.15
616   Philadelphia, PA            0.99    0.30         0.20
620   Phoenix, AZ                 0.96    0.24         0.18
628   Pittsburgh, PA              0.93    0.27         0.16
644   Portland, OR                1.17    0.24         0.13
648   Providence, RI              0.76    0.27         0.16
664   Raleigh-Durham, NC          1.66    0.31         0.22
676   Richmond, VA                1.05    0.30         0.21
678   Riverside, CA               0.48    0.26         0.16
684   Rochester, NY               1.06    0.25         0.15
692   Sacramento, CA              1.02    0.26         0.22
704   Salt Lake City, UT          0.93    0.24         0.18
716   San Antonio, TX             1.01    0.19         0.12
724   San Diego, CA               0.73    0.26         0.21
732   San Francisco, CA           1.29    0.25         0.20
736   San Jose, CA                1.42    0.28         0.20
740   Seattle, WA                 2.85    0.25         0.18
760   St. Louis, MO               1.85    0.24         0.16
828   Tampa-St. Petersburg, FL    0.78    0.27         0.15
856   Tulsa, OK                   0.76    0.20         0.18
884   Washington, DC              1.82    0.29         0.23
896   West Palm Beach, FL         0.55    0.29         0.18
![plot of chunk sextab2](./finalfinalmods_files/figure-html/sextab2.png) 
Call:
lm(formula = fpropmatch ~ lqs)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.06801 -0.02110 -0.00278  0.01645  0.06919 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.16613    0.01056   15.73   <2e-16 ***
lqs          0.01270    0.00994    1.28     0.21    
---
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

Residual standard error: 0.0303 on 53 degrees of freedom
Multiple R-squared:  0.0299,	Adjusted R-squared:  0.0116 
F-statistic: 1.63 on 1 and 53 DF,  p-value: 0.207

So, there is a mild association (higher LQ corresponds to a higher proportion of women who are matched), but the effect is weak.

## Interact nativity


|                  | Estimate| robust.se|   lcl|   ucl|
|:-----------------|--------:|---------:|-----:|-----:|
|(Intercept)       |    0.477|     0.003| 0.471| 0.483|
|f_sexF            |    0.616|     0.007| 0.603| 0.629|
|f_raceH           |    0.876|     0.019| 0.839| 0.915|
|f_raceB           |    0.823|     0.017| 0.790| 0.857|
|f_raceA           |    1.032|     0.020| 0.992| 1.072|
|f_fbfb            |    0.909|     0.015| 0.880| 0.939|
|agec              |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)         |    1.000|     0.000| 1.000| 1.000|
|stemjoblqc        |    1.243|     0.012| 1.220| 1.267|
|stemjobcountc     |    1.000|     0.000| 1.000| 1.000|
|f_raceH:f_fbfb    |    0.696|     0.028| 0.644| 0.752|
|f_raceB:f_fbfb    |    0.914|     0.043| 0.834| 1.002|
|f_raceA:f_fbfb    |    1.203|     0.032| 1.142| 1.267|
|f_fbfb:stemjoblqc |    0.971|     0.014| 0.944| 0.999|

Note the direction change from the previous version of this file I sent. Calculating the LQ of STEM jobs correctly, now has made the effect modification for the foreign born *negative*. Being in a higher LQ city **lowers** (slightly) the effect modification for a match.

This is hard to believe. 

Although, an anecdote might inform. Kristi Copeland's husband is from the subcontinent, and his first job was in Cleveland with Booz, Allen, and Hamilton. There were *lots* of foreign born in that office and they all joked that they accepted the job in Cleveland because they didn't know better. 

## Interact race


|                   | Estimate| robust.se|   lcl|   ucl|
|:------------------|--------:|---------:|-----:|-----:|
|(Intercept)        |    0.477|     0.003| 0.471| 0.483|
|f_sexF             |    0.616|     0.007| 0.603| 0.629|
|f_fbfb             |    0.906|     0.015| 0.877| 0.936|
|f_raceH            |    0.874|     0.019| 0.837| 0.913|
|f_raceB            |    0.815|     0.017| 0.782| 0.850|
|f_raceA            |    1.048|     0.021| 1.008| 1.090|
|stemjoblqc         |    1.243|     0.012| 1.219| 1.268|
|stemjobcountc      |    1.000|     0.000| 1.000| 1.000|
|agec               |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)          |    1.000|     0.000| 1.000| 1.000|
|f_fbfb:f_raceH     |    0.704|     0.028| 0.651| 0.761|
|f_fbfb:f_raceB     |    0.917|     0.043| 0.836| 1.005|
|f_fbfb:f_raceA     |    1.195|     0.031| 1.135| 1.258|
|f_raceH:stemjoblqc |    1.069|     0.037| 0.999| 1.143|
|f_raceB:stemjoblqc |    1.105|     0.048| 1.015| 1.202|
|f_raceA:stemjoblqc |    0.952|     0.048| 0.925| 0.980|

Perhaps a little surprisingly, Asian men, are a little *less* likely to be matched in high STEM job LQ cities than white men. For Hispanic men it is marginally positive, but not well estimated enough to be definitive, and for Black men, strongly positive.

So, now we need to put all of this together.

# Model-based assessment of interactions

I think the more standard way is to put all interactions into a single model, then test the differences between models, pulling one out at a time.

But, here I will just present a table of each model estimated separately. There are many roads to Rome...


|                   | Estimate| robust.se|   lcl|   ucl|
|:------------------|--------:|---------:|-----:|-----:|
|(Intercept)        |    0.478|     0.003| 0.471| 0.484|
|stemjoblqc         |    1.231|     0.013| 1.205| 1.256|
|stemjobcountc      |    1.000|     0.000| 1.000| 1.000|
|f_sexF             |    0.611|     0.007| 0.598| 0.624|
|f_raceH            |    0.874|     0.019| 0.837| 0.913|
|f_raceB            |    0.816|     0.017| 0.782| 0.851|
|f_raceA            |    1.050|     0.022| 1.009| 1.094|
|f_fbfb             |    0.905|     0.015| 0.876| 0.936|
|agec               |    0.988|     0.000| 0.988| 0.989|
|I(agec^2)          |    1.000|     0.000| 1.000| 1.000|
|f_raceH:f_fbfb     |    0.705|     0.028| 0.652| 0.762|
|f_raceB:f_fbfb     |    0.917|     0.043| 0.836| 1.005|
|f_raceA:f_fbfb     |    1.193|     0.032| 1.133| 1.256|
|stemjoblqc:f_raceH |    1.062|     0.037| 0.992| 1.137|
|stemjoblqc:f_raceB |    1.096|     0.047| 1.007| 1.193|
|stemjoblqc:f_raceA |    0.944|     0.019| 0.908| 0.982|
|stemjoblqc:f_sexF  |    1.059|     0.021| 1.019| 1.100|
|stemjoblqc:f_fbfb  |    1.007|     0.019| 0.970| 1.046|

Now figure out a way to display all of that together....

## Model Comparison 

Now remove factors and compare the models.


```
## Analysis of Deviance Table
## 
## Model 1: match ~ stemjoblqc + stemjobcountc + f_sex + f_race + f_fb + 
##     agec + I(agec^2) + f_race:f_fb + stemjoblqc:f_race + stemjoblqc:f_fb
## Model 2: match ~ stemjoblqc + stemjobcountc + f_sex + f_race * f_fb + 
##     agec + I(agec^2) + stemjoblqc:f_race + stemjoblqc:f_sex + 
##     stemjoblqc:f_fb
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)  
## 1     92630      64318                       
## 2     92629      64313  1     4.75    0.029 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```
## Analysis of Deviance Table
## 
## Model 1: match ~ stemjoblqc + stemjobcountc + f_sex + f_race + f_fb + 
##     agec + I(agec^2) + f_race:f_fb + stemjoblqc:f_race + stemjoblqc:f_sex
## Model 2: match ~ stemjoblqc + stemjobcountc + f_sex + f_race * f_fb + 
##     agec + I(agec^2) + stemjoblqc:f_race + stemjoblqc:f_sex + 
##     stemjoblqc:f_fb
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1     92630      64313                     
## 2     92629      64313  1    0.062      0.8
```

```
## Analysis of Deviance Table
## 
## Model 1: match ~ stemjoblqc + stemjobcountc + f_sex + f_race + f_fb + 
##     agec + I(agec^2) + f_race:f_fb + stemjoblqc:f_sex + stemjoblqc:f_fb
## Model 2: match ~ stemjoblqc + stemjobcountc + f_sex + f_race * f_fb + 
##     agec + I(agec^2) + stemjoblqc:f_race + stemjoblqc:f_sex + 
##     stemjoblqc:f_fb
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)  
## 1     92632      64324                       
## 2     92629      64313  3     10.7    0.013 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```
## 
## 
##    base      sex   nativity     race      all
## -------  -------  ---------  -------  -------
##  141591   141598     141600   141612   141631
```

So, again, results are mixed. Looking at the Wald tests (in the previous section) each interaction term has some explanatory power --or, rather some subsets of each do. But the overall model fit is *worse* with all the interactions in. And the best fitting model overall is the one with no interactions.  

I suspect that with our reduced number of observations (now down to ~ 93,000) with some really small cell sizes (e.g. foreign born black women with a STEM degree) the BIC is telling us that we do not have enough data to make a strong case for the effects we see with the coefficients. 


# Predicted probabilities

(not shown)


