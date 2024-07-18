<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:rdakit="http://metadataregistry.org/uri/profile/rdakit/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ex="http://fakeIRI2.edu/" xmlns:fake="http://fakePropertiesForDemo"
    xmlns:rdaa="http://rdaregistry.info/Elements/a/"
    xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
    xmlns:rdaao="http://rdaregistry.info/Elements/a/object/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdaed="http://rdaregistry.info/Elements/e/datatype/"
    xmlns:rdaeo="http://rdaregistry.info/Elements/e/object/"
    xmlns:rdai="http://rdaregistry.info/Elements/i/"
    xmlns:rdaid="http://rdaregistry.info/Elements/i/datatype/"
    xmlns:rdaio="http://rdaregistry.info/Elements/i/object/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/"
    xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
    xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
    xmlns:rdawo="http://rdaregistry.info/Elements/w/object/" 
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/" exclude-result-prefixes=""
    version="3.0">

    <xsl:variable name="w" select="document('http://www.rdaregistry.info/xml/Elements/w.xml')"/>
    <xsl:variable name="e" select="document('http://www.rdaregistry.info/xml/Elements/e.xml')"/>
    <xsl:variable name="m" select="document('http://www.rdaregistry.info/xml/Elements/m.xml')"/>
    <xsl:variable name="i" select="document('http://www.rdaregistry.info/xml/Elements/i.xml')"/>
    <xsl:variable name="n" select="document('http://www.rdaregistry.info/xml/Elements/n.xml')"/>
    <xsl:variable name="a" select="document('http://www.rdaregistry.info/xml/Elements/a.xml')"/>
    <xsl:key name="rdawDoc" match="$w/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdaeDoc" match="$e/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdamDoc" match="$m/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdaiDoc" match="$i/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdanDoc" match="$n/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdaaDoc" match="$a/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="/rdf:RDF/rdf:Description/rdf:type">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="@rdf:resource = 'http://rdaregistry.info/Elements/c/C10001'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Work.en'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rdf:resource = 'http://rdaregistry.info/Elements/c/C10006'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Expression.en'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rdf:resource = 'http://rdaregistry.info/Elements/c/C10007'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Manifestation.en'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rdf:resource = 'http://rdaregistry.info/Elements/c/C10003'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Item.en'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rdf:resource = 'http://rdaregistry.info/Elements/c/C10012'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Nomen.en'"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@rdf:resource= 'http://rdaregistry.info/Elements/c/C10004'">
                    <xsl:attribute name="rdf:resource">
                        <xsl:value-of select="'http://rdaregistry.info/Elements/c/Agent.en'"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/rdf:RDF/rdf:Description/*[starts-with(name(.), 'rda')]">
        <xsl:if
            test="contains(name(.), 'rdaw:') or contains(name(.), 'rdawd:') or contains(name(.), 'rdawo:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdawDoc', substring-after(name(.), ':P'), $w)/reg:lexicalAlias/@rdf:resource => substring-after('/w/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdae:') or contains(name(.), 'rdaed:') or contains(name(.), 'rdaeo:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdaeDoc', substring-after(name(.), ':P'), $e)/reg:lexicalAlias/@rdf:resource => substring-after('/e/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdam:') or contains(name(.), 'rdamd:') or contains(name(.), 'rdamo:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdamDoc', substring-after(name(.), ':P'), $m)/reg:lexicalAlias/@rdf:resource => substring-after('/m/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdai:') or contains(name(.), 'rdaid:') or contains(name(.), 'rdaio:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdaiDoc', substring-after(name(.), ':P'), $i)/reg:lexicalAlias/@rdf:resource => substring-after('/i/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdan:') or contains(name(.), 'rdand:') or contains(name(.), 'rdano:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdanDoc', substring-after(name(.), ':P'), $n)/reg:lexicalAlias/@rdf:resource => substring-after('/n/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdaa:') or contains(name(.), 'rdaad:') or contains(name(.), 'rdaao:')">
            <xsl:variable name="prefix" select="substring-before(name(.), ':')"/>
            <xsl:variable name="alias" select="key('rdaaDoc', substring-after(name(.), ':P'), $a)/reg:lexicalAlias/@rdf:resource => substring-after('/a/')"/>
            <xsl:element name="{$prefix || ':' || $alias}">
                <xsl:for-each select="@*">
                    <xsl:attribute name="{name(.)}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:value-of select="."/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
