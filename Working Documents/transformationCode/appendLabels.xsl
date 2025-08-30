<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:rdakit="http://metadataregistry.org/uri/profile/rdakit/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:vann="http://purl.org/vocab/vann/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/" 
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ex="http://fakeIRI2.edu/"
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
    xmlns:rdawo="http://rdaregistry.info/Elements/w/object/" exclude-result-prefixes=""
    version="3.0">

    <xsl:variable name="w" select="document('http://www.rdaregistry.info/xml/Elements/w.xml')"/>
    <xsl:variable name="e" select="document('http://www.rdaregistry.info/xml/Elements/e.xml')"/>
    <xsl:variable name="m" select="document('http://www.rdaregistry.info/xml/Elements/m.xml')"/>
    <xsl:variable name="i" select="document('http://www.rdaregistry.info/xml/Elements/i.xml')"/>
    <xsl:variable name="n" select="document('http://www.rdaregistry.info/xml/Elements/n.xml')"/>
    <xsl:variable name="a" select="document('http://www.rdaregistry.info/xml/Elements/a.xml')"/>
    <xsl:variable name="p" select="document('http://www.rdaregistry.info/xml/Elements/p.xml')"/>
    <xsl:variable name="t" select="document('http://www.rdaregistry.info/xml/Elements/t.xml')"/>
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
    <xsl:key name="rdapDoc" match="$p/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:key name="rdatDoc" match="$t/rdf:RDF/rdf:Description"
        use="substring-after(@rdf:about, '/P')"/>
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="/rdf:RDF/rdf:Description/*">
        <xsl:copy-of select="."/>
        <xsl:if
            test="contains(name(.), 'rdaw:') or contains(name(.), 'rdawd:') or contains(name(.), 'rdawo:')">
            <xsl:comment>
                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdawDoc', substring-after(name(.), ':P'), $w)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdae:') or contains(name(.), 'rdaed:') or contains(name(.), 'rdaeo:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdaeDoc', substring-after(name(.), ':P'), $e)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdam:') or contains(name(.), 'rdamd:') or contains(name(.), 'rdamo:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdamDoc', substring-after(name(.), ':P'), $m)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdai:') or contains(name(.), 'rdaid:') or contains(name(.), 'rdaio:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdaiDoc', substring-after(name(.), ':P'), $i)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdan:') or contains(name(.), 'rdand:') or contains(name(.), 'rdano:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdanDoc', substring-after(name(.), ':P'), $n)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdaa:') or contains(name(.), 'rdaad:') or contains(name(.), 'rdaao:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdaaDoc', substring-after(name(.), ':P'), $a)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdap:') or contains(name(.), 'rdapd:') or contains(name(.), 'rdapo:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdapDoc', substring-after(name(.), ':P'), $p)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
        <xsl:if
            test="contains(name(.), 'rdat:') or contains(name(.), 'rdatd:') or contains(name(.), 'rdato:')">
            <xsl:comment>
                                <xsl:value-of select="name(.)"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="key('rdatDoc', substring-after(name(.), ':P'), $t)/rdfs:label[@xml:lang = 'en']"/>
            </xsl:comment>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
