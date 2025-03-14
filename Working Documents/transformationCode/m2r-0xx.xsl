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
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    
    <xsl:include href="m2r-0xx-named.xsl"/> 
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    
    <!-- 020 - International Standard Book Number -->
    <xsl:template match="marc:datafield[@tag = '020'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '020']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}"/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'c']">
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'z'])">
                    <rdamd:P30160>
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </rdamd:P30160>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '020'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '020']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="translate(., ' :', '')"/>
                </rdand:P80068>
                <rdan:P80069 rdf:resource="http://id.loc.gov/vocabulary/identifiers/isbn"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <rdand:P80071>
                        <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                            <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </rdand:P80071>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="translate(., ' :', '')"/>
                </rdand:P80068>
                <rdan:P80069 rdf:resource="http://id.loc.gov/vocabulary/identifiers/isbn"/>
                <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <rdand:P80071>
                        <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                            <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </rdand:P80071>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 024 - Other Standard Identifier -->
    <xsl:template match="marc:datafield[@tag = '024'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '024']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="@ind1 = '8'">
                <xsl:if test="marc:subfield[@code = 'a']">
                    <rdamd:P30004>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    </rdamd:P30004>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="source">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0'">
                            <xsl:value-of select="'isrc'"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '1'">
                            <xsl:value-of select="'upc'"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '2'">
                            <xsl:value-of select="'ismm'"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '3'">
                            <xsl:value-of select="'ean'"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '4'">
                            <xsl:value-of select="'sici'"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '7'">
                            <xsl:if test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
                    <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdamd:P30160>
                <xsl:value-of select="marc:subfield[@code = 'c']"/>
            </rdamd:P30160>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '024'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '024']"
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind1 != '8'">
            <xsl:variable name="source">
                <xsl:choose>
                    <xsl:when test="@ind1 = '0'">
                        <xsl:value-of select="'isrc'"/>
                    </xsl:when>
                    <xsl:when test="../@ind1 = '1'">
                        <xsl:value-of select="'upc'"/>
                    </xsl:when>
                    <xsl:when test="../@ind1 = '2'">
                        <xsl:value-of select="'ismm'"/>
                    </xsl:when>
                    <xsl:when test="../@ind1 = '3'">
                        <xsl:value-of select="'ean'"/>
                    </xsl:when>
                    <xsl:when test="../@ind1 = '4'">
                        <xsl:value-of select="'sici'"/>
                    </xsl:when>
                    <xsl:when test="../@ind1 = '7'">
                        <xsl:if test="../marc:subfield[@code = '2']">
                            <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="."/>
                    </rdand:P80068>
                    <xsl:for-each select="../marc:subfield[@code = 'q']">
                        <rdand:P80071>
                            <xsl:value-of select="."/>
                        </rdand:P80071>
                    </xsl:for-each>
                    <xsl:choose>
                        <xsl:when test="../@ind1 = '0'">
                            <rdan:P80069 rdf:resource="https://id.loc.gov/vocabulary/identifiers/isrc"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '1'">
                            <rdan:P80069 rdf:resource="https://id.loc.gov/vocabulary/identifiers/upc"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '2'">
                            <rdan:P80069 rdf:resource="https://id.loc.gov/vocabulary/identifiers/ismm"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '3'">
                            <rdan:P80069 rdf:resource="https://id.loc.gov/vocabulary/identifiers/ean"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '4'">
                            <rdan:P80069 rdf:resource="https://id.loc.gov/vocabulary/identifiers/sici"/>
                        </xsl:when>
                        <xsl:when test="../@ind1 = '7'">
                            <xsl:if test="../marc:subfield[@code = '2']">
                                <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="@code = 'z'">
                        <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                    </xsl:if>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 026 - Fingerprint Identifier -->
    <xsl:template match="marc:datafield[@tag = '026'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '026']"
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <rdamo:P30296 rdf:resource="{uwf:nomenIRI($baseID, ., ., ../marc:subfield[@code = '2'][1], 'nomen')}"/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'a'] or marc:subfield[@code = 'b'] or marc:subfield[@code = 'c'] or marc:subfield[@code = 'd']">
            <xsl:variable name="fingerprintid">
                <xsl:value-of select="marc:subfield[@code = 'a']|marc:subfield[@code = 'b']|marc:subfield[@code = 'c']|marc:subfield[@code = 'd']"/>
            </xsl:variable>
            <rdamo:P30296 rdf:resource="{uwf:nomenIRI($baseID, ., $fingerprintid, marc:subfield[@code = '2'][1], 'nomen')}"/>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '026'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '026']"
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:variable name="fingerprintid">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']"/>
        </xsl:variable>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., ../marc:subfield[@code = '2'][1], 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="../marc:subfield[@code = '2']">
                    <xsl:copy-of select="uwf:s2Nomen(../marc:subfield[@code = '2'][1])"/>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'a'] or marc:subfield[@code = 'b'] or marc:subfield[@code = 'c'] or marc:subfield[@code = 'd']">
            <xsl:variable name="fingerprintid">
                <xsl:value-of select="marc:subfield[@code = 'a']|marc:subfield[@code = 'b']|marc:subfield[@code = 'c']|marc:subfield[@code = 'd']"/>
            </xsl:variable>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., $fingerprintid, marc:subfield[@code = '2'][1], 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$fingerprintid"/>
                </rdand:P80068>
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'][1])"/>
                </xsl:if>
                <rdand:P80071>
                    <xsl:call-template name="F026-xx-abcd"/>
                </rdand:P80071>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '026'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '026']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdf:Description rdf:about="{uwf:itemIRI($baseIRI, .)}">
                <xsl:call-template name="getmarc"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber, 'ite#', $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 027 - Standard technical report number -->
    <xsl:template match="marc:datafield[@tag = '027'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '027']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '027'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '027']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068><xsl:value-of select="."/></rdand:P80068>
                <xsl:choose>
                    <xsl:when test="contains(., '--')">
                        <rdand:P80069>ISRN</rdand:P80069>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdand:P80069>STRN</rdand:P80069>
                    </xsl:otherwise>
                </xsl:choose>
                <rdand:P80078>Standard Technical Report Number</rdand:P80078>
                <xsl:if test="@code = 'z'">
                    <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                        <rdand:P80071><xsl:value-of select="normalize-space(translate(., '();', ''))"/></rdand:P80071>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
            </xsl:for-each>
    </xsl:template>
    
    <!-- 028 - Publisher or Distributor Number -->
    <xsl:template match="marc:datafield[@tag = '028'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '028']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="@ind1 = '3'">
                <rdamo:P30065 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:when>
            <xsl:when test="@ind1 = '2'">
                <rdamo:P30066 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '028'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '028']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
            <rdand:P80068><xsl:value-of select="marc:subfield[@code = 'a']"/></rdand:P80068>
            <xsl:if test="marc:subfield[@code = 'b']">
                <rdand:P80073><xsl:value-of select="marc:subfield[@code = 'b']"/></rdand:P80073>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'q']">
                <rdand:P80071>
                    <xsl:for-each select="marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdand:P80071>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ind1 = '0'"><rdand:P80078>Issue number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '1'"><rdand:P80078>Matrix number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '2'"><rdand:P80078>Plate number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '4'"><rdand:P80078>Video recording publisher number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '5'"><rdand:P80078>Other publisher number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '6'"><rdand:P80078>Distributor number</rdand:P80078></xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <!-- 030 - CODEN Designation -->
    
    <xsl:template match="marc:datafield[@tag = '030'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '030']" 
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[A-Z]')">
                <rdawd:P10002 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '030'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '030']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[0-9]')">
                <rdamd:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '030'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '030']"
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068><xsl:value-of select="."/></rdand:P80068>
                <rdand:P80069>CODEN</rdand:P80069>
                <xsl:if test="@code = 'z'">
                    <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 034 - Coded Cartographic Mathematical Data -->
    
    <xsl:template match="marc:datafield[@tag = '034'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '034']"
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->       
            <xsl:if test="marc:subfield[@code = 'd'] or marc:subfield[@code = 'e']">
                <rdawd:P10301>
                    <xsl:text>{marc:subfield[@code = 'd']}--{marc:subfield[@code = 'e']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10301>
            </xsl:if>            
            <xsl:if test="marc:subfield[@code = 'f'] or marc:subfield[@code = 'g']">
                <rdawd:P10300>
                    <xsl:text>{marc:subfield[@code = 'f']}--{marc:subfield[@code = 'g']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10300>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'j'] or marc:subfield[@code = 'k']">
                <rdawd:P10303>
                    <xsl:text>{marc:subfield[@code =  'j']}--{marc:subfield[@code = 'k']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10303>
            </xsl:if>           
            <xsl:if test="marc:subfield[@code = 'm'] or marc:subfield[@code = 'n']">
                <rdawd:P10302>
                    <xsl:text>{marc:subfield[@code = 'm']}--{marc:subfield[@code = 'n']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10302>
            </xsl:if>             
            <xsl:if test="marc:subfield[@code = 'p']">
                <rdawd:P10214>
                    <xsl:text>{marc:subfield[@code = 'p']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10214>
            </xsl:if>          
            <xsl:if test="marc:subfield[@code = 's'] or marc:subfield[@code = 't']">
            <rdawd:P10024>
                <xsl:for-each select="marc:subfield[@code = 's'] | marc:subfield[@code = 't']">
                    <xsl:choose>
                        <xsl:when test="@code = 's'">
                            <xsl:text>G-ring latitude: </xsl:text>
                        </xsl:when>
                        <xsl:when test="@code = 't'">
                            <xsl:text>G-ring longitude: </xsl:text>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select="."/>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                    </xsl:if>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdawd:P10024>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'z']">
                <rdawd:P10321>
                    <xsl:text>Name of extraterrestrial body: {marc:subfield[@code = 'z']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                    </xsl:if>
                </rdawd:P10321>
            </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '034'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '034']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F034-xx-abchrxy"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '034'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '034']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F034-xx-abchrxy"/>
    </xsl:template>

    <!-- 043 - Geographic Area Code -->
    <xsl:template match="marc:datafield[@tag = '043']"  
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="gac" select="translate(., '.;,:', '') => normalize-space()"/>
            <xsl:if test="matches($gac, '^[a-z-]*$')">
                <rdawo:P10321 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1]">
                <rdawd:P10321 rdf:resource="{uwf:placeIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1])}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdawd:P10321 rdf:resource="{uwf:placeIRI($baseID, ., ., 'ISO3166')}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:choose>
                <xsl:when test="contains(., 'id.loc.gov/vocabulary/geographicAreas')">
                    <rdawo:P10321 rdf:resource="{.}"/>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/authorities/names/')">
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas(.)"/>
                    <xsl:choose>
                        <xsl:when test="$gac">
                            <rdawo:P10321 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {.}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment>Unable to parse 043 $0 value of {.}</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <xsl:choose>
                <xsl:when test="contains(., 'id.loc.gov/vocabulary/geographicAreas')">
                    <rdawo:P10321 rdf:resource="{.}"/>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/authorities/names/')">
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas(.)"/>
                    <xsl:choose>
                        <xsl:when test="$gac != ''">
                            <rdawo:P10321 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {.}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(., 'id.loc.gov/rwo/')">
                    <xsl:variable name="id">
                        <xsl:variable name="tokenizedIRI" select="tokenize(., '/')"/>
                        <xsl:value-of select="$tokenizedIRI[last()]"/>
                    </xsl:variable>
                    <xsl:variable name="authorityFile" select="concat('http://id.loc.gov/authorities/names/', $id)"/>
                    <xsl:variable name="gac" select="uwf:lcNamesToGeographicAreas($authorityFile)"/>
                    <xsl:choose>
                        <xsl:when test="$gac != ''">
                            <rdawo:P10321 rdf:resource="{concat('http://id.loc.gov/vocabulary/geographicAreas/', replace($gac,'-+$',''))}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:comment>Geographic Area Code could not be retrieved from {$authorityFile}</xsl:comment>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdawo:P10321 rdf:resource="{.}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '043']"
        mode="pla" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1]">
                <rdf:Description rdf:about="{uwf:placeIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1])}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <rdapo:P70020 rdf:resource="{uwf:nomenIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1], 'place')}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdf:Description rdf:about="{uwf:placeIRI($baseID, ., ., 'ISO3166')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                <rdapo:P70020 rdf:resource="{uwf:nomenIRI($baseID, ., ., 'ISO3166', 'place')}"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '043']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1]">
                <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., .,  following-sibling::marc:subfield[@code = '2'][1], 'place')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>{.}</rdand:P80068>
                    <rdand:P80069>{following-sibling::marc:subfield[@code = '2'][1]}</rdand:P80069>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., 'ISO3166', 'place')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>{.}</rdand:P80068>
                <rdan:P80069 rdf:resource="http://purl.org/dc/terms/ISO3166"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 050 - Library of Congress Call Number -->
    <xsl:template match="marc:datafield[@tag = '050']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaw:P10256 rdf:resource="{uwf:conceptIRI('lcc', .)}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '050']" 
        mode="con" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI('lcc', .)}">
                <xsl:copy-of select="uwf:fillClassConcept('lcc', ., ., '050')"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 051 - Library of Congress Copy, Issue, Offprint Statement -->
    <xsl:template match="marc:datafield[@tag = '051']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaw:P10256 rdf:resource="{uwf:conceptIRI('lcc', .)}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '051']" 
        mode="con" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI('lcc', .)}">
                <xsl:copy-of select="uwf:fillClassConcept('lcc', ., ., '051')"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 052 - Geographic Classification -->
    <xsl:template match="marc:datafield[@tag = '052']" 
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:variable name="source">
            <xsl:choose>
                <xsl:when test="@ind1 = ' '">
                    <xsl:value-of select="'lcc'"/>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:value-of select="'sudocs'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'b']">
                <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:variable name="ap">
                        <xsl:value-of select="concat(../marc:subfield[@code = 'a'], .)"/>
                    </xsl:variable>
                    <rdaw:P10321 rdf:resource="{uwf:placeIRI($baseID, ., $ap, $source)}"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10321 rdf:resource="{uwf:placeIRI($baseID, ., marc:subfield[@code = 'a'], $source)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '052']" 
        mode="pla" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="source">
            <xsl:choose>
                <xsl:when test="@ind1 = ' '">
                    <xsl:value-of select="'lcc'"/>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:value-of select="'sudocs'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'b']">
                <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:variable name="ap">
                        <xsl:value-of select="concat(../marc:subfield[@code = 'a'], .)"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:placeIRI($baseID, ., $ap, $source)}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                        <rdapo:P70020 rdf:resource="{uwf:nomenIRI($baseID, ., $ap, $source, 'place')}"/>
                        <xsl:if test="../marc:subfield[@code = 'd'] and count(../marc:subfield[@code = 'b']) = 1">
                            <xsl:for-each select="marc:subfield[@code = 'd']">
                                <rdapo:P70018 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'place')}"/>
                            </xsl:for-each>
                        </xsl:if>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <rdf:Description rdf:about="{uwf:placeIRI($baseID, ., marc:subfield[@code = 'a'], $source)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <rdapo:P70020 rdf:resource="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'a'], $source, 'place')}"/>
                    <xsl:for-each select="marc:subfield[@code = 'd']">
                        <rdapo:P70018 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'place')}"/>
                    </xsl:for-each>
                </rdf:Description>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '052']" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="source">
            <xsl:choose>
                <xsl:when test="@ind1 = ' '">
                    <xsl:value-of select="'lcc'"/>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:value-of select="'sudocs'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'b']">
                <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:variable name="ap">
                        <xsl:value-of select="concat(../marc:subfield[@code = 'a'], .)"/>
                    </xsl:variable>
                    <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., $ap, $source, 'place')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>{$ap}</rdand:P80068>
                        <xsl:copy-of select="uwf:s2NomenClassSchemes($source)"/>
                    </rdf:Description>
                    <xsl:if test="../marc:subfield[@code = 'd'] and count(../marc:subfield[@code = 'b']) = 1">
                        <xsl:for-each select="marc:subfield[@code = 'd']">
                            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'place')}">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                                <rdand:P80068>{.}</rdand:P80068>
                                <xsl:copy-of select="uwf:s2NomenClassSchemes($source)"/>
                            </rdf:Description>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'a'], $source, 'place')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>{marc:subfield[@code = 'a']}</rdand:P80068>
                    <xsl:copy-of select="uwf:s2NomenClassSchemes($source)"/>
                </rdf:Description>
                <xsl:for-each select="marc:subfield[@code = 'd']">
                    <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'place')}">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                        <rdand:P80068>{.}</rdand:P80068>
                        <xsl:copy-of select="uwf:s2NomenClassSchemes($source)"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 055 - Classification Numbers Assigned in Canada -->
    <xsl:template match="marc:datafield[@tag = '055']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="@ind2 = '6' or @ind2 = '7' or @ind2 = '8' or @ind2 = '9'">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2']">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <rdaw:P10256 rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)}"/>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <ex:ERROR>F055 with @ind2 of 6, 7, 8, or 9 missing subfield $2. Field not transformed.</ex:ERROR>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <rdaw:P10256 rdf:resource="{uwf:conceptIRI('lcc', .)}"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '055']" 
        mode="con" expand-text="yes">
        <xsl:choose>
            <xsl:when test="@ind2 = '6' or @ind2 = '7' or @ind2 = '8' or @ind2 = '9'">
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <rdf:Description rdf:about="{uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)}">
                            <xsl:copy-of select="uwf:fillClassConcept(../marc:subfield[@code = '2'][1], ., ., '055')"/>
                        </rdf:Description>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <rdf:Description rdf:about="{uwf:conceptIRI('lcc', .)}">
                        <xsl:copy-of select="uwf:fillClassConcept('lcc', ., ., '055')"/>
                    </rdf:Description>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- 060 - National Library of Medicine Call Number -->
    <xsl:template match="marc:datafield[@tag = '060']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="matches(., '(^Q[S-Z])|(^W)')">
                    <rdaw:P10256 rdf:resource="{uwf:conceptIRI('nlm', .)}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdaw:P10256 rdf:resource="{uwf:conceptIRI('lcc', .)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '060']" 
        mode="con" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI('lcc', .)}">
                <xsl:choose>
                    <xsl:when test="matches(., '(^Q[S-Z])|(^W)')">
                        <xsl:copy-of select="uwf:fillClassConcept('nlm', ., ., '060')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="uwf:fillClassConcept('lcc', ., ., '060')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 074 - GPO Item Number -->
    <xsl:template match="marc:datafield[@tag = '074']" mode="man" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '074']" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdand:P80078>GPO item number</rdand:P80078>
                <xsl:if test="@code = 'z'">
                    <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 080 - Universal Decimal Classification Number -->
    <xsl:template match="marc:datafield[@tag = '080']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:variable name="scheme">
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>UDC; Full</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:text>UDC; Abridged</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>udc</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'x']" separator=""/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10256 rdf:resource="{uwf:conceptIRI($scheme, $ap)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '080']" 
        mode="con" expand-text="yes">
        <xsl:variable name="scheme">
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>UDC; Full</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:text>UDC; Abridged</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>udc</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'x']">
                <xsl:value-of select="translate(., ' ', '')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $ap)}">
                <xsl:copy-of select="uwf:fillClassConcept($scheme, $ap, $ap, '080')"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    
    <!-- 088 - Report number -->
    <xsl:template match="marc:datafield[@tag = '088'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '088']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '088'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '088']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdand:P80078>Report number</rdand:P80078>
            </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdand:P80078>Report number</rdand:P80078>
                <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
