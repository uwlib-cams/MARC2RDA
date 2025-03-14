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
    
    <!-- 026 -->
    <xsl:template name="F026-xx-abcd" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e']">
            <xsl:if test="@code = 'a'">
                <xsl:text>First and second groups of characters: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Third and fourth groups of characters: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Date: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Number of volume or part: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <!-- 034 -->
    <xsl:template name="F034-xx-abchrxy" expand-text="yes">
            <!--<xsl:call-template name="getmarc"/>-->
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdaed:P20213>
                    <xsl:text>Category of scale: </xsl:text>
                    <xsl:choose>
                        <xsl:when test=". = 'a'">Linear scale</xsl:when>
                        <xsl:when test=". = 'b'">Angular scale</xsl:when>
                        <xsl:when test=". = 'c'">Neither linear nor angular scale</xsl:when>
                    </xsl:choose>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdaed:P20213>
            </xsl:for-each>
            
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <rdaed:P20226>
                    <xsl:value-of select="."/>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdaed:P20226>
            </xsl:for-each>
            
            <xsl:if test="marc:subfield[@code='c']">
                <rdaed:P20230>
                    <xsl:for-each select="marc:subfield[@code = 'c']">
                        <xsl:value-of select="."/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <xsl:text> applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        </xsl:if>
                    </xsl:for-each>   
                </rdaed:P20230>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'h']">
                <rdaed:P20213>
                    <xsl:for-each select="marc:subfield[@code = 'h']">
                        <xsl:if test="@code = 'h'">
                            <xsl:text>Angular scale: {.}</xsl:text>
                        </xsl:if>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <xsl:text> applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20213>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'r']">
                <rdaed:P20071>
                    <xsl:text>Distance from earth: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'r']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdaed:P20071>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'x']">
                <rdaed:P20071>
                    <xsl:text>Beginning date for coordinates: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'x']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdaed:P20071>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'y']">
                <rdaed:P20071>
                    <xsl:text>Ending date for coordinates: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'y']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdaed:P20071>
            </xsl:if>
 
    </xsl:template>

</xsl:stylesheet>

