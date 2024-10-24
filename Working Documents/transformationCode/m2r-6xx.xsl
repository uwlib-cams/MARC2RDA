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
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
    version="3.0">
    <xsl:include href="m2r-6xx-named.xsl"/>
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- field level templates - wor, exp, man, ite -->
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <!-- store subject heading label in variable -->
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610'">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611'">
                    <xsl:call-template name="F611-label"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!-- If there are more than just name part subfields (v, x, y, z) 
            then "has subject" is used alongside "has subject [agent]" -->
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            
            <!-- if the subject is being minted as a skos:concept,
             a "has subject" triple is also made using $x, $y, and $z
             and a "has category of work" for $v -->
            <!-- this if checks whether the subject IRI returns a minted IRI or a $0/$1 value.
             If it is a $0/$1 provided IRI, we do not separate out $v, $x, $y, $z -->
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                        <xsl:call-template name="F6XX-xx-xyz"/>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'y']">
                        <xsl:call-template name="F6XX-xx-y">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'z']">
                        <xsl:call-template name="F6XX-xx-z">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <xsl:call-template name="F6XX-xx-v"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
        
        <!-- choose appropriate "has subject [agent]" property based on field/subfields
            and call agentIRI for the object-->
        <xsl:choose>
            <xsl:when test="@tag = '600'">
                <xsl:choose>
                    <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                        <rdawo:P10261 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                    <xsl:when test="@ind1 = '3'">
                        <rdawo:P10262 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <rdawo:P10263 rdf:resource="{uwf:agentIRI(.)}"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- if $t then there is also a subject work -->
        <xsl:if test="marc:subfield[@code = 't']">
            <rdawo:P10257 rdf:resource="{uwf:relWorkIRI(.)}"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="con" expand-text="yes">
        <!-- we only mint a concept if there are qualifier subfields, a source provided, and a minted IRI -->
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:if test="@ind2 != '4'">
                <xsl:variable name="prefLabel">
                    <xsl:choose>
                        <xsl:when test="@tag = '600'">
                            <xsl:call-template name="F600-label"/>
                        </xsl:when>
                        <xsl:when test="@tag = '610'">
                            <xsl:call-template name="F610-label"/>
                        </xsl:when>
                        <xsl:when test="@tag = '611'">
                            <xsl:call-template name="F611-label"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
                <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    </rdf:Description>
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                        and (marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                        <xsl:variable name="prefLabelXYZ">
                            <xsl:call-template name="F6XX-xyz-label"/>
                        </xsl:variable>
                        <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                            <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                        </rdf:Description>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'v']">
                        <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="age">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="source" select="uwf:getSubjectSchemeCode(.)"/>
        <rdf:Description rdf:about="{uwf:agentIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <xsl:when test="@ind2 != '4'">
                                    <xsl:choose>
                                        <xsl:when test="starts-with(uwf:agentIRI(.), $BASE)">
                                            <rdaao:P50411 rdf:resource="{uwf:nomenIRI(., 'age/nom', $ap, $source)}"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <rdaao:P50411 rdf:resource="{uwf:nomenIRI(., 'age/nom', '', '')}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50377>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <xsl:when test="@ind2 != '4'">
                                    <xsl:choose>
                                        <xsl:when test="starts-with(uwf:agentIRI(.), $BASE)">
                                            <rdaao:P50409 rdf:resource="{uwf:nomenIRI(., 'age/nom', $ap, $source)}"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <rdaao:P50409 rdf:resource="{uwf:nomenIRI(., 'age/nom', '', '')}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50376>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@tag = '610' or @tag = '611'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <xsl:choose>
                        <xsl:when test="@ind2 != '4'">
                            <xsl:choose>
                                <xsl:when test="starts-with(uwf:agentIRI(.), $BASE)">
                                    <rdaao:P50407 rdf:resource="{uwf:nomenIRI(., 'age/nom', $ap, $source)}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaao:P50407 rdf:resource="{uwf:nomenIRI(., 'age/nom', '', '')}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdaad:P50375>
                                <xsl:value-of select="$ap"/>
                            </rdaad:P50375>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    
    <xsl:template
        match="marc:datafield[@tag = '600'][marc:subfield[@code = 't']] | marc:datafield[@tag = '610'][marc:subfield[@code = 't']] | marc:datafield[@tag = '611'][marc:subfield[@code = 't']]"
        mode="relWor" expand-text="yes">
        <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <xsl:choose>
                <xsl:when test="@ind2 != '4'">
                    <xsl:choose>
                        <xsl:when test="starts-with(uwf:relWorkIRI(.), $BASE)">
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom', uwf:relWorkAccessPoint(.), uwf:getSubjectSchemeCode(.))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom', '', '')}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@tag = '600' and @ind1 != '3'">
                    <rdawo:P10312 rdf:resource="{uwf:agentIRI(.)}"/>
                </xsl:when>
                <xsl:when test="@tag = '600' and @ind1 = '3'">
                    <rdawo:P10313 rdf:resource="{uwf:agentIRI(.)}"/>
                </xsl:when>
                <xsl:when test="@tag = '610' or @tag = '611'">
                    <rdawo:P10314 rdf:resource="{uwf:agentIRI(.)}"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '600'][marc:subfield[@code = 'y']] | marc:datafield[@tag = '610'][marc:subfield[@code = 'y']] | marc:datafield[@tag = '630'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610'">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611'">
                    <xsl:call-template name="F611-label"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '600'][marc:subfield[@code = 'z']] | marc:datafield[@tag = '610'][marc:subfield[@code = 'z']] | marc:datafield[@tag = '611'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610'">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611'">
                    <xsl:call-template name="F611-label"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:variable name="nomIRI">
            <xsl:choose>
                <xsl:when test="starts-with(uwf:agentIRI(.), $BASE)">
                    <xsl:value-of select="uwf:nomenIRI(., 'age/nom', $ap, $scheme)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="uwf:nomenIRI(., 'age/nom', '', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610'">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611'">
                    <xsl:call-template name="F611-label"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="@ind2 != '4'">
            <rdf:Description rdf:about="{$nomIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$ap"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
      
            <xsl:if test="marc:subfield[@code = 't']">
                <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
                <xsl:variable name="nomIRIWor">
                    <xsl:choose>
                        <xsl:when test="starts-with(uwf:relWorkIRI(.), $BASE)">
                            <xsl:value-of select="uwf:nomenIRI(., 'wor/nom', $apWor, $scheme)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:nomenIRI(., 'wor/nom', '', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <rdf:Description rdf:about="{$nomIRIWor}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="$apWor"/>
                    </rdand:P80068>
                    <xsl:choose>
                        <xsl:when test="@ind2 = '7'">
                            <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:if>
            
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 630 - Subject Added Entry - Uniform Title -->
    <xsl:template
        match="marc:datafield[@tag = '630']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F630-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                       <xsl:call-template name="F6XX-xx-xyz"/>  
                    </xsl:if>  
                    <xsl:for-each select="marc:subfield[@code = 'y']">
                        <xsl:call-template name="F6XX-xx-y">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'z']">
                        <xsl:call-template name="F6XX-xx-z">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <xsl:call-template name="F6XX-xx-v"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
        <rdawo:P10257 rdf:resource="{uwf:relWorkIRI(.)}"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '630']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:if test="@ind2 != '4'">
                <xsl:variable name="prefLabel">
                    <xsl:call-template name="F630-label"/>
                </xsl:variable>
                <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
                <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    </rdf:Description>
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                        and (marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                        <xsl:variable name="prefLabelXYZ">
                            <xsl:call-template name="F6XX-xyz-label"/>
                        </xsl:variable>
                        <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                            <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                        </rdf:Description>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'v']">
                        <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '630']"
        mode="relWor" expand-text="yes">
        <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <xsl:choose>
                <xsl:when test="@ind2 != '4'">
                    <xsl:choose>
                        <xsl:when test="starts-with(uwf:relWorkIRI(.), $BASE)">
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom', uwf:relWorkAccessPoint(.), uwf:getSubjectSchemeCode(.))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom', '', '')}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '630'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F630-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '630'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F630-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '630']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:variable name="nomIRIWor">
                <xsl:choose>
                    <xsl:when test="starts-with(uwf:relWorkIRI(.), $BASE)">
                        <xsl:value-of select="uwf:nomenIRI(., 'wor/nom', $apWor, $scheme)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI(., 'wor/nom', '', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F630-label"/>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomIRIWor}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apWor"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 647 - Subject Added Entry-Named Event -->
    <xsl:template
        match="marc:datafield[@tag = '647']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-xx-xyz"/>
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <xsl:call-template name="F6XX-xx-y">
                    <xsl:with-param name="prefLabel" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <xsl:call-template name="F6XX-xx-z">
                    <xsl:with-param name="prefLabel" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'v']">
            <xsl:call-template name="F6XX-xx-v"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '647']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F647-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                    and (marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '647'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '647'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '647']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F647-label"/>
            </xsl:variable>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 648 - Subject Added Entry-Chronological Term -->
    <xsl:template
        match="marc:datafield[@tag = '648']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                        <xsl:call-template name="F6XX-xx-xyz"/>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'y']">
                        <xsl:call-template name="F6XX-xx-y">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'z']">
                        <xsl:call-template name="F6XX-xx-z">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <xsl:call-template name="F6XX-xx-v"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10322 rdf:resource="{uwf:timespanIRI(., marc:subfield[@code = 'a'])}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '648']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F648-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                    and (marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '648']"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:timespanIRI(., marc:subfield[@code = 'a'])}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                <xsl:choose>
                    <xsl:when test="@ind2 != '4'">
                        <xsl:choose>
                            <xsl:when test="starts-with(uwf:relWorkIRI(.), $BASE)">
                                <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', marc:subfield[@code = 'a'], $scheme)}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', '', '')}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdatd:P70015>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdatd:P70015>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="."/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '648'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '648']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F648-label"/>
            </xsl:variable> 
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:variable name="nomIRI">
                <xsl:choose>
                    <xsl:when test="starts-with(uwf:timespanIRI(., marc:subfield[@code = 'a']), $BASE)">
                        <xsl:value-of select="uwf:nomenIRI(., 'tim/nom', marc:subfield[@code = 'a'], $scheme)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI(., 'tim/nom', '', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 650 - Subject Added Entry - Topical Term -->
    
    <xsl:template
        match="marc:datafield[@tag = '650']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                     <xsl:call-template name="F6XX-xx-xyz"/>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <xsl:call-template name="F6XX-xx-y">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <xsl:call-template name="F6XX-xx-z">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '650']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F650-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                 <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                     <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                 </rdf:Description>
                 <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                     and (marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                     <xsl:variable name="prefLabelXYZ">
                         <xsl:call-template name="F6XX-xyz-label"/>
                     </xsl:variable>
                     <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                         <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                     </rdf:Description>
                 </xsl:if>
                 <xsl:for-each select="marc:subfield[@code = 'v']">
                     <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                         <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                     </rdf:Description>
                 </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '650'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '650'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '650']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F650-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 651 - Subject Added Entry - Geographic Name -->
    
    <xsl:template
        match="marc:datafield[@tag = '651']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                             <xsl:call-template name="F6XX-xx-xyz"/>
                    </xsl:if>
                    <xsl:for-each select="marc:subfield[@code = 'y']">
                        <xsl:call-template name="F6XX-xx-y">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'z']">
                        <xsl:call-template name="F6XX-xx-z">
                            <xsl:with-param name="prefLabel" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <xsl:call-template name="F6XX-xx-v"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10321 rdf:resource="{uwf:placeIRI(., marc:subfield[@code = 'a'], uwf:getSubjectSchemeCode(.))}"/>    
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '651']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F651-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                    and (marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '651'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '651']"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:placeIRI(.,  marc:subfield[@code = 'a'], $scheme)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', marc:subfield[@code = 'a'], $scheme)}"/>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '4'">
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '651']"
        mode="nom" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:variable name="nomIRI">
            <xsl:choose>
                <xsl:when test="starts-with(uwf:placeIRI(., marc:subfield[@code = 'a'], $scheme), $BASE)">
                    <xsl:value-of select="uwf:nomenIRI(., 'pla/nom', marc:subfield[@code = 'a'], $scheme)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="uwf:nomenIRI(., 'pla/nom', '', '')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description rdf:about="{$nomIRI}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            <rdand:P80068>
                <xsl:value-of select="uwf:stripEndPunctuation(marc:subfield[@code = 'a'])"/>
            </rdand:P80068>
            <xsl:choose>
                <xsl:when test="@ind2 = '7'">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                    </rdand:P80068>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '7'">
                            <xsl:choose>
                                <xsl:when test="../marc:subfield[@code = '2']">
                                    <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                    </rdand:P80068>
                    <xsl:choose>
                        <xsl:when test="../@ind2 = '7'">
                            <xsl:choose>
                                <xsl:when test="../marc:subfield[@code = '2']">
                                    <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(../@ind2)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 653 - Index Term - Uncontrolled -->
    <xsl:template
        match="marc:datafield[@tag = '653']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F653-label"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@ind2 = '1'">
                <rdawd:P10261>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10261>
            </xsl:when>
            <xsl:when test="@ind2 = '2' or @ind2 = '3'">
                <rdawd:P10263>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10263>
            </xsl:when>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10322>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10322>
            </xsl:when>
            <xsl:when test="@ind2 = '5'">
                <rdawd:P10321>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10321>
            </xsl:when>
            <xsl:when test="@ind2 = '6'">
                <rdawd:P10004>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10004>
            </xsl:when>
            <xsl:otherwise>
                <rdawd:P10256>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10256>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 654 - Subject Added Entry - Faceted Topical Terms-->
    
    <xsl:template
        match="marc:datafield[@tag = '654']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F654-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                    <xsl:call-template name="F6XX-xx-xyz"/>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <xsl:call-template name="F6XX-xx-y">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <xsl:call-template name="F6XX-xx-z">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '654']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F654-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                    and (marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '654'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F654-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="$scheme">
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '654'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F654-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="$scheme">
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '654']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F654-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 655 - Index Term-Genre/Form-->
    
    <xsl:template
        match="marc:datafield[@tag = '655']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F655-label"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10004>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10004>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10004 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '655']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F655-label"/>
        </xsl:variable>
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 656 - Index Term - Occupation-->
    
    <xsl:template
        match="marc:datafield[@tag = '656']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F656-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:if test="marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1">
                    <xsl:call-template name="F6XX-xx-xyz"/>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <xsl:call-template name="F6XX-xx-y">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <xsl:call-template name="F6XX-xx-z">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '656']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F656-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']
                    and (marc:subfield[@code = 'x'] or count(marc:subfield[@code = 'x' or @code = 'y' or @code = 'z']) gt 1)">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '656'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F656-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'y']">
                <rdf:Description rdf:about="{uwf:yTimespanIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                        <xsl:when test="$scheme">
                            <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdatd:P70015>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdatd:P70015>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '656'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F656-label"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
            <xsl:for-each select="marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:zPlaceIRI(.., ., .)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <xsl:choose>
                        <xsl:when test="$scheme">
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapd:P70018>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdapd:P70018>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '656']"
        mode="nom" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F656-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom', ., $scheme)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 657 -  Index Term - Function -->
    
    <xsl:template
        match="marc:datafield[@tag = '657']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F657-label"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(marc:subfield[@code = '2'])">
                <rdawd:P10004>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10004>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10004 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '657']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F657-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    
    <!-- 658 -  Index Term - Curriculum Objective -->
    
    <xsl:template
        match="marc:datafield[@tag = '658']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F658-label"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(marc:subfield[@code = '2'])">
                <rdawd:P10004>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10004>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10004 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '658']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F658-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 662 - Subject Added Entry - Hierarchical Place Name-->
    
    <xsl:template
        match="marc:datafield[@tag = '662']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F662-label"/>
        </xsl:variable>
        <rdawo:P10321 rdf:resource="{uwf:placeIRI(., $prefLabel, marc:subfield[@code = '2'])}"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '662']"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F662-label"/>
        </xsl:variable>
        <rdf:Description rdf:about="{uwf:placeIRI(., $prefLabel, marc:subfield[@code = '2'])}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2']">
                    <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom', $prefLabel, marc:subfield[@code = '2'])}"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="not(starts-with(uwf:placeIRI(., $prefLabel, ''), $BASE))">
                            <rdapd:P70045>
                                <xsl:value-of select="$prefLabel"/>
                            </rdapd:P70045>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapd:P70018>
                                <xsl:value-of select="$prefLabel"/>
                            </rdapd:P70018>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '662']"
        mode="nom" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F662-label"/>
            </xsl:variable>
            <xsl:variable name="nomIRI">
                <xsl:choose>
                    <xsl:when test="starts-with(uwf:subjectIRI(., marc:subfield[@code = '2'], $prefLabel), $BASE)">
                        <xsl:value-of select="uwf:nomenIRI(., 'pla/nom', $prefLabel, marc:subfield[@code = '2'])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI(., 'pla/nom', '', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomIRI}">
                <rdf:type rdf:resource="httsp://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$prefLabel"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 688 - Subject Added Entry - Type of Entity Unspecified -->
    <xsl:template
        match="marc:datafield[@tag = '688']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F688-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '688']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F688-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
   
</xsl:stylesheet>

