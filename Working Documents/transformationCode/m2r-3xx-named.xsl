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
    xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F336-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdaed:P20001>
                    <xsl:value-of select="."/>
                </rdaed:P20001>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F336-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdaeo:P20001 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaeo:P20001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30002>
                <xsl:value-of select="."/>
            </rdamd:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30002>
                <xsl:value-of select="."/>
            </rdamd:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdamd:P30002>
                    <xsl:value-of select="."/>
                </rdamd:P30002>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdamo:P30002 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdamo:P30002 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30001>
                <xsl:value-of select="."/>
            </rdamd:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30001>
                <xsl:value-of select="."/>
            </rdamd:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdamd:P30001>
                    <xsl:value-of select="."/>
                </rdamd:P30001>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdamo:P30001 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdamo:P30001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
