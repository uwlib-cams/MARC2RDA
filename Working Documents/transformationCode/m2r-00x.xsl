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
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    
    <xsl:include href="m2r-00x-named.xsl"/> 
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    
    <xsl:template match="marc:controlfield[@tag = '008']" 
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        
        <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
        <xsl:choose>
            <!-- books -->
            <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                <xsl:call-template name="F008-c24-27-BOOKS">
                    <xsl:with-param name="char24-27" select="substring(., 25, 4)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '008']" 
        mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
        
        <xsl:variable name="char35-37" select="substring(., 36, 3)"/>
        <rdae:P20006 rdf:resource="{concat('http://id.loc.gov/vocabulary/languages/', $char35-37)}"/>
        
        <xsl:choose>
            <!-- books -->
            <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                <xsl:call-template name="F008-c22-BOOKS">
                    <xsl:with-param name="char22" select="substring(., 23, 1)"/>
                </xsl:call-template>
                <xsl:call-template name="F008-c23-f-BOOKS">
                    <xsl:with-param name="char23" select="substring(., 24, 1)"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '008']" 
        mode="man origMan" expand-text="yes">
        <xsl:param name="type"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
        <xsl:variable name="char6" select="substring(., 7, 1)"/>
        <xsl:if test="not(contains($type, 'reproduction'))">
            <xsl:call-template name="F008-c6">
                <xsl:with-param name="char6" select="$char6"/>
            </xsl:call-template>
            <xsl:variable name="char15-17" select="substring(., 16, 3)"/>
            <xsl:call-template name="F008-c15-17">
                <xsl:with-param name="char15-17" select="$char15-17"/>
            </xsl:call-template>
            <xsl:call-template name="F008-c23-BOOKS-origMan">
                <xsl:with-param name="char23" select="substring(., 24, 1)"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="not(contains($type, 'origMan'))">
            <xsl:choose>
                <!-- books -->
                <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                    or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                    <xsl:call-template name="F008-c18-21-BOOKS">
                        <xsl:with-param name="char18-21" select="substring(., 19, 4)"/>
                    </xsl:call-template>
                    <xsl:call-template name="F008-c23-BOOKS">
                        <xsl:with-param name="char23" select="substring(., 24, 1)"/>
                    </xsl:call-template>
                    <xsl:call-template name="F008-c24-27-2bkq-BOOKS">
                        <xsl:with-param name="char24-27" select="substring(., 25, 4)"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>