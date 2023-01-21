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
    <xsl:include href="m2r-2xx-named.xsl"/>
    <xsl:template match="marc:datafield[@tag = '245']" mode="wor"/>
    <xsl:template match="marc:datafield[@tag = '245']" mode="man">
        <!-- subfields not coded: $6.codeASAP , $7.doNotCode.pendingDiscussion, $8.doNotCode ("We will not map $8 until a use case is provided. 2022-07-14").
        -->
        <xsl:call-template name="F245-xx-anps"/>
        <xsl:call-template name="F245-xx-a"/>
        <xsl:call-template name="F245-xx-b"/>
        <xsl:call-template name="F245-xx-c"/>
        <xsl:call-template name="F245-xx-f-g"/>
        <xsl:call-template name="F245-xx-h"/>
        <xsl:call-template name="F245-xx-k"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '264']" mode="man">
        <xsl:choose>
            <xsl:when test="@ind2 = '0'">
                <rdamd:P30110>
                    <xsl:call-template name="F264-xx-abc"/>
                </rdamd:P30110>
                <xsl:call-template name="F264-x0-a_b_c"/>
            </xsl:when>
            <xsl:when test="@ind2 = '1'">
                <rdamd:P30111>
                    <xsl:call-template name="F264-xx-abc"/>
                </rdamd:P30111>
                <xsl:call-template name="F264-x1-a_b_c"/>
            </xsl:when>
            <xsl:when test="@ind2 = '2'">
                <rdamd:P30108>
                    <xsl:call-template name="F264-xx-abc"/>
                </rdamd:P30108>
                <xsl:call-template name="F264-x2-a_b_c"/>
            </xsl:when>
            <xsl:when test="@ind2 = '3'">
                <rdamd:P30109>
                    <xsl:call-template name="F264-xx-abc"/>
                </rdamd:P30109>
                <xsl:call-template name="F264-x3-a_b_c"/>
            </xsl:when>
            <xsl:when test="@ind2 = '4'">
                <xsl:for-each select="marc:subfield[@code='c']">
                    <rdamd:P30280>
                    <xsl:value-of select="."/>
                </rdamd:P30280>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
