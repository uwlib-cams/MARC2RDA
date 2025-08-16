<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template name="otherFieldsTo33x">
        <xsl:param name="record"/>
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
            </xsl:copy>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '007']" expand-text="yes">
        <xsl:variable name="p0" select="substring(., 1, 1)"/>
        <xsl:if test="$p0 = 'a'">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">http://rdaregistry.info/termList/RDACarrierType/1021</marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>