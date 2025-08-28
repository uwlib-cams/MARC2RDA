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
    <xsl:key name="lookupBK006c6" match="uwmisc:entry" use="uwmisc:marcBK006c6"/>
    
    <xsl:key name="lookupMP008c25" match="uwmisc:entry" use="uwmisc:marcMP008c25"/>
    <xsl:key name="lookupMP006c8" match="uwmisc:entry" use="uwmisc:marcMP006c8"/>
    <xsl:key name="lookupMP008c29" match="uwmisc:entry" use="uwmisc:marcMP008c29"/>
    <xsl:key name="lookupMP006c12" match="uwmisc:entry" use="uwmisc:marcMP006c12"/>
    <xsl:key name="lookupMP008c33orc34" match="uwmisc:entry" use="uwmisc:marcMP008c33orc34"/>
    <xsl:key name="lookupMP006c16orc17" match="uwmisc:entry" use="uwmisc:marcMP006c16orc17"/>
    
    <xsl:key name="lookupVM008c29" match="uwmisc:entry" use="uwmisc:marcVM008c29"/>
    <xsl:key name="lookupVM006c12" match="uwmisc:entry" use="uwmisc:marcVM006c12"/>
    <xsl:key name="lookupVM008c33" match="uwmisc:entry" use="uwmisc:marcVM008c33"/>
    <xsl:key name="lookupVM006c16" match="uwmisc:entry" use="uwmisc:marcVM006c16"/>
    
    <xsl:key name="lookupCF008c23" match="uwmisc:entry" use="uwmisc:marcCF008c23"/>
    <xsl:key name="lookupCF006c6" match="uwmisc:entry" use="uwmisc:marcCF006c6"/>
    <xsl:key name="lookupCF008c26" match="uwmisc:entry" use="uwmisc:marcCF008c26"/>
    <xsl:key name="lookupCF006c9" match="uwmisc:entry" use="uwmisc:marcCF006c9"/>
    
    <xsl:key name="lookupCR008c23" match="uwmisc:entry" use="uwmisc:marcCR008c23"/>
    <xsl:key name="lookupCR006c6" match="uwmisc:entry" use="uwmisc:marcCR006c6"/>
    <xsl:key name="lookupCR008c24" match="uwmisc:entry" use="uwmisc:marcCR008c24"/>
    <xsl:key name="lookupCR006c7" match="uwmisc:entry" use="uwmisc:marcCR006c7"/>
    
    <xsl:key name="lookupMX008c23" match="uwmisc:entry" use="uwmisc:marcMX008c23"/>
    <xsl:key name="lookupMX006c6" match="uwmisc:entry" use="uwmisc:marcMX006c6"/>
    
    <xsl:key name="lookupMU008c23" match="uwmisc:entry" use="uwmisc:marcMU008c23"/>
    <xsl:key name="lookupMU006c6" match="uwmisc:entry" use="uwmisc:marcMU006c6"/>
    <xsl:key name="lookupMU008c30orc31" match="uwmisc:entry" use="uwmisc:marcMU008c30orc31"/>
    <xsl:key name="lookupMU006c13orc14" match="uwmisc:entry" use="uwmisc:marcMU006c13orc14"/>
    <xsl:key name="lookupMU006c13c14" match="uwmisc:entry" use="uwmisc:marcMU006c13c14"/>
    
    <xsl:template name="otherFieldsTo33x">
        
        <xsl:param name="record"/>
        
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:apply-templates select="marc:leader"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '008']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '006']"/>
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
    
    <xsl:template match="marc:controlfield[@tag = '006']" expand-text="yes">
        <xsl:variable name="char0" select="substring(., 1, 1)"/>
        
        <xsl:choose>
            <!-- books -->
            <xsl:when test="$char0 = 'a' or $char0 = 't'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                
                <xsl:variable name="lookupBK006c6-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupBK006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                
                <xsl:for-each select="$lookupBK006c6-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- 008 maps -->
            <xsl:when test="$char0 = 'e' or $char0 = 'f'">
                <xsl:variable name="c8" select="substring(., 9, 1)"/>
                <xsl:variable name="c12" select="substring(., 13, 1)"/>
                <xsl:variable name="c16" select="substring(., 17, 1)"/>
                <xsl:variable name="c17" select="substring(., 18, 1)"/>
                
                <xsl:variable name="lookupMP006c8-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP006c8', $c8)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c8-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c8-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP006c8', $c8)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c8-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c12-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP006c12', $c12)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c12-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c12-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP006c12', $c12)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c12-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c16-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP006c16orc17', $c16)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c16-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c16-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP008c16orc17', $c16)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c16-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c17-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMP006c16orc17', $c17)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c17-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c17-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMP006c16orc17', $c17)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c17-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- visual materials -->
            <xsl:when test="$char0 = 'g' or $char0 = 'k' or $char0 = 'o' or $char0 = 'r'">
                <xsl:variable name="c12" select="substring(., 13, 1)"/>
                <xsl:variable name="c16" select="substring(., 17, 1)"/>
                
                <xsl:variable name="lookupVM006c12-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupVM006c12', $c12)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c12-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c12-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupVM006c12', $c12)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c12-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c16-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupVM006c16', $c16)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c16-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c16-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupVM006c16', $c16)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c16-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- computer files -->
            <xsl:when test="$char0 = 'm'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c9" select="substring(., 10, 1)"/>
                
                <xsl:variable name="lookupCF006c9-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCF006c9', $c9)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF006c9-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCF006c6-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupCF006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF006c6-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- continuing resources -->
            <xsl:when test="$char0 = 's'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c7" select="substring(., 8, 1)"/>
                
                <xsl:variable name="lookupCR006c6-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupCR006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c6-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR006c6-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCR006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c6-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR006c7-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupCR006c7', $c7)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c7-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- mixed materials -->
            <xsl:when test="$char0 = 'p'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                
                <xsl:variable name="lookupMX006c6-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMX006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX006c6-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMX006c6-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMX006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX006c6-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- music -->
            <xsl:when test="$char0 = 'c' or $char0 = 'd' or $char0 = 'i' or $char0 = 'j'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c13" select="substring(., 14, 1)"/>
                <xsl:variable name="c14" select="substring(., 15, 1)"/>
                
                <xsl:variable name="lookupMU006c6-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c6-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c6-carrier">
                    <xsl:copy-of select="document('lookup/Lookup338.xml')/key('lookupMU006c6', $c6)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c6-carrier/uwmisc:rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c13-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU006c13orc14', $c13)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c13-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c14-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU006c13orc14', $c14)/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c14-content/uwmisc:rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c13c14-content">
                    <xsl:copy-of select="document('lookup/Lookup336.xml')/key('lookupMU006c13c14', concat($c13, $c14))/uwmisc:rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c13c14-content/uwmisc:rdaIRI">
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