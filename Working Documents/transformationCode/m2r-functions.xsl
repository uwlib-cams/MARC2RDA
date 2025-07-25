<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs marc ex uwf uwmisc"
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
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    version="3.0">
    
<!-- REPRODUCTIONS -->
    
    <xsl:function name="uwf:checkReproductions">
        <xsl:param name="record"/>
        <xsl:variable name="test588" select="if (some $a in $record/marc:datafield[@tag = '588']/marc:subfield[@code = 'a']
            satisfies (contains($a, 'version record'))) then true() else false()"/>
        <xsl:choose>
            <xsl:when test="$test588 = true()">
                <xsl:value-of select="'588'"/>
            </xsl:when>
            <xsl:when test="$test588 = false() and $record/marc:datafield[@tag = '533']">
                <xsl:value-of select="if (some $a in $record/marc:datafield[@tag = '533']/marc:subfield[@code = 'a']
                    satisfies not(contains($a, 'also available as'))) then '533' else ''"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
<!-- $5 FUNCTIONS -->
    
    <!-- collBase is the base URI we use for the minted collection manifestation for an institution -->
    <xsl:variable name="collBase">http://marc2rda.edu/fake/colMan/</xsl:variable>
    
    <!-- $5-preprocessedRDA.xml contains minted collection works and collection manifestations for
         organizations with codes in the MARC Organization Codes Database -->
    <xsl:variable name="lookup5Doc" select="document('lookup/$5-preprocessedRDA.xml')"/>
    <xsl:key name="normCode" match="rdf:Description[rdaad:P50006]" use="rdaad:P50006"/>
    
    <!-- returns "is holding of" the minted IRI for the organization's collection if found, otherwise outputs comment -->
    <xsl:function name="uwf:s5Lookup" expand-text="yes">
        <xsl:param name="code5"/>
        <xsl:variable name="lowerCode5" select="lower-case($code5)"/>
        <xsl:variable name="lookup5" select="$lookup5Doc/key('normCode',$lowerCode5)/rdaad:P50006[@rdf:datatype='http://id.loc.gov/datatypes/orgs/normalized']"/>
        <xsl:choose>
            <xsl:when test="$lookup5">
                <rdaio:P40161 rdf:resource="{$collBase}{$lookup5}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Unable to match {$code5} with Cultural Heritage Organization</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- returns the name of institution if found, otherwise returns the input institution code -->
    <xsl:function name="uwf:s5NameLookup" expand-text="yes">
        <xsl:param name="code5"/>
        <xsl:variable name="lowerCode5" select="lower-case($code5[1])"/>
        <xsl:variable name="lookup5Name" select="$lookup5Doc/key('normCode',$lowerCode5)/rdaad:P50375"/>
        <xsl:choose>
            <xsl:when test="$lookup5Name">
                <xsl:value-of select="$lookup5Name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$code5"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
