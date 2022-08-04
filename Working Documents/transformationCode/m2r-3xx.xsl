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
    <xsl:include href="m2r-3xx-named.xsl"/>
    <xsl:template match="marc:datafield[@tag = '336']" mode="exp">
        <!-- Always maps to rdae:P20001, no matter the value -->
        <!-- Accounted for: $a, $b, $0, $1 -->
        <!--Not accounted for: $2, $3, $6, $8 -->
        <xsl:call-template name="F336-string"/>
        <xsl:call-template name="F336-iri"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '337']" mode="man">
        <!-- Always maps to rdam:P30002, no matter the value -->
        <!-- Accounted for: $a, $b, $0, $1 -->
        <!--Not accounted for: $2, $3, $6, $8 -->
        <xsl:call-template name="F337-string"/>
        <xsl:call-template name="F337-iri"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '338']" mode="man">
        <!-- Always maps to rdae:P30001, no matter the value -->
        <!-- Accounted for: $a, $b, $0, $1 -->
        <!--Not accounted for: $2, $3, $6, $8 -->
        <xsl:call-template name="F338-string"/>
        <xsl:call-template name="F338-iri"/>
    </xsl:template>
</xsl:stylesheet>
