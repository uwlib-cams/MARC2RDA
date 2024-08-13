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
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
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
        <xsl:if test="marc:subfield[@code = 't']">
            <rdawo:P10257 rdf:resource="{uwf:relWorkIRI(.)}"/>
        </xsl:if>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:call-template name="F6XX-xx-xyz"/>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="con" expand-text="yes">
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
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                        <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="age">
        <xsl:param name="baseIRI"/>
            <rdf:Description rdf:about="{uwf:agentIRI(.)}">
                <xsl:call-template name="getmarc"/>
                <xsl:choose>
                    <xsl:when test="@tag = '600'">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                                <xsl:choose>
                                    <xsl:when test="marc:subfield[@code = '2'] or @ind2 != '4'">
                                        <rdaao:P50411 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <rdaad:P50377>
                                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                        </rdaad:P50377>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@ind1 = '3'">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                                <xsl:choose>
                                    <xsl:when test="marc:subfield[@code = '2'] or @ind2 != '4'">
                                        <rdaao:P50409 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <rdaad:P50376>
                                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
                            <xsl:when test="marc:subfield[@code = '2'] or @ind2 != '4'">
                                <rdaao:P50407 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdaad:P50375>
                                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                </rdaad:P50375>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="(marc:subfield[@code = '2'] | @ind2 != '4')">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'age/nom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 't'] and (marc:subfield[@code = '2'] | @ind2 != '4')">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'wor/nom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'][marc:subfield[@code = 't']] | marc:datafield[@tag = '610'][marc:subfield[@code = 't']] | marc:datafield[@tag = '611'][marc:subfield[@code = 't']]"
        mode="relWor" expand-text="yes">
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
                <xsl:call-template name="getmarc"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] or @ind2 != '4'">
                        <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom')}"/>
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
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <rdawo:P10257 rdf:resource="{uwf:relWorkIRI(.)}"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:call-template name="F6XX-xx-xyz"/>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '630']"
        mode="relWor" expand-text="yes">
        <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2'] or @ind2 != '4'">
                    <rdawo:P10331 rdf:resource="{uwf:nomenIRI(., 'wor/nom')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '630']"
        mode="nom" expand-text="yes">
        <xsl:if test="(marc:subfield[@code = '2'] | @ind2 != '4')">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'wor/nom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '630']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F630-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')"> 
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                        <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
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
        <!--<xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
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
        </xsl:if>-->
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '647']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                </rdf:Description>
                <!--<xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                        <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>-->
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <!--<xsl:template match="marc:datafield[@tag = '647'][marc:subfield[@code = 'y']]"
        mode="tim">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:timespanIRI(.)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                        <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom')}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>-->
    <!--<xsl:template match="marc:datafield[@tag = '647'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:placeIRI(.)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                        <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom')}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>-->
    <!--<xsl:template
        match="marc:datafield[@tag = '647']"
        mode="nom" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')"> 
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="."/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'])"/>
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
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="."/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'])"/>
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
    </xsl:template>-->
    
    <!-- 648 - Subject Added Entry-Chronological Term -->
    <xsl:template
        match="marc:datafield[@tag = '648']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10322>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdawd:P10322>
            </xsl:when>
            <xsl:otherwise>
                <rdawo:P10322 rdf:resource="{uwf:timespanIRI(.)}"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:call-template name="F6XX-xx-xyz"/>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '648']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                        <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
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
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:timespanIRI(.)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom')}"/>
                </rdf:Description>
            </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '648']"
        mode="nom" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable> 
        <xsl:if test="@ind2 != '4'">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@ind2 = '7'">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
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
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
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
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '650']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
             <xsl:if test="@ind2 != '4'">
                 <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                     <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                 </rdf:Description>
                 <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                     <xsl:variable name="prefLabelXYZ">
                         <xsl:call-template name="F6XX-xyz-label"/>
                     </xsl:variable>
                     <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                         <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                     </rdf:Description>
                 </xsl:if>
                 <xsl:for-each select="marc:subfield[@code = 'v']">
                     <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                         <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
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
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:timespanIRI(.)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                        <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom')}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '650'][marc:subfield[@code = 'z']]"
        mode="pla">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'z']">
                    <rdf:Description rdf:about="{uwf:placeIRI(.)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                        <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom')}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '650']"
        mode="nom" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')"> 
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="."/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'])"/>
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
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                        <rdand:P80068>
                            <xsl:value-of select="."/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'])"/>
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
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:choose>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10321>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdawd:P10321>
            </xsl:when>
            <xsl:otherwise>
                <rdawo:P10321 rdf:resource="{uwf:placeIRI(.)}"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">   
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:call-template name="F6XX-xx-xyz"/>
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <xsl:call-template name="F6XX-xx-y">
                        <xsl:with-param name="prefLabel" select="."/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '651']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                </rdf:Description>
                <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                    <xsl:variable name="prefLabelXYZ">
                        <xsl:call-template name="F6XX-xyz-label"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                        <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', @tag)"/>
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
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:timespanIRI(.)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                        <rdato:P70047 rdf:resource="{uwf:nomenIRI(., 'tim/nom')}"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '651']"
        mode="pla">
        <xsl:if test="@ind2 != '4'">
            <rdf:Description rdf:about="{uwf:placeIRI(.)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                <rdapo:P70045 rdf:resource="{uwf:nomenIRI(., 'pla/nom')}"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '651']"
        mode="nom" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <rdf:Description rdf:about="{uwf:nomenIRI(., 'pla/nom')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            <rdand:P80068>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdand:P80068>
            <xsl:choose>
                <xsl:when test="@ind2 = '7'">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdan:P80069 rdf:resource="{uwf:ind2Thesaurus(@ind2)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')"> 
            <xsl:if test="@ind2 != '4'">
                <xsl:for-each select="marc:subfield[@code = 'y']">
                    <rdf:Description rdf:about="{uwf:nomenIRI(., 'tim/nom')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>
                            <xsl:value-of select="."/>
                        </rdand:P80068>
                        <xsl:choose>
                            <xsl:when test="@ind2 = '7'">
                                <xsl:choose>
                                    <xsl:when test="../marc:subfield[@code = '2']">
                                        <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'])"/>
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
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '654']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F654-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
                <xsl:if test="@ind2 != '4'">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
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
        <xsl:if test="starts-with(uwf:subjectIRI(., marc:subfield[@code = '2'], $prefLabel), 'http://marc2rda.edu')">
            <xsl:if test="@ind2 != '4'">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
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
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '656']"
        mode="con" expand-text="yes">
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F656-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
                <xsl:if test="@ind2 != '4'">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
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
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F657-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:if test="starts-with(uwf:subjectIRI(., marc:subfield[@code = '2'], $prefLabel), 'http://marc2rda.edu')">
                <xsl:if test="@ind2 != '4'">
                    <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', @tag)"/>
                    </rdf:Description>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

