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
    xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F264-abc">
        <!-- THIS TEMPLATE MUST BE REPAIRED.
            Subfields a, b, and c can all repeat and cannot simply be concatenated.
            REQUIRED: logic that tests for the presence of a repeating $a, $b, or $c
            ...then outputs a statement for the first, the second, the third, etc.
            ...or finds a way to concatenate the repeating fields.
            ERROR IN THE CODE BELOW: only position [1] is selected for each subfield.-->
        <xsl:value-of
            select="concat(marc:subfield[@code = 'a'][1], ' ', marc:subfield[@code = 'b'][1], ' ', marc:subfield[@code = 'c'][1])"
        />
    </xsl:template>

    <xsl:template name="F264-0-a">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <!-- condition with = probably need toacocunt for a possible terminal colon -->
                <xsl:when test="contains(., '=')">
                    <rdamd:P30086>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdamd:P30086>
                    <rdamd:P30091>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdamd:P30091>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdamd:P30086>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdamd:P30086>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30086>
                                <xsl:value-of select="."/>
                            </rdamd:P30086>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-1-a">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <!-- condition with = probably need toacocunt for a possible terminal colon -->
                <xsl:when test="contains(., '=')">
                    <rdamd:P30088>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdamd:P30088>
                    <rdamd:P30092>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdamd:P30092>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdamd:P30088>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdamd:P30088>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30088>
                                <xsl:value-of select="."/>
                            </rdamd:P30088>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-2-a">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <!-- condition with = probably need toacocunt for a possible terminal colon -->
                <xsl:when test="contains(., '=')">
                    <rdamd:P30087>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdamd:P30087>
                    <rdamd:P30090>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdamd:P30090>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdamd:P30087>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdamd:P30087>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30087>
                                <xsl:value-of select="."/>
                            </rdamd:P30087>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="F264-3-a">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <!-- condition with = probably need toacocunt for a possible terminal colon -->
                <xsl:when test="contains(., '=')">
                    <rdamd:P30085>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdamd:P30085>
                    <rdamd:P30089>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdamd:P30089>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdamd:P30085>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdamd:P30085>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdamd:P30085>
                                <xsl:value-of select="."/>
                            </rdamd:P30085>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
