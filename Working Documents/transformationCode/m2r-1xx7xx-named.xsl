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
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
    version="3.0">
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    
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
            @code = 'x' or @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>Is part of: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:text>: </xsl:text>
    
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text>Applies to: </xsl:text>
                <xsl:value-of select="normalize-space(marc:subfield[@code = '3'])"/>
                <xsl:text>. </xsl:text>
            </xsl:if>
            
            <xsl:if test="marc:subfield[@code = '4']">
                <xsl:text>Relationship code or URI: </xsl:text>
                <xsl:value-of select="normalize-space(marc:subfield[@code = '4'])"/>
                <xsl:text> . </xsl:text>
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
