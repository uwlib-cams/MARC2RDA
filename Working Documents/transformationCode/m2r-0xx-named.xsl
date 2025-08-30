<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
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
    xmlns:fake="http://fakePropertiesForDemo" 
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
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

    <!-- 045 -->
    <xsl:template name="F045-xx-abc">
        <xsl:param name="baseID"/>
        <xsl:param name="context"/>
        
        <!-- IRI for this timespan -->
        <xsl:variable name="iri" select="m2r:timespanIRI($baseID, $context, '')"/>
        
        <!-- Link manifestation → TimeSpan -->
        <rdamo:P30162 rdf:resource="{$iri}"/>
        
        <!-- For subfield $a (time period code) -->
        <xsl:if test="$context/marc:subfield[@code='a']">
            <rdawo:P10216 rdf:resource="{$iri}"/>
            <xsl:for-each select="$context/marc:subfield[@code='a']">
                <rdawo:P10218><xsl:value-of select="normalize-space(.)"/></rdawo:P10218>
            </xsl:for-each>
        </xsl:if>
        
        <!-- For subfields $b or $c (dates or BCE) -->
        <xsl:if test="$context/marc:subfield[@code='b'] or $context/marc:subfield[@code='c']">
            <rdawo:P10219 rdf:resource="{$iri}"/>
            <xsl:for-each select="$context/marc:subfield[@code='b' or @code='c']">
                <rdawo:P10218><xsl:value-of select="normalize-space(.)"/></rdawo:P10218>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>    
    
    <!-- 045 TIMESPAN) -->
    <xsl:template name="F045-timespan-node">
        <xsl:param name="baseID"/>
        <xsl:param name="context"/>
        <xsl:variable name="iri" select="m2r:timespanIRI($baseID, $context, '')"/>
        
        <rdf:Description rdf:about="{$iri}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
            
            <!-- Label from $b/$c or fallback to $a codes -->
            <xsl:variable name="bVals" select="$context/marc:subfield[@code='b']"/>
            <xsl:variable name="cVals" select="$context/marc:subfield[@code='c']"/>
            <xsl:variable name="aVals" select="$context/marc:subfield[@code='a']"/>
            
            <xsl:variable name="label">
                <xsl:choose>
                    <xsl:when test="$bVals">
                        <xsl:for-each select="$bVals">
                            <xsl:variable name="raw" select="normalize-space(.)"/>
                            <xsl:variable name="trim"
                                select="if (starts-with($raw,'d')) 
                                then substring($raw,2) else $raw"/>
                            <xsl:choose>
                                <xsl:when test="string-length($trim)=8">
                                    <xsl:value-of 
                                        select="concat(substring($trim,1,4), '-', substring($trim,5,2), '-', substring($trim,7,2))"/>
                                </xsl:when>
                                <xsl:when test="string-length($trim)=6">
                                    <xsl:value-of 
                                        select="concat(substring($trim,1,4), '-', substring($trim,5,2))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$trim"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="position() != last()">
                                <xsl:text> - </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$cVals">
                        <xsl:for-each select="$cVals">
                            <xsl:value-of select="concat(normalize-space(.), ' B.C.E.')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text> - </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$aVals">
                        <xsl:for-each select="$aVals">
                            <xsl:value-of select="normalize-space(.)"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:if test="normalize-space($label) != ''">
                <rdatd:P70016><xsl:value-of select="$label"/></rdatd:P70016>
            </xsl:if>
            
            <!-- If two or more $b values, treat as start/end year -->
            <xsl:if test="count($bVals) &gt;= 2">
                <rdatd:P70039>
                    <xsl:variable name="raw" select="normalize-space($bVals[1])"/>
                    <xsl:variable name="trim"
                        select="if (starts-with($raw,'d')) then substring($raw,2) else $raw"/>
                    <xsl:value-of select="substring($trim,1,4)"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:variable name="raw" select="normalize-space($bVals[last()])"/>
                    <xsl:variable name="trim"
                        select="if (starts-with($raw,'d')) then substring($raw,2) else $raw"/>
                    <xsl:value-of select="substring($trim,1,4)"/>
                </rdatd:P70040>
            </xsl:if>
            
            <!-- Carry codes as provenance notes -->
            <xsl:for-each select="$aVals">
                <rdatd:P70045>
                    <xsl:text>Time period code: </xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                </rdatd:P70045>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>
    
    <!--046-->
    <xsl:template name="F046-timespan">
        <xsl:param name="baseID"/>
        <xsl:param name="suffix"/>
        <xsl:param name="note"/>
         
        <rdf:Description rdf:about="{m2r:timespanIRI($baseID, ., $suffix)}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>

            <!-- Consolidated date handling for all cases (rows 12, 14, 29, 30) -->
            <xsl:if test="marc:subfield[@code = 'b'] or marc:subfield[@code = 'c'] or marc:subfield[@code = 'd'] or marc:subfield[@code = 'e']">
                <!-- rdatd:P70016: value of $b|$c - $d|$e, add "B.C.E." after $b and $d -->
                <xsl:variable name="startDate">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'b']">
                            <xsl:value-of select="concat(marc:subfield[@code = 'b'], ' B.C.E.')"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'c']">
                            <xsl:value-of select="marc:subfield[@code = 'c']"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="endDate">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'd']">
                            <xsl:value-of select="concat(marc:subfield[@code = 'd'], ' B.C.E.')"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'e']">
                            <xsl:value-of select="marc:subfield[@code = 'e']"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="string($startDate) != '' and string($endDate) != ''">
                    <rdatd:P70016>
                        <xsl:value-of select="concat($startDate, ' - ', $endDate)"/>
                    </rdatd:P70016>
                </xsl:if>
                
                <!-- rdatd:P70039: value of $b|$c which is present. Add "B.C.E." after $b -->
                <xsl:if test="marc:subfield[@code = 'b'] or marc:subfield[@code = 'c']">
                    <rdatd:P70039>
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = 'b']">
                                <xsl:value-of select="concat(marc:subfield[@code = 'b'], ' B.C.E.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="marc:subfield[@code = 'c']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdatd:P70039>
                </xsl:if>
                
                <!-- rdatd:P70040: value of $d|$e which is present. Add "B.C.E." after $d -->
                <xsl:if test="marc:subfield[@code = 'd'] or marc:subfield[@code = 'e']">
                    <rdatd:P70040>
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = 'd']">
                                <xsl:value-of select="concat(marc:subfield[@code = 'd'], ' B.C.E.')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="marc:subfield[@code = 'e']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdatd:P70040>
                </xsl:if>
            </xsl:if>

            <!-- Row 31-34: $j is present -->
            <xsl:if test="marc:subfield[@code = 'j']">
                <rdato:P70016 rdf:resource="{m2r:nomenIRI($baseID, ., marc:subfield[@code = 'j'], 
                    if (marc:subfield[@code = '2']) then marc:subfield[@code = '2'] else 'Representations of Dates and Times (ISO 8601)', 
                    'timespan')}"/>
            </xsl:if>

            <!-- Row 35: $k,l are present -->
            <xsl:if test="marc:subfield[@code = 'k'] and marc:subfield[@code = 'l']">
                <rdatd:P70016>
                    <xsl:value-of select="concat(marc:subfield[@code = 'k'], ' - ', marc:subfield[@code = 'l'])"/>
                </rdatd:P70016>
                <rdatd:P70039>
                    <xsl:value-of select="marc:subfield[@code = 'k']"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:value-of select="marc:subfield[@code = 'l']"/>
                </rdatd:P70040>
            </xsl:if>

            <!-- Row 36-39: $m,n are present -->
            <xsl:if test="marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
                <rdatd:P70016>
                    <xsl:value-of select="concat(marc:subfield[@code = 'm'], ' - ', marc:subfield[@code = 'n'])"/>
                </rdatd:P70016>
                <rdatd:P70039>
                    <xsl:value-of select="marc:subfield[@code = 'm']"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:value-of select="marc:subfield[@code = 'n']"/>
                </rdatd:P70040>
            </xsl:if>

            <!-- Row 40: $o,p are present -->
            <xsl:if test="marc:subfield[@code = 'o'] and marc:subfield[@code = 'p']">
                <rdatd:P70016>
                    <xsl:value-of select="concat(marc:subfield[@code = 'o'], ' - ', marc:subfield[@code = 'p'])"/>
                </rdatd:P70016>
                <rdatd:P70039>
                    <xsl:value-of select="marc:subfield[@code = 'o']"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:value-of select="marc:subfield[@code = 'p']"/>
                </rdatd:P70040>
            </xsl:if>
            
            <!-- Note about the timespan -->
            <xsl:if test="string($note) != ''">
                <rdatd:P70045><xsl:value-of select="$note"/></rdatd:P70045>
            </xsl:if>
            
            <!-- Row 45: sum of numeric $x and $z if both numeric -->
            <xsl:if test="marc:subfield[@code = 'x'] and marc:subfield[@code = 'z']">
                <xsl:variable name="xValue" select="number(marc:subfield[@code = 'x'])"/>
                <xsl:variable name="zValue" select="number(marc:subfield[@code = 'z'])"/>
                <xsl:if test="string($xValue) != 'NaN' and string($zValue) != 'NaN'">
                    <rdatd:P70045>
                        <xsl:value-of select="$xValue + $zValue"/>
                    </rdatd:P70045>
                </xsl:if>
            </xsl:if>
            <!-- Rows 68-71: emit $x as note when present -->
            <xsl:if test="marc:subfield[@code = 'x']">
                <rdatd:P70045>
                    <xsl:value-of select="marc:subfield[@code = 'x']"/>
                </rdatd:P70045>
            </xsl:if>
            <!-- Rows 72-75: emit $z as note when present -->
            <xsl:if test="marc:subfield[@code = 'z']">
                <rdatd:P70045>
                    <xsl:value-of select="marc:subfield[@code = 'z']"/>
                </rdatd:P70045>
            </xsl:if>

            <!-- Rows 79: if $3 present, include applies-to note -->
            <xsl:if test="marc:subfield[@code = '3'] and @ind1 = '2'">
                <rdatd:P70045>
                    <xsl:text>Applies to: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = '3']"/>
                </rdatd:P70045>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
</xsl:stylesheet>

