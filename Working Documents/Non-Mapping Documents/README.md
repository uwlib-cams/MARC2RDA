# Google Sheets to GitHub Workflow

[zippedExcel2csv.py](https://github.com/uwlib-cams/MARC2RDA/blob/main/Working%20Documents/Non-Mapping%20Documents/zippedExcel2csv.py) is used to upload mapping tables from Google Sheets to the MARC2RDA GitHub repository as csv files. 

## Dependencies
This script may be run in Linux or Windows and requires the following dependencies: 
* [pandas](https://pandas.pydata.org/)
    * can be installed using `pip install pandas`
* [openpyxl](https://openpyxl.readthedocs.io/en/stable/)
    * can be installed using `pip install openpyxl`

## Procedure
1. Go to Mapping Documents top directory in Google Sheets
2. Select ALL (all folders that is, but not "Non-Mapping Materials" -- only folders named after MARC fields)
3. Download
4. Run the Python script, which will prompt you to enter values for:
   * `downloadPath` - path to .zip folder containing downloaded Google Sheets
   * `gitRepo` - path to local copy of MARC2RDA GitHub repository
5. Manually delete the downloaded .zip file
6. Go to local GitHub repo and manually add, commit, push the updated csv files 

## Details

The Python script performs the following steps:
1. Checks that the input paths are valid paths
2. Sets a path for a temporary folder to process Google Sheets inside (this will be deleted by the script later on)
3. Sets a path for the csv folder within the local MARC2RDA GitHub repo
4. Unzips the downloaded Google Sheets .zip folder into the temporary folder
5. Converts all of the .xlsx files into .csv files and renames them to remove the .xlsx extension
6. Moves all of the .csv files from the temporary folder into the csv folder within the local MARC2RDA GitHub repo
7. Deletes the temporary folder

### Inputs

#### downloadPath
`downloadPath` is used by the script to access the downloaded Google Sheets. This path must lead to a .zip folder.
See the following examples: 
* Linux: `/mnt/c/Users/cpayn/Downloads/drive-download-20240522T012037Z-001.zip`
* Windows: `c:\Users\cpayn\Downloads\drive-download-20240522T012037Z-001.zip`

#### gitRepo
`gitRepo` is used by the script to move the processed CSV files into the local copy of the MARC2RDA GitHub repository. This path must end in 
/MARC2RDA
See the following examples:
* Linux: `/mnt/c/move/linked_data/MARC2RDA `
* Windows: `c:\Move\linked_data\MARC2RDA`