<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
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
    xmlns:rdap="http://rdaregistry.info/Elements/p/"
    xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
    xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
    xmlns:rdat="http://rdaregistry.info/Elements/t/"
    xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
    xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
    xmlns:fake="http://fakePropertiesForDemo" xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- skips fields not yet handled -->
    <xsl:mode name="wor" on-no-match="shallow-skip"/>
    <xsl:mode name="seWor" on-no-match="shallow-skip"/>
    <xsl:mode name="aggWor" on-no-match="shallow-skip"/>
    <xsl:mode name="augWor" on-no-match="shallow-skip"/>
    <xsl:mode name="exp" on-no-match="shallow-skip"/>
    <xsl:mode name="man" on-no-match="shallow-skip"/>
    <xsl:mode name="origMan" on-no-match="shallow-skip"/>
    <xsl:mode name="ite" on-no-match="shallow-skip"/>
    <xsl:mode name="nom" on-no-match="shallow-skip"/>
    <xsl:mode name="metaWor" on-no-match="shallow-skip"/>
    <xsl:mode name="age" on-no-match="shallow-skip"/>
    <xsl:mode name="relWor" on-no-match="shallow-skip"/>
    <xsl:mode name="con" on-no-match="shallow-skip"/>
    <xsl:mode name="pla" on-no-match="shallow-skip"/>
    <xsl:mode name="tim" on-no-match="shallow-skip"/>
    
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-aps.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="m2r-relators.xsl"/>
    <xsl:import href="m2r-processCMC.xsl"/>
    <xsl:import href="m2r-basicValidation.xsl"/>
    <xsl:import href="m2r-aggregates.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    
    <!-- base IRI for now - all minted entities begin with this -->
    <xsl:param name="BASE" select="'http://marc2rda.edu/fake/'"/>
    
    <!-- include all files containing main field templates
         each main field template will include its own -named file if it exists-->
    <xsl:include href="m2r-00x.xsl"/>
    <xsl:include href="m2r-0xx.xsl"/>
    <xsl:include href="m2r-00x-named.xsl"/>
    <xsl:include href="m2r-1xx7xx.xsl"/>
    <xsl:include href="m2r-2xx.xsl"/>
    <xsl:include href="m2r-3xx.xsl"/>
    <xsl:include href="m2r-4xx.xsl"/>
    <xsl:include href="m2r-5xx.xsl"/>
    <xsl:include href="m2r-6xx.xsl"/>
    <xsl:include href="m2r-8xx.xsl"/>
    
    <!-- This template matches the root
        and creates the <rdf:RDF> elements with the necessary namespaces for the resulting document
        if additional namespaces are used they should be added here as well. -->
    <xsl:template match="/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
            xmlns:rdaw="http://rdaregistry.info/Elements/w/"
            xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
            xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
            xmlns:rdae="http://rdaregistry.info/Elements/e/"
            xmlns:rdaed="http://rdaregistry.info/Elements/e/datatype/"
            xmlns:rdaeo="http://rdaregistry.info/Elements/e/object/"
            xmlns:rdam="http://rdaregistry.info/Elements/m/"
            xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
            xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
            xmlns:rdaa="http://rdaregistry.info/Elements/a/"
            xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
            xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
            xmlns:rdan="http://rdaregistry.info/Elements/n/"
            xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
            xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
            xmlns:rdap="http://rdaregistry.info/Elements/p/"
            xmlns:rdapd="http://rdaregistry.info/Elements/p/datatype/"
            xmlns:rdapo="http://rdaregistry.info/Elements/p/object/"
            xmlns:rdat="http://rdaregistry.info/Elements/t/"
            xmlns:rdatd="http://rdaregistry.info/Elements/t/datatype/"
            xmlns:rdato="http://rdaregistry.info/Elements/t/object/"
            xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
            xmlns:skos="http://www.w3.org/2004/02/skos/core#">
            <!-- apply templates to marc:record -->
            <xsl:apply-templates select="//marc:record"/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="marc:record" expand-text="yes">
        <xsl:variable name="isValid" select="m2r:isValid(.)"/>
        <xsl:choose>
            <xsl:when test="$isValid = 'True'">
                <xsl:variable name="record33XIRIs">
                    <xsl:copy-of select="m2r:get33XIRIs(.)"/>
                </xsl:variable>
                <xsl:variable name="isTactile" select="m2r:isTactile(., $record33XIRIs)"/>
                <xsl:choose>
                    <xsl:when test="$isTactile = false()">
                        <xsl:variable name="inputRecord" select="."/>
                        <xsl:variable name="inputPosition" select="position()"/>
                        <xsl:variable name="processedRecord">
                            <xsl:call-template name="otherFieldsTo33x">
                                <xsl:with-param name="record">
                                    <xsl:copy-of select="."/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:for-each select="$processedRecord/marc:record">
                            <xsl:variable name="isElectronic"
                                select="m2r:isElectronic(., $record33XIRIs)"/>
                            <xsl:variable name="isMicroform"
                                select="m2r:isMicroform(., $record33XIRIs)"/>
                            <!--<xsl:message>
                <xsl:text>Is Electronic for record {$inputPosition}/{count($inputRecord/../marc:record)} is: {$isElectronic}</xsl:text>
            </xsl:message>-->
                            <!-- message can be output to show processing -->
                            <!--<xsl:message>
                 <xsl:text>Processing record {marc:controlfield[@tag = '001']} ({position()}/{last()}).</xsl:text>
             </xsl:message>-->
                            <!-- VARIABLES -->
                            <!-- check whether record being processed is an aggregate-->
                            <xsl:variable name="isAggregate">
                                <!-- WHEN READY TO IMPLEMENT AGGREGATE MARKERS, uncomment next line and comment the xsl:choose below -->
                                <xsl:value-of select="lower-case(m2r:checkAggregates(.))"/>
                                <!--<xsl:choose>
                                    <xsl:when
                                        test="marc:datafield[@tag = '979']/marc:subfield[@code = 'a']">
                                        <xsl:value-of
                                            select="lower-case(marc:datafield[@tag = '979']/marc:subfield[@code = 'a'])"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="'sem'"/>
                                    </xsl:otherwise>
                                </xsl:choose>-->
                            </xsl:variable>
                            <!-- message can be output to show aggregate type -->
                            <!--<xsl:message>
                 <xsl:text>record {marc:controlfield[@tag = '001']} is {$isAggregate}</xsl:text>
             </xsl:message>-->
                            <xsl:choose>
                                <!-- if single work expression or augmentation aggregate, proceed with transform -->
                                <xsl:when test="$isAggregate = 'sem' or $isAggregate = 'aamnotaw'">
                                    <!-- variable for generating unique IRIs - currently date  -->
                                    <xsl:variable name="baseID"
                                        select="current-dateTime() => string() => m2r:stripAllPunctuation() => encode-for-uri()"/>
                                    <!-- main WEM IRIs stored in variables -->
                                    <xsl:variable name="mainWorkIRI" select="m2r:mainWorkIRI(.)"/>
                                    <xsl:variable name="mainExpressionIRI"
                                        select="m2r:mainExpressionIRI(.)"/>
                                    <xsl:variable name="mainManifestationIRI"
                                        select="m2r:mainManifestationIRI(., $isElectronic, $isMicroform)"/>
                                    <!-- if reproduction -->
                                    <xsl:variable name="isReproduction"
                                        select="m2r:checkReproductions(.)"/>
                                    <!-- orig manifestation IRI - blank if not reproduction -->
                                    <xsl:variable name="origManifestationIRI">
                                        <xsl:if test="$isReproduction">
                                            <xsl:value-of
                                                select="m2r:origManifestationIRI(., $isElectronic, $isMicroform)"
                                            />
                                        </xsl:if>
                                    </xsl:variable>
                                    <!-- aggregating work IRI - blank if not augmentation aggregate -->
                                    <xsl:variable name="aggWorkIRI">
                                        <xsl:if test="$isAggregate = 'aam'">
                                            <xsl:value-of select="m2r:aggWorkIRI(.)"/>
                                        </xsl:if>
                                    </xsl:variable>
                                    <!-- metadata work IRI for connection to MARC record -->
                                    <xsl:variable name="marcMetadataWorkIRI"
                                        select="$BASE || 'transform/wor#marc' || encode-for-uri(lower-case(translate(marc:controlfield[@tag = '003'][1], ' ', ''))) || encode-for-uri(translate(marc:controlfield[@tag = '001'][1], ' ', '_'))"/>
                                    <!-- call metadata work template (template at bottom of this file) -->
                                    <xsl:call-template name="marcMetadataWork">
                                        <xsl:with-param name="inputRecord" select="."/>
                                        <xsl:with-param name="marcWorkIRI"
                                            select="$marcMetadataWorkIRI"/>
                                        <xsl:with-param name="mainWorkIRI" select="$mainWorkIRI"/>
                                        <xsl:with-param name="aggWorkIRI" select="$aggWorkIRI"/>
                                        <xsl:with-param name="mainExpressionIRI"
                                            select="$mainExpressionIRI"/>
                                        <xsl:with-param name="mainManifestationIRI"
                                            select="$mainManifestationIRI"/>
                                        <xsl:with-param name="origManifestationIRI"
                                            select="$origManifestationIRI"/>
                                    </xsl:call-template>
                                    <!-- WEM STACK -->
                                    <!-- Set up the WEMI stack for the marc:record -->
                                    <!-- an rdf:Description is created for the Work, Expression, and Manifestation 
                     and apply-templates is called with the correct mode 
                     to create the appropriate relationships within each rdf:Description element -->
                                    <xsl:choose>
                                        <!-- SINGLE WE -->
                                        <xsl:when
                                            test="$isAggregate = 'sem' or $isAggregate = 'aamnotaw'">
                                            <!-- *****WORKS***** -->
                                            <rdf:Description rdf:about="{$mainWorkIRI}">
                                                <rdf:type
                                                  rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                                                <rdawo:P10623 rdf:resource="{$marcMetadataWorkIRI}"/>
                                                <rdawo:P10078 rdf:resource="{$mainExpressionIRI}"/>
                                                <!-- This code can be uncommented to add a work access point to the work description.
                         m2r:mainWorkAccessPoint() is located in m2r-aps.xsl -->
                                                <xsl:variable name="workAP"
                                                  select="m2r:mainWorkAccessPoint(.)"/>
                                                <xsl:if test="$workAP">
                                                  <rdawd:P10328>
                                                  <xsl:value-of select="$workAP"/>
                                                  </rdawd:P10328>
                                                </xsl:if>
                                                <xsl:apply-templates select="*" mode="wor">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                </xsl:apply-templates>
                                                <xsl:apply-templates select="*" mode="seWor">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                </xsl:apply-templates>
                                            </rdf:Description>
                                            <!-- *****EXPRESSIONS***** -->
                                            <rdf:Description rdf:about="{$mainExpressionIRI}">
                                                <rdf:type
                                                  rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
                                                <rdaeo:P20576 rdf:resource="{$marcMetadataWorkIRI}"/>
                                                <rdaeo:P20059 rdf:resource="{$mainManifestationIRI}"/>
                                                <xsl:if test="$isReproduction != ''">
                                                  <rdaeo:P20059
                                                  rdf:resource="{m2r:origManifestationIRI(.,
                                                  $isElectronic, $isMicroform)}"/>
                                                </xsl:if>
                                                <rdaeo:P20231 rdf:resource="{$mainWorkIRI}"/>
                                                <!-- This code can be uncommented to add an expression access point to the expression description.
                         m2r:mainExpressionAccessPoint() is located in m2r-aps.xsl -->
                                                <xsl:variable name="expressionAP"
                                                  select="m2r:mainExpressionAccessPoint(.)"/>
                                                <xsl:if test="$expressionAP">
                                                  <rdaed:P20310>
                                                  <xsl:value-of select="$expressionAP"/>
                                                  </rdaed:P20310>
                                                </xsl:if>
                                                <xsl:apply-templates select="*" mode="exp">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                </xsl:apply-templates>
                                            </rdf:Description>
                                        </xsl:when>
                                        <!-- AAM -->
                                        <xsl:when test="$isAggregate = 'aam'">
                                            <!-- *****WORKS***** -->
                                            <!-- aggregating work and main augmented work -->
                                            <rdf:Description rdf:about="{$aggWorkIRI}">
                                                <rdf:type
                                                  rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                                                <rdawo:P10623 rdf:resource="{$marcMetadataWorkIRI}"/>
                                                <rdawd:P10004>Aggregating work</rdawd:P10004>
                                                <!-- relationship to manifestation -->
                                                <rdawo:P10072 rdf:resource="{$mainManifestationIRI}"/>
                                                <xsl:if test="$isReproduction != ''">
                                                  <rdawo:P10072
                                                  rdf:resource="{$origManifestationIRI}"/>
                                                </xsl:if>
                                                <!-- This code can be uncommented to add a work access point to the work description.
                         m2r:mainWorkAccessPoint() is located in m2r-aps.xsl -->
                                                <xsl:variable name="aggWorkAP"
                                                  select="m2r:aggWorkAccessPoint(.)"/>
                                                <xsl:if test="$aggWorkAP">
                                                  <rdawd:P10328>
                                                  <xsl:value-of select="$aggWorkAP"/>
                                                  </rdawd:P10328>
                                                </xsl:if>
                                                <xsl:apply-templates select="*" mode="wor">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="type" select="'agg'"/>
                                                </xsl:apply-templates>
                                                <xsl:apply-templates select="*" mode="aggWor">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                </xsl:apply-templates>
                                            </rdf:Description>
                                            <rdf:Description rdf:about="{$mainWorkIRI}">
                                                <rdf:type
                                                  rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                                                <rdawo:P10623 rdf:resource="{$marcMetadataWorkIRI}"/>
                                                <rdawo:P10078 rdf:resource="{$mainExpressionIRI}"/>
                                                <!-- This code can be uncommented to add a work access point to the work description.
                         m2r:mainWorkAccessPoint() is located in m2r-aps.xsl -->
                                                <xsl:variable name="workAP"
                                                  select="m2r:mainWorkAccessPoint(.)"/>
                                                <xsl:if test="$workAP">
                                                  <rdawd:P10328>
                                                  <xsl:value-of select="$workAP"/>
                                                  </rdawd:P10328>
                                                </xsl:if>
                                                <xsl:apply-templates select="*" mode="augWor">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="type" select="'aug'"/>
                                                </xsl:apply-templates>
                                            </rdf:Description>
                                            <!-- *****EXPRESSIONS***** -->
                                            <rdf:Description rdf:about="{$mainExpressionIRI}">
                                                <rdf:type
                                                  rdf:resource="http://rdaregistry.info/Elements/c/C10006"/>
                                                <rdaeo:P20576 rdf:resource="{$marcMetadataWorkIRI}"/>
                                                <rdaeo:P20059 rdf:resource="{$mainManifestationIRI}"/>
                                                <xsl:if test="$isReproduction != ''">
                                                  <rdaeo:P20059
                                                  rdf:resource="{$origManifestationIRI}"/>
                                                </xsl:if>
                                                <rdaeo:P20231 rdf:resource="{$mainWorkIRI}"/>
                                                <!-- This code can be uncommented to add an expression access point to the expression description.
                         m2r:mainExpressionAccessPoint() is located in m2r-aps.xsl -->
                                                <xsl:variable name="expressionAP"
                                                  select="m2r:mainExpressionAccessPoint(.)"/>
                                                <xsl:if test="$expressionAP">
                                                  <rdaed:P20310>
                                                  <xsl:value-of select="$expressionAP"/>
                                                  </rdaed:P20310>
                                                </xsl:if>
                                                <xsl:apply-templates select="*" mode="exp">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                </xsl:apply-templates>
                                            </rdf:Description>
                                        </xsl:when>
                                    </xsl:choose>
                                    <!-- *****MANIFESTATIONS***** -->
                                    <rdf:Description rdf:about="{$mainManifestationIRI}">
                                        <rdf:type
                                            rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                                        <rdamo:P30462 rdf:resource="{$marcMetadataWorkIRI}"/>
                                        <rdamo:P30139 rdf:resource="{$mainExpressionIRI}"/>
                                        <!-- relationship to aggregating work -->
                                        <xsl:if test="$isAggregate = 'aam'">
                                            <rdamo:P30135 rdf:resource="{$aggWorkIRI}"/>
                                        </xsl:if>
                                        <!-- category for aggregates -->
                                        <xsl:if
                                            test="$isAggregate = 'cam' or $isAggregate = 'pam' or $isAggregate = 'aam' or $isAggregate = 'aamnotaw'">
                                            <rdamd:P30335>
                                                <xsl:text>Aggregate manifestation</xsl:text>
                                            </rdamd:P30335>
                                        </xsl:if>
                                        <!-- This code can be uncommented to add a manifestation access point to the manifestation description.
                         m2r:mainManifestationAccessPoint() is located in m2r-aps.xsl -->
                                        <xsl:variable name="manifestationAP"
                                            select="m2r:mainManifestationAccessPoint(., $isElectronic, $isMicroform)"/>
                                        <xsl:if test="$manifestationAP">
                                            <rdamd:P30276>
                                                <xsl:value-of select="$manifestationAP"/>
                                            </rdamd:P30276>
                                        </xsl:if>
                                        <xsl:choose>
                                            <xsl:when test="$isReproduction != ''">
                                                <xsl:variable name="formofitem">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="matches(substring(marc:leader, 7, 1), '[efgkor]')">
                                                  <xsl:value-of
                                                  select="substring(marc:controlfield[@tag = '008'], 30, 1)"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="substring(marc:controlfield[@tag = '008'], 24, 1)"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:variable>
                                                <xsl:choose>
                                                  <xsl:when test="matches($formofitem, 'o')">
                                                  <rdamo:P30136
                                                  rdf:resource="{$origManifestationIRI}"/>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <rdamo:P30043
                                                  rdf:resource="{$origManifestationIRI}"/>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:choose>
                                                  <xsl:when test="$isAggregate = 'aam'">
                                                  <xsl:apply-templates select="*" mode="man">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="type"
                                                  select="'reproduction'"/>
                                                  <xsl:with-param name="agg" select="'agg'"/>
                                                  <xsl:with-param name="isElectronic"
                                                  select="$isElectronic"/>
                                                  <xsl:with-param name="isMicroform"
                                                  select="$isMicroform"/>
                                                  </xsl:apply-templates>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:apply-templates select="*" mode="man">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="type"
                                                  select="'reproduction'"/>
                                                  <xsl:with-param name="isElectronic"
                                                  select="$isElectronic"/>
                                                  <xsl:with-param name="isMicroform"
                                                  select="$isMicroform"/>
                                                  </xsl:apply-templates>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:choose>
                                                  <xsl:when test="$isAggregate = 'aam'">
                                                  <xsl:apply-templates select="*" mode="man">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="agg" select="'agg'"/>
                                                  <xsl:with-param name="isElectronic"
                                                  select="$isElectronic"/>
                                                  <xsl:with-param name="isMicroform"
                                                  select="$isMicroform"/>
                                                  </xsl:apply-templates>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:apply-templates select="*" mode="man">
                                                  <xsl:with-param name="baseID" select="$baseID"/>
                                                  <xsl:with-param name="isElectronic"
                                                  select="$isElectronic"/>
                                                  <xsl:with-param name="isMicroform"
                                                  select="$isMicroform"/>
                                                  </xsl:apply-templates>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </rdf:Description>
                                    <!-- mint an original maninfestation if reproduction conditions are met -->
                                    <xsl:if test="$isReproduction != ''">
                                        <rdf:Description rdf:about="{$origManifestationIRI}">
                                            <rdf:type
                                                rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                                            <rdamo:P30462 rdf:resource="{$marcMetadataWorkIRI}"/>
                                            <rdamo:P30139 rdf:resource="{$mainExpressionIRI}"/>
                                            <!-- relationship to aggregating work -->
                                            <xsl:if test="$isAggregate = 'aam'">
                                                <rdamo:P30135 rdf:resource="{$aggWorkIRI}"/>
                                            </xsl:if>
                                            <!-- category for aggregates -->
                                            <xsl:if
                                                test="$isAggregate = 'cam' or $isAggregate = 'pam' or $isAggregate = 'aam' or $isAggregate = 'aamnotaw'">
                                                <rdamd:P30335>
                                                  <xsl:text>Aggregate manifestation</xsl:text>
                                                </rdamd:P30335>
                                            </xsl:if>
                                            <!-- This code can be uncommented to add a manifestation access point to the manifestation description.
                         m2r:mainManifestationAccessPoint() is located in m2r-aps.xsl -->
                                            <xsl:variable name="manifestationAP"
                                                select="m2r:mainManifestationAccessPoint(., $isElectronic, $isMicroform)"/>
                                            <xsl:if test="$manifestationAP">
                                                <rdamd:P30276>
                                                  <xsl:value-of select="$manifestationAP"/>
                                                </rdamd:P30276>
                                            </xsl:if>
                                            <xsl:apply-templates select="*" mode="origMan">
                                                <xsl:with-param name="baseID" select="$baseID"/>
                                                <xsl:with-param name="type" select="'origMan'"/>
                                            </xsl:apply-templates>
                                        </rdf:Description>
                                    </xsl:if>
                                    <!-- ADDITIONAL ENTITIES -->
                                    <!-- Items, nomens, metadata works, and agents are generated as needed
                  so the rdf:Description elements are generated within the field-specific templates.
                  How IRIs are minted vary, see documentation -->
                                    <!-- *****ITEMS***** -->
                                    <xsl:apply-templates select="*" mode="ite">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                        <xsl:with-param name="manIRI" select="$mainManifestationIRI"
                                        />
                                    </xsl:apply-templates>
                                    <!-- *****NOMENS***** -->
                                    <xsl:apply-templates select="*" mode="nom">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                    <!-- *****METADATA WORKS***** -->
                                    <xsl:apply-templates select="*" mode="metaWor">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                        <xsl:with-param name="manIRI" select="$mainManifestationIRI"
                                        />
                                    </xsl:apply-templates>
                                    <!-- *****RELATED AGENTS***** -->
                                    <xsl:apply-templates select="*" mode="age">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                    <!-- *****RELATED WORKS***** -->
                                    <xsl:apply-templates select="*" mode="relWor">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                    <!-- *****CONCEPTS***** -->
                                    <xsl:apply-templates select="*" mode="con">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                    <!-- *****PLACES***** -->
                                    <xsl:apply-templates select="*" mode="pla">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                    <!-- *****TIMESPANS***** -->
                                    <xsl:apply-templates select="*" mode="tim">
                                        <xsl:with-param name="baseID" select="$baseID"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <!-- output records that were identified as aggregates in message -->
                                <xsl:otherwise>
                                    <xsl:message>
                                        <xsl:text>Record {translate(marc:controlfield[@tag='001'], ' ', '')} identified as {$isAggregate} aggregate and was not processed.</xsl:text>
                                    </xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Record {translate(marc:controlfield[@tag='001'], ' ', '')} ({position()}/{last()}) identified as Tactile and was not processed.</xsl:text>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>Record {translate(marc:controlfield[@tag='001'], ' ', '')} ({position()}/{last()}) identified as not valid due to {$isValid} and was not processed.</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- METADATA WORK TEMPLATE -->
    <xsl:template name="marcMetadataWork" expand-text="yes">
        <xsl:param name="inputRecord"/>
        <xsl:param name="marcWorkIRI"/>
        <xsl:param name="mainWorkIRI"/>
        <xsl:param name="aggWorkIRI"/>
        <xsl:param name="mainExpressionIRI"/>
        <xsl:param name="mainManifestationIRI"/>
        <xsl:param name="origManifestationIRI"/>
        <xsl:variable name="marcManIRI"
            select="$BASE || 'transform/man#marc' || encode-for-uri(lower-case(translate(marc:controlfield[@tag = '003'][1], ' ', ''))) || encode-for-uri(translate(marc:controlfield[@tag = '001'][1], ' ', '_'))"/>
        <xsl:variable name="source003">
            <xsl:choose>
                <xsl:when test="marc:controlfield[@tag = '003']">
                    <xsl:value-of select="marc:controlfield[@tag = '003'][1]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'transform'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="marcWorGrpNomIRI"
            select="$BASE || encode-for-uri(lower-case(translate($source003, ' ', ''))) || '/nom#' || encode-for-uri(translate(marc:controlfield[@tag = '001'][1], ' ', '_'))"/>
        <rdf:Description rdf:about="{$marcWorkIRI}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10400>
                <xsl:value-of
                    select="marc:controlfield[@tag = '003'][1] || marc:controlfield[@tag = '001'][1]"
                />
            </rdawd:P10400>
            <rdawd:P10004>Metadata work</rdawd:P10004>
            <rdawd:P10002>
                <xsl:value-of
                    select="'transform/wor#marc' || encode-for-uri(lower-case(translate(marc:controlfield[@tag = '003'][1], ' ', ''))) || encode-for-uri(translate(marc:controlfield[@tag = '001'][1], ' ', '_'))"
                />
            </rdawd:P10002>
            <rdawo:P10072 rdf:resource="{$marcManIRI}"/>
            <rdawo:P10621 rdf:resource="{$mainWorkIRI}"/>
            <rdawo:P10615 rdf:resource="{$mainExpressionIRI}"/>
            <rdawo:P10617 rdf:resource="{$mainManifestationIRI}"/>
            <xsl:if test="$origManifestationIRI != ''">
                <rdawo:P10617 rdf:resource="{$origManifestationIRI}"/>
            </xsl:if>
            <xsl:if test="$aggWorkIRI != ''">
                <rdawo:P10621 rdf:resource="{$aggWorkIRI}"/>
            </xsl:if>
        </rdf:Description>
        <rdf:Description rdf:about="{$marcManIRI}">
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
            <rdamo:P30135 rdf:resource="{$marcWorkIRI}"/>
            <rdamd:P30335>Metadata manifestation</rdamd:P30335>
            <rdamd:P30004>
                <xsl:value-of
                    select="'transform/man#marc' || encode-for-uri(lower-case(translate(marc:controlfield[@tag = '003'][1], ' ', ''))) || encode-for-uri(translate(marc:controlfield[@tag = '001'][1], ' ', '_'))"
                />
            </rdamd:P30004>
            <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1018'}"/>
            <rdamd:P30137>
                <xsl:call-template name="getmarcRecord">
                    <xsl:with-param name="record" select="$inputRecord"/>
                </xsl:call-template>
            </rdamd:P30137>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
