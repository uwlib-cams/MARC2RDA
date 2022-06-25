<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
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
    <xsl:template match="*" mode="work"/>
    <xsl:template match="*" mode="exp"/>
    <xsl:template match="*" mode="man"/>
</xsl:stylesheet>
