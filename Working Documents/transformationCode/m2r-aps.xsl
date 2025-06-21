<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs marc ex uwf uwmisc"
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
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    version="3.0">
    
    <xsl:import href="m2r-functions.xsl"/>
    
<!-- ACCESS POINTS -->
    
    <!-- identifier for the MARC record, used in main manifestation IRI -->
    <!-- 016a, 035 OCLC or OCoLC, or 010 -->
    <xsl:function name="uwf:recordIdentifier" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']]">
                <xsl:choose>
                    <xsl:when test="$record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = '2']">
                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = '2'])
                            ||normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'lac'
                            ||normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag = '035'][marc:subfield[@code = 'a'][contains(., 'OCoLC') or contains(., 'OCLC')]]">
                <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '035'][marc:subfield[@code = 'a'][contains(., 'OCoLC') or contains(., 'OCLC')]][1]/marc:subfield[@code = 'a'][contains(., 'OCoLC') or contains(., 'OCLC')][1])"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag = '010'][marc:subfield[@code = 'a']]">
                <xsl:value-of select="'lccn'||normalize-space($record/marc:datafield[@tag = '010'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- get content type from MARC record -->
    <!-- content type is 336, this function uses the $a value or looks up the $a value using the $b value
        and uwf:rdaGetTerm336() from m2r-functions -->
    <xsl:function name="uwf:contentType">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '336']">
                <xsl:for-each select="$record/marc:datafield[@tag = '336']">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'a']">
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'b'] and (marc:subfield[@code = '2'] = 'rdaco' or marc:subfield[@code = '2'] = 'rdacontent')">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:value-of select="uwf:rdaGetTerm336(../marc:subfield[@code = '2'], .)"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'h']">
                <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245'][1]/marc:subfield[@code = 'h'][1]) => translate('[]();,.=', '')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- get carrier type from MARC record -->
    <!-- carrier type is 338, this function uses the $a value or looks up the $a value using the $b value
        and uwf:rdaGetTerm338() from m2r-functions -->
    <xsl:function name="uwf:carrierType">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '338']">
                <xsl:for-each select="$record/marc:datafield[@tag = '338']">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'a']">
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'b'] and (marc:subfield[@code = '2'] = 'rdact' or marc:subfield[@code = '2'] = 'rdacarrier')">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:value-of select="uwf:rdaGetTerm338(../marc:subfield[@code = '2'], .)"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- same processing done in the match=245 mode="wor" and mode="exp" templates
        but returns a string instead of the has title property.
        Used in access points and thus IRIs -->
    <xsl:function name="uwf:process245">
        <xsl:param name="record"/>
        <xsl:variable name="copy245">
            <xsl:copy select="$record/marc:datafield[@tag = '245']">
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
                <xsl:when test="(substring($record/marc:leader, 19, 1) = 'i' or substring($record/marc:leader, 19, 1) = 'a')">
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
                                <xsl:choose>
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="uwf:removeBrackets(.)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
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
                                            </xsl:if>                                    
                                        </xsl:for-each>
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
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
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
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
<!-- MAIN APS -->
    <!-- Determines the main work access point -->
    <xsl:function name="uwf:mainWorkAccessPoint">
        <xsl:param name="record"/>
        <xsl:choose>
            <!-- 130 titleWAP -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code = 'f' or @code = 'l' or @code = 'm' or @code = 'o' or @code = 's'])]"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 240 NameX00 +TitleWAP -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 100 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code = 'f' or @code = 'l' or @code = 'm' or @code = 'o' or @code = 's'])]"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 240 NameX10 +TitleWAP-->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 110 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code = 'f' or @code = 'l' or @code = 'm' or @code = 'o' or @code = 's'])]"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 240 NameX11 +TitleWAP-->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 111 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code = 'f' or @code = 'l' or @code = 'm' or @code = 'o' or @code = 's'])]"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 245 NameX00 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 100 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 245 anps -->
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 245 NameX10 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 110 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 245 anps -->
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 245 NameX11 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 111 name subfields -->
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <!-- 245 anps -->
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- just 245 Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <!-- name subfields of the first 7XX ind2 != 2 in the field  -->
                <xsl:variable name="name7XX">
                    <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][@ind2 != '2'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$first7XX/@tag = '700'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                                | $first7XX/marc:subfield[@code = 'd'] | $first7XX/marc:subfield[@code = 'j'] | $first7XX/marc:subfield[@code = 'q']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first7XX/@tag = '710'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first7XX/@tag = '711'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a']  | $first7XX/marc:subfield[@code = 'c'] | $first7XX/marc:subfield[@code = 'e'] | $first7XX/marc:subfield[@code = 'q']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="ap">
                    <!-- 245 anps -->
                    <xsl:value-of select="uwf:process245($record)||$name7XX"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the aggregating work access point. -->
    <xsl:function name="uwf:aggWorkAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
        <xsl:variable name="lang" select="uwf:lcLangCodeToLabel($langCode)"/>
        <xsl:variable name="contentType" select="uwf:contentType($record)"/>
        
        <!-- name subfields of the first 7XX ind2 != 2 in the field  -->
        <xsl:variable name="name7XX">
            <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][@ind2 != '2'][1]"/>
            <xsl:choose>
                <xsl:when test="$first7XX/@tag = '700'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                        | $first7XX/marc:subfield[@code = 'd'] | $first7XX/marc:subfield[@code = 'j'] | $first7XX/marc:subfield[@code = 'q']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
                <xsl:when test="$first7XX/@tag = '710'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
                <xsl:when test="$first7XX/@tag = '711'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a']  | $first7XX/marc:subfield[@code = 'c'] | $first7XX/marc:subfield[@code = 'e'] | $first7XX/marc:subfield[@code = 'q']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <!-- when 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <!-- 130 -->
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <!-- language from 130 or 008 -->
                <xsl:variable name="language">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- + content type (if found) and aggregating work -->
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||' '||$name7XX"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                    <xsl:value-of select="' '||$language"/>
                    <xsl:text> Aggregating work</xsl:text>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- not 130 -->
            <xsl:otherwise>
                <!-- 1XX field - check if it is an aggregator or compiler -->
                <!-- if it is, use as first part of ap -->
                <!-- otherwise it's put later in the ap -->
                <xsl:variable name="agg1XX">
                    <xsl:variable name="first1XX" select="$record/marc:datafield[@tag = '100' or @tag = '110' or @tag = '111'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$first1XX[marc:subfield[@code = 'e'][matches(lower-case(.), 'aggregator|compiler')]]
                            or $first1XX[marc:subfield[@code = 'e'][matches(., '(w/P)(10538)|(10585)|(10444)|(10542)|(10589)|(10448)$')]]">
                            <xsl:value-of select="true()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="false()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- name subfields from 1XX field -->
                <xsl:variable name="name1XX">
                    <xsl:variable name="first1XX" select="$record/marc:datafield[@tag = '100' or @tag = '110' or @tag = '111'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$first1XX/@tag = '100'">
                            <xsl:value-of select="$first1XX/marc:subfield[@code = 'a'] | $first1XX/marc:subfield[@code = 'b'] | $first1XX/marc:subfield[@code = 'c']
                                | $first1XX/marc:subfield[@code = 'd'] | $first1XX/marc:subfield[@code = 'j'] | $first1XX/marc:subfield[@code = 'q']
                                | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first1XX/@tag = '110'">
                            <xsl:value-of select="$first1XX/marc:subfield[@code = 'a'] | $first1XX/marc:subfield[@code = 'b'] | $first1XX/marc:subfield[@code = 'c']
                                | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first1XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first1XX/@tag = '111'">
                            <xsl:value-of select="$first1XX/marc:subfield[@code = 'a']  | $first1XX/marc:subfield[@code = 'c'] | $first1XX/marc:subfield[@code = 'e'] | $first1XX/marc:subfield[@code = 'q']
                                | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first1XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <xsl:choose>
                    <!-- 240 -->
                    <xsl:when test="$agg1XX = true() and $record/marc:datafield[@tag = '240']">
                        <!-- work fields -->
                        <xsl:variable name="workSubfields">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                        </xsl:variable>
                        <!-- language from 240 or 008 -->
                        <xsl:variable name="language">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>. {$lang}</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <!-- put together ap. If 1XX is aggregator, it goes first, otherwise it goes after work subfields -->
                        <xsl:variable name="fullAP">
                            <xsl:value-of select="$name1XX"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$workSubfields"/>
                            <xsl:value-of select="' '||$name7XX||' '||$language"/>
                            <xsl:if test="$contentType != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$contentType"/>
                            </xsl:if>
                            <xsl:text> Aggregating work</xsl:text>
                        </xsl:variable>
                        <xsl:value-of select="$fullAP"/>
                    </xsl:when>
                    
                    <!-- 245 -->
                    <xsl:when test="$record/marc:datafield[@tag = '245']">
                        <!-- 245 anps -->
                        <xsl:variable name="workSubfields">
                            <xsl:value-of select="uwf:process245($record)"/>
                        </xsl:variable>
                        <!-- put together ap. If 1XX is aggregator, it goes first, otherwise it goes after work subfields-->
                        <xsl:variable name="fullAP">
                            <xsl:if test="$agg1XX = true()">
                                <xsl:value-of select="$name1XX"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="$workSubfields"/>
                            <xsl:if test="$agg1XX = false()">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$name1XX"/>
                            </xsl:if>
                            <xsl:value-of select="' '||$name7XX||' '||$lang"/>
                            <xsl:if test="$contentType != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$contentType"/>
                            </xsl:if>
                            <xsl:text> Aggregating work</xsl:text>
                        </xsl:variable>
                        <xsl:value-of select="$fullAP"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the main expression access point. -->
    <xsl:function name="uwf:mainExpressionAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
        <xsl:variable name="lang" select="uwf:lcLangCodeToLabel($langCode)"/>
        <xsl:variable name="contentType" select="uwf:contentType($record)"/>
        <xsl:choose>
            <!-- 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||' '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||' '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||' '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- only 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <!-- name subfields of the first 7XX ind2 != 2 in the field  -->
                <xsl:variable name="name7XX">
                    <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][@ind2 != '2'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$first7XX/@tag = '700'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                                | $first7XX/marc:subfield[@code = 'd'] | $first7XX/marc:subfield[@code = 'j'] | $first7XX/marc:subfield[@code = 'q']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first7XX/@tag = '710'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                        <xsl:when test="$first7XX/@tag = '711'">
                            <xsl:value-of select="$first7XX/marc:subfield[@code = 'a']  | $first7XX/marc:subfield[@code = 'c'] | $first7XX/marc:subfield[@code = 'e'] | $first7XX/marc:subfield[@code = 'q']
                                | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                separator=" "/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$name7XX||' '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:mainManifestationAccessPoint"  expand-text="yes">
        <xsl:param name="record"/>
        
        <!-- same logic as F245 mapping to title proper -->
        <xsl:variable name="titleProper">
            <xsl:variable name="isISBD">
                <xsl:choose>
                    <xsl:when test="(substring($record/marc:leader, 19, 1) = 'i' or substring($record/marc:leader, 19, 1) = 'a')">
                        <xsl:value-of select="true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a'][not(following-sibling::*)] or
                            $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's']) or 
                            ($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]
                            and $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                            <xsl:choose>
                                <!-- remove ending = : ; / if ISBD-->
                                <!-- remove any square brackets [] -->
                                <xsl:when test="$isISBD = true()">
                                    <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                </xsl:when>
                                <!-- remove any square brackets [] if not ISBD -->
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- a with following n, p, s either before or after a b with other title info -->
                        <xsl:otherwise>
                            <!-- put together title from a and any directly following n, p, s fields -->
                            <!-- remove ending = : ; / -->
                            <xsl:variable name="title">
                                <xsl:choose>
                                    <!-- remove ISBD punctuation if ISBD -->
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => uwf:removeBrackets()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- remove any square brackets -->
                            <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                            <!-- if square brackets [] were removed, add not on manifestation -->
                        </xsl:otherwise>
                    </xsl:choose>    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="title">
                        <xsl:choose>
                            <xsl:when test="$isISBD = true()">
                                <xsl:choose>
                                    <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']/preceding-sibling::*">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield">
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
                                    <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']/preceding-sibling::*">
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield">
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
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="manifDate">
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']]">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/position() lt $record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][1]/position()">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="manifName">
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']]">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/position() lt $record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']][1]/position()">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="carrierType">
            <xsl:value-of select="uwf:carrierType($record)"/>
        </xsl:variable>
        
        <xsl:variable name="fullAP">
            <xsl:value-of select="$titleProper||' '||$manifDate||' '||$manifName"/>
            <xsl:if test="$carrierType != ''">
                <xsl:value-of select="$carrierType"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="uwf:stripEndPunctuation($fullAP)"/>
    </xsl:function>
    
