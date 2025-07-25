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
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    
    <xsl:include href="m2r-0xx-named.xsl"/> 
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    
    <!-- 010 Library of Congress Control Number -->
    
    <xsl:template match="marc:datafield[@tag = '010'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '010']" 
        mode="man" expand-text="yes">
            <xsl:param name="baseID"/>
            <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']| marc:subfield[@code = 'b']| marc:subfield[@code = 'z']">
                <rdam:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'nomen')}"/>
            </xsl:for-each>
        </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '010'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '010']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., '', '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>{replace(replace(., '#', ' '), '\.\s*$', '')}</rdand:P80068>
                <rdand:P80071>Library of Congress control number:<xsl:value-of select="replace(., '#', ' ')"/></rdand:P80071>                   
            </rdf:Description>
        </xsl:for-each>
        
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., '', '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>{replace(replace(., '#', ' '), '\.\s*$', '')}</rdand:P80068>
                <rdand:P80071>National Union Catalog of Manuscript Collections control number:<xsl:value-of select="replace(., '#', ' ')"/>
                </rdand:P80071>                               
            </rdf:Description>
        </xsl:for-each>            
 
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068><xsl:value-of select="replace(., '#', ' ')"/></rdand:P80068>
                <rdand:P80071><xsl:value-of select="replace(., '#', ' ')"/></rdand:P80071>
                <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>

