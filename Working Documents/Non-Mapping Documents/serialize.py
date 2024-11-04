# Function for serializing dataset/vocabulary
# set up to accept input as rdf/xml, nt, ttl, or json-ld and
# produces rdf/xml, nt, ttl, and json-ld formats

import rdflib
from textwrap import dedent
import os


def serialize(file_path):

    # file path w no extension
    file_path_noext = file_path.rsplit('.', 1)[0]

    # generate rdflib graph, use already existing namespaces
    g = rdflib.Graph(bind_namespaces="none").parse(file_path)

    # bind namespaces
    # for ns_prefix, namespace in g.namespaces():
    #     g.bind(ns_prefix, namespace, override=False)

    # generate each serialization
    def format_rdf(g):

        destination = file_path_noext + "." + "rdf"

        rdf = g.serialize(destination=destination, format='xml', encoding="utf8")

        # path = file_path_noext + "." + "rdf"
        # file = open(path, 'w')
        # file.write(rdf)
        # file.close()


    def format_nt(g):
        nt = g.serialize(format='nt')

        path = file_path_noext + "." + "nt"
        file = open(path, 'w')
        file.write(nt)
        file.close()


    def format_ttl(g):
        turtle = g.serialize(format='turtle')

        path = file_path_noext + "." + "ttl"
        file = open(path, 'w')
        file.write(turtle)
        file.close()


    def format_jsonld(g):
        
        jsonld = g.serialize(format='json-ld')
        path = file_path_noext + "." + "jsonld"
        file = open(path, 'w')
        file.write(jsonld)
        file.close()
    
    # uncomment the formats you would like to produce
    # format_rdf(g)
    # format_nt(g)
    format_ttl(g)
    # format_jsonld(g)


# only_serialize can be run from this script to produce all serializations

def only_serialize():
    file_prompt = dedent("""Enter the path of the file relative to the working directory. 
    The file must have the extenstion ".rdf", ".ttl", ".jsonld", or ".nt"
    For example: '../uwlswd_vocabs/newspaper_genre_list.ttl'
    > """)
    file_path = input(file_prompt)

    if not(os.path.exists(file_path)):
        exit()
    
    # get format
    format = file_path.rsplit(".", 1)[1]
    if format not in ["jsonld","rdf","ttl","nt"]:
        print("Error: file is not one of the accepted formats")
        exit(0)
    

    print(dedent(f"""{'=' * 20}
SERIALIZING DATA
{'=' * 20}"""))

    serialize(file_path)

only_serialize()