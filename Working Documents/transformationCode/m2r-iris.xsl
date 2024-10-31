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
        <xsl:param name="field"/>
        <xsl:variable name="ap">
            <xsl:value-of select="uwf:agentAccessPoint($field)"/>
        </xsl:variable>
        <xsl:choose>
            <!-- For a 1XX or 7XX, or 6XX with only name part subfields (and no $t) - 
                If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and (not(starts-with($field/@tag, '6'))
                or (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'])))
                and not($field/marc:subfield[@code = 't'])">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- not handling $0s yet -->
            <!-- otherwise it's a minted IRI -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- If it's a 6XX field and not ind2 = 4, we use the source and aap -->
                    <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4')">
                        <xsl:value-of select="$BASE||'age/'||translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <!-- same if it's not a 6XX field but there's a 2 -->
                    <xsl:when test="not(starts-with($field/@tag, '6')) and $field/marc:subfield[@code = '2']">
                        <xsl:value-of select="$BASE||'age/'||translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <!-- otherwise it's an opaque IRI -->
                    <xsl:otherwise>
                        <xsl:value-of select="$BASE||'age/'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:relWorkIRI">
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
                        <xsl:value-of select="uwf:multiple1s($field)"/>
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
                        <xsl:value-of select="$BASE||'wor/'||translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <xsl:when test="not(starts-with($field/@tag, '6')) and $field/marc:subfield[@code = '2']">
                        <xsl:value-of select="$BASE||'wor/'||translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$BASE||'wor/'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:metaWorIRI">
        <xsl:param name="node"/>
        <xsl:value-of select="$BASE||'metaWor/'||generate-id($node)"/>
    </xsl:function>
    
    <!-- This is a placeholder for handling multiple $1 values, it currently returns the first $1 value.
         In the future it will return the preferred $1 value -->
    <xsl:function name="uwf:multiple1s">
        <xsl:param name="field"/>
        <xsl:value-of select="$field/marc:subfield[@code = '1'][1]"/>
    </xsl:function>
    
    <!-- not done -->
    <xsl:function name="uwf:nomenIRI">
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:param name="ap"/>
        <xsl:param name="source"/>
        <xsl:choose>
            <xsl:when test="$source != ''">
                <xsl:value-of select="$BASE||$type||'/'||translate(lower-case($source), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$BASE||$type||'/'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:timespanIRI">
        <xsl:param name="field"/>
        <xsl:param name="ap"/>
        <xsl:choose>
            <xsl:when test="$field/marc:subfield[@code = '1'] and (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                        <xsl:value-of select="$BASE||'timespan/'||translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <xsl:when test="$field/marc:subfield[@code = '2']">
                        <xsl:value-of select="$BASE||'timespan/'||translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$BASE||'timespan/'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:yTimespanIRI">
        <xsl:param name="field"/>
        <xsl:param name="node"/>
        <xsl:param name="ap"/>
        <xsl:choose>
            <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                <xsl:value-of select="$BASE||'timespan/'||translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/marc:subfield[@code = '2']">
                <xsl:value-of select="$BASE||'timespan/'||translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$BASE||'timespan/'||generate-id($node)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:placeIRI">
        <xsl:param name="field"/>
        <xsl:param name="ap"/>
        <xsl:param name="source"/>
        <xsl:choose>
            <xsl:when test="$field/marc:subfield[@code = '1'] and (starts-with($field/@tag, '6') and 
                not($field/marc:subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']))">
                <xsl:choose>
                    <xsl:when test="count($field/marc:subfield[@code = '1']) > 1">
                        <xsl:value-of select="uwf:multiple1s($field)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$field/marc:subfield[@code = '1']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="exists($source) and $source != ''">
                        <xsl:value-of select="$BASE||'place/'||translate(lower-case($source), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$BASE||'place/'||generate-id($field)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:zPlaceIRI">
        <xsl:param name="field"/>
        <xsl:param name="node"/>
        <xsl:param name="ap"/>
        <xsl:choose>
            <xsl:when test="starts-with($field/@tag, '6') and not($field/@ind2 = '4' or $field/@ind2 = ' ' or $field/@ind2 = '7')">
                <xsl:value-of select="$BASE||'place/'||translate(lower-case(uwf:getSubjectSchemeCode($field)), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/marc:subfield[@code = '2']">
                <xsl:value-of select="$BASE||'place/'||translate(lower-case($field/marc:subfield[@code = '2'][1]), ' ', '')||'/'||uwf:stripAllPunctuation($ap)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$BASE||'place/'||generate-id($node)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- return an IRI for a concept generated from the scheme and the provided value -->
    <xsl:function name="uwf:conceptIRI">
        <xsl:param name="scheme"/>
        <xsl:param name="value"/>
        <xsl:value-of select="$BASE||'concept/'||translate(lower-case(uwf:stripAllPunctuation($scheme)), ' ', '')||'/'||uwf:stripAllPunctuation($value)"/>
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
                        <xsl:value-of select="uwf:multiple1s($field)"/>
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
                        <xsl:value-of select="uwf:conceptIRI($scheme, $value)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise use concept IRI based on scheme and prefLabel -->
            <xsl:otherwise>
                <xsl:value-of select="uwf:conceptIRI($scheme, $value)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>