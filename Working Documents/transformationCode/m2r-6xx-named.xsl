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
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
    version="3.0">
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    
    <xsl:template name="F6XX-xyz-label" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']">
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:text>{.} </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="F600-label" expand-text="yes">
        <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'j'] | marc:subfield[@code = 'q'] | marc:subfield[@code = 'u']
            | marc:subfield[@code = 't'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h']
            | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n']
            | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 'r'] | marc:subfield[@code = 's']
            | marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator=" "/>
    </xsl:template>
    
    <xsl:template name="F630-label" expand-text="yes">
        <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'f']
            | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l']
            | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
            | marc:subfield[@code = 'r'] | marc:subfield[@code = 's'] | marc:subfield[@code = 't'] | marc:subfield[@code = 'v']
            | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator=" "/>
    </xsl:template>
    
    <xsl:template name="F6XX-subject">
        <xsl:param name="prefLabel"/>
        <xsl:choose>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10256>
                    <xsl:value-of select="$prefLabel"/>
                </rdawd:P10256>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10256 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F6XX-xx-xyz">
        <xsl:variable name="prefLabelXYZ">
            <xsl:call-template name="F6XX-xyz-label"/>
        </xsl:variable>
            <xsl:choose>
                <xsl:when test="@ind2 = '4'">
                    <rdawd:P10256>
                        <xsl:value-of select="$prefLabelXYZ"/>
                    </rdawd:P10256>
                </xsl:when>
                <xsl:otherwise>
                    <rdaw:P10256 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}"/>
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F6XX-xx-v">
        <xsl:choose>
            <xsl:when test="@ind2 = '4'">
                <rdawd:P10004>
                    <xsl:value-of select="."/>
                </rdawd:P10004>
            </xsl:when>
            <xsl:otherwise>
                <rdaw:P10004 rdf:resource="{uwf:subjectIRI(., uwf:getSubjectSchemeCode(parent::node()), .)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F6XX-concept">
        <xsl:param name="prefLabel"/>
        <xsl:if test="starts-with(uwf:subjectIRI(., uwf:getSubjectSchemeCode(.), $prefLabel), 'http://marc2rda.edu')">
            <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabel)}">
                <xsl:copy-of select="uwf:fillConcept($prefLabel, uwf:getSubjectSchemeCode(.), '', '600')"/>
            </rdf:Description>
            <xsl:if test="marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:variable name="prefLabelXYZ">
                    <xsl:call-template name="F6XX-xyz-label"/>
                </xsl:variable>
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(.), $prefLabelXYZ)}">
                    <xsl:copy-of select="uwf:fillConcept($prefLabelXYZ, uwf:getSubjectSchemeCode(.), '', '600')"/>
                </rdf:Description>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'v']">
                <rdf:Description rdf:about="{uwf:conceptIRI(uwf:getSubjectSchemeCode(parent::node()), .)}">
                    <xsl:copy-of select="uwf:fillConcept(., uwf:getSubjectSchemeCode(parent::node()), '', '600')"/>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
