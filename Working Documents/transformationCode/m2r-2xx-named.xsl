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
    
    <xsl:import href="m2r-functions.xsl"/>
    
    <xsl:template name="F245-xx-a" expand-text="yes">
        <xsl:param name="isISBD"/>
        <xsl:choose>
            <!-- a with no following n, p, or s subfields either immediately following or following after other title info -->
            <xsl:when test="marc:subfield[@code = 'a'][not(following-sibling::*)] or
                marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's']) or 
                (marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]
                and marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                <rdamd:P30156>
                    <xsl:choose>
                        <!-- remove ending = : ; / if ISBD-->
                        <!-- remove any square brackets [] -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <!-- remove any square brackets [] if not ISBD -->
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdamd:P30156>
                <!-- if square brackets [] were removed, add note on manifestation -->
                <xsl:if test="uwf:testBrackets(marc:subfield[@code = 'a']) = true()">
                    <rdamd:P30137>Title proper {uwf:getBracketedData(marc:subfield[@code = 'a'])} is assigned by the cataloguing agency.</rdamd:P30137>
                </xsl:if>
            </xsl:when>
            <!-- a with following n, p, s either before or after a b with other title info -->
            <xsl:otherwise>
                <!-- put together title from a and any directly following n, p, s fields -->
                <!-- remove ending = : ; / -->
                <xsl:variable name="title">
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => uwf:removeBrackets()"/>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- remove any square brackets -->
                <rdamd:P30156>
                    <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                </rdamd:P30156>
                <!-- if square brackets [] were removed, add not on manifestation -->
                <xsl:if test="uwf:testBrackets($title) = true()">
                    <rdamd:P30137>Title proper {uwf:getBracketedData($title)}is assigned by the cataloguing agency.</rdamd:P30137>
                </xsl:if>
                <xsl:if test="$isISBD = true()">
                    <xsl:if test="uwf:testBrackets(marc:subfield[@code = 'a']) = true()">
                        <rdamd:P30137>Title proper {uwf:getBracketedData(marc:subfield[@code = 'a'])} is assigned by the cataloguing agency.</rdamd:P30137>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::*[@code = 'b'])]">
                        <xsl:if test="uwf:testBrackets(.) = true()">
                            <rdamd:P30137>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F245-xx-notA" expand-text="yes">
        <xsl:param name="isISBD"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$isISBD = true()">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'c']">
                            <xsl:for-each select="marc:subfield[@code = 'c']/preceding-sibling::*">
                                <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield">
                                <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'c']">
                            <xsl:for-each select="marc:subfield[@code = 'c']/preceding-sibling::*">
                                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield">
                                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <rdamd:P30156>
            <xsl:choose>
                <!-- remove ISBD punctuation if ISBD -->
                <xsl:when test="$isISBD = true()">
                    <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                </xsl:otherwise>
            </xsl:choose>
        </rdamd:P30156>
        <rdamd:P30137>Title proper is assigned by the cataloguing agency.</rdamd:P30137>
    </xsl:template>
    
    <xsl:template name="F245-xx-b-ISBD">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:call-template name="F245-xx-ISBD">
                <xsl:with-param name="subfield" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-c-ISBD">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F245-xx-ISBD">
                <xsl:with-param name="subfield" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-ISBD" expand-text="yes">
        <!-- does not account for subsequent titles (aggregates) -->
        <xsl:param name="subfield"/>
        <xsl:variable name="ISBDString">
            <xsl:choose>
                <xsl:when test="$subfield/@code = 'b' and (contains(., ' = ') or ends-with(., ' =') or ends-with($subfield/preceding-sibling::*[1], '=')) and $subfield/following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']">
                    <xsl:for-each select="$subfield | following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$subfield"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- separate by parallel statements = -->
        <xsl:for-each select="tokenize($ISBDString, ' = ')">
            <!-- only process each tokenized string if it is not blank -->
            <xsl:if test="exists(.)">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <xsl:choose>
                            <!-- If : is present, there is other title information, separate out -->
                            <xsl:when test="contains(., ' : ')">
                                <xsl:for-each select="tokenize(., ' : ')"> 
                                    <xsl:choose>
                                        <!-- if / is present there is statement of responsibility -->
                                        <!-- : always precedes / if it is present -->
                                        <xsl:when test="contains(., ' / ')">
                                            <xsl:for-each select="tokenize(., ' / ')">
                                                <xsl:choose>
                                                    <!-- this means it came before / and is other title info -->
                                                    <xsl:when test="position() = 1">
                                                        <rdamd:P30142>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                        </rdamd:P30142>
                                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                                            <rdamd:P30137>
                                                                <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <!-- this is statement of responsibility, split by ;  -->
                                                    <xsl:otherwise>
                                                        <xsl:for-each select="tokenize(., ' ; ')">
                                                            <rdamd:P30105>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                            </rdamd:P30105>
                                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no / included in subfield, or / is at the end of the subfield -->
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <!-- this means it came before the : and is based on the preceding subfield's ending punctuation -->
                                                <xsl:when test="position() = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                                            <rdamd:P30156>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                            </rdamd:P30156>
                                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                                            <rdamd:P30142>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                            </rdamd:P30142>
                                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                                <rdamd:P30105>
                                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                                </rdamd:P30105>
                                                                <xsl:if test="uwf:testBrackets(.) = true()">
                                                                    <rdamd:P30137>
                                                                        <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                    </rdamd:P30137>
                                                                </xsl:if>
                                                            </xsl:for-each>   
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:choose>
                                                                <xsl:when test="$subfield/@code = 'b'">
                                                                    <rdamd:P30142>
                                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                                    </rdamd:P30142>
                                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                                        <rdamd:P30137>
                                                                            <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                        </rdamd:P30137>
                                                                    </xsl:if>
                                                                </xsl:when>
                                                                <xsl:when test="$subfield/@code = 'c'">
                                                                    <xsl:for-each select="tokenize(., ' ; ')">
                                                                        <rdamd:P30105>
                                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                                        </rdamd:P30105>
                                                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                                                            <rdamd:P30137>
                                                                                <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                            </rdamd:P30137>
                                                                        </xsl:if>
                                                                    </xsl:for-each> 
                                                                </xsl:when>
                                                                <xsl:otherwise/>
                                                            </xsl:choose>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <!-- this is after : and is other title info -->
                                                <xsl:otherwise>
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no other title info, but has statement of responsibility -->
                            <xsl:when test="contains(., ' / ') and not(contains(., ' : '))">
                                <xsl:for-each select="tokenize(., ' / ')">
                                    <xsl:choose>
                                        <!-- first is based on preceding subfield's ending punctuation -->
                                        <xsl:when test="position() = 1">
                                            <xsl:choose>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                                    <rdamd:P30156>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30156>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                                    <xsl:for-each select="tokenize(., ' ; ')">
                                                        <rdamd:P30105>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                        </rdamd:P30105>
                                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                                            <rdamd:P30137>
                                                                <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:for-each>   
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:choose>
                                                        <xsl:when test="$subfield/@code = 'b'">
                                                            <rdamd:P30142>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                            </rdamd:P30142>
                                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:when test="$subfield/@code = 'c'">
                                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                                <rdamd:P30105>
                                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                                </rdamd:P30105>
                                                                <xsl:if test="uwf:testBrackets(.) = true()">
                                                                    <rdamd:P30137>
                                                                        <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                    </rdamd:P30137>
                                                                </xsl:if>
                                                            </xsl:for-each> 
                                                        </xsl:when>
                                                        <xsl:otherwise/>
                                                    </xsl:choose>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <!-- the rest is statement of responsibility, split by ;  -->
                                        <xsl:otherwise>
                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                <rdamd:P30105>
                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                </rdamd:P30105>
                                                <xsl:if test="uwf:testBrackets(.) = true()">
                                                    <rdamd:P30137>
                                                        <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                    </rdamd:P30137>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- no internal ISBD punctuation, property is based on preceding subfield's ending punctuation -->
                                <xsl:choose>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                        <rdamd:P30142>
                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                        </rdamd:P30142>
                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                            <rdamd:P30137>
                                                <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                            </rdamd:P30137>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                        <rdamd:P30156>
                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                        </rdamd:P30156>
                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                            <rdamd:P30137>
                                                <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                            </rdamd:P30137>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                        <xsl:for-each select="tokenize(., ' ; ')">
                                            <rdamd:P30105>
                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            </rdamd:P30105>
                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                <rdamd:P30137>
                                                    <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>   
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:choose>
                                            <xsl:when test="$subfield/@code = 'b'">
                                                <rdamd:P30142>
                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                </rdamd:P30142>
                                                <xsl:if test="uwf:testBrackets(.) = true()">
                                                    <rdamd:P30137>
                                                        <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                    </rdamd:P30137>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:when test="$subfield/@code = 'c'">
                                                <xsl:for-each select="tokenize(., ' ; ')">
                                                    <rdamd:P30105>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30105>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:for-each> 
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose> 
                    </xsl:when>
                    <!-- on right side of =  -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- If : is present, there is other title information, separate out -->
                            <xsl:when test="contains(., ' : ')">
                                <xsl:for-each select="tokenize(., ' : ')"> 
                                    <xsl:choose>
                                        <!-- if / is present there is statement of responsibility -->
                                        <!-- : always precedes / if it is present -->
                                        <xsl:when test="contains(., ' / ')">
                                            <xsl:for-each select="tokenize(., ' / ')">
                                                <xsl:choose>
                                                    <!-- this means it came before / and is other title info -->
                                                    <xsl:when test="position() = 1">
                                                        <rdamd:P30142>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                        </rdamd:P30142>
                                                        <xsl:if test="uwf:testBrackets(.) = true()">
                                                            <rdamd:P30137>
                                                                <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <!-- this is statement of responsibility, split by ;  -->
                                                    <xsl:otherwise>
                                                        <xsl:for-each select="tokenize(., ' ; ')">
                                                            <rdamd:P30105>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                            </rdamd:P30105>
                                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no / included in subfield, or / is at the end of the subfield -->
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <!-- this means it came before the : is title proper -->
                                                <xsl:when test="position() = 1">
                                                    <rdamd:P30156>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30156>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <!-- this is after : and is other title info -->
                                                <xsl:otherwise>
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="uwf:testBrackets(.) = true()">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no other title info, but has statement of responsibility -->
                            <xsl:when test="contains(., ' / ') and not(contains(., ' : '))">
                                <xsl:for-each select="tokenize(., ' / ')">
                                    <xsl:choose>
                                        <!-- first is title proper -->
                                        <xsl:when test="position() = 1">
                                            <rdamd:P30156>
                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            </rdamd:P30156>
                                            <xsl:if test="uwf:testBrackets(.) = true()">
                                                <rdamd:P30137>
                                                    <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:when>
                                        <!-- the rest is statement of responsibility, split by ;  -->
                                        <xsl:otherwise>
                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                <rdamd:P30105>
                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                                </rdamd:P30105>
                                                <xsl:if test="uwf:testBrackets(.) = true()">
                                                    <rdamd:P30137>
                                                        <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                                    </rdamd:P30137>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- If there is no additional punctuation, it is a parallel title -->
                            <xsl:otherwise>
                                <rdamd:P30156>
                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                </rdamd:P30156>
                                <xsl:if test="uwf:testBrackets(.) = true()">
                                    <rdamd:P30137>
                                        <xsl:text>Title proper {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-b-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30142>
                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
            </rdamd:P30142>
            <xsl:if test="uwf:testBrackets(.) = true()">
                <rdamd:P30137>
                    <xsl:text>Other title information {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-c-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30105>
                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
            </rdamd:P30105>
            <xsl:if test="uwf:testBrackets(.) = true()">
                <rdamd:P30137>
                    <xsl:text>Statement of responsibility {uwf:getBracketedData(.)} is assigned by the cataloguing agency.</xsl:text>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-f-g">
        <xsl:for-each select="marc:subfield[@code='f'] | marc:subfield[@code = 'g'] ">
            <rdamd:P30278>
                <xsl:value-of select="replace(., '\s*[:/=\.,]$', '')"/>
            </rdamd:P30278>
        </xsl:for-each>
     </xsl:template>
    <xsl:template name="F245-xx-h" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <rdamd:P30335>
                <xsl:value-of select="normalize-space() => replace('^\[','') => replace('[:=/\.;]$','') => replace('[\]]\s*$','')"/>
            </rdamd:P30335>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F245-xx-k" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'k']">
            <rdamd:P30137>
                <xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2)) => replace('\s*[,\.;,]$', '') => concat('.')"/>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    
   <!-- F246 -->
    <xsl:template name="F246-xx-ind" expand-text="yes">
        <xsl:text>Note on variant title: </xsl:text>
        <xsl:choose>
            <xsl:when
                test="marc:subfield[@code = 'i' or @code = 'a' or @code = 'b' or @code = 'f' or @code = 'n' or @code = 'p' or @code = 'g' or @code = 'h']">
                <xsl:for-each select="marc:subfield[@code = 'i']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                    <xsl:text>: </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'f' or @code = 'n' or @code = 'p']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'g' or @code = 'h']">
                    <xsl:if test="position() = 1">
                        <xsl:text>;</xsl:text>
                    </xsl:if>
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>: </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@ind2"/>
                <xsl:text>]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F246-xx-noind" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:value-of select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>: </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b' or @code = 'f' or @code = 'n' or @code = 'p']">
            <xsl:if test="position() != last()">
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- F260 -->
    <xsl:template name="F260-xx-abc">
        <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']"/>
    </xsl:template>
    
    <xsl:template name="F260-xx-efg">
        <xsl:value-of select="marc:subfield[@code = 'e'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']"/>
    </xsl:template>
    
    <xsl:template name="F260-xx-abc-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']">
            <xsl:text>$</xsl:text>
            <xsl:value-of select="@code"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F260-xx-efg-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'e'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']">
            <xsl:text>$</xsl:text>
            <xsl:value-of select="@code"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F260-xx-a" expand-text="yes">
        <xsl:choose>
            <xsl:when test="following-sibling::*[1]/@code = 'b' and matches(following-sibling::*[1]/text(), '(dist)|(sold)|(marketed)|(sale by)|(exported)|(imported)|(offered)|(supplied)|(obtained)|(circulated)|(available)|(leased)|(offered)')">
                <rdamd:P30085>
                    <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]', '')"/>
                </rdamd:P30085>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30088>
                    <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]', '')"/>
                </rdamd:P30088>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F260-xx-b" expand-text="yes">
        <xsl:choose>
            <xsl:when test=" matches(., '(dist)|(sold)|(marketed)|(sale by)|(exported)|(imported)|(offered)|(supplied)|(obtained)|(circulated)|(available)|(leased)|(offered)')">
                <rdamd:P30173>
                    <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]', '')"/>
                </rdamd:P30173>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30176>
                    <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]', '')"/>
                </rdamd:P30176>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F260-xx-c" expand-text="yes">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1]/@code = 'b' and matches(preceding-sibling::*[1]/text(), '(dist)|(sold)|(marketed)|(sale by)|(exported)|(imported)|(offered)|(supplied)|(obtained)|(circulated)|(available)|(leased)|(offered)')">
                <xsl:analyze-string select="."
                    regex="c?\d\d\d\d">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'c')">
                                <rdamd:P30280>
                                    <xsl:value-of select="."/>
                                </rdamd:P30280>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdamd:P30008>
                                    <xsl:value-of select="."/>
                                </rdamd:P30008>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:matching-substring>
                </xsl:analyze-string>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="."
                    regex="[c©]?\d\d\d\d">
                    <xsl:matching-substring>
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'c') or starts-with(., '©')">
                                <rdamd:P30280>
                                    <xsl:value-of select="."/>
                                </rdamd:P30280>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdamd:P30011>
                                    <xsl:value-of select="."/>
                                </rdamd:P30011>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:matching-substring>
                </xsl:analyze-string> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F260-xx-e" expand-text="yes">
        <rdamd:P30087>
            <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]()', '')"/>
        </rdamd:P30087>
    </xsl:template>
    
    <xsl:template name="F260-xx-f" expand-text="yes">
        <rdamd:P30175>
            <xsl:value-of select="replace(., '( [:;,]$)|(,$)', '') => translate('[]()', '')"/>
        </rdamd:P30175>
    </xsl:template>
    
    <xsl:template name="F260-xx-g" expand-text="yes">
        <xsl:analyze-string select="."
            regex="[c©]?\d\d\d\d">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test="starts-with(., 'c') or starts-with(., '©')">
                        <rdamd:P30280>
                            <xsl:value-of select="."/>
                        </rdamd:P30280>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdamd:P30010>
                            <xsl:value-of select="."/>
                        </rdamd:P30010>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string> 
    </xsl:template>
    
    <!-- F264-xx-abc processes MARC 264 entered with ISBD punctuation as an RDA "statement."
         All subfield values are concatenated with a space added between
             (may result in double-spaces in the output)-->
    <xsl:template name="F264-xx-abc" expand-text="yes">
        <xsl:value-of select="marc:subfield[not(@code = '6')][not(@code = '3')]"
                    separator=" "/>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- F264-xx-abc-notISBD processes MARC 264 entered without ISBD punctuation as an RDA "statement". All subfield values are concatenated with subfield codes and a space inserted. There may be double spaces in the output. -->
    <xsl:template name="F264-xx-abc-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[not(@code = '6')][not(@code = '3')]">
            <xsl:text>$</xsl:text>
            <xsl:value-of select="@code"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- F264-x0-a_b_c processes each MARC 264 subfield even if repeated then creates values for every value on either side of an equal sign, if present, except for $c, where no parallel statements are anticipated. Also strips terminal punctuation in the subfields. -->
    <xsl:template name="F264-x0-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30086>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')  => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30086>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30086>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                substring-before(' :') => translate('[]', '')"/></xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30086>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30174>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30174>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30174>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30174>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30009</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x1-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x1-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30088>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30088>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30088>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30088>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30176>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30176>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30176>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30176>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30011</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x2-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x2-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30085>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30085>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30085>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30085>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30173>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30173>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30173>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30173>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30008</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x3-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x3-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30087>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' ;') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30087>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30087>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30087>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30175>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30175>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30175>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30175>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30010</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F264-x4-c" expand-text="yes">
        <rdamd:P30137>
            <xsl:text>Copyright notice date: </xsl:text>
            <xsl:for-each select="marc:subfield[@code = 'c']">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(ends-with(., '.'))">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </rdamd:P30137>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30007</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F264-xx-c">
        <xsl:param name="rdaProp"/>
        <xsl:choose>
            <!-- 1234 or [1234] -->
            <xsl:when test="matches(., '^\[?\d\d\d\d\]?$')">
                <!-- use as date but remove any brackets -->
                <xsl:element name="{$rdaProp}">
                    <xsl:value-of select="translate(., '[]', '')"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- more complicated. multiple dates, other characters, etc. -->
                <!-- separate out all groups of 4 digits -->
                <xsl:variable name="c">
                    <xsl:analyze-string select="." regex="\d\d\d\d">
                        <xsl:matching-substring>
                            <xsl:sequence select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <!-- select first group of 4 digits to use -->
                <xsl:analyze-string select="$c[1]"
                    regex="^\d\d\d\d">
                    <xsl:matching-substring>
                        <xsl:element name="{$rdaProp}">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
