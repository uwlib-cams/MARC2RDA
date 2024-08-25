<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="marc xs"
                version="3.0">
    <xsl:variable name="patterns">
      <pattern>
          <name>245 Single graphic</name>
          <type>sem</type>
          <xpath>marc:datafield[@tag='245']/marc:subfield[@code='h'][contains(lower-case(.), 'graphic')] and marc:datafield[@tag='300']/marc:subfield[@code='a'][matches(., '^1 ')]</xpath>
      </pattern>
      <pattern>
          <name>008BK Festschrift</name>
          <type>collection</type>
          <xpath>substring(marc:controlfield[@tag='008'], 31, 1) = '1'</xpath>
      </pattern>
      <pattern>
          <name>111 Proceedings</name>
          <type>collection</type>
          <xpath>exists(marc:datafield[@tag='111'])</xpath>
      </pattern>
      <pattern>
          <name>110 Proceedings</name>
          <type>collection</type>
          <xpath>marc:datafield[@tag='110']/marc:subfield[@code='n'] or marc:datafield[@tag='110']/marc:subfield[@code='d'] or marc:datafield[@tag='110']/marc:subfield[@code='c']</xpath>
      </pattern>
      <pattern>
          <name>300 Atlas</name>
          <type>collection</type>
          <xpath>exists(marc:datafield[@tag='300']/marc:subfield[@code='a'][contains(lower-case(.), ' atlas')])</xpath>
      </pattern>
    </xsl:variable>

    <xsl:template name="append-aggregate-manifestations" expand-text="yes">
      <xsl:param name="wemi"/>
      <xsl:variable name="record" select="."/>

      <!--
        the block below is an additional iteration for appending review names in the patterns
        so that we can calculate the number of review names for the patterns presented in the output XML
        it's for development only
      -->
      <xsl:iterate select="$patterns/pattern">
        <xsl:variable name="isMatched" as="xs:boolean">
            <xsl:evaluate xpath="./xpath" context-item="$record"/>
        </xsl:variable>
        <xsl:if test="$isMatched">
          <review-name>
            <xsl:value-of select="./name"/>
          </review-name>
          <xsl:break/>
        </xsl:if>
      </xsl:iterate>

      <xsl:variable name="aggregateType">
        <xsl:iterate select="$patterns/pattern">
          <xsl:variable name="isMatched" as="xs:boolean">
              <xsl:evaluate xpath="./xpath" context-item="$record"/>
          </xsl:variable>
          <xsl:if test="$isMatched">
            <xsl:value-of select="./type"/>
            <xsl:break/>
          </xsl:if>
        </xsl:iterate>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$wemi = 'wor'">
          WOR:<xsl:value-of select="$aggregateType"/>
        </xsl:when>
        <xsl:when test="$wemi = 'exp'">
          EXP:<xsl:value-of select="$aggregateType"/>
        </xsl:when>
        <xsl:when test="$wemi = 'man'">
          MAN:<xsl:value-of select="$aggregateType"/>
        </xsl:when>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
