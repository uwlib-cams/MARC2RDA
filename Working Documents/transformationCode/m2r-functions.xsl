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
        <xsl:variable name="lowerCode5" select="lower-case($code5)"/>
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
    <xsl:variable name="locNameTitleSchemesDoc" select="document('lookup/lc/nameTitleSchemes.rdf')"/>
    <xsl:variable name="approvedSourcesDoc" select="document('lookup/approvedSources.xml')"/>
    
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
    
    <!-- lookup for field 506 concepts -->
    <!-- there's a very small vocabulary for this, so it's worth a separate quicker function -->
    <!--<xsl:function name="uwf:s2Concept382" expand-text="true">
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
    </xsl:function>-->
    
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
                <xsl:when test="$fieldNum = '050'">
                    <xsl:copy-of select="uwf:s2ConceptClassSchemes($scheme)"/>
                </xsl:when>
                <!--<xsl:when test="$fieldNum = '382'">
                    <xsl:copy-of select="uwf:s2Concept382($scheme)"/>
                </xsl:when>-->
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
    <!-- strips ending commas and ending ISBD punctuation. If a period is present, it determines whether that should be stripped. -->
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
    
<!-- ACCESS POINTS -->
    
    <!-- identifier for the MARC record, used in main manifestation IRI -->
    <xsl:function name="uwf:recordIdentifier" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']]">
                <xsl:choose>
                    <xsl:when test="$record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = '2']">
                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = '2'])
                            ||normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'lac'
                            ||normalize-space($record/marc:datafield[@tag = '016'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag = '035'][marc:subfield[@code = 'a'][starts-with(., '(OCoLC)')]]">
                <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '035'][marc:subfield[@code = 'a'][starts-with(., '(OCoLC)')]][1]/marc:subfield[@code = 'a'][starts-with(., '(OCoLC)')][1])"/>
            </xsl:when>
            <xsl:when test="$record/marc:datafield[@tag = '010'][marc:subfield[@code = 'a']]">
                <xsl:value-of select="'lccn'||normalize-space($record/marc:datafield[@tag = '010'][marc:subfield[@code = 'a']][1]/marc:subfield[@code = 'a'][1])"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- get carrier type from MARC record -->
    <xsl:function name="uwf:carrierType">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '338']">
                <xsl:for-each select="$record/marc:datafield[@tag = '338']">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'a']">
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'b'] and (marc:subfield[@code = '2'] = 'rdact' or marc:subfield[@code = '2'] = 'rdacarrier')">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:value-of select="uwf:rdaGetTerm338(../marc:subfield[@code = '2'], .)"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- get content type from MARC record -->
    <xsl:function name="uwf:contentType">
        <xsl:param name="record"/>
        <xsl:choose>
            <xsl:when test="$record/marc:datafield[@tag = '336']">
                <xsl:for-each select="$record/marc:datafield[@tag = '336']">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'a']">
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = 'b'] and (marc:subfield[@code = '2'] = 'rdaco' or marc:subfield[@code = '2'] = 'rdacontent')">
                            <xsl:for-each select="marc:subfield[@code = 'b']">
                                <xsl:value-of select="uwf:rdaGetTerm336(../marc:subfield[@code = '2'], .)"/>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:process245">
        <xsl:param name="record"/>
        <xsl:variable name="copy245">
            <xsl:copy select="$record/marc:datafield[@tag = '245']">
                <xsl:copy select="./@tag"/>
                <xsl:for-each select="child::*">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <marc:subfield>
                                <xsl:attribute name="code" select="./@code"/>
                                <xsl:value-of select="uwf:stripEndPunctuation(.)"/>
                            </marc:subfield>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:copy>
        </xsl:variable>
        <xsl:variable name="isISBD">
            <xsl:choose>
                <xsl:when test="(substring($record/marc:leader, 19, 1) = 'i' or substring($record/marc:leader, 19, 1) = 'a')">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$copy245/marc:datafield">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = 'a']">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = 'a'][not(following-sibling::*)] or
                            marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's']) or 
                            (marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]
                            and marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                            <xsl:for-each select="marc:subfield[@code='a']">
                                <xsl:choose>
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="uwf:removeBrackets(.)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="title">
                                <xsl:choose>
                                    <!-- remove ISBD punctuation if ISBD -->
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space(marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>                                    
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="uwf:removeBrackets(marc:subfield[@code = 'a'])"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="uwf:removeBrackets(.)"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="title">
                        <xsl:choose>
                            <xsl:when test="marc:subfield[@code = 'c']">
                                <xsl:value-of select="marc:subfield[@code = 'c']/preceding-sibling::*" separator=" "/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="marc:subfield" separator=" "/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:removeBrackets($title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <!-- generates an access point for an agent based on the subfields present in the field -->
    <xsl:function name="uwf:agentAccessPoint" expand-text="true">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '100' or $field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]00'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'j'] | $field/marc:subfield[@code = 'q']
                        | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '720' or ($field/@tag = '880' and contains($field/marc:subfield[@code = '6'], '720'))">
                <xsl:value-of select="uwf:stripEndPunctuation($field/marc:subfield[@code = 'a'])"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '110' or $field/@tag = '610' or $field/@tag = '710' or $field/@tag = '810'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]10'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '111' or $field/@tag = '611' or $field/@tag = '711' or $field/@tag = '811'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[1678]11'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a']  | $field/marc:subfield[@code = 'c'] | $field/marc:subfield[@code = 'e'] | $field/marc:subfield[@code = 'q']
                        | $field/marc:subfield[@code = 'u'] | $field/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $field/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $field/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- generates an access point for a related work based on the subfields present in the field -->
    <!-- may need updates -->
    <xsl:function name="uwf:relWorkAccessPoint" expand-text="true">
        <xsl:param name="field"/>
        <xsl:choose>
            <xsl:when test="$field/@tag = '600' or $field/@tag = '700' or $field/@tag = '800'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]00'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '610' or $field/@tag = '710' or $field/@tag = '810'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]10'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '611' or $field/@tag = '711' or $field/@tag = '811'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]11'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'b'] | $field/marc:subfield[@code = 'c']
                        | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'j'] 
                        | $field/marc:subfield[@code = 'k'] |$field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] |$field/marc:subfield[@code = 'n'] 
                        | $field/marc:subfield[@code = 'o'] | $field/marc:subfield[@code = 'p'] 
                        | $field/marc:subfield[@code = 'q'] | $field/marc:subfield[@code = 'u'] 
                        | $field/marc:subfield[@code = 't'] | $field/marc:subfield[@code = 'r']
                        | $field/marc:subfield[@code = 's']" 
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '630' or $field/@tag = '730' or $field/@tag = '830'
                or ($field/@tag = '880' and matches($field/marc:subfield[@code = '6'], '[678]30'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a'] | $field/marc:subfield[@code = 'd'] | $field/marc:subfield[@code = 'f'] 
                        | $field/marc:subfield[@code = 'g'] | $field/marc:subfield[@code = 'k'] | $field/marc:subfield[@code = 'l'] 
                        | $field/marc:subfield[@code = 'm'] | $field/marc:subfield[@code = 'n'] | $field/marc:subfield[@code = 'o']
                        | $field/marc:subfield[@code = 'p'] | $field/marc:subfield[@code = 'r'] | $field/marc:subfield[@code = 's']
                        | $field/marc:subfield[@code = 't']"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <xsl:when test="$field/@tag = '440'
                or ($field/@tag = '880' and starts-with($field/marc:subfield[@code = '6'], '440'))">
                <xsl:variable name="ap">
                    <xsl:value-of select="$field/marc:subfield[@code = 'a']
                        | $field/marc:subfield[@code = 'n']
                        | $field/marc:subfield[@code = 'p']"
                        separator=" "/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the main work access point -->
    <xsl:function name="uwf:mainWorkAccessPoint">
        <xsl:param name="record"/>
        <xsl:choose>
            <!-- 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 100 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 110 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- 111 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="ap">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
            <!-- just 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <xsl:variable name="ap">
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:value-of select="uwf:stripEndPunctuation($ap)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the aggregating work access point. -->
    <xsl:function name="uwf:aggWorkAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
        <xsl:variable name="lang" select="uwf:lcLangCodeToLabel($langCode)"/>
        <xsl:variable name="contentType" select="uwf:contentType($record)"/>
        <xsl:variable name="name7XX">
            <xsl:variable name="first7XX" select="$record/marc:datafield[@tag = '700' or @tag = '710' or @tag = '711'][1]"/>
            <xsl:choose>
                <xsl:when test="$first7XX/@tag = '700'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                        | $first7XX/marc:subfield[@code = 'd'] | $first7XX/marc:subfield[@code = 'j'] | $first7XX/marc:subfield[@code = 'q']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
                <xsl:when test="$first7XX/@tag = '710'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a'] | $first7XX/marc:subfield[@code = 'b'] | $first7XX/marc:subfield[@code = 'c']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
                <xsl:when test="$first7XX/@tag = '711'">
                    <xsl:value-of select="$first7XX/marc:subfield[@code = 'a']  | $first7XX/marc:subfield[@code = 'c'] | $first7XX/marc:subfield[@code = 'e'] | $first7XX/marc:subfield[@code = 'q']
                        | $first7XX/marc:subfield[@code = 'u'] | $first7XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $first7XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first7XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="language">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||' '||$name7XX||$language"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                    <xsl:text> Aggregating work</xsl:text>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="name1XX">
                    <xsl:variable name="first1XX" select="$record/marc:datafield[@tag = '100' or @tag = '110' or @tag = '111'][1]"/>
                    <xsl:choose>
                        <xsl:when test="$first1XX[marc:subfield[@code = 'e'][matches(lower-case(.), 'aggregator|compiler')]]
                            or $first1XX[marc:subfield[@code = 'e'][matches(., '(w/P)(10538)|(10585)|(10444)|(10542)|(10589)|(10448)$')]]">
                            <xsl:choose>
                                <xsl:when test="$first1XX/@tag = '100'">
                                    <xsl:value-of select="$first1XX/marc:subfield[@code = 'a'] | $first1XX/marc:subfield[@code = 'b'] | $first1XX/marc:subfield[@code = 'c']
                                        | $first1XX/marc:subfield[@code = 'd'] | $first1XX/marc:subfield[@code = 'j'] | $first1XX/marc:subfield[@code = 'q']
                                        | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                        separator=" "/>
                                </xsl:when>
                                <xsl:when test="$first1XX/@tag = '110'">
                                    <xsl:value-of select="$first1XX/marc:subfield[@code = 'a'] | $first1XX/marc:subfield[@code = 'b'] | $first1XX/marc:subfield[@code = 'c']
                                        | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                        | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first1XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                        separator=" "/>
                                </xsl:when>
                                <xsl:when test="$first1XX/@tag = '111'">
                                    <xsl:value-of select="$first1XX/marc:subfield[@code = 'a']  | $first1XX/marc:subfield[@code = 'c'] | $first1XX/marc:subfield[@code = 'e'] | $first1XX/marc:subfield[@code = 'q']
                                        | $first1XX/marc:subfield[@code = 'u'] | $first1XX/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                                        | $first1XX/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $first1XX/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                                        separator=" "/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <!-- 240 -->
                    <xsl:when test="$record/marc:datafield[@tag = '240']">
                        <xsl:variable name="workSubfields">
                            <xsl:if test="$name1XX != ''">
                                <xsl:value-of select="$name1XX"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                        </xsl:variable>
                        <xsl:variable name="language">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>. {$lang}</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of select="$workSubfields||' '||$name7XX||$language||' Aggregating work'"/>
                    </xsl:when>
                    <xsl:when test="$record/marc:datafield[@tag = '245']">
                        <xsl:variable name="workSubfields">
                            <xsl:if test="$name1XX != ''">
                                <xsl:value-of select="$name1XX"/>
                                <xsl:text> </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="uwf:process245($record)"/>
                        </xsl:variable>
                        <xsl:variable name="fullAP">
                            <xsl:value-of select="$workSubfields||' '||$name7XX||' '||$lang"/>
                            <xsl:if test="$contentType != ''">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="$contentType"/>
                            </xsl:if>
                            <xsl:text> Aggregating work</xsl:text>
                        </xsl:variable>
                        <xsl:value-of select="$fullAP"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- Determines the main expression access point. -->
    <xsl:function name="uwf:mainExpressionAccessPoint" expand-text="yes">
        <xsl:param name="record"/>
        <xsl:variable name="langCode" select="$record/marc:controlfield[@tag = '008'][1]/substring(text(), 36, 3)"/>
        <xsl:variable name="lang" select="uwf:lcLangCodeToLabel($langCode)"/>
        <xsl:variable name="contentType" select="uwf:contentType($record)"/>
        <xsl:choose>
            <!-- 130 -->
            <xsl:when test="$record/marc:datafield[@tag = '130']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '130']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '130']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '130']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 240 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and $record/marc:datafield[@tag = '240']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'a']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'd']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'k'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'n'] 
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'p']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 't']
                        | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'g']"/>
                </xsl:variable>
                <xsl:variable name="expSubfields">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                            or $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']">
                            <xsl:value-of select="$record/marc:datafield[@tag = '240']/marc:subfield[@code = 'f']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'l']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'm']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'o']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 'r']
                                | $record/marc:datafield[@tag = '240']/marc:subfield[@code = 's']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>. {$lang}</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||$expSubfields"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 100 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '100'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '100']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'd'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'j'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '100']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||'. '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 110 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '110'] and $record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '110']/marc:subfield[@code = 'a'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'b'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'c']
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '110']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||'. '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- 111 + 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '111'] and$record/marc:datafield[@tag = '245']">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="$record/marc:datafield[@tag = '111']/marc:subfield[@code = 'a']  | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'c'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'e'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'q']
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'u'] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'd'][not(preceding-sibling::marc:subfield[@code='t'])]
                        | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'g'][not(preceding-sibling::marc:subfield[@code='t'])] | $record/marc:datafield[@tag = '111']/marc:subfield[@code = 'n'][not(preceding-sibling::marc:subfield[@code='t'])]"
                        separator=" "/>
                    <xsl:text>. </xsl:text>
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||'. '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
            <!-- only 245 -->
            <xsl:when test="$record/marc:datafield[@tag = '245'] 
                and not($record/marc:datafield[@tag = '100'] or $record/marc:datafield[@tag = '110'] or $record/marc:datafield[@tag = '111'])">
                <xsl:variable name="workSubfields">
                    <xsl:value-of select="uwf:process245($record)"/>
                </xsl:variable>
                <xsl:variable name="fullAP">
                    <xsl:value-of select="$workSubfields||'. '||$lang"/>
                    <xsl:if test="$contentType != ''">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$contentType"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$fullAP"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="uwf:mainManifestationAccessPoint"  expand-text="yes">
        <xsl:param name="record"/>
        
        <!-- same logic as F245 mapping to title proper -->
        <xsl:variable name="titleProper">
            <xsl:variable name="isISBD">
                <xsl:choose>
                    <xsl:when test="(substring($record/marc:leader, 19, 1) = 'i' or substring($record/marc:leader, 19, 1) = 'a')">
                        <xsl:value-of select="true()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="false()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a'][not(following-sibling::*)] or
                            $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/not(following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's']) or 
                            ($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[1][not(@code = 'n' or @code = 'p' or @code = 's')]
                            and $record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][preceding-sibling::marc:subfield[@code = 'b'][contains(text(), ' = ')]])">
                            <xsl:choose>
                                <!-- remove ending = : ; / if ISBD-->
                                <!-- remove any square brackets [] -->
                                <xsl:when test="$isISBD = true()">
                                    <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                </xsl:when>
                                <!-- remove any square brackets [] if not ISBD -->
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!-- a with following n, p, s either before or after a b with other title info -->
                        <xsl:otherwise>
                            <!-- put together title from a and any directly following n, p, s fields -->
                            <!-- remove ending = : ; / -->
                            <xsl:variable name="title">
                                <xsl:choose>
                                    <!-- remove ISBD punctuation if ISBD -->
                                    <xsl:when test="$isISBD = true()">
                                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => replace('\s*[=:;/]$', '') => uwf:removeBrackets()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space($record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']) => uwf:removeBrackets()"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'a']/following-sibling::marc:subfield[@code = 'n' or @code = 'p' or @code = 's'][not(preceding-sibling::marc:subfield[contains(text(), ' = ') or ends-with(text(), ' =')])]">
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!-- remove any square brackets -->
                            <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                            <!-- if square brackets [] were removed, add not on manifestation -->
                        </xsl:otherwise>
                    </xsl:choose>    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="title">
                        <xsl:choose>
                            <xsl:when test="$isISBD = true()">
                                <xsl:choose>
                                    <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']/preceding-sibling::*">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield">
                                            <xsl:value-of select="normalize-space(.) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield[@code = 'c']/preceding-sibling::*">
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="$record/marc:datafield[@tag = '245']/marc:subfield">
                                            <xsl:value-of select="normalize-space(.) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                                            <xsl:if test="position() != last()">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:choose>
                        <!-- remove ISBD punctuation if ISBD -->
                        <xsl:when test="$isISBD = true()">
                            <xsl:value-of select="normalize-space($title) => replace('\s*[=:;/]$', '') => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($title) => replace('\[sic\]', '') => uwf:removeBrackets()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="manifDate">
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']]">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/position() lt $record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][1]/position()">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'c']]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '4'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'c']][1]/marc:subfield[@code = 'c']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="manifName">
            <xsl:choose>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']]">
                    <xsl:choose>
                        <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]">
                            <xsl:choose>
                                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/position() lt $record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']][1]/position()">
                                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '1'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '260'][marc:subfield[@code = 'b']]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '0'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '3'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
                <xsl:when test="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'b']]">
                    <xsl:value-of select="$record/marc:datafield[@tag = '264'][@ind2 = '2'][marc:subfield[@code = 'b']][1]/marc:subfield[@code = 'b']"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="carrierType">
            <xsl:value-of select="uwf:carrierType($record)"/>
        </xsl:variable>
        
        <xsl:variable name="fullAP">
            <xsl:value-of select="$titleProper||' '||$manifDate||' '||$manifName"/>
            <xsl:if test="$carrierType != ''">
                <xsl:value-of select="$carrierType"/>
            </xsl:if>
        </xsl:variable>
        <xsl:value-of select="uwf:stripEndPunctuation($fullAP)"/>
    </xsl:function>
    
</xsl:stylesheet>

