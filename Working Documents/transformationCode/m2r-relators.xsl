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
                <xsl:value-of select="translate($subfield, ',.', '') => normalize-space()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- takes in the field number and returns the field type for lookup in relator table -->
    <!-- either 'X00', 'X10', or 'X11' -->
    <xsl:function name="uwf:fieldType">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="($field/@tag = '100') or ($field/@tag = '600') or ($field/@tag = '700')
                or ($field/@tag = '880' and matches(substring($field/marc:subfield[@code = '6'], 1, 3), '[167]00'))">
                <xsl:value-of select="'X00'"/>
            </xsl:when>
            <xsl:when test="($field/@tag = '110') or ($field/@tag = '610') or ($field/@tag = '710')
                or ($field/@tag = '880' and matches(substring($field/marc:subfield[@code = '6'], 1, 3), '[167]10'))" >
                <xsl:value-of select="'X10'"/>
            </xsl:when>
            <xsl:when test="($field/@tag = '111') or ($field/@tag = '611') or ($field/@tag = '711')
                or ($field/@tag = '880' and matches(substring($field/marc:subfield[@code = '6'], 1, 3), '[167]11'))" >
                <xsl:value-of select="'X11'"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- otherwise it's 720 -->
                <xsl:value-of select="$field/@tag"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:tagType">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '100' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '100'))">
                <xsl:value-of select="'100'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '110' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '110'))">
                <xsl:value-of select="'110'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '111' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '111'))">
                <xsl:value-of select="'111'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '600' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '600'))">
                <xsl:value-of select="'600'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '610' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '610'))">
                <xsl:value-of select="'610'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '611' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '611'))">
                <xsl:value-of select="'611'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '700' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '700'))">
                <xsl:value-of select="'700'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '710' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '710'))">
                <xsl:value-of select="'710'"/>
            </xsl:when>  
            <xsl:when test="$field/@tag = '711' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '711'))">
                <xsl:value-of select="'711'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '800' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '800'))">
                <xsl:value-of select="'800'"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '810' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '810'))">
                <xsl:value-of select="'810'"/>
            </xsl:when>  
            <xsl:when test="$field/@tag = '811' or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '811'))">
                <xsl:value-of select="'811'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$field/@tag"/>
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
    
    
    <xsl:function name="uwf:defaultAgentProp">
        <xsl:param name="recordType"/>
        <xsl:param name="field"/>
        <xsl:param name="fieldType"/>
        <xsl:param name="domain"/>
        <xsl:param name="objIRI"/>
        <xsl:param name="objString"/>
        <xsl:variable name="tag" select="uwf:tagType($field)"/>
        <xsl:choose>
            <xsl:when test="$domain = 'work'">
                <xsl:choose>
                    <xsl:when test="starts-with($tag, '1')">
                        <!-- 1XX -->
                        <xsl:choose>
                            <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                <!-- person -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdawo:P10312'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                <!-- family -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdawo:P10313'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                <!-- corporate body -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdawo:P10314'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$domain = 'manifestation'">
                <xsl:choose>
                    <!-- 1XX - only maps to manifestation for aggregates -->
                    <xsl:when test="starts-with($tag, '1')">
                        <xsl:if test="$recordType = 'agg'">
                            <xsl:choose>
                                <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                    <!-- person -->
                                    <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                    <xsl:element name="{'rdamo:P30336'}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                    <!-- family -->
                                    <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                    <xsl:element name="{'rdamo:P30423'}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                    <!-- corporate body -->
                                    <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                    <xsl:element name="{'rdamo:P30394'}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="starts-with($tag, '7') and not($field/marc:subfield[@code = '5'])">
                        <xsl:choose>
                            <xsl:when test="$recordType = 'agg'">
                                <xsl:choose>
                                    <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                        <!-- person -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                        <xsl:element name="{'rdamo:P30336'}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                        <!-- family -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                        <xsl:element name="{'rdamo:P30423'}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                        <!-- corporate body -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                        <xsl:element name="{'rdamo:P30394'}">
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
                                </xsl:choose>
                            </xsl:when>
                            <!-- 7XX single work expression -->
                            <xsl:otherwise>
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
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$domain = 'item'">
                <xsl:choose>
                    <xsl:when test="starts-with($tag, '7') and $field/marc:subfield[@code = '5']">
                        <!-- 7XX -->
                        <xsl:choose>
                            <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                <!-- person -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaio:P40073'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                <!-- family -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaio:P40074'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                <!-- corporate body -->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaio:P40075'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = '720'">
                                <xsl:choose>
                                    <xsl:when test="$field/@ind = '1'">
                                        <!-- person -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objString"/></xsl:comment>
                                        <xsl:element name="{'rdaid:P40073'}">
                                            <xsl:copy-of select="$objString"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- agent -->
                                        <xsl:comment>Default relationship property used for <xsl:value-of select="$objString"/></xsl:comment>
                                        <xsl:element name="{'rdamd:P40072'}">
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
            <!-- inverse property -->
            <!--            <xsl:when test="$domain = 'agent'">
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '1') or starts-with($field/@tag, '7')">
                        <!-\- 1XX and 7XX -\->
                        <xsl:choose>
                            <xsl:when test="($fieldType = 'X00' and  ($field/@ind1 = '0' or $field/@ind1 = '1' or $field/@ind1 = '2'))">
                                <!-\- person -\->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50313'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X00' and $field/@ind1 = '3'">
                                <!-\- family -\->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50322'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:when test="$fieldType = 'X10' or $fieldType = 'X11'">
                                <!-\- corporate body -\->
                                <xsl:comment>Default relationship property used for <xsl:value-of select="$objIRI"/></xsl:comment>
                                <xsl:element name="{'rdaao:P50331'}">
                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$objIRI"/></xsl:attribute>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>-->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    
   
