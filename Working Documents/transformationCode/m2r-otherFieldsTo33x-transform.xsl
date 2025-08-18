<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="lookup007c0c1" match="uwmisc:entry" use="uwmisc:marc007c0c1"/>
    <xsl:key name="lookup007c0c5c6" match="uwmisc:entry" use="uwmisc:marc007c0c5c6"/>
    <xsl:key name="lookupMP008c25" match="uwmisc:entry" use="uwmisc:marcMP008c25"/>
    <xsl:key name="lookupMP008c29" match="uwmisc:entry" use="uwmisc:marcMP008c29"/>
    <xsl:key name="lookupMP008c33orc34" match="uwmisc:entry" use="uwmisc:marcMP008c33orc34"/>
    <xsl:key name="lookupVM008c29" match="uwmisc:entry" use="uwmisc:marcVM008c29"/>
    <xsl:key name="lookupVM008c33" match="uwmisc:entry" use="uwmisc:marcVM008c33"/>
    <xsl:key name="lookupCF008c23" match="uwmisc:entry" use="uwmisc:marcCF008c23"/>
    <xsl:key name="lookupCR008c23" match="uwmisc:entry" use="uwmisc:marcCR008c23"/>
    <xsl:key name="lookupMX008c23" match="uwmisc:entry" use="uwmisc:marcMX008c23"/>
    <xsl:key name="lookupMU008c23" match="uwmisc:entry" use="uwmisc:marcMU008c23"/>
    
    <xsl:template name="otherFieldsTo33x">
        
        <xsl:param name="record"/>
        
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '008']"/>
            </xsl:copy>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '007']" expand-text="yes">
        
        <xsl:variable name="f007c0c1" select="substring(., 1, 2)"/>
        <xsl:variable name="f007c0c5c6" select="substring(., 1, 1)||substring(., 6, 2)"/>
        <xsl:variable name="lookup007c0c1" select="document('lookup/Lookup338.xml')/key('lookup007c0c1', $f007c0c1)/uwmisc:rdaIRI"/>
        <xsl:variable name="lookup007c0c5c6" select="document('lookup/Lookup338.xml')/key('lookup007c0c5c6', $f007c0c5c6)/uwmisc:rdaIRI"/>
        
        <xsl:if test="$lookup007c0c1 != ''">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="$lookup007c0c1"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
        
        <xsl:if test="$lookup007c0c5c6 != ''">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="$lookup007c0c5c6"/>
                </marc:subfield>
            </marc:datafield>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '008']" expand-text="yes">
        <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
        
        <xsl:choose>
            
            <!-- 008 maps -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f'">
                <xsl:variable name="c25" select="substring(., 26, 1)"/>
                <xsl:variable name="c29" select="substring(., 30, 1)"/>
                <xsl:variable name="c33" select="substring(., 34, 1)"/>
                <xsl:variable name="c34" select="substring(., 35, 1)"/>
                
                <xsl:if test="$c25 != ' ' and $c25 != '|'">
                    <xsl:variable name="lookupMP008c25" select="document('lookup/Lookup338.xml')/key('lookupMP008c25', $c25)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMP008c25 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMP008c25"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$c29 != ' ' and $c29 != '|'">
                    <xsl:variable name="lookupMP008c29" select="document('lookup/Lookup338.xml')/key('lookupMP008c29', $c29)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMP008c29 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMP008c29"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$c33 != ' ' and $c33 != '|'">
                    <xsl:variable name="lookupMP008c33" select="document('lookup/Lookup338.xml')/key('lookupMP008c33orc34', $c33)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMP008c33 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMP008c33"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
                <xsl:if test="$c34 != ' ' and $c34 != '|'">
                    <xsl:variable name="lookupMP008c34" select="document('lookup/Lookup338.xml')/key('lookupMP008c33orc34', $c34)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMP008c34 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMP008c34"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            
            <!-- visual materials -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r'">
                <xsl:variable name="c29" select="substring(., 30, 1)"/>
                <xsl:variable name="c33" select="substring(., 34, 1)"/>
                
                <xsl:if test="$c29 != ' ' and $c29 != '|'">
                    <xsl:variable name="lookupVM008c29" select="document('lookup/Lookup338.xml')/key('lookupVM008c29', $c29)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupVM008c29 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupVM008c29"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
                
                <xsl:if test="$c33 != ' ' and $c33 != '|'">
                    <xsl:variable name="lookupVM008c33" select="document('lookup/Lookup338.xml')/key('lookupVM008c33', $c33)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupVM008c33 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupVM008c33"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            
            <!-- computer files -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'm'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:if test="$c23 != ' ' and $c23 != '|'">
                    <xsl:variable name="lookupCF008c23" select="document('lookup/Lookup338.xml')/key('lookupCF008c23', $c23)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupCF008c23 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupCF008c23"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            
            <!-- continuing resources -->
            <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:if test="$c23 != ' ' and $c23 != '|'">
                    <xsl:variable name="lookupCR008c23" select="document('lookup/Lookup338.xml')/key('lookupCR008c23', $c23)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupCR008c23 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupCR008c23"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            
            <!-- mixed materials -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:if test="$c23 != ' ' and $c23 != '|'">
                    <xsl:variable name="lookupMX008c23" select="document('lookup/Lookup338.xml')/key('lookupMX008c23', $c23)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMX008c23 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMX008c23"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
            
            <!-- music -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:if test="$c23 != ' ' and $c23 != '|'">
                    <xsl:variable name="lookupMU008c23" select="document('lookup/Lookup338.xml')/key('lookupMU008c23', $c23)/uwmisc:rdaIRI"/>
                    <xsl:if test="$lookupMU008c23 != ''">
                        <marc:datafield tag="338" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="$lookupMU008c23"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>