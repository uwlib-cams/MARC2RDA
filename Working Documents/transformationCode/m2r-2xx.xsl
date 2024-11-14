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
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-2xx-named.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    
    <xsl:template match="marc:datafield[@tag = '245'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '245']" mode="wor" >
        <xsl:call-template name="getmarc"/>
        <!-- copy of 245 where last subfield's ending punctuation (, or .) is removed -->
        <xsl:variable name="copy245">
            <xsl:copy select=".">
                <xsl:copy select="./@tag"/>
                <xsl:for-each select="child::*">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <marc:subfield>
                                <xsl:attribute name="code" select="./@code"/>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </marc:subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:copy>
        </xsl:variable>
        <xsl:variable name="isISBD">
            <xsl:choose>
                <xsl:when test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$copy245/marc:datafield">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'a']">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'a'][not(following-sibling::*)] or
                        marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's']) or 
                        (marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]
                        and marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                        <xsl:for-each select="marc:subfield[@code='a']">
                            <rdawd:P10088>
                                <xsl:choose>
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="uwf:removeBrackets(.)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </rdawd:P10088>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="title">
                            <xsl:choose>
                                <!-- remove ISBD punctuation if ISBD -->
                                <xsl:when test="$isISBD = true()">
                                    <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                        <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="uwf:removeBrackets(marc:subfield[@code = 'a'])"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                        <xsl:value-of select="uwf:removeBrackets(.)"/>
                                        <xsl:if test="position() != last()">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <rdawd:P10088>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </rdawd:P10088>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="title">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'c']">
                            <xsl:value-of select="marc:subfield[@code = 'c']/preceding-sibling::*" separator=" "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="marc:subfield" separator=" "/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <rdawd:P10088>
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdawd:P10088>
            </xsl:otherwise>
        </xsl:choose>
        </xsl:for-each>
    </xsl:template>    
    <xsl:template match="marc:datafield[@tag = '245'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '245']" 
        mode="man origMan">
        <xsl:param name="type"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="isISBD">
            <xsl:choose>
                <xsl:when test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- copy of 245 where last subfield's ending punctuation (, or .) is removed -->
        <xsl:variable name="copy245">
            <xsl:copy select=".">
                <xsl:copy select="./@tag"/>
                <xsl:for-each select="child::*">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <marc:subfield>
                                <xsl:attribute name="code" select="./@code"/>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </marc:subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:copy>
        </xsl:variable>
        <xsl:for-each select="$copy245/marc:datafield">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'a']">
                <xsl:call-template name="F245-xx-a">
                    <xsl:with-param name="isISBD" select="$isISBD"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="F245-xx-notA">
                    <xsl:with-param name="isISBD" select="$isISBD"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when
                test="$isISBD = true()">
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:call-template name="F245-xx-b-ISBD"/>
                </xsl:if>
                <xsl:call-template name="F245-xx-c-ISBD"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:call-template name="F245-xx-b-notISBD"/>
                </xsl:if>
                <xsl:call-template name="F245-xx-c-notISBD"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="F245-xx-f-g"/>
        <xsl:if test="$type != 'origMan'">
            <xsl:call-template name="F245-xx-h"/>
        </xsl:if>
        <xsl:call-template name="F245-xx-k"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 255 - Cartographic Mathematical Data -->
    <!-- Expression -->
    <xsl:template match="marc:datafield[@tag = '255'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '255']"
        mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'a'][contains(., '[0-9]')]">
            <rdaed:P20228>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdaed:P20228>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a'][not(contains(., '[0-9]'))]">
            <rdaed:P20291>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdaed:P20291>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdaed:P20216>
                <xsl:value-of select="marc:subfield[@code = 'b']"/>
            </rdaed:P20216>
        </xsl:if>
    </xsl:template>
    <!-- Work -->
    <xsl:template match="marc:datafield[@tag = '255'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '255']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdawd:P10081>
                <xsl:value-of 
                    select="replace(marc:subfield[@code = 'c'], '^\(|\)$|\).$|\.$', '') => normalize-space()"
                />
            </rdawd:P10081>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'd']">
            <rdawd:P10082>
                <xsl:value-of select="marc:subfield[@code = 'd']"/>
            </rdawd:P10082>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'e']">
            <rdawd:P10214>
                <xsl:value-of select="marc:subfield[@code = 'e']"/>
            </rdawd:P10214>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'f']">
            <rdawd:P10024>
                <xsl:value-of select="concat('Outer G-ring coordinate pairs: ', marc:subfield[@code = 'f'])"/>
            </rdawd:P10024>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'g']">
            <rdawd:P10024>
                <xsl:value-of select="concat('Exclusion G-ring coordinate pairs: ', marc:subfield[@code = 'g'])"/>
            </rdawd:P10024>
        </xsl:if>   
    </xsl:template>
 
    <!-- 257 - Country of Producing Entity -->
    <xsl:template match="marc:datafield[@tag = '257'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '257']" 
        mode="wor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="suba" select="."/>
            <xsl:choose>
                <xsl:when test="matches(., '\S+.*;.*\S+')">
                    <xsl:for-each select="tokenize(., ';')">
                        <xsl:choose>
                            <xsl:when test="$sub2">
                                <!-- this is okay because it is only minted when there is a source, else there would be a problem with multiple IRIs coming from the same node -->
                                <rdawo:P10316 rdf:resource="{uwf:placeIRI($baseIRI, $suba, ., $sub2)}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdawd:P10316>
                                    <xsl:value-of select="replace(., '\.$|;$', '') => normalize-space()"/>
                                </rdawd:P10316>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$sub2">
                            <rdawo:P10316 rdf:resource="{uwf:placeIRI($baseIRI, ., ., $sub2)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdawd:P10316>
                                <xsl:value-of select="replace(., '\.$|;$', '') => normalize-space()"/>
                            </rdawd:P10316>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:choose>
                <xsl:when test="contains(., 'id.loc.gov/vocabulary/geographicAreas')">
                    <rdawo:P10316 rdf:resource="{.}"/>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/authorities/names/')">
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas(.)"/>
                    <xsl:choose>
                        <xsl:when test="$gac != ''">
                            <rdawo:P10316 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {.}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>Unable to parse 257 $0 value of {.}</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <xsl:choose>
                <xsl:when test="contains(., 'id.loc.gov/vocabulary/geographicAreas')">
                    <rdawo:P10316 rdf:resource="{.}"/>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/authorities/names/')">
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas(.)"/>
                    <xsl:choose>
                        <xsl:when test="$gac != ''">
                            <rdawo:P10316 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {.}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/rwo/')">
                    <xsl:variable name="id">
                        <xsl:variable name="tokenizedIRI" select="tokenize(., '/')"/>
                        <xsl:value-of select="$tokenizedIRI[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="authorityFile" select="concat('http://id.loc.gov/authorities/names/', $id)"/>
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas($authorityFile)"/>
                    <xsl:choose>
                        <xsl:when test="$gac != ''">
                            <rdawo:P10316 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {$authorityFile}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawo:P10316 rdf:resource="{.}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '257'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '257']" 
        mode="pla" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <xsl:variable name="suba" select="."/>
                <xsl:choose>
                    <xsl:when test="matches(., '\S+.*;.*\S+')">
                        <xsl:for-each select="tokenize(., ';')">
                            <rdf:Description rdf:about="{uwf:placeIRI($baseIRI, $suba, ., $sub2)}">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                                <rdapo:P70019 rdf:resource="{uwf:nomenIRI($baseIRI, $suba, 'plaNom', ., $sub2)}"/>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:Description rdf:about="{uwf:placeIRI($baseIRI, ., ., $sub2)}">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                            <rdapo:P70019 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'plaNom', ., $sub2)}"/>
                        </rdf:Description>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '257'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '257']" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <xsl:variable name="suba" select="."/>
                <xsl:choose>
                    <xsl:when test="matches(., '\S+.*;.*\S+')">
                        <xsl:for-each select="tokenize(., ';')">
                            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, $suba, 'plaNom', ., $sub2)}">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                                <rdand:P80068>
                                    <xsl:value-of select="replace(., '\.$|;$', '') => normalize-space()"/>
                                </rdand:P80068>
                                <xsl:copy-of select="uwf:s2Nomen($sub2)"/>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'plaNom', ., $sub2)}">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                            <rdand:P80068>
                                <xsl:value-of select="replace(., '\.$|;$', '') => normalize-space()"/>
                            </rdand:P80068>
                            <xsl:copy-of select="uwf:s2Nomen($sub2)"/>
                        </rdf:Description>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- template immediately below, MARC 264:
         all values cocatenated go into RDA "statements";
         if there's isbd punctuation, subfield are not output;
         if there is not isbd punctuation, subfield codes are output.
         If there is a MARC $3, that value is appended to the RDA statement only.
         Repeated subfields and parallel values:
             considered insignificant to the RDA statements as output below.
         After statements are output, templates are called to process individual fields.
    -->
    <xsl:template match="marc:datafield[@tag = '264'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '264']" mode="man origMan">
        <xsl:param name="type"/>
        <xsl:call-template name="getmarc"/>
        <xsl:if test="not(contains($type, 'reproduction'))">
            <xsl:choose>
                <!-- check if ISBD punctuation -->
                <xsl:when
                    test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
                    <xsl:choose>
                        <xsl:when test="@ind2 = '0'">
                            <rdamd:P30110>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30110>
                            <xsl:call-template name="F264-x0-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '1'">
                            <rdamd:P30111>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30111>
                            <xsl:call-template name="F264-x1-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '2'">
                            <rdamd:P30108>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30108>
                            <xsl:call-template name="F264-x2-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '3'">
                            <rdamd:P30109>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30109>
                            <xsl:call-template name="F264-x3-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '4'">
                            <xsl:call-template name="F264-x4-c"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- no ISBD punctuation -->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@ind2 = '0'">
                            <rdamd:P30110>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30110>
                            <xsl:call-template name="F264-x0-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '1'">
                            <rdamd:P30111>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30111>
                            <xsl:call-template name="F264-x1-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '2'">
                            <rdamd:P30108>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30108>
                            <xsl:call-template name="F264-x2-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '3'">
                            <rdamd:P30109>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30109>
                            <xsl:call-template name="F264-x3-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '4'">
                            <xsl:call-template name="F264-x4-c"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
