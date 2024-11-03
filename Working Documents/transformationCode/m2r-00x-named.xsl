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
    
    <!-- 006 -->
    <xsl:template name="F006-c1-4-BK">
        <xsl:param name="char1-4"/>
        <xsl:call-template name="F008-c18-21-BK">
            <xsl:with-param name="char18-21" select="$char1-4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-CR">
        <xsl:param name="char1"/>
        <xsl:call-template name="F008-c18-CR">
            <xsl:with-param name="char18" select="$char1"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-4-MP">
        <xsl:param name="char1-4"/>
        <xsl:call-template name="F008-c18-21-MP">
            <xsl:with-param name="char18-21" select="$char1-4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-2-MU">
        <xsl:param name="char1-2"/>
        <xsl:call-template name="F008-c18-19-MU">
            <xsl:with-param name="char18-19" select="$char1-2"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-3-VM">
        <xsl:param name="char1-3"/>
        <xsl:call-template name="F008-c18-20-VM">
            <xsl:with-param name="char18-20" select="$char1-3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-3-VM-man">
        <xsl:param name="char1-3"/>
        <xsl:call-template name="F008-c18-20-VM-origMan">
            <xsl:with-param name="char18-20" select="$char1-3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c2-CR">
        <xsl:param name="char2"/>
        <xsl:call-template name="F008-c19-CR">
            <xsl:with-param name="char19" select="$char2"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c3-MU">
        <xsl:param name="char3"/>
        <xsl:call-template name="F008-c20-MU">
            <xsl:with-param name="char20" select="$char3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c4-CR">
        <xsl:param name="char4"/>
        <xsl:call-template name="F008-c21-CR">
            <xsl:with-param name="char21" select="$char4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c4-MU">
        <xsl:param name="char4"/>
        <xsl:call-template name="F008-c21-MU">
            <xsl:with-param name="char21" select="$char4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-SOME">
        <xsl:param name="char5"/>
        <xsl:call-template name="F008-c22-SOME">
            <xsl:with-param name="char22" select="$char5"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-CR">
        <xsl:param name="char5"/>
        <xsl:call-template name="F008-c22-CR">
            <xsl:with-param name="char22" select="$char5"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-6-MP">
        <xsl:param name="char5-6"/>
        <xsl:call-template name="F008-c22-23-MP">
            <xsl:with-param name="char22-23" select="$char5-6"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6_12-f-SOME">
        <xsl:param name="char6_12"/>
        <xsl:call-template name="F008-c23_29-f-SOME">
            <xsl:with-param name="char23_29" select="$char6_12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-BK">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-z-BK-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-CF">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23-CF">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-CF-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-CR">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-MX">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-MX-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-xz-SOME-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-MU">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-xz-SOME-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-10-BK">
        <xsl:param name="char7-10"/>
        <xsl:call-template name="F008-c24-27-BK">
            <xsl:with-param name="char24-27" select="$char7-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-10-2bkq-BK">
        <xsl:param name="char7-10"/>
        <xsl:call-template name="F008-c24-27-2bkq-BK">
            <xsl:with-param name="char24-27" select="$char7-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-CR">
        <xsl:param name="char7"/>
        <xsl:call-template name="F008-c24-CR">
            <xsl:with-param name="char24" select="$char7"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-MP">
        <xsl:param name="char7"/>
        <xsl:call-template name="F008-c24-MP">
            <xsl:with-param name="char24" select="$char7"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-12-MU">
        <xsl:param name="char7-12"/>
        <xsl:call-template name="F008-c24-29-MU-origMan">
            <xsl:with-param name="char24-29" select="$char7-12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-10-CR">
        <xsl:param name="char8-10"/>
        <xsl:call-template name="F008-c25-27-CR">
            <xsl:with-param name="char25-27" select="$char8-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-10-bkq-CR">
        <xsl:param name="char8-10"/>
        <xsl:call-template name="F008-c25-27-bkq-CR">
            <xsl:with-param name="char25-27" select="$char8-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-abdefg-MP">
        <xsl:param name="char8"/>
        <xsl:call-template name="F008-c25-abdefg-MP">
            <xsl:with-param name="char25" select="$char8"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-acd-MP">
        <xsl:param name="char8"/>
        <xsl:call-template name="F008-c25-acd-MP-origMan">
            <xsl:with-param name="char25" select="$char8"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c9-CF">
        <xsl:param name="char9"/>
        <xsl:call-template name="F008-c26-CF">
            <xsl:with-param name="char26" select="$char9"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c11-SOME">
        <xsl:param name="char11"/>
        <xsl:call-template name="F008-c28-SOME">
            <xsl:with-param name="char28" select="$char11"/>
        </xsl:call-template>
    </xsl:template>  
    
    <xsl:template name="F006-c12-BK">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c29-BK">
            <xsl:with-param name="char29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-CR">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c29-CR">
            <xsl:with-param name="char29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-MP">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-VM">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-BK">
        <xsl:param name="char13"/>
        <xsl:call-template name="F008-c30-BK">
            <xsl:with-param name="char30" select="$char13"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-14-MU">
        <xsl:param name="char13-14"/>
        <xsl:call-template name="F008-c30-31-MU">
            <xsl:with-param name="char30-31" select="$char13-14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-14-__-MU">
        <xsl:param name="char13-14"/>
        <xsl:call-template name="F008-c30-31-__-MU">
            <xsl:with-param name="char30-31" select="$char13-14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c14-BK">
        <xsl:param name="char14"/>
        <xsl:call-template name="F008-c31-BK">
            <xsl:with-param name="char31" select="$char14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c14-MP">
        <xsl:param name="char14"/>
        <xsl:call-template name="F008-c31-MP">
            <xsl:with-param name="char31" select="$char14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-BK">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-BK">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-MP-origMan">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-gk-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-gk-MP">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-jm-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-jm-MP">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-MU">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-MU">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-dgiklmno-VM">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-VM">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-abcdfmnoprstvw-VM">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-VM-origMan">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-abc-BK">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-abc-BK">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-d-BK">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-d-BK">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-VM">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-VM">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- 008 -->
    <xsl:template name="F008-c6">
        <xsl:param name="char6"/>
        <xsl:if test="$char6 = 'c'">
            <rdamd:P30137>
                <xsl:text>Continuing resource currently published.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char6 = 'd'">
            <rdamd:P30137>
                <xsl:text>Continuing resource ceased publication.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c7-14" expand-text="yes">
        <xsl:param name="char6"/>
        <xsl:param name="char7-14"/>
        <xsl:param name="date1" select="translate(substring($char7-14, 1, 4), 'u', 'X')"/>
        <xsl:param name="date2" select="translate(substring($char7-14, 5, 4), 'u', 'X')"/>
        <xsl:choose>
            <xsl:when test="$char6 = 'e'">
                <xsl:if test="matches($date1, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>{$date1}</xsl:text>
                        <xsl:if test="matches(substring($date2, 1, 2), '[\d]+[X]*')">
                            <xsl:text>-{substring($date2, 1, 2)}</xsl:text>
                        </xsl:if>
                        <xsl:if test="matches(substring($date2, 1, 2), '[\d]+[X]*') and matches(substring($date2, 3, 2), '[\d]+[X]*')">
                            <xsl:text>-{substring($date2, 3, 2)}</xsl:text>
                        </xsl:if>
                    </rdamd:P30278>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'm'">
                <xsl:if test="not(matches($date1, '[\d]+[X]*')) and matches($date2, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>/{$date2}</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
                <xsl:if test="matches($date1, '[\d]+[X]*') and not(matches($date2, '[\d]+[X]*'))">
                    <rdamd:P30278>
                        <xsl:text>{$date1}/</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
                <xsl:if test="not(matches($date1, '[\d]+[X]*')) and not(matches($date2, '[\d]+[X]*'))">
                    <rdamd:P30137>
                        <xsl:text>Dates of publication unknown.</xsl:text>
                    </rdamd:P30137>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'p'">
                <xsl:choose>
                    <xsl:when test="matches($date1, '[\d]+[X]*')">
                        <rdamd:P30278>
                            <xsl:text>{$date1}/..</xsl:text>
                        </rdamd:P30278>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdamd:P30137>
                            <xsl:text>Date of manifestation unknown.</xsl:text>
                        </rdamd:P30137>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$char6 = 'q'">
                <xsl:if test="matches($date1, '[\d]+[X]*') and matches($date2, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>[{$date1}..{$date2}]</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'r' or $char6 = 's' or $char6 = 't'">
                <xsl:choose>
                    <xsl:when test="matches($date1, '[\d]+[X]*')">
                        <rdamd:P30011>
                            <xsl:text>{$date1}</xsl:text>
                        </rdamd:P30011>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdamd:P30137>
                            <xsl:text>Date of publication unknown.</xsl:text>
                        </rdamd:P30137>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c15-17">
        <xsl:param name="char15-17"/>
        <rdamo:P30279 rdf:resource="{normalize-space(concat('http://id.loc.gov/vocabulary/countries/', $char15-17))}"/>
    </xsl:template>
    
    <xsl:template name="F008-c18-21-BK">
        <xsl:param name="char18-21"/>
        <xsl:analyze-string select="$char18-21" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'a'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1014'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1008'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'c'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1012'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'd'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#d'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'e'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1011'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'f'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#f'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'g'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#g'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'h'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1002'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'i'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1001'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'j'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1004'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1003'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'l'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1013'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'm'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#m'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'o'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1010'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'p'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1006'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c18-CR">
        <xsl:param name="char18"/>
        <xsl:choose>
            <xsl:when test="$char18 = 'a'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1013'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'b'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1007'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'c'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1005'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'd'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1001'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'e'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1003'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'f'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1012'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'g'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1014'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'h'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1015'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'i'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1002'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'j'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1006'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'k'">
                <rdaw:P10368 rdf:resource="{'https://doi.org/10.6069/uwlswd.ggnh-4s58#k'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'm'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1008'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'q'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1010'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 's'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1009'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 't'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1011'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'w'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1004'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c18-21-MP">
        <xsl:param name="char18-21"/>
        <xsl:choose>
            <xsl:when test="$char18-21 = '    '">
                <rdaed:P20071>
                    <xsl:text>No relief shown.</xsl:text>
                </rdaed:P20071>
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="$char18-21" regex=".{{1}}">
                    <xsl:matching-substring>
                        <xsl:if test=". != ' ' and . != '|' and . != 'z'">
                            <xsl:choose>
                                <xsl:when test=". = 'h'">
                                    <rdae:P20318 rdf:resource="{'https://doi.org/10.6069/uwlswd.1c2x-cj09#hx'}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdae:P20318 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.1c2x-cj09#', .)}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c18-19-MU">
        <xsl:param name="char18-19"/>
        <xsl:if test="not(contains($char18-19, ' ')) and not(contains($char18-19, '|')) 
            and $char18-19 != 'nn' and $char18-19 != 'uu' and $char18-19 != 'zz'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.8rpj-ek77#', $char18-19)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-20-VM" expand-text="yes">
        <xsl:param name="char18-20"/>
        <xsl:if test="matches($char18-20, '\d\d\d') and $char18-20 != '000'">
            <rdaed:P20219>
                <xsl:text>Duration: {$char18-20} minutes.</xsl:text>
            </rdaed:P20219>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-20-VM-origMan" expand-text="yes">
        <xsl:param name="char18-20"/>
        <xsl:if test="$char18-20 = '000'">
            <rdamd:P20219>
                <xsl:text>Duration: exceeds 16 hours, 39 minutes.</xsl:text>
            </rdamd:P20219>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c19-CR">
        <xsl:param name="char19"/>
        <xsl:choose>
            <xsl:when test="$char19 = 'n'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Normalized irregular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char19 = 'r'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Regular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char19 = 'x'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Completely irregular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c20-MU">
        <xsl:param name="char20"/>
        <xsl:if test="$char20 != ' ' and $char20 != '|' and $char20 != 'u' and $char20 != 'z' and $char20 != 'n'">
            <xsl:choose>
                <xsl:when test="$char20 = 'h'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1002'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'i'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1003'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'k'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1011'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'l'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1007'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'p'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1006'}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdae:P20209 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.06xx-6744#', $char20)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c21-CR">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 != ' ' and $char21 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.62zz-1534#', $char21)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c21-MU">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 = 'd' or $char21 = 'e' or $char21 = 'f'">
            <rdae:P20209 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.ywjs-vr46#', $char21)}"/>
        </xsl:if>    
    </xsl:template>
    
    <xsl:template name="F008-c22-SOME">
        <xsl:param name="char22"/>
        <xsl:choose>
            <xsl:when test="$char22 != ' ' and $char22 != '|'">
                <rdae:P20322 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.aec4-nv40#', $char22)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c22-CR">
        <xsl:param name="char22"/>
        <xsl:if test="$char22 = 'a'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microfilm.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'b'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microfiche.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'c'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microopaque.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'd'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Large print.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'e'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Newspaper format.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'f'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Braille.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'o'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Online.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'q'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Direct electronic.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 's'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Electronic.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c22-23-MP">
        <xsl:param name="char22-23"/>
        <xsl:if test="not(contains($char22-23, ' ')) and not(contains($char22-23, '|')) and $char22-23 != 'zz'">
            <rdae:P20216 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4jrs-m847#', $char22-23)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-dqs-SOME-origMan">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'd'">
                <rdam:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'q'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#q'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 's'">
                <rdam:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1003'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-ghi-SOME-origMan">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'g'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#gx'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'h'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#hx'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'i'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#ix'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-abcor-SOME">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'a'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#a'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'b'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1022'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'c'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1028'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'o'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1018'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'r'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#r'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-f-SOME">
        <xsl:param name="char23_29"/>
        <xsl:if test="$char23_29 = 'f'">
            <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-xz-SOME-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'x' or $char23 = 'z'">
            <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#zx'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-z-BK-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'z'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#zx'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-CF-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'q'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#q'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-CF">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'o'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#o'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-MX-origMan">
        <xsl:param name="char23"/>
        <xsl:choose>
            <xsl:when test="$char23 = 'j'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#jx'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'p'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#px'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 't'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#tx'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c24-27-BK">
        <xsl:param name="char24-27"/>
        <xsl:analyze-string select="$char24-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = ' ' or . = '|' or . = '2' or . = 'b' or . = 'k' or . = 'q'"/>
                    <xsl:when test=". = 'h'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#hx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'x'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#t'}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.633m-h220#', .)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c24-27-2bkq-BK">
        <xsl:param name="char24-27"/>
        <xsl:analyze-string select="$char24-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = '2'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#2'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdamd:P30137>
                            <xsl:text>Includes bibliographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdamd:P30137>
                            <xsl:text>Includes discographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'q'">
                        <rdamd:P30137>
                            <xsl:text>Includes filmographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c24-CR">
        <xsl:param name="char24"/>
        <xsl:if test="$char24 != ' ' and $char24 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.jfr5-z647#', $char24)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c24-MP">
        <xsl:param name="char24"/>
        <xsl:choose>
            <xsl:when test="$char24 = 'e'">
                <rdaed:P20317>
                    <xsl:text>Greenwich</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'f'">
                <rdaed:P20317>
                    <xsl:text>Ferro</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'g'">
                <rdaed:P20317>
                    <xsl:text>Paris</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'p'">
                <rdaed:P20317>
                    <xsl:text>Philadelphia</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'w'">
                <rdaed:P20317>
                    <xsl:text>Washington, D.C.</xsl:text>
                </rdaed:P20317>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c24-29-MU-origMan">
        <xsl:param name="char24-29"/>
        <xsl:analyze-string select="$char24-29" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". != ' ' and . != '|' and . != 'n' and . != 'z'">
                    <xsl:choose>
                        <xsl:when test=". = 'j'">
                            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.nt0v-d633#jx'}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30455 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.nt0v-d633#', .)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c25-27-CR">
        <xsl:param name="char25-27"/>
        <xsl:analyze-string select="$char25-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = ' ' or . = '|' or . = 'b' or . = 'k' or . = 'q'"/>
                    <xsl:otherwise>
                        <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.cr35-yd51#', .)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c25-27-bkq-CR">
        <xsl:param name="char25-27"/>
        <xsl:analyze-string select="$char25-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'b'">
                        <rdamd:P30137>
                            <xsl:text>Includes bibliographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdamd:P30137>
                            <xsl:text>Includes discographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'q'">
                        <rdamd:P30137>
                            <xsl:text>Includes filmographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c25-abdefg-MP">
        <xsl:param name="char25"/>
        <xsl:if test="$char25 = 'a' or $char25 = 'b' or $char25 = 'd'
            or $char25 = 'e' or $char25 = 'f' or $char25 = 'g'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.vw5v-gh79#', $char25)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c25-acd-MP-origMan">
        <xsl:param name="char25"/>
        <xsl:choose>
            <xsl:when test="$char25 = 'a'">
                <rdam:P30003 rdf:resource="{'http://rdaregistry.info/termList/ModeIssue/1001'}"/>
            </xsl:when>
            <xsl:when test="$char25 = 'c'">
                <rdam:P30003 rdf:resource="{'http://rdaregistry.info/termList/ModeIssue/1005'}"/>
            </xsl:when>
            <xsl:when test="$char25 = 'd'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c26-CF">
        <xsl:param name="char26"/>
        <xsl:if test="$char26 != 'u' and $char26 != 'z' and $char26 != ' ' and $char26 != '|'">
            <rdam:P30018 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.mkjn-bp10#', $char26)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c28-SOME">
        <xsl:param name="char28"/>
        <xsl:if test="$char28 != ' ' and $char28 != '|' and $char28 != 'u'">
            <xsl:choose>
                <xsl:when test="$char28 = 'n'">
                    <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.2eg3-1x53#nx'}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdam:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.2eg3-1x53#', $char28)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c29-BK">
        <xsl:param name="char29"/>
        <xsl:if test="$char29 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.t1gh-8294#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c29-CR">
        <xsl:param name="char29"/>
        <xsl:if test="$char29 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.6mz0-ta86#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-BK">
        <xsl:param name="char30"/>
        <xsl:if test="$char30 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.tq9s-1157#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-31-MU">
        <xsl:param name="char30-31"></xsl:param>
        <xsl:analyze-string select="$char30-31" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". != ' ' and . != '|' and . != 'n' and . != 'z'">
                    <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.23tq-5e25#', .)}"/>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c30-31-__-MU">
        <xsl:param name="char30-31"/>
        <xsl:if test="$char30-31 = '  '">
            <rdae:P20331 rdf:resource="{'https://doi.org/10.6069/uwlswd.23tq-5e25#pound'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c31-BK">
        <xsl:param name="char31"/>
        <xsl:if test="$char31 = '1'">
            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.m0xp-h565#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c31-MP">
        <xsl:param name="char31"/>
        <xsl:if test="$char31 = '1'">
            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.2h4d-g549#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-BK">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != 'u' and $char33 != '|' and $char33 != ' '">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.f447-ax91#', $char33)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-CR">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'a'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Basic Roman.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'b'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Extended Roman.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'c'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Cyrillic.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'd'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Japanese.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'e'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Chinese.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'f'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Arabic.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'g'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Greek.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'h'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Hebrew.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'i'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Thai.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'j'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Devanagari.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'k'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Korean.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'l'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Tamil.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-gk-MP">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'g'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#gx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#k'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-jm-MP">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". = 'm'">
                    <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
                </xsl:if>
                <xsl:if test=". = 'j'">
                    <rdae:P20001 rdf:resource="{'http://rdaregistry.info/termList/RDAContentType/1002'}"/>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-MP-origMan">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'a'">
                        <rdam:P30187 rdf:resource="{'http://rdaregistry.info/termList/RDAproductionMethod/1001'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdam:P30187 rdf:resource="{'http://rdaregistry.info/termList/RDAproductionMethod/1008'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'c'">
                        <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#cx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'd'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#dx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'e'">
                        <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#e'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'f'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#fx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'g'">
                        <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'j'">
                        <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1045'}"/>
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#j'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'l'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#l'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'n'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#n'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'o'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#o'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'p'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#p'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'q'">
                        <rdam:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'r'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#r'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-MU">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != ' ' and $char33 != '|' and $char33 != 'n' and $char33 != 'u' and $char33 != 'z'">
            <rdae:P20331 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.axz0-z371#', $char33)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-VM">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'd'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#d'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'g'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#g'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'i'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#i'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'k'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#k'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'l'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#l'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'm'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#m'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'n'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#n'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'o'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#o'}"/>
            </xsl:when>        
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c33-VM-origMan">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'a'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#a'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'b'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#b'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'c'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#c'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'd'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'f'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1036'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#f'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'm'">
                <rdam:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1005'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'n'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1048'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'o'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1045'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'p'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1030'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#p'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'q'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#q'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'r'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#r'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 's'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1040'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#s'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 't'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 't'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'v'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#v'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#v'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'w'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#w'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c34-abc-BK">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'a' or $char34 = 'b' or $char34 = 'c'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.x4ce-sd21#', $char34)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-d-BK">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'd'">
            <rdamd:P30137>
                <xsl:text>Contains biographical information.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-VM">
        <xsl:param name="char34"/>
        <xsl:choose>
            <xsl:when test="$char34 = 'a' or $char34 = 'c' or $char34 = 'l'">
                <rdaw:P10222 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.eje7-jq11#', $char34)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
