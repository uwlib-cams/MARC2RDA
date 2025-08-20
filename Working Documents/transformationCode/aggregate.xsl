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
    <xsl:variable name="List245aCollectionTerms" select="document('lookup/List245aCollectionTerms.xml')/items/item"/>
    <xsl:variable name="List245bCollectionTerms" select="document('lookup/List245bCollectionTerms.xml')/items/item"/>
    <xsl:variable name="List245cCollectionTerms" select="document('lookup/List245cCollectionTerms.xml')/items/item"/>
    <xsl:variable name="List520aCollectionTerms" select="document('lookup/List520aCollectionTerms.xml')/items/item"/>
    <xsl:variable name="ListVAgentEAggregators" select="document('lookup/ListVAgentEAggregators.xml')/items/item"/>
    <xsl:variable name="ListVAgent4Aggregators" select="document('lookup/ListVAgent4Aggregators.xml')/items/item"/>
    <xsl:variable name="ListVTextsCCT" select="document('lookup/ListVTextsCCT.xml')/items/item"/>
    <xsl:variable name="List245cAggregators" select="document('lookup/List245cAggregators.xml')/items/item"/>
    <xsl:variable name="ListV650a_655aCollectionTerms" select="document('lookup/ListV650a_655aCollectionTerms.xml')/items/item"/>
    <xsl:variable name="ListV650a_655aCollectionTermsUsually" select="document('lookup/ListV650a_655aCollectionTermsUsually.xml')/items/item"/>
    <xsl:variable name="ListV650v655vCollectionTermsUsually" select="document('lookup/ListV650v655vCollectionTermsUsually.xml')/items/item"/>
    <xsl:variable name="ListV650v655vCollectionTerms" select="document('lookup/ListV650v655vCollectionTerms.xml')/items/item"/>
    <xsl:variable name="List245cIntroductionTerms" select="document('lookup/List245cIntroductionTerms.xml')/items/item"/>
    <xsl:variable name="List300aSuppCont" select="document('lookup/List300aSuppCont.xml')/items/item"/>
    <xsl:variable name="List300bSuppCont" select="document('lookup/List300bSuppCont.xml')/items/item"/>
    <xsl:variable name="ListInvertedEtcTerms" select="document('lookup/ListInvertedEtcTerms.xml')/items/item"/>
    <xsl:variable name="List546aNotParallelTerms" select="document('lookup/List546aNotParallelTerms.xml')/items/item"/>
    <xsl:variable name="List500_520ParallelOnlyTerms_CaseNo" select="document('lookup/List500_520ParallelOnlyTerms_CaseNo.xml')/items/item"/>
    <xsl:variable name="List500_520_546aParallelPlusTerms_CaseNo" select="document('lookup/List500_520_546aParallelPlusTerms_CaseNo.xml')/items/item"/>
    <xsl:variable name="List110b245aConferenceTerms" select="document('lookup/List110b245aConferenceTerms.xml')/items/item"/>
    <xsl:variable name="ListVMusicCCT_MLA_Type_Plural" select="document('lookup/ListVMusicCCT_MLA_Type_Plural.xml')/items/item"/>
    <xsl:variable name="ListVMusicCCT_MLA_Medium" select="document('lookup/ListVMusicCCT_MLA_Medium.xml')/items/item"/>

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
                    <xsl:with-param name="List245aCollectionTerms" select="$List245aCollectionTerms"/>
                    <xsl:with-param name="List245bCollectionTerms" select="$List245bCollectionTerms"/>
                    <xsl:with-param name="List245cCollectionTerms" select="$List245cCollectionTerms"/>
                    <xsl:with-param name="List520aCollectionTerms" select="$List520aCollectionTerms"/>
                    <xsl:with-param name="ListVAgentEAggregators" select="$ListVAgentEAggregators"/>
                    <xsl:with-param name="ListVAgent4Aggregators" select="$ListVAgent4Aggregators"/>
                    <xsl:with-param name="ListVTextsCCT" select="$ListVTextsCCT"/>
                    <xsl:with-param name="List245cAggregators" select="$List245cAggregators"/>
                    <xsl:with-param name="ListV650a_655aCollectionTerms" select="$ListV650a_655aCollectionTerms"/>
                    <xsl:with-param name="ListV650a_655aCollectionTermsUsually" select="$ListV650a_655aCollectionTermsUsually"/>
                    <xsl:with-param name="ListV650v655vCollectionTermsUsually" select="$ListV650v655vCollectionTermsUsually"/>
                    <xsl:with-param name="ListV650v655vCollectionTerms" select="$ListV650v655vCollectionTerms"/>
                    <xsl:with-param name="List245cIntroductionTerms" select="$List245cIntroductionTerms"/>
                    <xsl:with-param name="List300aSuppCont" select="$List300aSuppCont"/>
                    <xsl:with-param name="List300bSuppCont" select="$List300bSuppCont"/>
                    <xsl:with-param name="ListInvertedEtcTerms" select="$ListInvertedEtcTerms"/>
                    <xsl:with-param name="List546aNotParallelTerms" select="$List546aNotParallelTerms"/>
                    <xsl:with-param name="List500_520ParallelOnlyTerms_CaseNo" select="$List500_520ParallelOnlyTerms_CaseNo"/>
                    <xsl:with-param name="List500_520_546aParallelPlusTerms_CaseNo" select="$List500_520_546aParallelPlusTerms_CaseNo"/>
                    <xsl:with-param name="List110b245aConferenceTerms" select="$List110b245aConferenceTerms"/>
                    <xsl:with-param name="ListVMusicCCT_MLA_Type_Plural" select="$ListVMusicCCT_MLA_Type_Plural"/>
                    <xsl:with-param name="ListVMusicCCT_MLA_Medium" select="$ListVMusicCCT_MLA_Medium"/>
                </xsl:evaluate>
            </xsl:variable>
            <xsl:if test="$isMatched">

                <!-- Can edit this to output more information -->
                <matched-record> 
                    <review-name>
                        <xsl:value-of select="./name"/>
                    </review-name>
                    
                    <control-number>
                        <xsl:value-of select="$record/marc:datafield[@tag='010']/marc:subfield[@code='a']"/>
                    </control-number>

                    <!--
                    <subfield>
                        <xsl:value-of select="$record/marc:datafield[@tag='700']"/>
                    </subfield>
                    <subfield>
                        <xsl:value-of select="$record/marc:datafield[@tag='710']"/>
                    </subfield>
                    -->
                </matched-record> 

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
                        <xsl:with-param name="List245aCollectionTerms" select="$List245aCollectionTerms"/>
                        <xsl:with-param name="List245bCollectionTerms" select="$List245bCollectionTerms"/>
                        <xsl:with-param name="List245cCollectionTerms" select="$List245cCollectionTerms"/>
                        <xsl:with-param name="List520aCollectionTerms" select="$List520aCollectionTerms"/>
                        <xsl:with-param name="ListVAgentEAggregators" select="$ListVAgentEAggregators"/>
                        <xsl:with-param name="ListVAgent4Aggregators" select="$ListVAgent4Aggregators"/>
                        <xsl:with-param name="ListVTextsCCT" select="$ListVTextsCCT"/>
                        <xsl:with-param name="List245cAggregators" select="$List245cAggregators"/>
                        <xsl:with-param name="ListV650a_655aCollectionTerms" select="$ListV650a_655aCollectionTerms"/>
                        <xsl:with-param name="ListV650a_655aCollectionTermsUsually" select="$ListV650a_655aCollectionTermsUsually"/>
                        <xsl:with-param name="ListV650v655vCollectionTermsUsually" select="$ListV650v655vCollectionTermsUsually"/>
                        <xsl:with-param name="ListV650v655vCollectionTerms" select="$ListV650v655vCollectionTerms"/>
                        <xsl:with-param name="List245cIntroductionTerms" select="$List245cIntroductionTerms"/>
                        <xsl:with-param name="List300aSuppCont" select="$List300aSuppCont"/>
                        <xsl:with-param name="List300bSuppCont" select="$List300bSuppCont"/>
                        <xsl:with-param name="ListInvertedEtcTerms" select="$ListInvertedEtcTerms"/>
                        <xsl:with-param name="List546aNotParallelTerms" select="$List546aNotParallelTerms"/>
                        <xsl:with-param name="List500_520ParallelOnlyTerms_CaseNo" select="$List500_520ParallelOnlyTerms_CaseNo"/>
                        <xsl:with-param name="List500_520_546aParallelPlusTerms_CaseNo" select="$List500_520_546aParallelPlusTerms_CaseNo"/>
                        <xsl:with-param name="List110b245aConferenceTerms" select="$List110b245aConferenceTerms"/>
                        <xsl:with-param name="ListVMusicCCT_MLA_Type_Plural" select="$ListVMusicCCT_MLA_Type_Plural"/>
                        <xsl:with-param name="ListVMusicCCT_MLA_Medium" select="$ListVMusicCCT_MLA_Medium"/>
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
                <xsl:value-of select="'SEM'"/>
            </xsl:on-completion>
            <xsl:variable name="isMatched" as="xs:boolean">
                <xsl:evaluate xpath="./xpath" context-item="$record">
                    <xsl:with-param name="listTextsCCT" select="$listTextsCCT"/>
                    <xsl:with-param name="listAgentE" select="$listAgentE"/>
                    <xsl:with-param name="listAgent4" select="$listAgent4"/>
                    <xsl:with-param name="listMusicCCT_MLA_Type_Plural" select="$listMusicCCT_MLA_Type_Plural"/>
                    <xsl:with-param name="listMusicCCT_MLA_Medium" select="$listMusicCCT_MLA_Medium"/>
                    <xsl:with-param name="List245aCollectionTerms" select="$List245aCollectionTerms"/>
                    <xsl:with-param name="List245bCollectionTerms" select="$List245bCollectionTerms"/>
                    <xsl:with-param name="List245cCollectionTerms" select="$List245cCollectionTerms"/>
                    <xsl:with-param name="List520aCollectionTerms" select="$List520aCollectionTerms"/>
                    <xsl:with-param name="ListVAgentEAggregators" select="$ListVAgentEAggregators"/>
                    <xsl:with-param name="ListVAgent4Aggregators" select="$ListVAgent4Aggregators"/>
                    <xsl:with-param name="ListVTextsCCT" select="$ListVTextsCCT"/>
                    <xsl:with-param name="List245cAggregators" select="$List245cAggregators"/>
                    <xsl:with-param name="ListV650a_655aCollectionTerms" select="$ListV650a_655aCollectionTerms"/>
                    <xsl:with-param name="ListV650a_655aCollectionTermsUsually" select="$ListV650a_655aCollectionTermsUsually"/>
                    <xsl:with-param name="ListV650v655vCollectionTermsUsually" select="$ListV650v655vCollectionTermsUsually"/>
                    <xsl:with-param name="ListV650v655vCollectionTerms" select="$ListV650v655vCollectionTerms"/>
                    <xsl:with-param name="List245cIntroductionTerms" select="$List245cIntroductionTerms"/>
                    <xsl:with-param name="List300aSuppCont" select="$List300aSuppCont"/>
                    <xsl:with-param name="List300bSuppCont" select="$List300bSuppCont"/>
                    <xsl:with-param name="ListInvertedEtcTerms" select="$ListInvertedEtcTerms"/>
                    <xsl:with-param name="List546aNotParallelTerms" select="$List546aNotParallelTerms"/>
                    <xsl:with-param name="List500_520ParallelOnlyTerms_CaseNo" select="$List500_520ParallelOnlyTerms_CaseNo"/>
                    <xsl:with-param name="List500_520_546aParallelPlusTerms_CaseNo" select="$List500_520_546aParallelPlusTerms_CaseNo"/>
                    <xsl:with-param name="List110b245aConferenceTerms" select="$List110b245aConferenceTerms"/>
                    <xsl:with-param name="ListVMusicCCT_MLA_Type_Plural" select="$ListVMusicCCT_MLA_Type_Plural"/>
                    <xsl:with-param name="ListVMusicCCT_MLA_Medium" select="$ListVMusicCCT_MLA_Medium"/>
                </xsl:evaluate>
            </xsl:variable>
            <xsl:if test="$isMatched">
                <xsl:value-of select="./type"/>
                <xsl:break/>
            </xsl:if>
        </xsl:iterate>
    </xsl:function>
    
</xsl:stylesheet>
