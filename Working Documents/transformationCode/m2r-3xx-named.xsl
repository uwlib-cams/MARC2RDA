<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F336-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdae:P20001>
                <xsl:value-of select="."/>
            </rdae:P20001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdae:P20001>
                <xsl:value-of select="."/>
            </rdae:P20001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdae:P20001>
                    <xsl:value-of select="."/>
                </rdae:P20001>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F336-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdae:P20001 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdae:P20001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdae:P30002>
                <xsl:value-of select="."/>
            </rdae:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdae:P30002>
                <xsl:value-of select="."/>
            </rdae:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdae:P30002>
                    <xsl:value-of select="."/>
                </rdae:P30002>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdae:P30002 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdae:P30002 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdae:P30001>
                <xsl:value-of select="."/>
            </rdae:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdae:P30001>
                <xsl:value-of select="."/>
            </rdae:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdae:P30001>
                    <xsl:value-of select="."/>
                </rdae:P30001>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdae:P30001 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdae:P30001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
