<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:ex="http://fakeIRI.edu/"
    xmlns:rdaw="http://rdaregistry.info/Elements/w/"
    xmlns:rdae="http://rdaregistry.info/Elements/e/"
    xmlns:rdam="http://rdaregistry.info/Elements/m/" xmlns:fake="http://fakePropertiesForDemo"
    exclude-result-prefixes="marc ex" version="3.0">
    <xsl:template name="F264-abc">
        <xsl:value-of
            select="concat(marc:subfield[@code = 'a'], ' ', marc:subfield[@code = 'b'], ' ', marc:subfield[@code = 'c'])"
        />
    </xsl:template>

    <xsl:template name="F264-0-a">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:choose>
                <!-- condition with = probably need toacocunt for a possible terminal colon -->
                <xsl:when test="contains(., '=')">
                    <rdam:P30086>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdam:P30086>
                    <rdam:P30091>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdam:P30091>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdam:P30086>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdam:P30086>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30086>
                                <xsl:value-of select="."/>
                            </rdam:P30086>
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
                    <rdam:P30088>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdam:P30088>
                    <rdam:P30092>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdam:P30092>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdam:P30088>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdam:P30088>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30088>
                                <xsl:value-of select="."/>
                            </rdam:P30088>
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
                    <rdam:P30087>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdam:P30087>
                    <rdam:P30090>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdam:P30090>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdam:P30087>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdam:P30087>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30087>
                                <xsl:value-of select="."/>
                            </rdam:P30087>
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
                    <rdam:P30085>
                        <xsl:value-of select="substring-before(., '=')"/>
                    </rdam:P30085>
                    <rdam:P30089>
                        <xsl:value-of select="substring-after(., '=')"/>
                    </rdam:P30089>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="contains(., ' :')">
                            <rdam:P30085>
                                <xsl:value-of select="substring-before(., ' :')"/>
                            </rdam:P30085>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30085>
                                <xsl:value-of select="."/>
                            </rdam:P30085>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
