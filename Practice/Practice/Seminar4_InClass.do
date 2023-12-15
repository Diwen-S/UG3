
***********************************************************
*********************** Seminar 4 *************************
***********************************************************

******* 1. Clustering Standard Errors
******* 2. Models with Binary Outcomes


clear all
cd "YOUR DIRECTORY"

log using "Seminar4_log", replace



******* 1. Clustering Standard Errors

*** import dataset 1
import excel using "aircon1", first


*** estimating the effect of air conditioning on achievement

* start with the simplest model, where assume iid errors
reg y aircon

* adjust SE for potential heteroscedasticity
reg y aircon, vce(robust)
	* no heteroscedasticity built into the data, so results are identical!
	
* adjust SE for clustering at classroom level
reg y aircon, vce(cluster classroom)
	* no group-level shocks built into the data, so results are identical!

	
clear

*** import dataset 2
import excel using "aircon2", first


*** estimating the effect of air conditioning on achievement

* start with the simplest model, where assume iid errors
reg y aircon

* adjust SE for potential heteroscedasticity
reg y aircon, vce(robust)
	* no heteroscedasticity built into the data, so results are identical!

* adjust SE for clustering at classroom level
reg y aircon, vce(cluster classroom)
	* since we have classroom-level shocks here, the SE look very different
	* SE are more than 7 times as large
	* point estimate of beta still significant, but t-stat 7 times smaller



clear
	
	
******* 2. Models with Binary Outcomes

*** import dataset 1
import excel using "titanic", first


*** create a dummy indicator for gender
gen female=0 
replace female=1 if sex=="female"


*** Linear Probability Model (LPM)
reg survived i.female i.pclass age sibsp parch fare, vce(robust)

	* females had a higher probability of surviving
	* passengers from 2nd and 3rd class had lower probabilities of surviving
	* older passengers had lower probabilities of surviving
	* those with siblings or spouses on board had lower prob. of surviving


*** Probit Model
probit survived i.female i.pclass age sibsp parch fare, vce(robust)

	* coefficients give the change in the probit index for a one unit change in the explanatory variable
	* importantly, this is not the same as the marginal effects which depend on the x-variables
	

	
** Marginal effects

	margins, dydx(age) atmeans
		* marginal effect of age when all variables are set to their average
		
	margins, dydx(age)
		* average marginal effect of age (not the same as above!)

	margins, dydx(age) at(female=1) atmeans
		* marginal effect of age for females when all variables are at their average
	
	margins, dydx(age) at(female=1)
		* average marginal effect of age for females (not the same as above!)

		

** 	Predicted probability of survival
	
	** Survival prob. for male/female
	margins female, atmeans
		* keeps all other x-variables at their means
		* females had a predicted prob. of survival of 75%
	
	margins female, at(pclass=1)
		* females in first class had a predicted prob. of survival of 92%
		
	margins female, at(pclass=1 age==10)
		* 10 year old females in first class had a predicted prob. of survival of 97%

	
	** Survival prob. for different age groups
	margins, at(age=(0(10)80))
		* predicted prob. of survival at ages 0, 10, 20, ..., 80
		* 0 year old child had a predicted prob. of survival of 59%
		* 40 year old had a predicted prob. of survival of 36%
		* 80 year old had a predicted prob. of survival of 17%
		
	margins, at(age=(0(10)80) female=1)
		* can look at same prob. as above, but only for females
		
	margins, at(age=(0(10)80) female=1 pclass=1) 
		* can look at same prob. as above, but only for females in first class



log close
translate "Seminar4_log.smcl" "Seminar4_log.pdf", replace
















