<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="lookup007c0c1" match="uwmisc:entry" use="uwmisc:marc007c0c1"/>
    <xsl:key name="lookup007c0c5c6" match="uwmisc:entry" use="uwmisc:marc007c0c5c6"/>
    
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
        <xsl:variable name="f007c0c1" select="substring(., 1, 2)"/>
        <xsl:variable name="f007c0c5c6" select="substring(., 1, 1)||substring(., 6, 2)"/>
        <xsl:variable name="lookup007c0c1" select="document('lookup/Lookup338.xml')/key('lookup007c0c1', $f007c0c1)/uwmisc:rdaIRI"/>
        <xsl:variable name="lookup007c0c5c6" select="document('lookup/Lookup338.xml')/key('lookup007c0c5c6', $f007c0c5c6)/uwmisc:rdaIRI"/>
        <xsl:if test="$lookup007c0c1 != ''">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="$lookup007c0c1"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
        <xsl:if test="$lookup007c0c5c6 != ''">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="$lookup007c0c5c6"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>