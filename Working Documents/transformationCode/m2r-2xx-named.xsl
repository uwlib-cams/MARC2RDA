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
        <xsl:choose>
            <xsl:when test="not(ends-with(marc:subfield[@code = 'b']/preceding-sibling::*[1], '='))">
                <rdamd:P30134>
                    <xsl:for-each
                        select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 's']">
                        <xsl:choose>
                            <xsl:when test="position() != last()">
                                <xsl:value-of select="replace(., '\s*[:/=\.,]$', '')" separator=", "/>
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="replace(., '\s*[:/=\.,]$', '')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </rdamd:P30134>
            </xsl:when>
            <xsl:when test="marc:subfield[@code = 'b']">
                <xsl:for-each select="marc:subfield[@code = 'b']">
                    <xsl:choose>
                        <xsl:when test="ends-with(preceding-sibling::marc:subfield[1], '=')">
                            <rdamd:P30134>
                                <xsl:for-each
                                    select="preceding-sibling::*[@code = 'a' or @code = 'n' or @code = 'p' or @code = 's']">
                                    <xsl:value-of select="replace(., '\s*[/:\.=,]$', '')"/>
                                    <xsl:if test="position() != last()">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </rdamd:P30134>
                            <rdamd:P30134>
                                <xsl:value-of select="replace(., '\s*[/:\.]$', '')"/>
                                <xsl:if
                                    test="following-sibling::*[@code = 'p' or @code = 'n' or @code = 's']">
                                    <xsl:text>, </xsl:text>
                                    <xsl:for-each
                                        select="following-sibling::*[@code = 'n' or @code = 'p' or @code = 's']">
                                        <xsl:value-of select="replace(., '\s*[/:\.=,]$', '')"/>
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
    </xsl:template>
    <!-- F245-xx-a treats all $a the same -->
    <xsl:template name="F245-xx-a" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdamd:P30156>
                <xsl:value-of select="replace(marc:subfield[@code = 'a'], '(\s)*[/:\.=;,]$', '')"/>
            </rdamd:P30156>
        </xsl:if>
    </xsl:template>
    <!-- F245-xx-b processes 4 conditions
        1. preceedingSibling endswith '=' AND doesn't contain ' = ' sp AND followingSibling is neither $n $p or $s
        2. preceedingSibling endsWith '=' AND does contain ' = ' sp AND followingSibling is neither $n $p or $s
        3. preceedingSibling doesn't endWith ' = ' AND contains ' = '
        4. Just a $b, no MARC "parallel statements.
    -->
    <xsl:template name="F245-xx-b">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when
                    test="ends-with(preceding-sibling::*[1], '=') and not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'])">
                    <xsl:choose>
                        <xsl:when test="contains(., ' = ')">
                            <xsl:for-each select="tokenize(., ' = ')">
                                <rdamd:P30134>
                                    <xsl:value-of select="replace(., '\s*[\.,:=/;]$', '')"/>
                                </rdamd:P30134>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30134>
                                <xsl:value-of select="."/>
                            </rdamd:P30134>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="not(ends-with(preceding-sibling::*[1], '='))">
                    <xsl:choose>
                        <xsl:when test="contains(., ' = ')">
                            <xsl:for-each select="tokenize(., ' = ')">
                                <rdamd:P30142>
                                    <xsl:value-of select="replace(., '\s*[\.,:=/;]$', '')"/>
                                </rdamd:P30142>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30142>
                                <xsl:value-of select="replace(., '\s*[\.,:=/;]$', '')"/>
                            </rdamd:P30142>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30142>
                        <xsl:value-of select="replace(marc:subfield[@code = 'b'], '\s*[\./]$', '')"
                        />
                    </rdamd:P30142>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <!-- F245-xx-c allows for two conditions: when there is ' = ' in the subfield and when there isn't -->
    <xsl:template name="F245-xx-c">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <xsl:choose>
                <xsl:when test="contains(.,' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30105>
                            <xsl:value-of select="replace(.,'\s*[\.,;=/:]$','')"/>
                        </rdamd:P30105>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30105>
                        <xsl:value-of select="replace(.,'\s*[\.,;=/:]$','')"/>
                    </rdamd:P30105>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F245-xx-f-g">
        <xsl:for-each select="marc:subfield[@code='f'] | marc:subfield[@code = 'g'] ">
            <rdamd:P30278>
                <xsl:value-of select="replace(.,'\s*[,\.;,]','')"/>
            </rdamd:P30278>
        </xsl:for-each>
     </xsl:template>
    <xsl:template name="F245-xx-h" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <rdamd:P30002>
                <xsl:value-of select="replace(.,'^\[','') => replace('[=]$','') => replace('[\]]$','')"/>
            </rdamd:P30002>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F245-xx-k" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'k']">
            <rdamd:P30137>
                <xsl:value-of select="replace(., '\s*[,\.;,]$', '')"/>
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
            <xsl:if test="not(matches(., '[^\d\[\]]'))">
                <rdamd:P30009>
                    <xsl:value-of select="replace(., '[^\d]', '')"/>
                   <!-- <xsl:choose>
                        <xsl:when test="ends-with(., '.')">
                            <xsl:value-of select="normalize-space(.) =>
                                substring-before('.') => translate('[]', '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </rdamd:P30009>
            </xsl:if>
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
            <xsl:if test="not(matches(., '[^\d\[\]]'))">
                <rdamd:P30011>
                    <xsl:value-of select="replace(., '[^\d]', '')"/>
                    <!--<xsl:choose>
                        <xsl:when test="ends-with(., '.')">
                            <xsl:value-of select="normalize-space(.) =>
                                substring-before('.') => translate('[]', '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </rdamd:P30011>
            </xsl:if>
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
            <xsl:if test="not(matches(., '[^\d\[\]]'))">
                <rdamd:P30008>
                    <xsl:value-of select="replace(., '[^\d]', '')"/>
                    <!--<xsl:choose>
                        <xsl:when test="ends-with(., '.')">
                            <xsl:value-of select="normalize-space(.) =>
                                substring-before('.') => translate('[]', '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(.) => translate('[]', '')"/>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </rdamd:P30008>
            </xsl:if>
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
            <xsl:if test="not(matches(., '[^\d\[\]]'))">
                <rdamd:P30010>
                    <xsl:value-of select="replace(., '[^\d]', '')"/>
                </rdamd:P30010>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F264-x4-c" expand-text="yes">
        <rdamd:P30137>
            <xsl:text>Copyright date: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'c']" separator="; "/>
        </rdamd:P30137>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30007>
                <xsl:value-of select="replace(., '[^\d]', '')"/>
            </rdamd:P30007>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
