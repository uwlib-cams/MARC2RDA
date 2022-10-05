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
