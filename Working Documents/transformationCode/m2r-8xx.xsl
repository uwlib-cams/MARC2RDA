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
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- Template: Main work to related work relationship -->
    <!-- 800, 810, 811 -->
    <xsl:template match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']] | marc:datafield[@tag = '810'][marc:subfield[@code = 't']]  | marc:datafield[@tag = '811'][marc:subfield[@code = 't']] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '810-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '811-00'][marc:subfield[@code = 't']]" 
        mode="wor">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawo:P10102 rdf:resource="{uwf:relWorkIRI($baseID, .)}"/>
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
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <xsl:variable name="workIRI" select="uwf:relWorkIRI($baseID, .)"/>
        <rdf:Description rdf:about="{$workIRI}">    
            <rdf:type rdf:resource="https://www.rdaregistry.info/Elements/c/#C10001"/>
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                    <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                </xsl:when>
                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                    <rdaao:P10328 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'work')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdawd:P10328>
                                <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                            </rdawd:P10328>
                            <xsl:if test="starts-with($workIRI, $BASE)">
                                <xsl:call-template name="FXXX-xx-d"/>
                                <xsl:call-template name="FXXX-xx-tnp"/>
                                <xsl:call-template name="FXXX-xx-l-wor"/>
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
                            <rdawo:P10312 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdawo:P10262 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawo:P10314 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="uwf:workIdentifiers(.)"/>
            <!-- If we minted the IRI - add additional details -->
            <xsl:if test="starts-with($workIRI, $BASE)">
                <xsl:call-template name="FXXX-xx-d"/>
                <xsl:call-template name="FXXX-xx-tnp"/>
                <xsl:call-template name="FXXX-xx-l-wor"/>
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
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
        <rdf:Description rdf:about="{$agentIRI}">
            <!--<xsl:call-template name="getmarc"/>-->
            <xsl:variable name="tagType" select="uwf:tagType(.)"/>
            <xsl:choose>
                <xsl:when test="$tagType = '800'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'True'">
                                    <rdaao:P50411 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1],'person')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'False'">
                                    <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'person')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50377>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50377>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                            </rdaad:P50377>
                                            <!-- do the same for 880s -->
                                            <xsl:if test="starts-with($agentIRI, $BASE)">
                                                <xsl:call-template name="FX00-1x-a"/>
                                                <xsl:call-template name="FX00-2x-a"/>
                                                <xsl:call-template name="FX00-0x-ab"/>
                                                <xsl:call-template name="FX00-0x-a"/>
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
                                <xsl:call-template name="FX00-0x-a"/>
                                <xsl:call-template name="FX00-xx-d"/>
                                <xsl:call-template name="FX00-xx-q"/>
                                <xsl:call-template name="FX00-xx-u"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted -->
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'True'">
                                    <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'family')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'False'">
                                    <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'family')}"/>
                                </xsl:when>
                                <!-- else a nomen string is used directly -->
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50376>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
                        <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'True'">
                            <rdaao:P50407 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'corporatebody')}"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'False'">
                            <rdaao:P50375 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'corporatebody')}"/>
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
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50375>
                                    <!-- If we minted the IRI - add additional details -->
                                    <xsl:if test="starts-with($agentIRI, $BASE)">
                                        <xsl:call-template name="FX1X-xx-c"/>
                                        <xsl:call-template name="FX1X-xx-n"/>
                                        <xsl:call-template name="FX1X-xx-d"/>
                                        <xsl:call-template name="FX1X-xx-u"/>
                                        <xsl:call-template name="FX1X-xx-a"/>
                                        <xsl:call-template name="FX10-xx-ab"/>
                                        <xsl:call-template name="FX11-xx-ae"/>
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
                        <xsl:call-template name="FX1X-xx-a"/>
                        <xsl:call-template name="FX10-xx-ab"/>
                        <xsl:call-template name="FX11-xx-ae"/>
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
        <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
        <xsl:variable name="apAgent" select="uwf:agentAccessPoint(.)"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
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
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', 'work')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$worNomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apWor"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
            
            <xsl:variable name="ageNomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], $type) = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], $type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', $type)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <rdf:Description rdf:about="{$ageNomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apAgent"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
        <rdawo:P10102 rdf:resource="{uwf:relWorkIRI($baseID, .)}"/>
    </xsl:template>    
    
    <!-- Here is the template for relwork -->
    <xsl:template
        match="marc:datafield[@tag = '830'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '830-00']"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <xsl:variable name="relWorkIRI" select="uwf:relWorkIRI($baseID, .)"/>
            <rdf:Description rdf:about="{$relWorkIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                        <rdawo:P10328 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'work')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdawd:P10328>
                            <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                        </rdawd:P10328>
                        <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <rdawd:P10328>
                                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                                </rdawd:P10328>
                                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                                    <xsl:call-template name="FX30-xx-anp"/>
                                    <xsl:call-template name="FX30-xx-d"/>
                                    <xsl:call-template name="FXXX-xx-l-wor"/>
                                    <xsl:call-template name="FXXX-xx-n"/>
                                    <xsl:call-template name="FXXX-xx-r"/>
                                    <xsl:call-template name="FXXX-xx-x"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="uwf:workIdentifiers(.)"/>
                <!-- If we minted the IRI - add additional details -->
                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                    <xsl:call-template name="FX30-xx-anp"/>
                    <xsl:call-template name="FX30-xx-d"/>
                    <xsl:call-template name="FXXX-xx-l-wor"/>
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
                    <xsl:when test="uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', 'work')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>