<!-- $2 FUNCTIONS -->
    
    <!-- loc docs containing codes used in $2 for different fields -->
    <xsl:variable name="locSubjectSchemesDoc" select="document('lookup/lc/subjectSchemes.rdf')"/>
    <xsl:variable name="locGenreFormSchemesDoc" select="document('lookup/lc/genreFormSchemes.rdf')"/>
    <xsl:variable name="locFingerprintSchemesDoc" select="document('lookup/lc/fingerprintschemes.rdf')"/>
    <xsl:variable name="locIdentifiersDoc" select="document('lookup/lc/identifiers.rdf')"/>
    <xsl:variable name="locAccessRestrictionTermDoc" select="document('lookup/lc/accessrestrictionterm.rdf')"/>
    <xsl:variable name="locClassSchemesDoc" select="document('lookup/lc/classSchemes.rdf')"/>
    <xsl:variable name="locMusicCodeSchemesDoc" select="document('lookup/lc/musiccodeschemes.rdf')"/>
    <xsl:variable name="locNameTitleSchemesDoc" select="document('lookup/lc/nameTitleSchemes.rdf')"/>
    <xsl:variable name="approvedSourcesDoc" select="document('lookup/approvedSources.xml')"/>
    <xsl:variable name="locNationalBibSchemesDoc" select="document('lookup/lc/nationalbibschemes.rdf')"/>
    
    <xsl:key name="schemeKey" match="madsrdf:hasMADSSchemeMember" use="madsrdf:Authority/@rdf:about"/>
    <xsl:key name="codeKey" match="uwmisc:row" use="uwmisc:marc024Code | uwmisc:marc3XXCode"/>
    <xsl:key name="approvedKey" match="uwmisc:row" use="uwmisc:approved"/>
    
    <xsl:function name="uwf:s2EntityTest" expand-text="yes">
        <xsl:param name="sub2"/>
        <xsl:param name="type"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:value-of select="if (some $approvedType in $approvedSourcesDoc/uwmisc:root/uwmisc:row/key('codeKey', $code2)/uwmisc:approved
            satisfies (lower-case($type) = lower-case($approvedType))) then 'True' else 'False'"/>
    </xsl:function>
    
    <!-- uwf:s2Nomen returns the property "has scheme of nomen" with the appropriate IRI if it is found, otherwise it outputs a comment -->
    <xsl:function name="uwf:s2Nomen" expand-text="yes">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locFingerprintSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/fingerprintschemes/', lower-case($code2)))">
                <rdan:P80069>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/fingerprintschemes/', lower-case($code2))"/>
                    </xsl:attribute>
                </rdan:P80069>
            </xsl:when>
            <xsl:when test="$locSubjectSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/subjectSchemes/', lower-case($code2)))">
                <rdan:P80069>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/subjectSchemes/', lower-case($code2))"/>
                    </xsl:attribute>
                </rdan:P80069>
            </xsl:when>
            <xsl:when test="$locIdentifiersDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/identifiers/', lower-case($code2)))">
                <rdan:P80069>
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="concat('http://id.loc.gov/vocabulary/identifiers/', lower-case($code2))"/>
                    </xsl:attribute>
                </rdan:P80069>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <rdand:P80069>
                    <xsl:value-of select="$code2"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:s2NomenClassSchemes" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locClassSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/classSchemes/', lower-case($code2)))">
                <rdan:P80069 rdf:resource="{concat('http://id.loc.gov/vocabulary/classSchemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <rdand:P80069>
                    <xsl:value-of select="$code2"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:s2NomenNameTitleSchemes" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locNameTitleSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/nameTitleSchemes/', lower-case($code2)))">
                <rdan:P80069 rdf:resource="{concat('http://id.loc.gov/vocabulary/nameTitleSchemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <rdand:P80069>
                    <xsl:value-of select="$code2"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- lookup for field 015 -->   
    <xsl:function name="uwf:s2NationalBibSchemes" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:variable name="matchedcitation" select="key('schemeKey', concat('http://id.loc.gov/vocabulary/nationalbibschemes/', lower-case($code2)), $locNationalBibSchemesDoc)/madsrdf:Authority"/>
        <xsl:choose>
            <xsl:when test="$matchedcitation">
                <!-- Property with IRI -->
                <rdan:P80069 rdf:resource="{concat('http://id.loc.gov/vocabulary/nationalbibschemes/', lower-case($code2))}"/>
                <!-- Property with the textual citation from authoritative label -->
                <rdan:P80069>
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="$matchedcitation/madsrdf:authoritativeLabel"/>
                    <xsl:text>"</xsl:text>
                </rdan:P80069>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <rdand:P80069>
                    <xsl:value-of select="$code2"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- uwf:s2Concept looks up a scheme code and return the skos:inScheme with the associated IRI from id.loc.gov -->
    <!-- docs can be added as needed based on the sources of $2 from different fields -->
    <!-- if a field has a very small VES or only one, a separate function can be made to handle that field (see uwf:s2Concept506) -->
    <xsl:function name="uwf:s2Concept" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <!-- ind2 values from subject schemes -->
            <!-- hardcoding prevents speeds up lookup -->
            <xsl:when test="$code2 = 'lcsh'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/lcsh'}"/>
            </xsl:when>
            <xsl:when test="$code2 = 'cyac'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/cyac'}"/>
            </xsl:when>
            <xsl:when test="$code2 = 'mesh'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/mesh'}"/>
            </xsl:when>
            <xsl:when test="$code2 = 'nal'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/nal'}"/>
            </xsl:when>
            <xsl:when test="$code2 = 'cash'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/cash'}"/>
            </xsl:when>
            <xsl:when test="$code2 = 'rvm'">
                <skos:inScheme rdf:resource="{'https://id.loc.gov/vocabulary/subjectSchemes/rvm'}"/>
            </xsl:when>
            <!-- otherwise lookup code2 value -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$locSubjectSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/subjectSchemes/', lower-case($code2)))">
                        <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/subjectSchemes/', lower-case($code2))}"/>
                    </xsl:when>
                    <xsl:when test="$locGenreFormSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/genreFormSchemes/', lower-case($code2)))">
                        <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/genreFormSchemes/', lower-case($code2))}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                        <skos:inScheme>
                            <xsl:value-of select="$code2"/>
                        </skos:inScheme>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- lookup for field 506 concepts -->
    <!-- there's a very small vocabulary for this, so it's worth a separate quicker function -->
    <xsl:function name="uwf:s2Concept506" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locAccessRestrictionTermDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/accessrestrictionterm/', lower-case($code2)))">
                <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/accessrestrictionterm/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <skos:inScheme>
                    <xsl:value-of select="$code2"/>
                </skos:inScheme>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- lookup for field 041 concepts -->
    <xsl:function name="uwf:s2Concept041" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locAccessRestrictionTermDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/languageschemes/', lower-case($code2)))">
                <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/languageschemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <skos:inScheme>
                    <xsl:value-of select="$code2"/>
                </skos:inScheme>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- lookup for field 048 -->   
    <xsl:function name="uwf:s2MusicCodeSchemes" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:variable name="matchedcitation" select="key('schemeKey', concat('http://id.loc.gov/vocabulary/musiccodeschemes/', lower-case($code2)), $locMusicCodeSchemesDoc)/madsrdf:Authority"/>
        <xsl:choose>
            <xsl:when test="$matchedcitation">
                <!-- Property with IRI -->
                <rdan:P80069 rdf:resource="{concat('http://id.loc.gov/vocabulary/musiccodeschemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <rdand:P80069>
                    <xsl:value-of select="$code2"/>
                </rdand:P80069>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <!-- lookup for field 382 concepts -->
    <!-- there's a very small vocabulary for this, so it's worth a separate quicker function -->
    <xsl:function name="uwf:s2Concept382" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locMusicCodeSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/musiccodeschemes/', lower-case($code2)))">
                <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/musiccodeschemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <skos:inScheme>
                    <xsl:value-of select="$code2"/>
                </skos:inScheme>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- lookup for classification schemes -->
    <xsl:function name="uwf:s2ConceptClassSchemes" expand-text="true">
        <xsl:param name="sub2"/>
        <xsl:variable name="code2" select="replace($sub2, '\.$', '')"/>
        <xsl:choose>
            <xsl:when test="$locClassSchemesDoc/rdf:RDF/madsrdf:MADSScheme/key('schemeKey', concat('http://id.loc.gov/vocabulary/classSchemes/', lower-case($code2)))">
                <skos:inScheme rdf:resource="{concat('http://id.loc.gov/vocabulary/classSchemes/', lower-case($code2))}"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>IRI could not be found for {$code2}</xsl:comment>
                <skos:inScheme>
                    <xsl:value-of select="$code2"/>
                </skos:inScheme>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- lookup for classification scheme datatypes -->
    <xsl:variable name="lookupDatatypesDoc" select="document('lookup/lcSchemeDatatypes.xml')"/>
    <xsl:key name="normCode" match="row" use="LoC_and_MARC_vocabularies_ID"/>
    
    <xsl:function name="uwf:lcSchemeDatatype" expand-text="true">
        <xsl:param name="code"/>
        <xsl:variable name="datatype" select="$lookupDatatypesDoc/root/row[LoC_and_MARC_vocabularies_ID[ends-with(text(), '/'||$code)]]/item"/>
        <xsl:if test="$datatype">
            <xsl:attribute name="rdf:datatype">
                <xsl:value-of select="$datatype"/>  
            </xsl:attribute>
        </xsl:if>
    </xsl:function>
    
