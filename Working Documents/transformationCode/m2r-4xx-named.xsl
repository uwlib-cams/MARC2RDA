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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F490-xx-axv-isbd">
        <xsl:for-each-group select="*[not(.[@code = '3'])][not(.[@code = '6'])]"
            group-starting-with="marc:subfield[@code = 'a']">
            <rdamd:P30106>
                <xsl:for-each select="current-group()">
                    <xsl:value-of select="replace(.[@code = 'a'], ' =$', '')"/>
                    <xsl:if test=".[@code = 'x']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select=".[@code = 'x']"/>
                    </xsl:if>
                    <xsl:if test=".[@code = 'v']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select=".[@code = 'v']"/>
                    </xsl:if>
                </xsl:for-each>
            </rdamd:P30106>
        </xsl:for-each-group>
        <xsl:if test="marc:subfield[@code = '3']">
            <rdamd:P30137>all rdamd:P30106 hasSeriesStatement values apply to <xsl:value-of
                    select="marc:subfield[@code = '3']"/>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F490-xx-axv-nonIsbd">
        <rdamd:P30106>
            <xsl:for-each select="*[not(@code='3')][not(@code='y')][not(@code='l')][not(@code='z')][not(@code='6')][not(@code='7')][not(@code='8')]">
                <xsl:text>$</xsl:text>
                <xsl:value-of select="@code"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
                <xsl:if test="not(position() = last())">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </rdamd:P30106>
        <xsl:if test="marc:subfield[@code = '3']">
            <rdamd:P30137>rdamd:P30106 hasSeriesStatement value applies to <xsl:value-of
                select="replace(marc:subfield[@code = '3'],':$','')"/>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>