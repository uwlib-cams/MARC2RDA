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
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf madsrdf" version="3.0">
    <xsl:import href="m2r-functions.xsl"/>
    
    <xsl:template name="F336-xx-ab0-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code = '3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20001>
                <xsl:value-of select="."/>
            </rdaed:P20001>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Content Type '</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>' applies to a manifestation's </xsl:text>
                    <xsl:value-of select="../marc:subfield[@code = '3']"/>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdaed:P20001>
                    <xsl:value-of select="."/>
                </rdaed:P20001>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <rdaed:P20071>
                        <xsl:text>Content Type '</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>' applies to a manifestation's </xsl:text>
                        <xsl:value-of select="../marc:subfield[@code = '3']"/>
                    </rdaed:P20071>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:choose>
                <xsl:when
                    test="contains(marc:subfield[@code = '2'], 'rda') and not(contains(marc:subfield[@code = '0'], 'http:')) and not(marc:subfield[@code = '1'])">
                    <xsl:comment>Source of rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code = '2']"/>': lookup the value of rdaed:P20001 in that source, retrieve the IRI and insert it into the data as the direct value of rdaeo:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when
                    test="not(contains(marc:subfield[@code = '2'], 'rda')) and not(contains(marc:subfield[@code = '0'], 'http:')) and not(marc:subfield[@code = '1'])">
                    <xsl:comment>Source of the rdaed:P20001 'hasContentType' value is coded '<xsl:value-of select="marc:subfield[@code = '2']"/>': it may be possible to consult that source to retrieve an IRI for the current value of rdaed:P20001.</xsl:comment>
                </xsl:when>
                <xsl:when
                    test="not(contains(marc:subfield[@code = '2'], 'rda')) and contains(marc:subfield[@code = '0'], 'http:') and not(marc:subfield[@code = '1'])"
                    ><!-- do nothing --></xsl:when>
                <xsl:otherwise>
                    <xsl:comment>$2 source not needed as $2 is rda and the $0 or $1 should be the direct value of P20001</xsl:comment>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F336-xx-01-iri">
        <xsl:if test="contains(marc:subfield[@code = '2'], 'rda')">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <rdaeo:P20001 rdf:resource="{replace(., '^\(uri\)','')}"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if
            test="not(contains(marc:subfield[@code = '2'], 'rda')) or not(marc:subfield[@code = '2'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="contains(., 'http:')">
                    <xsl:comment>MARC data source at field 336 contains a $0 IRI value representing authority data without the presence of a $1; a solution for outputting these in RDA is not yet devised.</xsl:comment>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaeo:P20001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30002>
                <xsl:value-of select="."/>
            </rdamd:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30002>
                <xsl:value-of select="."/>
            </rdamd:P30002>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdamd:P30002>
                    <xsl:value-of select="."/>
                </rdamd:P30002>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F337-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdamo:P30002 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdamo:P30002 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-string">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30001>
                <xsl:value-of select="."/>
            </rdamd:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30001>
                <xsl:value-of select="."/>
            </rdamd:P30001>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="not(contains(., 'http:'))">
                <rdamd:P30001>
                    <xsl:value-of select="."/>
                </rdamd:P30001>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F338-iri">
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:if test="contains(., 'http:')">
                <rdamo:P30001 rdf:resource="{.}"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdamo:P30001 rdf:resource="{.}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F340-xx-abcdefghijklmnop">
        <xsl:variable name="sub3" select="marc:subfield[@code = '3']"/>
        <xsl:variable name="sub0" select="marc:subfield[@code = '0']"/>
        <xsl:variable name="sub1" select="marc:subfield[@code = '1']"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30208>
                <xsl:value-of select="."/>
            </rdamd:P30208>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30208 hasBaseMaterial "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30208')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30208')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30169>
                <!--the parens below are not working; probably should remove -->
                <xsl:value-of select="."/>
                <xsl:text> (</xsl:text>
                <xsl:value-of select="preceding-sibling::marc:subfield[@code = 'a'][1]"/>
                <xsl:text>)</xsl:text>
            </rdamd:P30169>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30169 hasDimensions "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30084>
                <xsl:value-of select="."/>
            </rdamd:P30084>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30084 hasAppliedMaterial "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30084')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30084')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'd']">
            <rdamd:P30187>
                <xsl:value-of select="."/>
            </rdamd:P30187>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30187 hasProductionMethod "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30187')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30187')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <rdamd:P30186>
                <xsl:value-of select="."/>
            </rdamd:P30186>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30186 hasMount "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30186')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30186')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'f']">
            <rdamd:P30137>
                <xsl:text>Use at a rate or ratio of </xsl:text>
                <xsl:value-of select="."/>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'g']">
            <rdamd:P30456>
                <xsl:value-of select="."/>
            </rdamd:P30456>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30456 hasColourContent "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30456')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30456')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'h']">
            <rdamd:P30137>
                <xsl:text>Location of the described materials within the material base: </xsl:text>
                <xsl:value-of select="."/>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'i']">
            <rdamd:P30162>
                <xsl:value-of select="."/>
            </rdamd:P30162>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30162 hasEquipmentOrSystemRequirement "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'j']">
            <rdamd:P30191>
                <xsl:value-of select="."/>
            </rdamd:P30191>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30191 hasGeneration "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30191')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30191')"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'k']">
            <rdamd:P30155>
                <xsl:value-of select="."/>
            </rdamd:P30155>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30155 hasLayout "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30155')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30155')"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'l']">
            <rdamd:P30309>
                <xsl:value-of select="."/>
            </rdamd:P30309>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30309 hasTypeOfBinding "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30309')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30309')"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'm']">
            <rdamd:P30197>
                <xsl:value-of select="."/>
            </rdamd:P30197>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30197 hasBibliographicFormat "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
            </xsl:if>
            <xsl:copy-of select="uwf:test($sub0, 'P30197')"/>
            <xsl:copy-of select="uwf:test($sub1, 'P30197')"/>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'n']">
            <rdamd:P30199>
                <xsl:value-of select="."/>
            </rdamd:P30199>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30199 hasFontSize "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30199')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30199')"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdamd:P30196>
                <xsl:value-of select="."/>
            </rdamd:P30196>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30196 hasPolarity "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30196')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30196')"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'p']">
            <rdamd:P30453>
                <xsl:value-of select="."/>
            </rdamd:P30453>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>rdamd:P30453 hasIllustrativeContent "</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>" applies to </xsl:text>
                    <xsl:value-of select="$sub3"/>
                </rdamd:P30137>
                <xsl:copy-of select="uwf:test($sub0, 'P30453')"/>
                <xsl:copy-of select="uwf:test($sub1, 'P30453')"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 346 -->
    <xsl:template name="F346-string" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30104>{.}</rdamd:P30104>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>Video Format ({.}) applies to {../marc:subfield[@code = '3']}</xsl:text> 
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30123>{.}</rdamd:P30123>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdamd:P30137>
                    <xsl:text>Broadcast Standard ({.}) applies to {../marc:subfield[@code = '3']}</xsl:text> 
                </rdamd:P30137>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="not(contains(., 'http:'))">
                    <rdamd:P30104>
                        <xsl:value-of select="."/>
                    </rdamd:P30104>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'b'] and not(marc:subfield[@code = 'a'])">
            <xsl:for-each select="marc:subfield[@code = '0']">
                <xsl:if test="not(contains(., 'http:'))">
                    <rdamd:P30123>
                        <xsl:value-of select="."/>
                    </rdamd:P30123>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F346-iri" expand-text="yes">
            <xsl:if test="marc:subfield[@code = 'a'] and not(marc:subfield[@code = 'b'])">
                <xsl:for-each select="marc:subfield[@code = '0']">
                    <xsl:if test="contains(., 'http:')">
                        <rdam:P30104 rdf:resource="{.}"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = '1']">
                    <rdam:P30104 rdf:resource="{.}"/>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="marc:subfield[@code = 'b'] and not(marc:subfield[@code = 'a'])">
                <xsl:for-each select="marc:subfield[@code = '0']">
                    <xsl:if test="contains(., 'http:')">
                        <rdam:P30123 rdf:resource="{.}"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="marc:subfield[@code = '1']">
                    <rdam:P30123 rdf:resource="{.}"/>
                </xsl:for-each>
            </xsl:if>
    </xsl:template>
    
    <xsl:template name="F382-xx-a_b_d_p_2-exp" expand-text="yes">
        <xsl:variable name="s2code" select="marc:subfield[@code = '2']"/>
        <xsl:variable name="musiccodeschemes"
            select="document('http://id.loc.gov/vocabulary/musiccodeschemes.madsrdf.rdf')"/>
        <xsl:variable name="sourceiri">
            <xsl:for-each
                select="$musiccodeschemes/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/@rdf:resource">
                <xsl:if
                    test="substring-after(., 'http://id.loc.gov/vocabulary/musiccodeschemes/') = $s2code">
                    <xsl:text>http://id.loc.gov/vocabulary/musiccodeschemes/</xsl:text>
                    <xsl:value-of select="$s2code"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="contains($sourceiri, 'lcmpt')">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215 rdf:datatype="http://id.loc.gov/authorities/performanceMediums"
                    >{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri != '' and not(contains($sourceiri, 'lcmpt'))">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215 rdf:datatype="{$sourceiri}">{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri = ''">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdaed:P20215>{.}</rdaed:P20215>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F382-xx-abdenprstv3" expand-text="yes">
        <xsl:if test="marc:subfield[@code = '3']">{marc:subfield[@code = '3']||': '}</xsl:if>
        <xsl:text>For </xsl:text>
        <xsl:variable name="delimited">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 'r'] | marc:subfield[@code = 's'] | marc:subfield[@code = 't'] | marc:subfield[@code = 'v']">
                <xsl:if test=".[@code = 'a']">{.||'; '}</xsl:if>
                <xsl:if test=".[@code = 'n' or @code = 'e']">{'('||.||'); '}</xsl:if>
                <xsl:if test=".[@code = 'b']">{'solo '||.||'AFTERB '}</xsl:if>
                <xsl:if test=".[@code = 'd']">{'/'||.||' '}</xsl:if>
                <xsl:if test=".[@code = 'p']">{'or '||.||' '}</xsl:if>
                <xsl:if test=".[@code = 'v']">{'('||.||') '}</xsl:if>
                <xsl:if test=".[@code = 'r']">{'Total soloists: '||.||'. '}</xsl:if>
                <xsl:if test=".[@code = 's']">{'Total performers: '||.||'. '}</xsl:if>
                <xsl:if test=".[@code = 't']">{'Total ensembles: '||.||'. '}</xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of
            select="$delimited => replace(' \([0-9]+\); /', '/') => replace(' \([0-9]+\); or ', ' or ') => replace('Total soloists: 1\.', '') => replace('Total performers: 1\.', '') => replace('Total ensembles: 1\.', '') => replace(' \(0', ' (') => replace(' \(1\);', ';') => replace(';+ \[', ' [') => replace('\] /', ']/') => replace('\] ([a-z])', ']; $1') => replace('; Total ', '. Total ') => replace(' +$', '') => replace('\] Total', ']. Total') => replace(';;', ';') => replace(';\.', '.') => replace('; \(', ' (') => replace(';/', '/') => replace('; or ', ' or ') => replace(';$', '') => replace('AFTERB;', ';') => replace('AFTERB/', '/') => replace('AFTERB or ', ' or ') => replace('AFTERB \[', ' [') => replace('AFTERB', ';') => replace('::', ':')"
        />
    </xsl:template>
    <xsl:template name="F382-xx-a_b_d_p_2-wor" expand-text="yes">
        <xsl:variable name="s2code" select="marc:subfield[@code = '2']"/>
        <xsl:variable name="musiccodeschemes"
            select="document('http://id.loc.gov/vocabulary/musiccodeschemes.madsrdf.rdf')"/>
        <xsl:variable name="sourceiri">
            <xsl:for-each
                select="$musiccodeschemes/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/@rdf:resource">
                <xsl:if
                    test="substring-after(., 'http://id.loc.gov/vocabulary/musiccodeschemes/') = $s2code">
                    <xsl:text>http://id.loc.gov/vocabulary/musiccodeschemes/</xsl:text>
                    <xsl:value-of select="$s2code"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:if test="contains($sourceiri, 'lcmpt')">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220 rdf:datatype="http://id.loc.gov/authorities/performanceMediums"
                    >{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri != '' and not(contains($sourceiri, 'lcmpt'))">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220 rdf:datatype="{$sourceiri}">{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="$sourceiri = ''">
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'p']">
                <rdawd:P10220>{.}</rdawd:P10220>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
