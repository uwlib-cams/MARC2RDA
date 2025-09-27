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
    xmlns:m2r="http://marc2rda.info/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
<!-- ACCESS POINTS -->
    
    <!-- identifier for the MARC record, used in main manifestation IRI -->
    <!-- 016a, 035 OCLC or OCoLC, or 010 -->
    <xsl:function name="m2r:recordIdentifier" expand-text="yes">
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
    <xsl:function name="m2r:contentType">
        <xsl:param name="record"/>
        <xsl:variable name="termNodes">
            <terms>
                <xsl:choose>
                    <xsl:when test="$record/marc:datafield[@tag = '336'] | $record/marc:datafield[@tag = '337'] | $record/marc:datafield[@tag = '338']">
                        <xsl:for-each select="$record/marc:datafield[@tag = '336'] | $record/marc:datafield[@tag = '337'] | $record/marc:datafield[@tag = '338']">
                            <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                                <xsl:choose>
                                    <xsl:when test="contains(., 'rdaregistry.info/termList/')">
                                        <xsl:copy-of select="m2r:rdaIRILookupForAP(., 'expression')"/>
                                    </xsl:when>
                                    <xsl:when test="contains(., 'id.loc.gov/vocabulary/')">
                                        <xsl:copy-of select="m2r:lcIRILookupForAP(., 'expression')"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="marc:subfield[@code = '2'][starts-with(normalize-space(lower-case(.)), 'rda')]">
                                <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
                                    <xsl:copy-of select="m2r:rdalcTermCodeLookupForAP(., 'expression')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </terms>
        </xsl:variable>
        <xsl:variable name="sortedTerms">
            <xsl:for-each-group select="$termNodes/terms/term" group-by="text()">
                <xsl:sort select="text()"/>
                <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))||substring(current-grouping-key(), 2)"/>
                <xsl:if test="position() != last()">
                    <xsl:text> : </xsl:text>
                </xsl:if>
            </xsl:for-each-group>
        </xsl:variable>
        <xsl:value-of select="$sortedTerms"/>
    </xsl:function>
    
    <!-- get carrier type from MARC record -->
    <!-- carrier type is 338, this function uses the $a value or looks up the $a value using the $b value
        and m2r:rdaGetTerm338() from m2r-functions -->
    <xsl:function name="m2r:carrierType">
        <xsl:param name="record"/>
        <xsl:param name="isElectronic"/>
        <xsl:param name="isMicroform"/>
        <xsl:variable name="termNodes">
            <terms>
                <xsl:choose>
                    <xsl:when test="$record/marc:datafield[@tag = '336'] | $record/marc:datafield[@tag = '337'] | $record/marc:datafield[@tag = '338']">
                        <xsl:for-each select="$record/marc:datafield[@tag = '336'] | $record/marc:datafield[@tag = '337'] | $record/marc:datafield[@tag = '338']">
                            <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                                <xsl:choose>
                                    <xsl:when test="contains(., 'rdaregistry.info/termList/')">
                                        <xsl:copy-of select="m2r:rdaIRILookupForAP(., 'manifestation')"/>
                                    </xsl:when>
                                    <xsl:when test="contains(., 'id.loc.gov/vocabulary/')">
                                        <xsl:copy-of select="m2r:lcIRILookupForAP(., 'manifestation')"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:if test="marc:subfield[@code = '2'][starts-with(normalize-space(lower-case(.)), 'rda')]">
                                <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
                                    <xsl:copy-of select="m2r:rdalcTermCodeLookupForAP(., 'manifestation')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </terms>
        </xsl:variable>
        <xsl:variable name="sortedTerms">
            <xsl:choose>
                <xsl:when test="$isElectronic = true()">
                    <xsl:choose>
                        <xsl:when test="$termNodes/terms/term[matches(lower-case(.), 'computer|online')]">
                            <xsl:for-each-group select="$termNodes/terms/term[matches(lower-case(.), 'computer|online')]" 
                                group-by="text()">
                                <xsl:sort select="text()"/>
                                <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))||substring(current-grouping-key(), 2)"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> : </xsl:text>
                                </xsl:if>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Electronic'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isMicroform = true()">
                    <xsl:choose>
                        <xsl:when test="$termNodes/terms/term[matches(lower-case(.), 'micro') and not(matches(lower-case(.), 'microscope'))]">
                            <xsl:for-each-group select="$termNodes/terms/term[matches(lower-case(.), 'micro') and not(matches(lower-case(.), 'microscope'))]" 
                                group-by="text()">
                                <xsl:sort select="text()"/>
                                <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))||substring(current-grouping-key(), 2)"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> : </xsl:text>
                                </xsl:if>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'Microform'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each-group select="$termNodes/terms/term" group-by="text()">
                        <xsl:sort select="text()"/>
                        <xsl:value-of select="upper-case(substring(current-grouping-key(), 1, 1))||substring(current-grouping-key(), 2)"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> : </xsl:text>
                        </xsl:if>
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$sortedTerms"/>
    </xsl:function>
    
    <xsl:function name="m2r:manifVersion">
        <xsl:param name="record"/>
        <xsl:for-each select="$record/marc:datafield[@tag = '250']/marc:subfield[@code = 's'] | $record/marc:datafield[@tag = '250']/marc:subfield[@code = 'a'][not(matches(lower-case(.), 'first edition|first ed.|1st edition|1st ed.'))]">
            <xsl:if test="./@code = 's'">
                <xsl:value-of select="m2r:stripEndPunctuation(upper-case(substring(., 1, 1))||substring(., 2))"/>
            </xsl:if>
            <xsl:if test="./@code = 'a'">
                <xsl:value-of select="m2r:stripEndPunctuation(upper-case(substring(., 1, 1))||substring(., 2))"/>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text> : </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="m2r:expVersion">
        <xsl:param name="record"/>
        <xsl:variable name="expVersion">
            <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 's']">
                <xsl:value-of select="m2r:stripEndPunctuation(upper-case(substring(., 1, 1))||substring(., 2))"/>
                <xsl:text> : </xsl:text>
            </xsl:for-each>
            <xsl:for-each select="$record/marc:datafield[@tag = '250']/marc:subfield[@code = 'a']">
                <xsl:variable name="f250a" select="."/>
                <xsl:variable name="match26Xb">
                    <xsl:value-of select="if (some $b in $record/marc:datafield[starts-with(@tag, '26')]/marc:subfield[@code = 'b']
                        satisfies starts-with(lower-case($f250a), substring-before(lower-case($b), ' '))) then 'True' else 'False'"/>
                </xsl:variable>
                <xsl:if test="$match26Xb = 'False'">
                    <xsl:value-of select="m2r:stripEndPunctuation(upper-case(substring(., 1, 1))||substring(., 2))"/>
                    <xsl:text> : </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="replace($expVersion, ' : $', '')"/>
    </xsl:function>
    
    <xsl:function name="m2r:workAPFields">
        <xsl:param name="field"/>
        <xsl:value-of select="$field/marc:subfield[@code = 'a']
            | $field/marc:subfield[@code = 'd']
            | $field/marc:subfield[@code = 'k'] 
            | $field/marc:subfield[@code = 'n'] 
            | $field/marc:subfield[@code = 'p']
            | $field/marc:subfield[@code = 't']
            | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code = 'f' or @code = 'l' or @code = 'm' or @code = 'o' or @code = 's'])]"/>
    </xsl:function>
    
    <xsl:function name="m2r:expressionAPFields">
        <xsl:param name="field"/>
        <xsl:value-of select="$field/marc:subfield[@code = 'a']
            | $field/marc:subfield[@code = 'd']
            | $field/marc:subfield[@code = 'k'] 
            | $field/marc:subfield[@code = 'n'] 
            | $field/marc:subfield[@code = 'p']
            | $field/marc:subfield[@code = 't']
            | $field/marc:subfield[@code = 'g']
            | $field/marc:subfield[@code = 'f']
            | $field/marc:subfield[@code = 'l']
            | $field/marc:subfield[@code = 'm']
            | $field/marc:subfield[@code = 'o']
            | $field/marc:subfield[@code = 'r']
            | $field/marc:subfield[@code = 's']"/>
    </xsl:function>
    
    <!-- same processing done in the match=245 mode="wor" and mode="exp" templates
        but returns a string instead of the has title property.
        Used in access points and thus IRIs -->
    <xsl:function name="m2r:process245">
        <xsl:param name="record"/>
        <!-- copy of 245 where last subfield's ending punctuation (, or .) is removed -->
        <xsl:variable name="copy245">
            <xsl:copy select="$record/marc:datafield[@tag = '245']">
                <xsl:copy select="./@tag"/>
                <xsl:copy select="./@ind1"/>
                <xsl:copy select="./@ind2"/>
                <xsl:for-each select="child::*">
                    <xsl:if test="not(preceding-sibling::marc:subfield[@code='a'] and @code='a')">
                        <xsl:choose>
                            <xsl:when test="position() = last()">
                                <marc:subfield>
                                    <xsl:attribute name="code" select="./@code"/>
                                    <xsl:value-of select="m2r:stripEndPunctuation(.)"/>
                                </marc:subfield>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:copy>
        </xsl:variable>
        <!-- variable to check whether record contains isbd punctuation -->
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
        <xsl:variable name="title">
            <!-- go through 245 -->
            <xsl:for-each select="$copy245/marc:datafield">
                <xsl:choose>
                    <!-- if there is a subfield $a -->
                    <xsl:when test="marc:subfield[@code = 'a']">
                        <xsl:choose>
                            <!-- check if it does not have n or p following -->
                            <xsl:when test="marc:subfield[@code = 'a'][not(following-sibling::*)] or
                                marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p']) or 
                                (marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p')]
                                and marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                                <xsl:for-each select="marc:subfield[@code='a']">
                                    <xsl:choose>
                                        <xsl:when test="$isISBD = true()">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- otherwise there are additional subfields that make up the title proper -->
                                <xsl:variable name="title">
                                    <xsl:choose>
                                        <!-- remove ISBD punctuation if ISBD -->
                                        <xsl:when test="$isISBD = true()">
                                            <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => m2r:removeBrackets()"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                                <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') =>  m2r:removeBrackets()"/>
                                                <xsl:if test="position() != last()">
                                                    <xsl:text> </xsl:text>
                                                </xsl:if>                                    
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="m2r:removeBrackets(marc:subfield[@code = 'a'])"/>
                                            <xsl:text> </xsl:text>
                                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                                <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                                                <xsl:if test="position() != last()">
                                                    <xsl:text> </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- no $a - use all subfields before $c -->
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
                                <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => m2r:removeBrackets()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$copy245/marc:datafield/@ind2 != '0' and $copy245/marc:datafield/@ind2 != ' '">
                <xsl:value-of select="upper-case(substring($title, number($copy245/marc:datafield/@ind2)+1, 1))||substring($title, number($copy245/marc:datafield/@ind2)+2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$title"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="m2r:manifDate" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="dateType">
            <xsl:value-of select="substring($record/marc:controlfield[@tag = '008'][1], 7, 1)"/>
        </xsl:variable>
        <xsl:variable name="date1">
            <xsl:value-of select="substring($record/marc:controlfield[@tag = '008'][1], 8, 4)"/>
        </xsl:variable>
        <xsl:variable name="date2">
            <xsl:value-of select="substring($record/marc:controlfield[@tag = '008'][1], 12, 4)"/>
        </xsl:variable>
        <xsl:variable name="manifDate">
            <xsl:choose>
                <xsl:when test="$dateType = 'b' and $record/marc:datafield[@tag = '046']/marc:subfield[@code = 'b']">
                    <xsl:value-of select="$record/marc:datafield[@tag = '046']/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$dateType = 'e' and matches($date1, '\d\d\d\d')">
                    <xsl:value-of select="$date1"/>
                    <xsl:if test="matches(substring($date2, 1, 2), '\d\d')">
                        <xsl:text>-{substring($date2, 1, 2)}</xsl:text>
                        <xsl:if test="matches(substring($date2, 3, 2), '\d\d')">
                            <xsl:text>-{substring($date2, 3, 2)}</xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$dateType = 'p' and matches($date2, '\d\d\d\d')">
                    <xsl:value-of select="$date2"/>
                </xsl:when>
                <xsl:when test="($dateType = 'r' or $dateType = 's' or $dateType = 't') and matches($date1, '\d\d\d\d')">
                    <xsl:value-of select="$date1"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '260']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][matches(., '^\[*\d\d\d\d\]*$')]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c'][matches(., '\d\d\d\d')]][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- remove non numerical characters -->
        <xsl:value-of select="replace($manifDate, '[^\d]', '')"/>
    </xsl:function>
    
    <xsl:function name="m2r:manifName" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="manifName">
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '260']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][matches(., '^\[*\d\d\d\d\]*$')]/marc:subfield[@code = 'b'][1]"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'b'][1]"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'b'][1]"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'b'][1]"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2']/marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c'][matches(., '^\[*\d\d\d\d\]*$')]][1]/marc:subfield[@code = 'b'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '260']/marc:subfield[@code = 'b']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '260']/marc:subfield[@code = 'b'][1]"/>
                        </xsl:when>
                        <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1']/marc:subfield[@code = 'b']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1']/marc:subfield[@code = 'b'][1]"/>
                        </xsl:when>
                        <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0']/marc:subfield[@code = 'b']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0']/marc:subfield[@code = 'b'][1]"/>
                        </xsl:when>
                        <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3']/marc:subfield[@code = 'b']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3']/marc:subfield[@code = 'b'][1]"/>
                        </xsl:when>
                        <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2']/marc:subfield[@code = 'b']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '264']/marc:subfield[@code = 'b'][1]"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- remove brackets -->
        <xsl:value-of select="m2r:stripOuterBracketsAndParentheses($manifName) => m2r:stripEndPunctuation()"/>
    </xsl:function>
    
