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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    <xsl:include href="m2r-5xx-named.xsl"/>
    <xsl:variable name="collBase">http://marc2rda.edu/fake/colMan/</xsl:variable>
    <xsl:variable name="lookupDoc" select="document('lookup/$5-preprocessedRDA.xml')"/>
    <xsl:key name="normCode" match="rdf:Description[rdaad:P50006]" use="rdaad:P50006"/>
    <xsl:template
        match="marc:datafield[@tag = '500'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '500']"
        mode="man">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    <xsl:text> (Applies to: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = '3']"/>
                    <xsl:if test="marc:subfield[@code = '5']">
                        <xsl:text> at </xsl:text>
                        <xsl:for-each select="marc:subfield[@code = '5']">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:text>)</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="not(marc:subfield[@code = '3']) and not(marc:subfield[@code = '5'])">
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdamd:P30137>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '500'][marc:subfield[@code = '5']] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '504'][marc:subfield[@code = '5']]"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:if test="not(marc:subfield[@code = '3'])">
            <xsl:for-each select="marc:subfield[@code = '5']">
                <xsl:variable name="genID" select="generate-id()"/>
                <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                    <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                    <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
                    <rdaid:P40028>
                        <xsl:value-of select="../marc:subfield[@code = 'a']"/>
                    </rdaid:P40028>
                    <xsl:variable name="code5" select="."/>
                    <rdaio:P40161
                        rdf:resource="{$collBase}{$lookupDoc/key('normCode',$code5)/rdaad:P50006[@rdf:datatype='http://id.loc.gov/datatypes/orgs/normalized']}"
                    />
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '504'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '504']"
        mode="man">
        <rdamd:P30455>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:value-of
                    select="concat(' Number of references: ', marc:subfield[@code = 'b'], '.')"/>
            </xsl:if>
        </rdamd:P30455>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '522'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '522']"
        mode="wor">
        <rdawd:P10216>
            <xsl:value-of select="concat('Geographic coverage: ', marc:subfield[@code = 'a'])"/>
        </rdawd:P10216>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '561']" mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:variable name="code5" select="marc:subfield[@code = '5']"/>
                <rdaio:P40161
                    rdf:resource="{$collBase}{$lookupDoc/key('normCode',$code5)/rdaad:P50006[@rdf:datatype='http://id.loc.gov/datatypes/orgs/normalized']}"
                />
            </xsl:if>
            <xsl:call-template name="F561-xx-a"/>
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <rdaid:P40026>
                    <xsl:call-template name="F561-xx-u"/>
                </rdaid:P40026>
            </xsl:for-each>
        </rdf:Description>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F561-0x-a">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <xsl:call-template name="F561-0x-u">
                    <xsl:with-param name="baseIRI" select="$baseIRI"/>
                    <xsl:with-param name="genID" select="$genID"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <!-- <xsl:template match="*" mode="wor"/>
    <xsl:template match="*" mode="exp"/>
    <xsl:template match="*" mode="man"/>
    <xsl:template match="*" mode=""></xsl:template>-->
</xsl:stylesheet>
