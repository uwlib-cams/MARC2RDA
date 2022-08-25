<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdac="http://rdaregistry.info/Elements/c/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
    xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/"
    xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
    xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
    xmlns:rdan="http://rdaregistry.info/Elements/n/"
    xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
    xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
    xmlns:rdaa="http://rdaregistry.info/Elements/a/"
    xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
    xmlns:rdaao="http://rdaregistry.info/Elements/a/object/" version="3.0">
    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="base" select="'http://fakeIRI2.edu/'"/>
    <xsl:template match="/">
        <rdf:RDF xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:ex="http://fakeIRI.edu/"
            xmlns:rdaw="http://rdaregistry.info/Elements/w/"
            xmlns:rdawd="http://rdaregistry.info/Elements/w/datatype/"
            xmlns:rdawo="http://rdaregistry.info/Elements/w/object/"
            xmlns:rdam="http://rdaregistry.info/Elements/m/"
            xmlns:rdamd="http://rdaregistry.info/Elements/m/datatype/"
            xmlns:rdamo="http://rdaregistry.info/Elements/m/object/"
            xmlns:rdan="http://rdaregistry.info/Elements/n/"
            xmlns:rdand="http://rdaregistry.info/Elements/n/datatype/"
            xmlns:rdano="http://rdaregistry.info/Elements/n/object/"
            xmlns:rdaa="http://rdaregistry.info/Elements/a/"
            xmlns:rdaad="http://rdaregistry.info/Elements/a/datatype/"
            xmlns:rdaao="http://rdaregistry.info/Elements/a/object/">
            <xsl:for-each
                select="//madsrdf:code[@rdf:datatype = 'http://id.loc.gov/datatypes/orgs/normalized']">
                <xsl:variable name="normCode"
                    select="substring-after(../@rdf:about, 'http://id.loc.gov/vocabulary/organizations/')"/>
                <xsl:variable name="corporateBodyAgentIRI"
                    select="concat($base, 'corporateBodyAgent/', $normCode)"/>
                <xsl:variable name="colWorIRI" select="concat($base, 'colWor/', $normCode)"/>
                <xsl:variable name="colManIRI" select="concat($base, 'colMan/', $normCode)"/>
                <rdf:Description rdf:about="{../@rdf:about}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10012"/>
                    <rdano:P80030 rdf:resource="{$corporateBodyAgentIRI}"/>
                    <!--is appellation of corporate body of-->
                </rdf:Description>
                <rdf:Description rdf:about="{$corporateBodyAgentIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10005"/>
                    <rdaao:P50380 rdf:resource="{../@rdf:about}"/>
                    <!--has appellation of corporate body-->
                    <rdaao:P51115 rdf:resource="{$colWorIRI}"/>
                    <!--is collector corporate body of-->
                </rdf:Description>
                <rdf:Description rdf:about="{$colWorIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
                    <rdawo:P10631 rdf:resource="{$corporateBodyAgentIRI}"/>
                    <!--has collector corporate body-->
                    <rdawo:P10072 rdf:resource="{$colManIRI}"/>
                    <!--has manifestation of work-->
                </rdf:Description>
                <rdf:Description rdf:about="{$colManIRI}">
                    <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10007"/>
                    <rdamo:P30135 rdf:resource="{$colWorIRI}"/>
                    <!--has work manifested-->
                    <rdamd:P30277>
                        <xsl:value-of
                            select="concat('Collection of ', ../madsrdf:authoritativeLabel)"/>
                    </rdamd:P30277>
                    <!--has appellati of manifestation-->
                </rdf:Description>
            </xsl:for-each>
        </rdf:RDF>
    </xsl:template>
</xsl:stylesheet>
