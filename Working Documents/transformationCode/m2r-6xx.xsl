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
    <!-- 600, 610, 611-->
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '600-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '610-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '611-00']"
        mode="wor">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <!-- store subject heading label in variable -->
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '610'))">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '611'))">
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
            <!-- if there is a linked 880 and no source, these are also output as string values -->
            <xsl:if test="starts-with(@tag, '6') and @ind2 = '4' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:variable name="prefLabel880">
                        <xsl:choose>
                            <xsl:when test="starts-with(marc:subfield[@code = '6'], '600')">
                                <xsl:call-template name="F600-label"/>
                            </xsl:when>
                            <xsl:when test="starts-with(marc:subfield[@code = '6'], '610')">
                                <xsl:call-template name="F610-label"/>
                            </xsl:when>
                            <xsl:when test="starts-with(marc:subfield[@code = '6'], '611')">
                                <xsl:call-template name="F611-label"/>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="F6XX-subject">
                        <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <!-- $v is mapped separately as well -->
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
        
        <!-- choose appropriate "has subject [agent]" property based on field/subfields
            and call agentIRI for the object-->
        <xsl:choose>
            <xsl:when test="@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))">
                <xsl:choose>
                    <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                        <rdawo:P10261 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                    </xsl:when>
                    <xsl:when test="@ind1 = '3'">
                        <rdawo:P10262 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <rdawo:P10263 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- if $t then there is also a subject work -->
        <xsl:if test="marc:subfield[@code = 't']">
            <rdawo:P10257 rdf:resource="{uwf:relWorkIRI($baseIRI, .)}"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '600-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '610-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '611-00']"
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
                    <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                        <!-- if there are linked 880s, these are inclued -->
                        <xsl:if test="starts-with(@tag, '6') and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <xsl:variable name="prefLabel880">
                                    <xsl:choose>
                                        <xsl:when test="starts-with(marc:subfield[@code = '6'], '600')">
                                            <xsl:call-template name="F600-label"/>
                                        </xsl:when>
                                        <xsl:when test="starts-with(marc:subfield[@code = '6'], '610')">
                                            <xsl:call-template name="F610-label"/>
                                        </xsl:when>
                                        <xsl:when test="starts-with(marc:subfield[@code = '6'], '611')">
                                            <xsl:call-template name="F611-label"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                            </xsl:for-each>
                        </xsl:if>
                    </rdf:Description>
                </xsl:if>
                <!-- concept for $v -->
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '600-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '610-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '611-00']"
        mode="age">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="source" select="uwf:getSubjectSchemeCode(.)"/>
        <rdf:Description rdf:about="{uwf:agentIRI($baseIRI, .)}">
            <xsl:call-template name="getmarc"/>
            <xsl:choose>
                <xsl:when test="@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <xsl:when test="@ind2 != '4'">
                                    <xsl:choose>
                                        <xsl:when test="uwf:s2EntityTest($source, 'Person') = 'True'">
                                            <rdaao:P50411 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50377>
                                    <xsl:if test="starts-with(@tag, '6') and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each
                                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50377>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                            </rdaad:P50377>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <xsl:when test="@ind2 != '4'">
                                    <xsl:choose>
                                        <xsl:when test="uwf:s2EntityTest($source, 'Family') = 'True'">
                                            <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50376>
                                    <xsl:if test="starts-with(@tag, '6') and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each
                                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50376>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                            </rdaad:P50376>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@tag = '610' or @tag = '611' 
                    or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '610'))
                    or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '611'))">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <xsl:choose>
                        <xsl:when test="@ind2 != '4'">
                            <xsl:choose>
                                <xsl:when test="uwf:s2EntityTest($source, 'Corporate Body') = 'True'">
                                    <rdaao:P50407 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaao:P50375 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdaad:P50375>
                                <xsl:value-of select="$ap"/>
                            </rdaad:P50375>
                            <xsl:if test="starts-with(@tag, '6') and marc:subfield[@code = '6']">
                                <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                <xsl:for-each
                                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                    <rdaad:P50375>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50375>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="not(marc:subfield[@code = 'v']) and not(marc:subfield[@code = 'x'])
                and not(marc:subfield[@code = 'y']) and not(marc:subfield[@code = 'z'])">
                <xsl:copy-of select="uwf:agentIdentifiers(.)"/>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'][marc:subfield[@code = 't']] | marc:datafield[@tag = '610'][marc:subfield[@code = 't']] | marc:datafield[@tag = '611'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '600-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '610-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '611-00'][marc:subfield[@code = 't']]"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="source" select="uwf:getSubjectSchemeCode(.)"/>
        <rdf:Description rdf:about="{uwf:relWorkIRI($baseIRI, .)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <xsl:choose>
                <xsl:when test="@ind2 != '4'">
                    <xsl:choose>
                        <xsl:when test="uwf:s2EntityTest($source, 'Work') = 'True'">
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdawo:P10328 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                    <xsl:if test="starts-with(@tag, '6') and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdawd:P10328>
                                <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                            </rdawd:P10328>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="(@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))) and @ind1 != '3'">
                    <rdawo:P10312 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                </xsl:when>
                <xsl:when test="(@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))) and @ind1 = '3'">
                    <rdawo:P10313 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                </xsl:when>
                <xsl:when test="@tag = '610' or @tag = '611'
                    or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '610'))
                    or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '610'))">
                    <rdawo:P10314 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:if test="not(marc:subfield[@code = 'v']) and not(marc:subfield[@code = 'x'])
                and not(marc:subfield[@code = 'y']) and not(marc:subfield[@code = 'z'])">
                <xsl:copy-of select="uwf:workIdentifiers(.)"/>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '600-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '610-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '611-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="(@tag = '600')
                    and @ind1 != '3'">
                    <xsl:value-of select="'Person'"/>
                </xsl:when>
                <xsl:when test="(@tag = '600')
                    and @ind1 = '3'">
                    <xsl:value-of select="'Family'"/>
                </xsl:when>
                <xsl:when test="@tag = '610'or @tag = '611'">
                    <xsl:value-of select="'Corporate Body'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefLabel">
            <xsl:choose>
                <xsl:when test="@tag = '600' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '600'))">
                    <xsl:call-template name="F600-label"/>
                </xsl:when>
                <xsl:when test="@tag = '610' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '610'))">
                    <xsl:call-template name="F610-label"/>
                </xsl:when>
                <xsl:when test="@tag = '611' or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '611'))">
                    <xsl:call-template name="F611-label"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="@ind2 != '4'">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'ageNom')}">
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
                <xsl:if test="marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
            
            <xsl:if test="marc:subfield[@code = 't']">
                <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
                <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'worNom')}">
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
                    <xsl:if test="marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdand:P80113>
                                <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                            </rdand:P80113>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 630 - Subject Added Entry - Uniform Title -->
    <xsl:template
        match="marc:datafield[@tag = '630'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '630-00']"
        mode="wor">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F630-label"/>
        </xsl:variable>
        <!-- has subject work -->
        <rdawo:P10257 rdf:resource="{uwf:relWorkIRI($baseIRI, .)}"/>
        <!-- if v, x, y, or z, also use has subject -->
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="@tag = '630' and @ind2 = '4' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="concat('630-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:variable name="prefLabel880">
                        <xsl:call-template name="F630-label"/>
                    </xsl:variable>
                    <xsl:call-template name="F6XX-subject">
                        <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <!-- category of work for v -->
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '630'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '630-00']"
        mode="con" expand-text="yes">
        <!-- if v, x, y, z and source is provided, mint a concept -->
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:if test="@ind2 != '4'">
                <xsl:variable name="prefLabel">
                    <xsl:call-template name="F630-label"/>
                </xsl:variable>
                <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
                <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)"> 
                    <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                        <xsl:if test="@tag = '630' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum"
                                select="concat('630-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <xsl:variable name="prefLabel880">
                                    <xsl:call-template name="F647-label"/>
                                </xsl:variable>
                                <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                            </xsl:for-each>
                        </xsl:if>
                    </rdf:Description>
                    <!-- also mint a concept for each $v -->
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
        match="marc:datafield[@tag = '630'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '630-00']"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <!-- mint the work -->
        <rdf:Description rdf:about="{uwf:relWorkIRI($baseIRI, .)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <xsl:choose>
                <!-- if there is a source, mint a nomen -->
                <xsl:when test="@ind2 != '4'">
                    <xsl:choose>
                        <!-- if an approved source, it is an authorized access point -->
                        <xsl:when test="uwf:s2EntityTest(uwf:getSubjectSchemeCode(.), 'Work') = 'True'">
                            <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                        </xsl:when>
                        <!-- otherwise just an access point -->
                        <xsl:otherwise>
                            <rdawo:P10328 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- if no source, just a string value as an access point -->
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                    <xsl:if test="@tag = '630' and @ind2 = '4' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat('630-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdawd:P10328>
                                <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                            </rdawd:P10328>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <!-- if $0s and $1s are for the work (no v, x, y, z) - add the unapproved $0 and $1 values as identifiers -->
            <xsl:if test="not(marc:subfield[@code = 'v']) and not(marc:subfield[@code = 'x'])
                and not(marc:subfield[@code = 'y']) and not(marc:subfield[@code = 'z'])">
                <xsl:copy-of select="uwf:workIdentifiers(.)"/>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '630'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '630-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <!-- if there is a source, mint a nomen -->
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F630-label"/>
            </xsl:variable>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'worNom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apWor"/>
                </rdand:P80068>
                <xsl:if test="@tag = '630' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat('630-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
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
    </xsl:template>
    
    <!-- 647 - Subject Added Entry-Named Event -->
    <xsl:template
        match="marc:datafield[@tag = '647'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '647-00']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F647-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="@tag = '647' and @ind2 = '4' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="concat('647-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:variable name="prefLabel880">
                    <xsl:call-template name="F647-label"/>
                </xsl:variable>
                <xsl:call-template name="F6XX-subject">
                    <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'v']">
            <xsl:call-template name="F6XX-xx-v"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '647'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '647-00']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F647-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    <xsl:if test="@tag = '647' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('647-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:variable name="prefLabel880">
                                <xsl:call-template name="F647-label"/>
                            </xsl:variable>
                            <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 648 - Subject Added Entry-Chronological Term -->
    <xsl:template
        match="marc:datafield[@tag = '648'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '648-00']"
        mode="wor">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F648-label"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="@tag = '648' and @ind2 = '4' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="concat('648-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:variable name="prefLabel880">
                        <xsl:call-template name="F648-label"/>
                    </xsl:variable>
                    <xsl:call-template name="F6XX-subject">
                        <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10322 rdf:resource="{uwf:timespanIRI($baseIRI, ., marc:subfield[@code = 'a'])}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '648'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '648-00']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F648-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    <xsl:if test="@tag = '648' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('648-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:variable name="prefLabel880">
                                <xsl:call-template name="F648-label"/>
                            </xsl:variable>
                            <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '648'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '648-00']"
        mode="tim">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:timespanIRI($baseIRI, ., marc:subfield[@code = 'a'])}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                <xsl:choose>
                    <xsl:when test="@ind2 != '4'">
                        <xsl:choose>
                            <xsl:when test="uwf:s2EntityTest(uwf:getSubjectSchemeCode(.), 'Timespan') = 'True'">
                                <rdato:P70047 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'timNom')}"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <rdato:P70015 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'timNom')}"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdatd:P70015>
                            <xsl:value-of select="uwf:stripEndPunctuation(marc:subfield[@code = 'a'])"/>
                        </rdatd:P70015>
                        <xsl:if test="@tag = '648' and @ind2 = '4' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum" select="concat('648-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <rdatd:P70015>
                                    <xsl:value-of select="uwf:stripEndPunctuation(marc:subfield[@code = 'a'])"/>
                                </rdatd:P70015>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <!-- if $0s and $1s are for the timespan (no v, x, y, z) - add the unapproved $0 and $1 values as identifiers -->
                <xsl:if test="not(marc:subfield[@code = 'v']) and not(marc:subfield[@code = 'x'])
                    and not(marc:subfield[@code = 'y']) and not(marc:subfield[@code = 'z'])">
                    <xsl:copy-of select="uwf:timespanIdentifiers(.)"/>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '648'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '648-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F648-label"/>
            </xsl:variable> 
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'timNom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:stripEndPunctuation(marc:subfield[@code = 'a'])"/>
                </rdand:P80068>
                <xsl:if test="@tag = '648' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat('648-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:stripEndPunctuation(marc:subfield[@code = 'a'])"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
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
        </xsl:if>
    </xsl:template>
    
    <!-- 650 - Subject Added Entry - Topical Term -->
    
    <xsl:template
        match="marc:datafield[@tag = '650'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '650-00']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <!-- 650 label combines subfields separated by dashes -->
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F650-label"/>
        </xsl:variable>
        <!-- F6XX-subject template outputs work to subject relationship -->
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <!-- for linked 880s, when ind2 is 4 (no source), it also outputs a subject triple for that -->
        <xsl:if test="@tag = '650' and @ind2 = '4' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="concat('650-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:variable name="prefLabel880">
                    <xsl:call-template name="F650-label"/>
                </xsl:variable>
                <xsl:call-template name="F6XX-subject">
                    <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <!-- uwf:subjectIRI returns an IRI if $1 or $0 is valid, otherwise mints one starting with the provided BASE iri -->
        <!-- this if test checks whether the IRI used is one we minted or not -->
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '650'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '650-00']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F650-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    <xsl:if test="@tag = '650' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('650-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:variable name="prefLabel880">
                                <xsl:call-template name="F650-label"/>
                            </xsl:variable>
                            <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                        </xsl:for-each>
                    </xsl:if>
                 </rdf:Description>
                 <xsl:for-each select="marc:subfield[@code = 'v']">
                     <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                         <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                     </rdf:Description>
                 </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 651 - Subject Added Entry - Geographic Name -->
    
    <xsl:template
        match="marc:datafield[@tag = '651'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '651-00']"
        mode="wor" expand-text='yes'>
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <!-- subject place -->
        <xsl:variable name="ap">
            <xsl:variable name="placename">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'g']">
                        <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="uwf:stripEndPunctuation($placename)"/>
        </xsl:variable>
        <rdawo:P10321 rdf:resource="{uwf:placeIRI($baseIRI, ., $ap, uwf:getSubjectSchemeCode(.))}"/>   
        <!-- subject if v, x, y, z -->
        <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
            or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
            <xsl:call-template name="F6XX-subject">
                <xsl:with-param name="prefLabel" select="$prefLabel"/>
            </xsl:call-template>
            <xsl:if test="@tag = '651' and @ind2 = '4' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="concat('651-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:variable name="prefLabel880">
                        <xsl:call-template name="F651-label"/>
                    </xsl:variable>
                    <xsl:call-template name="F6XX-subject">
                        <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <xsl:call-template name="F6XX-xx-v"/>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '651'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '651-00']"
        mode="con" expand-text="yes">
        <xsl:if test="@ind2 != '4'">
            <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] 
                or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:variable name="prefLabel">
                    <xsl:call-template name="F651-label"/>
                </xsl:variable>
                <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
                <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                    <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                        <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                        <xsl:if test="@tag = '651' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum"
                                select="concat('651-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <xsl:variable name="prefLabel880">
                                    <xsl:call-template name="F651-label"/>
                                </xsl:variable>
                                <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                            </xsl:for-each>
                        </xsl:if>
                    </rdf:Description>
                    <xsl:for-each select="marc:subfield[@code = 'v']">
                        <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                            <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '651'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '651-00']"
        mode="pla" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F651-label"/>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:variable name="placename">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'g']">
                        <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="uwf:stripEndPunctuation($placename)"/>
        </xsl:variable>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <rdf:Description rdf:about="{uwf:placeIRI($baseIRI, .,  $ap, $scheme)}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
            <xsl:choose>
                <xsl:when test="@ind2 != '4'">
                    <xsl:choose>
                        <xsl:when test="uwf:s2EntityTest($scheme, 'Place') = 'True'">
                            <rdapo:P70045 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'plaNom')}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapo:P70018 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'plaNom')}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdapd:P70018>
                        <xsl:value-of select="$ap"/>
                    </rdapd:P70018>
                    <xsl:if test="@tag = '651' and @ind2 = '4' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat('651-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:variable name="ap880">
                                <xsl:variable name="placename880">
                                    <xsl:choose>
                                        <xsl:when test="marc:subfield[@code = 'g']">
                                            <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:value-of select="uwf:stripEndPunctuation($placename880)"/>
                            </xsl:variable>
                            <rdapd:P70018>
                                <xsl:value-of select="$ap880"/>
                            </rdapd:P70018>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '651'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '651-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
        <xsl:variable name="ap">
            <xsl:variable name="placename">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'g']">
                        <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:value-of select="uwf:stripEndPunctuation($placename)"/>
        </xsl:variable>
        <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, ., 'plaNom')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            <rdand:P80068>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </rdand:P80068>
            <xsl:if test="@tag = '651' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="concat('651-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <rdand:P80113>
                        <xsl:variable name="ap880">
                            <xsl:variable name="placename880">
                                <xsl:choose>
                                    <xsl:when test="marc:subfield[@code = 'g']">
                                        <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="uwf:stripEndPunctuation($placename880)"/>
                        </xsl:variable>
                        <xsl:value-of select="$ap880"/>
                    </rdand:P80113>
                </xsl:for-each>
            </xsl:if>
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
    </xsl:template>

    <!-- 653 - Index Term - Uncontrolled -->
    <xsl:template
        match="marc:datafield[@tag = '653'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '653']"
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
        match="marc:datafield[@tag = '654'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '654-00']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F654-label"/>
        </xsl:variable>
        <xsl:call-template name="F6XX-subject">
            <xsl:with-param name="prefLabel" select="$prefLabel"/>
        </xsl:call-template>
        <xsl:if test="@tag = '654' and not(marc:subfield[@code = '2']) and marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="concat('654-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:variable name="prefLabel880">
                    <xsl:call-template name="F654-label"/>
                </xsl:variable>
                <xsl:call-template name="F6XX-subject">
                    <xsl:with-param name="prefLabel" select="$prefLabel880"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), $BASE)">   
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <xsl:call-template name="F6XX-xx-v"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '654'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '654-00']"
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F654-label"/>
            </xsl:variable>
            <xsl:variable name="scheme" select="uwf:getSubjectSchemeCode(.)"/>
            <xsl:if test="starts-with(uwf:subjectIRI(., $scheme, $prefLabel), $BASE)">
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                    <xsl:if test="@tag = '654' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('654-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:variable name="prefLabel880">
                                <xsl:call-template name="F654-label"/>
                            </xsl:variable>
                            <xsl:copy-of select="uwf:fillConcept($prefLabel880, '', '', @tag)"/>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
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
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
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
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
                <xsl:for-each select="marc:subfield[@code = 'v']">
                    <rdf:Description rdf:about="{uwf:conceptIRI($scheme, .)}">
                        <xsl:copy-of select="uwf:fillConcept(., $scheme, '', @tag)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 657 -  Index Term - Function -->
    
    <xsl:template
        match="marc:datafield[@tag = '657']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F657-label"/>
        </xsl:variable>
        <rdawd:P10330>
            <xsl:text>Function: {$prefLabel}</xsl:text>
            <xsl:if test="marc:subfield[@code = '0' or @code = '1']">
                <xsl:text>; </xsl:text>
                <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                    <xsl:if test="@code = '0'">
                        <xsl:text>Authority record control number or standard number: {.}</xsl:text>
                    </xsl:if>   
                    <xsl:if test="@code = '1'">
                        <xsl:text>Real World Object URI: {.}</xsl:text>
                    </xsl:if>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:text> (Source: {marc:subfield[@code = '2']})</xsl:text>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
            </xsl:if>
        </rdawd:P10330>
    </xsl:template>
    
    
    <!-- 658 -  Index Term - Curriculum Objective -->
    
    <xsl:template
        match="marc:datafield[@tag = '658']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                | marc:subfield[@code = 'd'] | marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                <xsl:if test="@code = 'a'">
                    <xsl:text>Main curriculum objective: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'b'">
                    <xsl:text>Subordinate curriculum objective: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'c'">
                    <xsl:text>Curriculum code: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'd'">
                    <xsl:text>Correlation factor: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '0'">
                    <xsl:text>Authority record control number or standard number: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '1'">
                    <xsl:text>Real World Object URI: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:text> (Source: {marc:subfield[@code = '2']})</xsl:text>
            </xsl:if>
        </rdawd:P10330>
    </xsl:template>
    
    
    <!-- 662 - Subject Added Entry - Hierarchical Place Name-->
    
    <xsl:template
        match="marc:datafield[@tag = '662']"
        mode="wor">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F662-label"/>
        </xsl:variable>
        <rdawo:P10321 rdf:resource="{uwf:placeIRI($baseIRI, ., $prefLabel, marc:subfield[@code = '2'])}"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '662']"
        mode="pla">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="prefLabel">
            <xsl:call-template name="F662-label"/>
        </xsl:variable>
        <rdf:Description rdf:about="{uwf:placeIRI($baseIRI, ., $prefLabel, marc:subfield[@code = '2'])}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2']">
                    <rdapo:P70045 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'plaNom')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="not(starts-with(uwf:placeIRI($baseIRI, ., $prefLabel, ''), $BASE))">
                            <rdapd:P70045>
                                <xsl:value-of select="$prefLabel"/>
                            </rdapd:P70045>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdapd:P70018>
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
        <xsl:param name="baseIRI"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="prefLabel">
                <xsl:call-template name="F662-label"/>
            </xsl:variable>
            <xsl:variable name="nomIRI">
                <xsl:choose>
                    <xsl:when test="starts-with(uwf:subjectIRI(., marc:subfield[@code = '2'], $prefLabel), $BASE)">
                        <xsl:value-of select="uwf:nomenIRI($baseIRI, ., 'plaNom')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseIRI, ., 'plaNom')"/>
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
                <rdf:Description rdf:about="{uwf:subjectIRI(., $scheme, $prefLabel)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabel, $scheme, '', @tag)"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
    </xsl:template>
   
</xsl:stylesheet>

