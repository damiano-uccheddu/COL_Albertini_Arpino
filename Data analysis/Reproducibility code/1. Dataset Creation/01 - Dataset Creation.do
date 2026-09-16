*>> Set seed
	if missing("$MASTER_RUNNING") {
		set seed 7212622 // Set seed if running independently
		di "Independent run"
	}
	else {
		di "Master do-file running." // skip if master is running.
	}

*----	[  1. Preliminary operations ]---------------------------------------------------------------------------*

display "$S_DATE $S_TIME"


* ======================================================================= * 
*	Log file
* ======================================================================= * 

cap log close 
log using "$log_folder/Data Creation.log", replace




*----   [  2. Extract & Recode Variables from technical_variables ]----------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_technical_variables.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_technical_variables.dta", clear
		
		* 	Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* 	Display the frequency distribution of the 'wave' variable
		fre wave  

		* 	Save the processed dataset in a designated output directory
		compress 
		save "${share_all_out}/sharew`w'_technical_variables.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}


*----	[  3. Extract & Recode Variables from CH ]---------------------------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_ch.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_ch.dta", clear
		
		* Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* Display the frequency distribution of the 'wave' variable
		fre wave  

		* Save the processed dataset in a designated output directory
		compress
		save "${share_all_out}/sharew`w'_ch.dta", replace 
	}
	
	* If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}

	* Specific additional processing for the Netherlands in Wave 6 and 7
	if `w' == 6 | `w' == 7 {
		* Check if the Netherlands-specific dataset exists for Wave 6 or 7
		capture confirm file "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_ch.dta"

		* If the Netherlands-specific dataset exists, process it
		if _rc == 0 {
			* Load the Netherlands-specific dataset
			use "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_ch.dta", clear
			
			* Again, create a wave identifier
			gen wave = `w'
			
			* Save the Netherlands-specific dataset
			compress
			save "${share_all_out}/sharew`w'_ch_NL.dta", replace
		}
		else {
			* Display an error message if the Netherlands dataset for the wave does not exist
			di as error "Netherlands dataset for Wave `w' not found. Skipping..."
		}
	}
}


*----	[  4. Extract & Recode Variables from gv_isced ]---------------------------------------------------------*

*>> Define all waves to be processed
global waves "1 2 4 5 6 7 8 9"

* Loop through each wave in the global 'waves' list
foreach w of global waves {
	* Display which wave is currently being processed
	di as result "Processing Wave: " as txt "`w'"
	
	* Check if the dataset for the current wave exists
	* 'capture confirm file' suppresses error and checks file existence
	capture confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_isced.dta"
	
	* If the file exists (_rc == 0), execute the following block
	if _rc == 0 {
		* Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_isced.dta", clear
		
		* Create a new variable 'wave' to identify the data's wave number
		gen wave = `w'
		
		* Save the processed dataset to a specified output directory
		compress
		save "${share_all_out}/sharew`w'_gv_isced.dta", replace
	}
	else {
		* Display an error message if the file for the current wave does not exist
		di as error "File for Wave `w' not found. Skipping..."
	}

	* Specific additional processing for the Netherlands in Wave 6 and 7
	if `w' == 6 | `w' == 7 {
		* Check if the Netherlands-specific dataset exists for Wave 6 or 7
		capture confirm file "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_gv_isced.dta"

		* If the Netherlands-specific dataset exists, process it
		if _rc == 0 {
			* Load the Netherlands-specific dataset
			use "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_gv_isced.dta", clear
			
			* Again, create a wave identifier
			gen wave = `w'
			
			* Save the Netherlands-specific dataset
			compress
			save "${share_all_out}/sharew`w'_gv_isced_NL.dta", replace
		}
		else {
			* Display an error message if the Netherlands dataset for the wave does not exist
			di as error "Netherlands dataset for Wave `w' not found. Skipping..."
		}
	}
}

*----	[  4. Extract & Recode Variables from gv_children ]---------------------------------------------------------*

*>> Define all waves to be processed
global waves "1 2 4 5 6 7 8 9"

