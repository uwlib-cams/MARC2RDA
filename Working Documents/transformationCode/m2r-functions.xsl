<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs marc ex uwf"
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
    xmlns:fake="http://fakePropertiesForDemo"
    xmlns:uwf="http://universityOfWashington/functions"
    version="3.0">
    <xsl:variable name="collBase">http://marc2rda.edu/fake/colMan/</xsl:variable>
    <xsl:variable name="lookupDoc" select="document('lookup/$5-preprocessedRDA.xml')"/>
    <xsl:key name="normCode" match="rdf:Description[rdaad:P50006]" use="rdaad:P50006"/>
    
    <xsl:function name="uwf:test" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="property"/>
        <xsl:variable name="ns-wemi">
            <xsl:choose>
                <xsl:when test="starts-with($property,'P30')">http://rdaregistry.info/Elements/m/object/</xsl:when>
                <xsl:when test="starts-with($property,'P20')">http://rdaregistry.info/Elements/e/object/</xsl:when>
                <xsl:otherwise>namespaceError</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$subfield">
            <xsl:choose>
                <xsl:when test="starts-with(.,'http://rdaregistry.info/termList')">
                    <xsl:sequence>
                        <xsl:element name="{$property}" namespace="{$ns-wemi}">
                            <xsl:attribute name="rdf:resource">{.}</xsl:attribute>
                        </xsl:element>
                    </xsl:sequence>
                </xsl:when>
                <xsl:when test="./@code='1'">
                    <xsl:element name="{$property}" namespace="{$ns-wemi}">
                        <xsl:attribute name="rdf:resource">{.}</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence>
                        <xsl:comment>MARC data source at field 340 contains a $0 with a value representing authority data; a solution for outputting these in RDA is not yet devised.</xsl:comment>
                    </xsl:sequence>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    <!-- Proposal: Separate functions for RDA entities and concepts -->
    <xsl:function name="uwf:conceptTest" expand-text="yes">
        <xsl:param name="subfield"/>
        <xsl:param name="property"/>
        <xsl:variable name="ns-wemi">
            <xsl:choose>
                <xsl:when test="starts-with($property, 'P10')">rdaw</xsl:when>
                <xsl:when test="starts-with($property, 'P20')">rdae</xsl:when>
                <xsl:when test="starts-with($property, 'P30')">rdam</xsl:when>
                <xsl:when test="starts-with($property, 'P40')">rdai</xsl:when>
                <xsl:otherwise>namespaceError</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:for-each select="$subfield">
            <xsl:choose>
                <xsl:when test="contains(., 'http://rdaregistry.info/termList')">
                    <xsl:sequence>
                        <xsl:element name="{$ns-wemi || ':' || $property}">
                            <xsl:attribute name="rdf:resource">{'http://rdaregistry.info/termList'
                                ||
                                substring-after(.,'http://rdaregistry.info/termList')}</xsl:attribute>
                        </xsl:element>
                    </xsl:sequence>
                </xsl:when>
                <xsl:when test="contains(., 'http://id.loc.gov')">
                    <xsl:sequence>
                        <xsl:element name="{$ns-wemi || ':' || $property}">
                            <xsl:attribute name="rdf:resource">{'http://id.loc.gov' ||
                                substring-after(., 'http://id.loc.gov')}</xsl:attribute>
                        </xsl:element>
                    </xsl:sequence>
                </xsl:when>
                <xsl:when test="./@code = '1'">
                    <xsl:element name="{$ns-wemi || ':' || $property}">
                        <xsl:attribute name="rdf:resource">{.}</xsl:attribute>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence>
                        <!-- TBD: HTML document of unused $0 -->
                        <xsl:comment>MARC data source at field {../@tag} contains a $0 with a value that is not recognized or is not appropriate for RDA.</xsl:comment>
                    </xsl:sequence>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="uwf:S5lookup" expand-text="yes">
        <xsl:param name="code5"/>
        <rdaio:P40161
            rdf:resource="{$collBase}{$lookupDoc/key('normCode',$code5)/rdaad:P50006[@rdf:datatype='http://id.loc.gov/datatypes/orgs/normalized']}"
        />
    </xsl:function>
</xsl:stylesheet>