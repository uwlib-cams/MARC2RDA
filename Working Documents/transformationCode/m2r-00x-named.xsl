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
    
    <xsl:template name="F008-c18-CONT">
        <xsl:param name="char18"/>
        <xsl:choose>
            <xsl:when test="$char18 = 'a'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1013'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'b'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1007'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'c'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1005'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'd'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1001'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'e'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1003'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'f'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1012'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'g'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1014'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'h'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1015'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'i'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1002'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'j'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1006'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'k'">
                <rdaw:P10368 rdf:resource="{'https://doi.org/10.6069/uwlswd.ggnh-4s58#k'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'm'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1008'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'q'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1010'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 's'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1009'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 't'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1011'}"/>
            </xsl:when>
            <xsl:when test="$char18 = 'w'">
                <rdaw:P10368 rdf:resource="{'http://rdaregistry.info/termList/frequency/1004'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c19-CONT">
        <xsl:param name="char19"/>
        <xsl:choose>
            <xsl:when test="$char19 = 'n'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Normalized irregular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char19 = 'r'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Regular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char19 = 'x'">
                <rdamd:P30137>
                    <xsl:text>Regularity: Completely irregular.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c21-CONT">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 != ' ' and $char21 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.62zz-1534#', $char21)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c22-SOME">
        <xsl:param name="char22"/>
        <xsl:choose>
            <xsl:when test="$char22 != ' ' and $char22 != '|'">
                <rdae:P20322 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.aec4-nv40#', $char22)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c22-COMP">
        <xsl:param name="char22"/>
        <xsl:choose>
            <xsl:when test="$char22 != ' ' and $char22 != '|'">
                <rdam:P30305 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.aec4-nv40#', $char22)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c22-CONT">
        <xsl:param name="char22"/>
        <xsl:if test="$char22 = 'a'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microfilm.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'b'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microfiche.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'c'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Microopaque.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'd'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Large print.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'e'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Newspaper format.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'f'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Braille.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'o'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Online.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 'q'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Direct electronic.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char22 = 's'">
            <rdamd:P30137>
                <xsl:text>Originally issued as: Electronic.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-SOME-origMan">
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
    
    <xsl:template name="F008-c23-SOME">
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
    
    <xsl:template name="F008-c23-f-SOME">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'f'">
            <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-COMP-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'q'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#q'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-COMP">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'o'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#o'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c24-27-BOOKS">
        <xsl:param name="char24-27"/>
        <xsl:analyze-string select="$char24-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = ' ' or . = '|' or . = '2' or . = 'b' or . = 'k' or . = 'q'"/>
                    <xsl:when test=". = 'h'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#hx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'x'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#t'}"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.633m-h220#', .)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c24-27-2bkq-BOOKS">
        <xsl:param name="char24-27"/>
        <xsl:analyze-string select="$char24-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = '2'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.633m-h220#2'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdamd:P30137>
                            <xsl:text>Includes bibliographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdamd:P30137>
                            <xsl:text>Includes discographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                    <xsl:when test=". = 'q'">
                        <rdamd:P30137>
                            <xsl:text>Includes filmographies.</xsl:text>
                        </rdamd:P30137>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c24-CONT">
        <xsl:param name="char24"/>
        <xsl:if test="$char24 != ' ' and $char24 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.jfr5-z647#', $char24)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c26-COMP">
        <xsl:param name="char26"/>
        <xsl:if test="$char26 != 'u' and $char26 != 'z' and $char26 != ' ' and $char26 != '|'">
            <rdam:P30018 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.mkjn-bp10#', $char26)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c28-SOME">
        <xsl:param name="char28"/>
        <xsl:if test="$char28 != ' ' and $char28 != '|' and $char28 != 'z' and $char28 != 'u'">
            <xsl:choose>
                <xsl:when test="$char28 = 'n'">
                    <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.2eg3-1x53#nx'}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdam:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.2eg3-1x53#', $char28)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c29-BOOKS">
        <xsl:param name="char29"/>
        <xsl:if test="$char29 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.t1gh-8294#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-BOOKS">
        <xsl:param name="char30"/>
        <xsl:if test="$char30 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.tq9s-1157#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c31-BOOKS">
        <xsl:param name="char31"/>
        <xsl:if test="$char31 = '1'">
            <rdamd:P30137>
                <xsl:text>Index present.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-BOOKS">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != 'u' and $char33 != '|' and $char33 != ' '">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.f447-ax91#', $char33)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-abc-BOOKS">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'a' or $char34 = 'b' or $char34 = 'c'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.x4ce-sd21#', $char34)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-d-BOOKS">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'd'">
            <rdamd:P30137>
                <xsl:text>Contains biographical information.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