* Loop through each wave in the global 'waves' list
foreach w of global waves {
	* Display which wave is currently being processed
	di as result "Processing Wave: " as txt "`w'"
	
	* Check if the dataset for the current wave exists
	* 'capture confirm file' suppresses error and checks file existence
	capture confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_children.dta"
	
	* If the file exists (_rc == 0), execute the following block
	if _rc == 0 {
		* Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_children.dta", clear
		
		* Create a new variable 'wave' to identify the data's wave number
		gen wave = `w'
		
		* Save the processed dataset to a specified output directory
		compress
		save "${share_all_out}/sharew`w'_gv_children.dta", replace
	}
	else {
		* Display an error message if the file for the current wave does not exist
		di as error "File for Wave `w' not found. Skipping..."
	}

	* Specific additional processing for the Netherlands in Wave 6 and 7
	if `w' == 6 | `w' == 7 {
		* Check if the Netherlands-specific dataset exists for Wave 6 or 7
		capture confirm file "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_gv_children.dta"

		* If the Netherlands-specific dataset exists, process it
		if _rc == 0 {
			* Load the Netherlands-specific dataset
			use "${share_w`w'_NL_in}/NL_mmExp_sharew`w'_rel1-1-0_gv_children.dta", clear
			
			* Again, create a wave identifier
			gen wave = `w'
			
			* Save the Netherlands-specific dataset
			compress
			save "${share_all_out}/sharew`w'_gv_children_NL.dta", replace
		}
		else {
			* Display an error message if the Netherlands dataset for the wave does not exist
			di as error "Netherlands dataset for Wave `w' not found. Skipping..."
		}
	}
}

*----	[  5. Extract & Recode Variables from SP ]---------------------------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_sp.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_sp.dta", clear
		
		* 	Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* 	Display the wave variable
		fre wave

			*>> Received help from children (outside hh) – personal care; practical household help; help with paperwork
			if (wave == 1 | wave == 2 | wave == 5) { // Only execute this block for these waves

				forvalues i = 10/18 {
					gen 	ch_help_out_hh_`=`i'-9' = 0
					replace ch_help_out_hh_`=`i'-9' = 1 if ///
						sp003_1 == `i' | ///
						sp003_2 == `i' | ///
						sp003_3 == `i'
				}

				*>> Received help with personal care from: child # 
				forvalues i = 1/9 {
					local varnum = `i' + 9
					gen 	ch_pcare_hh_`i' = 0
					replace ch_pcare_hh_`i' = 1 if sp021d`varnum' == 1
				}
			}


			*>> Received help with personal care from: child # 
			if (wave == 6) { // Only execute this block for these waves (wave == 6)
				forvalues i = 1/20 {
					gen 	ch_help_out_hh_`i' = 0
					replace ch_help_out_hh_`i' = 1 if sp027_1 == `i' | sp027_2 == `i' | sp027_3 == `i'
				}

			*>> Received help with personal care from: child # 
				forvalues i = 1/20 {
					gen 	ch_pcare_hh_`i' = 0
					replace ch_pcare_hh_`i' = 1 if sp033_1 == `i' | sp033_2 == `i' | sp033_3 == `i'  | sp033_4 == `i'
				}
			}

			*>> Received help with personal care from: child # 
			if (wave == 7 | wave == 8 | wave == 9) { // Only execute this block for these waves (wave == 6)
				forvalues i = 1/20 {
					gen 	ch_help_out_hh_`i' = 0
					replace ch_help_out_hh_`i' = 1 if sp027_1 == `i' | sp027_2 == `i' | sp027_3 == `i'
				}

			*>> Received help with personal care from: child # 
				forvalues i = 1/20 {
					gen 	ch_pcare_hh_`i' = 0
					replace ch_pcare_hh_`i' = 1 if sp033_1 == `i' | sp033_2 == `i' | sp033_3 == `i'  | sp033_4 == `i' ///
						| sp033_5 == `i' | sp033_6 == `i'  | sp033_7 == `i'
				}
			}

		* 	Save the processed dataset in a designated output directory
		compress
		save "${share_all_out}/sharew`w'_sp.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}




*----	[  6. Extract & Recode Variables from CV_R ]-------------------------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_cv_r.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_cv_r.dta", clear
		
		* 	Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* 	Display the frequency distribution of the 'wave' variable
		fre wave  

		*	Recode gender 
		fre gender 
		recode gender 2=1 1=0, gen(female)

		*	Labels 
		// lab var fam_resp		"Family respondent"
		lab var female 			"Gender: female=1, male=0"
		lab var hhid`w'			"Household identifier wave `w'"
		lab var hhsize			"Household size"
		// lab var hou_resp		"Household respondent"
		lab var int_month		"Interview month"
		lab var int_year		"Interview year"
		lab var partnerinhh		"Partner in household"
		lab var wave        	"Wave"
		lab def female 			1 "female" 0 "male"
		lab val female female

		* 	Drop one variable 
		cap drop coupleid8_update_ca

		* 	Save the processed dataset in a designated output directory
		compress
		save "${share_all_out}/sharew`w'_cv_r.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}


