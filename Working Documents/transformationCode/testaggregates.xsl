<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- This template will append corresponding aggregate manifestations based on a sequential pattern matches -->
    <xsl:include href="aggregate.xsl"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="marc:collection"/>
    </xsl:template>
    
    <xsl:template match="marc:collection">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
            xmlns:ex="http://fakeIRI2.edu/">
            <xsl:apply-templates select="marc:record"/>
        </rdf:RDF>
    </xsl:template>
 
    <xsl:template match="marc:record" expand-text="yes">
             <xsl:call-template name="append-aggregates"/>
    </xsl:template>
</xsl:stylesheet>
