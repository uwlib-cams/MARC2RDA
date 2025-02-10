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
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-3xx-named.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    
    <xsl:template match="marc:datafield[@tag = '300'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '300']"
        mode="man origMan" expand-text="yes">
        <xsl:param name="type"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="$type = 'reproduction' or $type = 'origMan'">
                <xsl:variable name="conditionMet" select="uwf:checkReproductions(..)"/>
                <xsl:choose>
                    <xsl:when test="$conditionMet = '588'">
                        <xsl:if test="$type = 'reproduction'">
                            <rdamd:P30182>
                                <xsl:value-of select="marc:subfield[@code = '3'] | marc:subfield[@code = 'a'] 
                                    | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                                    | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']" separator=" "/>
                            </rdamd:P30182>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="$conditionMet = '533'">
                        <xsl:if test="$type = 'origMan'">
                            <rdamd:P30182>
                                <xsl:value-of select="marc:subfield[@code = '3'] | marc:subfield[@code = 'a'] 
                                    | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                                    | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']" separator=" "/>
                            </rdamd:P30182>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30182>
                    <xsl:value-of select="marc:subfield[@code = '3'] | marc:subfield[@code = 'a'] 
                        | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e']
                        | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']" separator=" "/>
                </rdamd:P30182>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 306 -->
    <xsl:template match="marc:datafield[@tag = '306'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '306']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdawd:P10351 rdf:datatype="xsd:time"
                >{replace(.,'([0-9][0-9])([0-9][0-9])([0-9][0-9])','$1:$2:$3')}</rdawd:P10351>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '306'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '306']"
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
    <xsl:template match="marc:datafield[@tag = '334'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '334']" 
            mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F334-string"/>
        <xsl:call-template name="F334-iri"/>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag = '334'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '334-00']" 
        mode="con">
        <xsl:call-template name="F334-concept"/>
    </xsl:template>
    
    <!-- 335 - Extension Plan -->
    <xsl:template match="marc:datafield[@tag = '335'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '335']" 
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F335-string"/>
        <xsl:call-template name="F335-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '335'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '335-00']" 
        mode="con">
        <xsl:call-template name="F335-concept"/>
    </xsl:template>
    
