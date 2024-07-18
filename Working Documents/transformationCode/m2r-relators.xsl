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
    <xsl:import href="m2r-functions.xsl"/>
    
<!-- **KEYS FOR LOOKUP** -->
    <xsl:key name="fieldKey" match="uwmisc:row" use="uwmisc:field" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="indKey" match="uwmisc:row" use="uwmisc:ind1" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="sub4KeyMarc" match="uwmisc:row" use="uwmisc:sub4Code | uwmisc:marcRelIri | uwmisc:unconIri" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="sub4KeyRda" match="uwmisc:row" use="uwmisc:rdaPropIri" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subEKeyMarc" match="uwmisc:row" use="uwmisc:subELabelMarc" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subEKeyRda" match="uwmisc:row" use="uwmisc:subELabelRda" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subJKeyMarc" match="uwmisc:row" use="uwmisc:subJLabelMarc" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="subJKeyRda" match="uwmisc:row" use="uwmisc:subJLabelRda" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    <xsl:key name="anyMatch" match="uwmisc:row" use="uwmisc:sub4Code | uwmisc:marcRelIri | uwmisc:unconIri | uwmisc:rdaPropIri | uwmisc:subELabelMarc | uwmisc:subELabelRda" collation="http://saxon.sf.net/collation?ignore-case=yes"/>
    
    <xsl:variable name="rel2rda" select="'./lookup/relatorTable-2024-05-15.xml'"/>
    
<!-- **FUNCTIONS** -->   
    
    <!-- returns an IRI for an agent entity -->
    <xsl:function name="uwf:agentIRI">
        <xsl:param name="field"/>
        <xsl:variable name="ap" select="lower-case(string-join(uwf:agentAccessPoint($field)))"/> 
        <xsl:choose>
            <!-- If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1']">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise it's an opaque IRI to avoid conflating different agents under one IRI -->
            <xsl:otherwise>
                <xsl:value-of select="'http://marc2rda.edu/agent/'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- returns an IRI for a nomen related to an agent entity -->
    <xsl:function name="uwf:agentNomenIRI">
        <xsl:param name="field"/>
        <!-- function bc how we do this might change -->
