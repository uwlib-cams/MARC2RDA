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
    xmlns:fake="http://fakePropertiesForDemo" 
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
    <xsl:include href="m2r-4xx-named.xsl"/>
    
    <xsl:template match="marc:datafield[@tag = '440'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '440-00']"
        mode="wor">
        <rdawo:P10102 rdf:resource="{m2r:relWorkIRI($BASE, .)}"/>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '440'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 3) = '440']"
        mode="man">
        <rdamd:P30106>
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'n']
                | marc:subfield[@code = 'p'] | marc:subfield[@code = 'v'] | marc:subfield[@code = 'x']"/>
        </rdamd:P30106>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '440'] | marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = '440-00']"
        mode="relWor">
       <rdf:Description rdf:about="{m2r:relWorkIRI($BASE, .)}">
           <!--<xsl:call-template name="getmarc"/>-->
           <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
           <rdawd:P10328>
               <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
           </rdawd:P10328>
           <xsl:if test="@tag = '440' and marc:subfield[@code = '6']">
               <xsl:variable name="occNum" select="concat('440-', substring(marc:subfield[@code = '6'], 5, 6))"/>
               <xsl:for-each
                   select="../marc:datafield[@tag = '880'][substring(marc:subfield[@code = '6'], 1, 6) = $occNum]">
                   <rdawd:P10328>
                       <xsl:value-of select="m2r:relWorkAccessPoint(.)"/>
                   </rdawd:P10328>
                   <!-- title -->
                   <xsl:call-template name="FX30-xx-anp"/>
                   <!-- attributes -->
                   <xsl:call-template name="FX30-xx-d"/>
                   <xsl:call-template name="FXXX-xx-l-wor"/>
                   <xsl:call-template name="FXXX-xx-r"/>
               </xsl:for-each>
           </xsl:if>
           <!-- title -->
           <xsl:call-template name="FX30-xx-anp"/>
           <!-- attributes -->
           <xsl:call-template name="FX30-xx-d"/>
           <xsl:call-template name="FXXX-xx-l-wor"/>
           <xsl:call-template name="FXXX-xx-r"/>
       </rdf:Description>
    </xsl:template>
    
    <xsl:template match="marc:datafield[@tag = '490']" mode="man">
        <!--<xsl:call-template name="getmarc"/>-->
        <!-- Accounted-for: $a + $x + $v when LDR/18 is a valid value -->
        <!-- Not accounted for: $6, $7, $8, $l, $y, $z-->
        <!-- 880s not accounted for -->
        <xsl:choose>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = 'a' or substring(preceding-sibling::marc:leader, 19, 1) = 'i'">
                <xsl:call-template name="F490-xx-axv-isbd"/>
            </xsl:when>
            <xsl:when
                test="substring(preceding-sibling::marc:leader, 19, 1) = '' or substring(preceding-sibling::marc:leader, 19, 1) = ' ' or substring(preceding-sibling::marc:leader, 19, 1) = 'c' or substring(preceding-sibling::marc:leader, 19, 1) = 'n' or substring(preceding-sibling::marc:leader, 19, 1) = 'u'">
                <xsl:call-template name="F490-xx-axv-nonIsbd"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>MARC 490 data lost; likely due to an unexpected value in LDR/18</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