<!--    <xsl:template match="marc:datafield[@tag = '336']" mode="exp">
        <xsl:call-template name="getmarc"/>
         Accounted for: $a, $b, $2-temporary, $3-partial, $0, $1 
        <!-\-Not accounted for: $2 needs permanent solution, $3 with $0 and $1, $6, $7, $8 -\->
        <xsl:call-template name="F336-xx-ab0-string"/>
        <xsl:call-template name="F336-xx-01-iri"/>
    </xsl:template>-->
    
    <!-- 337 - Media Type -->
    <xsl:template match="marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '337']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F337-string"/>
        <xsl:call-template name="F337-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '337-00']" 
        mode="con">
        <xsl:call-template name="F337-concept"/>
    </xsl:template>
    
    <!-- 338 - Carrier Type -->
    <xsl:template match="marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '338']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F338-string"/>
        <xsl:call-template name="F338-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '338-00']" 
        mode="con">
        <xsl:call-template name="F338-concept"/>
    </xsl:template>
    
    <!-- 340 - Physical Medium -->
    <xsl:template match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '340']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F340-b_f_h_i"/>
        <!-- these fields require lookups or minted concepts -->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
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
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'g'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30456</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'j'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30191</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'k'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30155</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'l'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30309</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'm'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30197</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'n'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30199</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'o'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30196</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'p'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30453</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'q'">
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30263</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q_0_1">
                        <xsl:with-param name="propertyNum">P30304</xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '340-00']"
        mode="con">
        <xsl:call-template name="F340-concept"/>
    </xsl:template>
    
    <!-- 342 - Geospatial Reference Data -->
    <xsl:template match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F342-xx-a-aggWor"/>
        <xsl:call-template name="F342-xx-bcdlmnosvpfijtuw2-aggWor"/>
        <xsl:call-template name="F342-x1-egh-aggWor"/>
        <xsl:call-template name="F342-xx-k-aggWor"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F342-xx-a"/>
        <xsl:call-template name="F342-xx-bcdlmnosvpfijtuw2"/>
        <xsl:call-template name="F342-x1-egh"/>
        <xsl:call-template name="F342-xx-k"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '342'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '342']"
        mode="wor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'q'] and marc:subfield[@code = 'r']">        <rdaw:P10330>
                <xsl:text>Ellipsoid name: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'q']" />
                <xsl:text>. Semi-major axis: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'r']" />
       </rdaw:P10330></xsl:if> 
    </xsl:template>
    
    <!-- 343 - Planar Coordinate Data  -->
    <xsl:template match="marc:datafield[@tag = '343'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '343']"
        mode="aggWor" expand-text="yes">
        <rdawd:P10330>
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
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
    
    <xsl:template match="marc:datafield[@tag = '343'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '343']"
        mode="exp" expand-text="yes">
        <rdaed:P20071>
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
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
    <xsl:template match="marc:datafield[@tag = '344'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '344']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd']| marc:subfield[@code = 'e'] | marc:subfield[@code = 'f'] 
            | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i']">
            <xsl:choose>
                <xsl:when test="@code = 'a'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30172</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'b'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30206</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'c'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30201</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'd'">
                    <xsl:choose>
                        <xsl:when test="(text() = 'fine') or (text() = 'standard')">
                            <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup('rdagrp', .)"/>                                        
                            <xsl:if test="$rdaIRI">
                                <rdam:P30307>
                                    <xsl:attribute name="rdf:resource" select="$rdaIRI"/>
                                </rdam:P30307>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F344-xx-3">
                                        <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="."/>
                                        <xsl:with-param name="value" select="$rdaIRI"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="(text() = 'coarse groove') or (text() = 'microgroove')">
                            <xsl:variable name="rdaIRI" select="uwf:rdaTermLookup('rdagw', .)"/>                                        
                            <xsl:if test="$rdaIRI">
                                <rdam:P30308>
                                    <xsl:attribute name="rdf:resource" select="$rdaIRI"/>
                                </rdam:P30308>
                                <xsl:if test="../marc:subfield[@code = '3']">
                                    <xsl:call-template name="F344-xx-3">
                                        <xsl:with-param name="sub3" select="../marc:subfield[@code = '3']"/>
                                        <xsl:with-param name="subfield" select="."/>
                                        <xsl:with-param name="value" select="$rdaIRI"/>
                                    </xsl:call-template>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                                <xsl:with-param name="propertyNum">P30164</xsl:with-param>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@code = 'e'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30161</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'f'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30185</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'g'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30184</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'h'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30138</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="@code = 'i'">
                    <xsl:call-template name="F344-xx-a_b_c_d_e_f_g_h_i_0_1">
                        <xsl:with-param name="propertyNum">P30454</xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '344'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '344-00']"
        mode="con">
        <xsl:call-template name="F344-concept"/>
    </xsl:template>
    
    <!-- 346 - Video Characteristics -->
    <xsl:template match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '346']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F346-string"/>
        <xsl:call-template name="F346-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '346-00']" 
        mode="con">
        <xsl:call-template name="F346-concept"/>
    </xsl:template>
    
    <!-- 347 - Digital File Characteristics -->
    
    <xsl:template match="marc:datafield[@tag = '347'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '347']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F347-c"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']
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
    
    <xsl:template match="marc:datafield[@tag = '347'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '347-00']"
        mode="con">
        <xsl:call-template name="F347-concept"/>
    </xsl:template>
    
<!-- 351 Organization and Arrangement of Materials--> 
    <xsl:template match="marc:datafield[@tag = '351'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'],1,6) = '351']" mode="wor" expand-text="yes">
        <rdaw:P10084><xsl:for-each select="marc:subfield[@code = 'c'] | marc:subfield[@code = 'a']| marc:subfield[@code = 'b']|marc:subfield[@code = '3']">       
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
        </xsl:for-each> </rdaw:P10084>
    </xsl:template>
    
    <!-- 380 - Form of Work -->
    <xsl:template match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '380']" 
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F380-string"/>
        <xsl:call-template name="F380-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '380-00']" 
        mode="con">
        <xsl:call-template name="F380-concept"/>
    </xsl:template>
    
    
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
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]"/>
                </xsl:if>
            </xsl:variable>
            
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <xsl:variable name="code" select="@code"/>
                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '382')"/>
                    <xsl:if test="$linked880">
                        <xsl:for-each select="$linked880/marc:datafield/marc:subfield[position()][@code = $code]">
                            <xsl:copy-of select="uwf:fillConcept(., '', '', '880')"/>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