<!--        <xsl:variable name="ap" select="lower-case(string-join(uwf:agentAccessPoint($field)))"/> 
        <xsl:choose>
            <!-\- If $0 or $1 or $2, it's authorized, construct an IRI from authorized access point -\->
            <xsl:when test="$field/marc:subfield[@code = '1'] or $field/marc:subfield[@code = '0'] or $field/marc:subfield[@code = '2']">
                <xsl:value-of select="concat('http://marc2rda.edu/fake/nom/', encode-for-uri(translate($ap, ' ', '')))"/>
            </xsl:when>
            <!-\- otherwise it's an opaque IRI -\->
            <xsl:otherwise>
                <xsl:value-of select="'http://marc2rda.edu/agent/nom/'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>-->
        <xsl:value-of select="'http://marc2rda.edu/agent/nom/'||generate-id($field)"/>
    </xsl:function>
    
    <!-- generates an access point for an agent based on the subfields present in the field -->
    <xsl:function name="uwf:agentAccessPoint" expand-text="true">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700'">
                <xsl:for-each select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                    | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'j'] | $field/marc:subfield[@code = 'q']
                    | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]">
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:text>{.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$field/@tag = '720'">
                <xsl:value-of select="$field/marc:subfield[@code = 'a']"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '110' or $field/@tag = '610' or $field/@tag = '710'">
                <xsl:for-each select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                    | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                    | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]">
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:text>{.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$field/@tag = '111' or $field/@tag = '611' or $field/@tag = '711'">
                <xsl:for-each select="$field/marc:subfield[@code = 'a']  | $field/marc:subfield[@code = 'c'] | $field/marc:subfield[@code = 'e'] | $field/marc:subfield[@code = 'q']
                    | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                    | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]">
                    <xsl:choose>
                        <xsl:when test="position() != last()">
                            <xsl:text>{.} </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- processes a relator term before lookup in the relator table -->
    <xsl:function name="uwf:normalizeRelatorTerm">
        <xsl:param name="subfield"/>
        <xsl:choose>
            <xsl:when test="$subfield/@code = 'e' or $subfield/@code = 'j'">
                <xsl:choose>
                    <xsl:when test="starts-with(normalize-space($subfield), 'jt')">
                        <xsl:value-of select="normalize-space(translate(replace($subfield, 'jt', ''), ',.', ''))"/>
                    </xsl:when>
                    <xsl:when test="starts-with(normalize-space($subfield), 'joint')">
                        <xsl:value-of select="normalize-space(translate(replace($subfield, 'joint', ''), ',.', ''))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(translate($subfield, ',.', ''))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($subfield)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- This is a placeholder for handling multiple $1 values, it currently returns the first $1 value -->
    <xsl:function name="uwf:multiple1s">
        <xsl:param name="field"/>
        <xsl:value-of select="$field/marc:subfield[@code = '1'][1]"/>
    </xsl:function>
    
    <!-- takes in the field number and returns the field type for lookup in relator table -->
    <!-- either 'X00', 'X10', or 'X11' -->
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
                <!-- otherwise it's 720 -->
                <xsl:value-of select="$fieldNum"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:ind1Type">
        <xsl:param name="tag"/>
        <xsl:param name="ind1"/>
        <xsl:choose>
            <!-- for 720, options are '1' or '# or 2' -->
            <xsl:when test="$tag = '720'">
                <xsl:choose>
                    <xsl:when test="not($ind1 = '1')">
                        <xsl:value-of select="'# or 2'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$ind1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$tag = 'X10' or $tag = 'X11'">
                <xsl:value-of select="'any'"/>
            </xsl:when>
            <!-- options are '0 or 1 or 2', '#', and '3' -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="($ind1 = '1') or ($ind1 = '0') or ($ind1 = '2')">
                        <xsl:value-of select="'0 or 1 or 2'"/>
                    </xsl:when>
                    <xsl:when test="($ind1 = ' ')">
                        <xsl:value-of select="'#'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$ind1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- if any $e$4$j matches in the relator table for that field type and ind1 value, returns match, otherwise default -->
    <xsl:function name="uwf:anyRelatorMatch">
        <xsl:param name="field"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind1"/>
        
        <xsl:variable name="testMatch" select="if (some $subfield in ($field/marc:subfield[@code = 'e'] | $field/marc:subfield[@code = '4'] | $field/marc:subfield[@code = 'j']) satisfies (key('anyMatch', uwf:normalizeRelatorTerm($subfield), document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
            intersect key('indKey', $ind1, document($rel2rda)))) then 'true' else 'false' "/>
        <xsl:choose>
            <xsl:when test="$testMatch = 'false'">
                <xsl:value-of select="'DEFAULT'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'MATCH'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- if $4 or $e are rda values, domain is a given and we don't worry about multiple domains -->
    <xsl:function name="uwf:relatorLookupRDA" expand-text="yes">
        <xsl:param name="key"/>
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:choose>
            <xsl:when test="key($key, $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                intersect key('indKey', $ind, document($rel2rda))">
                <xsl:copy-of select="(key($key, $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)))[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'NO MATCH'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- marc lookups -->
    <xsl:function name="uwf:relatorLookupMarc" expand-text="yes">
        <xsl:param name="key"/>
        <xsl:param name="subfield"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
        <xsl:choose>
            <xsl:when test="key($key, $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                intersect key('indKey', $ind, document($rel2rda))">
                <xsl:variable name="match" select="(key($key, $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                    intersect key('indKey', $ind, document($rel2rda)))[1]"/>
                <xsl:choose>
                    <xsl:when test="contains($match/uwmisc:multipleDomains, 'N')">
                        <xsl:copy-of select="$match"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'DEFAULT'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$domain = 'manifestation'">
                        <xsl:choose>
                            <xsl:when test="contains((key($key, $subfield, document($rel2rda)) intersect key('fieldKey', $fieldNum, document($rel2rda)) 
                                intersect key('indKey', $ind, document($rel2rda)))[1]/uwmisc:multipleDomains, 'Y')">
                                <xsl:value-of select="'DEFAULT'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'NO MATCH'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'NO MATCH'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xsl:function name="uwf:defaultProp">
        <xsl:param name="field"/>
        <xsl:param name="fieldType"/>
        <xsl:param name="domain"/>
        <xsl:param name="objIRI"/>
        <xsl:param name="objString"/>
        <xsl:choose>
            <xsl:when test="$domain = 'manifestation'">
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '1') or starts-with($field/@tag, '7')">
                        <!-- 1XX and 7XX -->
                        <xsl:choose>
                            <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                <!-- person -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdamo:P30268'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                <!-- family -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdamo:P30269'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                <!-- corporate body -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdamo:P30270'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = '720'">
                                <xsl:choose>
                                    <xsl:when test="$field/@ind = '1'">
                                        <!-- person -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objString"/></xsl:comment>
                                        <xsl:element name="{'rdamd:P30268'}">
                                            <xsl:copy-of select="$objString"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- agent -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objString"/></xsl:comment>
                                        <xsl:element name="{'rdamd:P30267'}">
                                            <xsl:copy-of select="$objString"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$domain = 'agent'">
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '1') or starts-with($field/@tag, '7')">
                        <!-- 1XX and 7XX -->
                        <xsl:choose>
                            <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                <!-- person -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50313'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                <!-- family -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50322'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                <!-- corporate body -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50331'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    
   
