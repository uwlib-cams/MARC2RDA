import pandas as pd
import os
import csv

def createMainSheet(fileList):
    csvList = []
    for f in fileList:
        csvList.append(pd.read_csv(f, sep='\t', low_memory=False, encoding= 'unicode-escape'))
    csvMerged = pd.concat(csvList, ignore_index=True)
    sourceFile = csvMerged.to_csv('mergedSheet.csv', index=False)

def createConditionSheet(merged):
    with open(merged, newline='') as sheet:
        sheet_reader = csv.DictReader(sheet, delimiter=',')
        with open('conditionSheet.csv', mode='w') as final:
            fieldnames=['Field', 'condition1', 'c1-values', 'condition2', 'c2-values']
            writer = csv.DictWriter(final, fieldnames=fieldnames)
            writer.writeheader()
            for row in sheet_reader:
                if row['MARCTagCondition1']:
                    writer.writerow({'Field': row['MARCField'], 'condition1': row['MARCTagCondition1'], 'c1-values': row['Condition1Values'], 'condition2': row['MARCTagCondition2'], 'c2-values': row['Condition2Values']})

createMainSheet(['../../00X.txt', '../../0XX.txt', '../../1XX.txt', '../../2XX.txt', '../../3XX.txt', '../../4XX.txt', '../../5XX.txt', '../../6XX.txt', '../../7XX.txt', '../../8XX.txt', '../../LDR-DIR.txt'])
createConditionSheet('mergedSheet.csv')