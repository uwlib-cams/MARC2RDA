<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <!--<xsl:output encoding="UTF-8" method="text" indent="yes"/>-->
    <xsl:strip-space elements="*"/>

    <!-- This template will append corresponding aggregate manifestations based on a sequential pattern matches -->
    <xsl:include href="aggregate.xsl"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="marc:collection"/>
    </xsl:template>
    
    <xsl:template match="marc:collection">
        <marc:collection xmlns:marc="http://www.loc.gov/MARC21/slim"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:apply-templates select="marc:record"/>
        </marc:collection>
    </xsl:template>
 
    <xsl:template match="marc:record" expand-text="yes">
        <xsl:variable name="aggType" select="uwf:checkAggregates(.)"/>
             <xsl:copy select=".">
                 <xsl:copy-of select="./*"/>
                 <marc:datafield tag="979" ind1=" " ind2=" ">
                     <marc:subfield code="a">{$aggType}</marc:subfield>
                 </marc:datafield>
             </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