<!-- **TEMPLATES** -->
    
    <!-- handleRelator template sets the appropriate variables for lookup in the relator table
         and outputs the property returned from the lookup -->
    
    <xsl:template name="handleRelator" expand-text="true">
    
        <!-- domain from field template mode -->
        <xsl:param name="domain"/>
        <!-- IRI generated from field, this is a temporary value for now -->
        <xsl:param name="agentIRI"/>
        <!-- type is agg when aggregating work is being processed, aug for augmented work, blank for single work -->
        <!-- also agg for manifestation when record is for an augmentation aggregate -->
        <xsl:param name="type"/>
        
        <!-- ***** VARIABLES ****** -->
        
        <!-- Access point -->
        <xsl:variable name="agentAP" select="uwf:agentAccessPoint(.)"/>
        
        <!-- namespace generated based on domain - this gives us the object namespace -->
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
        <xsl:variable name="fieldType" select="uwf:fieldType(.)"/>
        
        <!-- the indValue is based off field's ind1 to match lookup table - see function uwf:ind1Type()-->
        <xsl:variable name="indValue" select="uwf:ind1Type($fieldType, @ind1)"/>
        
        
    <!-- ****START TEST**** -->
        
        <!-- do ANY of the relators match in ANY domain - see uwf:anyRelatorMatch() function-->
        <xsl:variable name="anyMatch" select="uwf:anyRelatorMatch(., $fieldType, $indValue)"/>
        <xsl:choose>
            <!-- no subfields have a match -->
            <!-- if no $4$e$j match, this needs to be a default value, there's no point doing any further lookup -->
            <xsl:when test="$anyMatch = 'DEFAULT'">
                <xsl:copy-of select="uwf:defaultAgentProp($type, ., $fieldType, $domain, $agentIRI, $agentAP)"/>
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
                                <xsl:choose>
                                    <xsl:when test="$type = 'agg' and $domain = 'work'">
                                        <xsl:variable name="prop" select="substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)"/>
                                        <xsl:choose>
                                            <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585|P10055|P10444|P10538|P10585')">
                                                <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)}">
                                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="$type = 'aug' and $domain = 'work'">
                                        <xsl:variable name="prop" select="substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)"/>
                                        <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                            <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)}">
                                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Rda/uwmisc:rdaPropIri, string-length($sub4Rda/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
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
                                    <xsl:choose>
                                        <xsl:when test="$type = 'agg' and $domain = 'work'">
                                            <xsl:text>HERE</xsl:text>
                                            <xsl:variable name="prop" select="substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)"/>
                                            <xsl:choose>
                                                <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585')">
                                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)}">
                                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>HELP</xsl:text>
                                                    <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>    
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="$type = 'aug' and $domain = 'work'">
                                            <xsl:variable name="prop" select="substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)"/>
                                            <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                                <xsl:element name="{$ns-wemi || 'o:' || substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)}">
                                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="{$ns-wemi || 'o:' || substring($subERda/uwmisc:rdaPropIri, string-length($subERda/uwmisc:rdaPropIri) - 5)}">
                                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
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
                            <xsl:choose>
                                <xsl:when test="$type = 'agg' and $domain = 'work'">
                                    <xsl:variable name="prop" select="substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)"/>
                                    <xsl:choose>
                                        <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585')">
                                            <xsl:element name="{$ns-wemi || 'o:' || substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)}">
                                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$type = 'aug' and $domain = 'work'">
                                    <xsl:variable name="prop" select="substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)"/>
                                    <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                        <xsl:element name="{$ns-wemi || 'o:' || substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)}">
                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subJRda/uwmisc:rdaPropIri, string-length($subJRda/uwmisc:rdaPropIri) - 5)}">
                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                    </xsl:element>
                                </xsl:otherwise>
                            </xsl:choose>
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
                            <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
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
                                        <xsl:choose>
                                            <xsl:when test="$type = 'agg' and $domain = 'work'">
                                                <xsl:variable name="prop" select="substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)"/>
                                                <xsl:choose>
                                                    <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585')">
                                                        <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)}">
                                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="$type = 'aug' and $domain = 'work'">
                                                <xsl:variable name="prop" select="substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)"/>
                                                <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                                    <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)}">
                                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="{$ns-wemi || 'o:' || substring($sub4Marc/uwmisc:rdaPropIri, string-length($sub4Marc/uwmisc:rdaPropIri) - 5)}">
                                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
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
                            <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
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
                                        <xsl:choose>
                                            <xsl:when test="$type = 'agg' and $domain = 'work'">
                                                <xsl:variable name="prop" select="substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)"/>
                                                <xsl:choose>
                                                    <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585')">
                                                        <xsl:element name="{$ns-wemi || 'o:' || substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)}">
                                                            <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                        </xsl:element>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:when test="$type = 'aug' and $domain = 'work'">
                                                <xsl:variable name="prop" select="substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)"/>
                                                <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)}">
                                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:element name="{$ns-wemi || 'o:' || substring($subEMarc/uwmisc:rdaPropIri, string-length($subEMarc/uwmisc:rdaPropIri) - 5)}">
                                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:otherwise>
                                        </xsl:choose>
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
                                <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$subJMarc/uwmisc:domain = $domain">
                                    <!-- there was a match and not multiple domains, use given RDA prop IRI from table -->
                                    <xsl:choose>
                                        <xsl:when test="$type = 'agg' and $domain = 'work'">
                                            <xsl:variable name="prop" select="substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)"/>
                                            <xsl:choose>
                                                <xsl:when test="matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585')">
                                                    <xsl:element name="{$ns-wemi || 'o:' || substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)}">
                                                        <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                    </xsl:element>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:copy-of select="uwf:defaultAgentProp($type, .., $fieldType, $domain, $agentIRI, $agentAP)"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="$type = 'aug' and $domain = 'work'">
                                            <xsl:variable name="prop" select="substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)"/>
                                            <xsl:if test="not(matches($prop, 'P10448|P10589|P10542|P10393|P10055|P10444|P10538|P10585'))">
                                                <xsl:element name="{$ns-wemi || 'o:' || substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)}">
                                                    <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:element name="{$ns-wemi || 'o:' || substring($subJMarc/uwmisc:rdaPropIri, string-length($subJMarc/uwmisc:rdaPropIri) - 5)}">
                                                <xsl:attribute name="rdf:resource"><xsl:value-of select="$agentIRI"/></xsl:attribute>
                                            </xsl:element>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- NOT IN USE - used for inverse relationship from agent to WEMI -->
    <!--<xsl:template name="handleInvRelator" expand-text="true">
        <xsl:param name="baseIRI"/>
        <xsl:param name="agentIRI"/>
        <!-\- ***** VARIABLES ****** -\->
        <!-\- IRI generated from field, this is a temporary value for now -\->
        <xsl:variable name="worIRI" select="concat($baseIRI, 'wor')"/>
        <xsl:variable name="expIRI" select="concat($baseIRI, 'exp')"/>
        <xsl:variable name="manIRI" select="concat($baseIRI, 'man')"/>
        <xsl:variable name="iteIRI" select="concat($baseIRI, 'ite', generate-id())"/>
        
        <!-\- namespace generated based on domain - this gives us the object namespace -\->
        <xsl:variable name="ns-wemi" select="'rdaa'"/>
        
        <!-\- fieldType is for lookup - see function uwf:fieldType() -\->
        <xsl:variable name="fieldType" select="uwf:fieldType(.)"/>
        
        <!-\- the indValue is based off field's ind1 to match lookup table - see function uwf:ind1Type()-\->
        <xsl:variable name="indValue" select="uwf:ind1Type($fieldType, @ind1)"/>
        
        
        <!-\- ****START TEST**** -\->
        
        <!-\- do ANY of the relators match in ANY domain - see uwf:anyRelatorMatch() function-\->
        <xsl:variable name="anyMatch" select="uwf:anyRelatorMatch(., $fieldType, $indValue)"/>
        <xsl:choose>
            <!-\- no subfields have a match -\->
            <!-\- if no $4$e$j match, this needs to be a default value, there's no point doing any further lookup -\->
            <xsl:when test="$anyMatch = 'DEFAULT'">
                <xsl:copy-of select="uwf:defaultAgentProp(., $fieldType, 'agent', $manIRI, '')"/>
            </xsl:when>
            
            <!-\- otherwise at least one does -\->
            <xsl:otherwise>
                <!-\- if 4 matches rda iri - multipleDomains doesn't matter -\->
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
                
                <!-\- if X00, X10, or 720 and e matches rda label -\->
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
                
                <!-\- if X11 and j matches rda label -\->
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
                
                <!-\- if $e$4$j is marc and N multiple domains - match rda iri -\->
                <!-\- if $e$4$j is marc and Y multiple domains - default  -\->
                
                <xsl:for-each select="marc:subfield[@code = '4']">
                    <xsl:variable name="sub4Marc" select="uwf:relatorLookupMarc('sub4KeyMarc', uwf:normalizeRelatorTerm(.), $fieldType, $indValue, 'manifestation')"/>
                    <xsl:choose>
                        <xsl:when test="contains($sub4Marc, 'NO MATCH')">
                            <!-\- do nothing on no match -\->
                        </xsl:when>
                        <xsl:when test="contains($sub4Marc, 'DEFAULT')">
                            <!-\- this means there's a match but multiple domains - we default-\->
                            <xsl:copy-of select="uwf:defaultAgentProp(.., $fieldType, 'agent', $manIRI, '')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-\- there was a match and not multiple domains, use given RDA prop IRI from table -\->
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
                                <!-\- do nothing on no match -\->
                            </xsl:when>
                            <xsl:when test="contains($subEMarc, 'DEFAULT')">
                                <!-\- this means there's a match but multiple domains - we default-\->
                                <xsl:copy-of select="uwf:defaultAgentProp(.., $fieldType, 'agent', $manIRI, '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-\- there was a match and not multiple domains, use given RDA prop IRI from table -\->
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
                                <!-\- do nothing on no match -\->
                            </xsl:when>
                            <xsl:when test="contains($subJMarc, 'DEFAULT')">
                                <!-\- this means there's a match but multiple domains - we default-\->
                                <xsl:copy-of select="uwf:defaultAgentProp(.., $fieldType, 'agent', $manIRI, '')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-\- there was a match and not multiple domains, use given RDA prop IRI from table -\->
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
    </xsl:template>-->
    
    <xsl:template name="handle1XXNoRelator" expand-text="true">
        <xsl:param name="domain"/>
        <xsl:param name="agentIRI"/>
        <xsl:param name="type"/>
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
                            <xsl:call-template name="handleRelator">
                                <xsl:with-param name="domain" select="$domain"/>
                                <xsl:with-param name="agentIRI" select="$agentIRI"/>
                                <xsl:with-param name="type" select="$type"/>
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- 7XXs had no 'joint' or 'jt' subfields -->
                       <xsl:copy-of select="uwf:defaultAgentProp($type, ., uwf:fieldType(.), $domain, $agentIRI, uwf:agentAccessPoint(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- no 7XX fields -->
                <xsl:copy-of select="uwf:defaultAgentProp($type, ., uwf:fieldType(.), $domain, $agentIRI, uwf:agentAccessPoint(.))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Attributes -->
    
    <xsl:template name="FX00-0x-a">
        <xsl:if test="@ind1 = '0' and (marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b']))">
            <xsl:variable name="nameOfPerson">
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </xsl:variable>
            <rdaad:P50111>
                <xsl:value-of select="uwf:stripEndPunctuation($nameOfPerson)"/>
            </rdaad:P50111>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="FX00-0x-ab">
        <xsl:if test="@ind1 = '0' and (marc:subfield[@code = 'a'] and marc:subfield[@code = 'b'])">
            <xsl:variable name="nameOfPerson">
                <xsl:value-of select="concat(marc:subfield[@code = 'a'], ' ', marc:subfield[@code = 'b'])"/>
            </xsl:variable>
            <rdaad:P50111>
                <xsl:value-of select="uwf:stripEndPunctuation($nameOfPerson)"/>
            </rdaad:P50111>
        </xsl:if>
    </xsl:template>

    <xsl:template name="FX00-1x-a">
            <xsl:if test="@ind1 = '1' and marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b'])">
                <xsl:variable name="nameOfPerson" select="marc:subfield[@code = 'a']"/>
                <rdaad:P50111>
                    <xsl:value-of select="uwf:stripEndPunctuation($nameOfPerson)"/>
                </rdaad:P50111>
            </xsl:if>
        </xsl:template>
    
    <xsl:template name="FX00-2x-a">
        <xsl:if test="@ind1 = '2' and marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b'])">
            <xsl:variable name="nameOfPerson">
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </xsl:variable>
            <rdaad:P50111>
                <xsl:value-of select="uwf:stripEndPunctuation($nameOfPerson)"/>
            </rdaad:P50111>
        </xsl:if>
    </xsl:template>

      
    <xsl:template name="FX00-3x-a">
        <xsl:if test="@ind1 = '3' and (marc:subfield[@code = 'a'])">
            <xsl:variable name="nameOfFamily">
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </xsl:variable>
            <rdaad:P50061>
                <xsl:value-of select="uwf:stripEndPunctuation($nameOfFamily)"/>
            </rdaad:P50061>
        </xsl:if>
    </xsl:template>
    
  
   
    <xsl:template name="FX00-3x-c">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdaad:P50059>
                <xsl:value-of select="marc:subfield[@code = 'c']"/>
            </rdaad:P50059>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FX10-xx-ab">
        <xsl:variable name="nameOfCorporateBody">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']"/>
        </xsl:variable>
        <rdaad:P50032>
            <xsl:value-of select="uwf:stripEndPunctuation($nameOfCorporateBody)"/>
        </rdaad:P50032>     
    </xsl:template>
    
    <xsl:template name="FX11-xx-ae">
        <xsl:variable name="nameOfCorporateBody">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'e']"/>
        </xsl:variable>
        <rdaad:P50032>
            <xsl:value-of select="uwf:stripEndPunctuation($nameOfCorporateBody)"/>
        </rdaad:P50032>
    </xsl:template>
    
    <xsl:template name="FX1X-xx-c">
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdaad:P50024>
                <xsl:value-of select="normalize-space(translate(., '():', ''))"/>
            </rdaad:P50024>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FX00-xx-d">
        <xsl:for-each select="marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code = 't'])]">
            <xsl:choose>
                <xsl:when test="contains(., '-') and not(contains(., 'active') or contains(., 'fl.') or contains(., 'jin shi') or contains(., 'ju ren'))">
                    <xsl:if test="matches(normalize-space(.), '^.+-')">
                        <rdaad:P50121>
                            <xsl:value-of select="normalize-space(substring-before(., '-'))"/>
                        </rdaad:P50121>
                    </xsl:if>
                    <xsl:if test="not(ends-with(normalize-space(.), '-'))">
                        <rdaad:P50120>
                            <xsl:value-of select="replace(normalize-space(substring-after(., '-')),  '\.$', '') => uwf:stripEndPunctuation()"/>
                        </rdaad:P50120>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(normalize-space(.), 'b.')">
                            <rdaad:P50121>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'b.')),  '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50121>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'born')">
                            <rdaad:P50121>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'born')),  '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50121>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'd.')">
                            <rdaad:P50120>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'd.')),  '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50120>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'died')">
                            <rdaad:P50120>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'died')),  '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50120>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'active')">
                            <rdaad:P50098>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'active')), '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50098>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'jin shi')">
                            <rdaad:P50098>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'jin shi')), '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50098>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'ju ren')">
                            <rdaad:P50098>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'ju ren')), '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50098>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'fl.')">
                            <rdaad:P50098>
                                <xsl:value-of select="replace(normalize-space(substring-after(., 'fl.')), '\.$', '') => uwf:stripEndPunctuation()"/>
                            </rdaad:P50098>
                        </xsl:when>
                        <xsl:when test="contains(normalize-space(.), 'cent.') or contains(normalize-space(.), 'century')">
                            <rdaad:P50098>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </rdaad:P50098>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdaad:P50347>
                                <xsl:value-of select="."/>
                            </rdaad:P50347>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FX00-3x-d">
        <xsl:for-each select="marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code = 't'])]">
            <rdaad:P50355>
                <xsl:value-of select="."/>
            </rdaad:P50355>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FX1X-xx-d">
        <xsl:for-each select="marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code = 't'])]">
            <rdaad:P50039>
                <xsl:value-of select="normalize-space(translate(., '():', ''))"/>
            </rdaad:P50039>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FX00-xx-q">
        <xsl:for-each select="marc:subfield[@code = 'q']">
            <rdaad:P50115>
                <xsl:value-of select="normalize-space(.) => replace('^\(', '') => replace('\)[\.,]*$', '')"/>
            </rdaad:P50115>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="FX00-xx-u"><!-- X00 person and family $u affiliation -->
        <xsl:if test="marc:subfield[@code = 'u']">
            <xsl:variable name="name" select="marc:subfield[@code = 'u']"/>
            <xsl:choose>
                <xsl:when test="@ind2 = '3'">
                    <rdaad:P50394>
                        <xsl:text>Affiliation or address: </xsl:text>
                        <xsl:value-of select="uwf:stripEndPunctuation($name)"/>
                    </rdaad:P50394>
                </xsl:when>
                <xsl:otherwise>
                    <rdaad:P50395>
                        <xsl:text>Affiliation or address: </xsl:text>
                        <xsl:value-of select="uwf:stripEndPunctuation($name)"/>
                    </rdaad:P50395>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="FX1X-xx-u"><!-- corporate body $u affiliation for X11 and X10 -->
        <xsl:if test="marc:subfield[@code = 'u']">
            <xsl:variable name="nameOfCorporateBody" select="marc:subfield[@code = 'u']"/>
            <rdaad:P50393>
                <xsl:text>Affiliation or address: </xsl:text>
                <xsl:value-of select="uwf:stripEndPunctuation($nameOfCorporateBody)"/>
            </rdaad:P50393>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="FX1X-xx-n">
        <xsl:for-each select="marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code = 't'])]">
            <rdaad:P50019>
                <xsl:value-of select="."/>
            </rdaad:P50019>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Work attributes -->
    
    <xsl:template name="FX30-xx-anp">
        <xsl:variable name="title">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p']"/>
        </xsl:variable>
        <rdawd:P10088>
            <xsl:value-of select="uwf:stripEndPunctuation($title)"/>
        </rdawd:P10088>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-tnp">
        <xsl:if test="marc:subfield[@code = 't'] or marc:subfield[@code = 'n'] or marc:subfield[@code = 'p']">
            <xsl:variable name="title">
                <xsl:value-of select="marc:subfield[@code = 't'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p']"/>
            </xsl:variable>
            <rdawd:P10088>
                <xsl:value-of select="uwf:stripEndPunctuation($title)"/>
            </rdawd:P10088>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="FX30-xx-d">
        <xsl:for-each select="marc:subfield[@code = 'd']">
            <rdawd:P10219>
                <xsl:value-of select="."/>
            </rdawd:P10219>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-d">
        <xsl:for-each select="marc:subfield[@code = 'd']">
            <xsl:if test="preceding-sibling::marc:subfield[@code = 't']">
                <rdawd:P10219>
                    <xsl:value-of select="."/>
                </rdawd:P10219>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-l-wor">
        <xsl:for-each select="marc:subfield[@code = 'l']">
            <rdawd:P10353>
                <xsl:value-of select="."/>
            </rdawd:P10353>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-m-wor">
        <xsl:for-each select="marc:subfield[@code = 'm']">
            <rdawd:P10220>
                <xsl:value-of select="."/>
            </rdawd:P10220>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-n">
        <xsl:for-each select="marc:subfield[@code = 'n']">
            <xsl:if test="contains(., 'op.') or contains(., 'opp.')">
                <rdawd:P10333>
                    <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                </rdawd:P10333>
            </xsl:if>
            <xsl:if test="matches(., '\([12]\d\d\d\)')">
                <rdawd:P10219>
                    <xsl:value-of select="translate(., '()', '')"/>
                </rdawd:P10219>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-x">
        <xsl:for-each select="marc:subfield[@code = 'x']">
            <rdawd:P10366>
                <xsl:value-of select="."/>
            </rdawd:P10366>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="FXXX-xx-r">
        <xsl:for-each select="marc:subfield[@code = 'r']">
            <rdawd:P10221>
                <xsl:value-of select="."/>
            </rdawd:P10221>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 130/240 expression attribute templates -->
    
    <xsl:template name="F130F240-xx-f-exp">
        <xsl:for-each select="marc:subfield[@code = 'f']">
            <xsl:if test="not(matches(., '\([1-2][0-9][0-9][0-9]\)'))">
                <rdaed:P20214>
                    <xsl:value-of select="."/>
                </rdaed:P20214>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F130F240-xx-l-exp">
        <xsl:for-each select="marc:subfield[@code = 'l']">
            <rdaed:P20006>
                <xsl:value-of select="."/>
            </rdaed:P20006>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F130F240-xx-m-exp">
        <xsl:for-each select="marc:subfield[@code = 'm']">
            <rdaed:P20215>
                <xsl:value-of select="."/>
            </rdaed:P20215>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F130F240-xx-o-exp">
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <xsl:if test="matches(lower-case(normalize-space(.)), 'arr.') or matches(lower-case(normalize-space(.)), 'arranged')">
                <rdaed:P20331>
                    <xsl:text>Arrangement</xsl:text>
                </rdaed:P20331>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    
    <xsl:template name="F130F240-xx-r-exp">
        <xsl:for-each select="marc:subfield[@code = 'r']">
            <rdaed:P20326>
                <xsl:value-of select="."/>
            </rdaed:P20326>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F130F240-xx-s-exp">
        <xsl:for-each select="marc:subfield[@code = 's']">
            <rdaed:P20572>
                <xsl:value-of select="."/>
            </rdaed:P20572>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
