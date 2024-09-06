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
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-2xx-named.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    
    
    <xsl:template match="marc:datafield[@tag = '245']" mode="wor" >
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="isISBD">
            <xsl:choose>
                <xsl:when test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'a']">
                <xsl:for-each select="marc:subfield[@code='a']">
                    <rdawd:P10088>
                        <xsl:choose>
                            <xsl:when test="$isISBD = true()">
                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="uwf:removeBrackets(.)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdawd:P10088>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
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
                <rdawd:P10088>
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="replace($title, '\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdawd:P10088>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>    
    <xsl:template match="marc:datafield[@tag = '245'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '245']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'a']">
                <xsl:call-template name="F245-xx-a"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="F245-xx-notA"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when
                test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
<!--                <xsl:call-template name="F245-xx-ISBD"/>-->
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:call-template name="F245-xx-b-ISBD"/>
                </xsl:if>
                <xsl:call-template name="F245-xx-c-ISBD"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:call-template name="F245-xx-b-notISBD"/>
                </xsl:if>
                <xsl:call-template name="F245-xx-c-notISBD"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="F245-xx-f-g"/>
        <xsl:call-template name="F245-xx-h"/>
        <xsl:call-template name="F245-xx-k"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '257'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '257']"
        mode="man" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30086>
                <xsl:if test="../marc:subfield[@code = '2']">
                    <xsl:copy-of select="uwf:s2lookup(../marc:subfield[@code = '2'][1])"/>
                </xsl:if>{.}</rdamd:P30086>
        </xsl:for-each>
        <!-- this may need to be revisited for determining IRI vs identifier-->
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(../marc:subfield[@code = '1'])">
                <rdam:P30086>{.}</rdam:P30086>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <xsl:choose>
                <xsl:when test="../marc:subfield[@code = '0']">
                    <rdamo:P30086>
                        <rdf:Description rdf:about="{.}">
                            <xsl:for-each select="../marc:subfield[@code = '0']">
                                <rdap:P70057>{.}</rdap:P70057>
                            </xsl:for-each>
                        </rdf:Description>
                    </rdamo:P30086>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- template immediately below, MARC 264:
         all values cocatenated go into RDA "statements";
         if there's isbd punctuation, subfield are not output;
         if there is not isbd punctuation, subfield codes are output.
         If there is a MARC $3, that value is appended to the RDA statement only.
         Repeated subfields and parallel values:
             considered insignificant to the RDA statements as output below.
         After statements are output, templates are called to process individual fields.
    -->
    <xsl:template match="marc:datafield[@tag = '264'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '264']" mode="man origMan">
        <xsl:param name="type"/>
        <xsl:call-template name="getmarc"/>
        <xsl:if test="not(contains($type, 'reproduction'))">
            <xsl:choose>
                <!-- check if ISBD punctuation -->
                <xsl:when
                    test="(substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a')">
                    <xsl:choose>
                        <xsl:when test="@ind2 = '0'">
                            <rdamd:P30110>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30110>
                            <xsl:call-template name="F264-x0-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '1'">
                            <rdamd:P30111>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30111>
                            <xsl:call-template name="F264-x1-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '2'">
                            <rdamd:P30108>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30108>
                            <xsl:call-template name="F264-x2-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '3'">
                            <rdamd:P30109>
                                <xsl:call-template name="F264-xx-abc"/>
                            </rdamd:P30109>
                            <xsl:call-template name="F264-x3-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '4'">
                            <xsl:call-template name="F264-x4-c"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- no ISBD punctuation -->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@ind2 = '0'">
                            <rdamd:P30110>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30110>
                            <xsl:call-template name="F264-x0-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '1'">
                            <rdamd:P30111>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30111>
                            <xsl:call-template name="F264-x1-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '2'">
                            <rdamd:P30108>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30108>
                            <xsl:call-template name="F264-x2-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '3'">
                            <rdamd:P30109>
                                <xsl:call-template name="F264-xx-abc-notISBD"/>
                            </rdamd:P30109>
                            <xsl:call-template name="F264-x3-a_b_c"/>
                        </xsl:when>
                        <xsl:when test="@ind2 = '4'">
                            <xsl:call-template name="F264-x4-c"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <ex:ERROR>F264 IND2 ERROR</ex:ERROR>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
