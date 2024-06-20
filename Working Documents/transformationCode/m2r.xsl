<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
    xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdaed="http://rdaregistry.info/Elements/e/datatype/"
    xmlns:rdaeo="http://rdaregistry.info/Elements/e/object/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/"
    xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
    xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
    xmlns:rdai="http://rdaregistry.info/Elements/i/"
    xmlns:rdaid="http://rdaregistry.info/Elements/i/datatype/"
    xmlns:rdaio="http://rdaregistry.info/Elements/i/object/"
    xmlns:rdaa="http://rdaregistry.info/Elements/a/"
    xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
    xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
    xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- skips fields not yet handled -->
    <xsl:mode name="wor" on-no-match="shallow-skip"/>
    <xsl:mode name="exp" on-no-match="shallow-skip"/>
    <xsl:mode name="man" on-no-match="shallow-skip"/>
    
    <xsl:mode name="ite" on-no-match="shallow-skip"/>
    <xsl:mode name="nom" on-no-match="shallow-skip"/>
    <xsl:mode name="metaWor" on-no-match="shallow-skip"/>
    <xsl:mode name="age" on-no-match="shallow-skip"/>
    
    <!-- base IRI for now - all minted entities begin with this -->
    <xsl:variable name="base" select="'http://fakeIRI2.edu/'"/>
    
    <!-- include all files containing main field templates
         each main field template will include its own -named file if it exists-->
    <xsl:include href="m2r-0xx.xsl"/>
    <xsl:include href="m2r-1xx7xx.xsl"/>
    <xsl:include href="m2r-2xx.xsl"/>
    <xsl:include href="m2r-3xx.xsl"/>
    <xsl:include href="m2r-4xx.xsl"/>
    <xsl:include href="m2r-5xx.xsl"/>
    
    <!-- This template matches at the root
        It's only purpose is to apply-templates to the marc:collection -->
    <xsl:template match="/">
        <!--        <test>
            <introduction>
                <p>Processing a single MARC XML "collection"</p>
                <p>Number of records: <xsl:value-of select="count(marc:collection/marc:record)"
                    /></p>
                <p>Number of records with 264 fields: <xsl:value-of
                        select="count(marc:collection/marc:record[marc:datafield[@tag = '264']])"
                    /></p>
            </introduction> -->
        <xsl:apply-templates select="marc:collection"/>
        <!--     </test>  -->
    </xsl:template>
    
    <!-- This template matches the marc:collection 
        and creates the <rdf:RDF> elements with the necessary namespaces for the resulting document
        if additional namespaces are used they should be added here as well. -->
    <xsl:template match="marc:collection">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:rdaw="http://rdaregistry.info/Elements/w/"
            xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
            xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
            xmlns:rdae="http://rdaregistry.info/Elements/e/"
            xmlns:rdaed="http://rdaregistry.info/Elements/e/datatype/"
            xmlns:rdaeo="http://rdaregistry.info/Elements/e/object/"
            xmlns:rdam="http://rdaregistry.info/Elements/m/"
            xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
            xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
            xmlns:rdaa="http://rdaregistry.info/Elements/a/"
            xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
            xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
            xmlns:rdan="http://rdaregistry.info/Elements/n/"
            xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
            xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
            xmlns:rdap="http://rdaregistry.info/Elements/p/"
            xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
            xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
            xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
            xmlns:ex="http://fakeIRI2.edu/">
            <!-- at some point, filtering for aggregates will need to happen before apply-templates is called here -->
            <!--<xsl:apply-templates select="marc:record[not(marc:datafield[@tag='533'])]"/>-->
            <xsl:apply-templates select="marc:record"/>
        </rdf:RDF>
    </xsl:template>
    
    <!-- Set up the WEMI stack for the marc:record -->
    <!-- an rdf:Description is created for the Work, Expression, and Manifestation 
        and apply-templates is called with the correct mode 
        to create the appropriate relationships within each rdf:Description element -->
 
    <xsl:template match="marc:record" expand-text="yes">
        
        <!-- currently we are using the 001 control field to generate the baseIRI -->
        <xsl:variable name="baseIRI" select="concat($base, marc:controlfield[@tag = '001'])"/>
        
        <!-- *****WORKS***** -->
        <rdf:Description rdf:about="{concat($baseIRI,'wor')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawo:P10078 rdf:resource="{concat($baseIRI,'exp')}"/>
            <rdawd:P10002>{concat(marc:controlfield[@tag='001'],'wor')}</rdawd:P10002>
            <xsl:apply-templates select="*" mode="wor"/>
        </rdf:Description>
        
        <!-- *****EXPRESSIONS***** -->
        <rdf:Description rdf:about="{concat($baseIRI,'exp')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            <rdaeo:P20059 rdf:resource="{concat($baseIRI,'man')}"/>
            <rdaeo:P20231 rdf:resource="{concat($baseIRI,'wor')}"/>
            <rdaed:P20002>{concat(marc:controlfield[@tag='001'],'exp')}</rdaed:P20002>
            <xsl:apply-templates select="*" mode="exp"/>
        </rdf:Description>
        
        <!-- *****MANIFESTATIONS***** -->
        <rdf:Description rdf:about="{concat($baseIRI,'man')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            <rdamo:P30139 rdf:resource="{concat($baseIRI,'exp')}"/>
            <xsl:apply-templates select="*" mode="man"/>
        </rdf:Description>
        
        <!-- Items, nomens, metadata works, and agents are generated as needed
             so the rdf:Description elements are generated within the field-specific templates.
             How IRIs are minted vary, see documentation -->
        
        <!-- *****ITEMS***** -->
        <xsl:apply-templates select="*" mode="ite">
            <xsl:with-param name="baseIRI" select="$baseIRI"/>
            <xsl:with-param name="controlNumber" select="../marc:controlfield[@tag='001']"/>
        </xsl:apply-templates>
        
        <!-- *****NOMENS***** -->
        <xsl:apply-templates select="*" mode="nom">
            <xsl:with-param name="baseIRI" select="$baseIRI"/>
        </xsl:apply-templates>
        
        <!-- *****METADATA WORKS***** -->
        <xsl:apply-templates select="*" mode="metaWor">
            <xsl:with-param name="baseIRI" select="$baseIRI"/>
        </xsl:apply-templates>
        
        <!-- *****RELATED AGENTS***** -->
        <xsl:apply-templates select="*" mode="age">
            <xsl:with-param name="baseIRI" select="$baseIRI"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
