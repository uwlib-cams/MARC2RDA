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
    xmlns:rdai="http://rdaregistry.info/Elements/i/"
    xmlns:rdaid="http://rdaregistry.info/Elements/i/datatype/"
    xmlns:rdaio="http://rdaregistry.info/Elements/i/object/"
    xmlns:rdaa="http://rdaregistry.info/Elements/a/"
    xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
    xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf"
    version="3.0">
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-relators.xsl"/>
    
    <xsl:variable name="approvedSourcesDoc" select="document('lookup/approvedSources.xml')"/>
    <xsl:key name="approvedKey" match="uwmisc:row" use="uwmisc:approved"/>
    
    <!-- IRILookup takes an input IRI and type (see approvedSources.xml for valid types)
        and checks if it has the same baseIRI as an IRI of the correct type in approvedSources.xml
        if it does, it returns True.
        This is used in the IRI functions to determine whether a $1 value can be used as the 
        Entity IRI or not. -->
    <xsl:function name="uwf:IRILookup" expand-text="yes">
        <xsl:param name="iri"/>
        <xsl:param name="type"/>
        <xsl:value-of select="if (some $value in $approvedSourcesDoc/uwmisc:root/uwmisc:row/key('approvedKey', $type)/uwmisc:baseIRI/@iri
            satisfies (contains($iri, $value))) then 'True' else 'False'"/>
    </xsl:function>
    
    <!-- This returns a list of preferred $1 values based on the approved URIs-->
    <xsl:function name="uwf:multiple1s">
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:for-each select="$field/marc:subfield[@code='1']">
            <xsl:if test="uwf:IRILookup(., $type) = 'True'">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- see if any $0s are fast - this is used for concepts and agents (corporate bodies)
    which are the approved fast usages -->
    <xsl:function name="uwf:multiple0s">
        <xsl:param name="field"/>
        <xsl:for-each select="$field/marc:subfield[@code='0']">
            <xsl:if test="starts-with(., '(OCoLC)')">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- see if any $0s are IRIs - used for concepts -->
    <xsl:function name="uwf:multiple0IRIs">
        <xsl:param name="field"/>
        <xsl:for-each select="$field/marc:subfield[@code='0']">
            <xsl:if test="contains(., 'http')">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- This function removes content in parentheses at the beginning of $0
        from $0 values that contain http (are IRIs) -->
    <xsl:function name="uwf:process0">
        <xsl:param name="code0"/>
        <xsl:if test="contains($code0, 'http')">
            <xsl:choose>
                <xsl:when test="starts-with($code0, 'http')">
                    <xsl:value-of select="$code0"/>
                </xsl:when>
                <xsl:when test="starts-with($code0, '(')">
                    <xsl:value-of select="substring-after($code0, ')')"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    <!-- returns an IRI for an item -->
    
    <xsl:function name="uwf:itemIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="node"/>
        <xsl:value-of select="$baseIRI||'ite#'||generate-id($node)"/>
    </xsl:function>
    
    <!-- returns an IRI for an entity -->
    
    <xsl:function name="uwf:agentIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:variable name="ap">
            <xsl:value-of select="uwf:agentAccessPoint($field)"/>
        </xsl:variable>
        <xsl:variable name="tag" select="uwf:tagType($field)"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="($tag = '100' or $tag = '600' or $tag = '700' or $tag = '800')
                    and $field/@ind1 != '3'">
                    <xsl:value-of select="'Person'"/>
                </xsl:when>
                <xsl:when test="($tag= '100' or $tag = '600' or $tag = '700' or $tag = '800')
                    and $field/@ind1 = '3'">
                    <xsl:value-of select="'Family'"/>
                </xsl:when>
                <xsl:when test="$tag = '110' or $tag = '610' or $tag = '710' or $tag = '810' or
                    $tag = '111' or $tag = '611' or $tag = '711' or $tag = '811'">
                    <xsl:value-of select="'Corporate Body'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- For a 1XX or 7XX, or 6XX with only name part subfields (and no $t) - 
                If $1 -->
            <!-- do not use $1 if it is a 6XX field that has additional subfields -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and (matches($tag, '[17]\d\d')
                or (starts-with($tag, '6')
                and not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'])))
                and not($field/marc:subfield[@code = 't'])">
                <!-- select 1 value to use -->
                <xsl:variable name="sub1">
                    <xsl:choose>
                        <!-- when there are more than 1, call uwf:multiple1s to see if any are approved,
                        then select the first-->
                        <xsl:when test="count($field/marc:subfield[@code = '1']) gt 1">
                            <xsl:value-of select="uwf:multiple1s($field, $type)[1]"/>
                        </xsl:when>
                        <!-- if only 1 subfield 1, select that value -->
                        <xsl:otherwise>
                            <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!-- if that 1 value is approved, use it -->
                    <xsl:when test="uwf:IRILookup($sub1, $type) = 'True'">
                        <xsl:value-of select="$sub1"/>
                    </xsl:when>
                    <!-- otherwise we mint an IRI -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- If it's a 6XX field and not ind2 = 4, and the source is approved,
                                we use the source and aap -->
                            <xsl:when test="starts-with($tag, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), $type) = 'True'">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <!-- same if it's not a 6XX field but there's a 2 -->
                            <xsl:when test="not(starts-with($tag, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], $type) = 'True'">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <!-- otherwise it's an opaque IRI -->
                            <xsl:otherwise>
                                <xsl:value-of select="$baseIRI||'age#'||generate-id($field)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- If $0 and not $1 -->
            <xsl:when test="not($field/marc:subfield[@code = '1']) and $field/marc:subfield[@code = '0']">
                <xsl:variable name="sub0">
                    <xsl:choose>
                        <!-- when there are more than 0, call uwf:multiple0s to see if any are fast
                            (only ones we are currently transforming), then select the first-->
                        <xsl:when test="count($field/marc:subfield[@code = '0']) gt 1">
                            <xsl:value-of select="uwf:multiple0s($field)[1]"/>
                        </xsl:when>
                        <!-- if only 1 subfield 0, select that value -->
                        <xsl:otherwise>
                            <xsl:value-of select="$field/marc:subfield[@code = '0']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!-- and FAST, translate to IRI and use -->
                    <xsl:when test="starts-with($sub0, '(OCoLC)') and uwf:IRILookup(concat('https://id.worldcat.org/fast/', substring-after($sub0, 'fst')), $type) = 'True'">
                        <xsl:value-of select="concat('https://id.worldcat.org/fast/', substring-after($sub0, 'fst'))"/>
                    </xsl:when>
                    <!-- otherwise we mint an IRI -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- If it's a 6XX field and not ind2 = 4, and the source is approved,
                                we use the source and aap -->
                            <xsl:when test="starts-with($tag, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), $type) = 'True'">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <!-- same if it's not a 6XX field but there's a 2 -->
                            <xsl:when test="not(starts-with($tag, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], $type) = 'True'">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <!-- otherwise it's an opaque IRI -->
                            <xsl:otherwise>
                                <xsl:value-of select="$baseIRI||'age#'||generate-id($field)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise it's a minted IRI -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If it's a 6XX field and not ind2 = 4, and the source is approved, we use the source and aap -->
                    <xsl:when test="starts-with($tag, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), $type) = 'True'">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <!-- same if it's not a 6XX field but there's a 2 -->
                    <xsl:when test="not(starts-with($tag, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], $type) = 'True'">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <!-- otherwise it's an opaque IRI -->
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'age#'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:relWorkIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:variable name="tagType" select="uwf:tagType($field)"/>
        <xsl:variable name="ap">
            <xsl:value-of select="uwf:relWorkAccessPoint($field)"/>
        </xsl:variable>
        <xsl:choose>
            <!-- For a 1XX or 7XX or 8XX or 6XX and only name/title subfields - 
                If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and (not(starts-with($tagType, '6'))
                or (starts-with($tagType, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'])))">
                    <xsl:variable name="sub1">
                        <xsl:choose>
                            <!-- when there are more than 1, call uwf:multiple1s to see if any are approved,
                        then select the first-->
                            <xsl:when test="count($field/marc:subfield[@code = '1']) gt 1">
                                <xsl:value-of select="uwf:multiple1s($field, 'Work')[1]"/>
                            </xsl:when>
                            <!-- if only 1 subfield 1, select that value -->
                            <xsl:otherwise>
                                <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <!-- if that 1 value is approved, use it -->
                        <xsl:when test="uwf:IRILookup($sub1, 'Work') = 'True'">
                            <xsl:value-of select="$sub1"/>
                        </xsl:when>
                        <!-- otherwise mint an IRI -->
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="starts-with($tagType, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), 'Work') = 'True'">
                                    <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'wor#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                                </xsl:when>
                                <xsl:when test="not(starts-with($tagType, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], 'Work') = 'True'">
                                    <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'wor#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$baseIRI||'wor#'||generate-id($field)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
            </xsl:when>
            <!-- otherwise it's an opaque IRI to avoid conflating different works under one IRI -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($tagType, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), 'Work') = 'True'">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'wor#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:when test="not(starts-with($tagType, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], 'Work') = 'True'">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'wor#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'wor#'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:metaWorIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="node"/>
        <xsl:value-of select="$baseIRI||'metaWor#'||generate-id($node)"/>
    </xsl:function>
    
    <xsl:function name="uwf:nomenIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:value-of select="$baseIRI||$type||'#'||generate-id($field)"/>
    </xsl:function>
    
    <xsl:function name="uwf:timespanIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:param name="ap"/>
        
        <xsl:choose>
            <xsl:when test="$field/marc:subfield[@code = '1'] and ((starts-with($field/@tag, '6')
                or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '6')))
                and not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:variable name="sub1">
                    <xsl:choose>
                        <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                            <xsl:value-of select="uwf:multiple1s($field, 'Timespan')[1]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="uwf:IRILookup($sub1, 'Timespan') = 'True'">
                        <xsl:value-of select="$sub1"/>
                    </xsl:when>  
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="(starts-with($field/@tag, '6') or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '6')))
                                and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'tim#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <xsl:when test="$field/marc:subfield[@code = '2']">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'tim#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$baseIRI||'tim#'||generate-id($field)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="(starts-with($field/@tag, '6') or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '6')))
                        and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'tim#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:when test="$field/marc:subfield[@code = '2']">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'tim#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'tim#'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:placeIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:param name="ap"/>
        <xsl:param name="source"/>
        <xsl:choose>
            <xsl:when test="$field/marc:subfield[@code = '1'] and ((starts-with($field/@tag, '6') 
                or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '6')))
                and not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:variable name="sub1">
                     <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field, 'Place')[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="uwf:IRILookup($sub1, 'Place') = 'True'">
                        <xsl:value-of select="$sub1"/>
                    </xsl:when>  
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="exists($source) and $source != ''">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($source), ' ', ''))||'/'||'pla#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$baseIRI||'pla#'||generate-id($field)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="exists($source) and $source != ''">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($source), ' ', ''))||'/'||'pla#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'pla#'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- return an IRI for a concept generated from the scheme and the provided value -->
    <xsl:function name="uwf:conceptIRI">
        <xsl:param name="scheme"/>
        <xsl:param name="value"/>
        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:stripAllPunctuation($scheme)), ' ', ''))||'/'||'con#'||encode-for-uri(uwf:stripAllPunctuation($value))"/>
    </xsl:function>

    <xsl:function name="uwf:subjectIRI">
        <xsl:param name="field"/>
        <xsl:param name="scheme"/>
        <xsl:param name="value"/>
        <xsl:choose>
            <!-- If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1']">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="$field/marc:subfield[@code = '1'][1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- If $0 and not $1 -->
            <xsl:when test="not($field/marc:subfield[@code = '1']) and $field/marc:subfield[@code = '0']">
                <xsl:variable name="sub0">
                    <xsl:choose>
                        <xsl:when test="count($field/marc:subfield[@code='0']) gt 1">
                            <xsl:choose>
                                <!-- if there are multipel 0s, see if any are FAST ids -->
                                <xsl:when test="uwf:multiple0s($field)">
                                    <xsl:value-of select="uwf:multiple0s($field)[1]"/>
                                </xsl:when>
                                <!-- then check if there are any IRIs (contain http) -->
                                <xsl:otherwise>
                                    <xsl:value-of select="uwf:multiple0IRIs($field)[1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- else just grab the 0 -->
                        <xsl:otherwise>
                            <xsl:value-of select="$field/marc:subfield[@code='0']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!-- and FAST, translate to IRI and use -->
                    <xsl:when test="starts-with($sub0, '(OCoLC)')">
                        <xsl:value-of select="concat('https://id.worldcat.org/fast/', substring-after($sub0, 'fst'))"/>
                    </xsl:when>
                    <!-- and IRI, use -->
                    <xsl:when test="contains($sub0, 'http')">
                        <xsl:variable name="processed0" select="uwf:process0($sub0)"/>
                        <xsl:choose>
                            <xsl:when test="$processed0">
                                <xsl:value-of select="$processed0"/>
                            </xsl:when>
                            <!-- if IRI can't be retrieved use concept IRI -->
                            <xsl:otherwise>
                                <xsl:value-of select="uwf:conceptIRI($scheme, replace($value, '--', ''))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- otherwise use concept IRI based on scheme and prefLabel -->
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:conceptIRI($scheme, replace($value, '--', ''))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise use concept IRI based on scheme and prefLabel -->
            <xsl:otherwise>
                <xsl:value-of select="uwf:conceptIRI($scheme, replace($value, '--', ''))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- IDENTIFIERS -->
    
    <xsl:function name="uwf:agentIdentifiers">
        <xsl:param name="field"/>
        <xsl:variable name="tag" select="uwf:tagType($field)"/>
        <xsl:choose>
            <xsl:when test="($tag = '100' or $tag = '600' or $tag = '700' or $tag = '800')
                and $field/@ind1 != '3' and not($field/marc:subfield[@code = 't'])">
                <xsl:for-each select="$field/marc:subfield[@code = '0']">
                    <rdaad:P50094>
                        <xsl:value-of select="."/>
                    </rdaad:P50094>
                </xsl:for-each>
                <xsl:for-each select="$field/marc:subfield[@code = '1']">
                    <xsl:if test="uwf:IRILookup(., 'Person') = 'False'">
                        <rdaad:P50094>
                            <xsl:value-of select="."/>
                        </rdaad:P50094>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="($tag = '100' or $tag = '600' or $tag = '700' or $tag = '800')
                and $field/@ind1 = '3' and not($field/marc:subfield[@code = 't'])">
                <xsl:for-each select="$field/marc:subfield[@code = '0']">
                    <rdaad:P50052>
                        <xsl:value-of select="."/>
                    </rdaad:P50052>
                </xsl:for-each>
                <xsl:for-each select="$field/marc:subfield[@code = '1']">
                    <xsl:if test="uwf:IRILookup(., 'Family') = 'False'">
                        <rdaad:P50052>
                            <xsl:value-of select="."/>
                        </rdaad:P50052>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="$tag = '110' or $tag = '610' or $tag = '710' or $tag = '810'
                or $tag = '111' or $tag = '611' or $tag = '711' or $tag = '811'
                and not($field/marc:subfield[@code = 't'])">
                <xsl:for-each select="$field/marc:subfield[@code = '0']">
                    <rdaad:P50006>
                        <xsl:value-of select="."/>
                    </rdaad:P50006>
                </xsl:for-each>
                <xsl:for-each select="$field/marc:subfield[@code = '1']">
                    <xsl:if test="uwf:IRILookup(., 'Corporate Body') = 'False'">
                        <rdaad:P50006>
                            <xsl:value-of select="."/>
                        </rdaad:P50006>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:workIdentifiers">
        <xsl:param name="field"/>
        <xsl:for-each select="$field/marc:subfield[@code = '0']">
            <rdawd:P10002>
                <xsl:value-of select="."/>
            </rdawd:P10002>
        </xsl:for-each>
        <xsl:for-each select="$field/marc:subfield[@code = '1']">
            <xsl:if test="uwf:IRILookup(., 'Work') = 'False'">
                <rdawd:P10002>
                    <xsl:value-of select="."/>
                </rdawd:P10002>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="uwf:timespanIdentifiers">
        <xsl:param name="field"/>
        <xsl:for-each select="$field/marc:subfield[@code = '0']">
            <rdatd:P70018>
                <xsl:value-of select="."/>
            </rdatd:P70018>
        </xsl:for-each>
        <xsl:for-each select="$field/marc:subfield[@code = '1']">
            <xsl:if test="uwf:IRILookup(., 'Timespan') = 'False'">
                <rdatd:P70018>
                    <xsl:value-of select="."/>
                </rdatd:P70018>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
</xsl:stylesheet>