<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="lookupLDRc6" match="uwmisc:entry" use="uwmisc:marcLDRc6"/>
    <xsl:key name="lookup007c0" match="uwmisc:entry" use="uwmisc:marc007c0"/>
    <xsl:key name="lookup007c0c1" match="uwmisc:entry" use="uwmisc:marc007c0c1"/>
    <xsl:key name="lookup007c0c5c6" match="uwmisc:entry" use="uwmisc:marc007c0c5c6"/>
    <xsl:key name="lookupBK008c23" match="uwmisc:entry" use="uwmisc:marcBK008c23"/>
    <xsl:key name="lookupMP008c25" match="uwmisc:entry" use="uwmisc:marcMP008c25"/>
    <xsl:key name="lookupMP008c29" match="uwmisc:entry" use="uwmisc:marcMP008c29"/>
    <xsl:key name="lookupMP008c33orc34" match="uwmisc:entry" use="uwmisc:marcMP008c33orc34"/>
    <xsl:key name="lookupVM008c29" match="uwmisc:entry" use="uwmisc:marcVM008c29"/>
    <xsl:key name="lookupVM008c33" match="uwmisc:entry" use="uwmisc:marcVM008c33"/>
    <xsl:key name="lookupCF008c23" match="uwmisc:entry" use="uwmisc:marcCF008c23"/>
    <xsl:key name="lookupCF008c26" match="uwmisc:entry" use="uwmisc:marcCF008c26"/>
    <xsl:key name="lookupCR008c23" match="uwmisc:entry" use="uwmisc:marcCR008c23"/>
    <xsl:key name="lookupCR008c24" match="uwmisc:entry" use="uwmisc:marcCR008c24"/>
    <xsl:key name="lookupMX008c23" match="uwmisc:entry" use="uwmisc:marcMX008c23"/>
    <xsl:key name="lookupMU008c23" match="uwmisc:entry" use="uwmisc:marcMU008c23"/>
    <xsl:key name="lookupMU008c30orc31" match="uwmisc:entry" use="uwmisc:marcMU008c30orc31"/>
    <xsl:key name="lookupMU008c30c31" match="uwmisc:entry" use="uwmisc:marcMU008c30c31"/>
    
    <xsl:template name="otherFieldsTo33x">
        
        <xsl:param name="record"/>
        
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:apply-templates select="marc:leader"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '008']"/>
            </xsl:copy>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="marc:leader" expand-text="yes">
        <xsl:variable name="LDRc6" select="substring(., 7, 1)"/>
        <xsl:variable name="lookupLDRc6-content">
            <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupLDRc6', $LDRc6)/uwmisc:rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookupLDRc6-carrier">
            <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupLDRc6', $LDRc6)/uwmisc:rdaIRI"/>
        </xsl:variable>
        
        <xsl:for-each select="$lookupLDRc6-content/uwmisc:rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookupLDRc6-carrier/uwmisc:rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '007']" expand-text="yes">
        
        <xsl:variable name="f007c0" select="substring(., 1, 1)"/>
        <xsl:variable name="f007c0c1" select="substring(., 1, 2)"/>
        <xsl:variable name="f007c0c5c6" select="substring(., 1, 1)||substring(., 6, 2)"/>
        
        <xsl:variable name="lookup007c0-content">
            <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookup007c0', $f007c0)/uwmisc:rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookup007c0c1-content">
            <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookup007c0c1', $f007c0c1)/uwmisc:rdaIRI"/>
        </xsl:variable>
        
        <xsl:variable name="lookup007c0c1-carrier">
            <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookup007c0c1', $f007c0c1)/uwmisc:rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookup007c0c5c6-carrier">
            <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookup007c0c5c6', $f007c0c5c6)/uwmisc:rdaIRI"/>
        </xsl:variable>
        
        <xsl:for-each select="$lookup007c0-content/uwmisc:rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-content/uwmisc:rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-carrier/uwmisc:rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c5c6-carrier/uwmisc:rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template match="marc:controlfield[@tag = '008']" expand-text="yes">
        <xsl:variable name="ldr6-7" select="substring(preceding-sibling::marc:leader, 7, 2)"/>
        
        <xsl:choose>
            <!-- books -->
            <xsl:when test="$ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                
                <xsl:variable name="lookupBK008c23-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupBK008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                
                <xsl:for-each select="$lookupBK008c23-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- 008 maps -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f'">
                <xsl:variable name="c25" select="substring(., 26, 1)"/>
                <xsl:variable name="c29" select="substring(., 30, 1)"/>
                <xsl:variable name="c33" select="substring(., 34, 1)"/>
                <xsl:variable name="c34" select="substring(., 35, 1)"/>
                
                <xsl:variable name="lookupMP008c25-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP008c25', $c25)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c25-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c25-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP008c25', $c25)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c25-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c29-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP008c29', $c29)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c29-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c29-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP008c29', $c29)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c29-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c33-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP008c33orc34', $c33)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c33-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c33-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP008c33orc34', $c33)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c33-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c34-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP008c33orc34', $c34)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c34-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c34-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP008c33orc34', $c34)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c34-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- visual materials -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r'">
                <xsl:variable name="c29" select="substring(., 30, 1)"/>
                <xsl:variable name="c33" select="substring(., 34, 1)"/>
                
                
                <xsl:variable name="lookupVM008c29-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupVM008c29', $c29)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c29-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c29-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupVM008c29', $c29)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c29-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c33-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupVM008c33', $c33)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c33-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c33-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupVM008c33', $c33)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c33-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- computer files -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'm'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c26" select="substring(., 27, 1)"/>
                
                <xsl:variable name="lookupCF008c26-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCF008c26', $c26)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF008c26-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCF008c23-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupCF008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF008c23-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- continuing resources -->
            <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c24" select="substring(., 25, 1)"/>
                
                <xsl:variable name="lookupCR008c23-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupCR008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c23-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR008c23-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCR008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c23-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR008c24-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCR008c24', $c24)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c24-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- mixed materials -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                
                <xsl:variable name="lookupMX008c23-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMX008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX008c23-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMX008c23-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMX008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX008c23-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- music -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c30" select="substring(., 31, 1)"/>
                <xsl:variable name="c31" select="substring(., 32, 1)"/>
                
                <xsl:variable name="lookupMU008c23-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c23-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c23-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMU008c23', $c23)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c23-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c30-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU008c30orc31', $c30)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c30-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c31-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU008c30orc31', $c30)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c31-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c30c31-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU008c30c31', concat($c30, $c31))/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c30c31-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
<!--    <xsl:function name="uwf:getRecordType">
        <xsl:param name="record"/>
        <xsl:if test=""></xsl:if>
    </xsl:function>-->
    
</xsl:stylesheet>