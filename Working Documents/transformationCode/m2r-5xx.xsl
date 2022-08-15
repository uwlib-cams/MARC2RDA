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
    xmlns:rdai="http://rdaregistry.info/Elements/m/"
    xmlns:rdaid="http://rdaregistry.info/Elements/m/datatype/"
    xmlns:rdaio="http://rdaregistry.info/Elements/m/object/"
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    <!--<xsl:include href="m2r-5xx-named.xsl"/>-->
    <!-- Does not exist yet -->
    <xsl:variable name="collBase">http://marc2rda.edu/fake/</xsl:variable>
    <xsl:template match="marc:datafield[@tag = '500']" mode="man">
        <xsl:if test="not(marc:subfield/@code='5')">
            <rdamd:P30137>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a'] and marc:subfield[@tag='5']">
            
        </xsl:if>
    </xsl:template>
  <xsl:template match="marc:datafield[@tag = '500'][marc:subfield[@code='5']]" mode="ite">
        <rdaio:P40028>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdaio:P40028>
        <rdaid:P40161 rdf:resource="{$collBase}{lower-case(marc:subfield[@code='5'])}"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '504']" mode="man">
        <rdamd:P30455>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:value-of
                    select="concat(' Number of references: ', marc:subfield[@code = 'b'], '.')"/>
            </xsl:if>
        </rdamd:P30455>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '522']" mode="wor">
        <rdawd:P10216>
            <xsl:value-of select="concat('Geographic coverage: ', marc:subfield[@code = 'a'])"/>
        </rdawd:P10216>
    </xsl:template>
   <!-- <xsl:template match="*" mode="wor"/>
    <xsl:template match="*" mode="exp"/>
    <xsl:template match="*" mode="man"/>
    <xsl:template match="*" mode=""></xsl:template>-->
</xsl:stylesheet>
