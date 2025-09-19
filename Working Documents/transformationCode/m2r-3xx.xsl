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
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
    <xsl:include href="m2r-3xx-named.xsl"/>

    <xsl:template
        match="marc:datafield[@tag = '300'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '300']"
        mode="man origMan" expand-text="yes">
        <xsl:param name="type"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="$type = 'reproduction' or $type = 'origMan'">
                <xsl:variable name="conditionMet" select="m2r:checkReproductions(..)"/>
                <xsl:choose>
                    <xsl:when test="$conditionMet = '588'">
                        <xsl:if test="$type = 'reproduction'">
                            <rdamd:P30182>
                                <xsl:value-of select="
                                        marc:subfield[@code = '3'] | marc:subfield[@code = 'a']
                                        | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                                        | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']"
                                    separator=" "/>
                            </rdamd:P30182>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$conditionMet = '533'">
                        <xsl:if test="$type = 'origMan'">
                            <rdamd:P30182>
                                <xsl:value-of select="
                                        marc:subfield[@code = '3'] | marc:subfield[@code = 'a']
                                        | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                                        | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']"
                                    separator=" "/>
                            </rdamd:P30182>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30182>
                    <xsl:value-of select="
                            marc:subfield[@code = '3'] | marc:subfield[@code = 'a']
                            | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                            | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']"
                        separator=" "/>
                </rdamd:P30182>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- 306 -->
    <xsl:template
        match="marc:datafield[@tag = '306'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '306']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdawd:P10351 rdf:datatype="xsd:time"
                >{replace(.,'([0-9][0-9])([0-9][0-9])([0-9][0-9])','$1:$2:$3')}</rdawd:P10351>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '306'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '306']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20219 rdf:datatype="xsd:time"
                >{replace(.,'([0-9][0-9])([0-9][0-9])([0-9][0-9])','$1:$2:$3')}</rdaed:P20219>
        </xsl:for-each>
    </xsl:template>


    <xsl:template
        match="marc:datafield[@tag = '307'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '307']"
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:text>{marc:subfield[@code = 'a']}</xsl:text>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:text> {marc:subfield[@code = 'b']}</xsl:text>
            </xsl:if>
        </rdamd:P30137>
    </xsl:template>

    <!-- 334 - Mode of Issuance -->
    <xsl:template
        match="marc:datafield[@tag = '334'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '334']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F334-string"/>
        <xsl:call-template name="F334-iri"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '334'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '334-00']"
        mode="con">
        <xsl:call-template name="F334-concept"/>
    </xsl:template>

    <!-- 335 - Extension Plan -->
    <xsl:template
        match="marc:datafield[@tag = '335'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '335']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F335-string"/>
        <xsl:call-template name="F335-iri"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '335'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '335-00']"
        mode="con">
        <xsl:call-template name="F335-concept"/>
    </xsl:template>

    <!-- 336-337-338 -->
    
    <xsl:template match="marc:datafield[@tag = '336'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '336']
        | marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '337']
        | marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '338']" 
        mode="aggWor">
        <!--<xsl:call-template name="getmarc"/>-->
        
        <xsl:variable name="mappedTriple">
            <xsl:call-template name="F336-337-338">
                <xsl:with-param name="tag33X">
                    <xsl:choose>
                        <xsl:when test="starts-with(@tag, '33')">
                            <xsl:value-of select="@tag"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(marc:subfield[@code = '6'], 1, 3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
            
        <xsl:for-each select="$mappedTriple/child::*[starts-with(name(), 'rdaw')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
        
    <xsl:template match="marc:datafield[@tag = '336'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '336']
        | marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '337']
        | marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '338']" 
        mode="exp">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:variable name="mappedTriple">
            <xsl:call-template name="F336-337-338">
                <xsl:with-param name="tag33X">
                    <xsl:choose>
                        <xsl:when test="starts-with(@tag, '33')">
                            <xsl:value-of select="@tag"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(marc:subfield[@code = '6'], 1, 3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:for-each select="$mappedTriple/child::*[starts-with(name(), 'rdae')]">
            <xsl:copy-of select="."/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '336'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '336']
        | marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '337']
        | marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '338']" 
        mode="man">
        <xsl:param name="isElectronic"/>
        <xsl:param name="isMicroform"/>
        <!--<xsl:call-template name="getmarc"/>-->
        
        <xsl:variable name="sub3" select="marc:subfield[@code = '3']"/>
        
        <xsl:variable name="mappedTriple">
            <xsl:call-template name="F336-337-338">
                <xsl:with-param name="tag33X">
                    <xsl:choose>
                        <xsl:when test="starts-with(@tag, '33')">
                            <xsl:value-of select="@tag"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(marc:subfield[@code = '6'], 1, 3)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:for-each select="$mappedTriple/child::*[starts-with(name(), 'rdam')]">
            <xsl:choose>
                <xsl:when test="$isElectronic != false()">
                    <xsl:choose>
                        <xsl:when test="contains(name(), 'P30001')">
                            <xsl:choose>
                                <xsl:when test="not(contains(@rdf:resource, 'RDACarrierType'))">
                                    <xsl:copy-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="matches(@rdf:resource, '1010|1011|1012|1013|1014|1015|1016|1017|1018')">
                                        <xsl:copy-of select="."/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$isMicroform != false()">
                    <xsl:choose>
                        <xsl:when test="contains(name(), 'P30001')">
                            <xsl:choose>
                                <xsl:when test="not(contains(@rdf:resource, 'RDACarrierType'))">
                                    <xsl:copy-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="matches(@rdf:resource, '1022|1023|1024|1025|1026|1027|1028')">
                                        <xsl:copy-of select="."/>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        
        <xsl:for-each select="$mappedTriple/child::*">
            <xsl:if test="$sub3 != ''">
                <rdamd:P30137>
                    <xsl:value-of select="concat(
                        upper-case(substring(normalize-space($sub3), 1, 1)),
                        substring(normalize-space($sub3), 2)
                        )"/>
                    <xsl:choose>
                        <xsl:when test="contains(name(), '10349') or contains(name(), '20001')">
                            <xsl:text> has Content type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(name(), '30002')">
                            <xsl:text> has Media type: </xsl:text>
                        </xsl:when>
                        <xsl:when test="contains(name(), '30001')">
                            <xsl:text> has Carrier type: </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="./@rdf:resource">
                            <xsl:value-of select="@rdf:resource"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="text()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '336'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '336-00']
        | marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '337-00']
        | marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '338-00']"
        mode="con">
        <xsl:call-template name="F336-337-338-concept"/>
    </xsl:template>

    <!-- 340 - Physical Medium -->
    <xsl:template
        match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '340']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F340-b_f_h_i"/>
        <!-- these fields require lookups or minted concepts -->
        <xsl:for-each select="
                marc:subfield[@code = 'a'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
                | marc:subfield[@code = 'e'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'j']
                | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm']
                | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
                | marc:subfield[@code = 'q']">
            <xsl:choose>
                <!-- different subfields require different properties, 
                    the templates are set up to accommodate this with the param $propertyNum-->
                <xsl:when test="@code = 'd'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30187</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'g'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30456</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'j'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30191</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'k'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30155</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'l'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30309</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'm'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30197</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'n'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30199</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'o'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30196</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'p'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30453</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'q'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30263</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30304</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '340-00']"
        mode="con">
        <xsl:call-template name="F340-concept"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '340']"
        mode="aggWor">
        <xsl:for-each select="marc:subfield[@code = 'g']">
            <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                <xsl:with-param name="propertyNum">P10348</xsl:with-param>
                <xsl:with-param name="entity">w</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- 342 - Geospatial Reference Data -->
    <xsl:template
        match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F342-xx-a-aggWor"/>
        <xsl:call-template name="F342-xx-bcdlmnosvpfijtuw2-aggWor"/>
        <xsl:call-template name="F342-x1-egh-aggWor"/>
        <xsl:call-template name="F342-xx-k-aggWor"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F342-xx-a"/>
        <xsl:call-template name="F342-xx-bcdlmnosvpfijtuw2"/>
        <xsl:call-template name="F342-x1-egh"/>
        <xsl:call-template name="F342-xx-k"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="wor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'q'] and marc:subfield[@code = 'r']">
            <rdaw:P10330>
                <xsl:text>Ellipsoid name: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'q']"/>
                <xsl:text>. Semi-major axis: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'r']"/>
            </rdaw:P10330>
        </xsl:if>
    </xsl:template>

    <!-- 343 - Planar Coordinate Data  -->
    <xsl:template
        match="marc:datafield[@tag = '343'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '343']"
        mode="aggWor" expand-text="yes">
        <rdawd:P10330>
            <xsl:for-each select="
                    marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                    | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']
                    | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i']">
                <xsl:if test="@code = 'a'">
                    <xsl:text>Planar coordinate encoding method: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'b'">
                    <xsl:text>Planar distance units: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'c'">
                    <xsl:text>Abscissa resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'd'">
                    <xsl:text>Ordinate resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'e'">
                    <xsl:text>Distance resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'f'">
                    <xsl:text>Bearing resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'g'">
                    <xsl:text>Bearing units: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'h'">
                    <xsl:text>Bearing reference direction: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'i'">
                    <xsl:text>Bearing reference meridian: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdawd:P10330>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '343'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '343']"
        mode="exp" expand-text="yes">
        <rdaed:P20071>
            <xsl:for-each select="
                    marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                    | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']
                    | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i']">
                <xsl:if test="@code = 'a'">
                    <xsl:text>Planar coordinate encoding method: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'b'">
                    <xsl:text>Planar distance units: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'c'">
                    <xsl:text>Abscissa resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'd'">
                    <xsl:text>Ordinate resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'e'">
                    <xsl:text>Distance resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'f'">
                    <xsl:text>Bearing resolution: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'g'">
                    <xsl:text>Bearing units: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'h'">
                    <xsl:text>Bearing reference direction: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'i'">
                    <xsl:text>Bearing reference meridian: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdaed:P20071>
    </xsl:template>

    <!-- 344 - Sound Characteristics -->
    <xsl:template
        match="marc:datafield[@tag = '344'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '344']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="
                marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']
                | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i']">
            <xsl:choose>
                <xsl:when test="@code = 'a'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30172</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'b'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30206</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'c'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30201</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'd'">
                    <xsl:choose>
                        <xsl:when test="(text() = 'fine') or (text() = 'standard')">
                            <xsl:variable name="rdaIRI" select="m2r:rdaTermLookup('rdagrp', .)"/>
                            <xsl:if test="$rdaIRI">
                                <rdamo:P30307>
                                    <xsl:attribute name="rdf:resource" select="$rdaIRI"/>
                                </rdamo:P30307>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F344-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="."/>
                                        <xsl:with-param name="value" select="$rdaIRI"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="(text() = 'coarse groove') or (text() = 'microgroove')">
                            <xsl:variable name="rdaIRI" select="m2r:rdaTermLookup('rdagw', .)"/>
                            <xsl:if test="$rdaIRI">
                                <rdamo:P30308>
                                    <xsl:attribute name="rdf:resource" select="$rdaIRI"/>
                                </rdamo:P30308>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F344-xx-3">
                                        <xsl:with-param name="sub3"
                                            select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="."/>
                                        <xsl:with-param name="value" select="$rdaIRI"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                                <xsl:with-param name="propertyNum">P30164</xsl:with-param>
                                <xsl:with-param name="entity">m</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@code = 'e'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30161</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'f'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30185</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'g'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30184</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'h'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30138</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'i'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30454</xsl:with-param>
                        <xsl:with-param name="entity">m</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '344'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '344-00']"
        mode="con">
        <xsl:call-template name="F344-concept"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '344'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '344']"
        mode="aggWor">
        <xsl:for-each select="marc:subfield[@code = 'i']">
            <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                <xsl:with-param name="propertyNum">P10358</xsl:with-param>
                <xsl:with-param name="entity">w</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- 346 - Video Characteristics -->
    <xsl:template
        match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '346']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F346-string"/>
        <xsl:call-template name="F346-iri"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '346-00']"
        mode="con">
        <xsl:call-template name="F346-concept"/>
    </xsl:template>

    <!-- 347 - Digital File Characteristics -->

    <xsl:template
        match="marc:datafield[@tag = '347'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '347']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F347-c"/>
        <xsl:for-each select="
                marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']
                | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']">
            <xsl:choose>
                <xsl:when test="@code = 'a'">
                    <xsl:call-template name="F347-xx-a_b_d_e_f_0_1">
                        <xsl:with-param name="propertyNum">P30018</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'b'">
                    <xsl:call-template name="F347-xx-a_b_d_e_f_0_1">
                        <xsl:with-param name="propertyNum">P30096</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'd'">
                    <xsl:call-template name="F347-xx-a_b_d_e_f_0_1">
                        <xsl:with-param name="propertyNum">P30159</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'e'">
                    <xsl:call-template name="F347-xx-a_b_d_e_f_0_1">
                        <xsl:with-param name="propertyNum">P30006</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'f'">
                    <xsl:call-template name="F347-xx-a_b_d_e_f_0_1">
                        <xsl:with-param name="propertyNum">P30202</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '347'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '347-00']"
        mode="con">
        <xsl:call-template name="F347-concept"/>
    </xsl:template>

    <!-- 351 Organization and Arrangement of Materials-->
    <xsl:template
        match="marc:datafield[@tag = '351'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '351']"
        mode="wor" expand-text="yes">
        <rdaw:P10084>
            <xsl:for-each
                select="marc:subfield[@code = 'c'] | marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = '3']">
                <xsl:if test="@code = 'c'">
                    <xsl:text>Hierarchical level: {.}.</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'a'">
                    <xsl:text>Organization: {.}.</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'b'">
                    <xsl:text>Arrangement: {.}.</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '3'">
                    <xsl:text>(Applies to: {.})</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdaw:P10084>
    </xsl:template>

    <!-- 352 Digital Graphic Representation-->
    <xsl:template
        match="marc:datafield[@tag = '352'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '352']"
        mode="man" expand-text="yes">

        <rdamd:P30261>
            <xsl:for-each select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c']">
                <!-- Add a space before the second/third item -->
                <xsl:if test="position() > 1">
                    <xsl:text> </xsl:text>
                </xsl:if>

                <!-- Process based on subfield code -->
                <xsl:choose>
                    <xsl:when test="@code = 'a'">
                        <xsl:text>Direct reference method: </xsl:text>
                        <xsl:value-of select="m2r:stripAllPunctuation(string(.))"/>
                        <xsl:text>.</xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'b'">
                        <xsl:text>Object type: </xsl:text>
                        <xsl:value-of select="m2r:stripEndPunctuation(string(.))"/>
                        <xsl:text>.</xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'c'">
                        <xsl:text>Object count: </xsl:text>
                        <xsl:value-of select="m2r:stripAllPunctuation(string(.))"/>
                        <xsl:text>.</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </rdamd:P30261>

        <!-- Check if any d, e, or f subfields exist before creating the P30102 element -->
        <xsl:if test="marc:subfield[@code = 'd' or @code = 'e' or @code = 'f']">
            <rdamd:P30102>
                <xsl:for-each select="marc:subfield[@code = 'd' or @code = 'e' or @code = 'f']">
                    <!-- Add a space before the second/third item within this group -->
                    <xsl:if test="position() > 1">
                        <xsl:text> </xsl:text>
                    </xsl:if>

                    <!-- Process based on subfield code -->
                    <xsl:choose>
                        <xsl:when test="@code = 'd'">
                            <xsl:text>Row count: </xsl:text>
                            <!-- Apply stripAllPunctuation first, then remove 'x' and 'X' -->
                            <xsl:variable name="d_stripped"
                                select="m2r:stripAllPunctuation(string(.))"/>
                            <xsl:value-of select="translate($d_stripped, 'xX', '')"/>
                            <xsl:text>.</xsl:text>
                        </xsl:when>
                        <xsl:when test="@code = 'e'">
                            <xsl:text>Column count: </xsl:text>
                            <xsl:value-of select="m2r:stripAllPunctuation(string(.))"/>
                            <xsl:text>.</xsl:text>
                        </xsl:when>
                        <xsl:when test="@code = 'f'">
                            <xsl:text>Vertical count: </xsl:text>
                            <xsl:value-of select="m2r:stripAllPunctuation(string(.))"/>
                            <xsl:text>.</xsl:text>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </rdamd:P30102>
        </xsl:if>

        <!-- Check if g subfields exist before creating the P30102 element -->
        <xsl:if test="marc:subfield[@code = 'g']">
            <rdamd:P30102>
                <xsl:text>VPF topology level: {marc:subfield[@code = 'g']}</xsl:text>
            </rdamd:P30102>
        </xsl:if>

        <!-- Check if q subfields exist before creating the P30102 element -->
        <xsl:if test="marc:subfield[@code = 'q']">
            <rdamd:P30102>
                <xsl:text>Format of the digital image: {marc:subfield[@code = 'q']}</xsl:text>
            </rdamd:P30102>
        </xsl:if>

        <!-- Check if i subfields exist before creating the P30102 element -->
        <xsl:if test="marc:subfield[@code = 'i']">
            <rdamd:P30137>
                <xsl:text>Indirect reference description: {marc:subfield[@code = 'i']}</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <!-- 353 Supplementary Content Characteristics WIP --> 
    <xsl:template
        match="marc:datafield[@tag = '353'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '353']"
        mode="man" expand-text="yes">

        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdam:P30455><xsl:value-of select="."/></rdam:P30455>
        </xsl:for-each>

        <xsl:if test="marc:subfield[@code='b'] or marc:subfield[@code='2']">
            <rdam:P30455>
                <xsl:for-each select="marc:subfield[@code='b'] | marc:subfield[@code='2']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdam:P30455>
        </xsl:if>

        <xsl:for-each select="marc:subfield[@code = '0']">
            <rdam:P30455><xsl:value-of select="."/></rdam:P30455>
        </xsl:for-each>

        <xsl:for-each select="marc:subfield[@code = '3']">
            <rdam:P30137>applies to: <xsl:value-of select="."/></rdam:P30137>
        </xsl:for-each>
        
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdam:P30455 rdf:resource="{.}"/>
        </xsl:for-each>
 
    </xsl:template>


    <!-- 357 Originator Dissemination Control-->
    <xsl:template
        match="marc:datafield[@tag = '357'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '357']"
        mode="man" expand-text="yes">
        <xsl:call-template name="F357-xx-abcg"/>
    </xsl:template>

    <!-- 380 - Form of Work -->
    <xsl:template
        match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '380']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F380-string"/>
        <xsl:call-template name="F380-iri"/>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '380-00']"
        mode="con">
        <xsl:call-template name="F380-concept"/>
    </xsl:template>

    <!-- 382 Medium of Performance-->
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '382']"
        mode="exp">
        <xsl:if test="@ind1 = ' ' or @ind1 = '0' or @ind1 = '1'">
            <!--            <xsl:call-template name="getmarc"/>-->
            <xsl:call-template name="F382-xx-a_b_d_p_0_1_2-exp"/>
            <rdaed:P20215>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdaed:P20215>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '382']"
        mode="wor">
        <xsl:if test="@ind1 = '2' or @ind1 = '3'">
            <!--            <xsl:call-template name="getmarc"/>-->
            <xsl:call-template name="F382-xx-a_b_d_p_0_1_2-wor"/>
            <rdawd:P10220>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdawd:P10220>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '382']"
        mode="aggWor">
        <xsl:if test="@ind1 = ' ' or @ind1 = '0' or @ind1 = '1'">
            <!--<xsl:call-template name="getmarc"/>-->
            <xsl:call-template name="F382-xx-a_b_d_p_0_1_2-wor"/>
            <rdawd:P10220>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdawd:P10220>
            <rdawd:P10220>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdawd:P10220>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '382-00']"
        mode="con">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>

            <xsl:variable name="linked880">
                <xsl:if test="@tag = '382' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('382-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:copy-of
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"
                    />
                </xsl:if>
            </xsl:variable>

            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <xsl:variable name="code" select="@code"/>
                <rdf:Description rdf:about="{m2r:conceptIRI($sub2, .)}">
                    <xsl:copy-of select="m2r:fillConcept(., $sub2, '', '382')"/>
                    <xsl:if test="$linked880">
                        <xsl:for-each
                            select="$linked880/marc:datafield/marc:subfield[position()][@code = $code]">
                            <xsl:copy-of select="m2r:fillConcept(., '', '', '880')"/>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!--383 Numeric Designation of Musical Work-->
    <xsl:template match="marc:datafield[@tag = '383'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '383']" mode="wor">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="@ind1 = '0' or @ind1 = ' '">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdawd:P10334>
                    <xsl:value-of select="."/>
                </rdawd:P10334>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <rdawd:P10333>
                    <xsl:value-of select="."/>
                </rdawd:P10333>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'c']">
                <rdawd:P10335>
                    <xsl:value-of select="."/>
                </rdawd:P10335>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'd']"> 
                <xsl:choose>
                    <xsl:when test="following-sibling::marc:subfield[@code = '2']">
                        <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
                        <rdawo:P10335 rdf:resource="{m2r:nomenIRI($baseID, ., ., $source, 'work')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdawd:P10335>
                            <xsl:value-of select="."/>
                        </rdawd:P10335>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = 'b']">  
                <xsl:for-each select="marc:subfield[@code = 'e']"> 
                    <rdawd:P10330>
                        <xsl:text>Publisher associated with opus number: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = 'e']"/>
                    </rdawd:P10330>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = '3']">
                <xsl:call-template name="F383-3"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '383'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '383']" mode="exp">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="@ind1 = '1'">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdaed:P20002>
                    <xsl:value-of select="."/>
                </rdaed:P20002>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'b']">
                <rdaed:P20002>
                    <xsl:value-of select="."/>
                </rdaed:P20002>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'c']">
                <rdaed:P20002>
                    <xsl:value-of select="."/>
                </rdaed:P20002>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <xsl:choose>
                    <xsl:when test="following-sibling::marc:subfield[@code = '2']">
                        <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
                        <rdaeo:P20002 rdf:resource="{m2r:nomenIRI($baseID, ., ., $source, 'expression')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdaed:P10335>
                            <xsl:value-of select="."/>
                        </rdaed:P10335>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <rdaed:P20071>
                        <xsl:text>Publisher associated with opus number: </xsl:text>
                        <xsl:value-of select="."/>
                    </rdaed:P20071>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = '3']">
                <xsl:call-template name="F383-3"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="marc:datafield[@tag = '383'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '383']" mode="nom">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="@ind1 = '#' or @ind1 = '0'"> 
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <xsl:if test="following-sibling::marc:subfield[@code = '2']">
                    <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
                    <rdf:Description rdf:about="{m2r:nomenIRI($baseID, ., ., $source, 'work')}">
                        <xsl:call-template name="F383-nom"/>
                    </rdf:Description>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind1 = '1'"> 
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <xsl:if test="following-sibling::marc:subfield[@code = '2']">
                    <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
                    <rdf:Description rdf:about="{m2r:nomenIRI($baseID, ., ., $source, 'expression')}">
                        <xsl:call-template name="F383-nom"/>
                    </rdf:Description>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

