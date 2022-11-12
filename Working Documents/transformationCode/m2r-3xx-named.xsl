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
    <xsl:template name="F336-xx-ab0-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code='3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code='3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code='3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code='3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdaed:P20001>
                    <xsl:value-of select="."/>
                </rdaed:P20001>
                <xsl:if test="../marc:subfield[@code='3']">
                    <rdaed:P20071>
                        <xsl:text>Content Type '</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>' applies to a manifestation's </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code='3']"/>
                    </rdaed:P20071>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code='2']">
            <xsl:choose>
                <xsl:when test="contains(marc:subfield[@code='2'],'rda') and not(contains(marc:subfield[@code='0'],'http:')) and not(marc:subfield[@code='1'])">
                    <xsl:comment>Source of rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code='2']"/>': lookup the value of rdaed:P20001 in that source, retrieve the IRI and insert it into the data as the direct value of rdaeo:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when test="not(contains(marc:subfield[@code='2'],'rda')) and not(contains(marc:subfield[@code='0'],'http:')) and not(marc:subfield[@code='1'])">
                    <xsl:comment>Source of the rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code='2']"/>': it may be possible to consult that source to retrieve an IRI for the current value of rdaed:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when test="not(contains(marc:subfield[@code='2'],'rda')) and contains(marc:subfield[@code='0'],'http:') and not(marc:subfield[@code='1'])"><!-- do nothing --></xsl:when>
                <xsl:otherwise>
                    <xsl:comment>$2 source not needed as $2 is rda and the $0 or $1 should be the direct value of P20001</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F336-xx-01-iri">
        <xsl:if test="contains(marc:subfield[@code='2'],'rda')">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <rdaeo:P20001 rdf:resource="{replace(., '^\(uri\)','')}"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="not(contains(marc:subfield[@code='2'],'rda')) or not(marc:subfield[@code='2'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <xsl:comment>MARC data source and field 336 contains a $0 IRI value representing authority data without the presence of a $1; a solution for outputting these in RDA is not yet devised.</xsl:comment>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
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
