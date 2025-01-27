# Running the transformation code

The transform is written in XSLT in order to be free and open-source.

For testing purposes, the code was developed using Oxygen XML.

Instructions are included for running the code using Oxygen or using Saxon HE (open source), either in command line or through a Python script using Java.

## Option 1: Oxygen for development
*For transforming 1 MARC/XML file or 1 folder containing MARC/XML files with no subfolders*

1. Clone the MARC2RDA GitHub repository
2. In Oxygen, create a project and select the entire MARC2RDA repository to be included, along with the folder containing the MARC/XML file(s) to be transformed.
3. Open a file to be transformed. 
4. In the toolbar at the top of Oxygen, select the Configure Transformation Scenario(s) button, which looks like a wrench. 
5. Select “New” at the bottom of the pop-up menu and select "XML transformation with XSLT".
6. Name the transformation scenario.
7. In the XML URL box, ensure the value is ${currentFileURL}
8. In the XSL URL box, select m2r.xsl from files.
9. Select the "Parameters" and edit the BASE value to the base IRI you would like to be used when the transform mints IRIs. Ensure the IRI ends in / to avoid malformed IRIs. 
10. Navigate to the Output tab
11. In the Output tab, find the Save as option.
    
    a. If transforming one file, enter the location and name for the output file. The file name should end in `.rdf` Press okay.
    
    b. If transforming a folder of files, enter the location of a folder for the output, and end the folder name in `/${cfn}.rdf` This saves each file within the folder with the same name as the input file but as an rdf file. Press okay.
    
11. Transform the file(s)
    a. *If transforming 1 file*: Ensuring that the file you want to transform is open in the window, press "Apply associated".
    b. *If transforming a folder of files*: Close the transformation scenario pop-up box. In the navigation pane on the left, right click on the folder containing the files you want to transform. Select "Transform" and then "Transform with...". Select the transformation scenario you just set up and press "Apply selected scenarios". 
12. The transformation scenario should run and output RDF/XML from the MARC/XML


## Option 2: Saxon

### Dependencies
- Java
  - Windows: [download Java](https://www.java.com/en/download/) and ensure PATH is set up correctly
  - WSL: `$ sudo apt install openjdk-11-jre-headless`
- Saxon processor from [Saxonica](https://www.saxonica.com/welcome/welcome.xml)
  - For further documentation: [Getting started with SaxonJ](https://www.saxonica.com/html/documentation11/about/gettingstarted/gettingstartedjava.html)
  - The free Saxon-HE (Home Edition) is available for download from GitHub - see Saxonica/[Saxon-HE](https://github.com/Saxonica/Saxon-HE/) > [releases](https://github.com/Saxonica/Saxon-HE/releases)
  - The Saxon-HE repository README file provides information about current Saxon releases; we run sinopia_maps and map_storage stylesheets using version 11.5 or higher.
- Create `saxon11` folder in Windows or WSL and extract `SaxonHE11.5J.zip` to folder
  - Take note of the full directory path to this `saxon11` folder
- Test: `$ java -cp {path_to_directory}/saxon-he-{saxon_version}.jar net.sf.saxon.Query -t -qs:"current-date()"` and confirm output appears similar to the following:
```
SaxonJ-HE 11.5 from Saxonica
Java version 11.0.20.1
Analyzing query from {current-date()}
Analysis time: 378.7204 milliseconds
<?xml version="1.0" encoding="UTF-8"?>2023-09-20-07:00Execution time: 64.2685ms
Memory used: 11Mb
```

### Option 2a: process.py
*For transforming many MARC/XML files contained in folders and/or subfolders, or 1 MARC/XML file*

#### Python dependencies

- [Python](https://www.python.org/downloads/) for Windows or WSL (recommend v3.8 or above)
- [RDFLib](https://rdflib.readthedocs.io/en/stable/gettingstarted.html)
  - `$ pip install rdflib` [Installing Python packages](https://packaging.python.org/en/latest/tutorials/installing-packages/) may require* `pip3` *in place of* `pip` *for some systems*  

#### Running process.py

In the top level folder, run the python script. You should be prepared with:
- the absolute directory path to where the Saxon processor .jar file is located ready
- the absolute path to the file(s) or folder(s) containing the MARC data in MARC/XML format. These files must end in .xml
- the base IRI you would like IRIs minted by the transform to use. This IRI must end in /

### Option 2b: command line
*For transforming 1 MARC/XML file at a time*

In command line from the MARC2RDA top level folder, run:

```wrap!
java -cp {saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -s:"{input_path}" -xsl:"Working Documents/transformationCode/m2r.xsl" -o:"{output_path}" BASE="{base_IRI}"
```

- Replace `{saxon_dir}` with the path to your saxon directory e.g. ~/saxon11
- Replace `{saxon_version}` with your saxon version number e.g. 11.4
- Replace `{input_path}` with the path to the MARC/XML file to be transformed
- Replace `{output_path}` with the path to the output RDF file (will be created if it does not exist)
- Replace `{base_IRI}` with the base IRI you want to use when the transform mints IRIs. Ensure the IRI ends in / to avoid malformed IRIs. To run with the default base (http://marc2rda.edu/fake/), delete `BASE="{base_IRI}"` from the command

The full command to run should look something like this:
```wrap!
java -cp ~/saxon11/saxon-he-11.4.jar net.sf.saxon.Transform -s:"Working Documents/transformationCode/input/32examples.xml" -xsl:"Working Documents/transformationCode/m2r.xsl" -o:"Working Documents/transformationCode/output/32examples-RDA.rdf" BASE="http://marc2rda.edu/test/"
```

# Serializing the Output
