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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    
    <xsl:template name="F008-c6">
        <xsl:param name="char6"/>
        <xsl:if test="$char6 = 'c'">
            <rdamd:P30137>
                <xsl:text>Continuing resource currently published.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char6 = 'd'">
            <rdamd:P30137>
                <xsl:text>Continuing resource ceased publication.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c15-17">
        <xsl:param name="char15-17"/>
        <rdamo:P30279 rdf:resource="{concat('http://id.loc.gov/vocabulary/countries/', $char15-17)}"/>
    </xsl:template>
    
    <xsl:template name="F008-c18-21-BOOKS">
        <xsl:param name="char18-21"/>
        <xsl:analyze-string select="$char18-21" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'a'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1014'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1008'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'c'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1012'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'd'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#d'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'e'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1011'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'f'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#f'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'g'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#g'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'h'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1002'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'i'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1001'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'j'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1004'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1003'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'l'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1013'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'm'">
                        <rdam:P30453 rdf:resource="{'https://doi.org/10.6069/uwlswd.gq3z-mv97#m'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'o'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1010'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'p'">
                        <rdam:P30453 rdf:resource="{'http://rdaregistry.info/termList/IllusContent/1006'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c22-BOOKS">
        <xsl:param name="char22"/>
        <xsl:choose>
            <xsl:when test="$char22 != ' ' and $char22 != '|'">
                <rdae:P20322 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.aec4-nv40#', $char22)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23-BOOKS-origMan">
        <xsl:param name="char23"/>
        <xsl:choose>
            <xsl:when test="$char23 = 'd'">
                <rdam:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'g'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#gx'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'h'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#hx'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'i'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#ix'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'q'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#q'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 's'">
                <rdam:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1003'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23-BOOKS">
        <xsl:param name="char23"/>
        <xsl:choose>
            <xsl:when test="$char23 = 'a'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#a'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'b'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1022'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'c'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1028'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'o'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1018'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'r'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#r'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23-f-BOOKS">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'f'">
            <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
