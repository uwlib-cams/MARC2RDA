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
    <xsl:template match="marc:datafield[@tag = '245']" mode="wor">
        <fake:rdawP10088><!-- hasTitleOfWork -->
            <xsl:text>NO TITLE</xsl:text>
            <!--FOR WORKS USING MARC RECORDS WHERE THE ONLY TITLE FIELD IS 245. For works without titles, create well-formed RDA by creating an access point (AP) (or create an identifier, which can be a stringified IRI). Base of the AP should be an authorized AP (AAP) (QUESTION FROM TG: DOES IT HAVE TO BE AN AAP?) for an agent who creates the work, plus a title of the work derived from the manifestation (as should appear in the 245)-->
        </fake:rdawP10088>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '245']" mode="man">
        <xsl:call-template name="F245-xx-anps"/>
        <xsl:call-template name="F245-xx-a"/>
        <xsl:call-template name="F245-xx-b"/>
        <xsl:call-template name="F245-xx-c"/>
        <xsl:call-template name="F245-xx-f-g"/>
        <xsl:call-template name="F245-xx-h"/>
        <xsl:call-template name="F245-xx-k"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '264']" mode="man">
        <!-- subfields not accounted-for: $3, $6, $7 $8 ;
             need to code for $3 .
        -->
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