<!-- 013 Patent Control Information -->
    
    <xsl:template match="marc:datafield[@tag = '013'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '013']" 
        mode="wor">
        <rdaw:P10330>
            <xsl:call-template name="F013-xx-abcdef"/>
        </rdaw:P10330>
    </xsl:template>
    
    <!-- 015 National Bibliography Number -->
    <xsl:template match="marc:datafield[@tag = '015'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '015']" 
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="marc:datafield[@tag = '015'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '015']" 
        mode="nom">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="$source">
                    <xsl:sequence select="uwf:s2NationalBibSchemes($source)"/>
                </xsl:if>
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
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = '2'][1]"/>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="$source">
                    <xsl:sequence select="uwf:s2NationalBibSchemes($source)"/>
                </xsl:if>
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
    
    <!-- 016 National Bibliographic Agency Control Number -->
    <xsl:template match="marc:datafield[@tag = '016'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '016']" 
        mode="man">
        <xsl:param name="baseID"/>
 
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '016'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '016']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:variable name="ind1" select="@ind1"/>
        <xsl:variable name="source" select="marc:subfield[@code = '2']"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdan:P80071>
                    <xsl:text>Identifier derived from a National Bibliographic agency control number for a description of this manifestation</xsl:text>
                </rdan:P80071>
                
                <xsl:if test="@code = 'z'">
                    <rdano:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
                
                <!-- this would eventually need to be updated for LC Cultural Heritage Organizations lookup -->
                <rdano:P80075>
                    <xsl:choose>
                        <xsl:when test="$ind1 = '7' and string($source)">
                            <xsl:value-of select="$source"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'http://id.loc.gov/rwo/agents/no2004037399'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdano:P80075>

            </rdf:Description>
        </xsl:for-each>
    </xsl:template>

    <!-- 017 Copyright or Legal Deposit Number -->
    <xsl:template match="marc:datafield[@tag = '017'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '017']" 
        mode="man">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '017'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '017']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:variable name="source" select="marc:subfield[@code = '2']"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="../marc:subfield[@code = 'b'] or $source">
                    <rdan:P80073>
                        <xsl:value-of select="../marc:subfield[@code = 'b']"/>
                        <xsl:if test="string($source) = 'rocgpt'">
                            <xsl:text>R.O.C. Government Publications Catalogue (Taipei: Research, Development and Evaluation Commission, Executive Yuan)</xsl:text>
                        </xsl:if>
                    </rdan:P80073>
                </xsl:if>
                <xsl:if test="../marc:subfield[@code = 'd']"><!-- Date formatted as yyyymmdd -->
                    <rdan:P80066>
                        <xsl:variable name="rawDate" select="string(../marc:subfield[@code = 'd'])"/>
                        <xsl:value-of select="concat(substring($rawDate, 1, 4), '-', substring($rawDate, 5, 2), '-', substring($rawDate, 7, 2))"/>
                    </rdan:P80066>
                </xsl:if>
                <xsl:if test="../marc:subfield[@code = 'i']">
                    <rdan:P80071>
                        <xsl:value-of select="../marc:subfield[@code = 'i']"/>
                    </rdan:P80071>
                </xsl:if>
                <xsl:if test="@code = 'z'">
                    <rdano:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
                <rdand:P80067>
                    <xsl:text>Copyright or legal deposit</xsl:text>
                </rdand:P80067>
                
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>

    <!-- 018 Copyright Article-Fee Code -->
    <xsl:template match="marc:datafield[@tag = '018'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '018']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}"/>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '018'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '018']" 
        mode="nom">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., 'isbn', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="translate(., ' :', '')"/>
                </rdand:P80068>
                <rdan:P80069>
                    <xsl:text>copyright article-fee code</xsl:text>
                </rdan:P80069>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
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
    
    <!-- 033 - Date/Time and Place of an Event WIP  -->
    <xsl:template match="marc:datafield[@tag='033'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '033']" 
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdawo:P10316 rdf:resource="{uwf:placeIRI($baseID, ., ., 'lcco_g')}"/>
            <xsl:if test="following-sibling::marc:subfield[@code = 'c'][1]">
                <rdawo:P10316 rdf:resource="{uwf:placeIRI($baseID, ., ., 'lcco_gcutter')}"/>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:if test="@ind2 = '2' and not(marc:subfield[@code = '2'] or marc:subfield[@code = '0'])">
            <xsl:for-each select="marc:subfield[@code = 'p']">
                <rdawo:P10316>
                    <xsl:value-of select="."/>
                </rdawo:P10316>
             </xsl:for-each>
        </xsl:if>
        
        <xsl:if test="@ind2 = '2' and marc:subfield[@code = '2']">
            <xsl:for-each select="marc:subfield[@code = 'p']">
                <xsl:if test="following-sibling::marc:subfield[@code = '2'][1]">
                    <rdawo:P10316 rdf:resource="{uwf:placeIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1])}"/>
                </xsl:if>
                
            </xsl:for-each>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag='033'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '033']" 
        mode="exp" expand-text="yes">
        
        <xsl:param name="baseID"/>
        
        <!-- check whether there's $a -->
        <xsl:if test="@ind1 = '0|1|2'">
                   
            <!-- output each $a -->
            <!-- date of Capture -->
            <xsl:if test="@ind2 = '0'">
                <xsl:for-each select="marc:subfield[@code = 'a']"><!-- recorded in the pattern yyyymmddhhmm+-hmm -->
                <rdae:P20004>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/><!-- add date handling -->
                </rdae:P20004>
                </xsl:for-each>
            </xsl:if>
                
            <!-- date of Broadcast -->
            <xsl:if test="@ind2 = '1'">
                <xsl:for-each select="marc:subfield[@code = 'a']"><!-- recorded in the pattern yyyymmddhhmm+-hmm -->
                    <rdae:P20214>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/><!-- add date handling -->
                    </rdae:P20214>
                </xsl:for-each>
            </xsl:if>
         </xsl:if>
        
        <!-- place of Capture nomen -->
        <xsl:if test="@ind2 = '0'">
            <xsl:for-each select="marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']">
                <rdae:P20218 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
            </xsl:for-each>
        </xsl:if>
        
        <!-- place of Capture -->
        <xsl:if test="@ind2 = '0' and not(marc:subfield[@code = '2'] or marc:subfield[@code = '0'])">
            <xsl:for-each select="marc:subfield[@code = 'p']">
                <rdaeo:P20218>
                    <xsl:value-of select="."/>
                </rdaeo:P20218>
            </xsl:for-each>
        </xsl:if>
        
        <!-- related place of Broadcast/expression -->
        <xsl:if test="@ind2 = '1' and not(marc:subfield[@code = '2'] or marc:subfield[@code = '0'])">
            <xsl:for-each select="marc:subfield[@code = 'p']">
                <rdaeo:P20306>
                    <xsl:value-of select="."/>
                </rdaeo:P20306>
            </xsl:for-each>
        </xsl:if>
       
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag='033'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '033']" 
        mode="pla" expand-text="yes">
        
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:if test="following-sibling::marc:subfield[@code = 'c'][1]">
                <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., .,  concat(., ' ', following-sibling::marc:subfield[@code = 'c'][1]), 'place')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <rdapo:P70020>
                        <xsl:value-of select="concat(., ' ', following-sibling::marc:subfield[@code = 'c'][1])"/>
                    </rdapo:P70020>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:for-each select="marc:subfield[@code = 'p']">
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1]">
                <rdf:Description rdf:about="{uwf:placeIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1])}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10009"/>
                    <rdapo:P70020 rdf:resource="{uwf:nomenIRI($baseID, ., ., following-sibling::marc:subfield[@code = '2'][1], 'place')}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>                
    
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag='033'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '033']" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        
                 <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:if test="following-sibling::marc:subfield[@code = 'c'][1]">
                        <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., .,  concat(., ' ', following-sibling::marc:subfield[@code = 'c'][1]), 'nomen')}">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                            <rdand:P80068>
                                <xsl:value-of select="concat(., ' ', following-sibling::marc:subfield[@code = 'c'][1])"/>
                            </rdand:P80068>
                            <rdand:P80069><xsl:text>Library of Congress Classification--Class G</xsl:text></rdand:P80069>
                        </rdf:Description>
                    </xsl:if>
                </xsl:for-each>

    </xsl:template>

    <!-- 034 - Coded Cartographic Mathematical Data -->
    
    <xsl:template match="marc:datafield[@tag = '034'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '034']"
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->       
            <xsl:if test="marc:subfield[@code = 'd'] or marc:subfield[@code = 'e']">
                            <rdawd:P10301>
                                <xsl:value-of select="marc:subfield[@code = 'd']"/>
                                
                                <xsl:if test="marc:subfield[@code = 'd'] and marc:subfield[@code = 'e']">
                                    <xsl:text>--</xsl:text>
                                </xsl:if>                               
                                <xsl:value-of select="marc:subfield[@code = 'e']"/>
                                <xsl:if test="marc:subfield[@code = '3']">
                                    <xsl:text> (applies to: </xsl:text>
                                    <xsl:value-of select="marc:subfield[@code = '3']"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:if>
                            </rdawd:P10301>
                 </xsl:if>                         
        
            <xsl:if test="marc:subfield[@code = 'f'] or marc:subfield[@code = 'g']">
                <rdawd:P10300>
                    <xsl:value-of select="marc:subfield[@code = 'f']"/>                
                    <xsl:if test="marc:subfield[@code = 'f'] and marc:subfield[@code = 'g']">
                        <xsl:text>--</xsl:text>
                    </xsl:if>                               
                    <xsl:value-of select="marc:subfield[@code = 'g']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdawd:P10300>
            </xsl:if>
        
            <xsl:if test="marc:subfield[@code = 'j'] or marc:subfield[@code = 'k']">
                <rdawd:P10303>
                    <xsl:value-of select="marc:subfield[@code = 'j']"/>
                    <xsl:if test="marc:subfield[@code = 'j'] and marc:subfield[@code = 'k']">
                        <xsl:text>--</xsl:text>
                    </xsl:if>                               
                    <xsl:value-of select="marc:subfield[@code = 'k']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdawd:P10303>
            </xsl:if>         
        
            <xsl:if test="marc:subfield[@code = 'm'] or marc:subfield[@code = 'n']">
                <rdawd:P10302>
                    <xsl:value-of select="marc:subfield[@code = 'm']"/>
                    <xsl:if test="marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
                        <xsl:text>--</xsl:text>
                    </xsl:if>                               
                    <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdawd:P10302>
            </xsl:if>           
        
            <xsl:if test="marc:subfield[@code = 'p']">
                <rdawd:P10214>
                    <xsl:text>{marc:subfield[@code = 'p']}</xsl:text>
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
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
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
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
                    <xsl:if test="../marc:subfield[@code = '3']">
                        <xsl:text> (applies to: </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
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

    <!-- 035 - System Control Number  -->
    <xsl:template match="marc:datafield[@tag = '035'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '035']" 
        mode="man">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '035'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '035']" 
        mode="nom">
        <xsl:param name="baseID"/>
        
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                
                <xsl:if test="@code = 'z'">
                    <rdano:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
                
                <rdan:P80071>
                    <xsl:text>System control number</xsl:text>
                </rdan:P80071>
 
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>

    <!-- 041 - Language Code -->
    <!-- WORK -->
    <xsl:template match="marc:datafield[@tag = '041'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '041']" 
        mode="aggWor" expand-text="yes">
        <xsl:param name="baseID"/>
        
        <!-- Row 39: Map each language code in $a as separate element value (aggWor) -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/languages/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/languages/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 40: Map each language code in $a as separate element value when $2=iso (aggWor) -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 41: Map each language code in $a as separate element value when $2 is present but NOT iso -->
        <xsl:if test="marc:subfield[@code = '2'] and not(starts-with(marc:subfield[@code = '2'], 'iso'))">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdawo:P10353 rdf:resource="{uwf:conceptIRI($sub2, normalize-space(.))}"/>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 42: Map each language code in $a as separate element value when Ind2 is not blank and no $2 -->
        <xsl:if test="@ind2 = '7' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawd:P10353><xsl:value-of select="."/></rdawd:P10353>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawd:P10353><xsl:value-of select="normalize-space(.)"/></rdawd:P10353>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 44: Map each language code in $d as separate element value, no $2 -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/languages/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/languages/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 45: Map each language code in $d as separate element value when $2=iso -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawo:P10353 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>        

        <!-- Row 46: Map each language code in $d as separate element value when $2 is present but NOT iso -->
        <xsl:if test="marc:subfield[@code = '2'] and not(starts-with(marc:subfield[@code = '2'], 'iso'))">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <rdawo:P10353 rdf:resource="{uwf:conceptIRI($sub2, normalize-space(.))}"/>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 47: Map each language code in $d as separate element value when Ind2 is not blank and no $2 -->
        <xsl:if test="@ind2 = '7' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdawd:P10353><xsl:value-of select="."/></rdawd:P10353>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdawd:P10353><xsl:value-of select="normalize-space(.)"/></rdawd:P10353>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
        
        <!-- Row 51: Note for subfield $a - Language of text/sound track or separate title, no $2 -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'a']">
                <rdawd:P10330>
                    <xsl:text>Language of text/sound track or separate title: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'a']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 52: Note for subfield $a - Language of text/sound track or separate title with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'a']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of text/sound track or separate title: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 53: Note for subfield $d - Language code of sung or spoken text, no $2 -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'd']">
                <rdawd:P10330>
                    <xsl:text>Language code of sung or spoken text: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'd']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 54: Note for subfield $d - Language code of sung or spoken text with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'd']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language code of sung or spoken text: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'd']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 56: Note for subfield $b - Language of summary or abstract -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'b']">
                <rdawd:P10330>
                    <xsl:text>Language of summary or abstract: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'b']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 57: Note for subfield $b - Language of summary or abstract with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of summary or abstract: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 58: Note for subfield $e - Language of librettos -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'e']">
                <rdawd:P10330>
                    <xsl:text>Language of librettos: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'e']">
                            <!-- Process multiple 3-letter codes in single subfield -->
                            <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                            <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                <xsl:if test="matches(., '^[a-z]{3}$')">
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 59: Note for subfield $e - Language of librettos with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'e']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of librettos: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 60: Note for subfield $f - Language of table of contents -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'f']">
                <rdawd:P10330>
                    <xsl:text>Language of table of contents: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'f']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 61: Note for subfield $f - Language of table of contents with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'f']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of table of contents: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'f']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 62: Note for subfield $g - Language of accompanying material other than librettos and transcripts -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'g']">
                <rdawd:P10330>
                    <xsl:text>Language of accompanying material other than librettos and transcripts: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'g']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 63: Note for subfield $g - Language of accompanying material other than librettos and transcripts with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'g']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of accompanying material other than librettos and transcripts: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'g']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 64: Note for subfield $i - Language of intertitles -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'i']">
                <rdawd:P10330>
                    <xsl:text>Language of intertitles: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'i']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 65: Note for subfield $i - Language of intertitles with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'i']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of intertitles: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'i']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 66: Note for subfield $j - Language of subtitles -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'j']">
                <rdawd:P10330>
                    <xsl:text>Language of subtitles: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'j']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 67: Note for subfield $j - Language of subtitles with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'j']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of subtitles: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 68: Note for subfield $p - Language of captions -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'p']">
                <rdawd:P10330>
                    <xsl:text>Language of captions: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'p']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 69: Note for subfield $p - Language of captions with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'p']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of captions: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'p']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 70: Note for subfield $q - Language of accessible audio -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'q']">
                <rdawd:P10330>
                    <xsl:text>Language of accessible audio: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'q']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 71: Note for subfield $q - Language of accessible audio with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'q']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of accessible audio: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'q']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 72: Note for subfield $r - Language of accessible visual language (non-textual) -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 'r']">
                <rdawd:P10330>
                    <xsl:text>Language of accessible visual language (non-textual): </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 'r']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 73: Note for subfield $r - Language of accessible visual language (non-textual) with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'r']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of subtitles: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'r']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 74: Note for subfield $t - Language of accompanying transcripts for audiovisual materials -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:if test="marc:subfield[@code = 't']">
                <rdawd:P10330>
                    <xsl:text>Language of accompanying transcripts for audiovisual materials: </xsl:text>
                    <xsl:variable name="allIris">
                        <xsl:for-each select="marc:subfield[@code = 't']">
                            <!-- Check if the value length is divisible by 3 -->
                            <xsl:choose>
                                <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                    <!-- Process multiple 3-letter codes in single subfield -->
                                    <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                    <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                        <xsl:if test="matches(., '^[a-z]{3}$')">
                                            <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- When value is not divisible by 3, treat entire value as single language code -->
                                    <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                                    <xsl:text> </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

        <!-- Row 75: Note for subfield $t - Language of accompanying transcripts for audiovisual materials with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 't']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdawd:P10330>
                    <xsl:text>Language of accompanying transcripts for audiovisual materials: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 't']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdawd:P10330>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <!-- EXPRESSION -->
    <xsl:template match="marc:datafield[@tag = '041'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '041']" 
        mode="exp" expand-text="yes">
        <xsl:param name="baseID"/>

        <!-- Row 4: Ind1=1 for seWor/augWor - Category of expression -->
        <xsl:if test="@ind1 = '1'">
            <rdaed:P20331>Translation</rdaed:P20331>
        </xsl:if>
        
        <!-- Row 5: $h for seWor/augWor - Category of expression -->
        <xsl:if test="marc:subfield[@code = 'h']">
            <rdaed:P20331>Translation</rdaed:P20331>
        </xsl:if>
        
        <!-- Row 6: $k for seWor/augWor - Category of expression -->
        <xsl:if test="marc:subfield[@code = 'k']">
            <rdaed:P20331>Translation</rdaed:P20331>
        </xsl:if>
        
        <!-- Row 8: Map each language code in $a as separate element value (seWor/augWor) -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/languages/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/languages/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
        
        <!-- Row 9: Map each language code in $a as separate element value when $2=iso (seWor/augWor) -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 10: Map each language code in $a as separate element value when $2 is present but NOT iso -->
        <xsl:if test="marc:subfield[@code = '2'] and not(starts-with(marc:subfield[@code = '2'], 'iso'))">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdaeo:P20006 rdf:resource="{uwf:conceptIRI($sub2, normalize-space(.))}"/>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 11: Map each language code in $a as separate element value when Ind2 is not blank and no $2 -->
        <xsl:if test="@ind2 = '7' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaed:P20006><xsl:value-of select="."/></rdaed:P20006>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaed:P20006><xsl:value-of select="normalize-space(.)"/></rdaed:P20006>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 13: Map each language code in $d as separate element value (seWor/augWor) -->
        <xsl:if test="@ind2 = ' ' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/languages/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/languages/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 14: Map each language code in $d as separate element value when $2=iso (seWor/augWor) -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{.}"/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaeo:P20006 rdf:resource="http://id.loc.gov/vocabulary/{$subfield2Value}/{normalize-space(.)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>        

        <!-- Row 15: Map each language code in $d as separate element value when $2 is present but NOT iso -->
        <xsl:if test="marc:subfield[@code = '2'] and not(starts-with(marc:subfield[@code = '2'], 'iso'))">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <rdaeo:P20006 rdf:resource="{uwf:conceptIRI($sub2, normalize-space(.))}"/>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 16: Map each language code in $d as separate element value when Ind2 is not blank and no $2 -->
        <xsl:if test="@ind2 = '7' and not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = 'd']">
                <!-- Check if the value length is divisible by 3 -->
                <xsl:choose>
                    <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                        <!-- Process multiple 3-letter codes in single subfield -->
                        <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                        <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                            <xsl:if test="matches(., '^[a-z]{3}$')">
                                <rdaed:P20006><xsl:value-of select="."/></rdaed:P20006>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- When value is not divisible by 3, treat entire value as single language code -->
                        <rdaed:P20006><xsl:value-of select="normalize-space(.)"/></rdaed:P20006>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>

        <!-- Row 19: Note for subfield $a - Language of text/sound track or separate title, no $2 -->
        <xsl:if test="(@ind2 = ' ' and not(marc:subfield[@code = '2']))">
            <xsl:if test="marc:subfield[@code = 'a']">
                <rdaed:P20071>
                    <xsl:text>Language of text/sound track or separate title: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 20: Note for subfield $a - Language of text/sound track or separate title with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'a']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdaed:P20071>
                    <xsl:text>Language of text/sound track or separate title: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'a']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 21: Note for subfield $d - Language code of sung or spoken text, no $2 -->
        <xsl:if test="(@ind2 = ' ' and not(marc:subfield[@code = '2']))">
            <xsl:if test="marc:subfield[@code = 'd']">
                <rdaed:P20071>
                    <xsl:text>Language code of sung or spoken text: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'd']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 22: Note for subfield $d - Language code of sung or spoken text with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'd']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdaed:P20071>
                    <xsl:text>Language code of sung or spoken text: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'd']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 24: Note for subfield $h - Language of original, no $2 -->
        <xsl:if test="(@ind2 = ' ' and not(marc:subfield[@code = '2']))">
            <xsl:if test="marc:subfield[@code = 'h']">
                <rdaed:P20071>
                    <xsl:text>Language of original: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'h']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 25: Note for subfield $h - Language of original with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'h']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdaed:P20071>
                    <xsl:text>Language of original: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'h']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 26: Note for subfield $n - Language of original libretto, no $2 -->
        <xsl:if test="(@ind2 = ' ' and not(marc:subfield[@code = '2']))">
            <xsl:if test="marc:subfield[@code = 'n']">
                <rdaed:P20071>
                    <xsl:text>Language of original libretto: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'n']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 27: Note for subfield $n - Language of original libretto with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'n']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdaed:P20071>
                    <xsl:text>Language of original libretto: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'n']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 28: Note for subfield $k - Language of intermediate translations, no $2 -->
        <xsl:if test="(@ind2 = ' ' and not(marc:subfield[@code = '2']))">
            <xsl:if test="marc:subfield[@code = 'k']">
                <rdaed:P20071>
                    <xsl:text>Language of intermediate translations: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'k']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

        <!-- Row 29: Note for subfield $k - Language of intermediate translations with $2 -->
        <xsl:if test="marc:subfield[@code = '2'] and starts-with(marc:subfield[@code = '2'], 'iso')">
            <xsl:if test="marc:subfield[@code = 'k']">
                <xsl:variable name="subfield2Value" select="marc:subfield[@code = '2']"/>
                <rdaed:P20071>
                    <xsl:text>Language of intermediate translations: </xsl:text>
                    <xsl:for-each select="marc:subfield[@code = 'k']">
                        <!-- Check if the value length is divisible by 3 -->
                        <xsl:choose>
                            <xsl:when test="string-length(normalize-space(.)) mod 3 = 0">
                                <!-- Process multiple 3-letter codes in single subfield -->
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                        <xsl:if test="not(position() = last())">
                                            <xsl:text> and </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- When value is not divisible by 3, treat entire value as single language code -->
                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', normalize-space(.))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="not(position() = last())">
                            <xsl:text> and </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>

    </xsl:template>

    <!-- MANIFESTATION -->
    <xsl:template match="marc:datafield[@tag = '041'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '041']" 
        mode="man" expand-text="yes">
        <!-- Row 49: $3 note for aggWor mode - Process each $3 subfield separately -->
        <xsl:for-each select="marc:subfield[@code = '3']">
            <xsl:variable name="materialType" select="."/>
            <xsl:variable name="formattedMaterialType" select="concat(upper-case(substring(., 1, 1)), substring(., 2))"/>
            <xsl:variable name="cleanMaterialType" select="replace($formattedMaterialType, '^code\s+', '')"/>
            <xsl:variable name="parentContext" select=".."/>
            
            <!-- Process each subfield type separately (excluding translation codes $h, $k, $n) -->
            <xsl:for-each select="('a', 'd', 'b', 'e', 'f', 'g', 'i', 'j', 'p', 'q', 'r', 't')">
                <xsl:variable name="subfieldCode" select="."/>
                <xsl:variable name="subfieldValues" select="$parentContext/marc:subfield[@code = $subfieldCode]"/>
                
                <xsl:if test="$subfieldValues">
                    
                    <!-- Get subfield label -->
                    <xsl:variable name="subfieldLabel">
                        <xsl:choose>
                            <xsl:when test="$subfieldCode = 'a'">Language of text/sound track or separate title</xsl:when>
                            <xsl:when test="$subfieldCode = 'd'">Language of text/sound track or separate title</xsl:when>
                            <xsl:when test="$subfieldCode = 'b'">Language of summary or abstract</xsl:when>
                            <xsl:when test="$subfieldCode = 'e'">Language of librettos</xsl:when>
                            <xsl:when test="$subfieldCode = 'f'">Language of table of contents</xsl:when>
                            <xsl:when test="$subfieldCode = 'g'">Language of accompanying material other than librettos and transcripts</xsl:when>
                            <xsl:when test="$subfieldCode = 'i'">Language of intertitles</xsl:when>
                            <xsl:when test="$subfieldCode = 'j'">Language of subtitles</xsl:when>
                            <xsl:when test="$subfieldCode = 'p'">Language of captions</xsl:when>
                            <xsl:when test="$subfieldCode = 'q'">Language of accessible audio</xsl:when>
                            <xsl:when test="$subfieldCode = 'r'">Language of accessible visual content</xsl:when>
                            <xsl:when test="$subfieldCode = 't'">Language of accompanying transcripts for audiovisual materials</xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    
                    <!-- Collect all IRIs for this subfield type -->
                    <xsl:variable name="iris">
                        <xsl:variable name="subfield2Value" select="$parentContext/marc:subfield[@code = '2']"/>
                        <xsl:variable name="allIris">
                            <xsl:for-each select="$subfieldValues">
                                <xsl:variable name="codes" select="replace(., '([a-z]{3})', '$1 ')"/>
                                <xsl:for-each select="tokenize(normalize-space($codes), '\s+')">
                                    <xsl:if test="matches(., '^[a-z]{3}$')">
                                        <xsl:choose>
                                            <xsl:when test="$subfield2Value and starts-with($subfield2Value, 'iso')">
                                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/', $subfield2Value, '/', .)"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('http://id.loc.gov/vocabulary/languages/', .)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:value-of select="string-join(tokenize(normalize-space($allIris), '\s+'), ' + ')"/>
                    </xsl:variable>
                    
                    <!-- Create the note -->
                    <xsl:if test="string-length($iris) > 0">
                        <rdamd:P30137><xsl:value-of select="concat($cleanMaterialType, ' has ', $subfieldLabel, ': ', $iris)"/></rdamd:P30137>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <!-- CONCEPT -->
    <!-- Rows 10, 15, 41, 46 -->
    <xsl:template match="marc:datafield[@tag = '041'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '041']" 
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2'] and not(starts-with(marc:subfield[@code = '2'], 'iso'))">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '041')"/>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
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

    <!-- 046 Special Coded Dates - Row 12: $a=q (questionable date), Row 14: $a=i (inclusive dates), Row 29: $a=k (bulk of collection), Row 30: $a=m (multipart publication) -->
    
    <!--WORK-->
    <xsl:template match="marc:datafield[@tag = '046'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '046']" 
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        
        <!-- Row 32: When indicator 1 = 1 (Work) and subfields $j and $2 are present (date of last update) -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = 'j'] and marc:subfield[@code = '2']">
            <rdawo:P10219 rdf:resource="{uwf:timespanIRI($baseID, ., 'work-lastupdate')}"/>
        </xsl:if>
        
        <!-- Row 35: When subfields $k and $l are present (range of creation dates) -->
        <xsl:if test="marc:subfield[@code = 'k'] and marc:subfield[@code = 'l']">
            <rdawo:P10317 rdf:resource="{uwf:timespanIRI($baseID, ., 'creation-range')}"/>
        </xsl:if>
        
        <!-- Row 37: When indicator 1 = 1 (Work) and subfields $m and $n are present -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
            <rdawo:P10317 rdf:resource="{uwf:timespanIRI($baseID, ., 'work-validity-span')}"/>
        </xsl:if>

        <!-- Row 40: When $o and $p are present -->
        <xsl:if test="marc:subfield[@code = 'o'] and marc:subfield[@code = 'p']">
            <rdawo:P10317 rdf:resource="{uwf:timespanIRI($baseID, ., 'original-release')}"/>
        </xsl:if>

        <!-- Row 44: When indicator 1 = 1 (Work) and date subfields are present -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]">
            <rdawd:P10317>
                <xsl:value-of select="marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]" separator=" "/>
            </rdawd:P10317>
        </xsl:if>

        <!-- Row 56: Beginning date -->
        <xsl:if test="marc:subfield[@code = 'k']">
            <rdawd:P10219>
                <xsl:text>Beginning or single date created: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'k']"/>
            </rdawd:P10219>
        </xsl:if>

        <!-- Row 57: Ending date -->
        <xsl:if test="marc:subfield[@code = 'l']">
            <rdawd:P10219>
                <xsl:text>Ending date created: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'l']"/>
            </rdawd:P10219>
        </xsl:if>

        <!-- Row 59 -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = 'm']">
            <rdawd:P10330>
                <xsl:text>Beginning of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'm']"/>
            </rdawd:P10330>
        </xsl:if>

        <!-- Row 63 -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = 'n']">
            <rdawd:P10330>
                <xsl:text>End of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'n']"/>
            </rdawd:P10330>
        </xsl:if>

        <!-- Row 66 -->
        <xsl:if test="marc:subfield[@code = 'o']">
            <rdawd:P10219>
                <xsl:text>Single or starting date for aggregated content: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'o']"/>
            </rdawd:P10219>
        </xsl:if>

        <!-- Row 67 -->
        <xsl:if test="marc:subfield[@code = 'p']">
            <rdawd:P10219>
                <xsl:text>Ending date for aggregated content: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'p']"/>
            </rdawd:P10219>
        </xsl:if>

        <!-- Row 78 -->
        <xsl:if test="@ind1 = '1' and marc:subfield[@code = '3']">
            <rdawd:P10403>
                <xsl:text>applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
            </rdawd:P10403>
        </xsl:if>

    </xsl:template>

    <!--EXPRESSION-->
    <xsl:template match="marc:datafield[@tag = '046'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '046']" 
        mode="exp" expand-text="yes">
        <xsl:param name="baseID"/>
        
        <!-- Row 33: When indicator 1 = 2 (Expression) and subfields $j and $2 are present (date of last update) -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = 'j'] and marc:subfield[@code = '2']">
            <rdaeo:P20214 rdf:resource="{uwf:timespanIRI($baseID, ., 'expression-lastupdate')}"/>
        </xsl:if>
        
        <!-- Row 38: When indicator 1 = 2 (Expression) and subfields $m and $n are present -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
            <rdaeo:P20307 rdf:resource="{uwf:timespanIRI($baseID, ., 'expression-validity-span')}"/>
        </xsl:if>

        <!-- Row 41: When indicator 1 = 2 (Expression) and date subfields are present -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]">
            <rdaed:P20307>
                <xsl:value-of select="marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]" separator=" "/>
            </rdaed:P20307>
        </xsl:if>

        <!-- Row 60 -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = 'm']">
            <rdaed:P20071>
                <xsl:text>Beginning of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'm']"/>
            </rdaed:P20071>
        </xsl:if>

        <!-- Row 64 -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = 'n']">
            <rdaed:P20071>
                <xsl:text>End of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'n']"/>
            </rdaed:P20071>
        </xsl:if>
    
    </xsl:template>
    
    <!--MANIFESTATION-->
    <xsl:template match="marc:datafield[@tag = '046'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '046']" 
        mode="man" expand-text="yes">
        <xsl:param name="baseID"/>

        <!-- Row 12: When $a = 'q' and date subfields are present (questionable date) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'q' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'questionable')}"/>
        </xsl:if>
        
        <!-- Row 14: When $a = 'i' and date subfields are present (inclusive dates) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'i' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'inclusive')}"/>
        </xsl:if>
        
        <!-- Row 29: When $a = 'k' and date subfields are present (range of years of bulk of collection) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'k' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'bulk')}"/>
        </xsl:if>
        
        <!-- Row 30: When $a = 'm' and date subfields are present (range of years of publication of multipart item) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'm' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'multipart')}"/>
        </xsl:if>
        
        <!-- Row 31: When indicator 1 = # (blank) and subfields $j and $2 are present (date of last update) -->
        <xsl:if test="@ind1 = ' ' and marc:subfield[@code = 'j'] and marc:subfield[@code = '2']">
            <rdamo:P30278 rdf:resource="{uwf:timespanIRI($baseID, ., 'lastupdate')}"/>
        </xsl:if>
        
        <!-- Row 34: When indicator 1 = 3 (Manifestation) and subfields $j and $2 are present (date of last update) -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = 'j'] and marc:subfield[@code = '2']">
            <rdamo:P30278 rdf:resource="{uwf:timespanIRI($baseID, ., 'manifestation-lastupdate')}"/>
        </xsl:if>
        
        <!-- Row 36: When indicator 1 = # (blank) and subfields $m and $n are present (date span for validity) -->
        <xsl:if test="@ind1 = ' ' and marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'validity-span')}"/>
        </xsl:if>
        
        <!-- Row 39: When indicator 1 = 3 (Manifestation) and subfields $m and $n are present -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
            <rdamo:P30273 rdf:resource="{uwf:timespanIRI($baseID, ., 'manifestation-validity-span')}"/>
        </xsl:if>

        <!-- Row 42: When indicator 1 = 3 (Manifestation) and date subfields are present -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]">
            <rdamd:P20307>
                <xsl:value-of select="marc:subfield[@code = ('b','c','d','e','k','l','m','n','o','p')]" separator=" "/>
            </rdamd:P20307>
        </xsl:if>

        <!-- Row 43: When $a = 't' and subfields $d and $e are present (copyright date) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 't' and marc:subfield[@code = ('d','e')]">
            <rdamd:P30007>
                <xsl:text>Date of publication/release/production/execution: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'd']"/>
                <xsl:text>; Copyright date: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'e']"/>
            </rdamd:P30007>
        </xsl:if>

        <!-- Row 46: type of date code -->
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdamd:P30137>
                <xsl:value-of select="concat('Type of date code: ', marc:subfield[@code = 'a'])"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 47 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'r' and marc:subfield[@code = ('b', 'c')]">
            <rdamd:P30278>
                <xsl:text>Reprint/reissue date: </xsl:text>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'b']">
                        <xsl:value-of select="marc:subfield[@code = 'b']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'c']">
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 48 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'r' and marc:subfield[@code = ('d', 'e')]">
            <rdamd:P30278>
                <xsl:text>Original date: </xsl:text>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'd']">
                        <xsl:value-of select="marc:subfield[@code = 'd']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'e']">
                        <xsl:value-of select="marc:subfield[@code = 'e']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 49 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 's' and marc:subfield[@code = ('b', 'c')]">
            <rdamd:P30278>
                <xsl:text>Single date of distribution, publication, release, production, execution, writing, or a probable date: </xsl:text>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'b']">
                        <xsl:value-of select="marc:subfield[@code = 'b']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'c']">
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 50 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'p' and marc:subfield[@code = ('b', 'c')]">
            <rdamd:P30278>
                <xsl:text>Date of distribution/release/issue: </xsl:text>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'b']">
                        <xsl:value-of select="marc:subfield[@code = 'b']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'c']">
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 51 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'p' and marc:subfield[@code = ('d', 'e')]">
            <rdamd:P30009>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'd']">
                        <xsl:value-of select="marc:subfield[@code = 'd']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'e']">
                        <xsl:value-of select="marc:subfield[@code = 'e']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30009>
        </xsl:if>

        <!-- Row 52 -->
        <xsl:if test="marc:subfield[@code = 'a'] = 't' and marc:subfield[@code = ('b', 'c')]">
            <rdamd:P30278>
                <xsl:text>Date of publication/release/production/execution: </xsl:text>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = 'b']">
                        <xsl:value-of select="marc:subfield[@code = 'b']"/>
                        <xsl:text>B.C.E.</xsl:text>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = 'c']">
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </xsl:when>
                </xsl:choose>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 53: incorrect first date -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'x' and marc:subfield[@code = 'c']">
            <rdamd:P30278>
                <xsl:text>Incorrect date 1: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'c']"/>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 54: incorrect second date -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'x' and marc:subfield[@code = 'e']">
            <rdamd:P30278>
                <xsl:text>Incorrect date 2: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'e']"/>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 54: incorrect second date -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'x' and marc:subfield[@code = 'e']">
            <rdamd:P30278>
                <xsl:text>Incorrect date 2: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'e']"/>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 55: dates unknown -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'n' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <rdamd:P30278>
                <xsl:text>Dates unknown</xsl:text>
            </rdamd:P30278>
        </xsl:if>

        <!-- Row 58 -->
        <xsl:if test="not(@ind1 = '1' or @ind1 = '2' or @ind1 = '3') and marc:subfield[@code = 'm']">
            <rdamd:P30137>
                <xsl:text>Beginning of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'm']"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 61 -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = 'm']">
            <rdamd:P30137>
                <xsl:text>Beginning of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'm']"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 62 -->
        <xsl:if test="not(@ind1 = '1' or @ind1 = '2' or @ind1 = '3') and marc:subfield[@code = 'n']">
            <rdamd:P30137>
                <xsl:text>End of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'n']"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 65 -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = 'n']">
            <rdamd:P30137>
                <xsl:text>End of date valid: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'n']"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 77 -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = '3']">
            <rdamd:P30137>
                <xsl:text>applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
            </rdamd:P30137>
        </xsl:if>

        <!-- Row 80 -->
        <xsl:if test="@ind1 = '3' and marc:subfield[@code = '3']">
            <rdamd:P30137>
                <xsl:text>applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
            </rdamd:P30137>
        </xsl:if>

    </xsl:template>
    
    <!--TIMESPAN-->
    <xsl:template match="marc:datafield[@tag = '046'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '046']" 
        mode="tim" expand-text="yes">
        <xsl:param name="baseID"/>

        <!-- Row 12: When $a = 'q' and date subfields are present (questionable date) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'q' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <xsl:call-template name="F0046-timespan">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="suffix" select="'questionable'"/>
                <xsl:with-param name="note" select="'Questionable date'"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Row 14: When $a = 'i' and date subfields are present (inclusive dates) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'i' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <xsl:call-template name="F0046-timespan">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="suffix" select="'inclusive'"/>
                <xsl:with-param name="note" select="'Collection inclusive dates'"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Row 29: When $a = 'k' and date subfields are present (range of years of bulk of collection) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'k' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <xsl:call-template name="F0046-timespan">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="suffix" select="'bulk'"/>
                <xsl:with-param name="note" select="'Range of years of bulk of collection'"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Row 30: When $a = 'm' and date subfields are present (range of years of publication of multipart item) -->
        <xsl:if test="marc:subfield[@code = 'a'] = 'm' and (marc:subfield[@code = 'b' or @code = 'c'] or marc:subfield[@code = 'd' or @code = 'e'])">
            <xsl:call-template name="F0046-timespan">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="suffix" select="'multipart'"/>
                <xsl:with-param name="note" select="'Range of years of publication'"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Consolidated timespan creation for $j and $2 subfields (Rows 31, 32, 33, 34) -->
        <xsl:if test="marc:subfield[@code = 'j'] and marc:subfield[@code = '2']">
            <!-- Create the nomen resource once since it's identical for all cases -->
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'j'], marc:subfield[@code = '2'], 'timespan')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068><xsl:value-of select="marc:subfield[@code = 'j']"/></rdand:P80068>
                <rdand:P80069>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <xsl:value-of select="marc:subfield[@code = '2']"/>
                        </xsl:when>
                        <xsl:otherwise>Representations of Dates and Times (ISO 8601)</xsl:otherwise>
                    </xsl:choose>
                </rdand:P80069>
            </rdf:Description>
            
            <!-- Row 31: Manifestation timespan (when no specific indicator) -->
            <xsl:if test="not(@ind1 = '1' or @ind1 = '2' or @ind1 = '3')">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'lastupdate')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdato:P70016 rdf:resource="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'j'], marc:subfield[@code = '2'], 'timespan')}"/>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 32: Work timespan (indicator 1 = 1) -->
            <xsl:if test="@ind1 = '1'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'work-lastupdate')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdato:P70016 rdf:resource="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'j'], marc:subfield[@code = '2'], 'timespan')}"/>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 33: Expression timespan (indicator 1 = 2) -->
            <xsl:if test="@ind1 = '2'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'expression-lastupdate')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdato:P70016 rdf:resource="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'j'], marc:subfield[@code = '2'], 'timespan')}"/>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 34: Manifestation timespan (indicator 1 = 3) -->
            <xsl:if test="@ind1 = '3'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'manifestation-lastupdate')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdato:P70016 rdf:resource="{uwf:nomenIRI($baseID, ., marc:subfield[@code = 'j'], marc:subfield[@code = '2'], 'timespan')}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:if>
        
        <!-- Row 35: Work creation range timespan (subfields $k and $l) -->
        <xsl:if test="marc:subfield[@code = 'k'] and marc:subfield[@code = 'l']">
            <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'creation-range')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                <rdatd:P70016>
                    <xsl:value-of select="marc:subfield[@code = 'k']"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'l']"/>
                </rdatd:P70016>
                <rdatd:P70045>Range on which a resource has been created</rdatd:P70045>
                <rdatd:P70039>
                    <xsl:value-of select="marc:subfield[@code = 'k']"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:value-of select="marc:subfield[@code = 'l']"/>
                </rdatd:P70040>
            </rdf:Description>
        </xsl:if>
        
        <!-- Consolidated timespan creation for $m and $n subfields (Rows 36, 37, 38, 39) -->
        <xsl:if test="marc:subfield[@code = 'm'] and marc:subfield[@code = 'n']">
            <!-- Row 36: Manifestation timespan (when no specific indicator) -->
            <xsl:if test="not(@ind1 = '1' or @ind1 = '2')">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'validity-span')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdatd:P70016>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70016>
                    <rdatd:P70045>Date span for the validity of a resource</rdatd:P70045>
                    <rdatd:P70039>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                    </rdatd:P70039>
                    <rdatd:P70040>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70040>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 37: Work timespan (indicator 1 = 1) -->
            <xsl:if test="@ind1 = '1'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'work-validity-span')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdatd:P70016>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70016>
                    <rdatd:P70045>Date span for the validity of a resource</rdatd:P70045>
                    <rdatd:P70039>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                    </rdatd:P70039>
                    <rdatd:P70040>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70040>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 38: Expression timespan (indicator 1 = 2) -->
            <xsl:if test="@ind1 = '2'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'expression-validity-span')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdatd:P70016>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70016>
                    <rdatd:P70045>Date span for the validity of a resource</rdatd:P70045>
                    <rdatd:P70039>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                    </rdatd:P70039>
                    <rdatd:P70040>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70040>
                </rdf:Description>
            </xsl:if>
            
            <!-- Row 39: Manifestation timespan (indicator 1 = 3) -->
            <xsl:if test="@ind1 = '3'">
                <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'manifestation-validity-span')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                    <rdatd:P70016>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                        <xsl:text> - </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70016>
                    <rdatd:P70045>Date span for the validity of a resource</rdatd:P70045>
                    <rdatd:P70039>
                        <xsl:value-of select="marc:subfield[@code = 'm']"/>
                    </rdatd:P70039>
                    <rdatd:P70040>
                        <xsl:value-of select="marc:subfield[@code = 'n']"/>
                    </rdatd:P70040>
                </rdf:Description>
            </xsl:if>
        </xsl:if>

        <!-- Row 40: Work original release timespan -->
        <xsl:if test="marc:subfield[@code = 'o'] and marc:subfield[@code = 'p']">
            <rdf:Description rdf:about="{uwf:timespanIRI($baseID, ., 'original-release')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10011"/>
                <rdatd:P70016>
                    <xsl:value-of select="marc:subfield[@code = 'o']"/>
                    <xsl:text> - </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'p']"/>
                </rdatd:P70016>
                <rdatd:P70045>Date span of original release of the contents of a collection/aggregation</rdatd:P70045>
                <rdatd:P70039>
                    <xsl:value-of select="marc:subfield[@code = 'o']"/>
                </rdatd:P70039>
                <rdatd:P70040>
                    <xsl:value-of select="marc:subfield[@code = 'p']"/>
                </rdatd:P70040>
            </rdf:Description>
         </xsl:if>

        <!-- Row 45: has note on timespan -->
        <xsl:if test="marc:subfield[@code = 'x'] and marc:subfield[@code = 'z']">
            <xsl:variable name="xValue" select="number(marc:subfield[@code = 'x'])"/>
            <xsl:variable name="zValue" select="number(marc:subfield[@code = 'z'])"/>
            <xsl:if test="string($xValue) != 'NaN' and string($zValue) != 'NaN'">
                <rdatd:P70045>
                    <xsl:value-of select="$xValue + $zValue"/>
                </rdatd:P70045>
            </xsl:if>
         </xsl:if>

        <!-- Rows 68-71 -->
        <xsl:if test="(@ind1 = '1' or @ind1 = '2' or @ind1 = '3' or @ind1 = '') and marc:subfield[@code = 'x']">
            <rdatd:P70045>
                <xsl:value-of select="marc:subfield[@code = 'x']"/>
            </rdatd:P70045>
        </xsl:if>

        <!-- Rows 72-75 -->
        <xsl:if test="(@ind1 = '1' or @ind1 = '2' or @ind1 = '3' or @ind1 = '') and marc:subfield[@code = 'z']">
            <rdatd:P70045>
                <xsl:value-of select="marc:subfield[@code = 'z']"/>
            </rdatd:P70045>
        </xsl:if>

        <!-- Row 79 -->
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = '3']">
            <rdatd:P70045>
                <xsl:text>applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
            </rdatd:P70045>
        </xsl:if>

    </xsl:template>

    <!-- 047 - Form of Muscial Composition -->
    <xsl:template match="marc:datafield[@tag = '047'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '047']" 
        mode="wor" expand-text="yes">

        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaw:P10004><xsl:value-of select="."/></rdaw:P10004>            
        </xsl:for-each>

        <xsl:if test="@ind2 = '7' and marc:subfield[@code = '2']">
            <rdaw:P10406><xsl:value-of select="marc:subfield[@code = '2']"/></rdaw:P10406>
        </xsl:if>
    </xsl:template>
    

    <!-- 048 - Number of Musical Instruments or Voices Code -->
    <xsl:template match="marc:datafield[@tag = '048'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '048']" 
        mode="exp" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = 'a'][1]"/>
            <rdaeo:P20215 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}"/>
        </xsl:for-each>
        <xsl:for-each select=" marc:subfield[@code = 'b']">
            <xsl:variable name="source" select="following-sibling::marc:subfield[@code = 'b'][1]"/>
            <rdaeo:P20215 rdf:resource="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}"/>
        </xsl:for-each>
    </xsl:template> 

    <xsl:template match="marc:datafield[@tag = '048'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '048']" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="source">
                <xsl:choose>
                    <xsl:when test="../@ind2 = '7'">
                        <xsl:value-of select="following-sibling::marc:subfield[@code = '2'][1]"/>
                    </xsl:when>
                    <xsl:otherwise>marcmusperf</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:text>Performer or ensemble: </xsl:text><xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="$source != ''">
                    <xsl:sequence select="uwf:s2MusicCodeSchemes($source)"/>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
        
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:variable name="source">
                <xsl:choose>
                    <xsl:when test="../@ind2 = '7'">
                        <xsl:value-of select="following-sibling::marc:subfield[@code = '2'][1]"/>
                    </xsl:when>
                    <xsl:otherwise>marcmusperf</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., $source, 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:text>Soloist: </xsl:text><xsl:value-of select="."/>
                </rdand:P80068>
                <xsl:if test="$source != ''">
                    <xsl:sequence select="uwf:s2MusicCodeSchemes($source)"/>
                </xsl:if>
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
                        <xsl:value-of select="concat(../marc:subfield[@code = 'a'][1], .)"/>
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

    <!-- 070 - National Agricultural Library Call Number -->
    <xsl:template match="marc:datafield[@tag = '070']" mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:param name="baseID"/>
        <xsl:variable name="scheme">
                    <xsl:text>lcc</xsl:text>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10256 rdf:resource="{uwf:conceptIRI($scheme, $ap)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '070']" mode="con" expand-text="yes">
        <!--<call-template name="getmarc"/>-->
      <xsl:param name="baseID"/>
        <xsl:variable name="scheme">
                    <xsl:text>lcc</xsl:text>
        </xsl:variable>
      <xsl:variable name="ap">
          <xsl:value-of select="marc:subfield[@code = 'a']"/>
      </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $ap)}">
                <skos:notation rdf:datatype="http://www.wikidata.org/entity/Q130324983"> 
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </skos:notation>
                <skos:altLabel>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </skos:altLabel>
                <skos:note> 
                    <xsl:text>National Agricultural Library Call Number</xsl:text>
                </skos:note>
            </rdf:Description>
        </xsl:if>
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

    <!-- 083 - Additional Dewey Decimal Classification Number -->
    <xsl:template match="marc:datafield[@tag = '083'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '083']" mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:variable name="scheme">
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>ddcFull</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:value-of select="marc:subfield[@code = '2']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="@ind1 = '1'">
                    <xsl:text>ddcAbridged</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:value-of select="marc:subfield[@code = '2']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>ddc</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:value-of select="marc:subfield[@code = '2']"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawo:P10256 rdf:resource="{uwf:conceptIRI($scheme, $ap)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '083'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '083']" mode="con" expand-text="yes">
        <xsl:variable name="scheme">
                    <xsl:text>ddc</xsl:text>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <xsl:value-of select="substring(marc:subfield[@code = '2'], 1, 2)"/>
                    </xsl:if>
        </xsl:variable>
        <xsl:variable name="ap">
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <xsl:value-of select="translate(., ' ', '')"/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{uwf:conceptIRI($scheme, $ap)}">
                <xsl:copy-of select="uwf:fillClassConcept($scheme, $ap, $ap, '083')"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 084 - Other Classification Number -->
    <xsl:template match="marc:datafield[@tag = '084'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '084']" 
        mode="wor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdawo:P10256 rdf:resource="{uwf:conceptIRI($sub2, .)}"/>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '084'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '084']" 
        mode="con" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <rdf:Description rdf:about="{uwf:conceptIRI($sub2, .)}">
                    <xsl:copy-of select="uwf:fillConcept(., $sub2, '', '084')"/>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 086 - Government Document Classification Number -->
    
    <xsl:template match="marc:datafield[@tag = '086'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '086']" 
        mode="man" expand-text="yes">
        <xsl:param name="baseID"/>
        <!-- Subfield a -->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
        
        <!-- Subfield z -->
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}"/>
        </xsl:for-each>
        
        <!-- Subfield 0 -->
        <xsl:for-each select="marc:subfield[@code = '0']">
            <rdamd:P30004>
                <xsl:value-of select="."/>
            </rdamd:P30004>
        </xsl:for-each>
        
        <!-- Subfield 1 (IRI) -->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdamo:P30004 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '086'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '086']" 
        mode="nom">
        <xsl:param name="baseID"/>
        
        <xsl:variable name="schemeCode">
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">sudocs</xsl:when>
                <xsl:when test="@ind1 = '1'">cacodoc</xsl:when>
                <xsl:when test="marc:subfield[@code = '2']">
                    <xsl:value-of select="marc:subfield[@code = '2'][1]"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Process both subfield a and z together -->
        <xsl:for-each select="marc:subfield[@code = 'a' or @code = 'z']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., ., '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                
                <xsl:choose>
                    <xsl:when test="$schemeCode = 'sudocs'">
                        <rdand:P80069 rdf:resource="http://id.loc.gov/vocabulary/classSchemes/sudocs"/>
                    </xsl:when>
                    <xsl:when test="$schemeCode = 'cacodoc'">
                        <rdand:P80069 rdf:resource="http://id.loc.gov/vocabulary/classSchemes/cacodoc"/>
                    </xsl:when>
                    <xsl:when test="../marc:subfield[@code = '2']">
                        <xsl:sequence select="uwf:s2NomenClassSchemes($schemeCode)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdand:P80069>
                            <xsl:value-of select="$schemeCode"/>
                        </rdand:P80069>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- cancelled/invalid status only for subfield z -->
                <xsl:if test="@code = 'z'">
                    <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
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
    <xsl:template match="marc:datafield[@tag = '082'] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '082']"
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:call-template name="F0082-deweyClassification">
            <xsl:with-param name="baseID" select="$baseID"/>
            <xsl:with-param name="suffix" select="'dewey'"/>
            <xsl:with-param name="note" select="'Dewey Decimal Classification Number'"/>
        </xsl:call-template>
    </xsl:template>
    

</xsl:stylesheet>
