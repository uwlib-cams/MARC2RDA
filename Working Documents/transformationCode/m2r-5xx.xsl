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
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-5xx-named.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:template
        match="marc:datafield[@tag = '500'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '500']"
        mode="man">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '3']">
                <xsl:call-template name="getmarc"/>
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
                <xsl:call-template name="getmarc"/>
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
        <xsl:call-template name="getmarc"/>
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
                    <xsl:copy-of select="uwf:S5lookup(.)"/>
                </rdf:Description>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdawd:P10077>{marc:subfield[@code = 'b']}</rdawd:P10077>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdawd:P10006>{marc:subfield[@code = 'c']}</rdawd:P10006>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'd']">
            <rdawd:P10215>{replace(marc:subfield[@code = 'd'], '\.\s*$', '')}</rdawd:P10215>
        </xsl:if>
        <rdawd:P10209>
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdawd:P10209>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="man" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                <rdand:P80068>{replace(., '\.\s*$', '')}</rdand:P80068>
                <rdano:P80048 rdf:resource="{$baseIRI||'man'}"/>
                <rdand:P80078>Dissertation identifier</rdand:P80078>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '504'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '504']"
        mode="man">
        <xsl:call-template name="getmarc"/>
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
        <xsl:call-template name="getmarc"/>
        <rdawd:P10216>
            <xsl:value-of select="concat('Geographic coverage: ', marc:subfield[@code = 'a'])"/>
        </rdawd:P10216>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '527'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '527']"
        mode="exp">
        <xsl:call-template name="getmarc"/>
        <rdaed:P20071>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdaed:P20071>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '561']" mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <rdaid:P40026>
                <xsl:call-template name="F561-xx-a"/>
            </rdaid:P40026>
            <xsl:if test="marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                    <rdaid:P40026>
                        <xsl:call-template name="F561-xx-a"/>
                    </rdaid:P40026>
                </xsl:for-each>
            </xsl:if>
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
            <xsl:if test="marc:subfield[@code = '6']">
                <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                    <xsl:call-template name="F561-0x-a">
                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                        <xsl:with-param name="genID" select="generate-id()"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <xsl:call-template name="F561-0x-u">
                    <xsl:with-param name="baseIRI" select="$baseIRI"/>
                    <xsl:with-param name="genID" select="$genID"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <!-- 583 - Action Note -->
    <xsl:template match="marc:datafield[@tag = '583']" mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
            <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40028>
                    <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
                </rdaid:P40028>
            </xsl:if>
        </rdf:Description>
        <xsl:if test="@ind1 != '0'">
            <xsl:call-template name="F583-xx-x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F583-0x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '585'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '585']"
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="not(marc:subfield[@code = '5'])">
            <rdamd:P30137>
                <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                <xsl:if test="marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '585']" mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                    </xsl:if>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                            <xsl:if test="marc:subfield[@code = '3']">
                                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                            </xsl:if>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    <!-- <xsl:template match="*" mode="wor"/>
        <xsl:template match="*" mode="exp"/>
        <xsl:template match="*" mode="man"/>
        <xsl:template match="*" mode=""></xsl:template>-->
</xsl:stylesheet>
