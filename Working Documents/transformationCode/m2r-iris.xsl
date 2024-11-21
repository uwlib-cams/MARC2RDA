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
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf"
    version="3.0">
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-relators.xsl"/>
    
    <!-- returns an IRI for an entity -->
    
    <xsl:function name="uwf:agentIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:variable name="ap">
            <xsl:value-of select="uwf:agentAccessPoint($field)"/>
        </xsl:variable>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="($field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field = '800')
                    and $field/@ind1 != '3'">
                    <xsl:value-of select="'Person'"/>
                </xsl:when>
                <xsl:when test="($field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field = '800')
                    and $field/@ind1 = '3'">
                    <xsl:value-of select="'Family'"/>
                </xsl:when>
                <xsl:when test="$field/@tag = '110' or $field/@tag = '610' or $field/@tag = '710' or $field = '810' or
                    $field/@tag = '111' or $field/@tag = '611' or $field/@tag = '711' or $field = '811'">
                    <xsl:value-of select="'Corporate Body'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- For a 1XX or 7XX, or 6XX with only name part subfields (and no $t) - 
                If $1 -->
            <!-- do not use $1 if it is a 6XX field that has additional subfields -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and (not(starts-with($field/@tag, '6'))
                or (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'])))
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
                            <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), $type) = 'True'">
                                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                            </xsl:when>
                            <!-- same if it's not a 6XX field but there's a 2 -->
                            <xsl:when test="not(starts-with($field/@tag, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], $type) = 'True'">
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
            <!-- not handling $0s yet -->
            <!-- otherwise it's a minted IRI -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If it's a 6XX field and not ind2 = 4, and the source is approved,
                                we use the source and aap -->
                    <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4') and uwf:s2EntityTest(uwf:getSubjectSchemeCode($field), $type) = 'True'">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'age#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <!-- same if it's not a 6XX field but there's a 2 -->
                    <xsl:when test="not(starts-with($field/@tag, '6')) and $field/marc:subfield[@code = '2'] and uwf:s2EntityTest($field/marc:subfield[@code = '2'][1], $type) = 'True'">
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
        <xsl:variable name="ap">
            <xsl:value-of select="uwf:relWorkAccessPoint($field)"/>
        </xsl:variable>
        <xsl:choose>
            <!-- For a 1XX or 7XX or 6XX and only name/title subfields - 
                If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and (not(starts-with($field/@tag, '6'))
                or (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'])))">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field, 'Work')[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- not handling $0s yet -->
            <!-- otherwise it's an opaque IRI to avoid conflating different works under one IRI -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4')">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'wor#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:when test="not(starts-with($field/@tag, '6')) and $field/marc:subfield[@code = '2']">
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
    
    <!-- This is a placeholder for handling multiple $1 values, it currently returns the first $1 value.
         In the future it will return the preferred $1 value -->
    <xsl:function name="uwf:multiple1s">
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:for-each select="$field/marc:subfield[@code='1']">
            <xsl:if test="uwf:IRILookup(., $type) = 'True'">
                <xsl:copy-of select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <!-- not done -->
    <xsl:function name="uwf:nomenIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:param name="ap"/>
        <xsl:param name="source"/>
        <xsl:choose>
            <xsl:when test="$source != ''">
                <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($source), ' ', ''))||'/'||$type||'#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$baseIRI||$type||'#'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:timespanIRI">
        <xsl:param name="baseIRI"/>
        <xsl:param name="field"/>
        <xsl:param name="ap"/>
        <xsl:choose>
            <xsl:when test="$field/marc:subfield[@code = '1'] and (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field, 'Timespan')[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', ''))||'/'||'timespan#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:when test="$field/marc:subfield[@code = '2']">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', ''))||'/'||'timespan#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'timespan#'||generate-id($field)"/>
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
            <xsl:when test="$field/marc:subfield[@code = '1'] and (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field, 'Place')[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="exists($source) and $source != ''">
                        <xsl:value-of select="$BASE||encode-for-uri(translate(lower-case($source), ' ', ''))||'/'||'place#'||encode-for-uri(uwf:stripAllPunctuation($ap))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$baseIRI||'place#'||generate-id($field)"/>
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
            <!-- If $0 -->
            <xsl:when test="not($field/marc:subfield[@code = '1']) and count($field/marc:subfield[@code = '0']) = 1">
                <xsl:choose>
                    <!-- and IRI, use -->
                    <xsl:when test="contains($field/marc:subfield[@code = '0'], 'http')">
                        <xsl:variable name="processed0" select="uwf:process0($field/marc:subfield[@code = '0'])"/>
                        <xsl:choose>
                            <xsl:when test="$processed0">
                                <xsl:value-of select="$processed0"/>
                            </xsl:when>
                            <!-- if IRI can't be retrieved use concept IRI -->
                            <xsl:otherwise>
                                <xsl:value-of select="uwf:conceptIRI($scheme, $value)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <!-- and FAST, translate to IRI and use -->
                    <xsl:when test="starts-with($field/marc:subfield[@code = '0'], '(OCoLC)')">
                        <xsl:value-of select="concat('https://id.worldcat.org/fast/', substring-after($field/marc:subfield[@code = '0'], 'fst'))"/>
                    </xsl:when>
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
    
    <xsl:variable name="approvedSourcesDoc" select="document('lookup/approvedSources.xml')"/>
    <xsl:key name="approvedKey" match="uwmisc:row" use="uwmisc:approved"/>
    
    <xsl:function name="uwf:IRILookup" expand-text="yes">
        <xsl:param name="iri"/>
        <xsl:param name="type"/>
        <xsl:value-of select="if (some $value in $approvedSourcesDoc/uwmisc:root/uwmisc:row/key('approvedKey', $type)/uwmisc:baseIRI/@iri
            satisfies (contains($iri, $value))) then 'True' else 'False'"/>
    </xsl:function>
    
    <xsl:function name="uwf:agentIdentifiers">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="($field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800')
                and $field/@ind1 != '3'">
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
            <xsl:when test="($field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800')
                and $field/@ind1 = '3'">
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
            <xsl:when test="$field/@tag = '110' or $field/@tag = '610' or $field/@tag = '710' or $field/@tag = '810'
                or $field/@tag = '111' or $field/@tag = '611' or $field/@tag = '711' or $field/@tag = '811'">
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
    
</xsl:stylesheet>