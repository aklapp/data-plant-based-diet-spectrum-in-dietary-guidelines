/**********************************************
Online supplementary material: Stata do-file

Paper running title: Plant-based diet spectrum in dietary guidelines
Paper title: A global analysis of national dietary guidelines' level of encouragement of balanced food choices by integrating advice on plant-based diets and substitutions for animal-based foods
Authors: Anna-Lena Klapp, Nico Feil, Antje Risius

Do-file author: Nico Feil
Last edit of this do-file: 1 May 2022
Last change to analysis: 22 December 2021

Description: Our paper analyzes the Food-Based Dietary Guidelines of 100 countries and subnational administrations. We created various codings for each guideline, which we aggregated into an index. In this do-file, we regressed this index on six explanatory variables, and tested for the OLS inference assumptions, also known as classical linear assumptions: homoskedasticity, normally distributed residuals.
***********************************************/


*Setup
*We used outreg2 to export our results. If you do not have it, install it like so:
ssc install outreg2

*Set working directory for outreg2
cd xx

*Load the dataset
import delimited "xx", varnames(2) numericcols(_all)
* Recode missing values:
mvdecode _all, mv(-99)




/*Step 1: Residual analysis: Normally distributed residuals assumption
*We first ran all models below and tested for normally distributed residuals (predicted minus actual index variable), in SPSS. The Shapiro-Wilk and Kolmogorov-Smirnov tests indicated that (only) model 2 did _not_ have normally distributed residuals. To remedy this, we analysed the distributions of the explanatory variables. We noticed that the Page length variable had a positively skewed distribution (due to a few outlier guidelines with very high page counts). We tried a few transformations and found that taking the square root of Page length normalised this variable enough for all models to pass the Shapiro-Wilk and Kolmogorov-Smirnov tests.*/




/*Step 2: White tests for heteroskedasticity and regression results
OLS regressions using our for models with regular standard errors, followed each by a White test for heteroskedasticity.*/ 
*Model (1), regular standard errors
reg bfci prod_meat prod_dairy last_update pages_sqrt
imtest,white /*does not reject homoskedasticity*/
outreg2 using MainRegs, excel append ctitle(Model 1) stats(coef ci pval) dec(1) pdec(3) side

*Model (2), regular standard errors
reg bfci epi last_update pages_sqrt
imtest,white /*does not reject homoskedasticity*/
outreg2 using MainRegs, excel append ctitle(Model 2) stats(coef ci pval) dec(1) pdec(3) side

*Model 3, regular standard errors, not reported
reg bfci prod_meat prod_dairy epi last_update pages_sqrt
imtest, white /*rejects homoskedasticity, so we need robust standard errors*/
*Model (3), robust standard errors
reg bfci prod_meat prod_dairy epi last_update pages_sqrt, robust
outreg2 using MainRegs, excel append ctitle(Model 3) stats(coef ci pval) dec(1) pdec(3) side




/*Step 3: Did missing values lead to biased sample?
Due to missing external data (FAOSTAT, Yale EPI), some models had more missing data than others, leading to the exclusion of some countries from these regressions. This led to the question if the country samples are comparable between the different regressions. A simple estimate of this is the mean of the outcome variable in each sample. We compute index (outcome variable) means (arithm. avg.) in the three models with missing values:
*/
*Model 1
mean bfci if prod_meat !=. & prod_dairy !=.
outreg2 using BiasCheck, ci excel replace ctitle(Model 1)
*Model 2
mean bfci if epi !=.
outreg2 using BiasCheck, ci excel append ctitle(Model 2)
*Model 3
mean bfci if prod_meat !=. & prod_dairy !=. & epi !=.
outreg2 using BiasCheck, ci excel append ctitle(Model 3)




/*Step 4: Additional regressions (4)-(8)
These are the supplementary regressions with low-quality data in the supplementary data (see details in the methods section). We published them in supplementary material S7.*/
******

*Model (4), regular standard errors
reg bfci gdp_capita last_update pages_sqrt
imtest,white /*does not reject homoskedasticity*/
outreg2 using AddRegs, excel append ctitle(Model 4) stats(coef ci pval) dec(1) pdec(3) side

*Model (5), regular standard errors
reg bfci prod_cereal prod_vegetables last_update pages_sqrt
imtest,white /*does not reject homoskedasticity*/
outreg2 using AddRegs, excel append ctitle(Model 5) stats(coef ci pval) dec(1) pdec(3) side

*Model (6), regular standard errors
reg bfci prod* last_update pages_sqrt
imtest,white /*does not reject homoskedasticity*/
outreg2 using AddRegs, excel append ctitle(Model 6) stats(coef ci pval) dec(1) pdec(3) side

*Model 7, regular standard errors, not reported
reg bfci vegetarians last_update pages_sqrt
imtest,white /*rejects homoskedasticity, so we need robust standard errors*/
*Model (7), robust standard errors
reg bfci vegetarians last_update pages_sqrt, robust
outreg2 using AddRegs, excel append ctitle(Model 7) stats(coef ci pval) dec(1) pdec(3) side


*Model 8, regular standard errors, not reported
reg bfci prod_meat prod_dairy vegetarians epi last_update pages_sqrt
imtest,white /*rejects homoskedasticity, so we need robust standard errors*/
*Model (8), robust standard errors
reg bfci prod_meat prod_dairy vegetarians epi last_update pages_sqrt, robust
outreg2 using AddRegs, excel append ctitle(Model 8) stats(coef ci pval) dec(1) pdec(3) side