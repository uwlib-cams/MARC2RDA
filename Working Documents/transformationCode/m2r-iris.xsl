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
    
    <!-- returns an IRI for an entity -->
    
    <xsl:function name="uwf:agentIRI">
        <xsl:param name="field"/>
        <xsl:choose>
            <!-- For a 1XX or 7XX, If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and not(starts-with($field/@tag, '6'))">
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
            <!-- otherwise it's an opaque IRI to avoid conflating different agents under one IRI -->
            <xsl:otherwise>
                <xsl:value-of select="'http://marc2rda.edu/fake/age/'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xsl:function name="uwf:relWorkIRI">
        <xsl:param name="field"/>
        <xsl:choose>
            <!-- For a 1XX or 7XX, If $1, return value of $1, otherwise construct an IRI based on the access point -->
            <xsl:when test="$field/marc:subfield[@code = '1'] and not(starts-with($field/@tag, '6'))">
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
                <xsl:value-of select="'http://marc2rda.edu/fake/wor/'||generate-id($field)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- This is a placeholder for handling multiple $1 values, it currently returns the first $1 value -->
    <xsl:function name="uwf:multiple1s">
        <xsl:param name="field"/>
        <xsl:value-of select="$field/marc:subfield[@code = '1'][1]"/>
    </xsl:function>
    
    <!-- not done -->
    <xsl:function name="uwf:nomenIRI">
        <xsl:param name="field"/>
        <xsl:param name="type"/>
        <xsl:value-of select="'http://marc2rda.edu/fake/'||$type||'/'||generate-id($field)"/>
    </xsl:function>
    
    <!-- don't forget about subjects - where $1 is not for the timespan but for the whole subject -->
    <xsl:function name="uwf:timespanIRI">
        <xsl:param name="field"/>
        <xsl:value-of select="'http://marc2rda.edu/fake/timespan/'||generate-id($field)"/>
    </xsl:function>
    
    <xsl:function name="uwf:placeIRI">
        <xsl:param name="field"/>
        <xsl:value-of select="'http://marc2rda.edu/fake/place/'||generate-id($field)"/>
    </xsl:function>
    
    <!-- return an IRI for a concept generated from the scheme and the provided value -->
    <xsl:function name="uwf:conceptIRI">
        <xsl:param name="scheme"/>
        <xsl:param name="value"/>
        <xsl:value-of select="'http://marc2rda.edu/fake/concept/'||encode-for-uri(lower-case($scheme))||'/'||encode-for-uri(uwf:stripConceptPunctuation($value))"/>
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
                            <!-- if IRI can't be retrieved, generate opaque -->
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
            <!-- otherwise it's an opaque IRI to avoid conflating different agents under one IRI -->
            <xsl:otherwise>
                <xsl:value-of select="uwf:conceptIRI($scheme, $value)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>