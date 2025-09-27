<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:m2r="http://marc2rda.info/functions#"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:function name="m2r:isValid">
        <xsl:param name="record"/>
        <xsl:choose>
            <!-- multiple 1XX -->
            <xsl:when test="count($record/marc:datafield[@tag='100' or @tag='110' or @tag='111']) gt 1">
                <xsl:value-of select="'multiple 1XX fields'"/>
            </xsl:when>
            <!-- multiple 245 -->
            <xsl:when test="count($record/marc:datafield[@tag='245']) gt 1">
                <xsl:value-of select="'multiple 245 fields'"/>
            </xsl:when>
            <!-- repeated non-repeatables in Personal Name -->
            <xsl:when test="$record/marc:datafield[@tag='100']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='b']) gt 1
                or count(marc:subfield[@code='d']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 100'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='600']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='b']) gt 1
                or count(marc:subfield[@code='d']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 600'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='700']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='b']) gt 1
                or count(marc:subfield[@code='d']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 700'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='800']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='b']) gt 1
                or count(marc:subfield[@code='d']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='v']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 800'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='110']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 110'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='610']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 610'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='710']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 710'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='810']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='v']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 810'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='111']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 111'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='611']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 611'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='711']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 711'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='811']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='q']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='u']) gt 1
                or count(marc:subfield[@code='v']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 811'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='130']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 130'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='630']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 630'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='730']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 730'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='830']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1
                or count(marc:subfield[@code='t']) gt 1
                or count(marc:subfield[@code='v']) gt 1
                or count(marc:subfield[@code='x']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 830'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag='240']
                [count(marc:subfield[@code='a']) gt 1
                or count(marc:subfield[@code='f']) gt 1
                or count(marc:subfield[@code='h']) gt 1
                or count(marc:subfield[@code='l']) gt 1
                or count(marc:subfield[@code='o']) gt 1
                or count(marc:subfield[@code='r']) gt 1]">
                <xsl:value-of select="'non-repeatable subfield repeated in field 240'"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[count(marc:subfield[@code='6']) gt 1]">
                <xsl:value-of select="'subfield 6 repeated within one field'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'True'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>