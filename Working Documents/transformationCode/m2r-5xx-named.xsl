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
    <xsl:template name="F561-xx-a">
        <rdaid:P40026>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text> (Applies to: </xsl:text>
                <xsl:value-of select="marc:subfield[@code = '3']"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </rdaid:P40026>
        <xsl:if test="marc:subfield[@code = '6']">
            <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                <rdaid:P40026>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdaid:P40026>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F561-0x-a" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/',$genID,'1')}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/',$genID,'1')}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:call-template name="F561-xx-a"/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    <xsl:template name="F561-xx-u">
        <xsl:value-of select="."/>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F561-0x-u" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description
            rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/',$genID,position()+1)}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/',$genID,position()+1)}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:call-template name="F561-xx-u"/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
