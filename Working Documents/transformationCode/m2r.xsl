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
    <xsl:variable name="base" select="'http://fakeIRI2.edu/'"/>
    <xsl:include href="m2r-0xx.xsl"/>
    <xsl:include href="m2r-1xx.xsl"/>
    <xsl:include href="m2r-2xx.xsl"/>
    <xsl:include href="m2r-3xx.xsl"/>
    <xsl:include href="m2r-4xx.xsl"/>
    <xsl:include href="m2r-5xx.xsl"/>
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
            xmlns:ex="http://fakeIRI2.edu/">
            <xsl:apply-templates select="marc:record"/>
        </rdf:RDF>
    </xsl:template>
    <xsl:template match="marc:record" expand-text="yes">
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
        <!-- *****ITEMS***** -->
        <xsl:apply-templates select="*" mode="ite">
            <xsl:with-param name="baseIRI" select="$baseIRI"/>
        </xsl:apply-templates>
    </xsl:template>
</xsl:stylesheet>