<!-- 384 Key Type -->
<xsl:template
    match="marc:datafield[@tag = '384'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '384']"
    mode="exp">
    <xsl:if test="@ind1 = ' ' or @ind1 = '0' or @ind1 = '1'">
        <xsl:for-each
            select="marc:subfield[@code = 'a']">
            <rdaed:P20326><xsl:value-of select="."/></rdaed:P20326>
        </xsl:for-each>      
        <xsl:for-each select=" marc:subfield[@code = '0']">
            <rdaed:P20326><xsl:value-of select="."/></rdaed:P20326>
        </xsl:for-each>
        <xsl:for-each
            select="marc:subfield[@code = '1']">
                <rdaeo:P20326 rdf:resource="{.}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '3']">
            <rdaeo:P20071>applies to: <xsl:value-of select="."/></rdaeo:P20071>
        </xsl:for-each>
    </xsl:if>
</xsl:template>

<xsl:template
    match="marc:datafield[@tag = '384'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '384']"
    mode="wor">
    <xsl:if test="@ind1 = '2'">
        <xsl:for-each
            select="marc:subfield[@code = 'a']">
            <rdawd:P10221><xsl:value-of select="."/></rdawd:P10221>
        </xsl:for-each>
        <xsl:for-each select=" marc:subfield[@code = '0']">
            <rdawd:P10221><xsl:value-of select="."/></rdawd:P10221>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '3']">
            <rdawd:P10330>applies to: <xsl:value-of select="."/></rdawd:P10330>
        </xsl:for-each>
        <xsl:for-each
            select="marc:subfield[@code = '1']">
                <rdawo:P10221 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:if>
