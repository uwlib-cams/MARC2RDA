<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:key name="lookupLDRc6" match="entry" use="marcLDRc6"/>
    
    <xsl:key name="lookup007c0" match="entry" use="marc007c0"/>
    <xsl:key name="lookup007c0c1" match="entry" use="marc007c0c1"/>
    <xsl:key name="lookup007c0c5c6" match="entry" use="marc007c0c5c6"/>
    
    <xsl:key name="lookupBK008c23" match="entry" use="marcBK008c23"/>
    <xsl:key name="lookupBK006c6" match="entry" use="marcBK006c6"/>
    
    <xsl:key name="lookupMP008c25" match="entry" use="marcMP008c25"/>
    <xsl:key name="lookupMP006c8" match="entry" use="marcMP006c8"/>
    <xsl:key name="lookupMP008c29" match="entry" use="marcMP008c29"/>
    <xsl:key name="lookupMP006c12" match="entry" use="marcMP006c12"/>
    <xsl:key name="lookupMP008c33orc34" match="entry" use="marcMP008c33orc34"/>
    <xsl:key name="lookupMP006c16orc17" match="entry" use="marcMP006c16orc17"/>
    
    <xsl:key name="lookupVM008c29" match="entry" use="marcVM008c29"/>
    <xsl:key name="lookupVM006c12" match="entry" use="marcVM006c12"/>
    <xsl:key name="lookupVM008c33" match="entry" use="marcVM008c33"/>
    <xsl:key name="lookupVM006c16" match="entry" use="marcVM006c16"/>
    
    <xsl:key name="lookupCF008c23" match="entry" use="marcCF008c23"/>
    <xsl:key name="lookupCF006c6" match="entry" use="marcCF006c6"/>
    <xsl:key name="lookupCF008c26" match="entry" use="marcCF008c26"/>
    <xsl:key name="lookupCF006c9" match="entry" use="marcCF006c9"/>
    
    <xsl:key name="lookupCR008c23" match="entry" use="marcCR008c23"/>
    <xsl:key name="lookupCR006c6" match="entry" use="marcCR006c6"/>
    <xsl:key name="lookupCR008c24" match="entry" use="marcCR008c24"/>
    <xsl:key name="lookupCR006c7" match="entry" use="marcCR006c7"/>
    
    <xsl:key name="lookupMX008c23" match="entry" use="marcMX008c23"/>
    <xsl:key name="lookupMX006c6" match="entry" use="marcMX006c6"/>
    
    <xsl:key name="lookupMU008c20" match="entry" use="marcMU008c20"/>
    <xsl:key name="lookupMU006c3" match="entry" use="marcMU006c6"/>
    <xsl:key name="lookupMU008c23" match="entry" use="marcMU008c23"/>
    <xsl:key name="lookupMU006c6" match="entry" use="marcMU006c6"/>
    <xsl:key name="lookupMU008c30orc31" match="entry" use="marcMU008c30orc31"/>
    <xsl:key name="lookupMU008c30c31" match="entry" use="marcMU008c30c31"/>
    <xsl:key name="lookupMU006c13orc14" match="entry" use="marcMU006c13orc14"/>
    <xsl:key name="lookupMU006c13c14" match="entry" use="marcMU006c13c14"/>
    
    <xsl:key name="lookupTactile" match="entry" use="rdaIRI"/>
    
    <xsl:template name="otherFieldsTo33x">
        
        <xsl:param name="record"/>
        
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:apply-templates select="marc:leader"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '008']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '006']"/>
                <xsl:apply-templates select="marc:datafield[@tag = '245']"/>
            </xsl:copy>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template match="marc:leader" expand-text="yes">
        <xsl:variable name="LDRc6" select="substring(., 7, 1)"/>
        <xsl:variable name="lookupLDRc6-content">
            <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupLDRc6', $LDRc6)/rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookupLDRc6-carrier">
            <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupLDRc6', $LDRc6)/rdaIRI"/>
        </xsl:variable>
        
        <xsl:for-each select="$lookupLDRc6-content/rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)LDRc6</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookupLDRc6-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)LDRc6</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:controlfield[@tag = '007']" expand-text="yes">
        
        <xsl:variable name="f007c0" select="substring(., 1, 1)"/>
        <xsl:variable name="f007c0c1" select="substring(., 1, 2)"/>
        <xsl:variable name="f007c0c5c6" select="substring(., 1, 1)||substring(., 6, 2)"/>
        
        <xsl:variable name="lookup007c0-content">
            <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookup007c0', $f007c0)/rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookup007c0c1-content">
            <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookup007c0c1', $f007c0c1)/rdaIRI"/>
        </xsl:variable>
        
        <xsl:variable name="lookup007c0c1-carrier">
            <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookup007c0c1', $f007c0c1)/rdaIRI"/>
        </xsl:variable>
        <xsl:variable name="lookup007c0c5c6-carrier">
            <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookup007c0c5c6', $f007c0c5c6)/rdaIRI"/>
        </xsl:variable>
        
        <xsl:for-each select="$lookup007c0-content/rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)007c0</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-content/rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)007c0c1</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)007c0c1</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c5c6-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="7">
                    <xsl:text>(dpesc/dpsf1)007c0c5c6</xsl:text>
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
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupBK008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                
                <xsl:for-each select="$lookupBK008c23-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- computer files -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'm'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c26" select="substring(., 27, 1)"/>
                
                <xsl:variable name="lookupCF008c26-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCF008c26', $c26)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF008c26-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c26</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCF008c23-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupCF008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF008c23-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- continuing resources -->
            <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c24" select="substring(., 25, 1)"/>
                
                <xsl:variable name="lookupCR008c23-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupCR008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c23-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR008c23-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCR008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c23-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR008c24-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCR008c24', $c24)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR008c24-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c24</xsl:text>
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
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP008c25', $c25)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c25-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c25</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c25-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP008c25', $c25)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c25-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c25</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c29-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP008c29', $c29)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c29-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c29</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c29-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP008c29', $c29)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c29-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c29</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c33-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP008c33orc34', $c33)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c33-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c33</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c33-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP008c33orc34', $c33)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c33-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c33</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c34-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP008c33orc34', $c34)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c34-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c34</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP008c34-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP008c33orc34', $c34)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP008c34-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c34</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- mixed materials -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'">
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                
                <xsl:variable name="lookupMX008c23-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMX008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX008c23-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMX008c23-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMX008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX008c23-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- music -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd'">
                <xsl:variable name="c20" select="substring(., 21, 1)"/>
                <xsl:variable name="c23" select="substring(., 24, 1)"/>
                <xsl:variable name="c30" select="substring(., 31, 1)"/>
                <xsl:variable name="c31" select="substring(., 32, 1)"/>
                
                <xsl:variable name="lookupMU008c20-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU008c20', $c20)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c20-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c20</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c23-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c23-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c23-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMU008c23', $c23)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c23-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c23</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c30-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU008c30orc31', $c30)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c30-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c30</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c31-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU008c30orc31', $c30)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c31-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c31</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU008c30c31-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU008c30c31', concat($c30, $c31))/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU008c30c31-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c30c31</xsl:text>
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
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupVM008c29', $c29)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c29-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c29</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c29-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupVM008c29', $c29)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c29-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c29</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c33-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupVM008c33', $c33)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c33-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c33</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM008c33-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupVM008c33', $c33)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM008c33-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c33</xsl:text>
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
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupBK006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                
                <xsl:for-each select="$lookupBK006c6-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- computer files -->
            <xsl:when test="$char0 = 'm'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c9" select="substring(., 10, 1)"/>
                
                <xsl:variable name="lookupCF006c9-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCF006c9', $c9)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF006c9-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c9</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCF006c6-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupCF006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCF006c6-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- continuing resources -->
            <xsl:when test="$char0 = 's'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c7" select="substring(., 8, 1)"/>
                
                <xsl:variable name="lookupCR006c6-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupCR006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c6-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR006c6-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCR006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c6-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupCR006c7-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupCR006c7', $c7)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupCR006c7-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c7</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- maps -->
            <xsl:when test="$char0 = 'e' or $char0 = 'f'">
                <xsl:variable name="c8" select="substring(., 9, 1)"/>
                <xsl:variable name="c12" select="substring(., 13, 1)"/>
                <xsl:variable name="c16" select="substring(., 17, 1)"/>
                <xsl:variable name="c17" select="substring(., 18, 1)"/>
                
                <xsl:variable name="lookupMP006c8-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP006c8', $c8)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c8-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>]
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c8</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c8-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP006c8', $c8)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c8-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c8</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c12-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP006c12', $c12)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c12-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c12</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c12-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP006c12', $c12)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c12-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c12</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c16-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP006c16orc17', $c16)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c16-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c16-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP008c16orc17', $c16)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c16-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c17-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMP006c16orc17', $c17)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c17-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c17</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c17-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP006c16orc17', $c17)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c17-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c17</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- mixed materials -->
            <xsl:when test="$char0 = 'p'">
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                
                <xsl:variable name="lookupMX006c6-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMX006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX006c6-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMX006c6-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMX006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMX006c6-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
            </xsl:when>
            
            <!-- music -->
            <xsl:when test="$char0 = 'c' or $char0 = 'd' or $char0 = 'i' or $char0 = 'j'">
                <xsl:variable name="c3" select="substring(., 4, 1)"/>
                <xsl:variable name="c6" select="substring(., 7, 1)"/>
                <xsl:variable name="c13" select="substring(., 14, 1)"/>
                <xsl:variable name="c14" select="substring(., 15, 1)"/>
                
                <xsl:variable name="lookupMU006c3-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU006c3', $c3)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c3-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)008c20</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c6-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c6-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c6-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMU006c6', $c6)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c6-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c13-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU006c13orc14', $c13)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c13-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c13</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c14-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU006c13orc14', $c14)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c14-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c14</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMU006c13c14-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupMU006c13c14', concat($c13, $c14))/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMU006c13c14-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c13c14</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
            
            <!-- visual materials -->
            <xsl:when test="$char0 = 'g' or $char0 = 'k' or $char0 = 'o' or $char0 = 'r'">
                <xsl:variable name="c12" select="substring(., 13, 1)"/>
                <xsl:variable name="c16" select="substring(., 17, 1)"/>
                
                <xsl:variable name="lookupVM006c12-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupVM006c12', $c12)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c12-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c12</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c12-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupVM006c12', $c12)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c12-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c12</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c16-content">
                    <xsl:copy-of select="document('lookup/LookupContentType.xml')/key('lookupVM006c16', $c16)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c16-content/rdaIRI">
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupVM006c16-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupVM006c16', $c16)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupVM006c16-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="7">
                            <xsl:text>(dpesc/dpsf1)006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!--<xsl:template match="marc:datafield[@tag = '245']">
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <xsl:variable name="lookup245h">
                <xsl:copy-of select="document('lookup/LookupContentType.xml')/entry["></xsl:copy-of>
            </xsl:variable>
        </xsl:for-each>
    </xsl:template>-->
    
    <xsl:function name="m2r:isTactile">
        <xsl:param name="record"/>
        <xsl:variable name="ldr6-7" select="substring($record/marc:leader, 7, 2)"/>
        <xsl:choose>
            <xsl:when test="some $f007 in $record/marc:controlfield[@tag='007']
                satisfies substring($f007, 1, 1) = 'f'">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <!-- book -->
            
            <!-- 008 -->
            <xsl:when test="($ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'a' or substring($f006, 1, 1) = 't')
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- continuing resources -->
            
            <!-- 008 -->
            <xsl:when test="$ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as'
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies (substring($f006, 1, 1) = 's'
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- maps -->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 30, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'e' or substring($f006, 1, 1) = 'f')
                and substring($f006, 13, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- mixed materials -->
            
            <!-- 008 -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'
                and substring($record/marc:controlfield[@tag='008'], 24, 1) = 'f'">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies (substring($f006, 1, 1) = 'p'
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- music-->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'c' or substring($f006, 1, 1) = 'd'
                or substring($f006, 1, 1) = 'i'  or substring($f006, 1, 1) = 'j')
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- visual materials -->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 30, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'g' or substring($f006, 1, 1) = 'k'
                or substring($f006, 1, 1) = 'o'  or substring($f006, 1, 1) = 'r')
                and substring($f006, 13, 1) = 'f')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 245 $h -->
            <xsl:when test="some $h in ($record/marc:datafield[@tag='245']/marc:subfield[@code = 'h'])
                satisfies matches(lower-case($h), 'tactile|braille')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 250 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='250']/marc:subfield)
                satisfies matches(lower-case($subfield), 'tactile|braille')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 300 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='300']/marc:subfield[@code = 'a' or @code = 'e'])
                satisfies matches(lower-case($subfield), 'tactile|braille')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 546 $b -->
            <xsl:when test="some $b in ($record/marc:datafield[@tag='546']/marc:subfield[@code = 'b'])
                satisfies matches(lower-case($b), 'tactile|braille')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 655 $a -->
            <xsl:when test="some $a in ($record/marc:datafield[@tag='655']/marc:subfield[@code = 'a'])
                satisfies matches(lower-case($a), 'braille')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 65X $v -->
            <xsl:when test="some $v in ($record/marc:datafield[starts-with(@tag, '65')]/marc:subfield[@code = 'v'])
                satisfies matches(lower-case($v), 'maps for the blind')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            
            <!-- 775 $i -->
            <xsl:when test="some $i in ($record/marc:datafield[@tag = '775']/marc:subfield[@code = 'i'])
                satisfies matches(lower-case($i), 'braille edition of')">
                <xsl:value-of select="'True'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'False'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>