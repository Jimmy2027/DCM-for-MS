# DCM-for-MS
TNM Projekt by Hendrik Klug, Damiano Steger, Julia Zahner
ETH Zurich, June 2020

## Data
The data was provided by the Team of Fleischer et al. and can be downloaded form the polybox folder with this link:
https://polybox.ethz.ch/index.php/s/rPqt1FVWXOi6BpK

The password is tnm.

There are 3 folders : MS-new, HC and HCnew 
MSnew contains all the data for all the sessions of the MS patients.
HC contains all the data for the first sessions of the HC.
HCnew contains all the data for the second sessions of the HC.

The data contains time series of 115-AAL regions for 25 MS-patients and 12 healthy controls. There are time series for 5 sessions in MS patients and 2 sessions in HC. All the data is stored in .mat-files.

## Code
All the necessary code can be downloaded by cloning this git repository with the command.

```bash
git clone git@github.com:Jimmy2027/TNU.git
```
When cloning this repository the name of the folder will be 'DCM-for-MS" per default. There is no need to change this name.

Additionaly, the code is relying on the Statistical Parametric Mapping framework (spm12, Wellcome Trust Center for Human Neuroimaging). SPM12 can be downloaded from https://www.fil.ion.ucl.ac.uk/spm/software/spm12/ following the installation guide on https://en.wikibooks.org/wiki/SPM (Make sure you add spm to your MATLAB path!). 


## Preprocessing
Access the data with the link in the 'Data'-section above and place the folder 'Daten' into the folder 'DCM-for-MS', which has been downloaded in the previous step.

To construct the time series for the 7 superordinate regions out of the 115-AAL region time series run the python-script 'collapse_regions.py'. A folder named 'Data_preprocessed' will be generated automatically and contains the data used for the DCM analysis.

## spectral DCM
The file 'run_DCM.m' is used to construct all the DCM files and run the model inversion for all sessions, both groups and both models(fully connected, only self connections). Make sure the folder 'Data_preprocessed' is in the sam directory as the matlab script, before you run it, otherwise the code can not find the files and will get stuck.

The script makes a DCM folder where it saves all the DCM files with the prior parameters and posterior expectations etc.

## Node strength analysis for spectral DCM
After running the model inversion with spectral DCM the script 'plot_EC.m' can be used to calculate all the node strengths with the method described in our report. The function will also directly plot the results over the sessions.

## Second level analysis with PEB for spectral DCM
To calculate the independent effects (Time,Disease and Interaction TIme/Disease) as well as to look for a sparser model PEB was used with a factorial design. 

Befor you run anything make sure that the DCM analysis is complete and the folder 'DCM' exists in your directory.

Run the script 'run_PEB.m' this script calls two functions which construct the group DCM files out of the previously saved files in the DCM folder and runs the PEB.
The PEB files are saved in the 'PEB' folder automatically. The results of the sperser models are Saved in the folder 'BMA'.
The main results as well as the node stregths calculated after PEB averaging are plotted using the functions 'calculate_node_strength.m' and 'plot_data.m'. You don't need to run the two functions since they are already called by the 'run_PEB.m'.

## Regression DCM
The scripts used for the Regression DCM analysis are in the subfolder 'rDCM'. @Damiano beschrieben wie man deinen Code ausführen muss und passe ihn so an dass er auch bei Ihnen läuft.

## Remarks
To succesfully run the code it is essential that you place the 'Daten' folder in the 'DCM-for-MS' directory and follow the workflow described in this read me. Do not delete any automatically created folders since they are used in later steps of the analysis. 

Do only run the scripts mentioned in this read-me the other .m-files are called automatically by the mentioned scripts and are helper functions.

All the code is commented to give you a better understanding of the source code itself, if there should still be questions we are happy to help you :) 

We hope you enjoy our work!




