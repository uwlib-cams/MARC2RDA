<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template match="marc:datafield[@tag = '100']" mode="wor">
        <fake:rdawP10065>
            <xsl:value-of select="marc:subfield" separator=" "/>
        </fake:rdawP10065>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '110']" mode="wor">
        <fake:rdawP10065>
            <xsl:value-of select="marc:subfield" separator=" "/>
        </fake:rdawP10065>
    </xsl:template>
    <xsl:template match="*" mode="wor"/>
    <xsl:template match="*" mode="exp"/>
    <xsl:template match="*" mode="man"/>
</xsl:stylesheet>