<!-- CONCEPT FUNCTIONS -->
    
    
    <!-- returns triples to fill an rdf:Description for a concept, with the prefLabel, scheme, and notation as provided -->
    <xsl:function name="uwf:fillConcept">
        <xsl:param name="prefLabel"/>
        <xsl:param name="scheme"/>
        <xsl:param name="notation"/>
        <xsl:param name="fieldNum"/>
        <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
        <xsl:if test="$prefLabel">
            <skos:prefLabel>
                <xsl:value-of select="uwf:stripEndPunctuation($prefLabel)"/>
            </skos:prefLabel>
        </xsl:if>
        <xsl:if test="$notation">
            <skos:notation>
                <xsl:copy-of select="uwf:lcSchemeDatatype($scheme)"/>
                <xsl:value-of select="$notation"/>
            </skos:notation>
        </xsl:if>
        <xsl:if test="$scheme">
            <xsl:choose>
                <xsl:when test="$fieldNum = '506'">
                    <xsl:copy-of select="uwf:s2Concept506($scheme)"/>
                </xsl:when> 
                <xsl:when test="$fieldNum = ('050', '084')">
                    <xsl:copy-of select="uwf:s2ConceptClassSchemes($scheme)"/>
                </xsl:when>
                <xsl:when test="$fieldNum = '382'">
                    <xsl:copy-of select="uwf:s2Concept382($scheme)"/>
                </xsl:when>
                <xsl:when test="$fieldNum = '041'">
                    <xsl:copy-of select="uwf:s2Concept041($scheme)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="uwf:s2Concept($scheme)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="uwf:fillClassConcept">
        <xsl:param name="scheme"/>
        <xsl:param name="notation"/>
        <xsl:param name="altLabel"/>
        <xsl:param name="fieldNum"/>
        <rdf:type rdf:resource="http://www.w3.org/2004/02/skos/core#Concept"/>
        <xsl:if test="$notation">
            <skos:notation>
                <xsl:copy-of select="uwf:lcSchemeDatatype($scheme)"/>
                <xsl:value-of select="$notation"/>
            </skos:notation>
        </xsl:if>
        <xsl:if test="$altLabel">
            <skos:altLabel>
                <xsl:value-of select="uwf:stripEndPunctuation($altLabel)"/>
            </skos:altLabel>
        </xsl:if>
        <xsl:if test="$scheme">
            <xsl:copy-of select="uwf:s2ConceptClassSchemes($scheme)"/>
        </xsl:if>
    </xsl:function>
    
