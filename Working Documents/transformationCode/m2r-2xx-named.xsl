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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    <!-- F245-xx-anps processes $a $n $p $s of MARC 245 when:
        1. they are exist with or wthout a $b
        2. with a $b preceeded by $n or $p ending with an equal sign
     No other scenarios were considered.
    ISBD punctuation was eliminated.
-->
    <xsl:template name="F245-xx-anps">
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
            <!-- a with no following n, p, or s subfields -->
            <xsl:when test="marc:subfield[@code = 'a'][not(following-sibling::*)] or
                marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]">
                <rdamd:P30156>
                    <xsl:choose>
                        <!-- remove ending = : ; / if ISBD-->
                        <!-- remove any square brackets [] -->
                        <xsl:when test="$isISBD">
                            <xsl:value-of select="replace(marc:subfield[@code = 'a'], '\s*[=:;/]$', '') => translate('[]', '')"/>
                        </xsl:when>
                        <!-- remove any square brackets [] if not ISBD -->
                        <xsl:otherwise>
                            <xsl:value-of select="translate(marc:subfield[@code = 'a'], '[]', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </rdamd:P30156>
                <!-- if square brackets [] were removed, add not on manifestation -->
                <xsl:if test="contains(marc:subfield[@code = 'a'], '[') and contains(marc:subfield[@code = 'a'], ']')">
                    <rdamd:P30137>Title proper is assigned by the cataloguing agency.</rdamd:P30137>
                </xsl:if>
            </xsl:when>
            <!-- a with following n, p, s -->
            <xsl:otherwise>
                <!-- put together title from a and any directly following n, p, s fields -->
                <!-- remove ending = : ; / -->
                <xsl:variable name="title">
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD">
                            <xsl:value-of select="replace(marc:subfield[@code = 'a'], '\s*[=:;/]$', '')"/>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::*[@code = 'b'])]">
                                <xsl:value-of select="replace(., '\s*[=:;/]$', '')"/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::*[@code = 'b'])]">
                                <xsl:value-of select="."/>
                                <xsl:if test="position() != last()">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- remove any square brackets -->
                <rdamd:P30156>
                    <xsl:value-of select="translate($title, '[]', '')"/>
                </rdamd:P30156>
                <!-- if square brackets [] were removed, add not on manifestation -->
                <xsl:if test="contains($title, '[') and contains($title, ']')">
                    <xsl:if test="contains(marc:subfield[@code = 'a'], '[') and contains(marc:subfield[@code = 'a'], ']')">
                        <rdamd:P30137>Title proper is assigned by the cataloguing agency.</rdamd:P30137>
                    </xsl:if>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template name="F245-xx-anps">
        <xsl:if test="marc:subfield[@code = 'n'] or marc:subfield[@code = 'p'] or marc:subfield[@code = 's']">
            <xsl:choose>
                <xsl:when test="not(ends-with(marc:subfield[@code = 'b']/preceding-sibling::*[1], '='))">
                    <rdamd:P30156>
                        <xsl:for-each
                            select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 's']">
                            <xsl:choose>
                                <xsl:when test="position() != last()">
                                    <xsl:choose>
                                        <xsl:when test="ends-with(., '...')">
                                            <xsl:value-of select="."/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace(., '\s*[:/=\.,]$', '') => translate('[]', '')" separator=", "/>
                                            <xsl:text>, </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:choose>
                                        <xsl:when test="ends-with(., '...')">
                                            <xsl:value-of select="."/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace(., '\s*[:/=\.,]$', '') => translate('[]', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </rdamd:P30156>
                </xsl:when>
                <xsl:when test="marc:subfield[@code = 'b']">
                    <xsl:for-each select="marc:subfield[@code = 'b']">
                        <xsl:choose>
                            <xsl:when test="ends-with(preceding-sibling::marc:subfield[1], '=')">
                                <rdamd:P30134>
                                    <xsl:for-each
                                        select="preceding-sibling::*[@code = 'a' or @code = 'n' or @code = 'p' or @code = 's']">
                                       <xsl:choose>
                                           <xsl:when test="ends-with(., '...')">
                                               <xsl:value-of select="."/>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:value-of select="replace(., '\s*[/:\.=,]$', '') => translate('[]', '')"/>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                        <xsl:if test="position() != last()">
                                            <xsl:text>, </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </rdamd:P30134>
                                <rdamd:P30134>
                                    <xsl:choose>
                                        <xsl:when test="ends-with(., '...')">
                                            <xsl:value-of select="."/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="replace(., '\s*[/:\.=,]$', '') => translate('[]', '')"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:if
                                        test="following-sibling::*[@code = 'p' or @code = 'n' or @code = 's']">
                                        <xsl:text>, </xsl:text>
                                        <xsl:for-each
                                            select="following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']">
                                            <xsl:value-of select="replace(., '\s*[/:\.=,]$', '') => translate('[]', '')"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text>, </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </rdamd:P30134>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:template>-->
    <!-- F245-xx-a treats all $a the same -->
    <!--<xsl:template name="F245-xx-a" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'a'] and (not(marc:subfield[@code = 'n']) and not(marc:subfield[@code = 'p']) and not(marc:subfield[@code = 's']))">
            <rdamd:P30156>
                <xsl:choose>
                    <xsl:when test="ends-with(marc:subfield[@code = 'a'], '...')">
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(marc:subfield[@code = 'a'], '\s*[/:\.=,]$', '') => translate('[]', '')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdamd:P30156>
        </xsl:if>
    </xsl:template>-->
    <!-- F245-xx-b processes 4 conditions
        1. preceedingSibling endswith '=' AND doesn't contain ' = ' sp AND followingSibling is neither $n $p or $s
        2. preceedingSibling endsWith '=' AND does contain ' = ' sp AND followingSibling is neither $n $p or $s
        3. preceedingSibling doesn't endWith ' = ' AND contains ' = '
        4. Just a $b, no MARC "parallel statements.
    -->
    <xsl:template name="F245-xx-ISBD" expand-text="yes">
        <!-- does not account for subsequent titles (aggregates) -->
        <xsl:param name="subfield"/>
        <xsl:variable name="ISBDString">
            <xsl:choose>
                <xsl:when test="@code = 'b' and $subfield/following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']">
                    <xsl:value-of select="$subfield | following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']" separator = " "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$subfield"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:comment>
            <xsl:value-of select="$ISBDString"/>
        </xsl:comment>
        <!-- separate by parallel statements = -->
        <xsl:for-each select="tokenize($ISBDString, ' = ')">
            <!-- only process each tokenized string if it is not blank -->
            <xsl:if test="exists(.)">
                <xsl:choose>
                    <xsl:when test="position() = 1">
                        <xsl:choose>
                            <!-- If : is present, there is other title information, separate out -->
                            <xsl:when test="contains(., ' : ')">
                                <xsl:for-each select="tokenize(., ' : ')"> 
                                    <xsl:choose>
                                        <!-- if / is present there is statement of responsibility -->
                                        <!-- : always precedes / if it is present -->
                                        <xsl:when test="contains(., ' / ')">
                                            <xsl:for-each select="tokenize(., ' / ')">
                                                <xsl:choose>
                                                    <!-- this means it came before / and is other title info -->
                                                    <xsl:when test="position() = 1">
                                                        <rdamd:P30142>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                        </rdamd:P30142>
                                                        <xsl:if test="contains(., '[') and contains(., ']')">
                                                            <rdamd:P30137>
                                                                <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <!-- this is statement of responsibility, split by ;  -->
                                                    <xsl:otherwise>
                                                        <xsl:for-each select="tokenize(., ' ; ')">
                                                            <rdamd:P30105>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                            </rdamd:P30105>
                                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no / included in subfield, or / is at the end of the subfield -->
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <!-- this means it came before the : and is based on the preceding subfield's ending punctuation -->
                                                <xsl:when test="position() = 1">
                                                    <xsl:choose>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                                            <rdamd:P30156>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                            </rdamd:P30156>
                                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                                            <rdamd:P30142>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                            </rdamd:P30142>
                                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:when>
                                                        <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                                <rdamd:P30105>
                                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                                </rdamd:P30105>
                                                                <xsl:if test="contains(., '[') and contains(., ']')">
                                                                    <rdamd:P30137>
                                                                        <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                                    </rdamd:P30137>
                                                                </xsl:if>
                                                            </xsl:for-each>   
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <ex:ERROR>No ISBD punctuation present in 245 subfield preceding subfield {$subfield/@code}</ex:ERROR>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <!-- this is after : and is other title info -->
                                                <xsl:otherwise>
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="contains(., '[') and contains(., ']')">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no other title info, but has statement of responsibility -->
                            <xsl:when test="contains(., ' / ') and not(contains(., ' : '))">
                                <xsl:for-each select="tokenize(., ' / ')">
                                    <xsl:choose>
                                        <!-- first is based on preceding subfield's ending punctuation -->
                                        <xsl:when test="position() = 1">
                                            <xsl:choose>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="contains(., '[') and contains(., ']')">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                                    <rdamd:P30156>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                    </rdamd:P30156>
                                                    <xsl:if test="contains(., '[') and contains(., ']')">
                                                        <rdamd:P30137>
                                                            <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                                    <xsl:for-each select="tokenize(., ' ; ')">
                                                        <rdamd:P30105>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                        </rdamd:P30105>
                                                        <xsl:if test="contains(., '[') and contains(., ']')">
                                                            <rdamd:P30137>
                                                                <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:for-each>   
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <ex:ERROR>No ISBD punctuation present in 245 subfield preceding subfield {$subfield/@code}</ex:ERROR>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <!-- the rest is statement of responsibility, split by ;  -->
                                        <xsl:otherwise>
                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                <rdamd:P30105>
                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                </rdamd:P30105>
                                                <xsl:if test="contains(., '[') and contains(., ']')">
                                                    <rdamd:P30137>
                                                        <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                    </rdamd:P30137>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- no internal ISBD punctuation, property is based on preceding subfield's ending punctuation -->
                                <xsl:choose>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], ':')">
                                        <rdamd:P30142>
                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                        </rdamd:P30142>
                                        <xsl:if test="contains(., '[') and contains(., ']')">
                                            <rdamd:P30137>
                                                <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                            </rdamd:P30137>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '=')">
                                        <rdamd:P30156>
                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                        </rdamd:P30156>
                                        <xsl:if test="contains(., '[') and contains(., ']')">
                                            <rdamd:P30137>
                                                <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                            </rdamd:P30137>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:when test="ends-with($subfield/preceding-sibling::*[1], '/')">
                                        <xsl:for-each select="tokenize(., ' ; ')">
                                            <rdamd:P30105>
                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                            </rdamd:P30105>
                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                <rdamd:P30137>
                                                    <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:for-each>   
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <ex:ERROR>No ISBD punctuation present in 245 subfield preceding subfield {$subfield/@code}</ex:ERROR>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose> 
                    </xsl:when>
                    <!-- on right side of =  -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- If : is present, there is other title information, separate out -->
                            <xsl:when test="contains(., ' : ')">
                                <xsl:for-each select="tokenize(., ' : ')"> 
                                    <xsl:choose>
                                        <!-- if / is present there is statement of responsibility -->
                                        <!-- : always precedes / if it is present -->
                                        <xsl:when test="contains(., ' / ')">
                                            <xsl:for-each select="tokenize(., ' / ')">
                                                <xsl:choose>
                                                    <!-- this means it came before / and is other title info -->
                                                    <xsl:when test="position() = 1">
                                                        <rdamd:P30142>
                                                            <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                        </rdamd:P30142>
                                                        <xsl:if test="contains(., '[') and contains(., ']')">
                                                            <rdamd:P30137>
                                                                <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                            </rdamd:P30137>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <!-- this is statement of responsibility, split by ;  -->
                                                    <xsl:otherwise>
                                                        <xsl:for-each select="tokenize(., ' ; ')">
                                                            <rdamd:P30105>
                                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                            </rdamd:P30105>
                                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                                <rdamd:P30137>
                                                                    <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                                </rdamd:P30137>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <!-- no / included in subfield, or / is at the end of the subfield -->
                                        <xsl:otherwise>
                                            <xsl:choose>
                                                <!-- this means it came before the : is title proper -->
                                                <xsl:when test="position() = 1">
                                                    <rdamd:P30156>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                    </rdamd:P30156>
                                                    <xsl:if test="contains(., '[') and contains(., ']')">
                                                        <rdamd:P30137>
                                                            <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:when>
                                                <!-- this is after : and is other title info -->
                                                <xsl:otherwise>
                                                    <rdamd:P30142>
                                                        <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                    </rdamd:P30142>
                                                    <xsl:if test="contains(., '[') and contains(., ']')">
                                                        <rdamd:P30137>
                                                            <xsl:text>Other title information is assigned by the cataloguing agency.</xsl:text>
                                                        </rdamd:P30137>
                                                    </xsl:if>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- no other title info, but has statement of responsibility -->
                            <xsl:when test="contains(., ' / ') and not(contains(., ' : '))">
                                <xsl:for-each select="tokenize(., ' / ')">
                                    <xsl:choose>
                                        <!-- first is title proper -->
                                        <xsl:when test="position() = 1">
                                            <rdamd:P30156>
                                                <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                            </rdamd:P30156>
                                            <xsl:if test="contains(., '[') and contains(., ']')">
                                                <rdamd:P30137>
                                                    <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                                </rdamd:P30137>
                                            </xsl:if>
                                        </xsl:when>
                                        <!-- the rest is statement of responsibility, split by ;  -->
                                        <xsl:otherwise>
                                            <xsl:for-each select="tokenize(., ' ; ')">
                                                <rdamd:P30105>
                                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                                </rdamd:P30105>
                                                <xsl:if test="contains(., '[') and contains(., ']')">
                                                    <rdamd:P30137>
                                                        <xsl:text>Statement of responsibility is assigned by the cataloguing agency.</xsl:text>
                                                    </rdamd:P30137>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- If there is no additional punctuation, it is a parallel title -->
                            <xsl:otherwise>
                                <rdamd:P30156>
                                    <xsl:value-of select="replace(., '\s*[=:;/]$', '') => translate('[]', '')"/>
                                </rdamd:P30156>
                                <xsl:if test="contains(., '[') and contains(., ']')">
                                    <rdamd:P30137>
                                        <xsl:text>Title proper is assigned by the cataloguing agency.</xsl:text>
                                    </rdamd:P30137>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-b">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when
                    test="ends-with(preceding-sibling::*[1], '=') and not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'])">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30134>
                            <xsl:choose>
                                <xsl:when test="ends-with(., '...')">
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="replace(., '\s*[/:\.=,]$', '') => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30134>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30142>
                        <xsl:value-of select="replace(., '\s*[/:=,]$', '') => translate('[]', '')"/>
                    </rdamd:P30142>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F245-xx-bc-ISBD">
        <xsl:for-each select="marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']">
            <xsl:call-template name="F245-xx-ISBD">
                <xsl:with-param name="subfield" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- F245-xx-c allows for two conditions: when there is ' = ' in the subfield and when there isn't -->
    <xsl:template name="F245-xx-c">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:for-each select="tokenize(., ' = ')">
                <rdamd:P30105>
                    <xsl:value-of select="replace(., '\s*[;=/:,]$', '') => translate('[]', '')"/>
                </rdamd:P30105>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F245-xx-f-g">
        <xsl:for-each select="marc:subfield[@code='f'] | marc:subfield[@code = 'g'] ">
            <rdamd:P30278>
                <xsl:value-of select="replace(., '\s*[:/=\.,]$', '')"/>
            </rdamd:P30278>
        </xsl:for-each>
     </xsl:template>
    <xsl:template name="F245-xx-h" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <rdamd:P30002>
                <xsl:value-of select="replace(.,'^\[','') => replace('[ ]?[=/\.;]$','') => replace('[\]]$','')"/>
            </rdamd:P30002>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F245-xx-k" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'k']">
            <rdamd:P30137>
                <xsl:value-of select="concat(upper-case(substring(., 1, 1)), substring(., 2)) => replace('\s*[,\.;,]$', '') => concat('.')"/>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- F264-xx-abc processes MARC 264 entered with ISBD punctuation as an RDA "statement."
         All subfield values are concatenated with a space added between
             (may result in double-spaces in the output)-->
    <xsl:template name="F264-xx-abc" expand-text="yes">
        <xsl:value-of select="marc:subfield[not(@code = '6')][not(@code = '3')]"
                    separator=" "/>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- F264-xx-abc-notISBD processes MARC 264 entered without ISBD punctuation as an RDA "statement". All subfield values are concatenated with subfield codes and a space inserted. There may be double spaces in the output. -->
    <xsl:template name="F264-xx-abc-notISBD" expand-text="yes">
        <xsl:for-each select="marc:subfield[not(@code = '6')][not(@code = '3')]">
            <xsl:text>$</xsl:text>
            <xsl:value-of select="@code"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    <!-- F264-x0-a_b_c processes each MARC 264 subfield even if repeated then creates values for every value on either side of an equal sign, if present, except for $c, where no parallel statements are anticipated. Also strips terminal punctuation in the subfields. -->
    <xsl:template name="F264-x0-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30086>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')  => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30086>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30086>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                substring-before(' :') => translate('[]', '')"/></xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30086>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30174>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30174>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30174>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30174>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30009</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x1-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x1-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30088>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30088>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30088>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30088>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30176>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30176>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30176>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30176>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30011</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x2-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x2-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30085>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30085>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30085>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30085>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30173>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30173>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30173>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30173>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30008</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-x3-a_b_c duplicates F264-x0-a_b_c except it outputs different RDA properties-->
    <xsl:template name="F264-x3-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30087>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' :') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:when test="ends-with(., ' ;')">
                                    <xsl:value-of select="normalize-space(.) =>
                                        substring-before(' ;') => translate('[]', '')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30087>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30087>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' :') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:when test="ends-with(., ' ;')">
                                <xsl:value-of select="normalize-space(.) =>
                                    substring-before(' ;') => translate('[]', '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30087>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30175>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ',')">
                                    <xsl:analyze-string select="." regex="(.*)(,$)">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30175>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30175>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="normalize-space(regex-group(1)) => translate('[]', '')"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30175>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30010</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F264-x4-c" expand-text="yes">
        <rdamd:P30137>
            <xsl:text>Copyright notice date: </xsl:text>
            <xsl:for-each select="marc:subfield[@code = 'c']">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="not(ends-with(., '.'))">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </rdamd:P30137>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:call-template name="F264-xx-c">
                <xsl:with-param name="rdaProp">rdamd:P30007</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F264-xx-c">
        <xsl:param name="rdaProp"/>
        <xsl:choose>
            <!-- 1234 or [1234] -->
            <xsl:when test="matches(., '^\[?\d\d\d\d\]?$')">
                <!-- use as date but remove any brackets -->
                <xsl:element name="{$rdaProp}">
                    <xsl:value-of select="translate(., '[]', '')"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <!-- more complicated. multiple dates, other characters, etc. -->
                <!-- separate out all groups of 4 digits -->
                <xsl:variable name="c">
                    <xsl:analyze-string select="." regex="\d\d\d\d">
                        <xsl:matching-substring>
                            <xsl:sequence select="."/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <!-- select first group of 4 digits to use -->
                <xsl:analyze-string select="$c[1]"
                    regex="^\d\d\d\d">
                    <xsl:matching-substring>
                        <xsl:element name="{$rdaProp}">
                            <xsl:value-of select="."/>
                        </xsl:element>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
