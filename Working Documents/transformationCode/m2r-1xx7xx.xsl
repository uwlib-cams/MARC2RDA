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
    xmlns:uwf="http://universityOfWashington/functions" 
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwmisc="http://uw.edu/all-purpose-namespace/"
    exclude-result-prefixes="marc ex uwf uwmisc" version="3.0">
    
    <xsl:include href="m2r-relators.xsl"/>
    <xsl:include href="getmarc.xsl"/>

    <!-- field level templates - wor, exp, man, ite -->
    <xsl:template match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']" 
        mode = "wor">
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'work'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'work'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']" 
        mode = "exp">
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'expression'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'expression'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']" 
        mode = "man">
        <xsl:param name="baseIRI"/>
        <xsl:call-template name="getmarc"/>
        <xsl:choose>
            <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                <xsl:choose>
                    <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
                        <xsl:call-template name="handle1XXNoRelator">
                            <xsl:with-param name="domain" select="'manifestation'"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- default -->
                        <xsl:copy-of select="uwf:defaultProp(., uwf:fieldType(@tag), 'manifestation', uwf:agentIRI(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handleRelator">
                    <xsl:with-param name="domain" select="'manifestation'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- check if an item will be minted -->
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
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
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$testItem/node() or $testItem/@*">
            <rdamo:P30103 rdf:resource="{concat($baseIRI,'ite', generate-id())}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']" 
        mode = "ite" expand-text="true">
        <xsl:param name="baseIRI"/>
        <xsl:param name="controlNumber"/>
        <xsl:variable name="testItem">
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
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
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- if handleRelator returns a property, then generate an item and apply property -->
        <xsl:if test="$testItem/node() or $testItem/@*">
            <xsl:variable name="genID" select="generate-id()"/>
            <rdf:Description rdf:about="{concat($baseIRI,'ite',$genID)}">
                <xsl:call-template name="getmarc"/>
                <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10003"/>
                <rdaid:P40001>{concat($controlNumber,'ite',$genID)}</rdaid:P40001>
                <rdaio:P40049 rdf:resource="{concat($baseIRI,'man')}"/>
                <xsl:copy-of select="$testItem"/>
            </rdf:Description>
        </xsl:if>
        
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']" 
        mode="age">
        <xsl:param name="baseIRI"/>
        <rdf:Description rdf:about="{uwf:agentIRI(.)}">
            <xsl:call-template name="getmarc"/>
            <xsl:choose>
                <xsl:when test="@tag = '100' or @tag = '700'">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0' or @ind1 = '1' or @ind1 = '2'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10004"/>
                        </xsl:when>
                        <xsl:when test="@ind1 = '3'">
                            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10008"/>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@tag = '110' or @tag = '111' or @tag = '710' or @tag = '711'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                </xsl:when>
                <xsl:when test="@tag = '720'">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10002"/>
                </xsl:when>
            </xsl:choose>
            <xsl:element name="rdaad:P50378"><xsl:value-of select="uwf:agentAccessPoint(.)"/></xsl:element>
            <xsl:choose>
                <xsl:when test="not(marc:subfield[@code = 'e']) and not(marc:subfield[@code = '4']) and not(marc:subfield[@code = 'j'])">
                    <xsl:choose>
                        <xsl:when test=" @tag = '100' or @tag = '110' or @tag = '111'">
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
            </xsl:choose>
        </rdf:Description>
    </xsl:template>
</xsl:stylesheet>
