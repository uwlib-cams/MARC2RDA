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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    <xsl:import href="getmarc.xsl"/>
    <!-- <xsl:include href="m2r-0xx-named.xsl"/> -->
    <xsl:template match="marc:datafield[@tag = '020']" mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:comment>Simple literal without qualifiers</xsl:comment>
            <rdamd:P30004>
                <xsl:value-of select="translate(., ' :', '')"/>
            </rdamd:P30004>
            <xsl:comment>Simple literal with qualifiers</xsl:comment>
            <rdamd:P30004>
                <xsl:text>ISBN: </xsl:text>
                <xsl:value-of select="translate(., ' :', '')"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <xsl:text> (</xsl:text>
                    <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> ; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdamd:P30004>
            <xsl:comment>Typed literal without qualifiers</xsl:comment>
            <rdamd:P30004 rdf:datatype="http://id.loc.gov/vocabulary/identifiers/isbn">
                <xsl:value-of select="translate(., ' :', '')"/>
            </rdamd:P30004>
            <xsl:comment>Typed literal with qualifiers</xsl:comment>
            <rdamd:P30004 rdf:datatype="http://id.loc.gov/vocabulary/identifiers/isbn">
                <xsl:value-of select="translate(., ' :', '')"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <xsl:text> (</xsl:text>
                    <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> ; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdamd:P30004>
            <xsl:comment>Nomen</xsl:comment>
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:comment>Simple literal without qualifiers</xsl:comment>
            <rdamd:P30004>
                <xsl:value-of select="translate(., ' :', '')"/>
            </rdamd:P30004>
            <xsl:comment>Simple literal with qualifiers</xsl:comment>
            <rdamd:P30004>
                <xsl:text>Canceled/invalid ISBN: </xsl:text>
                <xsl:value-of select="translate(., ' :', '')"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <xsl:text> (</xsl:text>
                    <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> ; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdamd:P30004>
            <xsl:comment>Typed literal without qualifiers</xsl:comment>
            <rdamd:P30004 rdf:datatype="http://id.loc.gov/vocabulary/identifiers/isbn">
                <xsl:value-of select="translate(., ' :', '')"/>
            </rdamd:P30004>
            <xsl:comment>Typed literal with qualifiers</xsl:comment>
            <rdamd:P30004 rdf:datatype="http://id.loc.gov/vocabulary/identifiers/isbn">
                <xsl:text>(Canceled/invalid) </xsl:text>
                <xsl:value-of select="translate(., ' :', '')"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <xsl:text> (</xsl:text>
                    <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text> ; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdamd:P30004>
            <xsl:comment>Nomen</xsl:comment>
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'c']">
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'z']) or marc:subfield[@code = 'a']">
                    <rdamd:P30160>
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </rdamd:P30160>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '020']" mode="nom">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:comment>Nomen</xsl:comment>
            <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                <rdand:P80068>
                    <xsl:value-of select="translate(., ' :', '')"/>
                </rdand:P80068>
                <rdano:P80048 rdf:resource="{$baseIRI||'man'}"/>
                <rdan:P80069 rdf:resource="http://id.loc.gov/vocabulary/identifiers/isbn"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <rdand:P80071>
                        <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                            <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </rdand:P80071>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:comment>Nomen</xsl:comment>
            <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                <rdand:P80068>
                    <xsl:value-of select="translate(., ' :', '')"/>
                </rdand:P80068>
                <rdano:P80048 rdf:resource="{$baseIRI||'man'}"/>
                <rdan:P80069 rdf:resource="http://id.loc.gov/vocabulary/identifiers/isbn"/>
                <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                    <rdand:P80071>
                        <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                            <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>; </xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </rdand:P80071>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '030']" mode="wor">
        <xsl:call-template name="getmarc"/>
        <!-- subfields not coded: $6 $8 -->
        <xsl:if test="matches(marc:subfield[@code = 'a'], '^[A-Z]')">
            <rdawd:P10002>
                <xsl:value-of select="concat('(CODEN)', marc:subfield[@code = 'a'])"/>
            </rdawd:P10002>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[A-Z]')">
                <rdawd:P10002>
                    <xsl:value-of select="concat('(Canceled/invalid CODEN)', .)"/>
                </rdawd:P10002>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '030']" mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="matches(marc:subfield[@code = 'a'], '^[0-9]')">
            <rdamd:P30004>
                <xsl:value-of select="concat('(CODEN)', marc:subfield[@code = 'a'])"/>
            </rdamd:P30004>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:if test="matches(., '^[0-9]')">
                <rdamd:P30004>
                    <xsl:value-of select="concat('(Canceled/invalid CODEN)', .)"/>
                </rdamd:P30004>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '043']" mode="wor" expand-text="true">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdawd:P10321 rdf:datatype="http://id.loc.gov/vocabulary/geographicAreas"
                >{replace(.,'-+$','')}</rdawd:P10321>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1] != 'marcgac'">
                <rdawd:P10321
                    rdf:datatype="{'http://marc2rda.edu/fake/datatype/'||following-sibling::marc:subfield[@code = '2'][1]}"
                    >{.}</rdawd:P10321>
            </xsl:if>
            <xsl:if test="following-sibling::marc:subfield[@code = '2'][1] = 'marcgac'">
                <rdawd:P10321 rdf:datatype="http://id.loc.gov/vocabulary/geographicAreas"
                    >{replace(.,'-+$','')}</rdawd:P10321>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdawd:P10321 rdf:datatype="http://purl.org/dc/terms/ISO3166">{.}</rdawd:P10321>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:comment>Unused $0 value in field 043</xsl:comment>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdawo:P10321 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
