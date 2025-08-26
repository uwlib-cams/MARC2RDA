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
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>

    <!-- 740 -->
    <xsl:template name="F740-xx-ldrtestite" expand-text="yes">
        <xsl:variable name="leader" select="ancestor::marc:record/marc:leader"/>
        <xsl:variable name="ldr06" select="substring($leader, 7, 1)"/>
        <xsl:variable name="ldr07" select="substring($leader, 8, 1)"/>
        <xsl:variable name="ldr08" select="substring($leader, 9, 1)"/>
        <xsl:if test="$ldr06 = ('a','c','d','e','f','i','j','m','t') or 
            ($ldr06 = 'a' and $ldr07 = ('a','c','d','m')) or 
            $ldr08 = 'a'">
            <rdaid:P40069>
                <xsl:value-of select="string-join(marc:subfield[@code = ('a','n','p')], ' ')"/>
            </rdaid:P40069>
        </xsl:if>
        <xsl:if test="$ldr06 = ('g', 'k', 'o', 'r')">            
            <rdaid:P40086>
                <xsl:value-of select="string-join(marc:subfield[@code = ('a','n','p')], ' ')"/>
            </rdaid:P40086>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F740-xx-ldrtestman">
        <xsl:variable name="leader" select="ancestor::marc:record/marc:leader"/>
        <xsl:variable name="ldr06" select="substring($leader, 7, 1)"/>
        <xsl:variable name="ldr07" select="substring($leader, 8, 1)"/>
        <xsl:variable name="ldr08" select="substring($leader, 9, 1)"/>
        <xsl:if test="$ldr06 = ('a','c','d','e','f','i','j','m','t') or 
            ($ldr06 = 'a' and $ldr07 = ('a','c','d','m')) or 
            $ldr08 = 'a'">
            <rdamd:P30265>
                <xsl:value-of select="string-join(marc:subfield[@code = ('a','n','p')], ' ')"/>
            </rdamd:P30265>
        </xsl:if>
        <xsl:if test="$ldr06 = ('g', 'k', 'o', 'r')">            
            <rdamd:P30128>
                <xsl:value-of select="string-join(marc:subfield[@code = ('a','n','p')], ' ')"/>
            </rdamd:P30128>
        </xsl:if>     
    </xsl:template>
    
    <!-- 752 -->
    
    <!-- if any $4 has an IRI for a work property, relate place to work using that property -->
    <xsl:template name="F752-xx-abcdfgh1234-work">
        <xsl:param name="baseID"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/>  
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '4']">
                <xsl:for-each select="marc:subfield[@code = '4'][starts-with(., 'http://rdaregistry.info/Elements/w/')]">
                    <xsl:element name="{concat('rdawo:P', substring-after(., '/P'))}">
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="$placeIRI"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- if any $4 has an IRI for a expression property, relate place to expression using that property -->
    <xsl:template name="F752-xx-abcdfgh1234-expression">
        <xsl:param name="baseID"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/>  
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '4']">
                <xsl:for-each select="marc:subfield[@code = '4'][starts-with(., 'http://rdaregistry.info/Elements/e/')]">
                    <xsl:element name="{concat('rdaeo:P', substring-after(., '/P'))}">
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="$placeIRI"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- handle all manifestation cases -->
    <xsl:template name="F752-xx-abcdfgh1234-manifestation">
        <xsl:param name="baseID"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/>  
        <xsl:choose>
            <!-- check for $e or $4 that matches all mapping cases -->
            <!-- $e and $4 are repeatable -->
            <xsl:when test="marc:subfield[@code = 'e'] or marc:subfield[@code = '4'][matches(., 'http://rdaregistry.info/Elements/[wemi]|dbp|mfp|prp|pup')]">
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:choose>
                        <!-- full RDA registry URI in $4 -->
                        <xsl:when test="starts-with(., 'http://rdaregistry.info/Elements/m/')">
                            <xsl:element name="{concat('rdamo:P', substring-after(., '/P'))}">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:value-of select="$placeIRI"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <!-- $4 codes -->
                        <xsl:when test=". = 'dbp'">
                            <rdamo:P30085 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test=". = 'mfp'">
                            <rdamo:P30087 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test=". = 'prp'">
                            <rdamo:P30086 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test=". = 'pup'">
                            <rdamo:P30088 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
                <!-- $e values -->
                <xsl:for-each select="marc:subfield[@code = 'e']">
                    <xsl:choose>
                        <!-- MARC relator code or term from $e -->
                        <xsl:when test="contains(., 'distribution')">
                            <rdamo:P30085 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test="contains(., 'manufacture')">
                            <rdamo:P30087 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test="contains(., 'production')">
                            <rdamo:P30086 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:when test="contains(., 'publication')">
                            <rdamo:P30088 rdf:resource="{$placeIRI}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamo:P30272 rdf:resource="{$placeIRI}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <!-- default to related place of manifestation -->
            <xsl:otherwise>
                <rdamo:P30272 rdf:resource="{$placeIRI}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- if any $4 has an IRI for an item property, create item and relate place to item using that property -->
    <xsl:template name="F752-xx-abcdfgh1234-item" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/> 
        <xsl:variable name="genID" select="generate-id(.)"/>
        <xsl:choose>
            <!-- check for $e or $4 that matches all mapping cases -->
            <!-- $e and $4 are repeatable -->
            <xsl:when test="marc:subfield[@code = '4'][starts-with(., 'http://rdaregistry.info/Elements/i/')]">
                <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                    <!--<xsl:call-template name="getmarc"/>-->
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                    <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                    <rdaio:P40049 rdf:resource="{$manIRI}"/>
                    <xsl:for-each select="marc:subfield[@code = '4'][starts-with(., 'http://rdaregistry.info/Elements/i/')]">
                        <xsl:element name="{concat('rdaio:P', substring-after(., '/P'))}">
                            <xsl:attribute name="rdf:resource">
                                <xsl:value-of select="$placeIRI"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:for-each>
                </rdf:Description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- mint place -->
    <xsl:template name="F752-xx-abcdfgh1234-place">
        <xsl:param name="baseID"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" />
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/>  
        <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
        
        <!-- Place string (codes: a–d, f–h) -->
        <xsl:if test="$placeSubfields">
            <rdf:Description rdf:about="{$placeIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <xsl:choose>
                    <xsl:when test="$sub2 != ''">
                        <rdapo:P70019 rdf:resource="{uwf:nomenIRI($baseID, ., $placeString, $sub2, 'place')}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdapd:P70019>
                            <xsl:value-of select="$placeString"/>
                        </rdapd:P70019>
                        <!-- check for 880 and add string as appelation of place if no source -->
                        <xsl:if test="@tag = '752' and marc:subfield[@code = '6']">
                            <xsl:variable name="occNum"
                                select="concat('752-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                            <xsl:for-each
                                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                <xsl:variable name="placeSubfields880" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
                                    @code = 'd' or @code = 'f' or @code = 'g' or
                                    @code = 'h']" />
                                <xsl:variable name="placeString880" select="string-join($placeSubfields880, '--')"/>
                                <rdapd:P70019>
                                    <xsl:value-of select="$placeString880"/>
                                </rdapd:P70019>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- create nomen if source -->
    <xsl:template name="F752-xx-abcdfgh1234-nomen">
        <xsl:param name="baseID"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, '--')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, ., $placeString, '')"/>  
        <xsl:variable name="sub2" select="marc:subfield[@code = '2'][1]"/>
        
        
        <!-- Place string (codes: a–d, f–h) -->
        <xsl:if test="$sub2 != ''">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseID, ., $placeString, $sub2, 'place')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$placeString"/>
                </rdand:P80068>
                <xsl:if test="@tag = '752' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('752-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <!-- check for 880 and add as nomen string -->
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <xsl:variable name="placeSubfields880" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
                            @code = 'd' or @code = 'f' or @code = 'g' or
                            @code = 'h']" />
                        <xsl:variable name="placeString880" select="string-join($placeSubfields880, '--')"/>
                        <rdand:P80068>
                            <xsl:value-of select="$placeString880"/>
                        </rdand:P80068>
                    </xsl:for-each>
                </xsl:if>
                <!-- look up source in $2 -->
                <xsl:copy-of select="uwf:s2NomenNameTitleSchemes($sub2)"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 753 -->   
    <xsl:template name="F753-xx-abc12" expand-text="yes">  
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or @code = '1' or @code = '2']"/>
        
        <xsl:if test="$subfields">
            <xsl:for-each select="$subfields">
                <xsl:choose>
                    <xsl:when test="@code = 'a'">
                        <xsl:text>Make and model of machine: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'b'">
                        <xsl:text>Programming language: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = 'c'">
                        <xsl:text>Operating system: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = '1'">
                        <xsl:text>URI: </xsl:text>
                    </xsl:when>
                    <xsl:when test="@code = '2'">
                        <xsl:text>Source: </xsl:text>
                    </xsl:when>
                </xsl:choose>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>.</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 754 --> 
    <xsl:template name="F754-xx-acdxz-item" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, $context)"/>
        <xsl:variable name="scheme" select="$context/marc:subfield[@code='2'][1]"/>
        
        <!-- rdf:Description for item -->
        <rdf:Description rdf:about="{$itemIRI}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <!-- item id -->
            <rdaid:P40001>{concat('ite#',$baseID, generate-id())}</rdaid:P40001>
            <!-- relationship to manifestation -->
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            
            <!--($z) Public note -->
            <xsl:for-each select="$context/marc:subfield[@code='z']">
                <rdaid:P40028>Taxonomic identification note: <xsl:value-of select="."/></rdaid:P40028>
            </xsl:for-each>
            
            <!--($x) Non-public note -->
            <xsl:for-each select="$context/marc:subfield[@code='x']">
                <xsl:variable name="metaIRI" select="uwf:metaWorIRI($baseID, .)"/>
                <rdaio:P40164 rdf:resource="{$metaIRI}"/>
            </xsl:for-each>
            
            <!-- public and non-public notes for linked 880s -->
            <xsl:if test="@tag = '754' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('754-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:for-each select="marc:subfield[@code='z']">
                        <rdaid:P40028>
                            <xsl:text>Taxonomic identification note: {.}</xsl:text>
                        </rdaid:P40028>
                    </xsl:for-each>
                    <xsl:for-each select="marc:subfield[@code = 'x']">
                        <xsl:variable name="metaIRI880" select="uwf:metaWorIRI($baseID, .)"/>
                        <rdaio:P40164 rdf:resource="{$metaIRI880}"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:if>
            
            <!-- relationships to nomens -->
            
            <!-- $c + $a pairs -->
            <xsl:for-each select="$context/marc:subfield[@code='c']">
                <xsl:variable name="cat" select="."/>
                <xsl:variable name="aField" select="following-sibling::marc:subfield[@code='a'][1]"/>
                <xsl:if test="$aField">
                    <!-- IRI uses uwf:nomenIRI with type 'nomen' -->
                    <xsl:variable name="nomenIRI" select="uwf:nomenIRI($baseID, ., $aField, $scheme, 'nomen')"/>
                    <rdaio:P40079 rdf:resource="{$nomenIRI}"/>
                </xsl:if>
            </xsl:for-each>
            
            <!-- $d: Common or alternative name -->
            <xsl:for-each select="$context/marc:subfield[@code='d']">
                <!-- IRI uses uwf:nomenIRI with type 'nomen' -->
                <xsl:variable name="nomenIRI" select="uwf:nomenIRI($baseID, ., ., $scheme, 'nomen')"/>
                <rdai:P40079 rdf:resource="{$nomenIRI}"/>
            </xsl:for-each>
        </rdf:Description>
    </xsl:template>
    
    <!-- nomen named template -->
    <xsl:template name="F754-xx-acdxz-nomen" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, $context)"/>
        <xsl:variable name="scheme" select="$context/marc:subfield[@code='2'][1]"/>
        
        <!-- $c + $a pairs -->
        <!-- mint a nomen for each pair -->
        <xsl:for-each select="$context/marc:subfield[@code='c']">
            <xsl:variable name="position" select="position()"/>
            <xsl:variable name="cat" select="."/>
            <xsl:variable name="aField" select="following-sibling::marc:subfield[@code='a'][1]"/>
            <xsl:if test="$aField">
                <xsl:variable name="nomenIRI" select="uwf:nomenIRI($baseID, ., $aField, $scheme, 'nomen')"/>
                <rdf:Description rdf:about="{$nomenIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="$aField"/>
                    </rdand:P80068>
                    <rdand:P80078>
                        <xsl:value-of select="$cat"/>
                    </rdand:P80078>
                    <xsl:if test="$scheme != ''">
                        <rdand:P80069>
                            <xsl:value-of select="$scheme"/>
                        </rdand:P80069>
                    </xsl:if>
                    <rdand:P80067>
                        <xsl:text>Taxonomic Identification</xsl:text>
                    </rdand:P80067>
                    <!-- if linked 880 AND the $a is found in the same position, add as 'equivalent to' -->
                    <xsl:if test="../@tag = '754' and ../marc:subfield[@code = '6']">
                        <xsl:variable name="occNum"
                            select="concat('754-', substring(../marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:for-each select="marc:subfield[@code = 'c']">
                                <xsl:if test="position() = $position">
                                    <xsl:variable name="aField880" select="following-sibling::marc:subfield[@code='a'][1]"/>
                                    <rdand:P80113>
                                        <xsl:value-of select="$aField880"/>
                                    </rdand:P80113>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        
        <!-- $d: Common or alternative name -->
        <!-- mint a nomen for each $d -->
        <xsl:for-each select="$context/marc:subfield[@code='d']">
            <xsl:variable name="position" select="position()"/>
            <xsl:variable name="nomenIRI" select="uwf:nomenIRI($baseID, ., ., $scheme, 'nomen')"/>
            <rdf:Description rdf:about="{$nomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068><xsl:value-of select="."/></rdand:P80068>
                <rdand:P80078>Common or alternative name</rdand:P80078>
                <rdand:P80067>Taxonomic Identification</rdand:P80067>
                <!-- if linked 880 AND the $d is found in the same position, add as 'equivalent to' -->
                <xsl:if test="../@tag = '754' and ../marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('754-', substring(../marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <xsl:for-each select="marc:subfield[@code = 'd']">
                            <xsl:if test="position() = $position">
                                <rdand:P80113>
                                    <xsl:value-of select="."/>
                                </rdand:P80113>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- metadata work named template -->
    <xsl:template name="F754-xx-acdxz-metaWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, $context)"/>
        
        <!--($x) Non-public note -->
        <!-- rdf:Description for metadata work containing non-public note -->
        <xsl:for-each select="$context/marc:subfield[@code='x']">
            <xsl:variable name="metaIRI" select="uwf:metaWorIRI($baseID, .)"/>
            <rdf:Description rdf:about="{$metaIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
                <rdawd:P10002>{concat('metaWor#', $baseID, generate-id())}</rdawd:P10002>
                <rdf:subject rdf:resource="{$itemIRI}"/>
                <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/P40028"/>
                <rdf:object>
                    <xsl:text>Taxonomic identification note: {.}</xsl:text>
                </rdf:object>
                <rdawd:P10004>Private</rdawd:P10004>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 760 --> 
    <xsl:template name="F760-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Is subseries of: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 762 --> 
    <xsl:template name="F762-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Has subseries: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 765 --> 
    <xsl:template name="F765-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Is translation of]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 767 --> 
    <xsl:template name="F767-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Is translation as]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <!-- 770 -->
    
    <xsl:template name="F770-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Has supplement]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 772 -->   
    <xsl:template name="F772-xx-abcdefghijklmnpqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Is supplement to]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 773 --> 
    <xsl:template name="F773-xx-abcdefghijklmnpqrstuvwxyz34" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'd' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'k' or @code = 'l' or @code = 'm' or
            @code = 'n' or @code = 'o' or @code = 'p' or
            @code = 'q' or @code = 'r' or @code = 's' or
            @code = 't' or @code = 'u' or @code = 'w' or
            @code = 'x' or @code = 'y' or @code = 'z']"/>
        
        <xsl:if test="$subfields">
            <xsl:text>Is part of: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
    
            <!-- Append period if last subfield doesn't end in one -->
            <xsl:variable name="lastSubfieldText" select="normalize-space($subfields[last()])"/>
            <xsl:choose>
                <xsl:when test="not(ends-with($lastSubfieldText, '.'))">
                    <xsl:text>.</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text> Applies to: </xsl:text>
                <xsl:value-of select="normalize-space(marc:subfield[@code = '3'])"/>
                <xsl:text>.</xsl:text>
            </xsl:if>
            
            <!-- Add $4 sentence if present -->
            <xsl:if test="marc:subfield[@code = '4']">
                <xsl:text> Relationship code or URI: </xsl:text>
                <xsl:value-of select="normalize-space(marc:subfield[@code = '4'])"/>
                <xsl:text>.</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

        
    <!-- 774 -->   
    <xsl:template name="F774-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Has part]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 775 -->
    <xsl:template name="F775-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>[Other edition available]: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 776 --> 
    <xsl:template name="F776-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Has equivalent: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 777 --> 
    <xsl:template name="F777-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>On carrier unit with: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 780 -->
    <xsl:template name="F780-x0-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:if test="@ind2 = '0'">
            <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
                @code = 'd' or @code = 'e' or @code = 'f' or
                @code = 'g' or @code = 'h' or @code = 'i' or
                @code = 'j' or @code = 'k' or @code = 'l' or
                @code = 'm' or @code = 'n' or @code = 'o' or
                @code = 'p' or @code = 'q' or @code = 'r' or
                @code = 's' or @code = 't' or @code = 'u' or
                @code = 'v' or @code = 'w' or @code = 'x' or
                @code = 'y' or @code = 'z']" />
            
            <xsl:if test="$subfields">
                <xsl:text>Is continuation of: </xsl:text>
                <xsl:for-each select="$subfields">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    

    <!-- 785 -->
    <xsl:template name="F785-x0-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:if test="@ind2 = '0'">
            <xsl:variable name="subfields" select="marc:subfield[
                @code = 'a' or @code = 'b' or @code = 'c' or
                @code = 'd' or @code = 'e' or @code = 'f' or
                @code = 'g' or @code = 'h' or @code = 'i' or
                @code = 'j' or @code = 'k' or @code = 'l' or
                @code = 'm' or @code = 'n' or @code = 'o' or
                @code = 'p' or @code = 'q' or @code = 'r' or
                @code = 's' or @code = 't' or @code = 'u' or
                @code = 'v' or @code = 'w' or @code = 'x' or
                @code = 'y' or @code = 'z']" />
            
            <xsl:if test="$subfields">
                <xsl:text>Is continued by: </xsl:text>
                <xsl:for-each select="$subfields">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 786 -->
    <xsl:template name="F786-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Has source consulted: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>    
    
    <!-- 787 -->
    <xsl:template name="F787-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Related resource: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>    
    
</xsl:stylesheet>
