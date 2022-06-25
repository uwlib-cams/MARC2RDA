<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:include href="m2r-2xx-named.xsl"/>
    <xsl:template match="marc:datafield[@tag = '245']" mode="work">
        <fake:rdawP10088>
            <xsl:value-of select="marc:subfield" separator=" "/>
        </fake:rdawP10088>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '245']" mode="man">
        <rdam:manTitleFrom245>
            <xsl:value-of select="marc:subfield" separator=" "/>
        </rdam:manTitleFrom245>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '264']" mode="man">
        <!-- main condition of F264: ind2 value; then process fields a, b, c -->
        <!-- subfields not accounted-for: $3, $6, $8 -->
        <xsl:choose>
            <xsl:when test="@ind2 = '0'">
                <rdam:P30110>
                    <xsl:call-template name="F264-abc"/>
                </rdam:P30110>
                <xsl:call-template name="F264-0-a"/>
            </xsl:when>
            <xsl:when test="@ind2 = '1'">
                <rdam:P30111>
                    <xsl:call-template name="F264-abc"/>
                </rdam:P30111>
                <xsl:call-template name="F264-1-a"/>
            </xsl:when>
            <xsl:when test="@ind2 = '2'">
                <rdam:P30108>
                    <xsl:call-template name="F264-abc"/>
                </rdam:P30108>
                <xsl:call-template name="F264-2-a"/>
            </xsl:when>
            <xsl:when test="@ind2 = '3'">
                <rdam:P30109>
                    <xsl:call-template name="F264-abc"/>
                </rdam:P30109>
                <xsl:call-template name="F264-3-a"/>
            </xsl:when>
            <xsl:when test="@ind2 = '4'">
                <rdam:P30007>
                    <xsl:value-of select="marc:subfield[@code = 'c']"/>
                </rdam:P30007>
            </xsl:when>
            <xsl:otherwise>
                <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="work"/>
    <xsl:template match="*" mode="man"/>
</xsl:stylesheet>
