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
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- field level templates - wor, exp, man, ite -->
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']"
        mode="wor">
        <xsl:choose>
            <!-- when there's no relator subfield -->
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <!-- if it's a 1XX field, call handle1XXNoRelator with the appropriate domain -->
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'work'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of
                            select="uwf:defaultAgentProp(., uwf:fieldType(@tag), 'work', uwf:agentIRI(.), uwf:agentAccessPoint(.))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- if there is a relator subfield, call handleRelator with the appropriate domain -->
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'work'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']"
        mode="exp">
        <xsl:choose>
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'expression'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- only work and manifestation domains have default values -->
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'expression'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:choose>
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'manifestation'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of
                            select="uwf:defaultAgentProp(., uwf:fieldType(@tag), 'manifestation', uwf:agentIRI(.), uwf:agentAccessPoint(.))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'manifestation'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- check if an item will be minted -->
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when
                    test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                            <xsl:call-template name="handle1XXNoRelator">
                                <xsl:with-param name="domain" select="'item'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="handleRelator">
                        <xsl:with-param name="domain" select="'item'"/>
                        <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if there is an item relator term, create the manifestation to item relationship triple -->
        <xsl:if test="$testItem/node() or $testItem/@*">
            <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']"
        mode="ite" expand-text="true">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when
                    test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                            <xsl:call-template name="handle1XXNoRelator">
                                <xsl:with-param name="domain" select="'item'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- default -->
                            <xsl:copy-of
                                select="uwf:defaultAgentProp(., uwf:fieldType(@tag), 'item', uwf:agentIRI(.), uwf:agentAccessPoint(.))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="handleRelator">
                        <xsl:with-param name="domain" select="'item'"/>
                        <xsl:with-param name="agentIRI" select="uwf:agentIRI(.)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if handleRelator returns a property, then generate an item and apply property -->
        <xsl:if test="$testItem/node() or $testItem/@*">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
                </xsl:if>
                <xsl:copy-of select="$testItem"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- agent template -->
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])]"
        mode="age">
        <xsl:param name="baseIRI"/>
        <!-- get agentIRI and set up rdf:Description for that agent -->
        <!-- note: this isn't done for 720, where an agent is not minted -->
        <rdf:Description rdf:about="{uwf:agentIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <!-- create rdf:type and relationship to nomen or nomen string triples -->
            <xsl:choose>
                <xsl:when test="@tag = '100' or @tag = '700'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <!--<xsl:choose>
                                <!-\- if there's a $2, a nomen is minted -\->
                                <xsl:when test="marc:subfield[@code = '2']">
                                    <rdaao:P50411 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                                </xsl:when>
                                <!-\- else a nomen string is used directly -\->
                                <xsl:otherwise>-->
                                    <rdaad:P50377>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50377>
                                <!--</xsl:otherwise>
                            </xsl:choose>-->
                            <!-- If we minted the IRI - add additional details -->
                            <xsl:if test="starts-with(uwf:agentIRI(.), $BASE)">
                                <xsl:call-template name="FX00-x1-d"/>
                                <xsl:call-template name="FX00-x1-q"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                           <!-- <xsl:choose>
                                <xsl:when test="marc:subfield[@code = '2']">
                                    <rdaao:P50409 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                                </xsl:when>
                                <xsl:otherwise>-->
                                    <rdaad:P50376>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50376>
                                <!--</xsl:otherwise>
                            </xsl:choose>-->
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@tag = '110' or @tag = '111' or @tag = '710' or @tag = '711'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <!--<xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2']">
                            <rdaao:P50407 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                        </xsl:when>
                        <xsl:otherwise>-->
                            <rdaad:P50375>
                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                            </rdaad:P50375>
                        <!--</xsl:otherwise>
                    </xsl:choose>-->
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <!-- create inverse property from agent to WEMI entity -->
            <!--<xsl:choose>
                <xsl:when
                    test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'">
                            <xsl:call-template name="handle1XXNoRelator">
                                <xsl:with-param name="domain" select="'agent'"/>
                                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="handleInvRelator">
                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>-->
        </rdf:Description>
    </xsl:template>
    
   <!-- <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111']
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:if test="marc:subfield[@code = '2']">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'age/nom')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                </rdand:P80068>
                <xsl:copy-of select="uwf:s2Nomen(marc:subfield[@code = '2'])"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>-->
    
    
    <!-- 700, 710, 711 $t -->
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]"
        mode="man">
        <xsl:if test="@ind2 != '2'">
            <rdamo:P30265 rdf:resource="{uwf:relWorkIRI(.)}"/>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]"
        mode="relWor" expand-text="yes">
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
                <rdawd:P10328>
                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                </rdawd:P10328>
                <xsl:choose>
                    <xsl:when test="@tag = '700' and @ind1 != '3'">
                        <rdawo:P10312 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                    <xsl:when test="@tag = '700' and @ind1 = '3'">
                        <rdawo:P10313 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                    <xsl:when test="@tag = '710' or @tag = '711'">
                        <rdawo:P10314 rdf:resource="{uwf:agentIRI(.)}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]"
        mode="age" expand-text="yes">
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:agentIRI(.)}">
                <xsl:call-template name="getmarc"/>
                <xsl:choose>
                    <xsl:when test="@tag = '700' and @ind1 != '3'">
                       <!-- <xsl:choose>
                            <!-\- if there's a $0, $1, or $2, a nomen is minted -\->
                            <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2']">
                                <rdaao:P50411 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                            </xsl:when>
                            <!-\- else a nomen string is used directly -\->
                            <xsl:otherwise>-->
                                <rdaad:P50377>
                                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                </rdaad:P50377>
                            <!--</xsl:otherwise>
                        </xsl:choose>-->
                    </xsl:when>
                    <xsl:when test="@tag = '700' and @ind1 = '3'">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                       <!-- <xsl:choose>
                            <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2']">
                                <rdaao:P50409 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                            </xsl:when>
                            <xsl:otherwise>-->
                                <rdaad:P50376>
                                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                </rdaad:P50376>
                            <!--</xsl:otherwise>
                        </xsl:choose>-->
                    </xsl:when>
                    <xsl:when test="@tag = '710' or @tag = '711'">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                        <!--<xsl:choose>
                            <xsl:when test="marc:subfield[@code = '0'] or marc:subfield[@code = '1'] or marc:subfield[@code = '2']">
                                <rdaao:P50407 rdf:resource="{uwf:nomenIRI(., 'age/nom')}"/>
                            </xsl:when>
                            <xsl:otherwise>-->
                                <rdaad:P50375>
                                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                </rdaad:P50375>
                            <!--</xsl:otherwise>
                        </xsl:choose>-->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 730, 740 -->
    <xsl:template
        match="marc:datafield[@tag = '730'] | marc:datafield[@tag = '740']"
        mode="man">
        <xsl:if test="@ind2 != '2'">
            <rdamo:P30265 rdf:resource="{uwf:relWorkIRI(.)}"/>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '730'] | marc:datafield[@tag = '740']"
        mode="relWor" expand-text="yes">
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:relWorkIRI(.)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
                <rdawd:P10328>
                    <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
                </rdawd:P10328>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
