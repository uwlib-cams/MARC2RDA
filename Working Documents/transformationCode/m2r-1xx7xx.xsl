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
    <xsl:include href="m2r-1xx7xx-named.xsl"/>
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <!-- field level templates - wor, exp, man, ite -->
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720'] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '720-00']"
        mode="wor">
        <xsl:param name="baseID"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <!-- when there's no relator subfield -->
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <!-- if it's a 1XX field, call handle1XXNoRelator with the appropriate domain -->
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                        or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'work'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                            <xsl:with-param name="type" select="$type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of
                            select="uwf:defaultAgentProp($type, ., uwf:fieldType(.), 'work', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- if there is a relator subfield, call handleRelator with the appropriate domain -->
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'work'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- only 1xx mapped to augmented work -->
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']"
        mode="augWor">
        <xsl:param name="baseID"/>
        <xsl:param name="type"/>
        <xsl:choose>
            <!-- when there's no relator subfield -->
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <!-- if it's a 1XX field, call handle1XXNoRelator with the appropriate domain -->
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                        or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'work'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                            <xsl:with-param name="type" select="$type"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of
                            select="uwf:defaultAgentProp($type, ., uwf:fieldType(.), 'work', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- if there is a relator subfield, call handleRelator with the appropriate domain -->
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'work'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '720-00']"
        mode="exp">
        <xsl:param name="baseID"/>
        <xsl:choose>
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                        or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'expression'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                        </xsl:call-template>
                    </xsl:when>
                    <!-- only work and manifestation domains have default values -->
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'expression'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '720-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:param name="agg"/>
        <xsl:choose>
            <xsl:when
                test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                        or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'manifestation'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                            <xsl:with-param name="type" select="$agg"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of
                            select="uwf:defaultAgentProp($agg, ., uwf:fieldType(.), 'manifestation', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'manifestation'"/>
                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                    <xsl:with-param name="type" select="$agg"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!-- check if an item will be minted -->
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when
                    test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                            or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                            <xsl:call-template name="handle1XXNoRelator">
                                <xsl:with-param name="domain" select="'item'"/>
                                <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- default -->
                            <xsl:copy-of
                                select="uwf:defaultAgentProp('', ., uwf:fieldType(.), 'item', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="handleRelator">
                        <xsl:with-param name="domain" select="'item'"/>
                        <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if there is an item relator term, create the manifestation to item relationship triple -->
        <xsl:if test="$testItem/node() or $testItem/@*">
            <rdamo:P30103 rdf:resource="{uwf:itemIRI($baseID, .)}"/>
        </xsl:if>
        
        <xsl:if test="$agg = 'agg'">
            <!-- check if work property used -->
            <xsl:variable name="testWork">
                <xsl:choose>
                    <xsl:when
                        test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                        <xsl:choose>
                            <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                                or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                                <xsl:call-template name="handle1XXNoRelator">
                                    <xsl:with-param name="domain" select="'work'"/>
                                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- default -->
                                <xsl:copy-of
                                    select="uwf:defaultAgentProp('', ., uwf:fieldType(.), 'work', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="handleRelator">
                            <xsl:with-param name="domain" select="'work'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- if there is a work relator term (not aggregate), create the manifestation to item relationship triple -->
            <xsl:if test="$testWork/node() or $testWork/@*">
                <xsl:if test="not($testWork/node()/rdawo:P10448 | $testWork/node()/rdawo:P10589 | $testWork/node()/rdawo:P10542 | $testWork/node()/rdawo:P10393)">
                    <xsl:copy-of
                        select="uwf:defaultAgentProp($agg, ., uwf:fieldType(.), 'manifestation', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                    />
                </xsl:if>
            </xsl:if>
            
            <!-- check if expression property used -->
            <xsl:variable name="testExpression">
                <xsl:choose>
                    <xsl:when
                        test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                        <xsl:choose>
                            <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                                or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                                <xsl:call-template name="handle1XXNoRelator">
                                    <xsl:with-param name="domain" select="'expression'"/>
                                    <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- default -->
                                <xsl:copy-of
                                    select="uwf:defaultAgentProp('', ., uwf:fieldType(.), 'expression', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="handleRelator">
                            <xsl:with-param name="domain" select="'expression'"/>
                            <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- if there is a work relator term (not aggregate), create the manifestation to item relationship triple -->
            <xsl:if test="$testWork/node() or $testWork/@*">
                <xsl:copy-of
                    select="uwf:defaultAgentProp($agg, ., uwf:fieldType(.), 'manifestation', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                />
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '720']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '720-00']"
        mode="ite" expand-text="true">
        <xsl:param name="baseID"/>
        <xsl:param name="manIRI"/>
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when
                    test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test="@tag = '100' or @tag = '110' or @tag = '111'
                            or (@tag = '880' and starts-with(marc:subfield[@code = '6'], '1'))">
                            <xsl:call-template name="handle1XXNoRelator">
                                <xsl:with-param name="domain" select="'item'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- default -->
                            <xsl:copy-of
                                select="uwf:defaultAgentProp('', ., uwf:fieldType(.), 'item', uwf:agentIRI($baseID, .), uwf:agentAccessPoint(.))"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="handleRelator">
                        <xsl:with-param name="domain" select="'item'"/>
                        <xsl:with-param name="agentIRI" select="uwf:agentIRI($baseID, .)"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if handleRelator returns a property, then generate an item and apply property -->
        <xsl:if test="$testItem/node() or $testItem/@*">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{uwf:itemIRI($baseID, .)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat('ite#',$baseID, $genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{$manIRI}"/>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:copy-of select="uwf:s5Lookup(marc:subfield[@code = '5'])"/>
                </xsl:if>
                <xsl:copy-of select="$testItem"/>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- agent template -->
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] 
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]"
        mode="age">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <!-- get agentIRI and set up rdf:Description for that agent -->
        <!-- note: this isn't done for 720, where an agent is not minted -->
        <rdf:Description rdf:about="{uwf:agentIRI($baseID, .)}">
            <!--<xsl:call-template name="getmarc"/>-->
            <!-- create rdf:type and relationship to nomen or nomen string triples -->
            <xsl:choose>
                <xsl:when test="$tagType = '100' or $tagType = '700'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted-->
                                <!-- if the $2 is approved it's an authorized access point -->
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'True'">
                                    <rdaao:P50411 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'person')}"/>
                                </xsl:when>
                                <!-- if not it's just an access point -->
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'False'">
                                    <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'person')}"/>
                                </xsl:when>
                                <!-- else a nomen string is used directly as an access point -->
                                <xsl:otherwise>
                                    <rdaad:P50377>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
                            <!-- If we minted the IRI - add additional details -->
                            <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                                <xsl:call-template name="FX00-x1-a"/>
                                <xsl:call-template name="FX00-x2-a"/>
                                <xsl:call-template name="FX00-x0-ab"/>
                                <xsl:call-template name="FX00-x0-a"/>
                                <xsl:call-template name="FX00-xx-d"/>
                                <xsl:call-template name="FX00-xx-q"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                            <xsl:choose>
                                <!-- if there's a $2, a nomen is minted -->
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'True'">
                                    <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'family')}"/>
                                </xsl:when>
                                <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'False'">
                                    <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'family')}"/>
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
                            <!-- If we minted the IRI - add additional details -->
                            <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                                <xsl:call-template name="FX00-x3-c"/>
                                <xsl:call-template name="FX00-x3-d"/>
                                <xsl:call-template name="FX00-x3-a"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$tagType = '110' or $tagType = '111' or $tagType = '710' or $tagType = '711'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <xsl:choose>
                        <!-- if there's a $2, a nomen is minted -->
                        <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'True'">
                            <rdaao:P50407 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'corporatebody')}"/>
                        </xsl:when>
                        <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'False'">
                            <rdaao:P50375 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'corporatebody')}"/>
                        </xsl:when>
                        <!-- else a nomen string is used directly -->
                        <xsl:otherwise>
                            <rdaad:P50375>
                                <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                            </rdaad:P50375>
                            <xsl:if test="@tag != '880' and marc:subfield[@code = '6']">
                                <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                    <rdaad:P50375>
                                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                    </rdaad:P50375>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$tagType = '111' or $tagType = '711'">
                        <rdaad:P50237>
                            <xsl:text>Meeting</xsl:text>
                        </rdaad:P50237>
                    </xsl:if>
                    <!-- If we minted the IRI - add additional details -->
                    <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                        <xsl:call-template name="FX1X-xx-a"/>
                        <xsl:call-template name="FX1X-xx-ab"/>
                        <xsl:call-template name="FX1X-xx-ae"/>
                        <xsl:call-template name="FX1X-xx-c"/>
                        <xsl:call-template name="FX1X-xx-d"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:copy-of select="uwf:agentIdentifiers(.)"/>
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
    
    <xsl:template
        match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111']
        | marc:datafield[@tag = '700'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '710'][not(marc:subfield[@code = 't'])] | marc:datafield[@tag = '711'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '100-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '110-00'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '111-00']
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][not(marc:subfield[@code = 't'])] 
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][not(marc:subfield[@code = 't'])]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][not(marc:subfield[@code = 't'])]"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="($tagType = '100' or $tagType = '700')
                    and @ind1 != '3'">
                    <xsl:value-of select="'person'"/>
                </xsl:when>
                <xsl:when test="($tagType = '100' or $tagType = '700')
                    and @ind1 = '3'">
                    <xsl:value-of select="'family'"/>
                </xsl:when>
                <xsl:when test="$tagType = '110'or $tagType = '710' or $tagType = '111' or $tagType = '711'">
                    <xsl:value-of select="'corporatebody'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="marc:subfield[@code = '2']">
            <xsl:variable name="nomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], $type) = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], $type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', $type)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:Description rdf:about="{$nomenIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>
                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
    
    
    <!-- 700, 710, 711 $t -->
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][marc:subfield[@code = 't']]"
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <rdamo:P30265 rdf:resource="{uwf:relWorkIRI($baseID, .)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][marc:subfield[@code = 't']]"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:relWorkIRI($baseID, .)}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                        <rdaao:P10328 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'work')}"/>
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
                    <xsl:when test="$tagType = '700' and @ind1 != '3'">
                        <rdawo:P10312 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                    </xsl:when>
                    <xsl:when test="$tagType = '700' and @ind1 = '3'">
                        <rdawo:P10313 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                    </xsl:when>
                    <xsl:when test="$tagType = '710' or @tag = '711'">
                        <rdawo:P10314 rdf:resource="{uwf:agentIRI($baseID, .)}"/>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:copy-of select="uwf:workIdentifiers(.)"/>
                <!-- If we minted the IRI - add additional details -->
                <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                    <xsl:call-template name="FXXX-xx-f"/>
                    <xsl:call-template name="FXXX-xx-tnp"/>
                    <xsl:call-template name="FXXX-xx-n"/>
                    <xsl:call-template name="FXXX-xx-x"/>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][marc:subfield[@code = 't']]"
        mode="age" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <xsl:if test="@ind2 != '2'">
            <rdf:Description rdf:about="{uwf:agentIRI($baseID, .)}">
                <!--<xsl:call-template name="getmarc"/>-->
                <!-- create rdf:type and relationship to nomen or nomen string triples -->
                <xsl:choose>
                    <xsl:when test="$tagType = '700'">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                                <xsl:choose>
                                    <!-- if there's a $2, a nomen is minted and it's an authorized access point-->
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'True'">
                                        <rdaao:P50411 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'person')}"/>
                                    </xsl:when>
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'person') = 'False'">
                                        <rdaao:P50377 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'person')}"/>
                                    </xsl:when>
                                    <!-- else a nomen string is used directly as an access point -->
                                    <xsl:otherwise>
                                        <rdaad:P50377>
                                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
                                <!-- If we minted the IRI - add additional details -->
                                <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                                    <xsl:call-template name="FX00-x1-a"/>
                                    <xsl:call-template name="FX00-x2-a"/>
                                    <xsl:call-template name="FX00-x0-ab"/>
                                    <xsl:call-template name="FX00-x0-a"/>
                                    <xsl:call-template name="FX00-xx-d"/>
                                    <xsl:call-template name="FX00-xx-q"/>                   
                                </xsl:if>
                            </xsl:when>
                            <xsl:when test="@ind1 = '3'">
                                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                                <xsl:choose>
                                    <!-- if there's a $2, a nomen is minted -->
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'True'">
                                        <rdaao:P50409 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'family')}"/>
                                    </xsl:when>
                                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'family') = 'False'">
                                        <rdaao:P50376 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'family')}"/>
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
                                <!-- If we minted the IRI - add additional details -->
                                <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                                    <xsl:call-template name="FX00-x3-c"/>
                                    <xsl:call-template name="FX00-x3-d"/>
                                    <xsl:call-template name="FX00-x3-a"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="$tagType = '710' or $tagType = '711'">
                        <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                        <xsl:choose>
                            <!-- if there's a $2, a nomen is minted -->
                            <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'True'">
                                <rdaao:P50407 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'corporatebody')}"/>
                            </xsl:when>
                            <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'corporatebody') = 'False'">
                                <rdaao:P50375 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'corporatebody')}"/>
                            </xsl:when>
                            <!-- else a nomen string is used directly -->
                            <xsl:otherwise>
                                <rdaad:P50375>
                                    <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                </rdaad:P50375>
                                <xsl:if test="marc:subfield[@code = '6']">
                                    <xsl:variable name="occNum" select="concat(@tag, '-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                                    <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                                        <rdaad:P50375>
                                            <xsl:value-of select="uwf:agentAccessPoint(.)"/>
                                        </rdaad:P50375>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$tagType = '711'">
                            <rdaad:P50237>
                                <xsl:text>Meeting</xsl:text>
                            </rdaad:P50237>
                        </xsl:if>
                        <!-- If we minted the IRI - add additional details -->
                        <xsl:if test="starts-with(uwf:agentIRI($baseID, .), $BASE)">
                            <xsl:call-template name="FX1X-xx-a"/>
                            <xsl:call-template name="FX1X-xx-ab"/>
                            <xsl:call-template name="FX1X-xx-ae"/>
                            <xsl:call-template name="FX1X-xx-c"/>
                            <xsl:call-template name="FX1X-xx-d"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '700'][marc:subfield[@code = 't']] | marc:datafield[@tag = '710'][marc:subfield[@code = 't']] | marc:datafield[@tag = '711'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '700-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '710-00'][marc:subfield[@code = 't']]
        | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '711-00'][marc:subfield[@code = 't']]"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:variable name="tagType" select="uwf:tagType(.)"/>
        <xsl:variable name="type">
            <xsl:choose>
                <xsl:when test="($tagType = '700')
                    and @ind1 != '3'">
                    <xsl:value-of select="'person'"/>
                </xsl:when>
                <xsl:when test="($tagType = '700')
                    and @ind1 = '3'">
                    <xsl:value-of select="'family'"/>
                </xsl:when>
                <xsl:when test="$tagType = '710' or $tagType = '711'">
                    <xsl:value-of select="'corporatebody'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="@ind2 != '2'">
            <xsl:variable name="worNomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', 'work')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ageNomenIRI">
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], $type) = 'True'">
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:agentAccessPoint(.), marc:subfield[@code = '2'][1], $type)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', $type)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="marc:subfield[@code = '2']">
                <rdf:Description rdf:about="{$worNomenIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
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
                <rdf:Description rdf:about="{$ageNomenIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="uwf:agentAccessPoint(.)"/>
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
        </xsl:if>
    </xsl:template>
    
    <!-- 130 -->
    <xsl:template match="marc:datafield[@tag = '130'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '130']"
        mode="aggWor">
        <!-- title -->
        <xsl:call-template name="FX30-anp"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '130'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '130']"
        mode="seWor augWor">
        <!-- title -->
        <xsl:call-template name="FX30-anp"/>
        <!-- attributes -->
        <xsl:call-template name="FX30-d"/>
        <xsl:call-template name="FXXX-xx-n"/>
    </xsl:template>
    
    <!-- 730 -->
    <xsl:template
        match="marc:datafield[@tag = '730'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '730-00']"
        mode="man">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <rdamo:P30265 rdf:resource="{uwf:relWorkIRI($baseID, .)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '730'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '730-00']"
        mode="relWor" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <xsl:variable name="relWorkIRI" select="uwf:relWorkIRI($baseID, .)"/>
            <rdf:Description rdf:about="{$relWorkIRI}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                <rdawd:P10002>{concat(generate-id(), 'wor')}</rdawd:P10002>
                <xsl:choose>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                        <rdawo:P10331 rdf:resource="{uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')}"/>
                    </xsl:when>
                    <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'False'">
                        <rdawo:P10328 rdf:resource="{uwf:nomenIRI($baseID, ., '', '', 'work')}"/>
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
                                <!-- If we minted the IRI - add additional details -->
                                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                                    <xsl:call-template name="FX30-anp"/>
                                    <xsl:call-template name="FXXX-xx-f"/>
                                    <xsl:call-template name="FXXX-xx-n"/>
                                    <xsl:call-template name="FXXX-xx-x"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="uwf:workIdentifiers(.)"/>
                <!-- If we minted the IRI - add additional details -->
                <xsl:if test="starts-with($relWorkIRI, $BASE)">
                    <xsl:call-template name="FX30-anp"/>
                    <xsl:call-template name="FXXX-xx-f"/>
                    <xsl:call-template name="FXXX-xx-n"/>
                    <xsl:call-template name="FXXX-xx-x"/>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '730'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '730-00']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseID"/>
        <xsl:if test="@ind2 != '2'">
            <xsl:if test="marc:subfield[@code = '2']">
                <xsl:variable name="nomenIRI">
                    <xsl:choose>
                        <xsl:when test="marc:subfield[@code = '2'] and uwf:s2EntityTest(marc:subfield[@code = '2'][1], 'work') = 'True'">
                            <xsl:value-of select="uwf:nomenIRI($baseID, ., uwf:relWorkAccessPoint(.), marc:subfield[@code = '2'][1], 'work')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="uwf:nomenIRI($baseID, ., '', '', 'work')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <rdf:Description rdf:about="{$nomenIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdand:P80068>
                        <xsl:value-of select="uwf:relWorkAccessPoint(.)"/>
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
            </xsl:if>
        </xsl:if>
    </xsl:template>

