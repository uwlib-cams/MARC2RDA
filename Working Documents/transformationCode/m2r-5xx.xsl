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
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-5xx-named.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    
    <!-- 500 - General Note -->
    <xsl:template
        match="marc:datafield[@tag = '500'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '500-00']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: </xsl:text>
                        <xsl:value-of select="marc:subfield[@code = '3']"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                </rdamd:P30137>
                
                <xsl:if test="(@tag = '500') and (marc:subfield[@code = '6'])">
                    <xsl:variable name="occNum" select="concat('500-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdamd:P30137>
                            <xsl:value-of select="marc:subfield[@code = 'a']"/>
                            <xsl:if test="marc:subfield[@code = '3']">
                                <xsl:text> (Applies to: </xsl:text>
                                <xsl:value-of select="marc:subfield[@code = '3']"/>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                        </rdamd:P30137>
                    </xsl:for-each>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template
        match="marc:datafield[@tag = '500'][marc:subfield[@code = '5']] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '500-00'][marc:subfield[@code = '5']]"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
            <rdaid:P40028>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
                <xsl:if test="marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: </xsl:text>
                    <xsl:value-of select="marc:subfield[@code = '3']"/>
                    <xsl:text>)</xsl:text>
                </xsl:if>
            </rdaid:P40028>
            <!-- only uses $5 from 500 fields not linked 880s -->
            <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            <xsl:if test="(@tag = '500') and (marc:subfield[@code = '6'])">
                <xsl:variable name="occNum" select="concat('500-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <rdaid:P40028>
                        <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        <xsl:if test="marc:subfield[@code = '3']">
                            <xsl:text> (Applies to: </xsl:text>
                            <xsl:value-of select="marc:subfield[@code = '3']"/>
                            <xsl:text>)</xsl:text>
                        </xsl:if>
                    </rdaid:P40028>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <!-- 501 - With Note -->
    <xsl:template
        match="marc:datafield[@tag = '501'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '501']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test="@tag = '501' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 6) = '501-00')">
                    <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '501'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '501-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <xsl:call-template name="getmarc"/>
                <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6'] and @tag = '501'">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                           <xsl:value-of select="marc:subfield[@code = 'a']"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 502 - Dissertation Note -->
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'b']">
            <rdawd:P10077>{marc:subfield[@code = 'b']}</rdawd:P10077>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'c']">
            <rdawd:P10006>{marc:subfield[@code = 'c']}</rdawd:P10006>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'd']">
            <rdawd:P10215>{replace(marc:subfield[@code = 'd'], '\.\s*$', '')}</rdawd:P10215>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = 'a'] or marc:subfield[@code = 'g']">
            <rdawd:P10209>
                <xsl:for-each
                    select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'g']">
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </rdawd:P10209>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdawo:P10002 rdf:resource="{uwf:nomenIRI(., 'nom/', '', '')}"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '502'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '502']"
        mode="nom" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdf:Description rdf:about="{uwf:nomenIRI(., 'nom/', '', '')}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                <rdand:P80068>{replace(., '\.\s*$', '')}</rdand:P80068>
                <rdand:P80078>Dissertation identifier</rdand:P80078>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 504 - Bibliography, etc. Note -->
    <xsl:template
        match="marc:datafield[@tag = '504'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '504']"
        mode="man">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30455>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:value-of
                    select="concat('; Number of references: ', marc:subfield[@code = 'b'], '.')"/>
            </xsl:if>
        </rdamd:P30455>
    </xsl:template>
    
    <!-- 505 - Formatted Contents Notes -->
    <xsl:template match="marc:datafield[@tag= '505'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '505']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:call-template name="F505-xx-agrtu"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 506 - Restrictions on Access Note -->
    <xsl:template
        match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']"
        mode="man" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:variable name="online_resource">
            <xsl:value-of select="if (some $F338 in ../marc:datafield[@tag = '338']
                satisfies ((starts-with($F338/marc:subfield[@code = '2'][1], 'rda')
                and (contains($F338/marc:subfield[@code = 'a'], 'online resource')
                or contains($F338/marc:subfield[@code = 'b'], 'cr')
                or contains($F338/marc:subfield[@code = 'b'], '1018'))))) then 'true' else 'false'"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$online_resource = 'true'">
                <rdamd:P30145>
                    <xsl:call-template name="F506-xx-abcdegqu3"/>
                    <xsl:if test="marc:subfield[@code = '5']">
                        <xsl:text> (at institution: {uwf:s5NameLookup(marc:subfield[@code = '5'])})</xsl:text>
                    </xsl:if>
                </rdamd:P30145>
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:for-each select="marc:subfield[@code = 'f']">
                        <rdam:P30145 rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'], .)}"/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdamd:P30137>
                                <xsl:text>Restriction on access {uwf:conceptIRI(../marc:subfield[@code = '2'], .)} applies to {./marc:subfield[@code = '3']}</xsl:text>
                            </rdamd:P30137>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@tag = '506' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('506-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdamd:P30145>
                            <xsl:call-template name="F506-xx-abcdegqu3"/>
                        </rdamd:P30145>
                    </xsl:for-each>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:variable name="online_resource">
            <xsl:value-of select="if (some $F338 in ../marc:datafield[@tag = '338']
                satisfies ((starts-with($F338/marc:subfield[@code = '2'][1], 'rda')
                and (contains($F338/marc:subfield[@code = 'a'], 'online resource')
                or contains($F338/marc:subfield[@code = 'b'], 'cr')
                or contains($F338/marc:subfield[@code = 'b'], '1018'))))) then 'true' else 'false'"/>
        </xsl:variable>
        <!-- create the item IRI and rdf:description for this item -->
        <xsl:if test="$online_resource = 'false'">
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <xsl:call-template name="getmarc"/>
                <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>    
                </xsl:if>
                <rdaid:P40047>
                    <xsl:call-template name="F506-xx-abcdegqu3"/>
                </rdaid:P40047>
                <xsl:if test="marc:subfield[@code = '2']">
                    <xsl:for-each select="marc:subfield[@code = 'f']">
                        <rdai:P40047 rdf:resource="{uwf:conceptIRI(../marc:subfield[@code = '2'], .)}"/>
                        <xsl:if test="../marc:subfield[@code = '3']">
                            <rdaid:P40028>
                                <xsl:text>Restriction on access {uwf:conceptIRI(../marc:subfield[@code = '2'][1], .)} applies to {./marc:subfield[@code = '3']}</xsl:text>
                            </rdaid:P40028>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@tag = '506' and marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('506-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each
                            select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <rdaid:P40047>
                                <xsl:call-template name="F506-xx-abcdegqu3"/>
                            </rdaid:P40047>
                        </xsl:for-each>
                    </xsl:if>
                </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '506'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '506-00']" 
        mode="con">
        <xsl:call-template name="F506-xx-f2"/>
    </xsl:template>
    
    <!-- 508 - Creation/Production Credits Note -->
    <xsl:template match="marc:datafield[@tag='508'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '508']" 
        mode="man">
        <rdamd:P30137><xsl:value-of select="concat('Credits: ', marc:subfield[@code = 'a'])"/></rdamd:P30137>
    </xsl:template>
    
    <!-- 511 - Participant or Performer Note -->
    <xsl:template match="marc:datafield[@tag='511'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '511']" 
        mode="man">
        <rdamd:P30137>
            <xsl:if test="@ind1 = '1'"><xsl:text>Cast: </xsl:text></xsl:if>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 514 - Data Quality Note -->
    <xsl:template match="marc:datafield[@tag='514'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '514']" 
        mode="wor">
        <rdawd:P10330>
            <xsl:call-template name="F514-xx-zabcdefghijkmu"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 515 - Numbering Peculiarities Notes -->
    <xsl:template match="marc:datafield[@tag='515'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '515']" 
        mode="man" expand-text="yes">
        <rdamd:P30137>
            <xsl:text>Numbering peculiarities note: {marc:subfield[@code = 'a']}</xsl:text>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 516 - Type of Computer File or Data Note -->
    <xsl:template match="marc:datafield[@tag='516'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '516']" 
        mode="man">
        <rdamd:P30018>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30018>
    </xsl:template>
    
    <!-- 518 - Date/Time and Place of an Event Note -->
    <xsl:template match="marc:datafield[@tag='518'] | marc:datafield[@tag='880'][substring(marc:subfield[@code = '6'], 1, 3) = '518']" 
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:if test="marc:subfield[@code = 'a']">
                <xsl:text>Date/time and place of an event note: {marc:subfield[@code = 'a']}</xsl:text>
            </xsl:if>
            <xsl:for-each select="marc:subfield[@code = 'd'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
                | marc:subfield[@code = '0'] | marc:subfield[@code = '1'] | marc:subfield[@code = '2']">
                <xsl:if test="@code = 'd'">
                    <xsl:text>Date of event: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'o'">
                    <xsl:text>Other event information: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'p'">
                    <xsl:text>Place of event: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '0'">
                    <xsl:text>Authority record control number or standard number for controlled place of event term: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '1'">
                    <xsl:text>Real World Object URI: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = '2'">
                    <xsl:text>Source of term for controlled place of event term: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
            </xsl:if>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 520 - Summary, Etc.-->
    <xsl:template
        match="marc:datafield[@tag = '520'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '520']"
        mode="exp">
        <xsl:call-template name="getmarc"/>
        <rdaed:P20069>
            <xsl:call-template name="F520-xx-abcu23"/>
        </rdaed:P20069>
    </xsl:template>

    <!-- 521 - Target Audience Note-->
    <xsl:template
        match="marc:datafield[@tag = '521'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '521']"
        mode="man">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:call-template name="F521-xx-ab3"/>
        </rdamd:P30137>
    </xsl:template> 

    <!-- 522 - Geographic Coverage Note -->
    <xsl:template
        match="marc:datafield[@tag = '522'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '522']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10216>
            <xsl:value-of select="concat('Geographic coverage: ', marc:subfield[@code = 'a'])"/>
        </rdawd:P10216>
    </xsl:template>
    
    <!-- 524 - Preferred Citation of Described Materials Note -->
    <xsl:template match="marc:datafield[@tag = '524'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '524']" 
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30005>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdamd:P30005>
        <xsl:if test="marc:subfield[@code = '2']">
            <rdamd:P30137>
                <xsl:text>Preferred citation {marc:subfield[@code = 'a']} has source of schema used: {marc:subfield[@code = '2'][1]}</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '3']">
            <rdamd:P30137>
                <xsl:text>Preferred citation {marc:subfield[@code = 'a']} applies to: {marc:subfield[@code = '3']}</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <!-- 526 - Study Program Information Note -->
    <xsl:template match="marc:datafield[@tag = '526'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '526']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F526-xx-iabcdz5"/>
        <!-- iterate through each x (nonpublic note) subfield -->
        <!-- iri is 'http://marc2rda.edu/fake/MetaWor/' + x subfield's id-->
        <xsl:for-each select="marc:subfield[@code = 'x']">
            <rdamo:P30462
                rdf:resource="{uwf:metaWorIRI(.)}"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '526'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '526']" 
        mode="metaWor">
        <xsl:param name="baseIRI"/>
        <!-- iterate through each x (nonpublic note) subfield -->
        <xsl:for-each select="marc:subfield[@code = 'x']">
            <xsl:call-template name="F526-xx-x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 527 - Censorship Note -->
    <xsl:template
        match="marc:datafield[@tag = '527'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '527']"
        mode="exp">
        <xsl:call-template name="getmarc"/>
        <rdaed:P20071>
            <xsl:value-of select="marc:subfield[@code = 'a']"/>
        </rdaed:P20071>
    </xsl:template>
    
    <!-- 532 - Accessibility Note -->
    <xsl:template
        match="marc:datafield[@tag = '532'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '532']"
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F532-xx-a"/>
    </xsl:template>
    
    <!-- 534 - Original version note -->
    <!-- CODE ON HOLD -->
    <xsl:template
        match="marc:datafield[@tag = '534'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '534']"
        mode="man">
        <xsl:variable name="leader0607" select="substring(preceding-sibling::marc:leader, 6, 2)"/>
        <rdamd:P30137>
            <xsl:call-template name="F534-xx-pabcefklmnotxz"/>
        </rdamd:P30137>
        <xsl:if test="$leader0607 != 'ab' and $leader0607 != 'ai' and $leader0607 != 'as'">
            <xsl:if test="@tag = '534' or (@tag = '880' and substring(marc:subfield[@code = '6'], 1, 6) = '534-00')">
                <rdamo:P30024 rdf:resource="{concat('http://marc2rda.edu/fake/man/', generate-id())}"/>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '534'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '534-00']"
        mode="man2">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="leader0608" select="concat(substring(preceding-sibling::marc:leader, 6, 1), substring(preceding-sibling::marc:leader, 8, 1))"/>
        <xsl:if test="$leader0608 != 'ab' and $leader0608 != 'ai' and $leader0608 != 'as'">
            <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/man/', generate-id())}">
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                <rdamo:P30139 rdf:resource="{concat($baseIRI,'exp')}"/>
                <xsl:variable name="field022" select="preceding-sibling::marc:datafield[@tag = '022'][marc:subfield[@code = 'a']]"/>
                <xsl:if test="$field022/marc:subfield[@code = 'a'] = marc:subfield[@code = 'x']">
                    <xsl:call-template name="F534-xx-origMan"/>
                    <xsl:if test="marc:subfield[@code = '6']">
                        <xsl:variable name="occNum" select="concat('534-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                        <xsl:for-each select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                            <xsl:call-template name="F534-xx-origMan"/>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 536 - Funding Information Note -->
    <xsl:template
        match="marc:datafield[@tag = '536'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '536']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:call-template name="F536-xx-abcdefgh"/>
        </rdawd:P10330>
    </xsl:template> 
    
    <!-- 538 - System Details Note -->
    <xsl:template
        match="marc:datafield[@tag = '538'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '538-00']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:for-each select="marc:subfield[@code = '5']">
                    <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30162>
                    <xsl:call-template name="F538-xx-aiu"/>
                </rdamd:P30162>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '538'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '538-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="aiu">
            <xsl:call-template name="F538-xx-aiu"/>
        </xsl:variable>
        <!-- create the item IRI and rdf:description for this item -->
        <xsl:for-each select="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <xsl:copy-of select="uwf:S5lookup(.)"/>
                <rdaid:P40028>
                   <xsl:value-of select="$aiu"/>
                </rdaid:P40028>
                <xsl:if test="../@tag = '538' and ../marc:subfield[@code = '6']">
                    <xsl:variable name="occNum"
                        select="concat('538-', substring(../marc:subfield[@code = '6'], 5, 6))"/>
                    <xsl:for-each
                        select="../../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:call-template name="F538-xx-aiu"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:for-each>
    </xsl:template>
    
    
    <!-- 541 - Immediate Source of Acquisition Note -->
    <xsl:template
        match="marc:datafield[@tag = '541'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '541-00']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '541'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '541-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <!-- create the item IRI and rdf:description for this item -->
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <xsl:call-template name="getmarc"/>
            <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40050>
                    <xsl:call-template name="F541-xx-abcdefhno"/>
                </rdaid:P40050>
            </xsl:if>
            <xsl:if test="@ind1 = '0'">
                <rdaio:P40164
                    rdf:resource="{uwf:metaWorIRI(.)}"/>
            </xsl:if>
            <xsl:if test="@tag = '541' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('541-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40050>
                            <xsl:call-template name="F541-xx-abcdefhno"/>
                        </rdaid:P40050>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{uwf:metaWorIRI(.)}"
                        />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F541-0x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '541' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('541-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F541-0x">
                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                        <xsl:with-param name="genID" select="$genID"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 542 - Information Relating to Copyright Status -->
    <xsl:template
        match="marc:datafield[@tag = '542'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '542']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="@ind1 = '0'">
                <rdamo:P30462 rdf:resource="{uwf:metaWorIRI(.)}"/>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:call-template name="F542-xx-abcdefghijklmnopqrsu3"/>
                </rdamd:P30137>
                <xsl:call-template name="F542-1x-e_f_g_i_j_p"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '542'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '542']"
        mode="metaWor">
        <xsl:param name="baseIRI"/>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F542-0x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 544 - Location of Other Archival Materials Note -->
    <xsl:template
        match="marc:datafield[@tag = '544'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '544']"
        mode="man">
        <rdamd:P30137>
            <xsl:call-template name="F544-xx-dabcen"/>
        </rdamd:P30137>
    </xsl:template>

    <!-- 546 - Language Note -->
    <xsl:template
        match="marc:datafield[@tag = '546'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '546']"
        mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdaed:P20062>
                <xsl:value-of select="."/>
            </rdaed:P20062>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>Form of notation {.} applies to a manifestation's {../marc:subfield[@code = '3']}.</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '546'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '546']"
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdamd:P30137>
                <xsl:value-of select="."/>
                <xsl:if test="../marc:subfield[@code = '3']">
                    <xsl:text> (Applies to: {../marc:subfield[@code = '3']})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 547 - Former Title Complexity Note -->
    <xsl:template
        match="marc:datafield[@tag = '547'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '547']"
        mode="man" expand-text="true">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:text>Former title complexity note: {marc:subfield[@code = 'a']}</xsl:text>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 552 - Entity and Attribute Information Note -->
    <xsl:template
        match="marc:datafield[@tag = '552'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '552']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:call-template name="F552-xx-zabcdefghijklmnopu"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 556 - Information About Documentation Note -->
    <xsl:template
        match="marc:datafield[@tag = '556'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '556']"
        mode="wor" expand-text="true">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:call-template name="F556-xx-az"/>
        </rdawd:P10330>
    </xsl:template>
    
    
    <!-- 561 - Ownership and Custodial History -->
    <!-- match on tag 561 or an unlinked 880 field where $6 = 561-00 -->
    <xsl:template
        match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
    </xsl:template> 
    
    <xsl:template
        match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <!-- create the item IRI and rdf:description for this item -->
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <xsl:call-template name="getmarc"/>
            <rdaid:P40001>{concat($controlNumber, 'ite', $genID)}</rdaid:P40001>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40026>
                    <xsl:call-template name="F561-xx-au"/>
                </rdaid:P40026>
            </xsl:if>
            <xsl:if test="@ind1 = '0'">
                <rdaio:P40164
                    rdf:resource="{uwf:metaWorIRI(.)}"/>
            </xsl:if>
            <!-- if 561 field has $6, find associated 880 andd do the same mapping -->
            <xsl:if test="@tag = '561' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('561-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <!-- use for-each - there may be more than one associated 880 -->
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40026>
                            <xsl:call-template name="F561-xx-au"/>
                        </rdaid:P40026>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{uwf:metaWorIRI(.)}"
                        />
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '561'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '561-00']"
        mode="metaWor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F561-0x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '561' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('561-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F561-0x">
                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                        <xsl:with-param name="genID" select="$genID"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 563 - Binding Information -->
    <xsl:template match="marc:datafield[@tag = '563'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '563']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test=".[@tag = '563'] or .[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '563-00']">
                    <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:call-template name="F563-xx-au3"/>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '563'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '563-00']"
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <xsl:call-template name="getmarc"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:call-template name="F563-xx-au3"/>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6'] and @tag = '563'">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:call-template name="F563-xx-au3"/>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 565 - Case File Characteristics Note -->
    <xsl:template
        match="marc:datafield[@tag = '565'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '565']"
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:if test="marc:subfield[@code = '3']">
                <xsl:text>{marc:subfield[@code = '3']}: </xsl:text>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@ind1 = '0'">
                    <xsl:text>Case file characteristics: </xsl:text>
                </xsl:when>
                <xsl:when test="@ind1 = '8'"/>
                <xsl:otherwise>
                    <xsl:text>File size: </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="F565-xx-abcde"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 567 - Methodology Note -->
    <xsl:template
        match="marc:datafield[@tag = '567'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '567']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:call-template name="F567-xx-ab2"/>
        </rdawd:P10330>
    </xsl:template>
    
    
    <!-- 581 - Publications about Described Materials Note -->
    <xsl:template
        match="marc:datafield[@tag = '581'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '581']"
        mode="man">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:call-template name="F581-xx-az3"/>
        </rdamd:P30137>
    </xsl:template>
    
    <!-- 583 - Action Note -->
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']"
        mode="man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']" 
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
            <xsl:call-template name="getmarc"/>
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
            <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
            </xsl:if>
            <xsl:if test="@ind1 != '0'">
                <rdaid:P40028>
                    <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
                </rdaid:P40028>
                <!-- subfield 'x' is private note -->
                <!-- for each one, create triple 'is item described with metadata by' [metadataWork IRI] -->
                <!-- metadataWork IRI = 'http://marc2rda.edu/fake/MetaWor/' + generate-id() of subfield x -->
                <xsl:for-each select="marc:subfield[@code = 'x']">
                    <!-- need to do a for-each to set context for subfield id -->
                    <rdaio:P40164
                        rdf:resource="{uwf:metaWorIRI(.)}"
                    />
                </xsl:for-each>
            </xsl:if>
            <!-- @ind1 = '0'is private field -->
            <xsl:if test="@ind1 = '0'">
                <!-- 'is item described with metadata by' 'https://marc2rda.edu/fake/MetaWor/[end of item id] -->
                <rdaio:P40164
                    rdf:resource="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}"/>
            </xsl:if>
            
            <xsl:if test="@tag = '583' and marc:subfield[@code = '6']">
                <xsl:variable name="occNum"
                    select="concat('583-', substring(marc:subfield[@code = '6'], 5, 6))"/>
                <!-- use for-each - there may be more than one associated 880 -->
                <xsl:for-each
                    select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                    <xsl:if test="@ind1 != '0'">
                        <rdaid:P40028>
                            <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
                        </rdaid:P40028>
                        <xsl:for-each select="marc:subfield[@code = 'x']">
                            <rdaio:P40164
                                rdf:resource="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}"
                            />
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="@ind1 = '0'">
                        <rdaio:P40164
                            rdf:resource="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '583'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '583-00']" 
        mode="metaWor" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:variable name="genID" select="generate-id()"/>
        <xsl:if test="@ind1 != '0'">
            <!-- for each sets same context as above, ensures id value is the same -->
            <xsl:for-each select="marc:subfield[@code = 'x']">
                <xsl:call-template name="F583-1x-x">
                    <xsl:with-param name="baseIRI" select="$baseIRI"/>
                    <xsl:with-param name="genID" select="$genID"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="@ind1 = '0'">
            <xsl:call-template name="F583-0x">
                <xsl:with-param name="baseIRI" select="$baseIRI"/>
                <xsl:with-param name="genID" select="$genID"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- again, match with the associated 880 field and do the same mapping -->
        <xsl:if test="@tag = '583' and marc:subfield[@code = '6']">
            <xsl:variable name="occNum"
                select="concat('583-', substring(marc:subfield[@code = '6'], 5, 6))"/>
            <xsl:for-each
                select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                <xsl:if test="@ind1 != '0'">
                    <!-- for each sets same context as above, ensures id value is the same -->
                    <xsl:for-each select="marc:subfield[@code = 'x']">
                        <xsl:call-template name="F583-1x-x">
                            <xsl:with-param name="baseIRI" select="$baseIRI"/>
                            <xsl:with-param name="genID" select="$genID"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="@ind1 = '0'">
                    <xsl:call-template name="F583-0x">
                        <xsl:with-param name="baseIRI" select="$baseIRI"/>
                        <xsl:with-param name="genID" select="$genID"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <!-- 584 - Accumulation and Frequency of Use Note -->
    <xsl:template
        match="marc:datafield[@tag = '584'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '584']"
        mode="wor">
        <xsl:call-template name="getmarc"/>
        <rdawd:P10330>
            <xsl:call-template name="F584-xx-ab35"/>
        </rdawd:P10330>
    </xsl:template>
    
    <!-- 585 - Exhibitions note -->
    <xsl:template
        match="marc:datafield[@tag = '585'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '585']"
        mode="man" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = '5']">
                <xsl:if test=".[@tag = '585'] or .[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '585-00']">
                    <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <rdamd:P30137>
                    <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                    </xsl:if>
                </rdamd:P30137>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '585'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '585-00']" 
        mode="ite" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:if test="marc:subfield[@code = '5']">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <xsl:call-template name="getmarc"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                <xsl:copy-of select="uwf:S5lookup(marc:subfield[@code = '5'])"/>
                <rdaid:P40028>
                    <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                    <xsl:if test="marc:subfield[@code = '3']">
                        <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                    </xsl:if>
                </rdaid:P40028>
                <xsl:if test="marc:subfield[@code = '6']">
                    <xsl:variable name="occNum" select="substring(marc:subfield[@code = '6'], 5, 6)"/>
                    <xsl:for-each
                        select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 5, 6) = $occNum]">
                        <rdaid:P40028>
                            <xsl:text>Exhibition note: {marc:subfield[@code = 'a']}</xsl:text>
                            <xsl:if test="marc:subfield[@code = '3']">
                                <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
                            </xsl:if>
                        </rdaid:P40028>
                    </xsl:for-each>
                </xsl:if>
            </rdf:Description>
        </xsl:if>
    </xsl:template>
    
    <!-- 586 - Awards Note -->
    <xsl:template
        match="marc:datafield[@tag = '586'] |  marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '586']"
        mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdaed:P20005>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
            </rdaed:P20005>
            <xsl:if test="marc:subfield[@code = '3']">
                <rdaed:P20071>
                    <xsl:text>{marc:subfield[@code = 'a']} applies to: {marc:subfield[@code = '3']}</xsl:text>
                </rdaed:P20071>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    
    <!-- 588 - Source of Description Note -->
    <xsl:template
        match="marc:datafield[@tag = '588'] |  marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '588']"
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:if test="marc:subfield[@code = 'a']">
            <rdamd:P30137>
                <xsl:if test="@ind1 = '0'">
                    <xsl:text>Source of description: </xsl:text>
                </xsl:if>
                <xsl:if test="@ind1 = '1'">
                    <xsl:text>Latest issue consulted: </xsl:text>
                </xsl:if>
                <xsl:value-of select="marc:subfield[@code = 'a']"/>
                <xsl:if test="marc:subfield[@code = '5']">
                    <xsl:text> (Applies to: {uwf:s5NameLookup(marc:subfield[@code = '5'])})</xsl:text>
                </xsl:if>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    
    <!-- <xsl:template match="*" mode="wor"/>
        <xsl:template match="*" mode="exp"/>
        <xsl:template match="*" mode="man"/>
        <xsl:template match="*" mode=""></xsl:template>-->
</xsl:stylesheet>
