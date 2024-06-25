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
    xmlns:fake="http://fakePropertiesForDemo" exclude-result-prefixes="marc ex" version="3.0">
    
    <xsl:template name="F514-xx-zabcdefghijkmu" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'z']">
            <xsl:text>{marc:subfield[@code = 'z']} </xsl:text>
        </xsl:if>
        <xsl:for-each
            select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd']
            | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f'] | marc:subfield[@code = 'g'] | marc:subfield[@code = 'h']
            | marc:subfield[@code = 'i'] | marc:subfield[@code = 'j'] | marc:subfield[@code = 'k'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'u']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Attribute accuracy report: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Attribute accuracy value: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Attribute accuracy explanation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Logical consistency report: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Completeness report: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'f'">
                <xsl:text>Horizontal position accuracy report: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'g'">
                <xsl:text>Horizontal position accuracy value: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'h'">
                <xsl:text>Horizontal position accuracy explanation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'i'">
                <xsl:text>Vertical positional accuracy report: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'j'">
                <xsl:text>Vertical positional accuracy value: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'k'">
                <xsl:text>Vertical positional accuracy explanation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'm'">
                <xsl:text>Cloud cover: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'u'">
                <xsl:text>Uniform Resource Identifier: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 526 -->
    <xsl:template name="F526-xx-iabcdz5" expand-text="yes">
        <!-- for-each loop accounts for repeatable subfields and regular punctuation -->
        <rdamd:P30137>
            <xsl:text>Reading program: </xsl:text>
            <xsl:if test="marc:subfield[@code = 'i']">
                <xsl:text>{marc:subfield[@code = 'i']} </xsl:text>
            </xsl:if>
            <xsl:for-each
                select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd'] | marc:subfield[@code = 'z']">
                <xsl:if test="@code = 'a'">
                    <xsl:text>Program name: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'b'">
                    <xsl:text>Interest level: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'c'">
                    <xsl:text>Reading level: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'd'">
                    <xsl:text>Title point value: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="@code = 'z'">
                    <xsl:text>Public note: {.}</xsl:text>
                </xsl:if>
                <xsl:if test="position() != last()">
                    <xsl:text>; </xsl:text>
                </xsl:if>
            </xsl:for-each>
            <xsl:if test="marc:subfield[@code = '5']">
                <xsl:text> (At institution: {marc:subfield[@code = '5']})</xsl:text>
            </xsl:if>
        </rdamd:P30137>
    </xsl:template>
    <xsl:template name="F526-xx-x" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/', generate-id())}</rdawd:P10002>
            <rdawo:P10617 rdf:resource="{concat($baseIRI,'man')}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'man')}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:value-of select="."/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    
    <!-- 534 -->
    <xsl:template name="F534-xx-pabcefklmnotxz" expand-text="yes">
        <xsl:choose>
            <xsl:when test="marc:subfield[@code = 'p']">
                <xsl:text>{marc:subfield[@code = 'p']} </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Original version note: </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:for-each
            select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'e'] | 
            marc:subfield[@code = 'f'] | marc:subfield[@code = 'k'] | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm']
            | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o'] | marc:subfield[@code = 't'] | marc:subfield[@code = 'x'] | marc:subfield[@code = 'z']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Main entry of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Edition statement of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Publication, distribution, etc. of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Physical description, etc. of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'f'">
                <xsl:text>Series statement of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'k'">
                <xsl:text>Key title of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'l'">
                <xsl:text>Location of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'm'">
                <xsl:text>Material specific details: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'n'">
                <xsl:text>Note about original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <xsl:text>Other resource identifier: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 't'">
                <xsl:text>Title statement of original: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'x'">
                <xsl:text>International Standard Serial Number: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'z'">
                <xsl:text>International Standard Book Number: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F534-xx-origMan" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'b']">
            <rdamd:P30107>{.}</rdamd:P30107>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'c']">
            <rdamd:P30111>{.}</rdamd:P30111>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'e']">
            <rdamd:P30137>
                <xsl:text>Physical description, etc.: {.}</xsl:text>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'f']">
            <rdamd:P30106>{.}</rdamd:P30106>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'm']">
            <rdamd:P30137>
                <xsl:text>Material specific details: {.}</xsl:text>
            </rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'n']">
            <rdamd:P30137>{.}</rdamd:P30137>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'o']">
            <rdamd:P30004>{.}</rdamd:P30004>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 't']">
            <rdamd:P30134>{.}</rdamd:P30134>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <rdamd:P30004>{.}</rdamd:P30004>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 541 -->
    <xsl:template name="F541-xx-abcdefhno" expand-text="yes">
        <!-- for-each loop accounts for repeatable subfields and regular punctuation -->
        <xsl:for-each
            select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c'] | marc:subfield[@code = 'd'] | 
            marc:subfield[@code = 'e'] | marc:subfield[@code = 'h'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Source of acquisition: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Address: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Method of acquisition: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Date of acquisition: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Accession number: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'h'">
                <xsl:text>Purchase price: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'n'">
                <xsl:text>Extent: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <xsl:text>Type of unit: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F541-0x" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/', generate-id())}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:call-template name="F541-xx-abcdefhno"/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    
    <!-- 552 -->
    <xsl:template name="F552-xx-zabcdefghijklmnopu" expand-text="yes">
        <xsl:if test="marc:subfield[@code = 'z']">
            <xsl:text>{marc:subfield[@code = 'z']} </xsl:text>
        </xsl:if>
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e'] | marc:subfield[@code = 'f']  | marc:subfield[@code = 'g']
            | marc:subfield[@code = 'h'] | marc:subfield[@code = 'i'] | marc:subfield[@code = 'j'] | marc:subfield[@code = 'k']
            | marc:subfield[@code = 'l'] | marc:subfield[@code = 'm'] | marc:subfield[@code = 'n'] | marc:subfield[@code = 'o']
            | marc:subfield[@code = 'p'] | marc:subfield[@code = 'u']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Entity type label: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text> Entity type definition and source: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Attribute label: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Attribute definition and source: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Attribute definition and source: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'f'">
                <xsl:text>Enumerated domain value definition and source: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'g'">
                <xsl:text>Range domain minimum and maximum: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'h'">
                <xsl:text>Codeset name and source: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'i'">
                <xsl:text>Unrepresentable domain: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'j'">
                <xsl:text>Attribute units of measurement and resolution: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'k'">
                <xsl:text>Beginning and ending date of attribute values: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'l'">
                <xsl:text>Attribute value accuracy: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'm'">
                <xsl:text>Attribute value accuracy explanation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'n'">
                <xsl:text>Attribute measurement frequency: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <xsl:text>Entity and attribute overview: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'p'">
                <xsl:text>Entity and attribute detail citation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'u'">
                <xsl:text>Uniform Resource Identifier: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 556 -->
    <xsl:template name="F556-xx-az" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'z']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Information about documentation note: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'z'">
                <xsl:text>ISBN: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 561 -->
    <xsl:template name="F561-xx-au" expand-text="yes">
        <xsl:value-of select="marc:subfield[@code = 'a']"/>
        <xsl:if test="marc:subfield[@code = 'u']">
            <xsl:text> Additional information at: </xsl:text>
            <xsl:for-each select="marc:subfield[@code = 'u']">
                <xsl:value-of select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: </xsl:text>
            <xsl:value-of select="marc:subfield[@code = '3']"/>
            <xsl:text>)</xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template name="F561-0x" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/', generate-id())}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:call-template name="F561-xx-au"/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    
    <!-- 563 -->
    <xsl:template name="F563-xx-au3" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'u']">
            <xsl:if test="@code = 'a'">
                <xsl:text>{.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'u'">
                <xsl:text>Uniform Resource Identifier: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- 565 -->
    <xsl:template name="F565-xx-abcde" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b'] | marc:subfield[@code = 'c']
            | marc:subfield[@code = 'd'] | marc:subfield[@code = 'e']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Number of cases/variables: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Name of variable: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Unit of analysis: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Universe of data: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Filing scheme or code: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:if test="not(matches(., '^.*?;\s*$'))">
                    <xsl:text>;</xsl:text>
                </xsl:if>
                <xsl:if test="not(matches(., '\s$'))">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 567 -->
    <xsl:template name="F567-xx-ab2" expand-text="yes">
        <xsl:for-each select="marc:subfield[@code = 'a']">
            <xsl:text>Methodology: {.}</xsl:text>
            <xsl:if test="following-sibling::marc:subfield[@code = 'b'] and following-sibling::marc:subfield[@code = '2']">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = 'b'][following-sibling::marc:subfield[@code = '2']]">
            <xsl:text>Controlled term: {.}; </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="marc:subfield[@code = '2'][preceding-sibling::marc:subfield[@code = 'b']]">
            <xsl:text>Source of term: {.}</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <!-- 581 -->
    <xsl:template name="F581-xx-az3" expand-text="yes">
        <xsl:text>Publications: {marc:subfield[@code = 'a']}</xsl:text>
        <xsl:for-each select="marc:subfield[@code = 'z']">
            <xsl:text> ISBN: {.}</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:text>;</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- 583 -->
    <xsl:template name="F583-xx-abcdefhijklnouxz23" expand-text="yes">
        <xsl:for-each select="marc:subfield[not(.[@code = '5']) and not(.[@code = '6'])]">
            <xsl:if test="@code = 'a'">
                <xsl:text>Action: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Action identification: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'c'">
                <xsl:text>Time/date of action: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'd'">
                <xsl:text>Action interval: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'e'">
                <xsl:text>Contingency for action: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'f'">
                <xsl:text>Authorization: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'h'">
                <xsl:text>Jurisdiction: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'i'">
                <xsl:text>Method of action: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'j'">
                <xsl:text>Site of action: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'k'">
                <xsl:text>Action agent: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'l'">
                <xsl:text>Status: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'n'">
                <xsl:text>Extent: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'o'">
                <xsl:text>Type of unit: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'u'">
                <xsl:text>Uniform Resource Identifier: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'x' and ../@ind1 = '0'">
                <xsl:text>Private note: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'z'">
                <xsl:text>Public note: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = '2'">
                <xsl:text>Source of term: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = '3'">
                <xsl:text>(Applies to: {.})</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="F583-1x-x" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/', generate-id())}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:value-of select="."/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    <xsl:template name="F583-0x" expand-text="yes">
        <xsl:param name="baseIRI"/>
        <xsl:param name="genID"/>
        <rdf:Description rdf:about="{concat('http://marc2rda.edu/fake/MetaWor/', generate-id())}">
            <!--Does not meet min description of a work; needs to be linked to a metadata exp/man-->
            <rdf:type rdf:resource="http://rdaregistry.info/Elements/c/C10001"/>
            <rdawd:P10002>{concat('MetaWor/', generate-id())}</rdawd:P10002>
            <rdawo:P10616 rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Statement"/>
            <rdf:subject rdf:resource="{concat($baseIRI,'ite',$genID)}"/>
            <rdf:predicate rdf:resource="http://rdaregistry.info/Elements/i/datatype/P40026"/>
            <rdf:object>
                <xsl:call-template name="F583-xx-abcdefhijklnouxz23"/>
            </rdf:object>
            <rdawd:P10004>Private</rdawd:P10004>
        </rdf:Description>
    </xsl:template>
    
    <xsl:template name="F584-xx-ab35" expand-text="true">
        <xsl:for-each select="marc:subfield[@code = 'a'] | marc:subfield[@code = 'b']">
            <xsl:if test="@code = 'a'">
                <xsl:text>Accumulation: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="@code = 'b'">
                <xsl:text>Frequency of use: {.}</xsl:text>
            </xsl:if>
            <xsl:if test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:if test="marc:subfield[@code = '3']">
            <xsl:text> (Applies to: {marc:subfield[@code = '3']})</xsl:text>
        </xsl:if>
        <xsl:if test="marc:subfield[@code = '5']">
            <xsl:text> (At institution: {marc:subfield[@code = '5']})</xsl:text>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
