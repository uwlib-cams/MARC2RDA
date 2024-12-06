<!-- <?xml version="1.0" encoding="UTF-8"?>
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
        xmlns:rdat="http://rdaregistry.info/Elements/t/"
        xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
        xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
        xmlns:rdap="http://rdaregistry.info/Elements/p/"
        xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
        xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
        xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
        xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
        version="3.0">
        <xsl:include href="m2r-8xx-named.xsl"/>
        <xsl:import href="m2r-relators.xsl"/>
        <xsl:import href="m2r-iris.xsl"/>
        <xsl:import href="getmarc.xsl"/>
        <!-- field level templates - wor, exp, man, ite -->
    
        <!-- Template: Main work to related work relationship 
        <xsl:template match="marc:datafield[@tag = '800']" mode="wor">
            <xsl:call-template name="getmarc"/>
            <rdawo:P10102 rdf:resource="{uwf:relWorkIRI(.)}"/>
        </xsl:template>    
        
        <!-- Template: Here is the related work 
        <xsl:template
            match="marc:datafield[@tag = '800']" mode="relWor" expand-text="yes">
            <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">    
                <rdf:type rdf:resource="https://www.rdaregistry.info/Elements/c/#C10001"/>
                <rdawo:P10331 rdf:resource="{uwf:nomenIRI(.,'wor/nom', '','')}"/>              
                <xsl:choose>
                    <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                        <rdawo:P10261 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                    <xsl:when test="@ind1 = '3'">
                        <rdawo:P10262 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                </xsl:choose>
            </rdf:Description>
        </xsl:template>
        
        <!-- Template Here is Agent IRI 
        <xsl:template match="marc:datafield[@tag = '800']" mode="age" expand-text="yes">
            <xsl:param name="baseIRI"/>
            <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
            <rdf:Description rdf:about="{uwf:agentIRI(.)}">
                <xsl:call-template name="getmarc"/>
                <xsl:choose>
                    <xsl:when test="@tag = '800'">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                                <xsl:choose> <!-- DC: New edits, approved list lookup?
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Person') = 'True'">">
                                        <rdaao:P50411 rdf:resource="{uwf:nomenIRI(.,'age/nom', '','')}"/>
                                    </xsl:when>
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Person') = 'False'">
                                        <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <rdaad:P50377>
                                            <xsl:value-of select="$ap"/>
                                        </rdaad:P50377>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <!-- DC: New edits, not sure the purpose, is it to deal with additional tiples?
                            <xsl:otherwise>
                            <rdaad:P50377>
                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                            </rdaad:P50377>
                            <xsl:if test="marc:subfield[@code = '6']">
                                <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                    <rdaad:P50377>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50377>
                                </xsl:for-each>
                            </xsl:if>
                            </xsl:otherwise> 
                            <!-- DC: New edits: copied from 1xx7xx. If we minted the IRI - add additional details 
                            <xsl:if test="starts-with(uwf:agentIRI($baseIRI, .), $BASE)">
                                <xsl:call-template name="FX00-x1-d"/>
                                <xsl:call-template name="FX00-x1-q"/>
                            </xsl:if>
                        </xsl:choose>
                       <!-- DC: New edits: copied from 1xx7xx. Deal with FamilyIRI transform? checks if it is in the approved list 
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Family') = 'True'">
                                    <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Family') = 'False'">
                                    <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <!-- else a nomen string is used directly
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                    <!-- DC: Still not sure what occNum does
                                    <xsl:if test="marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50376>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                            </rdaad:P50376>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                    </xsl:when>
                </xsl:choose>
            </rdf:Description>
        </xsl:template>
        
        <!-- Template: Here is Nomen 
        <xsl:template
            match="marc:datafield[@tag = '800']" mode="nom" expand-text="yes">
            <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
            <xsl:variable name="apAgent" select="uwf:agentAccessPoint(.)"/>
            <xsl:if test="marc:subfield[@code = '2']">
                <rdf:Description rdf:about="{uwf:nomenIRI(.,'wor/nom', '','')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="$apWor"/>
                    </rdand:P80068>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <copy-of select="uwf:s2NomenNameTitleSchemes(marc:subfield[@code = '2'][1])"/>
                    </xsl:if>
                </rdf:Description>
                <rdf:Description rdf:about="{uwf:nomenIRI(.,'age/nom', '','')}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="$apAgent"/>
                    </rdand:P80068>
                    <xsl:if test="marc:subfield[@code = '2']">
                        <copy-of select="uwf:s2NomenNameTitleSchemes(marc:subfield[@code = '2'][1])"/>
                    </xsl:if>
                </rdf:Description>
            </xsl:if>
        </xsl:template>
    </xsl:stylesheet>