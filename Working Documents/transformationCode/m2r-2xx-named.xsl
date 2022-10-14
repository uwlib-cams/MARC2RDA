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
    xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F245-xx-anps" expand-text="yes">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code='a'] and substring(preceding-sibling::marc:leader,19,1)='i' or substring(preceding-sibling::marc:leader,19,1)='a'">
                <rdamd:P30134>
                    <xsl:choose>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' /')">{substring-before(marc:subfield[@code='a'], ' /')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' :')">{substring-before(marc:subfield[@code='a'], ' :')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], '.')">{substring-before(marc:subfield[@code='a'], '.')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' =')">{substring-before(marc:subfield[@code='a'], ' =')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ';')">{substring-before(marc:subfield[@code='a'], ';')}</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="marc:subfield[@code='n'] | marc:subfield[@code='p'] | marc:subfield[@code='s']">
                        <xsl:if test="not(preceding-sibling::marc:subfield[@code='b'])">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </rdamd:P30134>
            </xsl:when>
            <xsl:when test="(marc:subfield[@code='a']) and (substring(preceding-sibling::marc:leader,19,1)=' ' or substring(preceding-sibling::marc:leader,19,1)='c' or substring(preceding-sibling::marc:leader,19,1)='u' or substring(preceding-sibling::marc:leader,19,1)='n') and (marc:subfield[@code='n'] or marc:subfield[@code='p'] or marc:subfield[@code='s'])">
                <rdamd:P30134>
                    <xsl:text>$a </xsl:text>
                    <xsl:choose>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' /')">{substring-before(marc:subfield[@code='a'], ' /')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' :')">{substring-before(marc:subfield[@code='a'], ' :')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], '.')">{substring-before(marc:subfield[@code='a'], '.')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ' =')">{substring-before(marc:subfield[@code='a'], ' =')}</xsl:when>
                        <xsl:when test="ends-with(marc:subfield[@code='a'], ';')">{substring-before(marc:subfield[@code='a'], ';')}</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="marc:subfield[@code='a']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:for-each select="marc:subfield[@code='n'] | marc:subfield[@code='p'] | marc:subfield[@code='s']">
                        <xsl:if test="not(preceding-sibling::marc:subfield[@code='b'])">
                            <xsl:if test="@code='n'">
                                <xsl:text> $n </xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:if>
                            <xsl:if test="@code='p'">
                                <xsl:text> $p </xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:if>
                            <xsl:if test="@code='s'">
                                <xsl:text> $s </xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </rdamd:P30134>
            </xsl:when>
            <!-- Error message below may appear frequently. The plan was to manually check then run a routine that wipes away this [and other unnecessary] error messages. BETTER TO TEST IT: I.E. FIND ALL RECORDS THAT DON'T HAVE THE PROPERTY, PING THE marc TO MAKE SURE THERE'S A GOOD REASON -->
            <xsl:otherwise><BOGUS><xsl:text>POSSIBLE ERROR WITH 245 WHERE rdamd:P30134 hasTitleOfManifestation WAS EXPECTED</xsl:text></BOGUS></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="F245-xx-a" expand-text="yes">
        <xsl:if test="marc:subfield[@code='a']">
            <rdamd:P30156>
                <xsl:choose>
                    <xsl:when test="ends-with(marc:subfield[@code='a'], ' /')">{substring-before(marc:subfield[@code='a'], ' /')}</xsl:when>
                    <xsl:when test="ends-with(marc:subfield[@code='a'], ' :')">{substring-before(marc:subfield[@code='a'], ' :')}</xsl:when>
                    <xsl:when test="ends-with(marc:subfield[@code='a'], '.')">{substring-before(marc:subfield[@code='a'], '.')}</xsl:when>
                    <xsl:when test="ends-with(marc:subfield[@code='a'], ' =')">{substring-before(marc:subfield[@code='a'], ' =')}</xsl:when>
                    <xsl:when test="ends-with(marc:subfield[@code='a'], ';')">{substring-before(marc:subfield[@code='a'], ';')}</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="marc:subfield[@code='a']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </rdamd:P30156>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-b">
        <xsl:if test="marc:subfield[@code='b']">
            <rdamd:P30142>
                <xsl:value-of select="replace(marc:subfield[@code='b'], '\s*[\./]$', '')"/>
            </rdamd:P30142>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-c">
        <xsl:if test="marc:subfield[@code='c']">
            <rdamd:P30105>
                <xsl:value-of select="replace(marc:subfield[@code='c'],'[\.]$', '')"/>
            </rdamd:P30105>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-f-g">
        <xsl:if test="marc:subfield[@code='f']">
            <rdamd:P30278>
                <xsl:value-of select="replace(marc:subfield[@code='f'],'\.$','')"/>
            </rdamd:P30278>
        </xsl:if>
        <xsl:if test="marc:subfield[@code='g']">
            <rdamd:P30278>
                <xsl:value-of select="replace(marc:subfield[@code='g'],'\.$','')"/>
            </rdamd:P30278>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-h" expand-text="yes">
        <xsl:if test="marc:subfield[@code='h']">
            <rdamd:P30002>{replace(marc:subfield[@code='h'], '\]*[\]\.]', '') =>replace('^\[', '')}</rdamd:P30002>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F245-xx-k" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code='k']">
            <rdamd:P30137>
                <xsl:value-of select="replace(., '[,.]$', '')"/>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F264-xx-abc" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code='a']">
            <xsl:value-of select="."/>
            <xsl:if test="not(ends-with(.,' ')) and following-sibling::marc:subfield">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='b']">
             <xsl:value-of select="."/>
            <xsl:if test="not(ends-with(.,' '))">
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code='c']">
            <xsl:value-of select="."/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-x0-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30086>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30086>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30086>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30086>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(.,' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30174>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,',')">
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
                            <xsl:when test="ends-with(.,',')">
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
        <xsl:for-each select="marc:subfield[@code='c']">
            <rdamd:P30009>
                <xsl:choose>
                    <xsl:when test="ends-with(.,'.')">{normalize-space(.) => substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30009>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-x1-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30088>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30088>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30088>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30088>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(.,' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30176>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,',')">
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
                            <xsl:when test="ends-with(.,',')">
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
        <xsl:for-each select="marc:subfield[@code='c']">
            <rdamd:P30011>
                <xsl:choose>
                    <xsl:when test="ends-with(.,'.')">{normalize-space(.) => substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30011>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-x2-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30085>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30085>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30085>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{.}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30085>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(.,' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30173>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,',')">
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
                            <xsl:when test="ends-with(.,',')">
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
        <xsl:for-each select="marc:subfield[@code='c']">
            <rdamd:P30008>
                <xsl:choose>
                    <xsl:when test="ends-with(.,'.')">{normalize-space(.) => substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30008>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-x3-a_b_c" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <xsl:when test="contains(., ' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30087>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                                <xsl:when test="ends-with(.,' ;')">{normalize-space(.) => substring-before(' ;')}</xsl:when>
                                <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                            </xsl:choose>
                        </rdamd:P30087>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <rdamd:P30087>
                        <xsl:choose>
                            <xsl:when test="ends-with(., ' :')">{normalize-space(.) => substring-before(' :')}</xsl:when>
                            <xsl:when test="ends-with(.,' ;')">{ normalize-space(.) => substring-before(' ;')}</xsl:when>
                            <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                        </xsl:choose>
                    </rdamd:P30087>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:choose>
                <xsl:when test="contains(.,' = ')">
                    <xsl:for-each select="tokenize(., ' = ')">
                        <rdamd:P30175>
                            <xsl:choose>
                                <xsl:when test="ends-with(.,',')">
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
                            <xsl:when test="ends-with(.,',')">
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
        <xsl:for-each select="marc:subfield[@code='c']">
            <rdamd:P30010>
                <xsl:choose>
                    <xsl:when test="ends-with(.,'.')">{normalize-space(.) => substring-before('.')}</xsl:when>
                    <xsl:otherwise>{normalize-space(.)}</xsl:otherwise>
                </xsl:choose>
            </rdamd:P30010>
        </xsl:for-each>

    </xsl:template>
    
</xsl:stylesheet>
