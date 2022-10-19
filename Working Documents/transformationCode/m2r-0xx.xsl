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
    <!-- <xsl:include href="m2r-0xx-named.xsl"/> -->
    <xsl:template match="marc:datafield[@tag = '030']" mode="wor">
        <!-- subfields not coded: $6 $8 -->
        <xsl:if test="matches(marc:subfield[@code = 'a'], '^[A-Z]')">
            <rdawd:P10002>
                <xsl:value-of select="concat('(CODEN)',marc:subfield[@code = 'a'])"/>
            </rdawd:P10002>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[A-Z]')">
                <rdawd:P10002>
                    <xsl:value-of select="concat('(Canceled/invalid CODEN)',.)"/>
                </rdawd:P10002>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '030']" mode="man">
        <xsl:if test="matches(marc:subfield[@code = 'a'], '^[0-9]')">
            <rdamd:P30004>
                <xsl:value-of select="concat('(CODEN)',marc:subfield[@code = 'a'])"/>
            </rdamd:P30004>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[0-9]')">
                <rdamd:P30004>
                    <xsl:value-of select="concat('(Canceled/invalid CODEN)',.)"/>
                </rdamd:P30004>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>