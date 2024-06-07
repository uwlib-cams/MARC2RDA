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
    <xsl:include href="m2r-4xx-named.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:template match="marc:datafield[@tag = '490']" mode="man">
        <xsl:call-template name="getmarc"/>
        <!-- Accounted-for: $a + $x + $v when LDR/18 is a valid value -->
        <!-- Not accounted for: $6, $7, $8, $l, $y, $z-->
        <!-- 880s not accounted for -->
        <xsl:choose>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = 'a' or substring(preceding-sibling::marc:leader, 19, 1) = 'i'">
                <xsl:call-template name="F490-xx-axv-isbd"/>
            </xsl:when>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = '' or substring(preceding-sibling::marc:leader, 19, 1) = ' ' or substring(preceding-sibling::marc:leader, 19, 1) = 'c' or substring(preceding-sibling::marc:leader, 19, 1) = 'n' or substring(preceding-sibling::marc:leader, 19, 1) = 'u'">
                <xsl:call-template name="F490-xx-axv-nonIsbd"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>MARC 490 data lost; likely due to an unexpected value in LDR/18</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