<!-- 760 Main Series Entry -->
    <xsl:template
        match="marc:datafield[@tag = '760'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '760-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F760-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
    <!-- 762 Subseries Entry -->
    <xsl:template
        match="marc:datafield[@tag = '762'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '762-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F762-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>


<!-- 765 Original Language Entry -->
    <xsl:template
        match="marc:datafield[@tag = '765'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '765-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F765-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>

 <!-- 770 Supplement/Special Issue Entry -->
    <xsl:template
        match="marc:datafield[@tag = '770'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '770-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F770-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
<!-- 767 Translation Entry -->
    <xsl:template
        match="marc:datafield[@tag = '767'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '767-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F767-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
<!-- 773 Host Item Entry: manifestation-level -->
    <xsl:template 
        match="marc:datafield[@tag = '773'][not(marc:subfield[@code = '5'])] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '773-00' and not(marc:subfield[@code = '5'])]"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F773-xx-abcdefghijklmnpqrstuvwxyz34"/>
        </rdam:P30137>
    </xsl:template>
    
<!-- 773 Host Item Entry: item-level -->
    <xsl:template 
        match="marc:datafield[@tag = '773'][marc:subfield[@code = '5']] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '773-00' and marc:subfield[@code = '5']]"
        mode="ite">
        <xsl:param name="baseID"/>
        <xsl:variable name="itemIRI" select="uwf:itemIRI($baseID, .)"/>
        
        <!-- Link the item to the manifestation -->
        <rdamo:P30103 resource="{$itemIRI}"/>
        
        <!-- Note on the item itself -->
        <rdaid:P40028 about="{$itemIRI}">
            <xsl:call-template name="F773-xx-abcdefghijklmnpqrstuvwxyz34"/>
        </rdaid:P40028>
    </xsl:template>
    
