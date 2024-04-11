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
    xmlns:rdai="http://rdaregistry.info/Elements/i/"
    xmlns:rdaid="http://rdaregistry.info/Elements/i/datatype/"
    xmlns:rdaio="http://rdaregistry.info/Elements/i/object/"
    xmlns:rdaa="http://rdaregistry.info/Elements/a/"
    xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
    xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf"
    version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:key name="fieldKey" match="uwmisc:row" use="uwmisc:field" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="indKey" match="uwmisc:row" use="uwmisc:ind1" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="domainKey" match="uwmisc:row" use="uwmisc:domain" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="sub4Key" match="uwmisc:row" use="uwmisc:sub4Code | uwmisc:marcRelIri | uwmisc:unconIri" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="sub4KeyRda" match="uwmisc:row" use="uwmisc:rdaPropIri" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subEKeyMarc" match="uwmisc:row" use="uwmisc:subELabelMarc" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subEKeyRda" match="uwmisc:row" use="uwmisc:subELabelRda" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    
    <xsl:key name="anyMatch" match="uwmisc:row" use="uwmisc:sub4Code | uwmisc:marcRelIri | uwmisc:unconIri | uwmisc:rdaPropIri | uwmisc:subELabelMarc | uwmisc:subELabelRda" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    
    <xsl:variable name="rel2rda" select="'./input/relator-table-xml.xml'"/>
    <xsl:mode name="wor" on-no-match="shallow-skip"/>
    <xsl:mode name="exp" on-no-match="shallow-skip"/>
    <xsl:mode name="man" on-no-match="shallow-skip"/>
    
    <xsl:template match="/" expand-text="true">
        <xsl:for-each select="marc:collection">
        <rdf:RDF >
            <xsl:for-each select="marc:record">
                <rdf:Description rdf:about="{concat('http://testrelator.org/','wor')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                    <rdawo:P10078 rdf:resource="{concat('http://testrelator.org/','exp')}"/>
                    <rdawd:P10002>{concat(marc:controlfield[@tag='001'],'wor')}</rdawd:P10002>
                    <xsl:apply-templates select="*" mode="wor"/>
                </rdf:Description>
                
                <rdf:Description rdf:about="{concat('http://testrelator.org/','exp')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
                    <rdaeo:P20059 rdf:resource="{concat('http://testrelator.org/','man')}"/>
                    <rdaeo:P20231 rdf:resource="{concat('http://testrelator.org/','wor')}"/>
                    <rdaed:P20002>{concat(marc:controlfield[@tag='001'],'exp')}</rdaed:P20002>
                    <xsl:apply-templates select="*" mode="exp"/>
                </rdf:Description>
                
                <rdf:Description rdf:about="{concat('http://testrelator.org/','man')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdamo:P30139 rdf:resource="{concat('http://testrelator.org/','exp')}"/>
                    <xsl:apply-templates select="*" mode="man"/>
                </rdf:Description>
                
            </xsl:for-each>
            </rdf:RDF>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100']" mode = "wor">
        <xsl:call-template name="handleRelator">
            <xsl:with-param name="domain" select="'work'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '100']" mode = "exp">
        <xsl:call-template name="handleRelator">
            <xsl:with-param name="domain" select="'expression'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '100']" mode = "man">
        <xsl:call-template name="handleRelator">
            <xsl:with-param name="domain" select="'manifestation'"/>
        </xsl:call-template>
    </xsl:template>


    <!-- note: 720 will have its own template -->
    <xsl:template name="handleRelator" expand-text="true">
        <xsl:param name="domain"/>
        <xsl:variable name="agentIRI" select="concat('http://marc2rda.edu/agent/', translate(marc:subfield[@code='a'], ' ', ''))"/>
        
        <xsl:variable name="ns-wemi">
            <xsl:choose>
                <xsl:when test="starts-with($domain, 'work')">rdawo</xsl:when>
                <xsl:when test="starts-with($domain, 'expression')">rdaeo</xsl:when>
                <xsl:when test="starts-with($domain, 'manifestation')">rdamo</xsl:when>
                <xsl:when test="starts-with($domain, 'item')">rdaio</xsl:when>
                <xsl:otherwise>namespaceError</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="indValue">
            <xsl:choose>
                <xsl:when test="(@ind1 = '1') or (@ind1 = '0')">
                    <xsl:value-of select="'0 or 1'"/>
                </xsl:when>
                <xsl:when test="(@ind1 = ' ')">
                    <xsl:value-of select="'#'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@ind1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fieldType" select="uwf:fieldType(@tag)"/>
        
        <!-- do ANY of the relators match in ANY domain-->
        <xsl:variable name="anyMatch" select="uwf:anyRelatorMatch(., $fieldType, $indValue)"/>
        <xsl:choose>
            <!-- no subfields have a match -->
            <xsl:when test="$anyMatch = 'DEFAULT'">
                <xsl:value-of select="'NONE'"/>
            </xsl:when>
            
            <!-- at least one does -->
            <xsl:otherwise>
                <!-- if e matches rda label or 4 matches rda iri - multipleDomains doesn't matter? double check -->
                <!-- TESTED -->
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Rda" select="uwf:relatorLookup4RDA(., $fieldType, $indValue, $domain)"/>
                    <xsl:if test="not(contains($sub4Rda, 'NO MATCH'))">
                        <xsl:element name="{$ns-wemi || ':' || substring-after($sub4Rda/uwmisc:curie, ':')}">
                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
                
                <xsl:if test="$fieldType = 'X00' or $fieldType = 'X10'">
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:variable name="subERda" select="uwf:relatorLookupERDA(., $fieldType, $indValue, $domain)"/>
                        <xsl:if test="not(contains($subERda, 'NO MATCH'))">
                            <xsl:element name="{$ns-wemi || ':' || substring-after($subERda/uwmisc:curie, ':')}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- see if I can do this with ERda function-->
                <xsl:if test="$fieldType = 'X11'">
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <xsl:variable name="subERda" select="uwf:relatorLookupERDA(., 'X00', $indValue, $domain)"/>
                        <xsl:if test="not(contains($subERda, 'NO MATCH'))">
                            <xsl:element name="{$ns-wemi || ':' || substring-after($subERda/uwmisc:curie, ':')}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- if e or 4 is marc and N multiple domains - match rda iri -->
                <!-- if e or 4 is marc and Y multiple domains - default  -->
                <!-- UNTESTED -->
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Marc" select="uwf:relatorLookup4Marc(., $fieldType, $indValue, $domain)"/>
                    <xsl:choose>
                        <xsl:when test="contains($sub4Marc, 'NO MATCH')">
                            <!-- do nothing on no match -->
                        </xsl:when>
                        <xsl:when test="contains($sub4Marc, 'DEFAULT')">
                            <!-- this means there's a match but multiple domains - we default-->
                            <xsl:copy-of select="uwf:defaultIRI(.., $fieldType, $domain, $agentIRI)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                            <xsl:element name="{$ns-wemi || ':' || substring-after($sub4Marc/uwmisc:curie, ':')}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
                <xsl:for-each select="marc:subfield[@code = 'e']">
                <xsl:variable name="subEMarc" select="uwf:relatorLookupEMarc(., $fieldType, $indValue, $domain)"/>
                <xsl:choose>
                    <xsl:when test="contains($subEMarc, 'NO MATCH')">
                        <!-- do nothing on no match -->
                    </xsl:when>
                    <xsl:when test="contains($subEMarc, 'DEFAULT')">
                        <!-- this means there's a match but multiple domains - we default-->
                        <xsl:copy-of select="uwf:defaultIRI(.., $fieldType, $domain, $agentIRI)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                        <xsl:element name="{$ns-wemi || ':' || substring-after($subEMarc/uwmisc:curie, ':')}">
                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- if $4 or $e are rda values, domain is a given and we don't worry about multiple domains -->
    <xsl:function name="uwf:relatorLookup4RDA" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
            <xsl:choose>
                <xsl:when test="key('sub4KeyRda', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda))">
                    <xsl:copy-of select="(key('sub4KeyRda', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'NO MATCH'"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:relatorLookupERDA" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
            <xsl:variable name="eValue" select="lower-case($subfield)"/>
            <xsl:choose>
                <xsl:when test="key('subEKeyRda', $eValue, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda))">
                    <xsl:copy-of select="(key('subEKeyRda', $eValue, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'NO MATCH'"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:relatorLookup4Marc" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
        <xsl:choose>
            <xsl:when test="key('sub4Key', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda))">
                <xsl:variable name="sub4Match" select="(key('sub4Key', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]"/>
                <xsl:choose>
                    <xsl:when test="contains($sub4Match/uwmisc:multipleDomains, 'N')">
                        <xsl:copy-of select="$sub4Match"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'DEFAULT'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'NO MATCH'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:relatorLookupEMarc" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
        <xsl:choose>
            <xsl:when test="key('subEKeyMarc', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda))">
                <xsl:variable name="subEMatch" select="(key('subEKeyMarc', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]"/>
                <xsl:choose>
                    <xsl:when test="contains($subEMatch/uwmisc:multipleDomains, 'N')">
                        <xsl:copy-of select="$subEMatch"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'DEFAULT'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'NO MATCH'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:anyRelatorMatch">
        <xsl:param name="field"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        
        <xsl:variable name="testMatch" select="if (some $subfield in ($field/marc:subfield[@code = 'e'] | $field/marc:subfield[@code = '4'] | $field/marc:subfield[@code = 'j']) satisfies (key('anyMatch', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
            intersect key('indKey', $ind, document($rel2rda)))) then 'true' else 'false' "/>
        <xsl:choose>
            <xsl:when test="$testMatch = 'false'">
                <xsl:value-of select="'DEFAULT'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'MATCH'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:fieldType">
        <xsl:param name="fieldNum"/>
        <xsl:choose>
            <xsl:when test="($fieldNum = '100') or ($fieldNum = '600') or ($fieldNum = '700')" >
                <xsl:value-of select="'X00'"/>
            </xsl:when>
            <xsl:when test="($fieldNum = '110') or ($fieldNum = '610') or ($fieldNum = '710')" >
                <xsl:value-of select="'X10'"/>
            </xsl:when>
            <xsl:when test="($fieldNum = '111') or ($fieldNum = '611') or ($fieldNum = '711')" >
                <xsl:value-of select="'X11'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$fieldNum"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:defaultIRI">
        <xsl:param name="field"/>
        <xsl:param name="fieldType"/>
        <xsl:param name="domain"/>
        <xsl:param name="agentIRI"/>
    
    <xsl:choose>
        <xsl:when test="$domain = 'manifestation'">
            <xsl:choose>
                <xsl:when test="starts-with($field/@tag, '1') or starts-with($field/@tag, '7')">
                    <!-- 1XX and 7XX -->
                    <xsl:choose>
                        <xsl:when test="$fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1')">
                            <!-- person -->
                            <xsl:element name="{'rdamo:P30268'}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                            <!-- family -->
                            <xsl:element name="{'rdamo:P30269'}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                            <!-- corporate body -->
                            <xsl:element name="{'rdamo:P30270'}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="$domain = 'work'">
            <!-- I think this is only for subjects, needs to be handled -->
        </xsl:when>
        <xsl:otherwise/>
    </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>
