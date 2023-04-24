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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">

    <xsl:template name="getmarc">
        <xsl:comment>MARC data begins</xsl:comment>
        <xsl:element name="{'fake:marcfield'}">
            <xsl:value-of select="'F'||@tag"/>
            <xsl:text> </xsl:text>
            <xsl:if test="@ind1 != ' '">
                <xsl:value-of select="@ind1"/>
            </xsl:if>
            <xsl:if test="@ind1 = ' '">
                <xsl:value-of select="'#'"/>
            </xsl:if>
            <xsl:if test="@ind2 != ' '">
                <xsl:value-of select="@ind2"/>
            </xsl:if>
            <xsl:if test="@ind2 = ' '">
                <xsl:value-of select="'#'"/>
            </xsl:if>
            <xsl:text> </xsl:text>
            <xsl:for-each select="marc:subfield">
                <xsl:text>$</xsl:text>
                <xsl:value-of select="@code"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
        <xsl:comment>RDA data begins</xsl:comment>
    </xsl:template>
</xsl:stylesheet>