<!-- MAIN APS -->
    <!-- Determines the main work access point -->
    <xsl:function name="m2r:mainWorkAccessPoint">
        <xsl:param name="record"/>
        <xsl:choose>
            <!-- 130 titleWAP -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="ap">
                    <xsl:value-of select="m2r:workAPFields($record/marc:datafield[@tag = '130'][1])"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 240 NameX00 +TitleWAP -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 100 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '100'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="m2r:workAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 240 NameX10 +TitleWAP-->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 110 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '110'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="m2r:workAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 240 NameX11 +TitleWAP-->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <!-- 111 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '111'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 240 -->
                    <xsl:value-of select="m2r:workAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 245 NameX00 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 100 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '100'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 245 anp -->
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 245 NameX10 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 110 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '110'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 245 anps -->
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 245 NameX11 +Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <!-- 111 name subfields -->
                    <xsl:variable name="agentAP" select="m2r:stripEndPunctuation(m2r:agentAccessPoint($record/marc:datafield[@tag = '111'][1]))"/>
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <!-- 245 anps -->
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- just 245 Title245-->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <!-- name subfields of the first 7XX ind2 != 2 in the field  -->
                <xsl:variable name="name7XX">
                    <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][@ind2 != '2'][not(marc:subfield[@code = 't'])][not(marc:subfield[@code = '5'])]"/>
                    <xsl:value-of select="m2r:agentAccessPoint($first7XX)"/>
                </xsl:variable>
                <xsl:variable name="ap">
                    <xsl:if test="$name7XX != ''">
                        <xsl:value-of select="normalize-space($name7XX)"/>
                        <xsl:if test="not(ends-with($name7XX, '.'))">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    <!-- 245 anp -->
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the aggregating work access point. -->
    <xsl:function name="m2r:aggWorkAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        
        <xsl:choose>
            <!-- when 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <!-- 130 -->
                <xsl:variable name="expSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '130'][1])"/>
                </xsl:variable>
                <!-- + content type (if found) and aggregating work -->
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$expSubfields"/>
                    <xsl:text> (Aggregating work)</xsl:text>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '240']">
                <!--<xsl:variable name="agg1XX">
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
                </xsl:variable>-->
                <!-- name subfields from 1XX field -->
                <xsl:variable name="name1XX">
                    <xsl:variable name="first1XX" select="$record/marc:datafield[@tag = '100' or @tag = '110' or @tag = '111'][1]"/>
                    <xsl:value-of select="m2r:agentAccessPoint($first1XX)"/>
                </xsl:variable>
                <!-- work/expression fields -->
                <xsl:variable name="aggWorkSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                
                <!-- put together ap. If 1XX is aggregator, it goes first, otherwise it goes after work subfields -->
                <xsl:variable name="fullAP">
                    <!--<xsl:if test="$agg1XX = true()">
                                <xsl:value-of select="$name1XX"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>-->
                    <xsl:value-of select="$name1XX"/>
                    <xsl:if test="not(ends-with($name1XX, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$aggWorkSubfields"/>
                    <xsl:text> (Aggregating work)</xsl:text>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            
            <!-- 245-->
            <xsl:otherwise>
                <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
                <xsl:variable name="lang">
                    <xsl:if test="not(matches($langCode, ' |\|'))">
                        <xsl:value-of select="m2r:lcLangCodeToLabel($langCode)"/>
                    </xsl:if>
                </xsl:variable>
                
                <xsl:variable name="contentType" select="m2r:contentType($record)"/>
                
                <xsl:variable name="version">
                    <xsl:value-of select="m2r:expVersion($record)"/>
                </xsl:variable>
                
                <xsl:variable name="manifName">
                    <xsl:if test="substring($record/marc:leader, 7, 1) = 'i' or substring($record/marc:leader, 7, 1) = 'j'">
                        <xsl:value-of select="m2r:manifName($record)"/>
                    </xsl:if>
                </xsl:variable>
                
                <!-- name subfields of 1XX -->
                <xsl:variable name="name1XX">
                    <xsl:variable name="first1XX" select="$record/marc:datafield[@tag = '100' or @tag = '110' or @tag = '111'][1]"/>
                    <xsl:value-of select="m2r:agentAccessPoint($first1XX)"/>
                </xsl:variable>
                <!-- name subfields of the first 7XX ind2 != 2 and not $5 in the field -->
                <xsl:variable name="name7XX">
                    <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][@ind2 != '2'][not(marc:subfield[@code = 't'])][not(marc:subfield[@code = '5'])][1]"/>
                    <xsl:value-of select="m2r:agentAccessPoint($first7XX)"/>
                </xsl:variable>
                
                <xsl:variable name="qualifiers">
                    <xsl:text> (</xsl:text>
                    <xsl:choose>
                        <xsl:when test="$name1XX != ''">
                            <xsl:value-of select="normalize-space(m2r:stripEndPunctuation($name1XX))"/>
                        </xsl:when>
                        <xsl:when test="$name7XX != ''">
                            <xsl:value-of select="normalize-space(m2r:stripEndPunctuation($name7XX))"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="$contentType != ''">
                        <xsl:value-of select="$contentType"/>
                        <xsl:if test="$lang != '' or $version != '' or $manifName != ''">
                            <xsl:value-of select="' : '"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$lang != ''">
                        <xsl:value-of select="$lang"/>
                        <xsl:if test="$version != '' or $manifName != ''">
                            <xsl:value-of select="' : '"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$version != ''">
                        <xsl:value-of select="$version"/>
                        <xsl:if test="$manifName != ''">
                            <xsl:value-of select="' : '"/>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="$manifName != ''">
                        <xsl:value-of select="$manifName"/>
                    </xsl:if>
                    <xsl:if test="$contentType != '' or $lang != '' or $version != '' or $manifName != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                    <xsl:text>Aggregating work)</xsl:text>
                </xsl:variable>
                
                <!-- 245 anps -->
                <xsl:variable name="aggWorkSubfields">
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <!-- put together ap. If 1XX is aggregator, it goes first, otherwise it goes after work subfields-->
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$aggWorkSubfields"/>
                    <xsl:value-of select="$qualifiers"/>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the main expression access point. -->
    <xsl:function name="m2r:mainExpressionAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
        <xsl:variable name="lang">
            <xsl:if test="not($record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']) and not($record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l'])">
                <xsl:if test="not(matches($langCode, ' |\|'))">
                    <xsl:value-of select="m2r:lcLangCodeToLabel($langCode)"/>
                </xsl:if>
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="contentType" select="m2r:contentType($record)"/>
        
        <xsl:variable name="version">
            <xsl:value-of select="m2r:expVersion($record)"/>
        </xsl:variable>
        
        <xsl:variable name="manifName">
            <xsl:if test="substring($record/marc:leader, 7, 1) = 'i' or substring($record/marc:leader, 7, 1) = 'j'">
                <xsl:value-of select="m2r:manifName($record)"/>
            </xsl:if>
        </xsl:variable>
        
        <xsl:variable name="qualifiers">
            <xsl:if test="$contentType != '' or $lang != '' or $version != '' or $manifName != ''">
                <xsl:text> (</xsl:text>
                <xsl:if test="$contentType != ''">
                    <xsl:value-of select="$contentType"/>
                    <xsl:if test="$lang != '' or $version != '' or $manifName != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$lang != ''">
                    <xsl:value-of select="$lang"/>
                    <xsl:if test="$version != '' or $manifName != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$version != ''">
                    <xsl:value-of select="$version"/>
                    <xsl:if test="$manifName != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$manifName != ''">
                    <xsl:value-of select="$manifName"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:variable>
        
        <xsl:choose>
            <!-- 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="expSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '130'][1])"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$expSubfields"/>
                    <!--<xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>-->
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '100'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <!--<xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>-->
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '110'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <!--<xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>-->
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '111'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:expressionAPFields($record/marc:datafield[@tag = '240'][1])"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <!--<xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>-->
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '100'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '110'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="agentAP">
                    <xsl:value-of select="m2r:agentAccessPoint($record/marc:datafield[@tag = '111'][1])"/>
                </xsl:variable>
                <xsl:variable name="expressionSubfields">
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$agentAP"/>
                    <xsl:if test="not(ends-with($agentAP, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$expressionSubfields"/>
                    <xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- only 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="m2r:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields"/>
                    <xsl:if test="$qualifiers != ''">
                        <xsl:value-of select="$qualifiers"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="m2r:mainManifestationAccessPoint"  expand-text="yes">
        <xsl:param name="record"/>
        <xsl:param name="isElectronic"/>
        <xsl:param name="isMicroform"/>
        
        <!-- same logic as F245 mapping to title proper -->
        <xsl:variable name="titleProper">
            <xsl:value-of select="m2r:process245($record)"/>
        </xsl:variable>
        
        <xsl:variable name="manifDate">
            <xsl:value-of select="m2r:manifDate($record)"/>
        </xsl:variable>
        
        <xsl:variable name="manifName">
            <xsl:value-of select="m2r:manifName($record)"/>
        </xsl:variable>
        
        <xsl:variable name="version">
            <xsl:value-of select="m2r:manifVersion($record)"/>
        </xsl:variable>
        
        <xsl:variable name="carrierType">
            <xsl:value-of select="m2r:carrierType($record, $isElectronic, $isMicroform)"/>
        </xsl:variable>
        
        <xsl:variable name="fullAP">
            <xsl:value-of select="$titleProper"/>
            <xsl:if test="$manifDate != '' or $manifName != '' or $version != '' or $carrierType != ''">
                <xsl:text> (</xsl:text>
                <xsl:if test="$manifDate != ''">
                    <xsl:value-of select="$manifDate"/>
                    <xsl:if test="$manifName != '' or $version != '' or $carrierType != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$manifName != ''">
                    <xsl:value-of select="$manifName"/>
                    <xsl:if test="$version != '' or $carrierType != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$version != ''">
                    <xsl:value-of select="$version"/>
                    <xsl:if test="$carrierType != ''">
                        <xsl:value-of select="' : '"/>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$carrierType != ''">
                    <xsl:value-of select="$carrierType"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="$fullAP"/>
    </xsl:function>
    
<!-- RELATED APS -->
    <!-- generates an access point for a related agent based on the subfields present in the field -->
    <xsl:function name="m2r:agentAccessPoint" expand-text="true">
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '720' or ($field/@tag = '880' and contains($field/marc:subfield[@code = '6'], '720'))">
                <xsl:value-of select="m2r:stripEndPunctuation($field/marc:subfield[@code = 'a'])"/>
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- generates an access point for a related work based on the subfields present in the field -->
    <xsl:function name="m2r:relWorkAccessPoint" expand-text="true">
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
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
                <xsl:value-of select="m2r:stripEndPunctuation($ap) => replace(' ;\s*$', '') => normalize-space()"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '440'
                or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '440'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a']
                        | $field/marc:subfield[@code = 'n']
                        | $field/marc:subfield[@code = 'p']"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="m2r:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>

