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
    <xsl:template match="marc:datafield[@tag = '306']" mode="exp" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <rdaed:P20219 rdf:datatype="xsd:time"
                >{replace(.,'([0-9][0-9])([0-9][0-9])([0-9][0-9])','$1:$2:$3')}</rdaed:P20219>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '336']" mode="exp">
        <xsl:call-template name="getmarc"/>
        <!-- Accounted for: $a, $b, $2-temporary, $3-partial, $0, $1 -->
        <!--Not accounted for: $2 needs permanent solution, $3 with $0 and $1, $6, $7, $8 -->
        <xsl:call-template name="F336-xx-ab0-string"/>
        <xsl:call-template name="F336-xx-01-iri"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '337']" mode="man">
        <xsl:call-template name="getmarc"/>
        <!-- Always maps to rdam:P30002, no matter the value -->
        <!-- Accounted for: $a, $b, $0, $1 -->
        <!--Not accounted for: $2, $3, $6, $7, $8 -->
        <xsl:call-template name="F337-string"/>
        <xsl:call-template name="F337-iri"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '338']" mode="man">
        <xsl:call-template name="getmarc"/>
        <!-- Always maps to rdae:P30001, no matter the value -->
        <!-- Accounted for: $a, $b, $0, $1 -->
        <!--Not accounted for: $2, $3, $6, $7, $8 -->
        <xsl:call-template name="F338-string"/>
        <xsl:call-template name="F338-iri"/>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '340']" mode="man">
        <xsl:call-template name="getmarc"/>
        <!-- Accounted-for: $a $b $c $d $e $f $g $i $j $k $l $m $n $o $p $3-->
        <!-- Not accounted-for: $h (not mapped), $q (new field), $6, $8 -->
        <!-- Temporary or partial solution for: $2 -->
        <xsl:call-template name="F340-xx-abcdefghijklmnop"/>
    </xsl:template>
    <xsl:template
        match="marc:datafield[@tag = '380'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '380']"
        mode="wor" expand-text="yes">
        <xsl:call-template name="getmarc"/>
        <!-- TBD: $2(lookup), $3(aggregate), $7 -->
        <rdawd:P10004>{marc:subfield[@code='a']}</rdawd:P10004>
        <xsl:copy-of
            select="uwf:conceptTest(marc:subfield[@code = '0'] | marc:subfield[@code = '1'], 'P10004')"
        />
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
