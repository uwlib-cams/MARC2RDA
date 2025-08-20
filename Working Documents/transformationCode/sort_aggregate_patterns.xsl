<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <!-- Identity transform to copy everything as-is -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Special handling for the patterns element to sort its children -->
    <xsl:template match="patterns">
        <xsl:copy>
            <xsl:apply-templates select="pattern">
                <xsl:sort select="number(sort)" data-type="number" order="ascending"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
