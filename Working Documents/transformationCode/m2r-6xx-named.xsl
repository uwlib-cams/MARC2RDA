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
    xmlns:m2r="http://marc2rda.info/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
    <!-- Concept labels -->
    <!-- these vary by field. Each field has a label template that outputs the label based on the present subfields -->
    <!-- most subfields are concatenated and then combined with $v, $x, $y, and $z values separated by two dashes -->
    
    <xsl:template name="F600-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                | marc:subfield[@code = 'd'] | marc:subfield[@code = 'j'] | marc:subfield[@code = 'q'] | marc:subfield[@code = 'u']
                | marc:subfield[@code = 't'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g']
                | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n']
                | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p'] | marc:subfield[@code = 'r'] | marc:subfield[@code = 's']"/>
            <xsl:text>--</xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F610-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
                | marc:subfield[@code = 'd'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'u']
                | marc:subfield[@code = 't'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'k']
                | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o']
                | marc:subfield[@code = 'p'] | marc:subfield[@code = 'r'] | marc:subfield[@code = 's']"/>   
            <xsl:text>--</xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F611-label" expand-text="yes">
        <xsl:variable name="label">
           <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd'] 
            | marc:subfield[@code = 'e'] | marc:subfield[@code = 'u'] | marc:subfield[@code = 't'] 
            | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g'] 
            | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'n'] 
            | marc:subfield[@code = 'p'] | marc:subfield[@code = 'q'] | marc:subfield[@code = 's']"/> 
            <xsl:text>--</xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    
    <xsl:template name="F630-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'f']
            | marc:subfield[@code = 'g'] | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l']
            | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 'p']
            | marc:subfield[@code = 'r'] | marc:subfield[@code = 's'] | marc:subfield[@code = 't']"/>
            <xsl:text>--</xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F647-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'g']"/>
            <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:text>--</xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
            </xsl:if>
            </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F648-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'v']
            | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label) => replace(' -', '-') => replace('- ', '-')"/>
    </xsl:template>
    <xsl:template name="F650-label" expand-text="yes">
        <xsl:variable name="label">
           <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'v']
            | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/> 
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F651-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:choose>
                <xsl:when test="marc:subfield[@code = 'g']">
                    <xsl:text>{marc:subfield[@code = 'a']} ({marc:subfield[@code = 'g']})</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="marc:subfield[@code = 'a']"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>--</xsl:text>
            <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F653-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a']" separator=" "/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F654-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']
            | marc:subfield[@code = 'v'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F655-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']"/>
            <xsl:if test="marc:subfield[@code = 'v'] or marc:subfield[@code = 'x'] or marc:subfield[@code = 'y'] or marc:subfield[@code = 'z']">
                <xsl:text>--</xsl:text>
                <xsl:value-of select="marc:subfield[@code = 'v'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
            </xsl:if>
           </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F656-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'k'] | marc:subfield[@code = 'v'] 
            | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F657-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'v'] 
            | marc:subfield[@code = 'x'] | marc:subfield[@code = 'y'] | marc:subfield[@code = 'z']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F662-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] 
            | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
            | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    <xsl:template name="F688-label" expand-text="yes">
        <xsl:variable name="label">
            <xsl:value-of select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'g']" separator="--"/>
        </xsl:variable>
        <xsl:value-of select="m2r:stripEndPunctuation($label)"/>
    </xsl:template>
    
    
    <!-- This template outputs "has subject" as either a datatype or object property
        If it is an object property (there is a source present in the field)
        m2r:subjectIRI (located in m2r-iris.xsl) is called to return the subject IRI -->
    <xsl:template name="F6XX-subject">
        <xsl:param name="prefLabel"/>
        <xsl:variable name="scheme" select="m2r:getSubjectSchemeCode(.)"/>
        <xsl:choose>
            <!-- no source of term -->
            <xsl:when test="not(matches(@ind2, '[012356]')) and not(marc:subfield[@code = '2'])">
                <xsl:choose>
                    <!-- no $0 or $1 to use, use datatype property and string value -->
                    <xsl:when test="starts-with(m2r:subjectIRI(., $scheme, $prefLabel), 'http://marc2rda.edu')">
                        <rdawd:P10256>
                            <xsl:value-of select="$prefLabel"/>
                        </rdawd:P10256>
                    </xsl:when>
                    <!-- $0 or $1 present, use that value -->
                    <xsl:otherwise>
                        <rdaw:P10256 rdf:resource="{m2r:subjectIRI(., $scheme, $prefLabel)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!-- else there is a source - we mint an IRI baed on the source (scheme) and label-->
            <xsl:otherwise>
                <rdaw:P10256 rdf:resource="{m2r:subjectIRI(., $scheme, $prefLabel)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- handles subfield $v as category of work
        Outputs "has category of work" as datatype or object property -->
    <xsl:template name="F6XX-xx-v">
        <xsl:choose>
            <!-- if no source, use datatype and string value -->
            <xsl:when test="not(matches(../@ind2, '[012356]')) and not(../marc:subfield[@code = '2'])">
                <rdawd:P10004>
                    <xsl:value-of select="m2r:stripEndPunctuation(.)"/>
                </rdawd:P10004>
            </xsl:when>
            <!-- otherwise, mint a concept for the category of work in $v -->
            <xsl:otherwise>
                <rdaw:P10004 rdf:resource="{m2r:conceptIRI(m2r:getSubjectSchemeCode(..), .)}"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
