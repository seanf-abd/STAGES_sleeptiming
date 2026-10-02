# README:Investigating Associations Between Different Sleep Timing Variability Metrics and their Relationships with Polysomnography-Derived Measures of Sleep Architecture
>This document has been structured to mirror templates published in Zieliński, T., Hodge, J. J. L., & Millar, A. J. (2023). Keep It Simple: Using README Files to Advance Standardization in Chronobiology. Clocks & Sleep, 5(3), 499-506. https://doi.org/10.3390/clockssleep5030033

## General Information on Dataset utilised
-### Summary/Abstract
> A short and contextualized description of the data, containing a brief overview of the the dataset purpose, methods and (if applicable) results.  
> The comprehensives details are to be recorded in sections below. This section should help others to understand the content of the dataset without its thorough examination.
> This section can replace the "Description" section if information overlaps. 
  ### Title of Dataset         
    Stanford Technology Analytics and Genomics in Sleep (STAGES) dataset

  ### Author(s)/Contributor(s)
    Prinicpal Investigator: Dr. Emmanuel Mignot, MD, PhD
    Co-Investigator: Dr. Clete Kushida, MD, PhD
    For information pertaining to dataset contact the National Sleep Research Resource (NSRR) at https://sleepdata.org/pages/about

  ### Date of Creation
    2021-07-01
    
  ### Digitial Object Identifier (DOI)
    https://doi.org/10.25822/me0d-xs45

## Dataset Overview
### Description
This is a secondary data source, freely-obtained from https://sleepdata.org/datasets/stages. Researchers must create an NSRR account and submit a data request in order to gain access to the repository. 

## Usage and Access 
  ### Licence
The STAGES dataset is available for non-commercial and commercial use. Permission is hereby granted, free of charge, to any person obtaining a copy of this analysis code   and associated documentation files (the "analysis code"), to deal in the the analysis without restriction, including without limitation the rights to use,               copy,modify,merge, publish, distribute, sublicense, and/or sell copies of the analysis code, and to permit persons to whom the analysis code is furnished to do so, subject to the following conditions. All I ask is that if you use some of the analysis code for your own research, please cite the original paper. 

## Analysis Code
-### Summary/Abstract
> More information on the dataset is available athttps://sleepdata.org/datasets/stages/pages/README.md
>The aim of this section is to provide an overview of the analysis code utilised in the manuscript

  ### Purpose (Research hypothesis)
  This study sought to investigate the concordance between multiple measures of actigraphy-derived sleep timing variability in a well-characterised cohort of adults. 
  Further, we aimed to examine the relationship between sleep timing variability and sleep architecture (derived from Polysomnography) 

## Data Pre-Processing
  >The .Rmd's have been scripted to run sequentially, they rely on vars obtained from prev sections, thus it is important to run in this order.

  ### 1. STAGES_Workflow.Rmd
   >This code screens valid group of participants for study inclusion. Following this, actigraphy data is cleaned and then sleep timing variability measures were computed.
   The necessity behind this was that the actigraphy data is in .json format and computes a measure of 'activeness' which is some propietary dervied measure of activity. As    such, I had to develop my own pre-processing and analysis pipeline to handle this data. 
  ### 2. PSG_workflow.Rmd
   >This code obtains PSG data from each participant (from the scored .csv's, not the raw .edf's) and derives common assessements of nightly sleep architecture (REM onset
   latency, WASO, TST etc.)
   >If you are performing the sensitivity analysis, the thresholds for certain values (e.g., SOL/% ofN3 sleep etc.) need to be changed to accomodate this.
  ### 3. STAGES_analysis.Rmd
   >The last chunk computes the demographic information for analysis sample(s). The analysis sample is input directly from previous chunk, so ensure that you have selected     correct inclsuion/exclusion criteria. Figures and mixed-models are also created in this chunk.

## Citing the Dataset
>This is where I'd put my citation, if I had a citation that is.
>If there are any issues/bugs, please feel free to create an issue or send me an email!

## Acknowledgements   
>Special thanks to the administrators of the National Sleep Research Resource for the amazing work they do. 
>This research has been conducted using the STAGES - Stanford Technology, Analytics and Genomics in Sleep Resource funded by the Klarman Family Foundation. The investigators of the STAGES study contributed to the design and implementation of the STAGES cohort and/or provided data and/or collected biospecimens, but did not necessarily participate in the analysis or writing of this report. The full list of STAGES investigators can be found at the project website.
>The National Sleep Research Resource was supported by the U.S. National Institutes of Health, National Heart Lung and Blood Institute (R24 HL114473, 75N92019R002).