<!-- subject headings -->
    <xsl:function name="uwf:ind2Thesaurus">
        <xsl:param name="ind2"/>
        <xsl:choose>
            <xsl:when test="$ind2 = '0'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/lcsh'"/>
            </xsl:when>
            <xsl:when test="$ind2 = '1'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/cyac'"/>
            </xsl:when>
            <xsl:when test="$ind2 = '2'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/mesh'"/>
            </xsl:when>
            <xsl:when test="$ind2 = '3'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/nal'"/>
            </xsl:when>
            <xsl:when test="$ind2 = '5'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/cash'"/>
            </xsl:when>
            <xsl:when test="$ind2 = '6'">
                <xsl:value-of select="'https://id.loc.gov/vocabulary/subjectSchemes/rvm'"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:getSubjectSchemeCode">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@ind2 = '0'">
                <xsl:value-of select="'lcsh'"/>
            </xsl:when>
            <xsl:when test="$field/@ind2 = '1'">
                <xsl:value-of select="'cyac'"/>
            </xsl:when>
            <xsl:when test="$field/@ind2 = '2'">
                <xsl:value-of select="'mesh'"/>
            </xsl:when>
            <xsl:when test="$field/@ind2 = '3'">
                <xsl:value-of select="'nal'"/>
            </xsl:when>
            <xsl:when test="$field/@ind2 = '5'">
                <xsl:value-of select="'cash'"/>
            </xsl:when>
            <xsl:when test="$field/@ind2 = '6'">
                <xsl:value-of select="'rvm'"/>
            </xsl:when>
            <!-- @ind2 = 7 or blank -->
            <xsl:otherwise>
                <xsl:if test="$field/marc:subfield[@code = '2']">
                    <xsl:value-of select="$field/marc:subfield[@code = '2'][1]"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