<!-- **TEMPLATES** -->
    
    <!-- handleRelator template sets the appropriate variables for lookup in the relator table
         and outputs the property returned from the lookup -->
    
    <xsl:template name="handleRelator" expand-text="true">
    
        <!-- domain from field template mode -->
        <xsl:param name="domain"/>
        
        <!-- ***** VARIABLES ****** -->
        <!-- IRI generated from field, this is a temporary value for now -->
        <xsl:variable name="agentIRI" select="uwf:agentIRI(.)"/>
        
        <!-- Access point -->
        <xsl:variable name="agentAP" select="uwf:agentAccessPoint(.)"/>
        
        <!-- namespace generated based on domain - this gives us the object namespace -->
        <!-- are there cases where we will use a datatype instead of IRI? -->
        <xsl:variable name="ns-wemi">
            <xsl:choose>
                <xsl:when test="starts-with($domain, 'work')">rdaw</xsl:when>
                <xsl:when test="starts-with($domain, 'expression')">rdae</xsl:when>
                <xsl:when test="starts-with($domain, 'manifestation')">rdam</xsl:when>
                <xsl:when test="starts-with($domain, 'item')">rdai</xsl:when>
                <xsl:otherwise>namespaceError</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- fieldType is for lookup - see function uwf:fieldType() -->
        <xsl:variable name="fieldType" select="uwf:fieldType(@tag)"/>
        
        <!-- the indValue is based off field's ind1 to match lookup table - see function uwf:ind1Type()-->
        <xsl:variable name="indValue" select="uwf:ind1Type($fieldType, @ind1)"/>
        
        
    <!-- ****START TEST**** -->
        
        <!-- do ANY of the relators match in ANY domain - see uwf:anyRelatorMatch() function-->
        <xsl:variable name="anyMatch" select="uwf:anyRelatorMatch(., $fieldType, $indValue)"/>
        <xsl:choose>
            <!-- no subfields have a match -->
            <!-- if no $4$e$j match, this needs to be a default value, there's no point doing any further lookup -->
            <xsl:when test="$anyMatch = 'DEFAULT'">
                <xsl:copy-of select="uwf:defaultProp(., $fieldType, $domain, $agentIRI, $agentAP)"/>
            </xsl:when>
            
            <!-- otherwise at least one does -->
            <xsl:otherwise>
                <!-- if 4 matches rda iri - multipleDomains doesn't matter -->
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Rda" select="uwf:relatorLookupRDA('sub4KeyRda', uwf:normalizeRelatorTerm(.), $fieldType, $indValue)"/>
                    <xsl:if test="not(contains($sub4Rda, 'NO MATCH')) and $sub4Rda/uwmisc:domain = $domain">
                        <xsl:choose>
                            <xsl:when test="$fieldType = '720'">
                                <xsl:element name="{$ns-wemi || 'd:' || substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)}">
                                    <xsl:copy-of select="$agentAP"/>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- if X00, or X10 and e matches rda label -->
                <xsl:if test="$fieldType = 'X00' or $fieldType = 'X10' or $fieldType = '720'">
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:variable name="subERda" select="uwf:relatorLookupRDA('subEKeyRda', uwf:normalizeRelatorTerm(.), $fieldType, $indValue)"/>
                        <xsl:if test="not(contains($subERda, 'NO MATCH')) and $subERda/uwmisc:domain = $domain">
                            <xsl:choose>
                                <xsl:when test="$fieldType = '720'">
                                    <xsl:element name="{$ns-wemi || 'd:' || substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)}">
                                        <xsl:copy-of select="$agentAP"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- if X11 and j matches rda label -->
                <xsl:if test="$fieldType = 'X11'">
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <xsl:variable name="subJRda" select="uwf:relatorLookupRDA('subJKeyRda', uwf:normalizeRelatorTerm(.), 'X00', $indValue)"/>
                        <xsl:if test="not(contains($subJRda, 'NO MATCH')) and $subJRda/uwmisc:domain = $domain">
                            <xsl:element name="{$ns-wemi || 'o:' || substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)}">
                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- if $e$4$j is marc and N multiple domains - match rda iri -->
                <!-- if $e$4$j is marc and Y multiple domains - default  -->
                
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Marc" select="uwf:relatorLookupMarc('sub4KeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, $domain)"/>
                    <xsl:choose>
                        <xsl:when test="contains($sub4Marc, 'NO MATCH')">
                            <!-- do nothing on no match -->
                        </xsl:when>
                        <xsl:when test="contains($sub4Marc, 'DEFAULT')">
                            <!-- this means there's a match but multiple domains - we default-->
                            <xsl:copy-of select="uwf:defaultProp(.., $fieldType, $domain, $agentIRI, $agentAP)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                            <xsl:if test="$sub4Marc/uwmisc:domain = $domain">
                                <xsl:choose>
                                    <xsl:when test="$fieldType = '720'">
                                        <xsl:element name="{$ns-wemi || 'd:' || substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:copy-of select="$agentAP"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
                <xsl:if test="$fieldType = 'X00' or $fieldType = 'X10' or $fieldType = '720'">
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:variable name="subEMarc" select="uwf:relatorLookupMarc('subEKeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, $domain)"/>
                    <xsl:choose>
                        <xsl:when test="contains($subEMarc, 'NO MATCH')">
                            <!-- do nothing on no match -->
                        </xsl:when>
                        <xsl:when test="contains($subEMarc, 'DEFAULT')">
                            <!-- this means there's a match but multiple domains - we default-->
                            <xsl:copy-of select="uwf:defaultProp(.., $fieldType, $domain, $agentIRI, $agentAP)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="$subEMarc/uwmisc:domain = $domain">
                            <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                                <xsl:choose>
                                    <xsl:when test="$fieldType = '720'">
                                        <xsl:element name="{$ns-wemi || 'd:' || substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:copy-of select="$agentAP"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="{$ns-wemi || 'o:' || substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="$fieldType = 'X11'">
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <xsl:variable name="subJMarc" select="uwf:relatorLookupMarc('subJKeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, $domain)"/>
                        <xsl:choose>
                            <xsl:when test="contains($subJMarc, 'NO MATCH')">
                                <!-- do nothing on no match -->
                            </xsl:when>
                            <xsl:when test="contains($subJMarc, 'DEFAULT')">
                                <!-- this means there's a match but multiple domains - we default-->
                                <xsl:copy-of select="uwf:defaultProp(.., $fieldType, $domain, $agentIRI, $agentAP)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$subJMarc/uwmisc:domain = $domain">
                                    <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="handleInvRelator" expand-text="true">
        <xsl:param name="baseIRI"/>
        <!-- ***** VARIABLES ****** -->
        <!-- IRI generated from field, this is a temporary value for now -->
        <xsl:variable name="agentIRI" select="uwf:agentIRI(.)"/>
        <xsl:variable name="worIRI" select="concat($baseIRI, 'wor')"/>
        <xsl:variable name="expIRI" select="concat($baseIRI, 'exp')"/>
        <xsl:variable name="manIRI" select="concat($baseIRI, 'man')"/>
        <xsl:variable name="iteIRI" select="concat($baseIRI, 'ite', generate-id())"/>
        
        <!-- namespace generated based on domain - this gives us the object namespace -->
        <xsl:variable name="ns-wemi" select="'rdaa'"/>
        
        <!-- fieldType is for lookup - see function uwf:fieldType() -->
        <xsl:variable name="fieldType" select="uwf:fieldType(@tag)"/>
        
        <!-- the indValue is based off field's ind1 to match lookup table - see function uwf:ind1Type()-->
        <xsl:variable name="indValue" select="uwf:ind1Type($fieldType, @ind1)"/>
        
        
        <!-- ****START TEST**** -->
        
        <!-- do ANY of the relators match in ANY domain - see uwf:anyRelatorMatch() function-->
        <xsl:variable name="anyMatch" select="uwf:anyRelatorMatch(., $fieldType, $indValue)"/>
        <xsl:choose>
            <!-- no subfields have a match -->
            <!-- if no $4$e$j match, this needs to be a default value, there's no point doing any further lookup -->
            <xsl:when test="$anyMatch = 'DEFAULT'">
                <xsl:copy-of select="uwf:defaultProp(., $fieldType, 'agent', $manIRI, '')"/>
            </xsl:when>
            
            <!-- otherwise at least one does -->
            <xsl:otherwise>
                <!-- if 4 matches rda iri - multipleDomains doesn't matter -->
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Rda" select="uwf:relatorLookupRDA('sub4KeyRda', uwf:normalizeRelatorTerm(.), $fieldType, $indValue)"/>
                    <xsl:if test="not(contains($sub4Rda, 'NO MATCH'))">
                        <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Rda/uwmisc:invRdaPropIri, string-length($sub4Rda/uwmisc:invRdaPropIri) - 5)}">
                            <xsl:attribute name="rdf:resource">
                                <xsl:choose>
                                    <xsl:when test="$sub4Rda/uwmisc:domain = 'work'">
                                        <xsl:value-of select="$worIRI"/>
                                    </xsl:when>
                                    <xsl:when test="$sub4Rda/uwmisc:domain = 'expression'">
                                        <xsl:value-of select="$expIRI"/>
                                    </xsl:when>
                                    <xsl:when test="$sub4Rda/uwmisc:domain = 'manifestation'">
                                        <xsl:value-of select="$manIRI"/>
                                    </xsl:when>
                                    <xsl:when test="$sub4Rda/uwmisc:domain = 'item'">
                                        <xsl:value-of select="$iteIRI"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
                
                <!-- if X00, X10, or 720 and e matches rda label -->
                <xsl:if test="$fieldType = 'X00' or $fieldType = 'X10'">
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:variable name="subERda" select="uwf:relatorLookupRDA('subEKeyRda', uwf:normalizeRelatorTerm(.), $fieldType, $indValue)"/>
                        <xsl:if test="not(contains($subERda, 'NO MATCH'))">
                            <xsl:element name="{$ns-wemi || 'o:' || substring($subERda/uwmisc:invRdaPropIri, string-length($subERda/uwmisc:invRdaPropIri) - 5)}">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:choose>
                                        <xsl:when test="$subERda/uwmisc:domain = 'work'">
                                            <xsl:value-of select="$worIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subERda/uwmisc:domain = 'expression'">
                                            <xsl:value-of select="$expIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subERda/uwmisc:domain = 'manifestation'">
                                            <xsl:value-of select="$manIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subERda/uwmisc:domain = 'item'">
                                            <xsl:value-of select="$iteIRI"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- if X11 and j matches rda label -->
                <xsl:if test="$fieldType = 'X11'">
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <xsl:variable name="subJRda" select="uwf:relatorLookupRDA('subJKeyRda', uwf:normalizeRelatorTerm(.), 'X00', $indValue)"/>
                        <xsl:if test="not(contains($subJRda, 'NO MATCH'))">
                            <xsl:element name="{$ns-wemi || 'o:' || substring($subJRda/uwmisc:invRdaPropIri, string-length($subJRda/uwmisc:invRdaPropIri) - 5)}">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:choose>
                                        <xsl:when test="$subJRda/uwmisc:domain = 'work'">
                                            <xsl:value-of select="$worIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subJRda/uwmisc:domain = 'expression'">
                                            <xsl:value-of select="$expIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subJRda/uwmisc:domain = 'manifestation'">
                                            <xsl:value-of select="$manIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$subJRda/uwmisc:domain = 'item'">
                                            <xsl:value-of select="$iteIRI"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                
                <!-- if $e$4$j is marc and N multiple domains - match rda iri -->
                <!-- if $e$4$j is marc and Y multiple domains - default  -->
                
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Marc" select="uwf:relatorLookupMarc('sub4KeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, 'manifestation')"/>
                    <xsl:choose>
                        <xsl:when test="contains($sub4Marc, 'NO MATCH')">
                            <!-- do nothing on no match -->
                        </xsl:when>
                        <xsl:when test="contains($sub4Marc, 'DEFAULT')">
                            <!-- this means there's a match but multiple domains - we default-->
                            <xsl:copy-of select="uwf:defaultProp(.., $fieldType, 'agent', $manIRI, '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                            <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Marc/uwmisc:invRdaPropIri, string-length($sub4Marc/uwmisc:invRdaPropIri) - 5)}">
                                <xsl:attribute name="rdf:resource">
                                    <xsl:choose>
                                        <xsl:when test="$sub4Marc/uwmisc:domain = 'work'">
                                            <xsl:value-of select="$worIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$sub4Marc/uwmisc:domain = 'expression'">
                                            <xsl:value-of select="$expIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$sub4Marc/uwmisc:domain = 'manifestation'">
                                            <xsl:value-of select="$manIRI"/>
                                        </xsl:when>
                                        <xsl:when test="$sub4Marc/uwmisc:domain = 'item'">
                                            <xsl:value-of select="$iteIRI"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                
                <xsl:if test="$fieldType = 'X00' or $fieldType = 'X10'">
                    <xsl:for-each select="marc:subfield[@code = 'e']">
                        <xsl:variable name="subEMarc" select="uwf:relatorLookupMarc('subEKeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, 'manifestation')"/>
                        <xsl:choose>
                            <xsl:when test="contains($subEMarc, 'NO MATCH')">
                                <!-- do nothing on no match -->
                            </xsl:when>
                            <xsl:when test="contains($subEMarc, 'DEFAULT')">
                                <!-- this means there's a match but multiple domains - we default-->
                                <xsl:copy-of select="uwf:defaultProp(.., $fieldType, 'agent', $manIRI, '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                                <xsl:element name="{$ns-wemi || 'o:' || substring($subEMarc/uwmisc:invRdaPropIri, string-length($subEMarc/uwmisc:invRdaPropIri) - 5)}">
                                    <xsl:attribute name="rdf:resource">
                                        <xsl:choose>
                                            <xsl:when test="$subEMarc/uwmisc:domain = 'work'">
                                                <xsl:value-of select="$worIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subEMarc/uwmisc:domain = 'expression'">
                                                <xsl:value-of select="$expIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subEMarc/uwmisc:domain = 'manifestation'">
                                                <xsl:value-of select="$manIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subEMarc/uwmisc:domain = 'item'">
                                                <xsl:value-of select="$iteIRI"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
                
                <xsl:if test="$fieldType = 'X11'">
                    <xsl:for-each select="marc:subfield[@code = 'j']">
                        <xsl:variable name="subJMarc" select="uwf:relatorLookupMarc('subJKeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, 'manifestation')"/>
                        <xsl:choose>
                            <xsl:when test="contains($subJMarc, 'NO MATCH')">
                                <!-- do nothing on no match -->
                            </xsl:when>
                            <xsl:when test="contains($subJMarc, 'DEFAULT')">
                                <!-- this means there's a match but multiple domains - we default-->
                                <xsl:copy-of select="uwf:defaultProp(.., $fieldType, 'agent', $manIRI, '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                                <xsl:element name="{$ns-wemi || 'o:' || substring($subJMarc/uwmisc:invRdaPropIri, string-length($subJMarc/uwmisc:invRdaPropIri) - 5)}">
                                    <xsl:attribute name="rdf:resource">
                                        <xsl:choose>
                                            <xsl:when test="$subJMarc/uwmisc:domain = 'work'">
                                                <xsl:value-of select="$worIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subJMarc/uwmisc:domain = 'expression'">
                                                <xsl:value-of select="$expIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subJMarc/uwmisc:domain = 'manifestation'">
                                                <xsl:value-of select="$manIRI"/>
                                            </xsl:when>
                                            <xsl:when test="$subJMarc/uwmisc:domain = 'item'">
                                                <xsl:value-of select="$iteIRI"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:attribute>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="handle1XXNoRelator" expand-text="true">
        <xsl:param name="domain"/>
        <xsl:param name="baseIRI"/>
        <xsl:choose>
            <!-- if 1XX has no relator and there is a 7XX field -->
            <xsl:when test="../marc:datafield[@tag = '700'] or ../marc:datafield[@tag = '710'] or ../marc:datafield[@tag = '711'] or ../marc:datafield[@tag = '720']">
                <!-- copy the 1XX node as variable -->
                <xsl:variable name="copied1XX">
                    <xsl:copy select=".">
                        <xsl:copy-of select="./@*"/>
                        <xsl:copy-of select="./*"/>
                        <!-- add any relator subfields from the 7XX fields that start with 'joint' or 'jt' -->
                        <xsl:for-each select="../marc:datafield[@tag = '700'] | ../marc:datafield[@tag = '710'] | ../marc:datafield[@tag = '711'] | ../marc:datafield[@tag = '720']">
                            <xsl:for-each select="marc:subfield[@code = 'e'] | marc:subfield[@code = '4'] | marc:subfield[@code = 'j']">
                                <xsl:if test="starts-with(., 'joint') or starts-with(., 'jt')">
                                    <marc:subfield code="{@code}">{.}</marc:subfield>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:copy>
                </xsl:variable>
                <xsl:choose>
                    <!-- if there were 'joint' or 'jt' relator subfields added to the copied 1XX,
                         run the copied node through handleRelator template -->
                    <xsl:when test="$copied1XX/marc:datafield/marc:subfield[@code = 'e'] or $copied1XX/marc:datafield/marc:subfield[@code = '4'] or $copied1XX/marc:datafield/marc:subfield[@code = 'j']">
                        <xsl:for-each select="$copied1XX/marc:datafield">
                            <xsl:choose>
                                <xsl:when test="$domain = 'agent'">
                                    <xsl:call-template name="handleInvRelator">
                                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="handleRelator">
                                        <xsl:with-param name="domain" select="$domain"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- 7XXs had no 'joint' or 'jt' subfields -->
                       <xsl:copy-of select="uwf:defaultProp(., uwf:fieldType(@tag), $domain, uwf:agentIRI(.), uwf:agentAccessPoint(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- no 7XX fields -->
                <xsl:copy-of select="uwf:defaultProp(., uwf:fieldType(@tag), $domain, uwf:agentIRI(.), uwf:agentAccessPoint(.))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
