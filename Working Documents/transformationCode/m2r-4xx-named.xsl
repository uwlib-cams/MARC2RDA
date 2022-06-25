<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F490-isbd">
        <rdam:P30106>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield/@code = 'x'">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'x']"/>
            </xsl:if>
            <xsl:if test="marc:subfield/@code = 'v'">
                <xsl:text> </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'v']"/>
            </xsl:if>
        </rdam:P30106>
    </xsl:template>
    <xsl:template name="F490-marc">
        <rdam:P30106>
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
        </rdam:P30106>
    </xsl:template>
</xsl:stylesheet>
