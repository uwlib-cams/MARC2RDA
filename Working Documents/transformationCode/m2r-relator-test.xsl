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
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf"
    version="3.0">
    <xsl:key name="fieldKey" match="uwmisc:row" use="uwmisc:field"/>
    <xsl:key name="indKey" match="uwmisc:row" use="uwmisc:ind"/>
    <xsl:key name="domainKey" match="uwmisc:row" use="uwmisc:domain"/>
    <xsl:variable name="rel2rda" select="'./input/marcRel2Rda-test.xml'"/>
    
    <xsl:template match="/">
        <xsl:for-each select="marc:collection">
            <xsl:for-each select="marc:record">
                <!-- in actual implementation, a template will match on X00 fields in each mode and call relatorLookup template -->
                <xsl:for-each select="marc:datafield[@tag = '100'] | marc:datafield[@tag = '700'] | 
                    marc:datafield[@tag = '110'] | marc:datafield[@tag = '710']">
                    <xsl:variable name="fieldValue">
                        <xsl:choose>
                            <xsl:when test="(@tag = '100') or (@tag = '700')">
                                <xsl:value-of select="'X00'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@tag"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="indValue">
                        <xsl:choose>
                            <xsl:when test="(@ind1 = '1') or (@ind1 = '0')">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:when test="(@ind1 = ' ')">
                                <xsl:value-of select="'na'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@ind1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:call-template name="relatorLookup">
                        <!-- the marc:datafield as a whole is passed in -->
                        <xsl:with-param name="field" select="."/>
                        <!-- The fieldNum = X00 -->
                        <xsl:with-param name="fieldNum" select="$fieldValue"/>
                        <!-- if the ind = 0 or 1, select 1 otherwise use actual ind value -->
                        <xsl:with-param name="ind" select="$indValue"/>
                        <!-- domain determined by mode -->
                        <xsl:with-param name="domain">Item</xsl:with-param>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="relatorLookup" expand-text="yes">
        <xsl:param name="field"/>
        <xsl:param name="fieldNum"/>
        <xsl:param name="ind"/>
        <xsl:param name="domain"/>
        <!-- match marcRel2Rda table row by field, indicator, and domain -->
        <!-- this narrows down the list of possible matches -->
        <xsl:for-each
            select="key('fieldKey', $fieldNum, document($rel2rda)) intersect key('indKey', $ind, document($rel2rda)) intersect key('domainKey', $domain, document($rel2rda))">
            <xsl:variable name="relMatch" select="."/>
            <!-- within these possible matches, check the following -->
            
            <!-- any $e matches -->
            <xsl:for-each select="$field/marc:subfield[@code = 'e']">
                <xsl:if
                    test="lower-case($relMatch/uwmisc:subELabelMarc) = lower-case(replace(., '\.', ''))">
                    <xsl:value-of select="$relMatch"/>
                </xsl:if>
                <xsl:if test="lower-case($relMatch/uwmisc:subELabelRda) = lower-case(replace(., '\.', ''))">
                    <xsl:value-of select="$relMatch"/>
                </xsl:if>
            </xsl:for-each>
            
            <!-- any $4 matches -->
            <xsl:for-each select="$field/marc:subfield[@code = '4']">
                <xsl:if
                    test="$relMatch/uwmisc:sub4Code = .">
                    <xsl:value-of select="$relMatch"/>
                </xsl:if>
                <xsl:if test="$relMatch/uwmisc:marcRelIri = .">
                    <xsl:value-of select="$relMatch"/>
                </xsl:if>
            </xsl:for-each>
            
        </xsl:for-each>
        <!-- currently outputs the matching row. In implementation, this will return the appropriate curie instead -->
        <!-- not checking for 4 matching an rda prop IRI - this results in too many duplicates
             may just check if it's an rda WEMI IRI and map directly? -->
    </xsl:template>
</xsl:stylesheet>
