<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs marc ex uwf"
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
    xmlns:uwf="http://universityOfWashington/functions"
    version="3.0">
    
    <xsl:function name="uwf:test" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="property"/>
        <xsl:variable name="ns-wemi">
            <xsl:choose>
                <xsl:when test="starts-with($property,'P30')">http://rdaregistry.info/Elements/m/object/</xsl:when>
                <xsl:when test="starts-with($property,'P20')">http://rdaregistry.info/Elements/e/object/</xsl:when>
                <xsl:otherwise>namespaceError</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$subfield">
            <xsl:choose>
                <xsl:when test="starts-with(.,'http://rdaregistry.info/termList')">
                    <xsl:sequence>
                        <xsl:element name="{$property}" namespace="{$ns-wemi}">
                            <xsl:attribute name="rdf:resource">{.}</xsl:attribute>
                        </xsl:element>
                    </xsl:sequence>
                </xsl:when>
                <xsl:when test="./@code='1'">
                    <xsl:element name="{$property}" namespace="{$ns-wemi}">
                        <xsl:attribute name="rdf:resource">{.}</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence>
                        <xsl:comment>MARC data source at field 340 contains a $0 with a value representing authority data; a solution for outputting these in RDA is not yet devised.</xsl:comment>
                    </xsl:sequence>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
</xsl:stylesheet>