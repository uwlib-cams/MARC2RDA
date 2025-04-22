# Running the transformation code

The transform is written in XSLT in order to be free and open-source.

For testing purposes, the code was developed using Oxygen XML.

Instructions are included for running the code using Oxygen or using Saxon HE (open source), either in command line or through a Python script using Java.

## Option 1: Oxygen for development
*For transforming 1 MARC/XML file or 1 folder containing MARC/XML files with no subfolders*

1. Clone the MARC2RDA GitHub repository
2. In Oxygen, create a project and select the entire MARC2RDA repository to be included, along with the folder containing the MARC/XML file(s) to be transformed.
3. If this is the first time running the transform, see [setting up lookup files](#setting_up_lookup_files) and follow instructions before proceeding. This step may also need to be repeated if LC or RDA have updated their vocabularies since the last transformation was run. 
4. Once you have confirmed that the 'lookup' folder in the repository contain 'lc' and 'rda' subfolders, open a MARC/XML file to be transformed. 
5. In the toolbar at the top of Oxygen, select the Configure Transformation Scenario(s) button, which looks like a wrench. 
6. Select “New” at the bottom of the pop-up menu and select "XML transformation with XSLT".
7. Name the transformation scenario.
8. In the XML URL box, ensure the value is ${currentFileURL}
9. In the XSL URL box, select m2r.xsl from files.
10. Select the "Parameters" and edit the BASE value to the base IRI you would like to be used when the transform mints IRIs. Ensure the IRI ends in / to avoid malformed IRIs. 
11. Navigate to the Output tab
12. In the Output tab, find the Save as option.
    
    a. If transforming one file, enter the location and name for the output file. The file name should end in `.rdf` Press okay.
    
    b. If transforming a folder of files, enter the location of a folder for the output, and end the folder name in `/${cfn}.rdf` This saves each file within the folder with the same name as the input file but as an rdf file. Press okay.
    
13. Transform the file(s)
    
    a. *If transforming 1 file*: Ensuring that the file you want to transform is open in the window, press "Apply associated".
    
    b. *If transforming a folder of files*: Close the transformation scenario pop-up box. In the navigation pane on the left, right click on the folder containing the files you want to transform. Select "Transform" and then "Transform with...". Select the transformation scenario you just set up and press "Apply selected scenarios".
    
14. The transformation scenario should run and output RDF/XML from the MARC/XML

15. (Optional) Add human-readable labels to output files for review
    
    a. Open the RDF/XML output file just created.
    
    b. Follow the steps above to Configure Transformation Scenario(s) using "XML transformation with XSLT" for a new scenario.
    
    c. In the XML URL box, ensure the value is ${currentFileURL}.
    
    d. In the XSL URL box, select appendLabels.xsl from files.
    
    e. Follow the steps above to set “Parameters” and Output.
    
    f. Transform the file by applying the newly created scenario.


## Option 2: Saxon

### Dependencies
- Java
  - Windows: [download Java](https://www.java.com/en/download/) and ensure PATH is set up correctly
    - To check if PATH is set up correctly:
    - Open the command prompt
    - Type: java -version
    - If the system responds with the Java version, then PATH is set up correctly
  - WSL: `$ sudo apt install openjdk-11-jre-headless`
  - Note: if you are using a command prompt window through Anaconda, you may need to temporarily add Java to your PATH with the following code:
    - set `PATH=<Path to java that ends in \bin>;%PATH%`
    - Example: set PATH=C:\Program Files\Java\jre1.8.0_441\bin;%PATH
- Saxon processor from [Saxonica](https://www.saxonica.com/welcome/welcome.xml)
  - For further documentation: [Getting started with SaxonJ](https://www.saxonica.com/html/documentation11/about/gettingstarted/gettingstartedjava.html)
  - The free Saxon-HE (Home Edition) is available for download from GitHub - see Saxonica/[Saxon-HE](https://github.com/Saxonica/Saxon-HE/) > [releases](https://github.com/Saxonica/Saxon-HE/releases)
  - The Saxon-HE repository README file provides information about current Saxon releases; We recommend using version 11.5 or higher.
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

from the transformationCode folder within the MARC2RDA repository, run the python script. You should be prepared with:
- the absolute directory path to where the Saxon processor .jar file is located ready
- the absolute path to the file(s) or folder(s) containing the MARC data in MARC/XML format. These files must end in .xml
- the base IRI you would like IRIs minted by the transform to use. This IRI must end in /
- If running the transform for the first time, enter y when prompted to load lookup files. (see [setting up lookup files](#setting_up_lookup_files) for more details). This step may also need to be repeated if LC or RDA have updated their vocabularies since the last transformation was run.

When you are ready with the above information then you can run
- From the command line: python process.py
- Or use an IDE, such as Spyder to run the process
- Note: as of now, the output is saved in the same folder as the input; I will try to change this to allow the user to specify an output folder (TC 04.02.25)


### Option 2b: command line
*For transforming 1 MARC/XML file at a time*

If running the transform for the first time, see [setting up lookup files](#setting_up_lookup_files) and follow instructions before proceeding. This step may also need to be repeated if LC or RDA have updated their vocabularies since the last transformation was run.

Then, in command line from the transformationCode folder within the MARC2RDA repository, run:

```wrap!
java -cp {saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -s:"{input_path}" -xsl:"m2r.xsl" -o:"{output_path}" BASE="{base_IRI}"
```

- Replace `{saxon_dir}` with the path to your saxon directory e.g. ~/saxon11
- Replace `{saxon_version}` with your saxon version number e.g. 11.4
- Replace `{input_path}` with the path to the MARC/XML file to be transformed. This can be a relative or absolute path. 
- Replace `{output_path}` with the path to the output RDF file (will be created if it does not exist). This can be a relative or absolute path. 
- Replace `{base_IRI}` with the base IRI you want to use when the transform mints IRIs. Ensure the IRI ends in / to avoid malformed IRIs. To run with the default base (http://marc2rda.edu/fake/), delete `BASE="{base_IRI}"` from the command

The full command to run should look something like this:
```wrap!
java -cp ~/saxon11/saxon-he-11.4.jar net.sf.saxon.Transform -s:"input/32examples.xml" -xsl:"m2r.xsl" -o:"output/32examples-RDA.rdf" BASE="http://marc2rda.edu/test/"
```

# Setting up Lookup Files
Before running the transform for the first time, you must set up local lookup files using m2r-loadLookupFiles.xsl. 

### In Oxygen
1. In Oxygen, follow above instructions on setting up a project.
2. Open m2r-loadLookupFiles.xsl
3. In the toolbar at the top of Oxygen, select the Configure Transformation Scenario(s) button, which looks like a wrench. 
4. Select “New” at the bottom of the pop-up menu and select "XML transformation with XSLT".
5. Name the transformation scenario.
6. In the XML URL box, ensure the value is ${currentFileURL}
7. In the XSL URL box, ensure the value is also ${currentFileURL}.
8. Select "okay" and then select "apply associated".
9. Once the transformation has been successful, navigate to the "lookup" folder in the repository. There should now be "lc" and "rda" subfolders, each with files inside. 

### In Command Line
In command line from the MARC2RDA > "Working Documents" > transformationCode folder, run:

*Note: It is important that this is run from the transformationCode folder, NOT the MARC2RDA top level folder*

```wrap!
java -cp {saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -s:"m2r-loadLookupFiles.xsl" -xsl:"m2r-loadLookupFiles.xsl
```

- Replace `{saxon_dir}` with the path to your saxon directory e.g. ~/saxon11
- Replace `{saxon_version}` with your saxon version number e.g. 11.4

The full command to run should look something like this:
```wrap!
java -cp ~/saxon11/saxon-he-11.4.jar net.sf.saxon.Transform -s:"m2r-loadLookupFiles.xsl" -xsl:"m2r-loadLookupFiles.xsl"
```

### In process.py

During running process.py, you will be prompted to respond 'y' or 'n' to whether you would like to download the lookup files. You must select 'y' if you have not run the transformation before, or if you would like to update your local versions of the LC and RDA vocabularies used for lookups in the transform. 

# Serializing the Output

#### Python dependencies

- [Python](https://www.python.org/downloads/) for Windows or WSL (recommend v3.8 or above)
- [RDFLib](https://rdflib.readthedocs.io/en/stable/gettingstarted.html)
  - `$ pip install rdflib` [Installing Python packages](https://packaging.python.org/en/latest/tutorials/installing-packages/) may require* `pip3` *in place of* `pip` *for some systems*  

### Running serialize.py

Once the transformation has been run and RDF/XML data has been produced, the output file can be serialized into additional formats. 

To run serialize.py, be prepared with:
- The full path to the file you wish to serialize (must have the extension .rdf, .ttl, .jsonld, or .nt)
- The formats you wish to serialize to. The options are Turtle (ttl), N-triples (nt), JSON-LD (jsonld), and RDF (rdf). You will be prompted to enter the serializations you want as space separated values i.e. `ttl nt` to output both Turtle and N-triple versions of the file
- Here is the GitHub directory path to serialize.py: Working Documents/Non-Mapping Documents/serialize.py

The script will produce the various serializations in the same folder that the original file is located in. 