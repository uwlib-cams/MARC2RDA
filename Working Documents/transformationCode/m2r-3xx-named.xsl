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
    <xsl:import href="m2r-iris.xsl"/>

    <!-- 334 -->
    <xsl:template name="F334-string" expand-text="yes">
        <!-- if there are no IRIs to use, continue to $a's and $b's -->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">

            <!-- pattern testing variables -->
            <!-- aTest determines whether all $a's are followed by $b's -->
            <xsl:variable name="aTest" select="
                    if (every $a in ./marc:subfield[@code = 'a']
                        satisfies
                        ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                        'Yes'
                    else
                        'No'"/>
            <!-- bTest determines whether all $b's are preceded by $a's -->
            <!-- if both aTest and bTest are true, then the field is patterned ababab... -->
            <xsl:variable name="bTest" select="
                    if (every $b in ./marc:subfield[@code = 'b']
                        satisfies
                        ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                        'Yes'
                    else
                        'No'"/>

            <xsl:choose>
                <!-- if there's a $2 -->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                    <xsl:choose>
                        <!-- when $2 starts with rda, we lookup the $2 code and then the $a/$b terms from there-->
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <!-- for $a's, rdaTermLookup is called -->
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30003 rdf:resource="{$rdaIRI}"/>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- for $b's it's rdaCodeLookup (both in m2r-functions) -->
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaCodeLookup($sub2, .)"/>
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30003 rdf:resource="{$rdaIRI}"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>

                        <!-- other $2s, we mint concepts -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- no b's -->
                                <xsl:when test="not(marc:subfield[@code = 'b'])">
                                    <!-- we only mint concepts for 334s or unpaired 880s, paired 880s are combined with their match into one concept -->
                                    <xsl:if
                                        test="@tag = '334' or substring(marc:subfield[@code = '6'], 1, 6) = '334-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30003 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- no a's - use b's -->
                                <xsl:when test="not(marc:subfield[@code = 'a'])">
                                    <xsl:if
                                        test="@tag = '334' or substring(marc:subfield[@code = '6'], 1, 6) = '334-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'b']">
                                            <rdam:P30003 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in abab pattern -->
                                <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                    <xsl:if
                                        test="@tag = '334' or substring(marc:subfield[@code = '6'], 1, 6) = '334-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30003 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in any other pattern - ignore b's -->
                                <xsl:otherwise>
                                    <xsl:if
                                        test="@tag = '334' or substring(marc:subfield[@code = '6'], 1, 6) = '334-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30003 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- no $2 -->
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdamd:P30003>
                            <xsl:value-of select="."/>
                        </rdamd:P30003>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30003>
                            <xsl:value-of select="."/>
                        </rdamd:P30003>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F334-concept">
        <!-- mint concepts when $2 is not rdamedia or rdamt -->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '334' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('334-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <!-- same test variables as in F334-string -->
                    <xsl:variable name="aTest" select="
                            if (every $a in ./marc:subfield[@code = 'a']
                                satisfies
                                ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                                'Yes'
                            else
                                'No'"/>
                    <xsl:variable name="bTest" select="
                            if (every $b in ./marc:subfield[@code = 'b']
                                satisfies
                                ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                                'Yes'
                            else
                                'No'"/>

                    <xsl:choose>
                        <!-- no b's -->
                        <xsl:when test="not(marc:subfield[@code = 'b'])">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '334')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no a's - use b's -->
                        <xsl:when test="not(marc:subfield[@code = 'a'])">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '334')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in abab pattern, we include $b as the skos:notation -->
                        <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of
                                        select="uwf:fillConcept(., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], '334')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of
                                                select="uwf:fillConcept(., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in any other pattern - ignore b's -->
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '334')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F334-iri" expand-text="yes">
        <!-- If $1 value (or multiple), use those -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdam:P30003 rdf:resource="{.}"/>
        </xsl:for-each>
        <!-- If there's no $1 but there are $0s that begin with http(s), use these -->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <!-- $0's contianing a uri may start with (uri) -->
                <xsl:if test="contains(., 'http')">
                    <xsl:variable name="iri0">
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'http')">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test="starts-with(., '(')">
                                <xsl:value-of select="substring-after(., ')')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$iri0">
                        <rdam:P30003 rdf:resource="{$iri0}"/>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 335 -->
    <xsl:template name="F335-string" expand-text="yes">
        <!-- if there are no IRIs to use, continue to $a's and $b's -->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">

            <!-- pattern testing variables -->
            <!-- aTest determines whether all $a's are followed by $b's -->
            <xsl:variable name="aTest" select="
                    if (every $a in ./marc:subfield[@code = 'a']
                        satisfies
                        ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                        'Yes'
                    else
                        'No'"/>
            <!-- bTest determines whether all $b's are preceded by $a's -->
            <!-- if both aTest and bTest are true, then the field is patterned ababab... -->
            <xsl:variable name="bTest" select="
                    if (every $b in ./marc:subfield[@code = 'b']
                        satisfies
                        ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                        'Yes'
                    else
                        'No'"/>

            <xsl:choose>
                <!-- if there's a $2 -->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                    <xsl:choose>
                        <!-- when $2 starts with rda, we lookup the $2 code and then the $a/$b terms from there-->
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <!-- for $a's, rdaTermLookup is called -->
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdaw:P10365 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdawd:P10330>
                                            <xsl:text>Extension plan {$rdaIRI} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdawd:P10330>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- for $b's it's rdaCodeLookup (both in m2r-functions) -->
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaCodeLookup($sub2, .)"/>
                                <xsl:if test="$rdaIRI">
                                    <rdaw:P10365 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdawd:P10330>
                                            <xsl:text>Extension plan {$rdaIRI} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdawd:P10330>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>

                        <!-- other $2s, we mint concepts -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- no b's -->
                                <xsl:when test="not(marc:subfield[@code = 'b'])">
                                    <!-- we only mint concepts for 335s or unpaired 880s, paired 880s are combined with their match into one concept -->
                                    <xsl:if
                                        test="@tag = '335' or substring(marc:subfield[@code = '6'], 1, 6) = '335-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdaw:P10365 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdawd:P10330>
                                                  <xsl:text>Extension plan {uwf:conceptIRI($sub2, .)} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdawd:P10330>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- no a's - use b's -->
                                <xsl:when test="not(marc:subfield[@code = 'a'])">
                                    <xsl:if
                                        test="@tag = '335' or substring(marc:subfield[@code = '6'], 1, 6) = '335-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'b']">
                                            <rdaw:P10365 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdawd:P10330>
                                                  <xsl:text>Extension plan {uwf:conceptIRI($sub2, .)} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdawd:P10330>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in abab pattern -->
                                <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                    <xsl:if
                                        test="@tag = '335' or substring(marc:subfield[@code = '6'], 1, 6) = '335-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdaw:P10365 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdawd:P10330>
                                                  <xsl:text>Extension plan {uwf:conceptIRI($sub2, .)} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdawd:P10330>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in any other pattern - ignore b's -->
                                <xsl:otherwise>
                                    <xsl:if
                                        test="@tag = '335' or substring(marc:subfield[@code = '6'], 1, 6) = '335-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdaw:P10365 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdawd:P10330>
                                                  <xsl:text>
                                                        Extension plan {uwf:conceptIRI($sub2, .)} applies to the work's {../marc:subfield[@code = '3']}
                                                    </xsl:text>
                                                </rdawd:P10330>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-- no $2 -->
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdawd:P10365>
                            <xsl:value-of select="."/>
                        </rdawd:P10365>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdawd:P10330>
                                <xsl:text>Extension plan {.} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdawd:P10330>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdawd:P10365>
                            <xsl:value-of select="."/>
                        </rdawd:P10365>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdawd:P10330>
                                <xsl:text>Extension plan {.} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdawd:P10330>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F335-concept">
        <!-- mint concepts when $2 is not rdaep -->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '335' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('335-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <!-- same test variables as in F335-string -->
                    <xsl:variable name="aTest" select="
                            if (every $a in ./marc:subfield[@code = 'a']
                                satisfies
                                ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                                'Yes'
                            else
                                'No'"/>
                    <xsl:variable name="bTest" select="
                            if (every $b in ./marc:subfield[@code = 'b']
                                satisfies
                                ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                                'Yes'
                            else
                                'No'"/>

                    <xsl:choose>
                        <!-- no b's -->
                        <xsl:when test="not(marc:subfield[@code = 'b'])">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '335')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no a's - use b's -->
                        <xsl:when test="not(marc:subfield[@code = 'a'])">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '335')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in abab pattern, we include $b as the skos:notation -->
                        <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of
                                        select="uwf:fillConcept(., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], '335')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of
                                                select="uwf:fillConcept(., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in any other pattern - ignore b's -->
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '335')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F335-iri" expand-text="yes">
        <!-- If $1 value (or multiple), use those -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaw:P10365 rdf:resource="{.}"/>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdawd:P10330>
                    <xsl:text>Extension plan {.} applies to the work's {../marc:subfield[@code ='3']}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
        </xsl:for-each>
        <!-- If there's no $1 but there are $0s that begin with http(s), use these -->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <!-- $0's containing a uri may start with (uri) -->
                <xsl:if test="contains(., 'http')">
                    <xsl:variable name="iri0">
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'http')">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test="starts-with(., '(')">
                                <xsl:value-of select="substring-after(., ')')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$iri0">
                        <rdaw:P10365 rdf:resource="{$iri0}"/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdawd:P10330>
                                <xsl:text>Extension plan {$iri0} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdawd:P10330>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 336, 337, 338 -->
    <xsl:template name="F336-337-338">
        <xsl:param name="tag33X"/>
        <!-- check for usable IRIs from $0 and $1 -->
        <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
            <xsl:choose>
                <xsl:when test="contains(., 'rdaregistry.info/termList/')">
                    <xsl:copy-of select="uwf:rdaIRILookup-33X(.)"/>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/vocabulary/')">
                    <xsl:copy-of select="uwf:lcIRILookup-33X(.)"/>
                </xsl:when>
                <xsl:when test="contains(., 'http')">
                    <xsl:choose>
                        <xsl:when test="$tag33X = '336'">
                            <rdaeo:P20001 rdf:resource="{.}"/>
                            <rdawo:P10349 rdf:resource="{.}"/>
                        </xsl:when>
                        <xsl:when test="$tag33X = '337'">
                            <rdamo:P30002 rdf:resource="{.}"/>
                        </xsl:when>
                        <xsl:when test="$tag33X ='338'">
                            <rdamo:P30001 rdf:resource="{.}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        
        <!-- $a and $b -->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
            <xsl:choose>
                <!-- no subfield $2 - map as datatype string value -->
                <xsl:when test="not(../marc:subfield[@code = '2'])">
                    <xsl:choose>
                        <xsl:when test="$tag33X = '336'">
                            <rdaed:P20001>
                                <xsl:value-of select="."/>
                            </rdaed:P20001>
                            <rdawd:P10349>
                                <xsl:value-of select="."/>
                            </rdawd:P10349>
                        </xsl:when>
                        <xsl:when test="$tag33X = '337'">
                            <rdamd:P30002>
                                <xsl:value-of select="."/>
                            </rdamd:P30002>
                        </xsl:when>
                        <xsl:when test="$tag33X ='338'">
                            <rdamd:P30001>
                                <xsl:value-of select="."/>
                            </rdamd:P30001>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                
                <!-- subfield $2 present -->
                <xsl:otherwise>
                    <xsl:variable name="sub2" select="../marc:subfield[@code='2'][1]"/>
                    <xsl:choose>
                        <!-- term or code starts with rda -->
                        <xsl:when test="starts-with(normalize-space(lower-case($sub2)), 'rda')">
                            <xsl:variable name="rdaIRI">
                                <xsl:copy-of select="uwf:rdalcTermCodeLookup-33X(., $tag33X)"/>
                            </xsl:variable>
                            <xsl:choose>
                                <!-- rda IRI was successfully retrieved - use RDA IRI -->
                                <xsl:when test="$rdaIRI[node()]">
                                    <xsl:copy-of select="$rdaIRI"/>
                                </xsl:when>
                                <!-- otherwise, if no IRI was found, use string value -->
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="$tag33X = '336'">
                                            <xsl:if test="not(matches(., 'other|unspecified|xxx|zzz'))">
                                                <rdaed:P20001>
                                                    <xsl:value-of select="."/>
                                                </rdaed:P20001>
                                                <rdawd:P10349>
                                                    <xsl:value-of select="."/>
                                                </rdawd:P10349>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="$tag33X = '337'">
                                            <xsl:if test="not(matches(., 'other|unspecified|x|z'))">
                                                <rdamd:P30002>
                                                    <xsl:value-of select="."/>
                                                </rdamd:P30002>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:when test="$tag33X ='338'">
                                            <xsl:if test="not(matches(., 'other|unspecified|zu|xz|cz|hz|pz|mz|ez|nz|vz'))">
                                                <rdamd:P30001>
                                                    <xsl:value-of select="."/>
                                                </rdamd:P30001>
                                            </xsl:if>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        
                        <!-- term or code not from RDA - mint a concept -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- $a's present -->
                                <!-- mint a concept for each $a -->
                                <xsl:when test="@code = 'a'">
                                    <!-- we only mint concepts for 33Xs or unpaired 880s, paired 880s are combined with their match into one concept -->
                                    <xsl:if
                                        test="starts-with(../@tag, '33') or matches(substring(../marc:subfield[@code = '6'], 1, 6), '33[678]-00')">
                                        <xsl:choose>
                                            <xsl:when test="$tag33X = '336'">
                                                <rdaeo:P20001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                                <rdawo:P10349 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                            <xsl:when test="$tag33X = '337'">
                                                <rdamo:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                            <xsl:when test="$tag33X = '338'">
                                                <rdamo:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:when>
                                
                                <!-- code $b and no $a's -->
                                <!-- mint a concept for each $b -->
                                <xsl:when test="@code = 'b' and not(../marc:subfield[@code = 'a'])">
                                    <xsl:if
                                        test="starts-with(../@tag, '33') or matches(substring(../marc:subfield[@code = '6'], 1, 6), '33[678]-00')">
                                        <xsl:choose>
                                            <xsl:when test="$tag33X = '336'">
                                                <rdaeo:P20001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                                <rdawd:P10349 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                            <xsl:when test="$tag33X = '337'">
                                                <rdamo:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                            <xsl:when test="$tag33X = '338'">
                                                <rdamo:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:if>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F336-337-338-concept">
        <xsl:variable name="tag33X" select="@tag"/>
        <!-- mint concepts when $2 does not start with rda -->
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:variable name="linked880">
                <xsl:if test="starts-with(@tag, '33') and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:copy-of
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                    />
                </xsl:if>
            </xsl:variable>
            <xsl:if test="not(matches($sub2, '^rda.+'))">
                <xsl:variable name="aTest" select="
                    if (every $a in ./marc:subfield[@code = 'a']
                    satisfies
                    ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                    'Yes'
                    else
                    'No'"/>
                <xsl:variable name="bTest" select="
                    if (every $b in ./marc:subfield[@code = 'b']
                    satisfies
                    ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                    'Yes'
                    else
                    'No'"/>
                
                <xsl:choose>
                    <!-- no b's -->
                    <xsl:when test="not(marc:subfield[@code = 'b'])">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', $tag33X)"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each
                                        select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                        />
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- no a's - use b's -->
                    <xsl:when test="not(marc:subfield[@code = 'a'])">
                        <xsl:for-each select="marc:subfield[@code = 'b']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', $tag33X)"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each
                                        select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                        />
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- a's and b's in abab pattern, we include $b as the skos:notation -->
                    <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of
                                    select="uwf:fillConcept(., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], $tag33X)"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each
                                        select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                        <xsl:copy-of
                                            select="uwf:fillConcept(., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"
                                        />
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- a's and b's in any other pattern - ignore b's -->
                    <xsl:otherwise>
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', $tag33X)"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each
                                        select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                        />
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
<!--    <!-\- 336 -\->
    <xsl:template name="F336-string" expand-text="yes">
        <!-\- Check for usable IRIs in $0 -\->
        <xsl:variable name="sub0Test" select="if (some $sub0 in marc:subfield[@code = '0'] satisfies contains($sub0, 'http')) then 'Yes' else 'No'"/>
        <xsl:if test="not(marc:subfield[@code = '1']) and $sub0Test = 'No'">
            <xsl:variable name="sub2raw" select="marc:subfield[@code = '2'][1]"/>
            <xsl:variable name="sub2" select="tokenize($sub2raw, '/')[1]"/>
            <xsl:variable name="langCode" select="tokenize($sub2raw, '/')[2]"/>
            
            <!-\- $a terms -\->
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <xsl:variable name="term" select="normalize-space(.)"/>
                <xsl:variable name="lcTerm" select="lower-case($term)"/>
                <xsl:variable name="iri" select="
                    document('lookup/Lookup336.xml')/lookupTable/entry[
                    rdaTerm = $term or locTerm = $term or locCode = $term
                    ]/rdaIRI"/>
                <xsl:choose>
                    <!-\- Skip if 'other' or 'unspecified' and $2 = rdaco or rdacontent -\->
                    <xsl:when test="($sub2 = 'rdaco' or $sub2 = 'rdacontent') and ($lcTerm = 'other' or $lcTerm = 'unspecified')"/>
                    <!-\- Map to RDAContentType IRI -\->
                    <xsl:when test="$iri">
                        <rdae:P20001 rdf:resource="{$iri}"/>
                        <xsl:if test="../marc:subfield[@code = '3'] and string-length(normalize-space($term)) &gt; 0">
                            <rdaed:P30137>
                                <xsl:text>Content type </xsl:text>
                                <xsl:value-of select="$term"/>
                                <xsl:text> applies to </xsl:text>
                                <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code='3']),1,1)), substring(normalize-space(../marc:subfield[@code='3']),2))"/>
                            </rdaed:P30137>
                        </xsl:if>
                    </xsl:when>
                    <!-\- If $2 present but not rdaco/rdacontent, mint as literal with lang if available -\->
                    <xsl:when test="$sub2 != '' and not($sub2 = 'rdaco' or $sub2 = 'rdacontent')">
                        <rdaed:P20001>
                            <xsl:if test="$langCode != ''">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="$langCode"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$term"/>
                        </rdaed:P20001>
                    </xsl:when>
                    <!-\- Else fallback: literal without lang -\->
                    <xsl:otherwise>
                        <rdaed:P20001><xsl:value-of select="$term"/></rdaed:P20001>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            
            <!-\- $b codes -\->
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <xsl:variable name="code" select="normalize-space(.)"/>
                <xsl:variable name="lcCode" select="lower-case($code)"/>
                <xsl:variable name="iri" select="
                    document('lookup/Lookup336.xml')/lookupTable/entry[
                    rdaTerm = $code or locTerm = $code or locCode = $code
                    ]/rdaIRI"/>
                <xsl:choose>
                    <!-\- Skip if 'xxx' or 'zzz' and $2 = rdaco or rdacontent -\->
                    <xsl:when test="($sub2 = 'rdaco' or $sub2 = 'rdacontent') and ($lcCode = 'xxx' or $lcCode = 'zzz')"/>
                    <!-\- Map to RDAContentType IRI -\->
                    <xsl:when test="$iri">
                        <rdae:P20001 rdf:resource="{$iri}"/>
                        <xsl:if test="../marc:subfield[@code = '3'] and string-length(normalize-space($code)) &gt; 0">
                            <rdaed:P30137>
                                <xsl:text>Content type </xsl:text>
                                <xsl:value-of select="$code"/>
                                <xsl:text> applies to </xsl:text>
                                <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code='3']),1,1)), substring(normalize-space(../marc:subfield[@code='3']),2))"/>
                            </rdaed:P30137>
                        </xsl:if>
                    </xsl:when>
                    <!-\- If $2 present but not rdaco/rdacontent and no $a, mint as literal with lang -\->
                    <xsl:when test="$sub2 != '' and not($sub2 = 'rdaco' or $sub2 = 'rdacontent') and not(marc:subfield[@code = 'a'])">
                        <rdaed:P20001>
                            <xsl:if test="$langCode != ''">
                                <xsl:attribute name="xml:lang"><xsl:value-of select="$langCode"/></xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$code"/>
                        </rdaed:P20001>
                    </xsl:when>
                    <!-\- Else fallback: literal without lang -\->
                    <xsl:otherwise>
                        <rdaed:P20001><xsl:value-of select="$code"/></rdaed:P20001>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template name="F336-concept">
        <xsl:variable name="sub0Test" select="if (some $sub0 in marc:subfield[@code = '0'] satisfies contains($sub0, 'http')) then 'Yes' else 'No'"/>
        <xsl:if test="not(marc:subfield[@code = '1']) and $sub0Test = 'No'">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:if test="not($sub2 = 'rdaco' or $sub2 = 'rdacontent')">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'a']">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '336')"/>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="marc:subfield[@code = 'b']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '336')"/>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F336-iri" expand-text="yes">
        <!-\- Prefer subfield $1 -\->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <xsl:variable name="uri" select="normalize-space(.)"/>
            <xsl:choose>
                <xsl:when test="not(matches($uri, '^https?://'))"/>
                <xsl:when test="matches(lower-case($uri), 'xxx|zzz')"/>
                <xsl:when test="document('lookup/Lookup336.xml')/lookupTable/entry[rdaIRI = $uri or locURI = $uri]">
                    <xsl:variable name="label" select="document('lookup/Lookup336.xml')/lookupTable/entry[rdaIRI = $uri or locURI = $uri]/rdaTerm"/>
                    <rdae:P20001 rdf:resource="{$uri}"/>
                    <xsl:if test="../marc:subfield[@code = '3']
                        and string-length(normalize-space($label)) &gt; 0
                        and not(starts-with(normalize-space($label), 'http'))
                        and normalize-space($label) != normalize-space($uri)">
                        <rdaed:P30137>
                            <xsl:text>Content type </xsl:text>
                            <xsl:value-of select="$label"/>
                            <xsl:text> applies to </xsl:text>
                            <xsl:value-of select="concat(
                                upper-case(substring(normalize-space(../marc:subfield[@code='3']), 1, 1)),
                                substring(normalize-space(../marc:subfield[@code='3']), 2)
                                )"/>
                        </rdaed:P30137>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <rdae:P20001 rdf:resource="{$uri}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        
        <!-\- fallback to subfield $0 if no $1 -\->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:variable name="uri" select="normalize-space(.)"/>
                <xsl:choose>
                    <xsl:when test="not(matches($uri, '^https?://'))"/>
                    <xsl:when test="matches(lower-case($uri), 'xxx|zzz')"/>
                    <xsl:when test="document('lookup/Lookup336.xml')/lookupTable/entry[rdaIRI = $uri or locURI = $uri]">
                        <xsl:variable name="label" select="document('lookup/Lookup336.xml')/lookupTable/entry[rdaIRI = $uri or locURI = $uri]/rdaTerm"/>
                        <rdae:P20001 rdf:resource="{$uri}"/>
                        <xsl:if test="../marc:subfield[@code = '3']
                            and string-length(normalize-space($label)) &gt; 0
                            and not(starts-with(normalize-space($label), 'http'))
                            and normalize-space($label) != normalize-space($uri)">
                            <rdaed:P30137>
                                <xsl:text>Content type </xsl:text>
                                <xsl:value-of select="$label"/>
                                <xsl:text> applies to </xsl:text>
                                <xsl:value-of select="concat(
                                    upper-case(substring(normalize-space(../marc:subfield[@code='3']), 1, 1)),
                                    substring(normalize-space(../marc:subfield[@code='3']), 2)
                                    )"/>
                            </rdaed:P30137>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdae:P20001 rdf:resource="{$uri}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-\- 337 -\->
    <xsl:template name="F337-string" expand-text="yes">
        <!-\- if there are no IRIs to use, continue to $a's and $b's -\->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">

            <!-\- pattern testing variables -\->
            <!-\- aTest determines whether all $a's are followed by $b's -\->
            <xsl:variable name="aTest" select="
                    if (every $a in ./marc:subfield[@code = 'a']
                        satisfies
                        ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                        'Yes'
                    else
                        'No'"/>
            <!-\- bTest determines whether all $b's are preceded by $a's -\->
            <!-\- if both aTest and bTest are true, then the field is patterned ababab... -\->
            <xsl:variable name="bTest" select="
                    if (every $b in ./marc:subfield[@code = 'b']
                        satisfies
                        ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                        'Yes'
                    else
                        'No'"/>

            <xsl:choose>
                <!-\- if there's a $2 -\->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                    <xsl:choose>
                        <!-\- when $2 starts with rda, we lookup the $2 code and then the $a/$b terms from there-\->
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <!-\- for $a's, rdaTermLookup is called -\->
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-\- only output the property if the function returns a value -\->
                                <!-\- we don't want a triple with no object -\->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30002 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text> Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <!-\- for $b's it's rdaCodeLookup (both in m2r-functions) -\->
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaCodeLookup($sub2, .)"/>
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30002 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text>Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>

                        <!-\- other $2s, we mint concepts -\->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-\- no b's -\->
                                <xsl:when test="not(marc:subfield[@code = 'b'])">
                                    <!-\- we only mint concepts for 337s or unpaired 880s, paired 880s are combined with their match into one concept -\->
                                    <xsl:if
                                        test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>
                                                  <xsl:text>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-\- no a's - use b's -\->
                                <xsl:when test="not(marc:subfield[@code = 'a'])">
                                    <xsl:if
                                        test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'b']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>
                                                  <xsl:text>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-\- a's and b's in abab pattern -\->
                                <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                    <xsl:if
                                        test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>
                                                  <xsl:text> Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-\- a's and b's in any other pattern - ignore b's -\->
                                <xsl:otherwise>
                                    <xsl:if
                                        test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>
                                                  <xsl:text>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>

                <!-\- no $2 -\->
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdamd:P30002>
                            <xsl:value-of select="."/>
                        </rdamd:P30002>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30002>
                            <xsl:value-of select="."/>
                        </rdamd:P30002>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F337-concept">
        <!-\- mint concepts when $2 is not rdamedia or rdamt -\->
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '337' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('337-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">

                    <!-\- same test variables as in F337-string -\->
                    <xsl:variable name="aTest" select="
                            if (every $a in ./marc:subfield[@code = 'a']
                                satisfies
                                ($a[following-sibling::marc:subfield[1][@code = 'b']])) then
                                'Yes'
                            else
                                'No'"/>
                    <xsl:variable name="bTest" select="
                            if (every $b in ./marc:subfield[@code = 'b']
                                satisfies
                                ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then
                                'Yes'
                            else
                                'No'"/>

                    <xsl:choose>
                        <!-\- no b's -\->
                        <xsl:when test="not(marc:subfield[@code = 'b'])">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '337')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-\- no a's - use b's -\->
                        <xsl:when test="not(marc:subfield[@code = 'a'])">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '337')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-\- a's and b's in abab pattern, we include $b as the skos:notation -\->
                        <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of
                                        select="uwf:fillConcept(., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], '337')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of
                                                select="uwf:fillConcept(., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-\- a's and b's in any other pattern - ignore b's -\->
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '337')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each
                                            select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"
                                            />
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F337-iri" expand-text="yes">
        <!-\- If $1 value (or multiple), use those -\->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdam:P30002 rdf:resource="{.}"/>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <!-\- If there's no $1 but there are $0s that begin with http(s), use these -\->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <!-\- $0's contianing a uri may start with (uri) -\->
                <xsl:if test="contains(., 'http')">
                    <xsl:variable name="iri0">
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'http')">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test="starts-with(., '(')">
                                <xsl:value-of select="substring-after(., ')')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$iri0">
                        <rdam:P30002 rdf:resource="{$iri0}"/>
                    </xsl:if>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <rdamd:P30137>
                            <xsl:text>Media type {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                        </rdamd:P30137>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-\- 338 -\->
    <xsl:template name="F338-string" expand-text="yes">
       <xsl:choose>
            <xsl:when test="marc:subfield[@code = '2']">
                <!-\- Extract base vocabulary and optional language code -\->
                <xsl:variable name="sub2raw" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="sub2" select="tokenize($sub2raw, '/')[1]"/>
                <xsl:variable name="langCode" select="tokenize($sub2raw, '/')[2]"/>
                
                <!-\- $a subfields -\->
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <xsl:if test="normalize-space(.)">
                        <xsl:variable name="term" select="normalize-space(.)"/>
                        <xsl:variable name="lc" select="lower-case($term)"/>
                        <xsl:variable name="rdaIRI" select="document('lookup/Lookup338.xml')/lookupTable/entry[rdaTerm = $term or locTerm = $term or locCode = $term]/rdaIRI"/>
                        <xsl:choose>
                            <xsl:when test="$rdaIRI">
                                <rdam:P30001 rdf:resource="{$rdaIRI}"/>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <rdamd:P30137>
                                        <xsl:text>Carrier type: </xsl:text>
                                        <xsl:value-of select="$term"/>
                                        <xsl:text> applies to </xsl:text>
                                        <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code = '3']), 1, 1)), substring(normalize-space(../marc:subfield[@code = '3']), 2))"/>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="$lc = ('other', 'unspecified', 'zu', 'cz', 'vz', 'nb', 'xz', 'hz', 'pz', 'mz', 'ez', 'nz')"/>
                            <xsl:when test="$langCode != ''">                                   
                                <rdamd:P30001 xml:lang="{$langCode}">
                                    <xsl:value-of select="$term"/>
                                </rdamd:P30001>
                            </xsl:when>
                            <xsl:when test="$sub2 = 'rdact' or $sub2 = 'rdacarrier'">
                                <rdamd:P30001>
                                    <xsl:value-of select="$term"/>
                                </rdamd:P30001>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <rdamd:P30137>
                                        <xsl:text>Carrier type: </xsl:text>
                                        <xsl:value-of select="$term"/>
                                        <xsl:text> applies to </xsl:text>
                                        <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code = '3']), 1, 1)), substring(normalize-space(../marc:subfield[@code = '3']), 2))"/>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="not(matches($sub2, '^rdact$|^rdacarrier$|^rdaco$'))">
                                    <rdamd:P30001>
                                        <xsl:value-of select="$term"/>
                                    </rdamd:P30001>
                                </xsl:if>
                            </xsl:otherwise>
                            
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                <!-\- $b subfields -\->
                <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:if test="normalize-space(.)">
                        <xsl:variable name="code" select="normalize-space(.)"/>
                        <xsl:variable name="lc" select="lower-case($code)"/>
                        <xsl:variable name="rdaIRI" select="document('lookup/Lookup338.xml')/lookupTable/entry[rdaTerm = $code or locTerm = $code or locCode = $code]/rdaIRI"/>
                        <xsl:choose>
                            <xsl:when test="$rdaIRI">
                                <rdam:P30001 rdf:resource="{$rdaIRI}"/>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <rdamd:P30137>
                                        <xsl:text>Carrier type: </xsl:text>
                                        <xsl:value-of select="$code"/>
                                        <xsl:text> applies to </xsl:text>
                                        <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code = '3']), 1, 1)), substring(normalize-space(../marc:subfield[@code = '3']), 2))"/>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="$lc = ('other', 'unspecified', 'zu', 'cz', 'vz', 'nb', 'xz', 'hz', 'pz', 'mz', 'ez', 'nz')"/>
                            <xsl:when test="$langCode != ''">
                                <rdamd:P30001 xml:lang="{$langCode}">
                                    <xsl:value-of select="$code"/>
                                </rdamd:P30001>
                            </xsl:when>
                            <xsl:when test="$sub2 = 'rdact' or $sub2 = 'rdacarrier'">
                                <rdamd:P30001>
                                    <xsl:value-of select="$code"/>
                                </rdamd:P30001>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <rdamd:P30137>
                                        <xsl:text>Carrier type: </xsl:text>
                                        <xsl:value-of select="$code"/>
                                        <xsl:text> applies to </xsl:text>
                                        <xsl:value-of select="concat(upper-case(substring(normalize-space(../marc:subfield[@code = '3']), 1, 1)), substring(normalize-space(../marc:subfield[@code = '3']), 2))"/>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:when>
                            
                            <xsl:otherwise>
                                <rdamd:P30001>
                                    <xsl:value-of select="$code"/>
                                </rdamd:P30001>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="F338-concept">
        <xsl:variable name="sub0Test">
            <xsl:value-of select="if (some $sub0 in marc:subfield[@code = '0'] satisfies 
                contains($sub0, 'http')) then 'Yes' else 'No'"/>
        </xsl:variable>
        <xsl:if test="not(marc:subfield[@code = '1']) and $sub0Test = 'No'">
            <xsl:variable name="sub2" select="marc:subfield[@code='2'][1]"/>
            <xsl:if test="not(matches(lower-case($sub2), '^rdact|^rdacarrier'))">
                <xsl:variable name="linked880">
                    <xsl:if test="marc:subfield[@code='6']">
                        <xsl:variable name="occNum" select="substring(marc:subfield[@code='6'], 1, 6)"/>
                        <xsl:copy-of select="../marc:datafield[@tag='880'][marc:subfield[@code='6'][starts-with(., $occNum)]]"/>
                    </xsl:if>
                </xsl:variable>
                <!-\- Test for a-b pairing -\->
                <xsl:variable name="aTest" select="
                    if (every $a in marc:subfield[@code = 'a'] 
                    satisfies $a[following-sibling::marc:subfield[1][@code = 'b']])
                    then 'Yes' else 'No'"/>
                <xsl:variable name="bTest" select="
                    if (every $b in marc:subfield[@code = 'b'] 
                    satisfies $b[preceding-sibling::marc:subfield[1][@code = 'a']])
                    then 'Yes' else 'No'"/>
                <xsl:choose>
                    <xsl:when test="not(marc:subfield[@code='b'])">
                        <xsl:for-each select="marc:subfield[@code='a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '338')"/>
                                <!-\- Copy matching vernacular $a -\->
                                <xsl:if test="$linked880">
                                    <xsl:for-each select="$linked880/marc:datafield/marc:subfield[@code = 'a']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="not(marc:subfield[@code='a'])">
                        <xsl:for-each select="marc:subfield[@code='b']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '338')"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each select="$linked880/marc:datafield/marc:subfield[@code = 'b']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, following-sibling::marc:subfield[@code='b'][1], '338')"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each select="$linked880/marc:datafield/marc:subfield[@code = 'a']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', following-sibling::marc:subfield[@code='b'][1], '880')"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '338')"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each select="$linked880/marc:datafield/marc:subfield[@code = 'a']">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F338-iri" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = '1'] | marc:subfield[@code = '0']">
            <xsl:variable name="iri" select="normalize-space(.)"/>
            <xsl:choose>
                <!-\- id.loc.gov IRI -\->
                <xsl:when test="matches(lower-case($iri), 'id.loc.gov/carriers')">
                    <xsl:variable name="rdaIRI" select="document('lookup/Lookup338.xml')/lookupTable/entry[locURI = $iri]/rdaIRI"/>
                    <xsl:choose>
                        <!-\- if id.loc.gov IRI can be matched to an RDA registry IRI -\->
                        <xsl:when test="$rdaIRI != ''">
                            <rdamo:P30001 rdf:resource="{normalize-space($iri)}"/>
                            <xsl:if test="../marc:subfield[@code = '3']">
                                <rdamd:P30137>
                                    <xsl:text>Carrier type: </xsl:text>
                                    <xsl:value-of select="$rdaIRI"/>
                                    <xsl:text> applies to </xsl:text>
                                    <xsl:value-of select="concat(upper-case(substring(../marc:subfield[@code = '3'], 1, 1)), substring(../marc:subfield[@code = '3'], 2))"/>
                                </rdamd:P30137>
                            </xsl:if>
                        </xsl:when>
                        <!-\- else do not map the id.loc.gov IRI if not found in table (other, unspecified, etc.) -\->
                    </xsl:choose>
                </xsl:when>
                <!-\- otherwise if RDA registry IRI, map as is -\->
                <xsl:when test="matches(lower-case($iri), 'rdaregistry.info/termList/RDACarrierType')">
                    <rdamo:P30001 rdf:resource="{normalize-space($iri)}"/>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <rdamd:P30137>
                            <xsl:text>Carrier type: </xsl:text>
                            <xsl:value-of select="$iri"/>
                            <xsl:text> applies to </xsl:text>
                            <xsl:value-of select="concat(upper-case(substring(../marc:subfield[@code = '3'], 1, 1)), substring(../marc:subfield[@code = '3'], 2))"/>
                        </rdamd:P30137>
                    </xsl:if>
                </xsl:when>
                <!-\- if not id.loc.gov or rda, but contains 'http', use IRI -\->
                <xsl:when test="contains(lower-case($iri), 'http')">
                    <rdamd:P30001 rdf:resource="{normalize-space($iri)}"/>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <rdamd:P30137>
                            <xsl:text>Carrier type: </xsl:text>
                            <xsl:value-of select="$iri"/>
                            <xsl:text> applies to </xsl:text>
                            <xsl:value-of select="concat(upper-case(substring(../marc:subfield[@code = '3'], 1, 1)), substring(../marc:subfield[@code = '3'], 2))"/>
                        </rdamd:P30137>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>-->

    <!-- 340 -->

    <!-- template for subfields that are mapped to properties with text values (subfields b, f, h, i) -->
    <xsl:template name="F340-b_f_h_i" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30169>
                <xsl:value-of select="."/>
                <xsl:if test="../marc:subfield[@code = 'a']">
                    <xsl:text> ({../marc:subfield[@code = 'a']})</xsl:text>
                </xsl:if>
            </rdamd:P30169>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>Has dimensions </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:if test="../marc:subfield[@code = 'a']">
                        <xsl:text> ({../marc:subfield[@code = 'a']})</xsl:text>
                    </xsl:if>
                    <xsl:text> applies to {../marc:subfield[@code = '3']}</xsl:text>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'f']">
            <rdamd:P30137>
                <xsl:text>Reduction ratio or production rate/ratio: {.}</xsl:text>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (applies to: {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <rdamd:P30137>
                <xsl:text>Location of the described materials within the material base: {.}</xsl:text>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (applies to: {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'i']">
            <rdamd:P30162>
                <xsl:value-of select="."/>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (applies to: {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30162>
        </xsl:for-each>
    </xsl:template>

    <!-- mints concepts for 340 subfields as needed -->
    <xsl:template name="F340-concept" expand-text="yes">
        <!-- if there is a $0 that begins with 'http' or there is a $1 value 
            AND there is only one subfield that this IRI could be referring to, 
            then we use that value, so a concept is not minted -->
        <!-- The if test here uses count() to check that there are not multiple subfields the $0 or $1 could be referring to
             these subfields may differ in other fields that require a similar approach-->
        <xsl:if test="
                not(marc:subfield[@code = '1'] and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1)
                and not(contains(marc:subfield[@code = '0'], 'http') and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1)">
            <!-- otherwise, there is no $0 that begins with 'http', no $1, OR there are these values but we can't know
              what property to use with them - then we check the $2 -->
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <!-- if there's a $6, retrieve a copy of the linked 880 field -->
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '340' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('340-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>

                <!-- if the $2 value does not begin with rda and include additional characters 
                    (this prevents a match on just 'rda', which can't be looked up as it doesn't tell us which vocabulary is in use) -->
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <!-- for each subfield that requires it (not $b, $f, $h, and $i which map to strings, or numeric subfields)
                        we mint a concept -->
                    <xsl:for-each select="
                            marc:subfield[@code = 'a'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
                            | marc:subfield[@code = 'e'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'j']
                            | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm']
                            | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
                            | marc:subfield[@code = 'q']">
                        <!-- save the code value in a variable for if there's a linked 880, 
                            we need to find the associated subfield in that field using it -->
                        <xsl:variable name="currentCode" select="@code"/>
                        <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '340')"/>
                            <!-- if it exists, include the linked 880 as part of this concept -->
                            <xsl:if test="$linked880">
                                <!-- select all matching subfields in the same position 
                                    (for-each accounts for if there are multiple linked 880s) -->
                                <xsl:for-each
                                    select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
                                    <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- handles 340 subfields that map to concepts -->
    <xsl:template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1" expand-text="yes">
        <!-- propertyNum is the appropriate rda property passed from the 340 match template
             these are all manifestation properties, so only the P##### number is needed-->
        <xsl:param name="propertyNum"/>
        <xsl:param name="entity"/>
        <!-- the subfield is stored in a variable so that 
            context can be moved to perform checks without losing it -->
        <xsl:variable name="subfield" select="."/>
        <xsl:choose>
            <!-- If there is a $1 and only one subfield that it could refer to, 
                we know the property to use and can use the $1 value as the object -->
            <xsl:when test="
                    ../marc:subfield[@code = '1'] and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                    or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1">
                <xsl:for-each select="../marc:subfield[@code = '1']">
                    <xsl:element name="rda{$entity}o:{$propertyNum}">
                        <xsl:attribute name="rdf:resource" select="."/>
                    </xsl:element>
                    <!-- if there's a $3, call the F340-xx-3 template to output a note -->
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:call-template name="F340-xx-3">
                            <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                            <xsl:with-param name="subfield" select="$subfield"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <!-- otherwise, if there is no $1 or no way to know which property to use
                because multiple subfields that the $1 could be attached to are present -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- we check if there is a $0 with 'http' and only one subfield that could be referred to.
                        if there is, we can use this $0 value as an object of the appropriate property -->
                    <xsl:when test="
                            contains(../marc:subfield[@code = '0'], 'http') and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                            or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1">
                        <xsl:for-each select="../marc:subfield[@code = '0']">
                            <!-- uwf:process0 takes a $0 and strips anything not part of the IRI -->
                            <xsl:variable name="iri0" select="uwf:process0(.)"/>
                            <!-- if getting iri was successful (started with 'http' or '('), then we can use the $0-->
                            <xsl:if test="$iri0">
                                <xsl:element name="rda{$entity}o:{$propertyNum}">
                                    <xsl:attribute name="rdf:resource" select="$iri0"/>
                                </xsl:element>
                                <!-- if there's a 3, output a note -->
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F340-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="$subfield"/>
                                        <xsl:with-param name="value" select="$iri0"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- if there is no $1 or $0 (http) or multiple subfields that these IRIs could refer to
                       we move on to subfield $2 -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- $2 -->
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:variable name="sub2" select="../marc:subfield[@code = '2'][1]"/>
                                <xsl:choose>
                                    <!-- when $2 starts with rda (but is not only 'rda'), we lookup the $2 code and then the term from there-->
                                    <xsl:when test="matches($sub2, '^rda.+')">
                                        <!-- uwf:rdaTermLookup() does all the lookup work and returns an IRI 
                                            if one is found for that term from that source -->
                                        <xsl:variable name="rdaIRI"
                                            select="uwf:rdaTermLookup($sub2, $subfield)"/>
                                        <!-- only output the property if the function returns a value -->
                                        <!-- we don't want a triple with no object -->
                                        <xsl:if test="$rdaIRI">
                                            <xsl:element name="rda{$entity}o:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource" select="$rdaIRI"
                                                />
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F340-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$rdaIRI"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:when>
                                    <!-- if there is a $2 that is not rda (or is only 'rda') 
                                        then a concept is minted -->
                                    <xsl:otherwise>
                                        <xsl:if
                                            test="../@tag = '340' or substring(../marc:subfield[@code = '6'], 1, 6) = '340-00'">
                                            <xsl:element name="rda{$entity}o:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F340-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- If there were not $0s, $1s, or $2s that fit the above checks, a string value is used -->
                            <xsl:otherwise>
                                <xsl:element name="rda{$entity}d:{$propertyNum}">
                                    <xsl:value-of select="$subfield"/>
                                </xsl:element>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F340-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="$subfield"/>
                                        <xsl:with-param name="value" select="$subfield"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- handle subfield $3 for 340 -->
    <xsl:template name="F340-xx-3" expand-text="yes">
        <xsl:param name="sub3"/>
        <xsl:param name="subfield"/>
        <xsl:param name="value"/>
        <!-- 340 has many subfields, so F340-xx-3 determines what the note about the $3 part says -->
        <rdamd:P30137>
            <xsl:if test="$subfield/@code = 'a'">
                <xsl:text>Has material base and configuration {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'c'">
                <xsl:text>Has materials applied to surface {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'd'">
                <xsl:text>Has information recording technique {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'e'">
                <xsl:text>Has support {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'g'">
                <xsl:text>Has color content {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'j'">
                <xsl:text>Has generation {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'k'">
                <xsl:text>Has layout {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'l'">
                <xsl:text>Has type of binding {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'm'">
                <xsl:text>Has book format {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'n'">
                <xsl:text>Has font size {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'o'">
                <xsl:text>Has polarity {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'p'">
                <xsl:text>Has illustrative content {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'q'">
                <xsl:text>Has reduction ratio designator {$value}</xsl:text>
            </xsl:if>
            <xsl:text> applies to {$sub3}</xsl:text>
        </rdamd:P30137>
    </xsl:template>

    <!-- 342 -->
    <xsl:template name="F342-xx-a" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '0'">
                    <rdaed:P20071>
                        <xsl:text>Geographic coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '1'">
                    <rdaed:P20216>
                        <xsl:value-of select="."/>
                    </rdaed:P20216>
                </xsl:when>
                <xsl:when test="../@ind2 = '3'">
                    <rdaed:P20071>
                        <xsl:text>Local planar coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '4'">
                    <rdaed:P20071>
                        <xsl:text>Local coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '5'">
                    <rdaed:P20071>
                        <xsl:text>Geodetic model name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '6'">
                    <rdaed:P20071>
                        <xsl:text>Altitude datum name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '7'">
                    <rdaed:P20071>
                        <xsl:text>Name of geospatial reference method: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdaed:P20071>
                        <xsl:text>Depth datum name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F342-xx-a-aggWor" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '0'">
                    <rdawd:P10330>
                        <xsl:text>Geographic coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '1'">
                    <rdawd:P10330>
                        <xsl:value-of select="."/>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '3'">
                    <rdawd:P10330>
                        <xsl:text>Local planar coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '4'">
                    <rdawd:P10330>
                        <xsl:text>Local coordinate system: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '5'">
                    <rdawd:P10330>
                        <xsl:text>Geodetic model name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '6'">
                    <rdawd:P10330>
                        <xsl:text>Altitude datum name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '7'">
                    <rdawd:P10330>
                        <xsl:text>Name of geospatial reference method: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdawd:P10330>
                        <xsl:text>Depth datum name: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>.</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F342-xx-bcdlmnosvpfijtuw2" expand-text="yes">
        <xsl:for-each
            select="marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 's'] | marc:subfield[@code = 'v']">
            <xsl:if test="@code = 'b'">
                <rdaed:P20071>
                    <xsl:text>Coordinate units or distance units: {.}.</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <rdaed:P20071>
                    <xsl:text>Latitude resolution: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <rdaed:P20071>
                    <xsl:text>Longitude resolution: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'l'">
                <rdaed:P20071>
                    <xsl:text>Height of perspective point above surface: {.} meters</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'm'">
                <rdaed:P20071>
                    <xsl:text>Azimuthal angle: {.} degrees</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <rdaed:P20071>
                    <xsl:text>Landsat number and path number: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 's'">
                <rdaed:P20071>
                    <xsl:text>Denominator of flattening ratio: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="@code = 'v'">
                <rdaed:P20071>
                    <xsl:text>Local planar, local, or other projection or grid description: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and not(contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdaed:P20071>
                    <xsl:text>Azimuth measure point longitude or straight vertical longitude from pole: </xsl:text>
                    <xsl:value-of select="."/>
                </rdaed:P20071>
            </xsl:for-each>
        </xsl:if>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdaed:P20071>
                    <xsl:text>Azimuth measure point longitude: </xsl:text>
                    <xsl:value-of select="."/>
                </rdaed:P20071>
            </xsl:for-each>
        </xsl:if>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and contains(., 'Polar stereographic')]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdaed:P20071>
                    <xsl:text>Straight vertical longitude from pole: </xsl:text>
                    <xsl:value-of select="."/>
                </rdaed:P20071>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="@ind2 = '2'">
            <rdaed:P20071>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <xsl:text>Grid coordinate system: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>. </xsl:text>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'p']">
                    <xsl:text>Zone identifier: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
            </rdaed:P20071>
        </xsl:if>

        <xsl:if test="marc:subfield[@code = 'f']">
            <rdaed:P20071>
                <xsl:for-each select="marc:subfield[@code = 'f']">
                    <xsl:text>Oblique line longitude: {.}</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdaed:P20071>
        </xsl:if>

        <xsl:for-each select="marc:subfield[@code = 'i' or @code = 'j']">
            <rdaed:P20071>
                <xsl:choose>
                    <xsl:when test="@code = 'i'">
                        <xsl:text>False easting: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'j'">
                        <xsl:text>False northing: </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="."/>
            </rdaed:P20071>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 't']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '6'">
                    <rdaed:P20071>
                        <xsl:text>Altitude resolution: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdaed:P20071>
                        <xsl:text>Depth resolution: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 != '6' and ../@ind2 != '8'">
                    <rdaed:P20071>
                        <xsl:text>Vertical resolution: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 'u']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '6'">
                    <rdaed:P20071>
                        <xsl:text>Altitude encoding method: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdaed:P20071>
                        <xsl:text>Depth encoding method: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 != '6' and ../@ind2 != '8'">
                    <rdaed:P20071>
                        <xsl:text>Vertical encoding method: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 'w']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '3'">
                    <rdaed:P20071>
                        <xsl:text>Local planar georeference information: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 = '4'">
                    <rdaed:P20071>
                        <xsl:text>Local georeference information: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
                <xsl:when test="../@ind2 != '3' and ../@ind2 != '4'">
                    <rdaed:P20071>
                        <xsl:text>Local planar or local georeference information: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:if test="@ind2 = '7'">
            <xsl:if test="marc:subfield[@code = '2']">
                <rdaed:P20071>
                    <xsl:text>Geospatial reference method used: {.}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F342-xx-bcdlmnosvpfijtuw2-aggWor" expand-text="yes">
        <xsl:for-each
            select="marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 's'] | marc:subfield[@code = 'v']">
            <xsl:if test="@code = 'b'">
                <rdawd:P10330>
                    <xsl:text>Coordinate units or distance units: {.}.</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <rdawd:P10330>
                    <xsl:text>Latitude resolution: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <rdawd:P10330>
                    <xsl:text>Longitude resolution: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'l'">
                <rdawd:P10330>
                    <xsl:text>Height of perspective point above surface: {.} meters</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'm'">
                <rdawd:P10330>
                    <xsl:text>Azimuthal angle: {.} degrees</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <rdawd:P10330>
                    <xsl:text>Landsat number and path number: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 's'">
                <rdawd:P10330>
                    <xsl:text>Denominator of flattening ratio: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="@code = 'v'">
                <rdawd:P10330>
                    <xsl:text>Local planar, local, or other projection or grid description: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
        </xsl:for-each>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and not(contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdawd:P10330>
                    <xsl:text>Azimuth measure point longitude or straight vertical longitude from pole: </xsl:text>
                    <xsl:value-of select="."/>
                </rdawd:P10330>
            </xsl:for-each>
        </xsl:if>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdawd:P10330>
                    <xsl:text>Azimuth measure point longitude: </xsl:text>
                    <xsl:value-of select="."/>
                </rdawd:P10330>
            </xsl:for-each>
        </xsl:if>

        <xsl:if
            test="marc:subfield[@code = 'n'] and marc:subfield[@code = 'a' and contains(., 'Polar stereographic')]">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdawd:P10330>
                    <xsl:text>Straight vertical longitude from pole: </xsl:text>
                    <xsl:value-of select="."/>
                </rdawd:P10330>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="@ind2 = '2'">
            <rdawd:P10330>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <xsl:text>Grid coordinate system: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>. </xsl:text>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'p']">
                    <xsl:text>Zone identifier: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>.</xsl:text>
                </xsl:for-each>
            </rdawd:P10330>
        </xsl:if>

        <xsl:if test="marc:subfield[@code = 'f']">
            <rdawd:P10330>
                <xsl:for-each select="marc:subfield[@code = 'f']">
                    <xsl:text>Oblique line longitude: {.}</xsl:text>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdawd:P10330>
        </xsl:if>

        <xsl:for-each select="marc:subfield[@code = 'i' or @code = 'j']">
            <rdawd:P10330>
                <xsl:choose>
                    <xsl:when test="@code = 'i'">
                        <xsl:text>False easting: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'j'">
                        <xsl:text>False northing: </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="."/>
            </rdawd:P10330>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 't']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '6'">
                    <rdawd:P10330>
                        <xsl:text>Altitude resolution: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdawd:P10330>
                        <xsl:text>Depth resolution: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 != '6' and ../@ind2 != '8'">
                    <rdawd:P10330>
                        <xsl:text>Vertical resolution: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 'u']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '6'">
                    <rdawd:P10330>
                        <xsl:text>Altitude encoding method: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '8'">
                    <rdawd:P10330>
                        <xsl:text>Depth encoding method: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 != '6' and ../@ind2 != '8'">
                    <rdawd:P10330>
                        <xsl:text>Vertical encoding method: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = 'w']">
            <xsl:choose>
                <xsl:when test="../@ind2 = '3'">
                    <rdawd:P10330>
                        <xsl:text>Local planar georeference information: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 = '4'">
                    <rdawd:P10330>
                        <xsl:text>Local georeference information: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="../@ind2 != '3' and ../@ind2 != '4'">
                    <rdawd:P10330>
                        <xsl:text>Local planar or local georeference information: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <xsl:if test="@ind2 = '7'">
            <xsl:if test="marc:subfield[@code = '2']">
                <rdawd:P10330>
                    <xsl:text>Geospatial reference method used: {.}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F342-x1-egh" expand-text="yes">
        <xsl:if test="@ind2 = '1'">
            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Polar stereographic')]">
                <rdaed:P20071>
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:text>Standard parallel(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <rdaed:P20071>
                        <xsl:text>Oblique line latitude(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Miller cylindrical') or contains(., 'Polyconic') or contains(., 'Sinusoidal') or contains(., 'Transverse Mercator') or contains(., 'Van der Grinten')]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdaed:P20071>
                        <xsl:text>Longitude of the central meridian: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Lambert azimuthal equal area') or contains(., 'Robinson') or contains(., 'Stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdaed:P20071>
                        <xsl:text>Longitude of projection center: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdaed:P20071>
                        <xsl:text>Latitude of projection center: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Equidistant conic') or contains(., 'Lambert conformal conic') or contains(., 'Oblique Mercator') or contains(., 'Polyconic') or contains(., 'Transverse Mercator') or contains(., 'Azimuthal equidistant')]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdaed:P20071>
                        <xsl:text>Latitude of projection origin: {.}</xsl:text>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>

        <xsl:if test="not(@ind2 = '1')">
            <xsl:if
                test="marc:subfield[@code = 'e'] or marc:subfield[@code = 'a' and not(contains(., 'Albers conical equal area') or contains(., 'Equidistant') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <rdaed:P20071>
                        <xsl:text>Standard parallel(s) or oblique line latitude(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>;</xsl:text>
                        </xsl:if>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'g'] or marc:subfield[@code = 'a' and not(contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Miller cylindrical') or contains(., 'Polyconic') or contains(., 'Sinusoidal') or contains(., 'Transverse Mercator') or contains(., 'Van der Grinten') or contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Lambert azimuthal equal area') or contains(., 'Robinson') or contains(., 'Stereographic'))]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdaed:P20071>
                        <xsl:text>Longitude of the central meridian or projection center: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'h'] or marc:subfield[@code = 'a' and not(contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Stereographic') or contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Lambert conformal conic') or contains(., 'Oblique Mercator') or contains(., 'Polyconic') or contains(., 'Transverse Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdaed:P20071>
                        <xsl:text>Latitude of projection center or projection origin: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F342-x1-egh-aggWor" expand-text="yes">
        <xsl:if test="@ind2 = '1'">
            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Polar stereographic')]">
                <rdawd:P10330>
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:text>Standard parallel(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <rdawd:P10330>
                        <xsl:text>Oblique line latitude(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Miller cylindrical') or contains(., 'Polyconic') or contains(., 'Sinusoidal') or contains(., 'Transverse Mercator') or contains(., 'Van der Grinten')]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdawd:P10330>
                        <xsl:text>Longitude of the central meridian: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Lambert azimuthal equal area') or contains(., 'Robinson') or contains(., 'Stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdawd:P10330>
                        <xsl:text>Longitude of projection center: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdawd:P10330>
                        <xsl:text>Latitude of projection center: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Albers conical equal area') or contains(., 'Equidistant conic') or contains(., 'Lambert conformal conic') or contains(., 'Oblique Mercator') or contains(., 'Polyconic') or contains(., 'Transverse Mercator') or contains(., 'Azimuthal equidistant')]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdawd:P10330>
                        <xsl:text>Latitude of projection origin: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>

        <xsl:if test="not(@ind2 = '1')">
            <xsl:if
                test="marc:subfield[@code = 'e'] or marc:subfield[@code = 'a' and not(contains(., 'Albers conical equal area') or contains(., 'Equidistant') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <rdawd:P10330>
                        <xsl:text>Standard parallel(s) or oblique line latitude(s): {.}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>;</xsl:text>
                        </xsl:if>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'g'] or marc:subfield[@code = 'a' and not(contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Equirectangular') or contains(., 'Lambert conformal conic') or contains(., 'Mercator') or contains(., 'Miller cylindrical') or contains(., 'Polyconic') or contains(., 'Sinusoidal') or contains(., 'Transverse Mercator') or contains(., 'Van der Grinten') or contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Lambert azimuthal equal area') or contains(., 'Robinson') or contains(., 'Stereographic'))]">
                <xsl:for-each select="marc:subfield[@code = 'g']">
                    <rdawd:P10330>
                        <xsl:text>Longitude of the central meridian or projection center: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

            <xsl:if
                test="marc:subfield[@code = 'h'] or marc:subfield[@code = 'a' and not(contains(., 'General vertical near-sided projection') or contains(., 'Gnomomic') or contains(., 'Orthographic') or contains(., 'Stereographic') or contains(., 'Albers conical equal area') or contains(., 'Azimuthal equidistant') or contains(., 'Equidistant conic') or contains(., 'Lambert conformal conic') or contains(., 'Oblique Mercator') or contains(., 'Polyconic') or contains(., 'Transverse Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'h']">
                    <rdawd:P10330>
                        <xsl:text>Latitude of projection center or projection origin: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F342-xx-k" expand-text="yes">
        <xsl:if test="@ind1 = '1'">
            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Mercator') and not(contains(., 'Transverse') or contains(., 'Oblique)'))]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdaed:P20213>
                        <xsl:text>Scale factor at equator: {.}</xsl:text>
                    </rdaed:P20213>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdaed:P20213>
                        <xsl:text>Scale factor at center line: {.}</xsl:text>
                    </rdaed:P20213>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Transverse Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdaed:P20213>
                        <xsl:text>Scale factor at central meridian: {.}</xsl:text>
                    </rdaed:P20213>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Polar stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdaed:P20213>
                        <xsl:text>Scale factor at projection origin: {.}</xsl:text>
                    </rdaed:P20213>
                </xsl:for-each>
            </xsl:if>

        </xsl:if>
        <xsl:if test="not(@ind1 = '1')">
            <xsl:if
                test="marc:subfield[@code = 'k'] or marc:subfield[@code = 'a' and not(contains(., 'Mercator') or contains(., 'Transverse Mercator') or contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdaed:P20213>
                        <xsl:text>Scale factor: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdaed:P20213>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F342-xx-k-aggWor" expand-text="yes">
        <xsl:if test="@ind1 = '1'">
            <xsl:if
                test="marc:subfield[@code = 'a' and contains(., 'Mercator') and not(contains(., 'Transverse') or contains(., 'Oblique)'))]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdawd:P10330>
                        <xsl:text>Scale factor at equator: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Oblique Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdawd:P10330>
                        <xsl:text>Scale factor at center line: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Transverse Mercator')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdawd:P10330>
                        <xsl:text>Scale factor at central meridian: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'a' and contains(., 'Polar stereographic')]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdawd:P10330>
                        <xsl:text>Scale factor at projection origin: {.}</xsl:text>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>

        </xsl:if>
        <xsl:if test="not(@ind1 = '1')">
            <xsl:if
                test="marc:subfield[@code = 'k'] or marc:subfield[@code = 'a' and not(contains(., 'Mercator') or contains(., 'Transverse Mercator') or contains(., 'Polar stereographic') or contains(., 'Oblique Mercator'))]">
                <xsl:for-each select="marc:subfield[@code = 'k']">
                    <rdawd:P10330>
                        <xsl:text>Scale factor: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>


    <!-- 344 -->

    <xsl:template name="F344-concept" expand-text="yes">
        <xsl:if test="
                not(marc:subfield[@code = '1'] and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8')]) = 1)
                and not(contains(marc:subfield[@code = '0'], 'http') and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8')]) = 1)">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '340' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('340-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <xsl:for-each select="
                            marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']
                            | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i']">
                        <xsl:variable name="currentCode" select="@code"/>
                        <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '344')"/>
                            <xsl:if test="$linked880">
                                <xsl:for-each
                                    select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
                                    <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1" expand-text="yes">
        <xsl:param name="propertyNum"/>
        <xsl:param name="entity"/>
        <xsl:variable name="subfield" select="."/>
        <xsl:choose>
            <!-- $1 -->
            <xsl:when test="
                    ../marc:subfield[@code = '1'] and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                    or @code = '6' or @code = '8')]) = 1">
                <xsl:for-each select="../marc:subfield[@code = '1']">
                    <xsl:element name="rda{$entity}o:{$propertyNum}">
                        <xsl:attribute name="rdf:resource" select="."/>
                    </xsl:element>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:call-template name="F344-xx-3">
                            <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                            <xsl:with-param name="subfield" select="$subfield"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <!-- $0 -->
                <xsl:choose>
                    <xsl:when test="
                            contains(../marc:subfield[@code = '0'], 'http') and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                            or @code = '6' or @code = '8')]) = 1">
                        <xsl:for-each select="../marc:subfield[@code = '0']">
                            <xsl:variable name="iri0" select="uwf:process0(.)"/>
                            <xsl:if test="$iri0">
                                <xsl:element name="rda{$entity}o:{$propertyNum}">
                                    <xsl:attribute name="rdf:resource" select="$iri0"/>
                                </xsl:element>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F344-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="$subfield"/>
                                        <xsl:with-param name="value" select="$iri0"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- $2 -->
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:variable name="sub2" select="../marc:subfield[@code = '2'][1]"/>
                                <xsl:choose>
                                    <xsl:when test="starts-with($sub2, 'rda') and $sub2 != 'rda'">
                                        <xsl:variable name="rdaIRI"
                                            select="uwf:rdaTermLookup($sub2, $subfield)"/>
                                        <xsl:if test="$rdaIRI">
                                            <xsl:element name="rda{$entity}o:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource" select="$rdaIRI"
                                                />
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$rdaIRI"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:if
                                            test="../@tag = '344' or substring(../marc:subfield[@code = '6'], 1, 6) = '344-00'">
                                            <xsl:element name="rda{$entity}o:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- If there were not $0s, $1s, or $2s that fit the above checks, a string value is used -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <!-- c may be part of LC's playing speed vocabulary -->
                                    <xsl:when test="$subfield/@code = 'c'">
                                        <xsl:variable name="lcIRI"
                                            select="uwf:lcTermLookup('Playing Speed', $subfield)"/>
                                        <xsl:choose>
                                            <xsl:when test="$lcIRI">
                                                <xsl:element name="rdamo:{$propertyNum}">
                                                  <xsl:attribute name="rdf:resource" select="$lcIRI"
                                                  />
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$lcIRI"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="rdamd:{$propertyNum}">
                                                  <xsl:value-of select="$subfield"/>
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$subfield"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <!-- f may be part of LC's tape configuration vocabulary -->
                                    <xsl:when test="$subfield/@code = 'f'">
                                        <xsl:variable name="lcIRI"
                                            select="uwf:lcTermLookup('Tape Configuration', $subfield)"/>
                                        <xsl:choose>
                                            <xsl:when test="$lcIRI">
                                                <xsl:element name="rdamo:{$propertyNum}">
                                                  <xsl:attribute name="rdf:resource" select="$lcIRI"
                                                  />
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$lcIRI"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="rdamd:{$propertyNum}">
                                                  <xsl:value-of select="$subfield"/>
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F344-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$subfield"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="rda{$entity}d:{$propertyNum}">
                                            <xsl:value-of select="$subfield"/>
                                        </xsl:element>
                                        <xsl:if test="../marc:subfield[@code = '3']">
                                            <xsl:call-template name="F344-xx-3">
                                                <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                <xsl:with-param name="subfield" select="$subfield"/>
                                                <xsl:with-param name="value" select="$subfield"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="F344-xx-3" expand-text="yes">
        <xsl:param name="sub3"/>
        <xsl:param name="subfield"/>
        <xsl:param name="value"/>
        <rdamd:P30137>
            <xsl:if test="$subfield/@code = 'a'">
                <xsl:text>Type of recording {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'b'">
                <xsl:text>Recording medium {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'c'">
                <xsl:text>Playing speed {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'd'">
                <xsl:choose>
                    <xsl:when test="(text() = 'fine') or (text() = 'standard')">
                        <xsl:text>Groove pitch {$value}</xsl:text>
                    </xsl:when>
                    <xsl:when test="(text() = 'coarse groove') or (text() = 'microgroove')">
                        <xsl:text>Groove width {$value}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>Groove characteristic {$value}</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'e'">
                <xsl:text>Track configuration {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'f'">
                <xsl:text>Tape configuration {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'g'">
                <xsl:text>Configuration of playback channels {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'h'">
                <xsl:text>Special playback characteristic {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'i'">
                <xsl:text>Sound content {$value}</xsl:text>
            </xsl:if>
            <xsl:text> applies to {$sub3}</xsl:text>
        </rdamd:P30137>
    </xsl:template>

    <!-- 346 -->
    <xsl:template name="F346-string" expand-text="yes">
        <!-- if it's only $a or only $b but no $0 or $1, or it's $a and $b -->
        <!-- need to test this logic -->
        <xsl:if test="
                ((not(marc:subfield[@code = 'b']) or not(marc:subfield[@code = 'a']))
                and (not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))))
                or (marc:subfield[@code = 'a'] and marc:subfield[@code = 'b'])">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                    <xsl:choose>
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30104 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text>Video format {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30123 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text>Broadcast standard {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- mint concepts -->
                        <xsl:otherwise>
                            <xsl:if
                                test="@tag = '346' or substring(marc:subfield[@code = '6'], 1, 6) = '346-00'">
                                <xsl:for-each select="marc:subfield[@code = 'a']">
                                    <rdam:P30104 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text>Video format {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="marc:subfield[@code = 'b']">
                                    <rdam:P30123 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>
                                            <xsl:text>Broadcast standard {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                                        </rdamd:P30137>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- no $2 - value from $a and $b -->
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdamd:P30104>{.}</rdamd:P30104>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Video format {.} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30123>{.}</rdamd:P30123>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Broadcast standard {.} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F346-concept" expand-text="yes">
        <!-- if it's only $a or only $b but no $0 or $1, or it's $a and $b -->
        <xsl:if test="
                ((not(marc:subfield[@code = 'b']) or not(marc:subfield[@code = 'a']))
                and (not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))))
                or (marc:subfield[@code = 'a'] and marc:subfield[@code = 'b'])">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '346' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('346-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>

                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
                        <xsl:variable name="currentCode" select="@code"/>
                        <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '346')"/>
                            <xsl:if test="$linked880">
                                <xsl:for-each
                                    select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
                                    <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F346-iri" expand-text="yes">
        <!-- a and not b -->
        <xsl:if test="marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b'])">
            <!-- for each 1, use 1 -->
            <xsl:for-each select="marc:subfield[@code = '1']">
                <rdam:P30104 rdf:resource="{.}"/>
            </xsl:for-each>
            <!-- if no 1, check 0 -->
            <xsl:if test="not(marc:subfield[@code = '1'])">
                <!-- if 0 contains http, get iri -->
                <xsl:for-each select="marc:subfield[@code = '0']">
                    <xsl:variable name="iri0" select="uwf:process0(marc:subfield[@code = '0'])"/>
                    <!-- if getting iri was successful (started with 'http' or '('), use 0s-->
                    <xsl:if test="$iri0">
                        <rdam:P30104 rdf:resource="{$iri0}"/>
                        <rdamd:P30137>
                            <xsl:text>Video format {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                        </rdamd:P30137>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
        <!-- b and not a -->
        <xsl:if test="marc:subfield[@code = 'b'] and not(marc:subfield[@code = 'a'])">
            <!-- for each 1, use 1 -->
            <xsl:for-each select="marc:subfield[@code = '1']">
                <rdam:P30123 rdf:resource="{.}"/>
            </xsl:for-each>
            <!-- if no 1, check 0 -->
            <xsl:if test="not(marc:subfield[@code = '1'])">
                <!-- if 0 contains http, get iri -->
                <xsl:for-each select="marc:subfield[@code = '0']">
                    <xsl:variable name="iri0" select="uwf:process0(.)"/>
                    <!-- if getting iri was successful (started with 'http' or '(') 
                                 use 0s-->
                    <xsl:if test="$iri0">
                        <rdam:P30123 rdf:resource="{$iri0}"/>
                        <rdamd:P30137>
                            <xsl:text>Broadcast standard {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</xsl:text>
                        </rdamd:P30137>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- 347 -->

    <xsl:template name="F347-c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30183>
                <xsl:value-of select="."/>
            </rdamd:P30183>
            <xsl:if test="../marc:subfield[@code = '3']">
                <xsl:call-template name="F347-xx-3">
                    <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                    <xsl:with-param name="subfield" select="."/>
                    <xsl:with-param name="value" select="."/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F347-concept" expand-text="yes">
        <xsl:if test="
                not(marc:subfield[@code = '1'] and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8')]) = 1)
                and not(contains(marc:subfield[@code = '0'], 'http') and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                or @code = '6' or @code = '8')]) = 1)">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '347' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('347-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>

                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <xsl:for-each
                        select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'e']">
                        <xsl:variable name="currentCode" select="@code"/>
                        <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '347')"/>
                            <xsl:if test="$linked880">
                                <xsl:for-each
                                    select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
                                    <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                </xsl:for-each>
                            </xsl:if>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F347-xx-a_b_d_e_f_0_1" expand-text="yes">
        <xsl:param name="propertyNum"/>
        <xsl:variable name="subfield" select="."/>
        <xsl:choose>
            <xsl:when test="
                    ../marc:subfield[@code = '1'] and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                    or @code = '6' or @code = '8')]) = 1">
                <xsl:for-each select="../marc:subfield[@code = '1']">
                    <xsl:element name="rdam:{$propertyNum}">
                        <xsl:attribute name="rdf:resource" select="."/>
                    </xsl:element>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:call-template name="F347-xx-3">
                            <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                            <xsl:with-param name="subfield" select="$subfield"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="
                            contains(../marc:subfield[@code = '0'], 'http') and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3'
                            or @code = '6' or @code = '8')]) = 1">
                        <xsl:for-each select="../marc:subfield[@code = '0']">
                            <xsl:variable name="iri0" select="uwf:process0(.)"/>
                            <xsl:if test="$iri0">
                                <xsl:element name="rdam:{$propertyNum}">
                                    <xsl:attribute name="rdf:resource" select="$iri0"/>
                                </xsl:element>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F347-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="$subfield"/>
                                        <xsl:with-param name="value" select="$iri0"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- $2 -->
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:variable name="sub2" select="../marc:subfield[@code = '2'][1]"/>
                                <xsl:choose>
                                    <xsl:when test="matches($sub2, '^rda.+')">
                                        <xsl:variable name="rdaIRI"
                                            select="uwf:rdaTermLookup($sub2, $subfield)"/>
                                        <xsl:if test="$rdaIRI">
                                            <xsl:element name="rdam:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource" select="$rdaIRI"
                                                />
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F347-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$rdaIRI"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:when>
                                    <!-- if there is a $2 that is not rda (or is only 'rda') 
                                        then a concept is minted -->
                                    <xsl:otherwise>
                                        <xsl:if
                                            test="../@tag = '347' or substring(../marc:subfield[@code = '6'], 1, 6) = '340-00'">
                                            <xsl:element name="rdam:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F347-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value"
                                                  select="uwf:conceptIRI($sub2, $subfield)"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- If there were not $0s, $1s, or $2s that fit the above checks, a string value is used -->
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$subfield/@code = 'b'">
                                        <xsl:variable name="lcIRI"
                                            select="uwf:lcTermLookup('Encoding Format', $subfield)"/>
                                        <xsl:choose>
                                            <xsl:when test="$lcIRI">
                                                <xsl:element name="rdam:{$propertyNum}">
                                                  <xsl:attribute name="rdf:resource" select="$lcIRI"
                                                  />
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F347-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$lcIRI"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="rdamd:{$propertyNum}">
                                                  <xsl:value-of select="$subfield"/>
                                                </xsl:element>
                                                <xsl:if test="../marc:subfield[@code = '3']">
                                                  <xsl:call-template name="F347-xx-3">
                                                  <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                  <xsl:with-param name="subfield" select="$subfield"/>
                                                  <xsl:with-param name="value" select="$subfield"/>
                                                  </xsl:call-template>
                                                </xsl:if>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="rdamd:{$propertyNum}">
                                            <xsl:value-of select="$subfield"/>
                                        </xsl:element>
                                        <xsl:if test="../marc:subfield[@code = '3']">
                                            <xsl:call-template name="F347-xx-3">
                                                <xsl:with-param name="sub3"
                                                  select="../marc:subfield[@code = '3']"/>
                                                <xsl:with-param name="subfield" select="$subfield"/>
                                                <xsl:with-param name="value" select="$subfield"/>
                                            </xsl:call-template>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="F347-xx-3" expand-text="yes">
        <xsl:param name="sub3"/>
        <xsl:param name="subfield"/>
        <xsl:param name="value"/>
        <rdamd:P30137>
            <xsl:if test="$subfield/@code = 'a'">
                <xsl:text>File type {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'b'">
                <xsl:text>Encoding format {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'c'">
                <xsl:text>File size {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'd'">
                <xsl:text>Resolution {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'e'">
                <xsl:text>Regional encoding {$value}</xsl:text>
            </xsl:if>
            <xsl:if test="$subfield/@code = 'f'">
                <xsl:text>Encoded bitrate {$value}</xsl:text>
            </xsl:if>
            <xsl:text> applies to {$sub3}</xsl:text>
        </rdamd:P30137>
    </xsl:template>

    <!-- 357 -->
    <xsl:template name="F357-xx-abcg" expand-text="yes">
        <!-- Pull all subfields -->
        <xsl:variable name="a" select="normalize-space(string(marc:subfield[@code = 'a'][1]))"/>
        <xsl:variable name="b-list" select="marc:subfield[@code = 'b']"/>
        <xsl:variable name="c-list" select="marc:subfield[@code = 'c']"/>
        <xsl:variable name="g-list" select="marc:subfield[@code = 'g']"/>

        <!-- a&b&c&g -->
              <xsl:if test="$a and $b-list and $c-list and $g-list">
                 <rdamd:P30146>
                     <xsl:text>The originating agency, </xsl:text>
                     <xsl:value-of select="string-join($b-list, '; ')"/>
                     <xsl:text>, denotes their control of dissemination using the term </xsl:text>
                     <xsl:value-of select="$a"/>
                     <xsl:text> to the authorized recipients, </xsl:text>
                     <xsl:value-of select="string-join($c-list, '; ')"/>
                     <xsl:text>, with the following restrictions: </xsl:text>
                     <xsl:value-of select="string-join($g-list, '; ')"/>
                 </rdamd:P30146>
             </xsl:if>
   
        <rdamd:P30137>
            <xsl:choose>
                
            <!-- a, a&c, a&g, a&c&g -->
                <xsl:when test="$a and empty($b-list)">
                    <xsl:text>The disseminating agency denotes their control of dissemination using the term </xsl:text>
                    <xsl:value-of select="$a"/>
                    
                    <xsl:if test="$c-list">
                        <xsl:text> to the authorized recipients, </xsl:text>
                        <xsl:value-of select="string-join($c-list, '; ')"/>
                    </xsl:if>
                    
                    <xsl:if test="$g-list">
                        <xsl:choose>
                            <xsl:when test="$c-list">
                                <xsl:text>, with the following restrictions: </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> with the following restrictions: </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="string-join($g-list, '; ')"/>
                    </xsl:if>
                </xsl:when>

            <!-- b -->
                <xsl:when test="not($a) and $b-list and not($c-list) and not($g-list)">
                    <xsl:text>The originating agency is </xsl:text>
                    <xsl:value-of select="string-join($b-list, '; ')"/>
                </xsl:when>

            <!-- a&b, a&b&c, a&b&g, a&b&c&g, b&c, b&g, b&c&g -->
                <!-- cases with a -->
                <xsl:when test="$b-list != '' and not($a = '' and $c-list = '' and $g-list = '')">
                    <xsl:text>The originating agency, </xsl:text>
                    <xsl:value-of select="string-join($b-list, '; ')"/>
                    <xsl:text>, denotes their control of dissemination using the term </xsl:text>
                <xsl:value-of select="$a"/>
                
                <xsl:if test="$c-list">
                    <xsl:text> to the authorized recipients, </xsl:text>
                    <xsl:value-of select="string-join($c-list, '; ')"/>
                </xsl:if>
                
                <xsl:if test="$g-list">
                    <xsl:choose>
                        <xsl:when test="$c-list">
                            <xsl:text>, with the following restrictions: </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> with the following restrictions: </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="string-join($g-list, '; ')"/>
                </xsl:if>
                </xsl:when>

                <!-- cases without a -->
                <xsl:when test="$b-list != '' and not($a = '' and $c-list = '' and $g-list = '')">
                    <xsl:text>The originating agency, </xsl:text>
                    <xsl:value-of select="string-join($b-list, '; ')"/>
                    
                    <xsl:if test="$c-list">
                        <xsl:text> controls dissemination to the authorized recipients, </xsl:text>
                        <xsl:value-of select="string-join($c-list, '; ')"/>
                    </xsl:if>
                    
                    <xsl:if test="$g-list">
                        <xsl:choose>
                            <xsl:when test="$c-list">
                                <xsl:text>, with the following restrictions: </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text> denotes their control of dissemination with the following restrictions: </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:value-of select="string-join($g-list, '; ')"/>
                    </xsl:if>
                </xsl:when>

            <!-- c, g, c&g -->
                <xsl:when test="$c-list and not($a) and not($b-list)">
                    <xsl:text>Disseminated by the originating agency to the following authorized recipient: </xsl:text>
                    <xsl:value-of select="string-join($c-list, '; ')"/>
                    
                    <xsl:if test="$g-list">
                        <xsl:text>, with the following restrictions: </xsl:text>
                        <xsl:value-of select="string-join($g-list, '; ')"/>
                    </xsl:if>
                </xsl:when>
                
                <xsl:when test="$g-list and not($a) and not($b-list) and not($c-list)">
                    <xsl:text>Desseminated with the following restrictions: </xsl:text>
                    <xsl:value-of select="string-join($g-list, '; ')"/>
                </xsl:when>
            </xsl:choose>
        </rdamd:P30137>
    </xsl:template>

    <!-- 380 -->
    <xsl:template name="F380-iri" expand-text="yes">
        <!-- If $1 value (or multiple), use those -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaw:P10004 rdf:resource="{.}"/>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdawd:P10330>
                    <xsl:text>Category of work {.} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                </rdawd:P10330>
            </xsl:if>
        </xsl:for-each>
        <!-- If there's no $1 but there are $0s that begin with http(s), use these -->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <!-- $0's contianing a uri may start with (uri) -->
                <xsl:if test="contains(., 'http')">
                    <xsl:variable name="iri0">
                        <xsl:choose>
                            <xsl:when test="starts-with(., 'http')">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:when test="starts-with(., '(')">
                                <xsl:value-of select="substring-after(., ')')"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$iri0">
                        <rdaw:P10004 rdf:resource="{$iri0}"/>
                    </xsl:if>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <rdawd:P10330>
                            <xsl:text>Category of work {$iri0} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                        </rdawd:P10330>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F380-string" expand-text="yes">
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:choose>
                <!-- if there's a $2 -->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:if
                        test="@tag = '380' or substring(marc:subfield[@code = '6'], 1, 6) = '380-00'">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdaw:P10004
                                rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)}"/>
                            <xsl:if test="../marc:subfield[@code = '3']">
                                <rdawd:P10330>
                                    <xsl:text>Category of work {.} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                                </rdawd:P10330>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:when>
                <!-- no $2 -->
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdawd:P10004>
                            <xsl:value-of select="."/>
                        </rdawd:P10004>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdawd:P10330>
                                <xsl:text>Category of work {.} applies to the work's {../marc:subfield[@code = '3']}</xsl:text>
                            </rdawd:P10330>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="F380-concept" expand-text="yes">
        <xsl:if
            test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '380' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('380-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                        />
                    </xsl:if>
                </xsl:variable>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '380')"/>
                        <xsl:if test="$linked880">
                            <xsl:for-each
                                select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                            </xsl:for-each>
                        </xsl:if>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- 382 -->
    <xsl:template name="F382-xx-a_b_d_p_0_1_2-exp" expand-text="yes">
        <xsl:variable name="s2code" select="marc:subfield[@code = '2'][1]"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '2']">
                <xsl:if
                    test="@tag = '382' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '382-00'))">
                    <xsl:for-each
                        select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                        <rdae:P20215
                            rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)}"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each
                    select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                    <rdaed:P20215>{.}</rdaed:P20215>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaeo:P20215 rdf:resource="{.}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <!-- $0's contianing a uri may start with (uri) -->
            <xsl:if test="contains(., 'http')">
                <xsl:variable name="iri0">
                    <xsl:choose>
                        <xsl:when test="starts-with(., 'http')">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:when test="starts-with(., '(')">
                            <xsl:value-of select="substring-after(., ')')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$iri0">
                    <rdaeo:P20215 rdf:resource="{$iri0}"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F382-xx-abdenprstv3" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '3']">{marc:subfield[@code = '3']||': '}</xsl:if>
        <xsl:text>For </xsl:text>
        <xsl:variable name="delimited">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 'r'] | marc:subfield[@code = 's'] | marc:subfield[@code = 't'] | marc:subfield[@code = 'v']">
                <xsl:if test=".[@code = 'a']">{.||'; '}</xsl:if>
                <xsl:if test=".[@code = 'n' or @code = 'e']">{'('||.||'); '}</xsl:if>
                <xsl:if test=".[@code = 'b']">{'solo '||.||'AFTERB '}</xsl:if>
                <xsl:if test=".[@code = 'd']">{'/'||.||' '}</xsl:if>
                <xsl:if test=".[@code = 'p']">{'or '||.||' '}</xsl:if>
                <xsl:if test=".[@code = 'v']">{'('||.||') '}</xsl:if>
                <xsl:if test=".[@code = 'r']">{'Total soloists: '||.||'. '}</xsl:if>
                <xsl:if test=".[@code = 's']">{'Total performers: '||.||'. '}</xsl:if>
                <xsl:if test=".[@code = 't']">{'Total ensembles: '||.||'. '}</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of
            select="$delimited => replace(' \([0-9]+\); /', '/') => replace(' \([0-9]+\); or ', ' or ') => replace('Total soloists: 1\.', '') => replace('Total performers: 1\.', '') => replace('Total ensembles: 1\.', '') => replace(' \(0', ' (') => replace(' \(1\);', ';') => replace(';+ \[', ' [') => replace('\] /', ']/') => replace('\] ([a-z])', ']; $1') => replace('; Total ', '. Total ') => replace(' +$', '') => replace('\] Total', ']. Total') => replace(';;', ';') => replace(';\.', '.') => replace('; \(', ' (') => replace(';/', '/') => replace('; or ', ' or ') => replace(';$', '') => replace('AFTERB;', ';') => replace('AFTERB/', '/') => replace('AFTERB or ', ' or ') => replace('AFTERB \[', ' [') => replace('AFTERB', ';') => replace('::', ':')"
        />
    </xsl:template>
    <xsl:template name="F382-xx-a_b_d_p_0_1_2-wor" expand-text="yes">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '2']">
                <xsl:if
                    test="@tag = '382' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '382-00'))">
                    <xsl:for-each
                        select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                        <rdaw:P10220
                            rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'], .)}"/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each
                    select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                    <rdawd:P10220>{.}</rdawd:P10220>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdawo:P10220 rdf:resource="{.}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <!-- $0's contianing a uri may start with (uri) -->
            <xsl:if test="contains(., 'http')">
                <xsl:variable name="iri0">
                    <xsl:choose>
                        <xsl:when test="starts-with(., 'http')">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:when test="starts-with(., '(')">
                            <xsl:value-of select="substring-after(., ')')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:if test="$iri0">
                    <rdawo:P10220 rdf:resource="{$iri0}"/>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

        <!--383 templates-->
    <xsl:template name="F383-3">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:text>Serial number </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:text>Opus number </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:text>Thematic index number </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'd']">
            <xsl:text>Thematic index code </xsl:text>
            <xsl:value-of select="."/>
            <xsl:text> applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F383-nom">
        <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
        <rdand:P80068>
            <xsl:if test="preceding-sibling::marc:subfield[@code = 'c']">
                <xsl:value-of select="preceding-sibling::marc:subfield[@code = 'c']"/>
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="."/> 
        </rdand:P80068>    
        <xsl:choose>
            <xsl:when test="$source = 'mlati'">    
                <rdano:P80069 rdf:resource="cmc.wp.musiclibraryassoc.org/thematic-index/l"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            </xsl:when>
            <xsl:otherwise>
                <rdand:P80069>
                    <xsl:value-of select="$source"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
