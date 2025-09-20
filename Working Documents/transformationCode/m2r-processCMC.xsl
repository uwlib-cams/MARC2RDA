<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="xs"
    version="3.0">
    
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
    
    <xsl:key name="rdaIRI" match="skos:Concept" use="@rdf:about"/>
    <xsl:key name="lcIRI" match="entry" use="locURI"/>
    
    <xsl:template name="otherFieldsTo33x">
        
        <xsl:param name="record"/>
        <xsl:variable name="marc33XIRIs">
            <xsl:copy-of select="m2r:get33XIRIs($record/*)"/>
        </xsl:variable>
        <xsl:variable name="allCMC">
            <allCMC>
                <xsl:copy-of select="m2r:CMCPatterns(.)"/>
                <xsl:apply-templates select="marc:leader"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '007']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '008']"/>
                <xsl:apply-templates select="marc:controlfield[@tag = '006']"/>
                <xsl:apply-templates select="marc:datafield[@tag = '245']"/>
                <xsl:apply-templates select="marc:datafield[@tag = '300']"/>
            </allCMC>
        </xsl:variable>
        <xsl:variable name="dedupedCMC">
            <IRIs>
                <xsl:for-each-group select="$allCMC//marc:datafield/marc:subfield[@code='1']" group-by="text()">
                    <xsl:choose>
                        <xsl:when test="contains(current-grouping-key(), 'RDAContentType')">
                            <marc:datafield tag="336" ind1=" " ind2=" ">
                                <marc:subfield code="1">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </marc:subfield>
                            </marc:datafield>
                        </xsl:when>
                        <xsl:when test="contains(current-grouping-key(), 'RDACarrierType')">
                            <marc:datafield tag="338" ind1=" " ind2=" ">
                                <marc:subfield code="1">
                                    <xsl:value-of select="current-grouping-key()"/>
                                </marc:subfield>
                            </marc:datafield>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>
            </IRIs>
        </xsl:variable>
        
        <xsl:message>
            <xsl:copy-of select="$dedupedCMC"/>
        </xsl:message>
        
        <xsl:for-each select="$record/*">
            <xsl:copy select=".">
                <xsl:copy-of select="./*"/>
                <xsl:for-each select="$dedupedCMC//marc:datafield">
                    <xsl:if test="not(some $iri in $marc33XIRIs//IRI
                        satisfies matches($iri, marc:subfield[@code='1']))">
                        <xsl:copy-of select="."/>
                    </xsl:if>
                </xsl:for-each>
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
            <xsl:choose>
                <!-- condition for LDR6 = a is that 655 $a and 650 $v not matches below -->
                <xsl:when test="$LDRc6 = 'a'">
                    <xsl:if test="every $subfield in (../marc:datafield[@tag = '655']/marc:subfield[@code = 'a']|../marc:datafield[@tag = '650']/marc:subfield[@code = 'v'])
                        satisfies not(matches($subfield, 'stories without words|coloring book|colouring book'))">
                        <marc:datafield tag="336" ind1=" " ind2=" ">
                            <marc:subfield code="1">
                                <xsl:value-of select="."/>
                            </marc:subfield>
                            <marc:subfield code="9">
                                <xsl:text>LDRc6</xsl:text>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="9">
                            <xsl:text>LDRc6</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        
        <xsl:for-each select="$lookupLDRc6-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="9">
                    <xsl:text>LDRc6</xsl:text>
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
        
        <xsl:variable name="lookup007c0-carrier">
            <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookup007c0', $f007c0)/rdaIRI"/>
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
                <marc:subfield code="9">
                    <xsl:text>007c0</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-content/rdaIRI">
            <marc:datafield tag="336" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="9">
                    <xsl:text>007c0c1</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="9">
                    <xsl:text>007c0</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c1-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="9">
                    <xsl:text>007c0c1</xsl:text>
                </marc:subfield>
            </marc:datafield>
        </xsl:for-each>
        
        <xsl:for-each select="$lookup007c0c5c6-carrier/rdaIRI">
            <marc:datafield tag="338" ind1=" " ind2=" ">
                <marc:subfield code="1">
                    <xsl:value-of select="."/>
                </marc:subfield>
                <marc:subfield code="9">
                    <xsl:text>007c0c5c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c26</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c24</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c25</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c25</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c29</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c29</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c33</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c33</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c34</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c34</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c20</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c23</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c30</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c31</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c30c31</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c29</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c29</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c33</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c33</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c9</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c7</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c8</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c8</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c12</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c12</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
                
                <xsl:variable name="lookupMP006c16-carrier">
                    <xsl:copy-of select="document('lookup/LookupCarrierType.xml')/key('lookupMP006c16orc17', $c16)/rdaIRI"/>
                </xsl:variable>
                <xsl:for-each select="$lookupMP006c16-carrier/rdaIRI">
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                        <marc:subfield code="9">
                            <xsl:text>006c16</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c17</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c17</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>008c20</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c6</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c13</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c14</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c13c14</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c12</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c12</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c16</xsl:text>
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
                        <marc:subfield code="9">
                            <xsl:text>006c16</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '245']">
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <xsl:variable name="h" select="."/>
            <xsl:variable name="lookup245h-content">
                <xsl:copy-of select="document('lookup/LookupContentType.xml')//entry[marc245h][matches($h, marc245h)]/rdaIRI"/>  
            </xsl:variable>
            <xsl:for-each select="$lookup245h-content/rdaIRI">
                <marc:datafield tag="336" ind1=" " ind2=" ">
                    <marc:subfield code="1">
                        <xsl:value-of select="."/>
                    </marc:subfield>
                    <marc:subfield code="9">
                        <xsl:text>245h</xsl:text>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
            
            <xsl:variable name="lookup245h-carrier">
                <xsl:copy-of select="document('lookup/LookupCarrierType.xml')//entry[marc245h][matches($h, marc245h)]/rdaIRI"/>  
            </xsl:variable>
            <xsl:for-each select="$lookup245h-carrier/rdaIRI">
                <marc:datafield tag="338" ind1=" " ind2=" ">
                    <marc:subfield code="1">
                        <xsl:value-of select="."/>
                    </marc:subfield>
                    <marc:subfield code="9">
                        <xsl:text>245h</xsl:text>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '300']">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:variable name="a" select="."/>
            <xsl:variable name="lookup300a-content">
                <xsl:copy-of select="document('lookup/LookupContentType.xml')//entry[marc300a][matches($a, marc300a)]/rdaIRI"/>  
            </xsl:variable>
            <xsl:for-each select="$lookup300a-content/rdaIRI">
                <marc:datafield tag="336" ind1=" " ind2=" ">
                    <marc:subfield code="1">
                        <xsl:value-of select="."/>
                    </marc:subfield>
                    <marc:subfield code="9">
                        <xsl:text>300a</xsl:text>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
            
            <xsl:variable name="lookup300a-carrier">
                <xsl:copy-of select="document('lookup/LookupCarrierType.xml')//entry[marc300a][matches($a, marc300a)]/rdaIRI"/>  
            </xsl:variable>
            <xsl:for-each select="$lookup300a-carrier/rdaIRI">
                <marc:datafield tag="338" ind1=" " ind2=" ">
                    <marc:subfield code="1">
                        <xsl:value-of select="."/>
                    </marc:subfield>
                    <marc:subfield code="9">
                        <xsl:text>300a</xsl:text>
                    </marc:subfield>
                </marc:datafield>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:function name="m2r:CMCPatterns">
        <xsl:param name="record"/>
        <xsl:variable name="contentPatterns" select="document('lookup/LookupContentType.xml')/lookupTable/entry"/>
        <xsl:variable name="carrierPatterns" select="document('lookup/LookupCarrierType.xml')/lookupTable/entry"/>
        <xsl:for-each select="$contentPatterns">
            <xsl:for-each select="./xpath">
                <xsl:variable name="isMatched" as="xs:boolean">
                    <xsl:evaluate xpath="." context-item="$record"/>
                </xsl:variable>
                <xsl:if test="$isMatched">
                    <xsl:message>CONTENT MATCH</xsl:message>
                    <xsl:variable name="rdaIRI" select="following-sibling::rdaIRI"/>
                    <marc:datafield tag="336" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="$rdaIRI"/>
                        </marc:subfield>
                        <marc:subfield code="9">
                            <xsl:text>pattern</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
        
        <xsl:for-each select="$carrierPatterns">
            <xsl:for-each select="./xpath">
                <xsl:variable name="isMatched" as="xs:boolean">
                    <xsl:evaluate xpath="." context-item="$record"/>
                </xsl:variable>
                <xsl:if test="$isMatched">
                    <xsl:message>CARRIER MATCH</xsl:message>
                    <xsl:variable name="rdaIRI" select="following-sibling::rdaIRI"/>
                    <marc:datafield tag="338" ind1=" " ind2=" ">
                        <marc:subfield code="1">
                            <xsl:value-of select="$rdaIRI"/>
                        </marc:subfield>
                        <marc:subfield code="9">
                            <xsl:text>pattern</xsl:text>
                        </marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="m2r:isTactile">
        <xsl:param name="record"/>
        <xsl:param name="record33XIRIs"/>
        <xsl:variable name="ldr6-7" select="substring($record/marc:leader, 7, 2)"/>
        <xsl:choose>
            <!-- 33X Tactile -->
            <xsl:when test="exists($record33XIRIs//IRI[matches(., 'RDAContentType')][matches(., '1004|1005|1015|1016|1017|1018|1019')])">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- 007 -->
            <xsl:when test="some $f007 in $record/marc:controlfield[@tag='007']
                satisfies substring($f007, 1, 1) = 'f'">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- book -->
            
            <!-- 008 -->
            <xsl:when test="($ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'a' or substring($f006, 1, 1) = 't')
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- continuing resources -->
            
            <!-- 008 -->
            <xsl:when test="($ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies (substring($f008, 24, 1) = 'f'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies (substring($f006, 1, 1) = 's'
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- maps -->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 30, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'e' or substring($f006, 1, 1) = 'f')
                and substring($f006, 13, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- mixed materials -->
            
            <!-- 008 -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies (substring($f006, 1, 1) = 'p'
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- music-->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 24, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'c' or substring($f006, 1, 1) = 'd'
                or substring($f006, 1, 1) = 'i'  or substring($f006, 1, 1) = 'j')
                and substring($f006, 7, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- visual materials -->
            
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies substring($f008, 30, 1) = 'f')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- 006 -->
            <xsl:when test="some $f006 in $record/marc:controlfield[@tag='006']
                satisfies ((substring($f006, 1, 1) = 'g' or substring($f006, 1, 1) = 'k'
                or substring($f006, 1, 1) = 'o'  or substring($f006, 1, 1) = 'r')
                and substring($f006, 13, 1) = 'f')">
                <xsl:value-of select="'VM006'"/>
            </xsl:when>
            
            <!-- 245 $h -->
            <xsl:when test="some $h in ($record/marc:datafield[@tag='245']/marc:subfield[@code = 'h'])
                satisfies matches(lower-case($h), 'tactile|braille')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 250 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='250']/marc:subfield)
                satisfies matches(lower-case($subfield), 'tactile|braille')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 300 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='300']/marc:subfield[@code = 'a' or @code = 'e'])
                satisfies matches(lower-case($subfield), 'tactile|braille')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 546 $b -->
            <xsl:when test="some $b in ($record/marc:datafield[@tag='546']/marc:subfield[@code = 'b'])
                satisfies matches(lower-case($b), 'tactile|braille')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 655 $a -->
            <xsl:when test="some $a in ($record/marc:datafield[@tag='655']/marc:subfield[@code = 'a'])
                satisfies matches(lower-case($a), 'braille')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 65X $v -->
            <xsl:when test="some $v in ($record/marc:datafield[starts-with(@tag, '65')]/marc:subfield[@code = 'v'])
                satisfies matches(lower-case($v), 'maps for the blind')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 775 $i -->
            <xsl:when test="some $i in ($record/marc:datafield[@tag = '775']/marc:subfield[@code = 'i'])
                satisfies matches(lower-case($i), 'braille edition of')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="m2r:isMicroform">
        <xsl:param name="record"/>
        <xsl:param name="record33XIRIs"/>
        <xsl:variable name="ldr6-7" select="substring($record/marc:leader, 7, 2)"/>
        <xsl:choose>
            <!-- 33X Microform -->
            <xsl:when test="exists($record33XIRIs//IRI[matches(., 'RDACarrierType')][matches(., '1020|1021|1022|1023|1024|1025|1026|1027|1028|1056')])">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:when test="exists($record33XIRIs//IRI[matches(., 'RDAMediaType')][matches(., '1002')])">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- book -->
            <!-- 008 -->
            <xsl:when test="($ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 24, 1), 'a|b|c'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- continuing resources -->
            <!-- 008 -->
            <xsl:when test="($ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 24, 1), 'a|b|c|'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- maps -->
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 30, 1), 'a|b|c'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- mixed materials -->
            <!-- 008 -->
            <xsl:when test="substring($ldr6-7, 1, 1) = 'p'
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 24, 1), 'a|b|c'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- music-->
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 24, 1), 'a|b|c'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- visual materials -->
            <!-- 008 -->
            <xsl:when test="(substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r')
                and (some $f008 in $record/marc:controlfield[@tag='008']
                satisfies matches(substring($f008, 30, 1), 'a|b|c'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 007 -->
            <xsl:when test="some $f007 in $record/marc:controlfield[@tag='007']
                satisfies substring($f007, 1, 1) = 'h'">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 245 $h -->
            <xsl:when test="some $h in ($record/marc:datafield[@tag='245']/marc:subfield[@code = 'h'])
                satisfies (matches(lower-case($h), 'micro') and not(matches(lower-case($h), 'microscope')))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 300 $a -->
            <xsl:when test="some $a in ($record/marc:datafield[@tag='300']/marc:subfield[@code = 'a'])
                satisfies (matches(lower-case($a), 'micro|aperture card') and not(matches(lower-case($a), 'microscope')))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 533 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='533']/marc:subfield[@code = 'a' or @code = 'e'])
                satisfies (matches(lower-case($subfield), '^microfiche|^microfilm|^microopaque|^aperture card'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <!-- 583 -->
            <xsl:when test="some $subfield in ($record/marc:datafield[@tag='583']/marc:subfield[@code = 'a' or @code = 'i'])
                satisfies (matches(lower-case($subfield), '^microfiche|^microfilm|^microopaque|^aperture card'))">
                <xsl:value-of select="true()"/>
            </xsl:when>
            
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="m2r:isElectronic">
        <xsl:param name="record"/>
        <xsl:param name="record33XIRIs"/>
        <xsl:variable name="ldr6-7" select="substring($record/marc:leader, 7, 2)"/>
        <xsl:variable name="electronicIndicators">
            <xsl:choose>
                <!-- 33x computer -->
                <xsl:when test="exists($record33XIRIs//IRI[matches(., 'http://rdaregistry.info/termList/RDAMediaType/1003')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:when test="exists($record33XIRIs//IRI[matches(., 'RDACarrierType')]
                    [matches(., '1010|1011|1012|1013|1014|1015|1016|1017|1018')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <!-- 583 $a -->
                <xsl:when test="exists($record/marc:datafield[@tag='583']/marc:subfield[@code='a'][matches(lower-case(.), 'digitized')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 588 $a -->
                <xsl:when test="exists($record/marc:datafield[@tag='588']/marc:subfield[@code='a'][matches(lower-case(.), 'version record')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 007/00 -->
                <xsl:when test="exists($record/marc:controlfield[@tag='007'][substring(., 1, 1) = 'c'])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- book -->
                <!-- 008 -->
                <xsl:when test="($ldr6-7 = 'aa' or $ldr6-7 = 'ac' or $ldr6-7 = 'ad' or $ldr6-7 = 'am'
                    or $ldr6-7 = 'ca' or $ldr6-7 = 'cc' or $ldr6-7 = 'cd' or $ldr6-7 = 'cm')
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 24, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- continuing resources -->
                <!-- 008 -->
                <xsl:when test="($ldr6-7 = 'ab' or $ldr6-7 = 'ai' or $ldr6-7 = 'as')
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 24, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- maps -->
                <!-- 008 -->
                <xsl:when test="(substring($ldr6-7, 1, 1) = 'e' or substring($ldr6-7, 1, 1) = 'f')
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 30, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- mixed materials -->
                <!-- 008 -->
                <xsl:when test="substring($ldr6-7, 1, 1) = 'p'
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 24, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- music-->
                <!-- 008 -->
                <xsl:when test="(substring($ldr6-7, 1, 1) = 'i' or substring($ldr6-7, 1, 1) = 'j'
                    or substring($ldr6-7, 1, 1) = 'c' or substring($ldr6-7, 1, 1) = 'd')
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 24, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- visual materials -->
                <!-- 008 -->
                <xsl:when test="(substring($ldr6-7, 1, 1) = 'g' or substring($ldr6-7, 1, 1) = 'k'
                    or substring($ldr6-7, 1, 1) = 'o' or substring($ldr6-7, 1, 1) = 'r')
                    and (some $f008 in $record/marc:controlfield[@tag='008']
                    satisfies matches(substring($f008, 30, 1), 'o|q|s'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 856 ind2 -->
                <xsl:when test="exists($record/marc:datafield[@tag='856'][@ind2='0'])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 300 $a online resource -->
                <xsl:when test="exists($record/marc:datafield[@tag='300']/marc:subfield[@code='a']
                    [matches(lower-case(.), 'online resource')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 533 $a -->
                <xsl:when test="exists($record/marc:datafield[@tag='533']/marc:subfield[@code='a']
                    [matches(lower-case(.), 'electronic|online|computer|streaming')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 588 $a -->
                <xsl:when test="exists($record/marc:datafield[@tag='588']/marc:subfield[@code='a']
                    [matches(lower-case(.), 'electronic|online|computer|streaming')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 245 $h -->
                <xsl:when test="exists($record/marc:datafield[@tag='245']/marc:subfield[@code='h']
                    [matches(lower-case(.), 'electronic|online|computer|streaming')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 300 $a -->
                <xsl:when test="exists($record/marc:datafield[@tag='300']/marc:subfield[@code='a']
                    [matches(lower-case(.), 'electronic|online|computer|streaming')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- 040 $e -->
                <xsl:when test="exists($record/marc:datafield[@tag='040']/marc:subfield[@code='e'][matches(lower-case(.), 'pn')])">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <!-- LDR 6 -->
                <xsl:when test="matches(substring($ldr6-7, 1, 1), 'm')">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:value-of select="$electronicIndicators"/>
    </xsl:function>
    
    <xsl:function name="m2r:get33XIRIs">
        <xsl:param name="record"/>
        <xsl:variable name="IRIs">
            <IRIs>
                <xsl:for-each select="$record/marc:datafield[@tag='336' or @tag='337' or @tag='338']">
                    <!-- check for existing IRIs from $0 and $1 -->
                    <xsl:for-each select="marc:subfield[@code = '0'] | marc:subfield[@code = '1']">
                        <xsl:choose>
                            <xsl:when test="contains(., 'rdaregistry.info/termList/')">
                                <IRI>
                                    <xsl:value-of select="."/>
                                </IRI>
                            </xsl:when>
                            <xsl:when test="contains(., 'id.loc.gov/vocabulary/')">
                                <xsl:for-each select="document('lookup/LookupContentType.xml')/lookupTable/entry/key('lcIRI', .)/rdaIRI">
                                    <IRI>
                                        <xsl:value-of select="."/>
                                    </IRI>
                                </xsl:for-each>
                                <xsl:for-each select="document('lookup/LookupCarrierType.xml')/lookupTable/entry/key('lcIRI', .)/rdaIRI">
                                    <IRI>
                                        <xsl:value-of select="."/>
                                    </IRI>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    
                    <!-- $a and $b -->
                    <xsl:if test="marc:subfield[@code='2'] and starts-with(normalize-space(lower-case(marc:subfield[@code='2'][1])), 'rda')">
                        <xsl:variable name="sub2" select="marc:subfield[@code='2'][1]"/>
                        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
                            <xsl:variable name="rdaIRI">
                                <xsl:copy-of select="m2r:rdalcTermCodeLookup-33X(., ../@tag)"/>
                            </xsl:variable>
                            <xsl:if test="$rdaIRI//@rdf:resource">
                                <xsl:for-each select="$rdaIRI//@rdf:resource">
                                    <IRI>
                                        <xsl:value-of select="."/>
                                    </IRI>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:for-each>
            </IRIs>
        </xsl:variable>
        
        <xsl:variable name="dedupedIRIs">
            <IRIs>
                <xsl:for-each-group select="$IRIs/IRIs/IRI" group-by="text()">
                    <IRI>
                        <xsl:value-of select="current-grouping-key()"/>
                    </IRI>
                </xsl:for-each-group>
            </IRIs>
        </xsl:variable>
        <xsl:copy-of select="$dedupedIRIs"/>
    </xsl:function>
    
</xsl:stylesheet>