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
    xmlns:fake="http://fakePropertiesForDemo" xmlns:uwf="http://universityOfWashington/functions"
    exclude-result-prefixes="marc ex uwf" version="3.0">
    <xsl:include href="m2r-3xx-named.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    <xsl:import href="m2r-functions.xsl"/>
    
    <xsl:template match="marc:datafield[@tag = '306'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '306']"
        mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20219 rdf:datatype="xsd:time"
                >{replace(.,'([0-9][0-9])([0-9][0-9])([0-9][0-9])','$1:$2:$3')}</rdaed:P20219>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '307'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '307']"
        mode="man" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <rdamd:P30137>
            <xsl:text>{marc:subfield[@code = 'a']}</xsl:text>
            <xsl:if test="marc:subfield[@code = 'b']">
                <xsl:text> {marc:subfield[@code = 'b']}</xsl:text>
            </xsl:if>
        </rdamd:P30137>
    </xsl:template>
    
<!--    <xsl:template match="marc:datafield[@tag = '334']" 
        mode="man">
        <xsl:copy-of select="uwf:rdaLookup('rdami', 'single unit')"/>
    </xsl:template>-->
    
    <xsl:template match="marc:datafield[@tag = '336']" mode="exp">
        <xsl:call-template name="getmarc"/>
        <!-- Accounted for: $a, $b, $2-temporary, $3-partial, $0, $1 -->
        <!--Not accounted for: $2 needs permanent solution, $3 with $0 and $1, $6, $7, $8 -->
        <xsl:call-template name="F336-xx-ab0-string"/>
        <xsl:call-template name="F336-xx-01-iri"/>
    </xsl:template>
    
    <!-- 337 - Media Type -->
    <xsl:template match="marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '337']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F337-string"/>
        <xsl:call-template name="F337-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '337'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '337-00']" 
        mode="con">
        <xsl:call-template name="F337-concept"/>
    </xsl:template>
    
    <!-- 338 - Carrier Type -->
    <xsl:template match="marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '338']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F338-string"/>
        <xsl:call-template name="F338-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '338'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '338-00']" 
        mode="con">
        <xsl:call-template name="F338-concept"/>
    </xsl:template>
    
    <!-- 340 - Physical Medium -->
    <xsl:template match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '340']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F340-b_f_h_i"/>
        <xsl:call-template name="F340-xx-a_c_d_e_g_j_k_l_m_n_o_p_q"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '340'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '340-00']"
        mode="con">
        <xsl:call-template name="F340-concept"/>
    </xsl:template>
    
    <!-- 346 - Video Characteristics -->
    <xsl:template match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '346']" 
        mode="man">
        <xsl:call-template name="getmarc"/>
        <xsl:call-template name="F346-string"/>
        <xsl:call-template name="F346-iri"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '346'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '346-00']" 
        mode="con">
        <xsl:call-template name="F346-concept"/>
    </xsl:template>
    
    <xsl:template
        match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '380']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdawd:P10004>
                <xsl:if test="../marc:subfield[@code = '2']">
                    <xsl:copy-of select="uwf:s2lookup(../marc:subfield[@code = '2'])"/>
                </xsl:if>{.}</rdawd:P10004>
            <xsl:if test="../marc:subfield[@code = '3']">
                <rdawd:P10330>
                    <xsl:text>Category of work {.} applies only to {../marc:subfield[@code = '3']}.</xsl:text>
                </rdawd:P10330>
            </xsl:if>
        </xsl:for-each>
        <!-- 0s, 1s, and 2s will need updating once decision is made -->
        <!--<xsl:copy-of
            select="uwf:conceptTest(marc:subfield[@code = '0'] | marc:subfield[@code = '1'], 'P10004')"
        />-->
        <xsl:for-each select="marc:subfield[@code = '1']">
            <rdaw:P10004>
                <xsl:attribute name="rdf:resource">{.}</xsl:attribute> 
            </rdaw:P10004>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '0']">
            <xsl:choose>
                <xsl:when test="starts-with(., 'http')">
                    <rdaw:P10004>
                        <xsl:attribute name="rdf:resource">{.}</xsl:attribute> 
                    </rdaw:P10004>
                </xsl:when>
                <xsl:otherwise>
                    <rdaw:P10004>{.}</rdaw:P10004>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '382']"
        mode="exp">
        <xsl:if test="@ind1 = ' ' or @ind1 = '0' or @ind1 = '1'">
            <xsl:call-template name="getmarc"/>
            <xsl:call-template name="F382-xx-a_b_d_p_2-exp"/>
            <rdaed:P20215>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdaed:P20215>
            <xsl:copy-of
                select="uwf:conceptTest(marc:subfield[@code = '0'] | marc:subfield[@code = '1'], 'P20215')"
            />
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '382'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '382']"
        mode="wor">
        <xsl:if test="@ind1 = '2' or @ind1 = '3'">
            <xsl:call-template name="getmarc"/>
            <xsl:call-template name="F382-xx-a_b_d_p_2-wor"/>
            <rdawd:P10220>
                <xsl:call-template name="F382-xx-abdenprstv3"/>
            </rdawd:P10220>
            <xsl:copy-of
                select="uwf:conceptTest(marc:subfield[@code = '0'] | marc:subfield[@code = '1'], 'P10220')"
            />
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