*----	[  7. Extract & Recode Variables from GV_Imputations ]---------------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_imputations.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_gv_imputations.dta", clear
		
		*>> Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		*>> Number of children 
			*	Mean value for the number of children (based on the 5 SHARE imputed datasets)
			bys mergeid: egen nchild_mean = mean(nchild) if nchild >= 0
			fre nchild_mean 
			sum nchild_mean 
			
			*	Round the variable
			gen nchild_rounded = round(nchild_mean, 1)
			fre nchild_rounded
			sum nchild_rounded
		 
		*>> Income  
			*	Mean value for income (based on the 5 SHARE imputed datasets)
			bys mergeid: egen income_mean = mean(thinc)
			sum income_mean 
			
		*>> Wealth   
			*	Mean value for income (based on the 5 SHARE imputed datasets)
			bys mergeid: egen wealth_mean = mean(hnetw)
			sum wealth_mean 

		*>> We only keep one out of the five implicats:
		keep if implicat==1 

		* 	Save the processed dataset in a designated output directory
		compress
		save "${share_all_out}/sharew`w'_gv_imputations.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}


*-----------------------------------------------------------------------------------------------* 
*>> Extract & Recode Variables from CF
*-----------------------------------------------------------------------------------------------* 

*	Wave  3 has no information on cognitive functioning -> I have exluded this wave from the loop

global w "1 2 4 5 6 7 8 9"
foreach w in $w {
	di as result "Wave: " as txt "`w'"
	use "${share_w`w'_in}/sharew`w'_rel9-0-0_cf.dta", clear 	// Open the dataset  
	gen wave=`w'														// Create wave id 

		*	Check for proxy interview variable 
		cap confirm variable cf719_
		if _rc {
			di as error "Variable cf719_ is missing in Wave `w'"
		}
		else {
			tab cf719_, miss
		}

		*	Personal identifier & keep variables	
		keep 		///
		wave 		/// 
		mergeid		/// Person identifier (fix across modules and waves)
		cf* 		/// Information on proxy interviews (and other CF variables)

	*	Save
	compress
	save "${share_all_out}/sharew`w'_cf.dta", replace 
}


*----	[  8. Extract & Recode Variables from DN ]---------------------------------------------------------------*

*>> Define a list of all waves to be processed
global w "1 2 3 4 5 6 7 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_dn.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_dn.dta", clear
		
		* 	Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* 	Display the frequency distribution of the 'wave' variable
		fre wave  

		* 	Save the processed dataset in a designated output directory
		compress
		save "${share_all_out}/sharew`w'_dn.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}


*----	[  9. Extract & Recode Variables from SN ]---------------------------------------------------------------*

*>> Define a list of all waves to be processed
global w "4 6 8 9"

*>> Loop through each wave defined in the global list
foreach w in $w {

	*	Display the current wave number being processed
	di as result "Wave: " as txt "`w'"
	
	*	Check if the dataset for the current wave exists in the specified directory
	*		The 'capture' command suppresses the error message if the file is not found
	*		The 'confirm file' command checks for the existence of the file
	cap confirm file "${share_w`w'_in}/sharew`w'_rel9-0-0_sn.dta"
	
	*	If the file exists (_rc == 0), then execute the following block
	if _rc == 0 { // "_rc" is a system variable that stores the return code of the last command executed
		
		* 	Load the dataset for the current wave
		use "${share_w`w'_in}/sharew`w'_rel9-0-0_sn.dta", clear
		
		* 	Generate a variable 'wave' and assign it the current wave number
		gen wave=`w'

		* 	Display the frequency distribution of the 'wave' variable
		fre wave  

		if wave == 4 {
			* Create sn_child_loop_* variables
			forvalues i = 1/7 {
				generate byte sn_child_loop_`i' = .
				format sn_child_loop_`i' %13.0g
			}

			* Create sn_childid_* variables
			forvalues i = 1/7 {
				generate str14 sn_childid_`i' = ""
				format sn_childid_`i' %14s
			}

		}

		* 	Save the processed dataset in a designated output directory
		save "${share_all_out}/sharew`w'_sn.dta", replace 
	}
	
	* 	If the file does not exist, display an error message and skip to the next wave
	else {
		di as error "File for Wave `w' not found. Skipping..."
	}
}



