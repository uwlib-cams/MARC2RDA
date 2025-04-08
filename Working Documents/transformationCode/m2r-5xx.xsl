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
    xmlns:uwf="http://universityOfWashington/functions"
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:m2rext="uwlib-cams/MARC2RDA/extensions"
    exclude-result-prefixes="marc ex uwf m2rext" version="3.0">
    <xsl:include href="m2r-5xx-named.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="getmarc.xsl"/>
        
    <!-- for extension demo only -->
    <!-- <xsl:template match="marc:datafield[@tag='518'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '518']" 
        mode="wor" expand-text="yes">
        <xsl:variable name="placeUris" select="document('lookup/placeUris.xml')/root/row"/>

        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:variable name="uri" select="."/>
            <xsl:variable name="types" select="tokenize(m2rext:getFirstLevelTypes(.))"/>

            <xsl:for-each select="$types">
                <xsl:variable name="currentUri" select="."/>
                <xsl:if test="$placeUris[. = $currentUri]">
                    <xsl:text>=== IRI ({$uri}) is RDA Place ===</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template> -->

    <!-- 500 - General Note -->
    <xsl:template
        match="marc:datafield[@tag = '500'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '500-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdamd:P30137>
                
                <xsl:if test="(@tag = '500') and (marc:subfield[@code = '6'])">
                    <xsl:variable name="occNum" select="concat('500-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdamd:P30137>
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                            <xsl:if test="marc:subfield[@code = '3']">
                                <xsl:text> (Applies to: </xsl:text>
                                <xsl:value-of select="marc:subfield[@code = '3']"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                        </rdamd:P30137>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '500'][marc:subfield[@code = '5']] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '500-00'][marc:subfield[@code = '5']]"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
            <!--<xsl:call-template name="getmarc"/>-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            <rdaid:P40028>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
                <xsl:if test="marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = '3']"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdaid:P40028>
            <!-- only uses $5 from 500 fields not linked 880s -->
            <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
            <xsl:if test="(@tag = '500') and (marc:subfield[@code = '6'])">
                <xsl:variable name="occNum" select="concat('500-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <rdaid:P40028>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        <xsl:if test="marc:subfield[@code = '3']">
                            <xsl:text> (Applies to: </xsl:text>
                            <xsl:value-of select="marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </rdaid:P40028>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <!-- 501 - With Note -->
    <xsl:template
        match="marc:datafield[@tag = '501'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '501']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test="@tag = '501' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 6) = '501-00')">
                    <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '501'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '501-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6'] and @tag = '501'">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                           <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 502 - Dissertation Note -->
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="wor" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdawd:P10077>{marc:subfield[@code = 'b']}</rdawd:P10077>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdawd:P10006>{marc:subfield[@code = 'c']}</rdawd:P10006>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'd']">
            <rdawd:P10215>{replace(marc:subfield[@code = 'd'], '\.\s*$', '')}</rdawd:P10215>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a'] or marc:subfield[@code = 'g']">
            <rdawd:P10209>
                <xsl:for-each
                    select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'g']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdawd:P10209>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdawo:P10002 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'nomen')}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., '', '', 'nomen')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>{replace(., '\.\s*$', '')}</rdand:P80068>
                <rdand:P80078>Dissertation identifier</rdand:P80078>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 504 - Bibliography, etc. Note -->
    <xsl:template
        match="marc:datafield[@tag = '504'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '504']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30455>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:value-of
                    select="concat('; Number of references: ', marc:subfield[@code = 'b'], '.')"/>
            </xsl:if>
        </rdamd:P30455>
    </xsl:template>
    
    <!-- 505 - Formatted Contents Notes -->
    <xsl:template match="marc:datafield[@tag= '505'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '505']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:call-template name="F505-xx-agrtu"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 506 - Restrictions on Access Note -->
    <xsl:template
        match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']"
        mode="man" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:variable name="online_resource">
            <xsl:value-of select="if (some $F338 in ../marc:datafield[@tag = '338']
                satisfies ((starts-with($F338/marc:subfield[@code = '2'][1], 'rda')
                and (contains($F338/marc:subfield[@code = 'a'], 'online resource')
                or contains($F338/marc:subfield[@code = 'b'], 'cr')
                or contains($F338/marc:subfield[@code = 'b'], '1018'))))) then 'true' else 'false'"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$online_resource = 'true'">
                <xsl:if test="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or @code = 'd'
                    or @code = 'e' or @code = 'g' or @code = 'q' or @code = 'u']">
                    <rdamd:P30145>
                        <xsl:call-template name="F506-xx-abcdegqu3"/>
                        <xsl:if test="marc:subfield[@code = '5']">
                            <xsl:text> (at institution: {uwf:s5NameLookup(marc:subfield[@code = '5'])})</xsl:text>
                        </xsl:if>
                    </rdamd:P30145>
                </xsl:if>
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:for-each select="marc:subfield[@code = 'f']">
                        <rdam:P30145 rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'], .)}"/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Restriction on access {uwf:conceptIRI(../marc:subfield[@code = '2'], .)} applies to {../marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@tag = '506' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('506-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <xsl:if test="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or @code = 'd'
                            or @code = 'e' or @code = 'g' or @code = 'q' or @code = 'u']">
                             <rdamd:P30145>
                                 <xsl:call-template name="F506-xx-abcdegqu3"/>
                             </rdamd:P30145>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:variable name="online_resource">
            <xsl:value-of select="if (some $F338 in ../marc:datafield[@tag = '338']
                satisfies ((starts-with($F338/marc:subfield[@code = '2'][1], 'rda')
                and (contains($F338/marc:subfield[@code = 'a'], 'online resource')
                or contains($F338/marc:subfield[@code = 'b'], 'cr')
                or contains($F338/marc:subfield[@code = 'b'], '1018'))))) then 'true' else 'false'"/>
        </xsl:variable>
        <!-- create the item IRI and rdf:description for this item -->
        <xsl:if test="$online_resource = 'false'">
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>    
                </xsl:if>
                <xsl:if test="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or @code = 'd'
                    or @code = 'e' or @code = 'g' or @code = 'q' or @code = 'u']">
                    <rdaid:P40047>
                        <xsl:call-template name="F506-xx-abcdegqu3"/>
                    </rdaid:P40047>
                </xsl:if>
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:for-each select="marc:subfield[@code = 'f']">
                        <rdai:P40047 rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'], .)}"/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdaid:P40028>
                                <xsl:text>Restriction on access {uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)} applies to {./marc:subfield[@code = '3']}</xsl:text>
                            </rdaid:P40028>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@tag = '506' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('506-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:if test="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or @code = 'd'
                                or @code = 'e' or @code = 'g' or @code = 'q' or @code = 'u']">
                                <rdaid:P40047>
                                    <xsl:call-template name="F506-xx-abcdegqu3"/>
                                </rdaid:P40047>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']" 
        mode="con">
        <xsl:call-template name="F506-xx-f2"/>
    </xsl:template>    
 
    <!-- 507 - Scale Note for Visual Materials -->
   
    <xsl:template
        match="marc:datafield[@tag = '507'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '507']"
        mode="exp"
        expand-text="yes">
        
        <xsl:param name="baseID"/>
        
        <!-- Subfield 'a' → Scale Note -->          
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdaed:P20228>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdaed:P20228>
        </xsl:if>
     
        <!-- Subfield 'b' → Constant Horizontal Scale -->
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdaed:P20213>
                <xsl:value-of select="marc:subfield[@code = 'b']"/>
            </rdaed:P20213>
        </xsl:if>
    </xsl:template>
    
    <!-- 508 - Creation/Production Credits Note -->
    <xsl:template match="marc:datafield[@tag='508'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '508']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137><xsl:value-of select="concat('Credits: ', marc:subfield[@code = 'a'])"/></rdamd:P30137>
    </xsl:template>
    
    <!-- 510 - Citation/References Note -->
    <xsl:template match="marc:datafield[@tag='510']| marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '510']" 
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdam:P30254>
                <xsl:if test="@ind1 = '0'">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '3']">
                            <xsl:value-of select="
                                concat(marc:subfield[@code = '3'],' indexed by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="
                                concat('Indexed by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            <xsl:if test="@ind1 = '1'">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '3']">
                        <xsl:value-of select="
                            concat(marc:subfield[@code = '3'],' indexed in its entirety by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="
                            concat('Indexed in its entirety by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="@ind1 = '2'">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '3']">
                        <xsl:value-of select="
                            concat(marc:subfield[@code = '3'],' indexed selectively by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="
                            concat('Indexed selectively by: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:if test="@ind1 = '3' or @ind1 = '4'">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '3']">
                        <xsl:value-of select="
                            concat(marc:subfield[@code = '3'],' references: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'],' ',marc:subfield[@code = 'c'])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="
                            concat('References: ',marc:subfield[@code = 'a'],' ', marc:subfield[@code = 'u'],' ', marc:subfield[@code = 'b'],' ', marc:subfield[@code = 'x'],' ',marc:subfield[@code = 'c'])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </rdam:P30254>
    </xsl:template>
        
    <!-- 511 - Participant or Performer Note -->
    <xsl:template match="marc:datafield[@tag='511'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '511']" 
        mode="man">
        <rdamd:P30137>
            <xsl:if test="@ind1 = '1'"><xsl:text>Cast: </xsl:text></xsl:if>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 513 - Type of Report and Period Covered note -->
    <xsl:template match="marc:datafield[@tag='513'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '513']" 
        mode="wor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdaw:P10330>
                <xsl:text>Type of report: {marc:subfield[@code = 'a']}</xsl:text>
            </rdaw:P10330>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdaw:P10216>
                <xsl:text>Period covered: {marc:subfield[@code='b']}</xsl:text>
            </rdaw:P10216>       
        </xsl:if>
    </xsl:template>
    
    <!-- 514 - Data Quality Note -->
    <xsl:template match="marc:datafield[@tag='514'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '514']" 
        mode="wor">
        <rdawd:P10330>
            <xsl:call-template name="F514-xx-zabcdefghijkmu"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 515 - Numbering Peculiarities Notes -->
    <xsl:template match="marc:datafield[@tag='515'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '515']" 
        mode="man" expand-text="yes">
        <rdamd:P30137>
            <xsl:text>Numbering peculiarities note: {marc:subfield[@code = 'a']}</xsl:text>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 516 - Type of Computer File or Data Note -->
    <xsl:template match="marc:datafield[@tag='516'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '516']" 
        mode="man">
        <rdamd:P30018>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30018>
    </xsl:template>
    
    <!-- 518 - Date/Time and Place of an Event Note -->
    <xsl:template match="marc:datafield[@tag='518'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '518']" 
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:if test="marc:subfield[@code = 'a']">
                <xsl:text>Date/time and place of an event note: {marc:subfield[@code = 'a']}</xsl:text>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'd'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
                | marc:subfield[@code = '0'] | marc:subfield[@code = '1'] | marc:subfield[@code = '2']">
                <xsl:if test="@code = 'd'">
                    <xsl:text>Date of event: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'o'">
                    <xsl:text>Other event information: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'p'">
                    <xsl:text>Place of event: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '0'">
                    <xsl:text>Authority record control number or standard number for controlled place of event term: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '1'">
                    <xsl:text>Real World Object URI: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '2'">
                    <xsl:text>Source of term for controlled place of event term: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
            </xsl:if>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 520 - Summary, Etc.-->
    
    <xsl:template
        match="marc:datafield[@tag = '520'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '520']"
        mode="exp">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdaed:P20069>
            <xsl:call-template name="F520-xx-abcu23"/>
        </rdaed:P20069>
    </xsl:template>

    <!-- 521 - Target Audience Note-->
    <xsl:template
        match="marc:datafield[@tag = '521'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '521']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:call-template name="F521-xx-ab3"/>
        </rdamd:P30137>
    </xsl:template> 

    <!-- 522 - Geographic Coverage Note -->
    <xsl:template
        match="marc:datafield[@tag = '522'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '522']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10216>
            <xsl:value-of select="concat('Geographic coverage: ', marc:subfield[@code = 'a'])"/>
        </rdawd:P10216>
    </xsl:template>
    
    <!-- 524 - Preferred Citation of Described Materials Note -->
    <xsl:template match="marc:datafield[@tag = '524'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '524']" 
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30005>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30005>
        <xsl:if test="marc:subfield[@code = '2']">
            <rdamd:P30137>
                <xsl:text>Preferred citation {marc:subfield[@code = 'a']} has source of schema used: {marc:subfield[@code = '2'][1]}</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '3']">
            <rdamd:P30137>
                <xsl:text>Preferred citation {marc:subfield[@code = 'a']} applies to: {marc:subfield[@code = '3']}</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <!-- 525 - Supplement Note -->
    <xsl:template match="marc:datafield[@tag = '525'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '525']"
        mode="wor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdaw:P10330>
                <xsl:text>Supplement note: </xsl:text>
                <xsl:for-each select="marc:subfield[@code = 'a']">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </rdaw:P10330>
        </xsl:if>
    </xsl:template>
    
    <!-- 526 - Study Program Information Note -->
    <xsl:template match="marc:datafield[@tag = '526'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '526']" 
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F526-xx-iabcdz5"/>
        <!-- iterate through each x (nonpublic note) subfield -->
        <xsl:for-each select="marc:subfield[@code = 'x']">
            <rdamo:P30462
                rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '526'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '526']" 
        mode="metaWor">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <!-- iterate through each x (nonpublic note) subfield -->
        <xsl:for-each select="marc:subfield[@code = 'x']">
            <xsl:call-template name="F526-xx-x">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="manIRI" select="$manIRI"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 527 - Censorship Note -->
    <xsl:template
        match="marc:datafield[@tag = '527'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '527']"
        mode="aggWor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdawd:P10330>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '527'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '527']"
        mode="exp">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdaed:P20071>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdaed:P20071>
    </xsl:template>
    
    <!-- 532 - Accessibility Note -->
    <xsl:template
        match="marc:datafield[@tag = '532'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '532']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:call-template name="F532-xx-a"/>
    </xsl:template>
    
    <!-- 533 - Reproduction Note -->
    <xsl:template
        match="marc:datafield[@tag = '533'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '533']"
        mode="wor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '7']">
            <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
            <xsl:for-each select="marc:subfield[@code = '7']">
                <!-- continuing resources -->
                <xsl:if test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                    <!-- c12 = 008/18 -->
                    <xsl:call-template name="F008-c18-CR">
                        <xsl:with-param name="char18" select="substring(., 13, 1)"/>
                    </xsl:call-template>
                    <!-- c13 = 008/19 -->
                    <xsl:call-template name="F008-c19-CR">
                        <xsl:with-param name="char19" select="substring(., 14, 1)"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '533'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '533']"
        mode="aggWor" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '7']">
            <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
            <xsl:for-each select="marc:subfield[@code = '7']">
                <!-- c14 = 008/23 or 008/29 -->
                <xsl:choose>
                    <!-- books -->
                    <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                        or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- continuing resources -->
                    <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- maps -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- mixed materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- music -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                        or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- visual materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                        or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r'">
                        <xsl:call-template name="F008-c23_29-f-SOME-aggWor">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '533'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '533']"
        mode="exp" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '7']">
            <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
            <xsl:for-each select="marc:subfield[@code = '7']">
                <!-- c14 = 008/23 or 008/29 -->
                <xsl:choose>
                    <!-- books -->
                    <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                        or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- continuing resources -->
                    <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- maps -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- mixed materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- music -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                        or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- visual materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                        or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r'">
                        <xsl:call-template name="F008-c23_29-f-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '533'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '533']"
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30335>
                <xsl:value-of select="replace(., '\.$', '') => normalize-space()"/>
            </rdamd:P30335>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30279>
                <xsl:value-of select="replace(., '[:;]\s*$', '') => normalize-space() => uwf:removeBrackets()"/>
            </rdamd:P30279>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30297>
                <xsl:value-of select="replace(., ',', '') => normalize-space() => uwf:removeBrackets()"/>
            </rdamd:P30297>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'd']">
            <rdamd:P30278>
                <xsl:value-of select="replace(., '\.\s*$', '') => normalize-space() => uwf:removeBrackets()"/>
            </rdamd:P30278>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <rdamd:P30137>
                <xsl:value-of select="."/>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'f']">
            <rdamd:P30106>
                <xsl:value-of select="translate(., '()', '')"/>
            </rdamd:P30106>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'm']">
            <rdamd:P30137>
                <xsl:text>Dates and/or sequential designation of issues reproduced: {.}</xsl:text>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'n']">
            <rdamd:P30137>
                <xsl:value-of select="."/>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '7']">
            <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
            <xsl:for-each select="marc:subfield[@code = '7']">
                <xsl:variable name="char0" select="substring(., 1, 1)"/>
                <!-- c0 = 008/6 -->
                <xsl:if test="$char0 = 'c'">
                    <rdamd:P30137>
                        <xsl:text>Continuing resource currently published.</xsl:text>
                    </rdamd:P30137>
                </xsl:if>
                <xsl:if test="$char0 = 'd'">
                    <rdamd:P30137>
                        <xsl:text>Continuing resource ceased publication.</xsl:text>
                    </rdamd:P30137>
                </xsl:if>
               <!-- c1-8 = 008/7-14 -->
                <xsl:call-template name="F008-c7-14">
                    <xsl:with-param name="char6" select="substring(., 1, 1)"/>
                    <xsl:with-param name="char7-14" select="substring(., 2, 8)"/>
                </xsl:call-template>
                <!-- c9-11 = 008/15-17 -->
                <xsl:if test="substring(., 10, 3) != '   '">
                    <xsl:call-template name="F008-c15-17">
                        <xsl:with-param name="char15-17" select="substring(., 10, 3)"/>
                    </xsl:call-template>
                </xsl:if>
                <xsl:choose>
                    <!-- books -->
                    <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                        or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- computer files -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'm'">
                        <xsl:call-template name="F008-c23-CF">
                            <xsl:with-param name="char23" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23-CF-origMan">
                            <xsl:with-param name="char23" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- continuing resources -->
                    <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- maps -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- mixed materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23-MX-origMan">
                            <xsl:with-param name="char23" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23-xz-SOME-origMan">
                            <xsl:with-param name="char23" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- music -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                        or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23-xz-SOME-origMan">
                            <xsl:with-param name="char23" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- visual materials -->
                    <xsl:when test="substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                        or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r'">
                        <xsl:call-template name="F008-c23_29-abcor-SOME">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
                            <xsl:with-param name="char23_29" select="substring(., 15, 1)"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 536 - Funding Information Note -->
    <xsl:template
        match="marc:datafield[@tag = '536'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '536']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:call-template name="F536-xx-abcdefgh"/>
        </rdawd:P10330>
    </xsl:template> 
    
    <!-- 538 - System Details Note -->
    <xsl:template
        match="marc:datafield[@tag = '538'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '538-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:for-each select="marc:subfield[@code = '5']">
                    <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30162>
                    <xsl:call-template name="F538-xx-aiu"/>
                </rdamd:P30162>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '538'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '538-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="aiu">
            <xsl:call-template name="F538-xx-aiu"/>
        </xsl:variable>
        <!-- create the item IRI and rdf:description for this item -->
        <xsl:for-each select="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <xsl:copy-of select="uwf:s5Lookup(.)"/>
                <rdaid:P40028>
                   <xsl:value-of select="$aiu"/>
                </rdaid:P40028>
                <xsl:if test="../@tag = '538' and ../marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('538-', substring(../marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:call-template name="F538-xx-aiu"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- 541 - Immediate Source of Acquisition Note -->
    <xsl:template
        match="marc:datafield[@tag = '541'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '541-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '541'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '541-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <!-- create the item IRI and rdf:description for this item -->
        <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
            <!--<xsl:call-template name="getmarc"/>-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40050>
                    <xsl:call-template name="F541-xx-abcdefhno"/>
                </rdaid:P40050>
            </xsl:if>
            <xsl:if test="@ind1 = '0'">
                <rdaio:P40164
                    rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
            </xsl:if>
            <xsl:if test="@tag = '541' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('541-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40050>
                            <xsl:call-template name="F541-xx-abcdefhno"/>
                        </rdaid:P40050>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{uwf:metaWorIRI($baseID, .)}"
                        />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F541-0x">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '541' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('541-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F541-0x">
                        <xsl:with-param name="baseID" select="$baseID"/>
                        <xsl:with-param name="genID" select="$genID"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 542 - Information Relating to Copyright Status -->
    <xsl:template
        match="marc:datafield[@tag = '542'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '542']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="@ind1 = '0'">
                <rdamo:P30462 rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:call-template name="F542-xx-abcdefghijklmnopqrsu3"/>
                </rdamd:P30137>
                <xsl:call-template name="F542-1x-e_f_g_i_j_p"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '542'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '542']"
        mode="metaWor">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F542-0x">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="manIRI" select="$manIRI"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 544 - Location of Other Archival Materials Note -->
    <xsl:template
        match="marc:datafield[@tag = '544'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '544']"
        mode="man">
        <rdamd:P30137>
            <xsl:call-template name="F544-xx-dabcen"/>
        </rdamd:P30137>
    </xsl:template>

    <!-- 546 - Language Note -->
    <xsl:template
        match="marc:datafield[@tag = '546'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '546']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdawd:P10330>
                <xsl:text>Form of notation: </xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (Applies to a manifestation's {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdawd:P10330>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '546'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '546']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20062>
                <xsl:value-of select="."/>
            </rdaed:P20062>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Form of notation {.} applies to a manifestation's {../marc:subfield[@code = '3']}.</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '546'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '546']"
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30137>
                <xsl:value-of select="."/>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 547 - Former Title Complexity Note -->
    <xsl:template
        match="marc:datafield[@tag = '547'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '547']"
        mode="man" expand-text="true">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:text>Former title complexity note: {marc:subfield[@code = 'a']}</xsl:text>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 550 - Issuing Body Note -->
    <xsl:template
        match="marc:datafield[@tag = '550'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '550']"
        mode="man" expand-text="true">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30055>
            <xsl:for-each select="marc:subfield[@code = 'a']">
                <xsl:if test="@code = 'a'">
                    <xsl:text>Issuing body note: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdamd:P30055>
    </xsl:template>
    
    
    <!-- 552 - Entity and Attribute Information Note -->
    <xsl:template
        match="marc:datafield[@tag = '552'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '552']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:call-template name="F552-xx-zabcdefghijklmnopu"/>
        </rdawd:P10330>
    </xsl:template>
      
    
    <!-- 555 - Culmulative Index/Finding Aids Note -->
    <xsl:template
        match="marc:datafield[@tag = '555'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '555']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P30137>
            <xsl:call-template name="F555-xx-abcdu3"/>
        </rdawd:P30137>
    </xsl:template>
    
    
    <!-- 556 - Information About Documentation Note -->
    <xsl:template
        match="marc:datafield[@tag = '556'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '556']"
        mode="wor" expand-text="true">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:call-template name="F556-xx-az"/>
        </rdawd:P10330>
    </xsl:template>
    
    
    <!-- 561 - Ownership and Custodial History -->
    <!-- match on tag 561 or an unlinked 880 field where $6 = 561-00 -->
    <xsl:template
        match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <!-- create the item IRI and rdf:description for this item -->
        <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
            <!--<xsl:call-template name="getmarc"/>-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40026>
                    <xsl:call-template name="F561-xx-au"/>
                </rdaid:P40026>
            </xsl:if>
            <xsl:if test="@ind1 = '0'">
                <rdaio:P40164
                    rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
            </xsl:if>
            <!-- if 561 field has $6, find associated 880 andd do the same mapping -->
            <xsl:if test="@tag = '561' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('561-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <!-- use for-each - there may be more than one associated 880 -->
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40026>
                            <xsl:call-template name="F561-xx-au"/>
                        </rdaid:P40026>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{uwf:metaWorIRI($baseID, .)}"
                        />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="metaWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, .)"/>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F561-0x">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="itemIRI" select="$itemIRI"/>
            </xsl:call-template>
        </xsl:if>
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '561' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('561-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F561-0x">
                        <xsl:with-param name="baseID" select="$baseID"/>
                        <xsl:with-param name="itemIRI" select="$itemIRI"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 563 - Binding Information -->
    <xsl:template match="marc:datafield[@tag = '563'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '563']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test=".[@tag = '563'] or .[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '563-00']">
                    <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:call-template name="F563-xx-au3"/>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '563'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '563-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:call-template name="F563-xx-au3"/>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6'] and @tag = '563'">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:call-template name="F563-xx-au3"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 565 - Case File Characteristics Note -->
    <xsl:template
        match="marc:datafield[@tag = '565'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '565']"
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text>{marc:subfield[@code = '3']}: </xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>Case file characteristics: </xsl:text>
                </xsl:when>
                <xsl:when test="@ind1 = '8'"/>
                <xsl:otherwise>
                    <xsl:text>File size: </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="F565-xx-abcde"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 567 - Methodology Note -->
    <xsl:template
        match="marc:datafield[@tag = '567'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '567']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:call-template name="F567-xx-ab2"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 580 - Linking Entry Complexity Note -->
    <xsl:template
        match="marc:datafield[@tag = '580']| marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '580']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
    <xsl:param name="baseID"/>   
    <xsl:choose>
        <xsl:when test="marc:subfield[@code = '5']">
            <xsl:if test="@tag = '580' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 6) = '580-00')">
                <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise>
            <rdamd:P30137>
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:text>Linking entry complexity note: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = 'a']" />
                </xsl:if>
            </rdamd:P30137>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '580'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '580-00']" 
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdaid:P40028>
                
                <xsl:if test="marc:subfield[@code = '6'] and @tag = '580'">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 581 - Publications about Described Materials Note -->
    <xsl:template
        match="marc:datafield[@tag = '581'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '581']"
        mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamd:P30137>
            <xsl:call-template name="F581-xx-az3"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 583 - Action Note -->
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']" 
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
            <!--<xsl:call-template name="getmarc"/>-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40028>
                    <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
                </rdaid:P40028>
                <!-- subfield 'x' is private note -->
                <!-- for each one, create triple 'is item described with metadata by' [metadataWork IRI] -->
                <!-- metadataWork IRI = 'http://marc2rda.edu/fake/metaWor#' + generate-id() of subfield x -->
                <xsl:for-each select="marc:subfield[@code = 'x']">
                    <!-- need to do a for-each to set context for subfield id -->
                    <rdaio:P40164
                        rdf:resource="{uwf:metaWorIRI($baseID, .)}"
                    />
                </xsl:for-each>
            </xsl:if>
            <!-- @ind1 = '0'is private field -->
            <xsl:if test="@ind1 = '0'">
                <!-- 'is item described with metadata by' -->
                <rdaio:P40164
                    rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
            </xsl:if>
            
            <xsl:if test="@tag = '583' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('583-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <!-- use for-each - there may be more than one associated 880 -->
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40028>
                            <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
                        </rdaid:P40028>
                        <xsl:for-each select="marc:subfield[@code = 'x']">
                            <rdaio:P40164
                                rdf:resource="{uwf:metaWorIRI($baseID, .)}"
                            />
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{uwf:metaWorIRI($baseID, .)}"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']" 
        mode="metaWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, .)"/>
        <xsl:if test="@ind1 != '0'">
            <!-- for each sets same context as above, ensures id value is the same -->
            <xsl:for-each select="marc:subfield[@code = 'x']">
                <xsl:call-template name="F583-1x-x">
                    <xsl:with-param name="baseID" select="$baseID"/>
                    <xsl:with-param name="itemIRI" select="$itemIRI"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F583-0x">
                <xsl:with-param name="baseID" select="$baseID"/>
                <xsl:with-param name="itemIRI" select="$itemIRI"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '583' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('583-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 != '0'">
                    <!-- for each sets same context as above, ensures id value is the same -->
                    <xsl:for-each select="marc:subfield[@code = 'x']">
                        <xsl:call-template name="F583-1x-x">
                            <xsl:with-param name="baseID" select="$baseID"/>
                            <xsl:with-param name="itemIRI" select="$itemIRI"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F583-0x">
                        <xsl:with-param name="baseID" select="$baseID"/>
                        <xsl:with-param name="itemIRI" select="$itemIRI"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 584 - Accumulation and Frequency of Use Note -->
    <xsl:template
        match="marc:datafield[@tag = '584'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '584']"
        mode="wor">
        <!--<xsl:call-template name="getmarc"/>-->
        <rdawd:P10330>
            <xsl:call-template name="F584-xx-ab35"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 585 - Exhibitions note -->
    <xsl:template
        match="marc:datafield[@tag = '585'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '585']"
        mode="man" expand-text="yes">
        <xsl:param name="baseID"/>
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test=".[@tag = '585'] or .[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '585-00']">
                    <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                    </xsl:if>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '585'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '585-00']" 
        mode="ite" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                    </xsl:if>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                            <xsl:if test="marc:subfield[@code = '3']">
                                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                            </xsl:if>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 586 - Awards Note -->
    <xsl:template
        match="marc:datafield[@tag = '586'] |  marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '586']"
        mode="aggWor" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdawd:P10330>
                <xsl:text>Award: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
                <xsl:if test="marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdawd:P10330>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '586'] |  marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '586']"
        mode="exp" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdaed:P20005>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdaed:P20005>
            <xsl:if test="marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>{marc:subfield[@code = 'a']} applies to: {marc:subfield[@code = '3']}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 588 - Source of Description Note -->
    <xsl:template
        match="marc:datafield[@tag = '588'] |  marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '588']"
        mode="man" expand-text="yes">
        <!--<xsl:call-template name="getmarc"/>-->
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdamd:P30137>
                <xsl:if test="@ind1 = '0'">
                    <xsl:text>Source of description: </xsl:text>
                </xsl:if>
                <xsl:if test="@ind1 = '1'">
                    <xsl:text>Latest issue consulted: </xsl:text>
                </xsl:if>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:text> (Applies to: {uwf:s5NameLookup(marc:subfield[@code = '5'])})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    
    <!-- <xsl:template match="*" mode="wor"/>
        <xsl:template match="*" mode="exp"/>
        <xsl:template match="*" mode="man"/>
        <xsl:template match="*" mode=""></xsl:template>-->
</xsl:stylesheet>
