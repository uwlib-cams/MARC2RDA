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
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf madsrdf" version="3.0">
    <xsl:import href="m2r-functions.xsl"/>
    
    <xsl:template name="F336-xx-ab0-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code = '3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code = '3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdaed:P20001>
                    <xsl:value-of select="."/>
                </rdaed:P20001>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <rdaed:P20071>
                        <xsl:text>Content Type '</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>' applies to a manifestation's </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                    </rdaed:P20071>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:choose>
                <xsl:when
                    test="matches(marc:subfield[@code = '2'], '^rda.+') and not(contains(marc:subfield[@code = '0'], 'http:')) and not(marc:subfield[@code = '1'])">
                    <xsl:comment>Source of rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code = '2']"/>': lookup the value of rdaed:P20001 in that source, retrieve the IRI and insert it into the data as the direct value of rdaeo:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when
                    test="not(matches(marc:subfield[@code = '2'], '^rda.+')) and not(contains(marc:subfield[@code = '0'], 'http:')) and not(marc:subfield[@code = '1'])">
                    <xsl:comment>Source of the rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code = '2']"/>': it may be possible to consult that source to retrieve an IRI for the current value of rdaed:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when
                    test="not(matches(marc:subfield[@code = '2'], '^rda.+')) and contains(marc:subfield[@code = '0'], 'http:') and not(marc:subfield[@code = '1'])"
                    ><!-- do nothing --></xsl:when>
                <xsl:otherwise>
                    <xsl:comment>$2 source not needed as $2 is rda and the $0 or $1 should be the direct value of P20001</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F336-xx-01-iri">
        <xsl:if test="matches(marc:subfield[@code = '2'], '^rda.+')">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <rdaeo:P20001 rdf:resource="{replace(., '^\(uri\)','')}"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if
            test="not(matches(marc:subfield[@code = '2'], '^rda.+')) or not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <xsl:comment>MARC data source at field 336 contains a $0 IRI value representing authority data without the presence of a $1; a solution for outputting these in RDA is not yet devised.</xsl:comment>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaeo:P20001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 337 -->
    <xsl:template name="F337-string" expand-text="yes">
        <!-- if there are no IRIs to use, continue to $a's and $b's -->
        <xsl:if test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            
            <!-- pattern testing variables -->
            <!-- aTest determines whether all $a's are followed by $b's -->
            <xsl:variable name="aTest" select="if (every $a in ./marc:subfield[@code = 'a'] satisfies 
                ($a[following-sibling::marc:subfield[1][@code = 'b']])) then 'Yes' else 'No'"/>
            <!-- bTest determines whether all $b's are preceded by $a's -->
            <!-- if both aTest and bTest are true, then the field is patterned ababab... -->
            <xsl:variable name="bTest" select="if (every $b in ./marc:subfield[@code = 'b'] satisfies
                ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then 'Yes' else 'No'"/>
            
            <xsl:choose>
                <!-- if there's a $2 -->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                    <xsl:choose>
                        <!-- when $2 starts with rda, we lookup the $2 code and then the $a/$b terms from there-->
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <!-- for $a's, rdaTermLookup is called -->
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30002 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- for $b's it's rdaCodeLookup (both in m2r-functions) -->
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaCodeLookup($sub2, .)"/>
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30002 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <!-- other $2s, we mint concepts -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- no b's -->
                                <xsl:when test="not(marc:subfield[@code = 'b'])">
                                    <!-- we only mint concepts for 337s or unpaired 880s, paired 880s are combined with their match into one concept -->
                                    <xsl:if test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- no a's - use b's -->
                                <xsl:when test="not(marc:subfield[@code = 'a'])">
                                    <xsl:if test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'b']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in abab pattern -->
                                <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                    <xsl:if test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in any other pattern - ignore b's -->
                                <xsl:otherwise>
                                    <xsl:if test="@tag = '337' or substring(marc:subfield[@code = '6'], 1, 6) = '337-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30002 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                        <rdamd:P30002>
                            <xsl:value-of select="."/>
                        </rdamd:P30002>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30002>
                            <xsl:value-of select="."/>
                        </rdamd:P30002>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F337-concept">
        <!-- mint concepts when $2 is not rdamedia or rdamt -->
        <xsl:if test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '337' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('337-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                        
                        <!-- same test variables as in F337-string -->
                        <xsl:variable name="aTest" select="if (every $a in ./marc:subfield[@code = 'a'] satisfies 
                            ($a[following-sibling::marc:subfield[1][@code = 'b']])) then 'Yes' else 'No'"/>
                        <xsl:variable name="bTest" select="if (every $b in ./marc:subfield[@code = 'b'] satisfies
                            ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then 'Yes' else 'No'"/>
                        
                        <xsl:choose>
                            <!-- no b's -->
                            <xsl:when test="not(marc:subfield[@code = 'b'])">
                                <xsl:for-each select="marc:subfield[@code = 'a']">
                                    <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                        <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '337')"/>
                                        <xsl:if test="$linked880">
                                            <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                                <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </rdf:Description>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no a's - use b's -->
                            <xsl:when test="not(marc:subfield[@code = 'a'])">
                                <xsl:for-each select="marc:subfield[@code = 'b']">
                                    <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                        <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '337')"/>
                                        <xsl:if test="$linked880">
                                            <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                                <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </rdf:Description>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- a's and b's in abab pattern, we include $b as the skos:notation -->
                            <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                <xsl:for-each select="marc:subfield[@code = 'a']">
                                    <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                        <xsl:copy-of select="uwf:fillConcept( ., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], '337')"/>
                                        <xsl:if test="$linked880">
                                            <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                                <xsl:copy-of select="uwf:fillConcept( ., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"/>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </rdf:Description>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- a's and b's in any other pattern - ignore b's -->
                            <xsl:otherwise>
                                <xsl:for-each select="marc:subfield[@code = 'a']">
                                    <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                        <xsl:copy-of select="uwf:fillConcept( ., $sub2, '', '337')"/>
                                        <xsl:if test="$linked880">
                                            <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                                <xsl:copy-of select="uwf:fillConcept( ., '', '', '880')"/>
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
        <!-- If $1 value (or multiple), use those -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdam:P30002 rdf:resource="{.}"/>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>Media type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                        <rdam:P30002 rdf:resource="{$iri0}"/>
                    </xsl:if>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <rdamd:P30137>Carrier type {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 338 -->
    <xsl:template name="F338-string" expand-text="yes">
        <!-- if there are no IRIs to use, continue to $a's and $b's -->
        <xsl:if test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            
            <!-- pattern testing variables -->
            <!-- aTest determines whether all $a's are followed by $b's -->
            <xsl:variable name="aTest" select="if (every $a in ./marc:subfield[@code = 'a'] satisfies 
                ($a[following-sibling::marc:subfield[1][@code = 'b']])) then 'Yes' else 'No'"/>
            <!-- bTest determines whether all $b's are preceded by $a's -->
            <!-- if both aTest and bTest are true, then the field is patterned ababab... -->
            <xsl:variable name="bTest" select="if (every $b in ./marc:subfield[@code = 'b'] satisfies
                ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then 'Yes' else 'No'"/>
            
            <xsl:choose>
                <!-- if there's a $2 -->
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                    <xsl:choose>
                        <!-- when $2 starts with rda (but isn't 'rda'), we look up the $2 code and then the $a/$b terms from there-->
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <!-- for $a's, rdaTermLookup is called -->
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30001 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                            <!-- for $b's it's rdaCodeLookup (both in m2r-functions) -->
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaCodeLookup($sub2, .)"/>
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30001 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Media type {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        
                        <!-- other $2s, we mint concepts -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <!-- no b's -->
                                <xsl:when test="not(marc:subfield[@code = 'b'])">
                                    <!-- we only mint concepts for 337s or unpaired 880s, paired 880s are combined with their match into one concept -->
                                    <xsl:if test="@tag = '338' or substring(marc:subfield[@code = '6'], 1, 6) = '338-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Carrier type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- no a's - use b's -->
                                <xsl:when test="not(marc:subfield[@code = 'a'])">
                                    <xsl:if test="@tag = '338' or substring(marc:subfield[@code = '6'], 1, 6) = '338-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'b']">
                                            <rdam:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Media type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in abab pattern -->
                                <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                                    <xsl:if test="@tag = '338' or substring(marc:subfield[@code = '6'], 1, 6) = '338-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Carrier type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <!-- a's and b's in any other pattern - ignore b's -->
                                <xsl:otherwise>
                                    <xsl:if test="@tag = '338' or substring(marc:subfield[@code = '6'], 1, 6) = '338-00'">
                                        <xsl:for-each select="marc:subfield[@code = 'a']">
                                            <rdam:P30001 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <rdamd:P30137>Carrier type {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                        <rdamd:P30001>
                            <xsl:value-of select="."/>
                        </rdamd:P30001>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>Carrier type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30001>
                            <xsl:value-of select="."/>
                        </rdamd:P30001>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>Carrier type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F338-concept">
        <xsl:if test="not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '338' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('338-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    
                    <xsl:variable name="aTest" select="if (every $a in ./marc:subfield[@code = 'a'] satisfies 
                        ($a[following-sibling::marc:subfield[1][@code = 'b']])) then 'Yes' else 'No'"/>
                    <xsl:variable name="bTest" select="if (every $b in ./marc:subfield[@code = 'b'] satisfies
                        ($b[preceding-sibling::marc:subfield[1][@code = 'a']])) then 'Yes' else 'No'"/>
                    
                    <xsl:choose>
                        <!-- no b's -->
                        <xsl:when test="not(marc:subfield[@code = 'b'])">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '338')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- no a's - use b's -->
                        <xsl:when test="not(marc:subfield[@code = 'a'])">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '338')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'b']">
                                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in abab pattern, we include $b as the skos:notation -->
                        <xsl:when test="$aTest = 'Yes' and $bTest = 'Yes'">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept( ., $sub2, ./following-sibling::marc:subfield[@code = 'b'][1], '338')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept( ., '', ./following-sibling::marc:subfield[@code = 'b'][1], '880')"/>
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdf:Description>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- a's and b's in any other pattern - ignore b's -->
                        <xsl:otherwise>
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                    <xsl:copy-of select="uwf:fillConcept( ., $sub2, '', '338')"/>
                                    <xsl:if test="$linked880">
                                        <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = 'a']">
                                            <xsl:copy-of select="uwf:fillConcept( ., '', '', '880')"/>
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
    
    <xsl:template name="F338-iri" expand-text="yes">
        <!-- If $1 value (or multiple), use those -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdam:P30001 rdf:resource="{.}"/>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>Carrier type {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <!-- If there's no $1 but there are $0s that begin with http(s), use these -->
        <xsl:if test="not(marc:subfield[@code = '1'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
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
                        <rdamd:P30137>Carrier type {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 340 -->
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
    
    <xsl:template name="F340-concept" expand-text="yes">
        <xsl:if test="not(marc:subfield[@code = '1'] and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3' 
            or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1)
            and not(contains(marc:subfield[@code = '0'], 'http') and count(*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3' 
            or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1)">
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                    <xsl:variable name="linked880">
                        <xsl:if test="@tag = '340' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum"
                                select="concat('340-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:copy-of
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"/>
                        </xsl:if>
                    </xsl:variable>
                    
                    <xsl:if test="not(matches($sub2, '^rda.+'))">
                        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
                            | marc:subfield[@code = 'e'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'j']
                            | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm']
                            | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
                            | marc:subfield[@code = 'q']">
                            <xsl:variable name="currentCode" select="@code"/>
                            <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                                <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '340')"/>
                                <xsl:if test="$linked880">
                                    <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
                                        <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                                    </xsl:for-each>
                                </xsl:if>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
    </xsl:template>
    
    <!-- function for minimizing repitition when handling all the many 340 subfields -->
    <xsl:template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1" expand-text="yes">
        <xsl:param name="propertyNum"/>
        <xsl:variable name="subfield" select="."/>
        <xsl:choose>
            <!-- 1 and only one other subfield -->
            <xsl:when test="../marc:subfield[@code = '1'] and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3' 
                or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1">
                <xsl:for-each select="../marc:subfield[@code = '1']">
                    <xsl:element name="rdam:{$propertyNum}">
                        <xsl:attribute name="rdf:resource" select="."/>
                    </xsl:element>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:call-template name="F340-xx-3">
                            <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                            <xsl:with-param name="subfield" select="$subfield"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <!-- no $1 -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- $0 with http and only one other subfield -->
                    <xsl:when test="contains(../marc:subfield[@code = '0'], 'http') and count(../*[not(@code = '0' or @code = '1' or @code = '2' or @code = '3' 
                        or @code = '6' or @code = '8' or @code = 'b' or @code = 'f' or @code = 'h' or @code = 'i')]) = 1">
                        <xsl:for-each select="../marc:subfield[@code = '0']">
                            <xsl:variable name="iri0" select="uwf:process0(.)"/>
                            <!-- if getting iri was successful (started with 'http' or '('), use 0s-->
                            <xsl:if test="$iri0">
                                <xsl:element name="rdam:{$propertyNum}">
                                    <xsl:attribute name="rdf:resource" select="$iri0"/>
                                </xsl:element>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F340-xx-3">
                                        <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="$subfield"/>
                                        <xsl:with-param name="value" select="$iri0"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <!-- no $1 or $0 (http) or multiple text subfields -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- $2 -->
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:variable name="sub2" select="../marc:subfield[@code = '2']"/>
                                <xsl:choose>
                                    <!-- when $2 starts with rda, we lookup the $2 code and then the $a/$b terms from there-->
                                    <xsl:when test="matches($sub2, '^rda.+')">
                                        <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, $subfield)"/>
                                        <!-- only output the property if the function returns a value -->
                                        <!-- we don't want a triple with no object -->
                                        <xsl:if test="$rdaIRI">
                                            <xsl:element name="rdam:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource" select="$rdaIRI"/>
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F340-xx-3">
                                                    <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                                                    <xsl:with-param name="subfield" select="$subfield"/>
                                                    <xsl:with-param name="value" select="$rdaIRI"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:when>
                                    <!-- other $2s not rda -->
                                    <xsl:otherwise>
                                        <xsl:if test="../@tag = '340' or substring(../marc:subfield[@code = '6'], 1, 6) = '340-00'">
                                            <xsl:element name="rdam:{$propertyNum}">
                                                <xsl:attribute name="rdf:resource" select="uwf:conceptIRI($sub2, $subfield)"/>
                                            </xsl:element>
                                            <xsl:if test="../marc:subfield[@code = '3']">
                                                <xsl:call-template name="F340-xx-3">
                                                    <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                                                    <xsl:with-param name="subfield" select="$subfield"/>
                                                    <xsl:with-param name="value" select="uwf:conceptIRI($sub2, $subfield)"/>
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:if>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- no $0 (http), $1, or $2 -->
                            <xsl:otherwise>
                                <xsl:element name="rdamd:{$propertyNum}">
                                    <xsl:value-of select="$subfield"/>
                                </xsl:element>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F340-xx-3">
                                        <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
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
    
    <xsl:template name="F340-xx-3" expand-text="yes">
        <xsl:param name="sub3"/>
        <xsl:param name="subfield"/>
        <xsl:param name="value"/>
        <rdamd:P30137>
            <xsl:if test="$subfield/@code = 'a'">
                <xsl:text>Has material base and configuration {$value}</xsl:text>
            </xsl:if> 
            <xsl:if test="$subfield/@code = 'c'">
                <xsl:text>has materials applied to surface {$value}</xsl:text>
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
    
    <!-- 346 -->
    <xsl:template name="F346-string" expand-text="yes">
        <!-- if it's only $a or only $b but no $0 or $1, or it's $a and $b -->
        <!-- need to test this logic -->
        <xsl:if test="((not(marc:subfield[@code = 'b']) or not(marc:subfield[@code = 'a'])) 
            and (not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))))
            or (marc:subfield[@code = 'a'] and marc:subfield[@code = 'b'])">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                    <xsl:choose>
                        <xsl:when test="matches($sub2, '^rda.+')">
                            <xsl:for-each select="marc:subfield[@code = 'a']">
                                <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup($sub2, .)"/>
                                <!-- only output the property if the function returns a value -->
                                <!-- we don't want a triple with no object -->
                                <xsl:if test="$rdaIRI">
                                    <rdam:P30104 rdf:resource="{$rdaIRI}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Video format {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                                        <rdamd:P30137>Broadcast standard {$rdaIRI} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <!-- mint concepts -->
                        <xsl:otherwise>
                            <xsl:if test="@tag = '346' or substring(marc:subfield[@code = '6'], 1, 6) = '346-00'">
                                <xsl:for-each select="marc:subfield[@code = 'a']">
                                    <rdam:P30104 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Video format {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                                    </xsl:if>
                                </xsl:for-each>
                                <xsl:for-each select="marc:subfield[@code = 'b']">
                                    <rdam:P30123 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
                                    <xsl:if test="../marc:subfield[@code = '3']">
                                        <rdamd:P30137>Broadcast standard {uwf:conceptIRI($sub2, .)} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                            <rdamd:P30137>Video format {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <rdamd:P30123>{.}</rdamd:P30123>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>Broadcast standard {.} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F346-concept" expand-text="yes">
        <!-- if it's only $a or only $b but no $0 or $1, or it's $a and $b -->
        <xsl:if test="((not(marc:subfield[@code = 'b']) or not(marc:subfield[@code = 'a'])) 
            and (not(marc:subfield[@code = '1']) and not(contains(marc:subfield[@code = '0'], 'http'))))
            or (marc:subfield[@code = 'a'] and marc:subfield[@code = 'b'])">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="sub2" select="marc:subfield[@code = '2']"/>
                <xsl:variable name="linked880">
                    <xsl:if test="@tag = '346' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('346-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:copy-of
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"/>
                    </xsl:if>
                </xsl:variable>
         
                <xsl:if test="not(matches($sub2, '^rda.+'))">
                    <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
                        <xsl:variable name="currentCode" select="@code"/>
                        <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '346')"/>
                            <xsl:if test="$linked880">
                                <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = $currentCode]">
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
                            <rdamd:P30137>Video format {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
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
                        <rdamd:P30137>Broadcast standard {$iri0} applies to the manifestation's {../marc:subfield[@code = '3']}</rdamd:P30137>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F382-xx-a_b_d_p_2-exp" expand-text="yes">
        <xsl:variable name="s2code" select="marc:subfield[@code = '2']"/>
        <xsl:variable name="musiccodeschemes"
            select="document('http://id.loc.gov/vocabulary/musiccodeschemes.madsrdf.rdf')"/>
        <xsl:variable name="sourceiri">
            <xsl:for-each
                select="$musiccodeschemes/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/@rdf:resource">
                <xsl:if
                    test="substring-after(., 'http://id.loc.gov/vocabulary/musiccodeschemes/') = $s2code">
                    <xsl:text>http://id.loc.gov/vocabulary/musiccodeschemes/</xsl:text>
                    <xsl:value-of select="$s2code"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="contains($sourceiri, 'lcmpt')">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215 rdf:datatype="http://id.loc.gov/authorities/performanceMediums"
                    >{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri != '' and not(contains($sourceiri, 'lcmpt'))">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215 rdf:datatype="{$sourceiri}">{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri = ''">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215>{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
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
    <xsl:template name="F382-xx-a_b_d_p_2-wor" expand-text="yes">
        <xsl:variable name="s2code" select="marc:subfield[@code = '2']"/>
        <xsl:variable name="musiccodeschemes"
            select="document('http://id.loc.gov/vocabulary/musiccodeschemes.madsrdf.rdf')"/>
        <xsl:variable name="sourceiri">
            <xsl:for-each
                select="$musiccodeschemes/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/@rdf:resource">
                <xsl:if
                    test="substring-after(., 'http://id.loc.gov/vocabulary/musiccodeschemes/') = $s2code">
                    <xsl:text>http://id.loc.gov/vocabulary/musiccodeschemes/</xsl:text>
                    <xsl:value-of select="$s2code"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="contains($sourceiri, 'lcmpt')">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220 rdf:datatype="http://id.loc.gov/authorities/performanceMediums"
                    >{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri != '' and not(contains($sourceiri, 'lcmpt'))">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220 rdf:datatype="{$sourceiri}">{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri = ''">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220>{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
