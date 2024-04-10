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
    <xsl:key name="fieldKey" match="uwmisc:row" use="uwmisc:field"/>
    <xsl:key name="indKey" match="uwmisc:row" use="uwmisc:ind1"/>
    <xsl:key name="domainKey" match="uwmisc:row" use="uwmisc:domain"/>
    <xsl:key name="sub4Key" match="uwmisc:row" use="uwmisc:sub4Code | uwmisc:marcRelIri | uwmisc:unconIri"/>
    <xsl:key name="sub4KeyRda" match="uwmisc:row" use="uwmisc:rdaPropIri"/>
    <xsl:key name="subEKeyMarc" match="uwmisc:row" use="uwmisc:subELabelMarc"/>
    <xsl:key name="subEKeyRda" match="uwmisc:row" use="uwmisc:subELabelRda"/>
    <xsl:variable name="rel2rda" select="'./input/relator-table-xml.xml'"/>
    <xsl:mode name="wor" on-no-match="shallow-skip"/>
    
    <xsl:template match="/" expand-text="true">
        <xsl:for-each select="marc:collection">
            <xsl:for-each select="marc:record">
                
                <rdf:Description rdf:about="{concat('http://testrelator.org/','wor')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                    <rdawo:P10078 rdf:resource="{concat('http://testrelator.org/','exp')}"/>
                    <rdawd:P10002>{concat(marc:controlfield[@tag='001'],'wor')}</rdawd:P10002>
                  
                    <xsl:apply-templates select="*" mode="wor"/>
                </rdf:Description>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100']" mode="wor">
        <xsl:variable name="agentIRI" select="concat('http://marc2rda.edu/agent/', translate(marc:subfield[@code='a'], ' ', ''))"/>
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
        <!-- if e matches rda label or 4 matches rda iri - y/n doesn't matter? double check -->
        <xsl:for-each select="marc:subfield[@code = '4']">
            <xsl:variable name="sub4Rda" select="uwf:relatorLookup4RDA(., 'X00', $indValue, 'work')"/>
            <xsl:if test="not(contains($sub4Rda, 'NO MATCH'))">
                <xsl:element name="{'rdawo:' || substring-after($sub4Rda, 'rdaw:')}">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <xsl:variable name="subERda" select="uwf:relatorLookupERDA(., 'X00', $indValue, 'work')"/>
            <xsl:if test="not(contains($subERda, 'NO MATCH'))">
                <xsl:element name="{'rdawo:' || substring-after($subERda, 'rdaw:')}">
                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <!-- if e or 4 is marc and N multiple domains - match rda iri -->
        <!-- if e or 4 is marc and Y multiple domains - default  -->
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
                    <xsl:value-of select="(key('sub4KeyRda', $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]/uwmisc:curie"/>
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
                    <xsl:value-of select="(key('subEKeyRda', $eValue, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda)))[1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'NO MATCH'"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:function>
    
    
    <xsl:function name="uwf:relatorLookup" expand-text="yes">
        <xsl:param name="field"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <!-- match marcRel2Rda table row by field, indicator, and domain -->
        <!-- this narrows down the list of possible matches -->
        
        <xsl:for-each select="$field/marc:subfield[@code = '4']">
            <xsl:choose>
                <xsl:when test="contains(., 'http://rdaregistry.info/Elements/')">
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test="key('sub4Key', ., document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda))">
                    <xsl:for-each select="key('sub4Key', ., document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda))">
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'NO MATCH'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$field/marc:subfield[@code = 'e']">
            <xsl:choose>
                <xsl:when test="key('subEKey', ., document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda))">
                    <xsl:value-of select="key('subEKey', ., document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                        intersect key('indKey', $ind, document($rel2rda))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'NO MATCH'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
       
       
    </xsl:function>
</xsl:stylesheet>
