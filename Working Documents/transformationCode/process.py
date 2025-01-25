
from textwrap import dedent
import rdflib
import os


# uses rdflib graph to format rdf/xml file so each rdf:Description element has a unique rdf:about attribute
# use already existing namespaces
def format_rdflib(abs_path):
    g = rdflib.Graph(bind_namespaces="none").parse(abs_path)

    # for ns_prefix, namespace in g.namespaces():
    #     g.bind(ns_prefix, namespace)

    g.serialize(destination=abs_path, format="xml", encoding="utf8")

# calls format_rdflib and then runs rdf2datacite.xsl on formatted file
def process_file(file_path, base_IRI):
    # file path parsing assumes main.py is being run in top-level uwlswd 
    # AND that the file being parsed is NOT located IN uwlswd folder
    
    # absolute path
    abspath = os.path.abspath(file_path)
    dir = os.path.dirname(abspath)
    filename = os.path.splitext(os.path.basename(abspath))[0]
    output_path = f"{dir}/{filename}-RDA.rdf"

    print(dedent(f"""{'=' * 20}
Transforming MARC from {file_path} to RDA/RDF/XML
{'=' * 20}"""))


    # run m2r.xsl
    os_command = f"""java -cp {saxon_dir}/saxon-he-{saxon_version}.jar 
    net.sf.saxon.Transform 
    -s:"{abspath}"
    -xsl:"Working Documents/transformationCode/m2r.xsl"
    -o:"{output_path}"
    BASE="{base_IRI}"
    """

    os_command = os_command.replace('\n', '')
    os.system(os_command)


### SCRIPT STARTS HERE ###

# check set-up
print(dedent("""Please confirm:
1) You have the absolute directory path to where the Saxon processor .jar file is located ready
2) You have the absolute path to the file(s) or folder(s) containing the MARC data in MARC/XML format.
    These files must end in .xml
3) You have the base IRI you would like IRIs minted by the transform to use."""))
confirm = input("OK to proceed? (Yes or No):\n> ")
if confirm.lower() == "yes":
    pass
else:
    exit(0)

# get location and version of saxon folder 
saxon_dir_prompt = dedent("""Enter the absolute directory path to where your Saxon HE .jar file is stored
For example: ~/saxon, c:/Users/cpayn/saxon11, etc.
> """)
saxon_dir = input(saxon_dir_prompt)

saxon_version_prompt = dedent("""Enter your Saxon HE version number (this will be in the .jar file name)
For example: 11.1, 11.4, etc.
> """)
saxon_version = input(saxon_version_prompt)

def prompt_user_base_IRI():
    IRI_prompt = dedent("""Enter the base IRI you would like to use for IRIs minted by the transform. 
    The IRI must end in / or IRIs will be malformed. 
    For example: http://marc2rda.edu/fake/
> """)
    return(input(IRI_prompt))

# get input file path
def prompt_user_input(): 
    file_prompt = dedent("""Enter the absolute or relative path of the folder or file containing MARC/XML. 
    The file must have the extenstion ".xml", 
    if entering the path of a folder, each '.xml' file within the directory will be transformed
    For example: ~/marc_for_transform or test_input/6xx/610Test.xml
> """)
    file_path = input(file_prompt)

    if os.path.exists(file_path):
        return file_path 
    
    else:
        print(dedent("\nError: file or folder could not be found. Please re-enter file or folder name or press CTRL+C to cancel.\n"))
        return prompt_user_input()
    
# process file path for separate variables 
file_path = prompt_user_input()
if os.path.isfile(file_path):
    base_IRI = prompt_user_base_IRI()
    if file_path.endswith('.xml'):
        process_file(file_path, base_IRI)
    else: 
        print("Input must be an xml file or a directory containing xml files")
        exit()

elif os.path.isdir(file_path):
    base_IRI = prompt_user_base_IRI()
    complete_files = []

    for root, dir_names, file_names in os.walk(file_path):
        for f in file_names:
            if f.endswith('.xml'):
                complete_files.append(os.path.join(root, f))

    print(dedent(f"""{'=' * 20}
{len(complete_files)} FILES FOUND
{'=' * 20}"""))

    for f in complete_files:
        process_file(f, base_IRI)