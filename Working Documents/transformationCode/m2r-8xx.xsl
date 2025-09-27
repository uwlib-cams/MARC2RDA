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
    xmlns:m2r="http://marc2rda.info/functions#"
    exclude-result-prefixes="marc m2r" version="3.0">
    
    <!-- Template: Main work to related work relationship -->
    <!-- 800, 810, 811 -->
    <xsl:template match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']] | marc:datafield[@tag = '810'][marc:subfield[@code = 't']]  | marc:datafield[@tag = '811'][marc:subfield[@code = 't']] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '810-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '811-00'][marc:subfield[@code = 't']]" 
        mode="wor">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawo:P10102 rdf:resource="{m2r:relWorkIRI($baseID, .)}"/>
    </xsl:template>    
    
    <!-- Template: Here is the related work -->
    <xsl:template
        match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']] | marc:datafield[@tag = '810'][marc:subfield[@code = 't']]  | marc:datafield[@tag = '811'][marc:subfield[@code = 't']] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '810-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '811-00'][marc:subfield[@code = 't']]" 
        mode="relWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="m2r:tagType(.)"/>
        <xsl:variable name="workIRI" select="m2r:relWorkIRI($baseID, .)"/>
        <rdf:Description rdf:about="{$workIRI}">    
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                    <rdawo:P10331 rdf:resource="{m2r:nomenIRI($baseID, ., m2r:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                </xsl:when>
                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                    <rdaao:P10328 rdf:resource="{m2r:nomenIRI($baseID, ., '', '', 'work')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdawd:P10328>
                                <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                            </rdawd:P10328>
                            <xsl:if test="starts-with($workIRI, $BASE)">
                                <xsl:call-template name="FXXX-xx-d"/>
                                <xsl:call-template name="FXXX-xx-tnp"/>
                                <xsl:call-template name="FXXX-xx-l-wor"/>
                                <xsl:call-template name="FXXX-xx-m-wor"/>
                                <xsl:call-template name="FXXX-xx-n"/>
                                <xsl:call-template name="FXXX-xx-r"/>
                                <xsl:call-template name="FXXX-xx-x"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$tagType = '800'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdawo:P10312 rdf:resource="{m2r:agentIRI($baseID, .)}"/>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdawo:P10262 rdf:resource="{m2r:agentIRI($baseID, .)}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawo:P10314 rdf:resource="{m2r:agentIRI($baseID, .)}"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="m2r:workIdentifiers(.)"/>
            <!-- If we minted the IRI - add additional details -->
            <xsl:if test="starts-with($workIRI, $BASE)">
                <xsl:call-template name="FXXX-xx-d"/>
                <xsl:call-template name="FXXX-xx-tnp"/>
                <xsl:call-template name="FXXX-xx-l-wor"/>
                <xsl:call-template name="FXXX-xx-m-wor"/>
                <xsl:call-template name="FXXX-xx-n"/>
                <xsl:call-template name="FXXX-xx-r"/>
                <xsl:call-template name="FXXX-xx-x"/>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <!-- Template Here is Agent IRI -->
    <xsl:template match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']] | marc:datafield[@tag = '810'][marc:subfield[@code = 't']]  | marc:datafield[@tag = '811'][marc:subfield[@code = 't']] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '810-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '811-00'][marc:subfield[@code = 't']]"
        mode="age" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="ap" select="m2r:agentAccessPoint(.)"/>
        <xsl:variable name="agentIRI" select="m2r:agentIRI($baseID, .)"/>
        <rdf:Description rdf:about="{$agentIRI}">
            <!--<xsl:call-template name="getmarc"/>-->
            <xsl:variable name="tagType" select="m2r:tagType(.)"/>
            <xsl:choose>
                <xsl:when test="$tagType = '800'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'True'">
                                    <rdaao:P50411 rdf:resource="{m2r:nomenIRI($baseID, ., m2r:agentAccessPoint(.), marc:subfield[@code = '2'][1],'person')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'False'">
                                    <rdaao:P50377 rdf:resource="{m2r:nomenIRI($baseID, ., '', '', 'person')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50377>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50377>
                                                <xsl:value-of select="m2r:agentAccessPoint(.)"/>
                                            </rdaad:P50377>
                                            <!-- do the same for 880s -->
                                            <xsl:if test="starts-with($agentIRI, $BASE)">
                                                <xsl:call-template name="FX00-1x-a"/>
                                                <xsl:call-template name="FX00-2x-a"/>
                                                <xsl:call-template name="FX00-0x-ab"/>
                                                <xsl:call-template name="FX00-xx-d"/>
                                                <xsl:call-template name="FX00-xx-q"/>
                                                <xsl:call-template name="FX00-xx-u"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="starts-with($agentIRI, $BASE)">
                                <xsl:call-template name="FX00-1x-a"/>
                                <xsl:call-template name="FX00-2x-a"/>
                                <xsl:call-template name="FX00-0x-ab"/>
                                <xsl:call-template name="FX00-xx-d"/>
                                <xsl:call-template name="FX00-xx-q"/>
                                <xsl:call-template name="FX00-xx-u"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted -->
                                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'True'">
                                    <rdaao:P50409 rdf:resource="{m2r:nomenIRI($baseID, ., m2r:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'family')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'False'">
                                    <rdaao:P50376 rdf:resource="{m2r:nomenIRI($baseID, ., '', '', 'family')}"/>
                                </xsl:when>
                                <!-- else a nomen string is used directly -->
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="m2r:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50376>
                                                <xsl:value-of select="m2r:agentAccessPoint(.)"/>
                                            </rdaad:P50376>
                                            <xsl:if test="starts-with($agentIRI, $BASE)">
                                                <xsl:call-template name="FX00-3x-c"/>
                                                <xsl:call-template name="FX00-3x-d"/>
                                                <xsl:call-template name="FX00-3x-a"/>
                                                <xsl:call-template name="FX00-xx-u"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!-- If we minted the IRI - add additional details -->
                            <xsl:if test="starts-with($agentIRI, $BASE)">
                                <xsl:call-template name="FX00-3x-c"/>
                                <xsl:call-template name="FX00-3x-d"/>
                                <xsl:call-template name="FX00-3x-a"/>
                                    <xsl:call-template name="FX00-xx-u"/>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$tagType = '810' or $tagType = '811'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <xsl:choose>     
                        <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'True'">
                            <rdaao:P50407 rdf:resource="{m2r:nomenIRI($baseID, ., m2r:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'corporatebody')}"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'False'">
                            <rdaao:P50375 rdf:resource="{m2r:nomenIRI($baseID, ., '', '', 'corporatebody')}"/>
                        </xsl:when>
                        <!-- else a nomen string is used directly -->
                        <xsl:otherwise>
                            <rdaad:P50375>
                                <xsl:value-of select="$ap"/>
                            </rdaad:P50375>
                            <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                <xsl:for-each
                                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                    <rdaad:P50375>
                                        <xsl:value-of select="m2r:agentAccessPoint(.)"/>
                                    </rdaad:P50375>
                                    <!-- If we minted the IRI - add additional details -->
                                    <xsl:if test="starts-with($agentIRI, $BASE)">
                                        <xsl:call-template name="FX1X-xx-c"/>
                                        <xsl:call-template name="FX1X-xx-n"/>
                                        <xsl:call-template name="FX1X-xx-d"/>
                                        <xsl:call-template name="FX1X-xx-u"/>
                                        <xsl:if test="@tag = '810'"><xsl:call-template name="FX10-xx-ab"/></xsl:if>
                                        <xsl:if test="@tag = '811'"><xsl:call-template name="FX11-xx-ae"/></xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$tagType = '811'">
                        <rdaad:P50237>
                            <xsl:text>Meeting</xsl:text>
                        </rdaad:P50237>
                    </xsl:if>
                    <!-- If we minted the IRI - add additional details -->
                    <xsl:if test="starts-with($agentIRI, $BASE)">
                        <xsl:call-template name="FX1X-xx-c"/>
                        <xsl:call-template name="FX1X-xx-n"/>
                        <xsl:call-template name="FX1X-xx-d"/>
                        <xsl:call-template name="FX1X-xx-u"/>
                        <xsl:if test="@tag = '810'"><xsl:call-template name="FX10-xx-ab"/></xsl:if>
                        <xsl:if test="@tag = '811'"><xsl:call-template name="FX11-xx-ae"/></xsl:if>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <!-- Template: Here is Nomen -->
    <xsl:template
        match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']] | marc:datafield[@tag = '810'][marc:subfield[@code = 't']]  | marc:datafield[@tag = '811'][marc:subfield[@code = 't']] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '810-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '811-00'][marc:subfield[@code = 't']]" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="apWor" select="m2r:relWorkAccessPoint(.)"/>
        <xsl:variable name="apAgent" select="m2r:agentAccessPoint(.)"/>
        <xsl:variable name="tagType" select="m2r:tagType(.)"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="($tagType = '800')
                    and @ind1 != '3'">
                    <xsl:value-of select="'person'"/>
                </xsl:when>
                <xsl:when test="($tagType = '800')
                    and @ind1 = '3'">
                    <xsl:value-of select="'family'"/>
                </xsl:when>
                <xsl:when test="$tagType = '810' or $tagType = '811'">
                    <xsl:value-of select="'corporatebody'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="worNomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., m2r:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., '', '', 'work')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$worNomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apWor"/>
                </rdand:P80068>
                <xsl:copy-of select="m2r:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
            
            <xsl:variable name="ageNomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], $type) = 'True'">
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., m2r:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], $type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., '', '', $type)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <rdf:Description rdf:about="{$ageNomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apAgent"/>
                </rdand:P80068>
                <xsl:copy-of select="m2r:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="m2r:agentAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 830 -->
    <!-- Here is the template for Work -->
    <xsl:template match="marc:datafield[@tag = '830']| marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '830-00']" 
        mode="wor">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawo:P10102 rdf:resource="{m2r:relWorkIRI($baseID, .)}"/>
    </xsl:template>    
    
    <!-- Here is the template for relwork -->
    <xsl:template
        match="marc:datafield[@tag = '830'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '830-00']"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <xsl:variable name="relWorkIRI" select="m2r:relWorkIRI($baseID, .)"/>
            <rdf:Description rdf:about="{$relWorkIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <rdawo:P10331 rdf:resource="{m2r:nomenIRI($baseID, ., m2r:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = '2'] and m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                        <rdawo:P10328 rdf:resource="{m2r:nomenIRI($baseID, ., '', '', 'work')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdawd:P10328>
                            <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                        </rdawd:P10328>
                        <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <rdawd:P10328>
                                    <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                                </rdawd:P10328>
                                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                                    <xsl:call-template name="FX30-xx-anp"/>
                                    <xsl:call-template name="FX30-xx-d"/>
                                    <xsl:call-template name="FXXX-xx-l-wor"/>
                                    <xsl:call-template name="FXXX-xx-m-wor"/>
                                    <xsl:call-template name="FXXX-xx-n"/>
                                    <xsl:call-template name="FXXX-xx-r"/>
                                    <xsl:call-template name="FXXX-xx-x"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="m2r:workIdentifiers(.)"/>
                <!-- If we minted the IRI - add additional details -->
                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                    <xsl:call-template name="FX30-xx-anp"/>
                    <xsl:call-template name="FX30-xx-d"/>
                    <xsl:call-template name="FXXX-xx-l-wor"/>
                    <xsl:call-template name="FXXX-xx-m-wor"/>
                    <xsl:call-template name="FXXX-xx-n"/>
                    <xsl:call-template name="FXXX-xx-r"/>
                    <xsl:call-template name="FXXX-xx-x"/>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- Here is the template for nomen -->
    <xsl:template
        match="marc:datafield[@tag = '830'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '830-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="nomenIRI">
                <xsl:choose>
                    <xsl:when test="m2r:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., m2r:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="m2r:nomenIRI($baseID, ., '', '', 'work')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:copy-of select="m2r:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>

    <!--856 Electronic Location and Access-->
    <xsl:template match="marc:datafield[@tag = '856'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '856']" mode="man" 
        expand-text="yes">
        <xsl:if test="@ind2 = '0'">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '3']">
                    <xsl:for-each select="marc:subfield[@code = 'u']">
                        <rdamd:P30137>
                            <xsl:text>[{../marc:subfield[@code = '3']}] at: {normalize-space(.)}</xsl:text>
                        </rdamd:P30137>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="marc:subfield[@code = 'u']">
                        <rdam:P30154 rdf:resource="{normalize-space(.)}"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="@ind2 = '2' or ' ' or '8'">
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <rdamd:P30137>
                    <xsl:text>Related resource at: {normalize-space(.)}</xsl:text>
                </rdamd:P30137>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind2 = '1'">
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <rdamd:P30137>
                    <xsl:text>Version of resource at: {normalize-space(.)}</xsl:text>
                </rdamd:P30137>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind2 = '3'">
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <rdamd:P30137>
                    <xsl:text>Component part(s) of resource at: {normalize-space(.)}</xsl:text>
                </rdamd:P30137>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind2 = '4'">
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <rdamd:P30137>
                    <xsl:text>Version of component part(s) of resource at: {normalize-space(.)}</xsl:text>
                </rdamd:P30137>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!--881 Manifestation Statements-->
    <xsl:template match="marc:datafield[@tag = '881'] | marc:datafield[@tag = '881'][substring(marc:subfield[@code = '6'], 1, 6) = '881']" mode="man" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'a']">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdamd:P30292>
                    <xsl:value-of select="."/>
                </rdamd:P30292>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'b' or @code = 'c' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h' or @code = 'i' or @code = 'j' or @code = 'k' or @code = 'l' or @code = 'm' or @code = 'n']">
            <rdamd:P30292>
                <xsl:for-each select="marc:subfield[@code = 'b' or @code = 'c' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h' or @code = 'i' or @code = 'j' or @code = 'k' or @code = 'l' or @code = 'm' or @code = 'n']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdamd:P30292>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'b']">
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <rdamd:P30286>
                    <xsl:value-of select="."/>
                </rdamd:P30286>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'c']">
            <xsl:for-each select="marc:subfield[@code = 'c']">
                <rdamd:P30293>
                    <xsl:value-of select="."/>
                </rdamd:P30293>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'd']">
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <rdamd:P30284>
                    <xsl:value-of select="."/>
                </rdamd:P30284>
            </xsl:for-each>
        </xsl:if>        
        <xsl:if test="marc:subfield[@code = 'e']">
            <xsl:for-each select="marc:subfield[@code = 'e']">
                <rdamd:P30288>
                    <xsl:value-of select="."/>
                </rdamd:P30288>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'f']">
            <xsl:for-each select="marc:subfield[@code = 'f']">
                <rdamd:P30289>
                    <xsl:value-of select="."/>
                </rdamd:P30289>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'g']">
            <xsl:for-each select="marc:subfield[@code = 'g']">
                <rdamd:P30283>
                    <xsl:value-of select="."/>
                </rdamd:P30283>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'h']">
            <xsl:for-each select="marc:subfield[@code = 'h']">
                <rdamd:P30287>
                    <xsl:value-of select="."/>
                </rdamd:P30287>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'i']">
            <xsl:for-each select="marc:subfield[@code = 'i']">
                <rdamd:P30280>
                    <xsl:value-of select="."/>
                </rdamd:P30280>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'j']">
            <xsl:for-each select="marc:subfield[@code = 'j']">
                <rdamd:P30285>
                    <xsl:value-of select="."/>
                </rdamd:P30285>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'k']">
            <xsl:for-each select="marc:subfield[@code = 'k']">
                <rdamd:P30281>
                    <xsl:value-of select="."/>
                </rdamd:P30281>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'l']">
            <xsl:for-each select="marc:subfield[@code = 'l']">
                <rdamd:P30291>
                    <xsl:value-of select="."/>
                </rdamd:P30291>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'm']">
            <xsl:for-each select="marc:subfield[@code = 'm']">
                <rdamd:P30282>
                    <xsl:value-of select="."/>
                </rdamd:P30282>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'n']">
            <xsl:for-each select="marc:subfield[@code = 'n']">
                <rdamd:P30290>
                    <xsl:value-of select="."/>
                </rdamd:P30290>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '3']">
<rdamd:P30137>
    <xsl:text>Manifestation statement "</xsl:text>
    <xsl:for-each select="marc:subfield[@code = 'b' or @code = 'c' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h' or @code = 'i' or @code = 'j' or @code = 'k' or @code = 'l' or @code = 'm' or @code = 'n']">
                <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text> </xsl:text>
        </xsl:if>
            </xsl:for-each>
            <xsl:text>" applies to </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
</rdamd:P30137>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
