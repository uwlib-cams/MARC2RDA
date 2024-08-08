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
    xmlns:uwf="http://universityOfWashington/functions" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/" exclude-result-prefixes="marc ex uwf uwmisc"
    version="3.0">
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- field level templates - wor, exp, man, ite -->
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="wor">
        <xsl:choose>
            <xsl:when test="@tag = '600'">
                <xsl:choose>
                    <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                        <rdawo:P10261 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
                    </xsl:when>
                    <xsl:when test="@ind1 = '3'">
                        <rdawo:P10262 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <rdawo:P10263 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="age">
        <xsl:param name="baseIRI"/>
        <rdf:Description rdf:about="{uwf:generateIRI(., 'agent')}">
            <xsl:call-template name="getmarc"/>
            <xsl:choose>
                <xsl:when test="@tag = '600'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <rdaao:P50249 rdf:resource="{$baseIRI||'/wor'}"/>
                            <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2'] or @ind2 != '4'">
                                    <rdaao:P50411 rdf:resource="{uwf:agentNomenIRI(.)}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50377>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <rdaao:P50250 rdf:resource="{$baseIRI||'/wor'}"/>
                            <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2'] or @ind2 != '4'">
                                    <rdaao:P50409 rdf:resource="{uwf:agentNomenIRI(.)}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdaad:P50376>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@tag = '610' or @tag = '611'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <rdaao:P50251 rdf:resource="{$baseIRI||'wor'}"/>
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2'] or @ind2 != '4'">
                            <rdaao:P50407 rdf:resource="{uwf:agentNomenIRI(.)}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdaad:P50375>
                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                            </rdaad:P50375>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '600'] | marc:datafield[@tag = '610'] | marc:datafield[@tag = '611']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="marc:subfield[@code = '0'] | marc:subfield[@code = '1'] | marc:subfield[@code = '2'] | @ind2 != '4'">
            <rdf:Description rdf:about="{uwf:agentNomenIRI(.)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:choose>
                    <xsl:when test="@tag = '600'">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                                <rdano:P80107 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
                            </xsl:when>
                            <xsl:when test="@ind1 = '3'">
                                <rdano:P80105 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@tag = '610' or @tag = '611'">
                        <rdano:P80103 rdf:resource="{uwf:generateIRI(., 'agent')}"/>
                    </xsl:when>
                </xsl:choose>
                <xsl:comment>Has scheme of nomen here based on something</xsl:comment>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
