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
    <xsl:template match="marc:datafield[@tag = '020'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '020']" mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'c']">
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'z'])">
                    <rdamd:P30160>
                        <xsl:value-of select="marc:subfield[@code = 'c']"/>
                    </rdamd:P30160>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '020'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '020']" mode="nom">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
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
    
    <!-- 027 - Standard technical report number -->
    <xsl:template match="marc:datafield[@tag = '027'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '027']" mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '027'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '027']" mode="nom">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
            <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
                <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                    <rdand:P80068><xsl:value-of select="."/></rdand:P80068>
                    <xsl:choose>
                        <xsl:when test="contains(., '--')">
                            <rdand:P80069>ISRN</rdand:P80069>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdand:P80069>STRN</rdand:P80069>
                        </xsl:otherwise>
                    </xsl:choose>
                    <rdand:P80078>Standard Technical Report Number</rdand:P80078>
                    <xsl:if test="@code = 'z'">
                        <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
                    </xsl:if>
                    <xsl:if test="following-sibling::marc:subfield[@code = 'q']">
                        <xsl:for-each select="following-sibling::marc:subfield[@code = 'q']">
                            <rdand:P80071><xsl:value-of select="normalize-space(translate(., '();', ''))"/></rdand:P80071>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
            </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '028'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '028']"
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="@ind1 = '3'">
                <rdamo:P30065 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
            </xsl:when>
            <xsl:when test="@ind1 = '2'">
                <rdamo:P30066 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '028'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '028']" mode="nom">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
            <rdand:P80068><xsl:value-of select="marc:subfield[@code = 'a']"/></rdand:P80068>
            <xsl:if test="marc:subfield[@code = 'b']">
                <rdand:P80073><xsl:value-of select="marc:subfield[@code = 'b']"/></rdand:P80073>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'q']">
                <rdand:P80071>
                    <xsl:for-each select="marc:subfield[@code = 'q']">
                        <xsl:value-of select="normalize-space(translate(., '();', ''))"/>
                        <xsl:if test="position() != last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </rdand:P80071>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ind1 = '0'"><rdand:P80078>Issue number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '1'"><rdand:P80078>Matrix number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '2'"><rdand:P80078>Plate number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '4'"><rdand:P80078>Video recording publisher number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '5'"><rdand:P80078>Other publisher number</rdand:P80078></xsl:when>
                <xsl:when test="@ind1 = '6'"><rdand:P80078>Distributor number</rdand:P80078></xsl:when>
                <xsl:otherwise/>
                </xsl:choose>
        </rdf:Description>
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
    
    <!-- 088 - Report number -->
    <xsl:template match="marc:datafield[@tag = '088'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '088']" mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamo:P30004 rdf:resource="{'http://marc2rda.edu/fake/nom/'||generate-id()}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '088'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '088']" mode="nom">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdano:P80048 rdf:resource="{$baseIRI||'man'}"/>
                <rdand:P80078>Report number</rdand:P80078>
            </rdf:Description>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdf:Description rdf:about="{'http://marc2rda.edu/fake/nom/'||generate-id()}">
                <rdand:P80068>
                    <xsl:value-of select="."/>
                </rdand:P80068>
                <rdano:P80048 rdf:resource="{$baseIRI||'man'}"/>
                <rdand:P80078>Report number</rdand:P80078>
                <rdan:P80168 rdf:resource="http://id.loc.gov/vocabulary/mstatus/cancinv"/>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
