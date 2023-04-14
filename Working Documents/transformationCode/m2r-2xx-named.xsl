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
    <!-- F245-xx-anps processes $a $n $p $s and accounts for ISBD and non-ISBD punctuation. -->
    <xsl:template name="F245-xx-anps" expand-text="yes">
        <xsl:choose>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = 'i' or substring(preceding-sibling::marc:leader, 19, 1) = 'a'">
                <xsl:value-of select="replace(marc:subfield[@code = 'a'], '\s*[:/]$', '')"/>
                <xsl:if test="marc:subfield[@code = 'a']">
                    <xsl:text>. </xsl:text>
                </xsl:if>
                <xsl:for-each select="marc:subfield[@code = 'n' or @code = 'p' or @code = 's']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when
                test="(substring(preceding-sibling::marc:leader, 19, 1) = ' ' or substring(preceding-sibling::marc:leader, 19, 1) = 'c' or substring(preceding-sibling::marc:leader, 19, 1) = 'u' or substring(preceding-sibling::marc:leader, 19, 1) = 'n') and (marc:subfield[@code = 'a'] or marc:subfield[@code = 'n'] or marc:subfield[@code = 'p'] or marc:subfield[@code = 's'])">
                <xsl:choose>
                    <xsl:when
                        test="not(marc:subfield[@code = 'n'] and marc:subfield[@code = 'p'] and marc:subfield[@code = 's'])"/>
                    <xsl:otherwise>
                        <xsl:text>$a </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="replace(marc:subfield[@code = 'a'], '\s*[/:=;]$', '')"/>
                <xsl:for-each
                    select="marc:subfield[@code = 'n'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 's']">
                    <xsl:if test="@code = 'n'">
                        <xsl:text> $n </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:if>
                    <xsl:if test="@code = 'p'">
                        <xsl:text> $p </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:if>
                    <xsl:if test="@code = 's'">
                        <xsl:text> $s </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <BOGUS>
                    <xsl:text>POSSIBLE ERROR WITH 245 WHERE rdamd:P30134 hasTitleOfManifestation WAS EXPECTED</xsl:text>
                </BOGUS>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="F245-xx-a" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdamd:P30156>
                <xsl:value-of select="replace(marc:subfield[@code = 'a'], '(\s)*[/:\.=;]$', '')"/>
            </rdamd:P30156>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-b">
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdamd:P30142>
                <xsl:value-of select="replace(marc:subfield[@code = 'b'], '\s*[\./]$', '')"/>
            </rdamd:P30142>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-c">
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdamd:P30105>
                <xsl:value-of select="replace(marc:subfield[@code = 'c'], '[\.]$', '')"/>
            </rdamd:P30105>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-f-g">
            <rdamd:P30278>
                <xsl:value-of select="replace(marc:subfield[@code = 'f'], '\.$', '')"/>
                <xsl:value-of select="replace(marc:subfield[@code = 'g'], '\.$', '')"/>
            </rdamd:P30278>
    </xsl:template>
    <xsl:template name="F245-xx-h" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'h']">
            <rdamd:P30002>{replace(marc:subfield[@code='h'], '\]*[\]\.]', '') =>replace('^\[',
                '')}</rdamd:P30002>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-k" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'k']">
            <rdamd:P30137>
                <xsl:value-of select="replace(., '[,.]$', '')"/>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    <!-- F264-xx-abc processes MARC 264 entered with ISBD punctuation as an RDA "statement."
         All subfield values are concatenated with a space added between
             (may result in double-spaces in the output).
    -->
    <xsl:template name="F264-xx-abc" expand-text="yes">
        <xsl:choose>
            <xsl:when test="marc:subfield/@code = '3'">
                <xsl:value-of select="marc:subfield[not(@code = '6')][not(@code = '3')]"
                    separator=" "/>
                <xsl:text> (Applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="marc:subfield[not(@code = '6')]" separator=" "/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- F264-xx-abc-notISBD processes MARC 264 entered without ISBD punctuation as an RDA "statement". All subfield values are concatenated with subfield codes and a space inserted. There may be double spaces in the output. -->
    <xsl:template name="F264-xx-abc-notISBD" expand-text="yes">
        <xsl:choose>
            <xsl:when test="marc:subfield/@code = '3'">
                <xsl:for-each select="marc:subfield[not(@code = '6')][not(@code = '3')]">
                    <xsl:text>$</xsl:text>
                    <xsl:value-of select="@code"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
                <xsl:text> (Applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
                <xsl:text>)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="marc:subfield[not(@code = '6')]">
                    <xsl:text>$</xsl:text>
                    <xsl:value-of select="@code"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:choose>
                        <xsl:when test="position() = last()"/>
                        <xsl:otherwise>
                            <xsl:text> </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- F264-x0-a_b_c processes each MARC 264 subfield even if repeated then creates values for every value on either side of an equal sign, if present, except for $c, where no parallel statements are anticipated. Also strips terminal punctuation in the subfields. -->
    <xsl:template name="F264-x0-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30086>
                            <xsl:choose>
                                <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                    substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                    substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30086>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30086>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
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
                                        <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
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
                                    <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30174>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30009>
                <xsl:choose>
                    <xsl:when test="ends-with(., '.')">{normalize-space(.) =>
                        substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30009>
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
                                <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                    substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                    substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30088>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30088>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
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
                                        <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30176>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30176>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30176>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30011>
                <xsl:choose>
                    <xsl:when test="ends-with(., '.')">{normalize-space(.) =>
                        substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30011>
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
                                <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                    substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                    substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30085>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30085>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
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
                                        <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30173>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30173>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30173>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30008>
                <xsl:choose>
                    <xsl:when test="ends-with(., '.')">{normalize-space(.) =>
                        substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30008>
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
                                <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                    substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(., ' ;')">{normalize-space(.) =>
                                    substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30087>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30087>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) =>
                                substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(., ' ;')">{ normalize-space(.) =>
                                substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
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
                                        <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30175>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30175>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ',')">
                                <xsl:analyze-string select="." regex="(.*)(,$)">
                                    <xsl:matching-substring>{normalize-space(regex-group(1))}</xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30175>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30010>
                <xsl:choose>
                    <xsl:when test="ends-with(., '.')">{normalize-space(.) =>
                        substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30010>
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
