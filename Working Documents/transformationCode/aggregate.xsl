<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="marc xs"
                version="3.0">
    <xsl:variable name="listTextsCCT" select="document('lookup/ListTextsCCT.xml')/items/item"/>
    <xsl:variable name="listAgentE" select="document('lookup/ListAgent$eAggregators.xml')/items/item"/>
    <xsl:variable name="listAgent4" select="document('lookup/ListAgent$4Aggregators.xml')/items/item"/>
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
      <pattern>
        <name>6XX$a Atlases</name>
        <type>collection</type>
        <xpath>exists(marc:datafield[starts-with(@tag, '6')]/marc:subfield[@code='a'][contains(lower-case(.), 'atlases')])</xpath>
      </pattern>
      <pattern>
        <name>6XX$v$x Atlases</name>
        <type>collection</type>
        <xpath>marc:datafield[starts-with(@tag, '6')]/marc:subfield[@code='x'][matches(., '^Atlases\.?$')] or marc:datafield[starts-with(@tag, '6')]/marc:subfield[@code='v'][matches(., '^Atlases\.?$')]</xpath>
      </pattern>
      <pattern>
        <name>130 Radio program</name>
        <type>collection</type>
        <xpath>exists(marc:datafield[@tag='130']/marc:subfield[@code='a'][contains(., '(Radio program)')])</xpath>
      </pattern>
      <pattern>
        <name>130$k Selections</name>
        <type>collection</type>
        <xpath>marc:datafield[@tag='130']/marc:subfield[@code='k'][contains(lower-case(.), 'selections')] and not(substring(marc:leader, 7, 1) = 'c' or substring(marc:leader, 7, 1) = 'd' or substring(marc:leader, 7, 1) = 'j')</xpath>
      </pattern>
      <pattern>
        <name>240$k Selections</name>
        <type>collection</type>
        <!-- <xpath>marc:datafield[@tag='240']/marc:subfield[@code='k'][contains(lower-case(.), 'selections')] and not(substring(marc:leader, 7, 1) = 'c' or substring(marc:leader, 7, 1) = 'd' or substring(marc:leader, 7, 1) = 'j')</xpath> -->
        <xpath>exists(marc:datafield[@tag='240']/marc:subfield[@code='k'][contains(lower-case(.), 'selections')])</xpath>
      </pattern>
      <pattern>
        <name>240 CCT, not music</name>
        <type>collection</type>
        <xpath>some $item in $listTextsCCT satisfies lower-case($item) = lower-case(replace(marc:datafield[@tag='240']/marc:subfield[@code='a'], '[\.,]$', ''))</xpath>
      </pattern>
      <pattern>
        <name>1XX$e Aggregator terms</name>
        <type>collection</type>
        <xpath>some $item in $listAgentE satisfies marc:datafield[starts-with(@tag, '1')]/marc:subfield[@code='e'][contains(lower-case(.), lower-case($item))]</xpath>
      </pattern>
      <pattern>
        <name>1XX$4 Aggregator terms</name>
        <type>collection</type>
        <xpath>some $item in $listAgent4 satisfies marc:datafield[starts-with(@tag, '1')]/marc:subfield[@code='4'][contains(lower-case(.), lower-case($item))]</xpath>
      </pattern>
      <pattern>
        <name>7XX$e Aggregator terms</name>
        <type>collection</type>
        <xpath>some $item in $listAgentE satisfies marc:datafield[starts-with(@tag, '7')]/marc:subfield[@code='e'][contains(lower-case(.), lower-case($item))]</xpath>
      </pattern>
      <pattern>
        <name>7XX$4 Aggregator terms</name>
        <type>collection</type>
        <xpath>some $item in $listAgent4 satisfies marc:datafield[starts-with(@tag, '7')]/marc:subfield[@code='4'][contains(lower-case(.), lower-case($item))]</xpath>
      </pattern>
      <pattern>
        <name>700 Analytical &amp; 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='700']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='700' and @ind2='2']/marc:subfield[@code='t'])
          and exists(marc:datafield[@tag='505']/marc:subfield[@code='r'])
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
      <pattern>
        <name>700 Analytical not 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='700']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='700' and @ind2='2']/marc:subfield[@code='t'])
          and not(exists(marc:datafield[@tag='505']/marc:subfield[@code='r']))
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
      <pattern>
        <name>710 Analytical &amp; 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='710']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='710' and @ind2='2']/marc:subfield[@code='t'])
          and exists(marc:datafield[@tag='505']/marc:subfield[@code='r'])
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
      <pattern>
        <name>710 Analytical not 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='710']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='710' and @ind2='2']/marc:subfield[@code='t'])
          and not(exists(marc:datafield[@tag='505']/marc:subfield[@code='r']))
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
      <pattern>
        <name>711 Analytical &amp; 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='711']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='711' and @ind2='2']/marc:subfield[@code='t'])
          and exists(marc:datafield[@tag='505']/marc:subfield[@code='r'])
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
      <pattern>
        <name>711 Analytical not 505 sor</name>
        <type>collection</type>
        <xpath>
          not(exists(marc:datafield[@tag='711']/marc:subfield[@code='5']))
          and exists(marc:datafield[@tag='711' and @ind2='2']/marc:subfield[@code='t'])
          and not(exists(marc:datafield[@tag='505']/marc:subfield[@code='r']))
          or exists(marc:datafield[@tag='505']/marc:subfield[@code='a'][contains(., ' / ')])
        </xpath>
      </pattern>
    </xsl:variable>

    <xsl:template name="append-aggregates" expand-text="yes">
      <xsl:param name="wemi"/>
      <xsl:variable name="record" select="."/>

      <!--
        the block below is an additional iteration for appending review names in the spreadsheet
        so that we can calculate and compare the number of review names for the patterns presented in the output XML
        it's for development only
      -->
      <xsl:iterate select="$patterns/pattern">
        <xsl:variable name="isMatched" as="xs:boolean">
          <xsl:evaluate xpath="./xpath" context-item="$record">
            <xsl:with-param name="listTextsCCT" select="$listTextsCCT"/>
            <xsl:with-param name="listAgentE" select="$listAgentE"/>
            <xsl:with-param name="listAgent4" select="$listAgent4"/>
          </xsl:evaluate>
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
            <xsl:evaluate xpath="./xpath" context-item="$record">
              <xsl:with-param name="listTextsCCT" select="$listTextsCCT"/>
              <xsl:with-param name="listAgentE" select="$listAgentE"/>
              <xsl:with-param name="listAgent4" select="$listAgent4"/>
            </xsl:evaluate>
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