<!-- RDA source vocabularies lookup functions -->
    
    <!-- These functions use rdaVocabularies.xml to retrieve an rda or id.loc.gov document 
        based on a $2 code that begins with 'rda'
        these documents can then be used to match terms and codes from rda vocabularies to their IRIs-->
    <xsl:variable name="lookupRdaDoc" select="document('lookup/rdaVocabularies.xml')"/>
    <xsl:key name="sourceCode" match="uwmisc:row" use="uwmisc:sourceCode"/>
    <xsl:key name="vocabName" match="uwmisc:row" use="uwmisc:vocabulary"/>
    <xsl:key name="rdaTerm" match="skos:Concept" use="skos:prefLabel"/>
    <xsl:key name="lcTerm" match="madsrdf:Authority" use="madsrdf:authoritativeLabel"/>
    <xsl:key name="rdaCode" match="skos:Concept" use="@rdf:about"/>
    <xsl:key name="lcCode" match="madsrdf:Authority" use="@rdf:about"/>
    <xsl:key name="rdaIRI" match="skos:Concept" use="@rdf:about"/>
    <xsl:key name="lcIRI" match="uwmisc:entry" use="uwmisc:locURI"/>
    <xsl:key name="lcTermOrCode" match="uwmisc:entry" use="uwmisc:locCode|uwmisc:locTerm"/>
    
    <!-- If it's a term, a lookup needs to be done to find the IRI -->
    <xsl:function name="uwf:rdaTermLookup" expand-text="yes">
        <xsl:param name="rda2"/>
        <xsl:param name="term"/>
        <xsl:choose>
            <xsl:when test="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('sourceCode', $rda2)">
                <xsl:variable name="lookupDoc" select="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('sourceCode', $rda2)/uwmisc:lookupDoc/@iri"/>
                <xsl:choose>
                    <xsl:when test="contains($lookupDoc, 'lc/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority/key('lcTerm', $term)">
                            <xsl:value-of select="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority/key('lcTerm', $term)/@rdf:about"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($lookupDoc, 'rda/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/skos:Concept/key('rdaTerm', $term)">
                            <xsl:value-of select="document($lookupDoc)/rdf:RDF/skos:Concept/key('rdaTerm', $term)/@rdf:about"/>
                        </xsl:if>   
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise rda term not in rdaVocabularies.xml, cannot lookup term -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <!-- If there's a code, we are checking that the resulting IRI exists -->
    <xsl:function name="uwf:rdaCodeLookup" expand-text="yes">
        <xsl:param name="rda2"/>
        <xsl:param name="code"/>
        <xsl:choose>
            <xsl:when test="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('sourceCode', $rda2)">
                <xsl:variable name="lookupRow" select="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('sourceCode', $rda2)"/>
                <xsl:variable name="lookupDoc" select="$lookupRow/uwmisc:lookupDoc/@iri"/>
                <xsl:variable name="baseLookupIRI" select="$lookupRow/uwmisc:baseIRI/@iri"/>
                <xsl:variable name="codeIRI"
                    select="$baseLookupIRI||$code"/>
                <xsl:choose>
                    <xsl:when test="contains($lookupDoc, 'lc/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority/key('lcCode', $codeIRI)">
                            <xsl:value-of select="$codeIRI"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($lookupDoc, 'rda/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/skos:Concept/key('rdaCode', $codeIRI)">
                            <xsl:value-of select="$codeIRI"/>
                        </xsl:if>   
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdaIRILookup-33X" expand-text="yes">
        <xsl:param name="givenIRI"/>
        <xsl:choose>
            <xsl:when test="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)">
                <rdaeo:P20001 rdf:resource="{$givenIRI}"/>
                <rdaeo:P10349 rdf:resource="{$givenIRI}"/>
            </xsl:when>
            <xsl:when test="document('lookup/rda/RDAMediaType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)">
                <rdamo:P30002 rdf:resource="{$givenIRI}"/>
            </xsl:when>
            <xsl:when test="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)">
                <rdamo:P30001 rdf:resource="{$givenIRI}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:lcIRILookup-33X" expand-text="yes">
        <xsl:param name="givenIRI"/>
        <xsl:choose>
            <xsl:when test="document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)">
                <rdaeo:P20001 rdf:resource="{document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaIRI}"/>
                <rdaeo:P10349 rdf:resource="{document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaIRI}"/>
            </xsl:when>
            <xsl:when test="document('lookup/Lookup337.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)">
                <rdamo:P30002 rdf:resource="{document('lookup/Lookup337.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaIRI}"/>
            </xsl:when>
            <xsl:when test="document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)">
                <rdamo:P30001 rdf:resource="{document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaIRI}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdalcTermCodeLookup-33X" expand-text="yes">
        <xsl:param name="givenTermOrCode"/>
        <xsl:param name="tag33X"/>
        <xsl:choose>
            <!-- four numerical characters means in an RDA code -->
            <xsl:when test="matches($givenTermOrCode, '^\d\d\d\d$')">
                <xsl:choose>
                    <xsl:when test="$tag33X = '336' and document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDAContentType/', $givenTermOrCode))">
                        <rdaeo:P20001 rdf:resource="{concat('http://rdaregistry.info/termList/RDAContentType/', $givenTermOrCode)}"/>
                        <rdawo:P10349 rdf:resource="{concat('http://rdaregistry.info/termList/RDAContentType/', $givenTermOrCode)}"/>
                    </xsl:when>
                    <xsl:when test="$tag33X = '337' and document('lookup/rda/RDACMediaType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDAMediaType/', $givenTermOrCode))">
                        <rdamo:P30002 rdf:resource="{concat('http://rdaregistry.info/termList/RDAMediaType/', $givenTermOrCode)}"/>
                    </xsl:when>
                    <xsl:when test="$tag33X = '338' and document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDACarrierType/', $givenTermOrCode))">
                        <rdamo:P30001 rdf:resource="{concat('http://rdaregistry.info/termList/RDACarrierType/', $givenTermOrCode)}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise check for rdaTerm, then lcTerm or lcCode -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- RDA Content Type Term -->
                    <xsl:when test="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)">
                        <rdaeo:P20001 rdf:resource="{document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/@rdf:about}"/>
                        <rdawo:P10349 rdf:resource="{document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/@rdf:about}"/>
                    </xsl:when>
                    <!-- RDA Media Type Term -->
                    <xsl:when test="document('lookup/rda/RDAMediaType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)">
                        <rdamo:P30002 rdf:resource="{document('lookup/rda/RDAMediaType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/@rdf:about}"/>
                    </xsl:when>
                    <!-- RDA Carrier Type Term -->
                    <xsl:when test="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)">
                        <rdamo:P30001 rdf:resource="{document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/@rdf:about}"/>
                    </xsl:when>
                    <!-- LC Content Type Term or Code -->
                    <xsl:when test="document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)">
                        <rdaeo:P20001 rdf:resource="{document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaIRI}"/>
                        <rdawo:P10349 rdf:resource="{document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaIRI}"/>
                    </xsl:when>
                    <!-- LC Media Type Term or Code -->
                    <xsl:when test="document('lookup/Lookup337.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)">
                        <rdamo:P30002 rdf:resource="{document('lookup/Lookup337.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaIRI}"/>
                    </xsl:when>
                    <!-- LC Carrier Type Term or Code -->
                    <xsl:when test="document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)">
                        <rdamo:P30001 rdf:resource="{document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaIRI}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdaIRILookupForAP" expand-text="yes">
        <xsl:param name="givenIRI"/>
        <xsl:param name="entityType"/>
        <xsl:choose>
            <xsl:when test="$entityType = 'expression' and document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)">
                <term>
                    <xsl:value-of select="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)/skos:prefLabel[@xml:lang = 'en']"/>
                </term>
            </xsl:when>
            <xsl:when test="$entityType = 'manifestation' and document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)">
                <term>
                    <xsl:value-of select="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaIRI', $givenIRI)/skos:prefLabel[@xml:lang = 'en']"/>
                </term>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:lcIRILookupForAP">
        <xsl:param name="givenIRI"/>
        <xsl:param name="entityType"/>
        <xsl:choose>
            <xsl:when test="$entityType = 'expression'and document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)">
                <term>
                    <xsl:value-of select="document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaTerm"/>
                </term>
            </xsl:when>
            <xsl:when test="$entityType = 'manifestation' and document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)">
                <term>
                    <xsl:value-of select="document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcIRI', $givenIRI)/uwmisc:rdaTerm"/>
                </term>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdalcTermCodeLookupForAP" expand-text="yes">
        <xsl:param name="givenTermOrCode"/>
        <xsl:param name="entityType"/>
        <xsl:choose>
            <!-- four numerical characters means in an RDA code -->
            <xsl:when test="matches($givenTermOrCode, '^\d\d\d\d$')">
                <xsl:choose>
                    <xsl:when test="$entityType = 'expression' and document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDAContentType/', $givenTermOrCode))">
                        <term>
                            <xsl:value-of select="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDAContentType/', $givenTermOrCode))/skos:prefLabel[@xml:lang = 'en']"/>
                        </term>
                    </xsl:when>
                    <xsl:when test="$entityType = 'manifestation' and document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDACarrierType/', $givenTermOrCode))">
                        <term>
                            <xsl:value-of select="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaCode', concat('http://rdaregistry.info/termList/RDACarrierType/', $givenTermOrCode))/skos:prefLabel[@xml:lang = 'en']"/>
                        </term>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <!-- otherwise check for rdaTerm, then lcTerm or lcCode -->
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$entityType = 'expression'">
                        <xsl:choose>
                            <!-- RDA Content Type Term -->
                            <xsl:when test="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)">
                                <term>
                                    <xsl:value-of select="document('lookup/rda/RDAContentType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/skos:prefLabel[@xml:lang = 'en']"/>
                                </term>
                            </xsl:when>
                            <!-- LC Content Type Term or Code -->
                            <xsl:when test="document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)">
                                <term>
                                    <xsl:value-of select="document('lookup/Lookup336.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaTerm"/>
                                </term>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$entityType = 'manifestation'">
                        <xsl:choose>
                            <!-- RDA Carrier Type Term -->
                            <xsl:when test="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)">
                                <term>
                                    <xsl:value-of select="document('lookup/rda/RDACarrierType.xml')/rdf:RDF/skos:Concept/key('rdaTerm', $givenTermOrCode)/skos:prefLabel[@xml:lang = 'en']"/>
                                </term>
                            </xsl:when>
                            <!-- LC Carrier Type Term or Code -->
                            <xsl:when test="document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)">
                                <term>
                                    <xsl:value-of select="document('lookup/Lookup338.xml')/uwmisc:lookupTable/uwmisc:entry/key('lcTermOrCode', $givenTermOrCode)/uwmisc:rdaTerm"/>
                                </term>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdaGetTerm336">
        <xsl:param name="rda2"/>
        <xsl:param name="value"/>
        <xsl:variable name="lookupDoc">
            <xsl:choose>
                <xsl:when test="$rda2 = 'rdacontent'">
                    <xsl:value-of select="'lookup/lc/contentTypes.rdf'"/>
                </xsl:when>
                <xsl:when test="$rda2 = 'rdaco'">
                    <xsl:value-of select="'lookup/rda/RDAContentType.xml'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($lookupDoc, 'lc/')">
                <xsl:value-of select="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority[ends-with(@rdf:about, $value)]/madsrdf:authoritativeLabel"/>
            </xsl:when>
            <xsl:when test="contains($lookupDoc, 'rda/')">
                <xsl:value-of select="document($lookupDoc)/rdf:RDF/skos:Concept[ends-with(@rdf:about, $value)]/skos:prefLabel[@xml:lang='en']"/> 
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:rdaGetTerm338">
        <xsl:param name="rda2"/>
        <xsl:param name="value"/>
        <xsl:variable name="lookupDoc">
            <xsl:choose>
                <xsl:when test="$rda2 = 'rdacarrier'">
                    <xsl:value-of select="'lookup/lc/carriers.rdf'"/>
                </xsl:when>
                <xsl:when test="$rda2 = 'rdact'">
                    <xsl:value-of select="'lookup/rda/RDACarrierType.xml'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($lookupDoc, 'lc/')">
                <xsl:value-of select="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority[ends-with(@rdf:about, $value)]/madsrdf:authoritativeLabel"/>
            </xsl:when>
            <xsl:when test="contains($lookupDoc, 'rda/')">
                <xsl:value-of select="document($lookupDoc)/rdf:RDF/skos:Concept[ends-with(@rdf:about, $value)]/skos:prefLabel[@xml:lang='en']"/> 
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:lcTermLookup" expand-text="yes">
        <xsl:param name="vocabName"/>
        <xsl:param name="term"/>
        <xsl:choose>
            <xsl:when test="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('vocabName', $vocabName)">
                <xsl:variable name="lookupDoc" select="$lookupRdaDoc/uwmisc:root/uwmisc:row/key('vocabName', $vocabName)/uwmisc:lookupDoc/@iri"/>
                <xsl:choose>
                    <xsl:when test="contains($lookupDoc, 'lc/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority/key('lcTerm', $term)">
                            <xsl:value-of select="document($lookupDoc)/rdf:RDF/madsrdf:MADSScheme/madsrdf:hasMADSSchemeMember/madsrdf:Authority/key('lcTerm', $term)/@rdf:about"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="contains($lookupDoc, 'rda/')">
                        <xsl:if test="document($lookupDoc)/rdf:RDF/skos:Concept/key('rdaTerm', $term)">
                            <xsl:value-of select="document($lookupDoc)/rdf:RDF/skos:Concept/key('rdaTerm', $term)/@rdf:about"/>
                        </xsl:if>   
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:lcLangCodeToLabel" expand-text="yes">
        <xsl:param name="code"/>
        <xsl:variable name="langIRI" select="'http://id.loc.gov/vocabulary/languages/'||$code"/>
        <xsl:variable name="nameFile" select="document('lookup/lc/languages.rdf')"/>
        <xsl:value-of select="$nameFile//madsrdf:authoritativeLabel[@xml:lang='en'][parent::madsrdf:Authority/@rdf:about=$langIRI]"/>
    </xsl:function>
    
    <!-- POSSIBLE BREAK POINT !!!!  If we query LC too much we may get denied -->
    <xsl:function name="uwf:lcNamesToGeographicAreas" expand-text="yes">
        <xsl:param name="nameIRI"/>
        <xsl:variable name="nameFile" select="document(concat($nameIRI, '.rdf'))"/>
        <xsl:value-of select="$nameFile//madsrdf:code[@rdf:datatype = 'http://id.loc.gov/datatypes/codes/gac']"/>
    </xsl:function>
    
<!-- string functions -->
    <!-- strips ending commas. If a period is present, it determines whether that should be stripped. -->
    <xsl:function name="uwf:stripEndPunctuation">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="ends-with(normalize-space($string), ',')">
                <xsl:value-of select="normalize-space(substring($string, 1, string-length($string) - 1))"/>
            </xsl:when>
            <xsl:when test="ends-with(normalize-space($string), '.')">
                <xsl:choose>
                    <xsl:when test="matches($string, ' [\w]\.$')">
                        <xsl:value-of select="normalize-space($string)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="uwf:checkAbbreviations(normalize-space($string)) = true()">
                                <xsl:value-of select="normalize-space($string)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(substring($string, 1, string-length($string) - 1))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space($string)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:stripAllPunctuation">
        <xsl:param name="conceptString"/>
        <xsl:value-of select="lower-case($conceptString) => translate(' ', '') => translate('.;,:/()[]{}+', '')"/>
    </xsl:function>
    
    <xsl:function name="uwf:testBrackets">
        <xsl:param name="string"/>
        <xsl:choose>
            <!-- opening and closing bracket -->
            <xsl:when test="matches($string, '^\[.*\][\W=]*$')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- opening bracket, no closing bracket -->
            <xsl:when test="matches($string, '^\[[^\]]*$')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <!-- closing bracket, no opening bracket -->
            <xsl:when test="matches($string, '^[^\[]*\][\W=]*$')">
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:removeBrackets">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="uwf:testBrackets($string) = true()">
                <xsl:choose>
                    <xsl:when test="matches($string, '^\[.*\][\W=]*$')">
                        <xsl:value-of select="replace($string, '(^\[)|(\])([\W=]*$)', '$3') => normalize-space()"/>
                    </xsl:when>
                    <xsl:when test="matches($string, '^\[[^\]]*$')">
                        <xsl:value-of select="replace($string, '^\[', '') => normalize-space()"/>
                    </xsl:when>
                    <xsl:when test="matches($string, '^[^\[]*\][\W=]*$')">
                        <xsl:value-of select="replace($string, '(\])([\W=]*$)', '$2') => normalize-space()"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="normalize-space($string)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:getBracketedData">
        <xsl:param name="string"/>
        <xsl:choose>
            <xsl:when test="matches($string, '^\[.*\][\W=]*$')">
                <xsl:analyze-string select="$string" regex="\[.*\]">
                    <xsl:matching-substring>
                        <xsl:value-of select="replace(normalize-space(.), '(^\[)(.*)(\]$)', '&#34;$2&#34;')"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches($string, '^\[[^\]]*$')">
                <xsl:analyze-string select="$string" regex="((^\[)([^\[].*))">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat(replace(normalize-space(.), '\s*[=:;/]$', ''), '&#34;')"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="matches($string, '^[^\[]*\][\W=]*$')">
                <xsl:analyze-string select="$string" regex="(([^\[].*)(\][\W]*$))">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat('&#34;', replace(normalize-space(.), '(\])([\W=]*$)', '&#34;'))"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:checkAbbreviations">
        <xsl:param name="string"/>
        <xsl:variable name="lookupAbbreviationsDoc" select="document('lookup/abbreviations.xml')"/>
        <xsl:value-of select="if (some $row in $lookupAbbreviationsDoc/root/row
            satisfies (ends-with(lower-case($string), $row))) then true() else false()"/>
    </xsl:function>
    
</xsl:stylesheet>

