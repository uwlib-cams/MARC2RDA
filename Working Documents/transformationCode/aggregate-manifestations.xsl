<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="marc"
                version="3.0">

    <!-- Template to identify different types of aggregate manifestations -->
    <xsl:template name="identify-collection-aggregate">
        <xsl:variable name="isCollectionAggregate" as="xs:boolean">
          <xsl:sequence select="
            marc:datafield[@tag='245']/marc:subfield[@code='h'][translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'graphic']
            and marc:datafield[@tag='300']/marc:subfield[@code='a'][matches(., '^1 ')]
            and substring(marc:controlfield[@tag='008'], 31, 1) = '1'
            and exists(marc:datafield[@tag='111'])
            and (
                marc:datafield[@tag='110'][contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'tn') 
                or contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'td') 
                or contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'tc')]
            )
            and translate(marc:datafield[@tag='300']/marc:subfield[@code='a'], 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'atlas'
            and (
                translate(marc:controlfield[@tag='000']/substring(., 7, 1), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'atlases'
                or marc:datafield[matches(marc:subfield, '(Atlases)')]
            )
            and marc:datafield[@tag='130']/marc:subfield[@code='a'] = '(Radio program)'
            and translate(marc:datafield[@tag='130']/marc:subfield[@code='k'], 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'selections'
                and not(
                    marc:controlfield[@tag='000']/substring(., 7, 1) = 'c' 
                    or marc:controlfield[@tag='000']/substring(., 7, 1) = 'd' 
                    or marc:controlfield[@tag='000']/substring(., 7, 1) = 'j'
                )
            and translate(marc:datafield[@tag='240']/marc:subfield[@code='k'], 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'selections'
                and not(
                    marc:controlfield[@tag='000']/substring(., 7, 1) = 'c' 
                    or marc:controlfield[@tag='000']/substring(., 7, 1) = 'd' 
                    or marc:controlfield[@tag='000']/substring(., 7, 1) = 'j'
                )
            and exists(marc:datafield[@tag='130'])
          "/>
        </xsl:variable>
        <!-- <xsl:variable name="isParallelAggregate" as="xs:boolean">
        </xsl:variable>
        <xsl:variable name="isAugmentationAggregate" as="xs:boolean">
        </xsl:variable> -->

        <xsl:if test="$isCollectionAggregate">
          <xsl:comment>handle collection aggregate manifestation</xsl:comment>
        </xsl:if>
        <!-- <xsl:if test="$isAugmentationAggregate">
          <xsl:comment>handle augmentation aggregate manifestation</xsl:comment>
        </xsl:if>
        <xsl:if test="$isParallelAggregate">
          <xsl:comment>handle parallel aggregate manifestation</xsl:comment>
        </xsl:if>
        <xsl:if test="not($isCollectionAggregate) and not($isAugmentationAggregate) and not($isParallelAggregate)">
          <xsl:comment>handle Single expression manifestations</xsl:comment>
        </xsl:if> -->
    </xsl:template>

</xsl:stylesheet>
