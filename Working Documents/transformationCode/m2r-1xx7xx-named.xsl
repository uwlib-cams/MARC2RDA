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
    
    <!-- 754 --> 
    <xsl:template name="F754-xx-acdxz" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:param name="context"/>
        
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, $context)"/>
        <xsl:variable name="genID" select="generate-id($context)"/>
        <xsl:variable name="itemID" select="concat('ite#', $baseID, $genID)"/>
        
        <!-- Base item description and $z public note -->
        <rdf:Description rdf:about="{$itemIRI}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{$itemID}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{$manIRI}"/>
            
            <xsl:for-each select="$context/marc:subfield[@code='z']">
                <rdaid:P40028>Taxonomic identification note: <xsl:value-of select="."/></rdaid:P40028>
            </xsl:for-each>
        </rdf:Description>
        
        <!-- Create nomen from each $a preceded by a $c -->
        <xsl:for-each select="$context/marc:subfield[@code='a']">
            <xsl:variable name="name" select="."/>
            <xsl:variable name="cat" select="preceding-sibling::marc:subfield[@code='c'][1]"/>
            <xsl:if test="$cat">
                <xsl:variable name="nomenID" select="concat($itemID, '-nomen-', position())"/>
                
                <rdf:Description rdf:about="http://example.org/nomen/{$nomenID}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/n/Nomen"/>
                    <rdan:P80068><xsl:value-of select="$name"/></rdan:P80068>
                    <rdan:P80078><xsl:value-of select="$cat"/></rdan:P80078>
                    <rdan:P80067>Taxonomic Identification</rdan:P80067>
                </rdf:Description>
                
                <rdf:Description rdf:about="{$itemIRI}">
                    <rdai:P40079 rdf:resource="http://example.org/nomen/{$nomenID}"/>
                </rdf:Description>
            </xsl:if>
        </xsl:for-each>
        
        <!-- Create nomen from each $d -->
        <xsl:for-each select="$context/marc:subfield[@code='d']">
            <xsl:variable name="nomenID" select="concat($itemID, '-d-', position())"/>
            
            <rdf:Description rdf:about="http://example.org/nomen/{$nomenID}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/n/Nomen"/>
                <rdan:P80068><xsl:value-of select="."/></rdan:P80068>
                <rdan:P80078>Common or alternative name</rdan:P80078>
                <rdan:P80067>Taxonomic Identification</rdan:P80067>
            </rdf:Description>
            
            <rdf:Description rdf:about="{$itemIRI}">
                <rdai:P40079 rdf:resource="http://example.org/nomen/{$nomenID}"/>
            </rdf:Description>
        </xsl:for-each>
        
        <!-- Handle $x as private note with reified RDF Statement -->
        <xsl:for-each select="$context/marc:subfield[@code='x']">
            <xsl:variable name="stmtID" select="concat('stmt-', generate-id())"/>
            
            <rdf:Statement rdf:about="http://example.org/statement/{$stmtID}">
                <rdf:type rdf:resource="rdf:Statement"/>
                <rdf:subject rdf:resource="{$itemIRI}"/>
                <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/P40028"/>
                <rdf:object>Taxonomic identification note: <xsl:value-of select="."/></rdf:object>
                <rdaid:P40164>private</rdaid:P40164>
            </rdf:Statement>
            
            <rdf:Description rdf:about="{$itemIRI}">
                <rdai:P40164 rdf:resource="http://example.org/statement/{$stmtID}"/>
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
            <xsl:text>[Has equivalent]: </xsl:text>
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
                <xsl:text>[Is continuation of]: </xsl:text>
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
                <xsl:text>[Is continued by]: </xsl:text>
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
            <xsl:text>[Related resource]: </xsl:text>
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
    
</xsl:stylesheet>
