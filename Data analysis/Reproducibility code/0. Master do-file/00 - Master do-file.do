* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ *
* >
* > Stata Version & Preliminary Settings
* >
* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ * 

*>> Clear results window
cls

cap log close 

*>> Stata version 
version 19.5

*>> Debug mode
pause on 

*>> Clear and other settings 
clear
clear matrix
clear mata 
set max_memory .
set maxvar 32767, perm 
set logtype text
set more off

*>> Set seed + check that master is running
set seed 7212622
global MASTER_RUNNING 1  // <-- check


* ======================================================================= *
* Program to count number of individuals in the data
* ======================================================================= * 

cap program drop count_ind
program define count_ind
cap drop unique_pid
egen unique_pid = tag(pid)
count if unique_pid == 1
end


* ======================================================================= *
* Macro's for file save locations
* ======================================================================= * 

*>> Set username macro
global username "`c(username)'"

*>> Global macro (insert here the working folder where the replication material is stored)
global working_folder 		"C:/Users/$username/Dropbox/_Research_/_Active_Projects_/COL_Albertini_Arpino/Data analysis/Reproducibility code"
global dataset_in 			"A:/Encrypted datasets/Source"
global dataset_out			"A:/Encrypted datasets/Derived/COL_Albertini_Arpino"

*>> Folder in which I have the other do-files
global dataset_creation 		"$working_folder/1. Dataset Creation"
global dataset_cleaning 		"$working_folder/2. Data Cleaning"
global main_analysis 			"$working_folder/3. Main Analysis"

*>> Log files 
global log_folder 		"C:/Users/$username/Dropbox/_Research_/_Active_Projects_/COL_Albertini_Arpino/Data analysis/Output folder/Log folder"

*>> Dataset input
global share_w1_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew1_rel9-0-0_ALL_datasets_stata" 
global share_w2_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew2_rel9-0-0_ALL_datasets_stata"
global share_w3_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew3_rel9-0-0_ALL_datasets_stata"
global share_w4_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew4_rel9-0-0_ALL_datasets_stata" 
global share_w5_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew5_rel9-0-0_ALL_datasets_stata"
global share_w6_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew6_rel9-0-0_ALL_datasets_stata"
global share_w6_NL_in 	"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/NL_mmExp_sharew6_rel1-1-0_ALL_datasets_stata"
global share_w7_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew7_rel9-0-0_ALL_datasets_stata"
global share_w7_NL_in 	"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/NL_mmExp_sharew7_rel1-1-0_ALL_datasets_stata"
global share_w8_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew8_rel9-0-0_ALL_datasets_stata"
global share_w9_in 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharew9_rel9-0-0_ALL_datasets_stata"
global share_wX_cv 		"A:/Encrypted datasets/Source/SHARE/Release 9.0.0/sharewX_rel9-0-0_gv_allwaves_cv_r_stata"


*>> Dataset output
global share_all_out		"$dataset_out/W_All"

*>> Tables and Figures
global tables_out 			"$working_folder/Output folder/Tables"  //<- here tables from "esttab" command
global figure_out 			"$working_folder/Output folder/Figures" //<- here graphs and figures



* ======================================================================= *
* Do-files
* ======================================================================= * 

*>> 	Dataset Creation
do "$dataset_creation/01 - Dataset Creation.do"

*>> 	Data Cleaning
do "$dataset_cleaning/[FRS-FNRS_PER] - 02 - Second Paper - Data Cleaning.do"

*>> 	Main analysis
do "$main_analysis/[FRS-FNRS_PER] - 02 - Second Paper - Main Analysis.do"



* ======================================================================= *
* Timer
* ======================================================================= * 

* 	Stop the timer
timestamp_stop

*>> Append to the log file 
cap log close 
log using "$log_folder/Timer.log", append

* 	Close eventually open logs
cap log close