<!-- RELATED APS -->
    <!-- generates an access point for a related agent based on the subfields present in the field -->
    <xsl:function name="uwf:agentAccessPoint" expand-text="true">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]00'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] 
                        | $field/marc:subfield[@code = 'b'] 
                        | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'q']
                        | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '720' or ($field/@tag = '880' and contains($field/marc:subfield[@code = '6'], '720'))">
                <xsl:value-of select="uwf:stripEndPunctuation($field/marc:subfield[@code = 'a'])"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '110' or $field/@tag = '610' or $field/@tag = '710' or $field/@tag = '810'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]10'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] 
                        | $field/marc:subfield[@code = 'b'] 
                        | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] 
                        | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '111' or $field/@tag = '611' or $field/@tag = '711' or $field/@tag = '811'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]11'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a']  
                        | $field/marc:subfield[@code = 'c'] 
                        | $field/marc:subfield[@code = 'e'] 
                        | $field/marc:subfield[@code = 'q']
                        | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] 
                        | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- generates an access point for a related work based on the subfields present in the field -->
    <xsl:function name="uwf:relWorkAccessPoint" expand-text="true">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]00'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '610' or $field/@tag = '710' or $field/@tag = '810'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]10'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '611' or $field/@tag = '711' or $field/@tag = '811'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]11'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '630' or $field/@tag = '730' or $field/@tag = '830'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]30'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] 
                        | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] 
                        | $field/marc:subfield[@code = 'k'] 
                        | $field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] 
                        | $field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o']
                        | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'r'] 
                        | $field/marc:subfield[@code = 's']
                        | $field/marc:subfield[@code = 't']"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '440'
                or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '440'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a']
                        | $field/marc:subfield[@code = 'n']
                        | $field/marc:subfield[@code = 'p']"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>

