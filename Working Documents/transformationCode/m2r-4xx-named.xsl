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
    <xsl:template name="F490-isbd">
        <rdamd:P30106>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield/@code = 'x'">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'x']"/>
            </xsl:if>
            <xsl:if test="marc:subfield/@code = 'v'">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'v']"/>
            </xsl:if>
        </rdamd:P30106>
    </xsl:template>
    <xsl:template name="F490-marc">
        <rdamd:P30106>
            <xsl:value-of select="@tag"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@ind1"/>
            <xsl:value-of select="@ind2"/>
            <xsl:text> $a </xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = 'x']">
                <xsl:text> $x </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'x']"/>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'v']">
                <xsl:text> $v </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'v']"/>
            </xsl:if>
        </rdamd:P30106>
    </xsl:template>
</xsl:stylesheet>
