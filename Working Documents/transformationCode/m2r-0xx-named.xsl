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
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <!-- 013 -->
    <xsl:template name="F013-xx-abcdef" expand-text="yes">
        <xsl:text>Patent control information: </xsl:text>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e']| marc:subfield[@code = 'f']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Number: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Country: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Type of number: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Date: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Status: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'f'">
                <xsl:text>Party to document: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
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
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdaed:P20213>
            </xsl:for-each>
            
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <rdaed:P20226>
                    <xsl:value-of select="."/>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdaed:P20226>
            </xsl:for-each>
            
            <xsl:if test="marc:subfield[@code='c']">
                <rdaed:P20230>
                    <xsl:for-each select="marc:subfield[@code = 'c']">
                        <xsl:value-of select="."/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <xsl:text> (applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
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
                            <xsl:text> (applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20213>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'r']">
                <rdaed:P20071>                
                    <xsl:for-each select="marc:subfield[@code = 'r']">
                        <xsl:if test="@code = 'r'">
                            <xsl:text>Distance from earth: {.}</xsl:text>
                        </xsl:if>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'x']">
                <rdaed:P20071>
                    <xsl:for-each select="marc:subfield[@code = 'x']">
                        <xsl:if test="@code = 'x'">
                            <xsl:text>Beginning date for coordinates: {.}</xsl:text>
                        </xsl:if>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <xsl:text> (applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = 'y']">
                <rdaed:P20071>
                    <xsl:for-each select="marc:subfield[@code = 'y']">
                        <xsl:if test="@code = 'y'">
                            <xsl:text>Ending date for coordinates: {.}</xsl:text>
                        </xsl:if>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <xsl:text> (applies to: </xsl:text>
                            <xsl:value-of select="../marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
 
    </xsl:template>

    <!--046-->
    <xsl:template name="F0046-timespan">
        <xsl:param name="baseID"/>
        <xsl:param name="suffix"/>
        <xsl:param name="note"/>
         
        <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., $suffix)}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
             
                           <!-- Combined date range with B.C.E. suffix -->
              <rdatd:P70016><xsl:value-of select="concat(
                  if (marc:subfield[@code = 'b']) then concat(marc:subfield[@code = 'b'], ' B.C.E.') 
                  else if (marc:subfield[@code = 'c']) then marc:subfield[@code = 'c'] 
                  else '',
                  if (marc:subfield[@code = 'b' or @code = 'c'] and marc:subfield[@code = 'd' or @code = 'e']) then ' - ' 
                  else '',
                  if (marc:subfield[@code = 'd']) then concat(marc:subfield[@code = 'd'], ' B.C.E.') 
                  else if (marc:subfield[@code = 'e']) then marc:subfield[@code = 'e'] 
                  else ''
              )"/></rdatd:P70016>
              
              <!-- Note about the timespan -->
              <rdatd:P70045><xsl:value-of select="$note"/></rdatd:P70045>
              
              <!-- Beginning date -->
              <xsl:if test="marc:subfield[@code = 'b' or @code = 'c']">
                  <rdatd:P70039><xsl:value-of select="
                      if (marc:subfield[@code = 'b']) then concat(marc:subfield[@code = 'b'], ' B.C.E.') 
                      else if (marc:subfield[@code = 'c']) then marc:subfield[@code = 'c'] 
                      else ''
                  "/></rdatd:P70039>
              </xsl:if>
              
              <!-- Ending date -->
              <xsl:if test="marc:subfield[@code = 'd' or @code = 'e']">
                  <rdatd:P70040><xsl:value-of select="
                      if (marc:subfield[@code = 'd']) then concat(marc:subfield[@code = 'd'], ' B.C.E.') 
                      else if (marc:subfield[@code = 'e']) then marc:subfield[@code = 'e'] 
                      else ''
                  "/></rdatd:P70040>
              </xsl:if>
         </rdf:Description>
     </xsl:template>
     
    <!-- F0082-deweyClassification: Named template for MARC 082 -->
    <xsl:template name="F0082-deweyClassification">
        <xsl:param name="baseID"/>
        <xsl:param name="suffix"/>
        <xsl:param name="note"/>
        
        <!-- Normalize $a by removing slashes -->
        <xsl:variable name="normalizedA" select="replace(marc:subfield[@code = 'a'], '/', '')"/>
        
        <!-- Get edition code from $2 -->
        <xsl:variable name="editionCode" select="marc:subfield[@code = '2']"/>
        
        <!-- Construct the scheme IRI based on ind1 and editionCode -->
        <xsl:variable name="schemeIRI">
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>http://id.loc.gov/vocabulary/classSchemes/ddc</xsl:text>
                    <xsl:value-of select="substring-before($editionCode, '/')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://id.loc.gov/vocabulary/classSchemes/ddc</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Create concept IRI: schemeIRI#normalizedA -->
        <xsl:variable name="conceptIRI" select="concat($schemeIRI, '#', $normalizedA)"/>
        
        <!-- 1. Link the Work to the classification concept -->
        <rdf:Description rdf:about="{$baseID}">
            <rdawo:P10256 rdf:resource="{$conceptIRI}"/>
        </rdf:Description>
        
        <!-- 2. Define the classification concept itself -->
        <rdf:Description rdf:about="{$conceptIRI}" xmlns:skos="http://www.w3.org/2004/02/skos/core#">
            <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
            
            <skos:notation rdf:datatype="http://www.w3.org/2001/XMLSchema#string">
                <xsl:value-of select="$normalizedA"/>
            </skos:notation>
            
            <skos:altLabel>
                <xsl:value-of select="$normalizedA"/>
            </skos:altLabel>
            
            <skos:inScheme rdf:resource="{$schemeIRI}"/>
            
            <rdatd:P70045>
                <xsl:value-of select="$note"/>
            </rdatd:P70045>
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>