</xsl:template>
    <!-- 385 - Intended Audience -->
    
    <xsl:template
        match="marc:datafield[@tag = '385'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '385']"
        mode="exp">
        
        <xsl:param name="baseID"/> 
        
        <xsl:call-template name="F385-xx-a_b-expression">
            <xsl:with-param name="baseID" select="$baseID"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Manifestation-level template call -->
    <xsl:template
        match="marc:datafield[@tag = '385'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '385']"
        mode="man">
        
        <xsl:call-template name="F385-xx-a_b-manifestation"/>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '385'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '385-00']"
        mode="con">
        
        <xsl:call-template name="F385-xx-a_b-concept"/>
    </xsl:template>
    

<!-- 388 Time Period of Creation -->
    <xsl:template match="marc:datafield[@tag = '388'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '388']" mode="wor">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->  
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdawo:P10317 rdf:resource="{m2r:timespanIRI($baseID, .., .)}"/>         
        </xsl:for-each> 
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="starts-with(., 'http://')">
                <rdawo:P10317 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdawo:P10317 rdf:resource="{.}"/>
        </xsl:for-each> 
        <xsl:if test="marc:subfield[@code = '3']">
            <rdawd:P10330>
                <xsl:text>Timespan related to work </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'a'] [1]"/>
                <xsl:text> applies to </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
            </rdawd:P10330>
        </xsl:if>
    </xsl:template>    
    
    <xsl:template match="marc:datafield[@tag = '388'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '388']" mode="tim">
        <xsl:param name="baseID"/>
        <!--create variables to test whether s2Nomen output includes IRI and has scheme-->
        <xsl:variable name="testScheme" select="m2r:s2Nomen(marc:subfield[@code = '2'])"/>
        <xsl:variable name="schemeElement" select="$testScheme[self::rdan:P80069 or self::rdand:P80069]"/>
        <!--<xsl:call-template name="getmarc"/>--> 
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{m2r:timespanIRI($baseID, .., .)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10010"/>
                    <xsl:choose>
                    <!--only mint nomenIRI when $2 has a scheme-->
                        <xsl:when test="$schemeElement/@rdf:resource">
                            <rdato:P70009 rdf:resource="{m2r:nomenIRI($baseID, .., ., marc:subfield[@code = '2'], 'timespan')}"/>
                        </xsl:when>
                            <!--otherwise use string value of $a-->
                        <xsl:otherwise>
                            <rdatd:P70015>
                                    <xsl:value-of select="."/>
                            </rdatd:P70015>
                        </xsl:otherwise>
                    </xsl:choose>
            </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(starts-with(., 'http://'))">
                <rdatd:P70018>
                    <xsl:value-of select="."/>
                </rdatd:P70018>
            </xsl:if>
        </xsl:for-each>
    </xsl:template> 
    
    <xsl:template match="marc:datafield[@tag = '388'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '388']" mode="nom">
        <xsl:param name="baseID"/>
        <xsl:variable name="testScheme" select="m2r:s2Nomen(marc:subfield[@code = '2'])"/>
        <xsl:variable name="schemeElement" select="$testScheme[self::rdan:P80069 or self::rdand:P80069]"/>
        <!--<xsl:call-template name="getmarc"/>-->   
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{m2r:nomenIRI($baseID, .., ., marc:subfield[@code = '2'], 'timespan')}">       
                <rdano:P80068>
                    <xsl:value-of select="."/>
                </rdano:P80068>
            </rdf:Description>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:copy-of select="$schemeElement"/>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
