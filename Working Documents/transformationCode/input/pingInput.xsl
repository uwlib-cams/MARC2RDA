<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="2.0">
    
    <xsl:template match="/">
        <root>
            <xsl:apply-templates select="marc:collection/marc:record"/>
        </root>
    </xsl:template>
    <xsl:template match="marc:record">
        <xsl:for-each select="marc:datafield[@tag='264']">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>