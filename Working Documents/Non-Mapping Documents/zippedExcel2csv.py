import zipfile, os, glob, shutil
import pandas as pd

#Procedure:
#1. Go to Mapping Documents top directory in Google Sheets
#2. Select ALL (all folders that is)
#3. Download
#4. Enter var values for python script (at present the way this is done varies for the vars):
#   downloadPath
#   downloadFile
#   extractPath
#   dir
#   gitRepo
#5. Run
#6. Manually delete:
#    downloadFile
#7. Go to git repo and manually add, commit, push

downloadPath = r"C:\Users\geron\Downloads\\"
downloadFile = "drive-download-20220610T170324Z-001.zip"
extractPath = r"C:\Users\geron\OneDrive\Desktop\csvStage_folders\\"
dir = r"C:\Users\geron\OneDrive\Desktop\csvStage_files"
gitRepo = r"C:\Users\geron\OneDrive - UW\Documents\gitRepos\MARC2RDA\Working Documents\Draft Field By Field Spreadsheets\csv"

#extract all dir/files downloaded from Sheets
with zipfile.ZipFile(downloadPath + downloadFile,"r") as zip_ref:
    zip_ref.extractall(extractPath)

#move all .xlsx files out of Sheets directories into a common directory
for name in glob.glob(extractPath + '*\\*'):
    if name.endswith(".xlsx"):
        shutil.copy(name, dir)

#convert .xlsx to .csv and remove the .xlsx files
for file in glob.glob(dir + "\\" + "*.xlsx"):
    excel = pd.read_excel(file)
    excel.to_csv(file + '.csv' )
    os.remove(file)

#strip .xlsx from file name
for fi in glob.glob(dir + '\\' + '*.csv'):
    new_name = fi.replace('.xlsx','')
    os.rename(fi, new_name)

#src = r"C:\Users\geron\OneDrive\Desktop\testing2-sheets2csv-ok2del"
for f in os.listdir(dir):
    startFile = dir + '\\' +  f
    finalFile = gitRepo + '\\' + f
    if os.path.isfile(startFile):
        shutil.move(startFile, finalFile)

#Delete local dir containing all unzipped Excel files in original Google Sheets directory structure
deletePath = extractPath + "*"
dirs = glob.glob(extractPath + '*')
for d in dirs:
    shutil.rmtree(d)

#Possible additional steps:
#1.	Delete Google Sheets zip download in local Downloads
    #os.remove(r"C:\Users\geron\Downloads\drive-download-20220521T180108Z-001.zip")
#2.	git add/commit/push -- best to retain full control of this? i.e. do it manually


