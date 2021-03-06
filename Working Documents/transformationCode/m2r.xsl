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
    xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="base" select="'http://fakeIRI2.edu/'"/>
    <xsl:include href="m2r-1xx.xsl"/>
    <xsl:include href="m2r-2xx.xsl"/>
    <xsl:include href="m2r-3xx.xsl"/>
    <xsl:include href="m2r-4xx.xsl"/>
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
    <xsl:template match="marc:record">
        <!-- *****WORKS***** -->
        <rdf:Description rdf:about="{concat($base,marc:controlfield[@tag='001'],'wor')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawo:P10078 rdf:resource="{concat($base,marc:controlfield[@tag='001'],'exp')}"/>
            <xsl:apply-templates select="*" mode="wor"/>
        </rdf:Description>
        <!-- *****EXPRESSIONS***** -->
        <rdf:Description rdf:about="{concat($base,marc:controlfield[@tag='001'],'exp')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
            <rdaeo:P20059 rdf:resource="{concat($base,marc:controlfield[@tag='001'],'man')}"/>
            <rdaeo:P20231 rdf:resource="{concat($base,marc:controlfield[@tag='001'],'wor')}"/>
            <xsl:apply-templates select="*" mode="exp"/>
        </rdf:Description>
        <!-- *****MANIFESTATIONS***** -->
        <rdf:Description rdf:about="{concat($base,marc:controlfield[@tag='001'],'man')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            <rdamo:P30139 rdf:resource="{concat($base,marc:controlfield[@tag='001'],'exp')}"/>
            <xsl:apply-templates select="*" mode="man"/>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
