<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:marc="http://www.loc.gov/MARC21/slim" 
    xmlns:uwf="http://universityOfWashington/functions" exclude-result-prefixes="marc xs" version="3.0">
    <xsl:variable name="listTextsCCT" select="document('lookup/ListTextsCCT.xml')/items/item"/>
    <xsl:variable name="listAgentE" select="document('lookup/ListAgent$eAggregators.xml')/items/item"/>
    <xsl:variable name="listAgent4" select="document('lookup/ListAgent$4Aggregators.xml')/items/item"/>
    <xsl:variable name="listMusicCCT_MLA_Type_Plural" select="document('lookup/ListMusicCCT-MLA_Type_Plural.xml')/items/item"/>
    <xsl:variable name="listMusicCCT_MLA_Medium" select="document('lookup/ListMusicCCT-MLA_Medium.xml')/items/item"/>
    <xsl:variable name="patterns" select="document('lookup/aggregatePatterns.xml')/patterns/pattern" />

    <xsl:template name="append-aggregates" expand-text="yes">
        <xsl:param name="wemi"/>
        <xsl:variable name="record" select="."/>

        <!--
        the block below is an additional iteration for appending review names in the spreadsheet
        so that we can calculate and compare the number of review names for the patterns presented in the output XML
        it's for development only
      -->
        <xsl:iterate select="$patterns">
            <xsl:variable name="isMatched" as="xs:boolean">
                <xsl:evaluate xpath="./xpath" context-item="$record">
                    <xsl:with-param name="listTextsCCT" select="$listTextsCCT"/>
                    <xsl:with-param name="listAgentE" select="$listAgentE"/>
                    <xsl:with-param name="listAgent4" select="$listAgent4"/>
                    <xsl:with-param name="listMusicCCT_MLA_Type_Plural" select="$listMusicCCT_MLA_Type_Plural"/>
                    <xsl:with-param name="listMusicCCT_MLA_Medium" select="$listMusicCCT_MLA_Medium"/>
                </xsl:evaluate>
            </xsl:variable>
            <xsl:if test="$isMatched">
                <matched-record>
                    <!-- Review Name -->
                    <xsl:value-of select="./name"/>
                    <!-- LCCN -->
                    <control-number>
                        <xsl:value-of select="$record/marc:datafield[@tag='010']/marc:subfield[@code='a']"/>
                    </control-number>
                </matched-record>
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
                        <xsl:with-param name="listMusicCCT_MLA_Type_Plural" select="$listMusicCCT_MLA_Type_Plural"/>
                        <xsl:with-param name="listMusicCCT_MLA_Medium" select="$listMusicCCT_MLA_Medium"/>
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
    
    <!-- function used in m2r.xsl -->
    <!-- returns true() if there is a match and false() if not -->
    <!-- if the xsl:iterate is updated (such as the params), this will need updating too -->
    <xsl:function name="uwf:checkAggregates" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:iterate select="$patterns">
            <xsl:on-completion>
                <xsl:value-of select="false()"/>
            </xsl:on-completion>
            <xsl:variable name="isMatched" as="xs:boolean">
                <xsl:evaluate xpath="./xpath" context-item="$record">
                    <xsl:with-param name="listTextsCCT" select="$listTextsCCT"/>
                    <xsl:with-param name="listAgentE" select="$listAgentE"/>
                    <xsl:with-param name="listAgent4" select="$listAgent4"/>
                    <xsl:with-param name="listMusicCCT_MLA_Type_Plural" select="$listMusicCCT_MLA_Type_Plural"/>
                    <xsl:with-param name="listMusicCCT_MLA_Medium" select="$listMusicCCT_MLA_Medium"/>
                </xsl:evaluate>
            </xsl:variable>
            <xsl:if test="$isMatched">
                <xsl:value-of select="true()"/>
                <xsl:break/>
            </xsl:if>
        </xsl:iterate>
    </xsl:function>
    
</xsl:stylesheet>
