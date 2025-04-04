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
    <xsl:import href="m2r-functions.xsl"/>
    <xsl:import href="m2r-iris.xsl"/>
    <xsl:import href="getmarc.xsl"/>
    
    <!-- 777 --> 
    <xsl:template name="F777-xx-abcdefghjklmnopqrstuvwxyz" expand-text="yes">
        <xsl:variable name="subfields" select="marc:subfield[@code = 'a' or @code = 'b' or @code = 'c' or
            @code = 'd' or @code = 'e' or @code = 'f' or
            @code = 'g' or @code = 'h' or @code = 'i' or
            @code = 'j' or @code = 'k' or @code = 'l' or
            @code = 'm' or @code = 'n' or @code = 'o' or
            @code = 'p' or @code = 'q' or @code = 'r' or
            @code = 's' or @code = 't' or @code = 'u' or
            @code = 'v' or @code = 'w' or @code = 'x' or
            @code = 'y' or @code = 'z']" />
        
        <xsl:if test="$subfields">
            <xsl:text>On carrier unit with: </xsl:text>
            <xsl:for-each select="$subfields">
                <xsl:value-of select="."/>
                <xsl:choose>
                    <xsl:when test="position() != last()">
                        <xsl:text>; </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>: </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    
</xsl:stylesheet>
