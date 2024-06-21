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
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    
    <xsl:template name="X00-xx-6-nomen-child" expand-text="yes">
        <xsl:param name="fieldTag"/>
        <xsl:param name="mainSubfield"/>
        <xsl:if test="marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="concat($fieldTag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="//marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="marc:subfield[@code = $mainSubfield]">
                    <rdand:P80113>
                        <xsl:value-of select="marc:subfield[@code = $mainSubfield]"/>
                    </rdand:P80113>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="X00-xx-6-nomen-sibling" expand-text="yes">
        <xsl:param name="fieldTag"/>
        <xsl:param name="mainSubfield"/>
        <xsl:if test="../marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="concat($fieldTag, '-', substring(../marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="//marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="marc:subfield[@code = $mainSubfield]">
                    <rdand:P80113>
                        <xsl:value-of select="marc:subfield[@code = $mainSubfield]"/>
                    </rdand:P80113>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
