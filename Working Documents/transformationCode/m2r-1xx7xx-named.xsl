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
    <xsl:template name="F752-xx-abcdfgh1234">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        <xsl:variable name="placeSubfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'f' or @code = 'g' or
            @code = 'h' or @code = '1' or @code = '2' or
            @code = '4']" /> 
        <xsl:variable name="placeString" select="string-join($placeSubfields, ', ')"/>
        <xsl:variable name="placeIRI" select="uwf:placeIRI($baseID, $context, $placeString, '')"/>        
        
        <xsl:variable name="subfield4" select="lower-case($context/marc:subfield[@code='4'])"/>
        <xsl:variable name="subfieldE" select="lower-case($context/marc:subfield[@code='e'])"/>
        
        <rdf:Description rdf:about="{$manIRI}">
            <xsl:choose>
                
                <!-- full RDA registry URI in $4 -->
                <xsl:when test="starts-with($subfield4, 'http://rdaregistry.info/Elements/')">
                    <xsl:element name="{concat(
                        substring-before(substring-after($subfield4, 'http://rdaregistry.info/Elements/'), '/'),
                        ':P',
                        substring-after($subfield4, '/P')
                        )}">
                        <xsl:attribute name="rdf:resource">
                            <xsl:value-of select="$placeIRI"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:when>
                
                <!-- MARC relator code or term from $e -->
                <xsl:when test="$subfield4 = 'dbp' or $subfieldE = 'distribution'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdam:P30085 rdf:resource="{$placeIRI}"/>
                </xsl:when>
                <xsl:when test="$subfield4 = 'mfp' or $subfieldE = 'manufacture'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdam:P30087 rdf:resource="{$placeIRI}"/>
                </xsl:when>
                <xsl:when test="$subfield4 = 'prp' or $subfieldE = 'production'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdam:P30086 rdf:resource="{$placeIRI}"/>
                </xsl:when>
                <xsl:when test="$subfield4 = 'pup' or $subfieldE = 'publication'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdam:P30088 rdf:resource="{$placeIRI}"/>
                </xsl:when>
                
                <!-- Default fallback -->
                <xsl:otherwise>
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdam:P30272 rdf:resource="{$placeIRI}"/>
                </xsl:otherwise>
            </xsl:choose>
        </rdf:Description>
        
        <!-- Place string (codes: a–d, f–h, 1, 2, 4) -->
        <xsl:if test="$placeSubfields">
            <rdf:Description rdf:about="{$placeIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdaid:P80175>
                    <xsl:value-of select="$placeString"/>
                </rdaid:P80175>
            </rdf:Description>
        </xsl:if>
        
        <!-- Role/type (e) -->
        <xsl:for-each select="$context/marc:subfield[@code='e'][normalize-space(.) != '']">
            <rdf:Description rdf:about="{$placeIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdai:P80176>
                    <xsl:value-of select="."/>
                </rdai:P80176>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 753 -->   
    <xsl:template name="F753-xx-abc12" expand-text="yes">  
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or 
            @code = 'c' or @code = '1' or @code = '2']"/>
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
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <!-- 754 --> 
    <xsl:template name="F754-xx-acdxz" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, $context)"/>
        <xsl:variable name="scheme" select="$context/marc:subfield[@code='2'][1]"/>
        
        <!--($z) Public note -->
        <xsl:for-each select="$context/marc:subfield[@code='z']">
            <rdf:Description rdf:about="{$itemIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdai:P40028>Taxonomic identification note: <xsl:value-of select="."/></rdai:P40028>
            </rdf:Description>
        </xsl:for-each>
        
        <!--($x) Non-public note -->
        <xsl:for-each select="$context/marc:subfield[@code='x']">
            <xsl:variable name="metaIRI" select="uwf:metaWorIRI($baseID, .)"/>
            <rdf:Description rdf:about="{$metaIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
                <rdawd:P10002>{concat('metaWor#', $baseID, generate-id())}</rdawd:P10002>
                <rdf:subject rdf:resource="{$itemIRI}"/>
                <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/P40028"/>
                <rdf:object>Taxonomic identification note: <xsl:value-of select="."/></rdf:object>
                <rdawd:P10004>Private</rdawd:P10004>
            </rdf:Description>
        </xsl:for-each>
        
        <!-- $c + $a pairs -->
        <xsl:for-each select="$context/marc:subfield[@code='c']">
            <xsl:variable name="cat" select="."/>
            <xsl:variable name="aField" select="following-sibling::marc:subfield[@code='a'][1]"/>
            <xsl:if test="$aField">
                <xsl:variable name="nomenIRI" select="uwf:conceptIRI($scheme, $aField)"/>
                <rdf:Description rdf:about="{$nomenIRI}">
                    <xsl:copy-of select="uwf:fillConcept($aField, $scheme, $cat, '754')"/>
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                    <rdan:P80067>Taxonomic Identification</rdan:P80067>
                </rdf:Description>
                <rdf:Description rdf:about="{$itemIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                    <rdai:P40079 rdf:resource="{$nomenIRI}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        
        <!-- $d: Common or alternative name -->
        <xsl:for-each select="$context/marc:subfield[@code='d']">
            <xsl:variable name="nomenIRI" select="uwf:conceptIRI('common', .)"/>
            <rdf:Description rdf:about="{$nomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdan:P80068><xsl:value-of select="."/></rdan:P80068>
                <rdan:P80078>Common or alternative name</rdan:P80078>
                <rdan:P80067>Taxonomic Identification</rdan:P80067>
            </rdf:Description>
            <rdf:Description rdf:about="{$itemIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdai:P40079 rdf:resource="{$nomenIRI}"/>
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
