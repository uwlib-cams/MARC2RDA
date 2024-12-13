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
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
    version="3.0">
    <!-- CP: commented out while it doesn't exist -->
    <!-- CP: also, need to add this file to m2r.xsl -->
<!--    <xsl:include href="m2r-8xx-named.xsl"/>-->
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- field level templates - wor, exp, man, ite -->
    
    <!-- Template: Main work to related work relationship -->
    <!-- CP: add 880s -->
    <xsl:template match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]" 
        mode="wor">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <rdawo:P10102 rdf:resource="{uwf:relWorkIRI($baseIRI, .)}"/>
    </xsl:template>    
    
    <!--         Template: Here is the related work -->
    <xsl:template
        match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]" 
        mode="relWor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <!-- CP: add 800 to relWorkIRI function in m2r-iris -->
        <rdf:Description rdf:about="{uwf:relWorkIRI($baseIRI, .)}">    
            <rdf:type rdf:resource="https://www.rdaregistry.info/Elements/c/#C10001"/>
            <!-- CP: add check to determine whether we mint a nomen or not -->
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Work') = 'True'">
                    <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                </xsl:when>
                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Work') = 'False'">
                    <rdaao:P10328 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'worNom')}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10328>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                    </rdawd:P10328>
                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdawd:P10328>
                                <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                            </rdawd:P10328>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>              
            <xsl:choose>
                <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                    <rdawo:P10261 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                </xsl:when>
                <xsl:when test="@ind1 = '3'">
                    <rdawo:P10262 rdf:resource="{uwf:agentIRI($baseIRI, .)}"/>
                </xsl:when>
            </xsl:choose>
            <xsl:copy-of select="uwf:workIdentifiers(.)"/>
        </rdf:Description>
    </xsl:template>
    
    <!-- Template Here is Agent IRI -->
    <xsl:template match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]"
        mode="age" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="ap" select="uwf:agentAccessPoint(.)"/>
        <rdf:Description rdf:about="{uwf:agentIRI($baseIRI, .)}">
            <xsl:call-template name="getmarc"/>
            <xsl:choose>
                <xsl:when test="@tag = '800'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Person') = 'True'">">
                                    <rdaao:P50411 rdf:resource="{uwf:nomenIRI($baseIRI, .,'ageNom')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Person') = 'False'">
                                    <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="$ap"/>
                                    </rdaad:P50377>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                        <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                            <rdaad:P50377>
                                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                            </rdaad:P50377>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="starts-with(uwf:agentIRI($baseIRI, .), $BASE)">
                                <xsl:call-template name="FX00-x1-d"/>
                                <xsl:call-template name="FX00-x1-q"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted -->
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Family') = 'True'">
                                    <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'Family') = 'False'">
                                    <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseIRI, ., 'ageNom')}"/>
                                </xsl:when>
                                <!-- else a nomen string is used directly -->
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                    <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
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
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <!-- Template: Here is Nomen -->
    <xsl:template
        match="marc:datafield[@tag = '800'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '800-00'][marc:subfield[@code = 't']]" 
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="apWor" select="uwf:relWorkAccessPoint(.)"/>
        <xsl:variable name="apAgent" select="uwf:agentAccessPoint(.)"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, .,'worNom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apWor"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
            <rdf:Description rdf:about="{uwf:nomenIRI($baseIRI, .,'ageNom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="$apAgent"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
                <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdand:P80113>
                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                        </rdand:P80113>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>