*---- [ 10. Merge modules per wave ]---------------------------------------------------------------------------*

* Define all waves to be processed
global waves "1 2 4 5 6 7 8 9"

* Loop through each wave
foreach w of global waves {
	
	* Load the main dataset (coverscreen) for the current wave 
	use "$share_all_out/sharew`w'_cv_r.dta", clear 

	* Adjust dataset list based on wave availability for gv_children
	local datasets "cf ch dn gv_imputations gv_isced sp"

	if `w' >= 4 & `w' <= 9 {
		local datasets "`datasets' gv_children" // Include gv_children only for waves 4, 5, 6, 7, 8, 9
	}

	* Include SN module for waves 4, 6, 8, and 9
	if inlist(`w', 4, 6, 8, 9) {
		local datasets "`datasets' sn"
	}
	
	local datasets "`datasets' technical_variables" // Continue adding other datasets
	
	* Merge with other datasets for the same wave
	foreach dataset in `datasets' {
		
		* Merge each module dataset with the main dataset
		merge 1:1 mergeid using "$share_all_out/sharew`w'_`dataset'.dta"

		* Check merge results and keep only matched observations
		tab _merge
		keep if _merge == 3 | _merge == 1
		drop _merge
	}

	* Special processing for the Netherlands in Wave 6 and 7 (gv_isced)
	if `w' == 6 | `w' == 7 {
		* Merge the Netherlands specific dataset
		merge 1:1 mergeid using "$share_all_out/sharew`w'_gv_isced_NL.dta"

		* Check merge results and keep only matched observations
		tab _merge
		keep if _merge == 3 | _merge == 1
		drop _merge
	}

	* Special processing for the Netherlands in Wave 6 (gv_children)
	if `w' == 6 {
		* Merge the Netherlands specific dataset
		merge 1:1 mergeid using "$share_all_out/sharew`w'_gv_children_NL.dta"
		* Check merge results and keep only matched observations
		tab _merge
		keep if _merge == 3 | _merge == 1
		drop _merge
	}

	* Special processing for the Netherlands in Wave 6 and 7 (ch)
	if `w' == 6 | `w' == 7 {
		* Merge the Netherlands specific dataset
		merge 1:1 mergeid using "$share_all_out/sharew`w'_ch_NL.dta"
		* Check merge results and keep only matched observations
		tab _merge
		keep if _merge == 3 | _merge == 1
		drop _merge
	}

	* Sort the dataset by mergeid and wave 
	sort mergeid wave 

	* Create parent-child dyadic IDs
	dyadic_ids

	* Save the final merged dataset at the person-wave level (with dyad_* variables)
	compress
	save "$share_all_out/sharew`w'_merged_a.dta", replace
}


*----	[ 11. Append waves to panel long format ]----------------------------------------------------------------*

*	Append single wave files to one long file:
use          "$share_all_out/sharew1_merged_a.dta", clear
append using "$share_all_out/sharew2_merged_a.dta"
append using "$share_all_out/sharew4_merged_a.dta", force 
append using "$share_all_out/sharew5_merged_a.dta"
append using "$share_all_out/sharew6_merged_a.dta", force
append using "$share_all_out/sharew7_merged_a.dta"
append using "$share_all_out/sharew8_merged_a.dta", force
append using "$share_all_out/sharew9_merged_a.dta", force 
append using "$share_wX_cv/sharewX_rel9-0-0_gv_allwaves_cv_r.dta"

// (!) Please note: some sn_childid_* variables may have type mismatches across waves (e.g., byte vs string).
// 					The "force" option is used below to ignore this numeric/string mismatch.
// 					The using variable would then be treated as if it contained numeric missing value.

*----	[ 12. Final Save ]-–––––––––––––––––––––––––––––––––––––––––---------------------------------------------*

*>> Remove any notes
notes drop _dta

*>> Compress the dataset 
compress

*>> Sort the dataset 
sort mergeid wave

*>> Final Save 
save "$share_all_out/SHARE_LONG.dta", replace

*>> Timer 
display "$S_TIME  $S_DATE"
timer off 1
timer list 1

*>> Close the log file
log close