<!-- 774 Constituent Unit Entry -->
    <xsl:template
        match="marc:datafield[@tag = '774'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '774-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F774-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    

 <!-- 775 Other Edition Entry -->
    <xsl:template
        match="marc:datafield[@tag = '775'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '775-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F775-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>


<!-- 776 Additional Physical Form Entry -->
    <xsl:template
        match="marc:datafield[@tag = '776'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '776-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F776-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
 <!-- 777 Issued with Entry -->
    <xsl:template
        match="marc:datafield[@tag = '777'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '777-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F777-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
<!-- 780 Preceding Entry -->
    <xsl:template
        match="marc:datafield[@tag = '780'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '780-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F780-x0-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
    
 <!-- 785 Succeeding Entry -->
    <xsl:template
        match="marc:datafield[@tag = '785'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '785-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F785-x0-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
<!-- 786 Data Source Entry -->
    <xsl:template
        match="marc:datafield[@tag = '786'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '786-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F786-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
    
    
<!-- 787 Other Relationship Entry -->
    <xsl:template
        match="marc:datafield[@tag = '787'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '787-00']"
        mode="man">
        <rdam:P30137>
            <xsl:call-template name="F787-xx-abcdefghjklmnopqrstuvwxyz"/>
        </rdam:P30137>
    </xsl:template>
    
</xsl:stylesheet>
