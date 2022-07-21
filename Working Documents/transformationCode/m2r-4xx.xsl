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
    <xsl:template match="marc:datafield[@tag = '490']" mode="man">
        <xsl:choose>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = 'a' or substring(preceding-sibling::marc:leader, 19, 1) = 'i'">
                <xsl:call-template name="F490-isbd"/>
            </xsl:when>
            <xsl:when
                test="not(substring(preceding-sibling::marc:leader, 19, 1) = 'a' or substring(preceding-sibling::marc:leader, 19, 1) = 'i')">
                <xsl:call-template name="F490-marc"/>
            </xsl:when>
            <xsl:otherwise>
                <ex:ERROR>Looks like a LDR/18 error</ex:ERROR>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*" mode="wor"/>
    <xsl:template match="*" mode="exp"/>
    <xsl:template match="*" mode="man"/>
</xsl:stylesheet>
