import zipfile, os, glob, shutil, re
import pandas as pd

#Procedure:
#1. Go to Mapping Documents top directory in Google Sheets
#2. Select ALL (all folders that is, but not "Non-Mapping Materials" -- only folders named after MARC fields)
#3. Download
#4. Run Python script which will prompt youto enter values for:
#   downloadPath - path to .zip folder containing downloaded Google Sheets
#   gitRepo - path to local copy of MARC2RDA git repo
#5. Manually delete:
#    downloadFile
#6. Go to git repo and manually add, commit, push

# downloadPath e.g. /mnt/c/Users/cpayn/Downloads/drive-download-20240522T012037Z-001.zip or c:\Users\cpayn\Downloads\drive-download-20240522T012037Z-001.zip
downloadPath = input('''Enter path to downloaded .xslx folder (this should end in .zip):
                     ''')
# gitRepo e.g. /mnt/c/move/linked_data/MARC2RDA or c:\Move\linked_data\MARC2RDA
gitRepoInput = input('''Enter path to your local copy of the MARC2RDA GitHub Repo (this should end in /MARC2RDA):
               ''')

#set temporary extractPath for unzipping and editing files
extractPath =  re.sub('.zip', '', downloadPath) + "-temp/"
#set path to csv folder in MARC2RDA repo
gitRepo = gitRepoInput + "/Working Documents/Draft Field By Field Spreadsheets/csv"

# check that input paths for downloadPath and gitRepo exist
if not(os.path.exists(downloadPath)):
    print("Please doublecheck path to .xlsx folder and rerun.")
    exit()

if not(os.path.exists(gitRepo)):
    print("Please doublecheck path to local GitHub repo and re-run.")
    exit()

#extract all dir/files downloaded from Sheets
print('Extracting files from zip folder\n')
with zipfile.ZipFile(downloadPath,"r") as zip_ref:
    zip_ref.extractall(extractPath)

#convert .xlsx to .csv and remove the .xlsx files
print('Converting files to csv\n')
for file in glob.glob(extractPath + "*/*.xlsx"):
    excel = pd.read_excel(file)
    excel.to_csv(file + '.csv' )
    os.remove(file)

#strip .xlsx from file name
print("Renaming files\n")
for fi in glob.glob(extractPath + '*/*.csv'):
    new_name = fi.replace('.xlsx','')
    os.rename(fi, new_name)

# move files to GitHub repo
print("moving files")
for folder in os.listdir(extractPath):
    for f in os.listdir(extractPath + '/' + folder):
        startFile = extractPath + '/' +  folder + '/' + f
        print(startFile)
        finalFile = gitRepo + '/' + f
        if os.path.isfile(startFile):
            shutil.move(startFile, finalFile)
            finalFile = gitRepo + '/' + f

# Delete local dir containing all unzipped Excel files in original Google Sheets directory structure
print("Deleting temp folder")
deletePath = extractPath + "*"
dirs = glob.glob(extractPath + '*')
for d in dirs:
    shutil.rmtree(d)
shutil.rmtree(extractPath)

#Possible additional steps:
#1.	Delete Google Sheets zip download in local Downloads
    #os.remove(r"C:\Users\geron\Downloads\drive-download-20220521T180108Z-001.zip")
#2.	git add/commit/push -- best to retain full control of this? i.e. do it manually


