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
    xmlns:m2r="http://universityOfWashington/functions"
    exclude-result-prefixes="marc m2r" version="3.0">
    
    <!-- 006 -->
    <xsl:template name="F006-c1-4-BK">
        <xsl:param name="char1-4"/>
        <xsl:call-template name="F008-c18-21-BK">
            <xsl:with-param name="char18-21" select="$char1-4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-CR">
        <xsl:param name="char1"/>
        <xsl:call-template name="F008-c18-CR">
            <xsl:with-param name="char18" select="$char1"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-4-MP">
        <xsl:param name="char1-4"/>
        <xsl:call-template name="F008-c18-21-MP">
            <xsl:with-param name="char18-21" select="$char1-4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-2-MU">
        <xsl:param name="char1-2"/>
        <xsl:call-template name="F008-c18-19-MU">
            <xsl:with-param name="char18-19" select="$char1-2"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-3-VM">
        <xsl:param name="char1-3"/>
        <xsl:call-template name="F008-c18-20-VM">
            <xsl:with-param name="char18-20" select="$char1-3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c1-3-VM-man">
        <xsl:param name="char1-3"/>
        <xsl:call-template name="F008-c18-20-VM-origMan">
            <xsl:with-param name="char18-20" select="$char1-3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c2-CR">
        <xsl:param name="char2"/>
        <xsl:call-template name="F008-c19-CR">
            <xsl:with-param name="char19" select="$char2"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c3-MU">
        <xsl:param name="char3"/>
        <xsl:call-template name="F008-c20-MU">
            <xsl:with-param name="char20" select="$char3"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c4-CR">
        <xsl:param name="char4"/>
        <xsl:call-template name="F008-c21-CR">
            <xsl:with-param name="char21" select="$char4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c4-MU">
        <xsl:param name="char4"/>
        <xsl:call-template name="F008-c21-MU">
            <xsl:with-param name="char21" select="$char4"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-SOME">
        <xsl:param name="char5"/>
        <xsl:call-template name="F008-c22-SOME">
            <xsl:with-param name="char22" select="$char5"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-CR">
        <xsl:param name="char5"/>
        <xsl:call-template name="F008-c22-CR">
            <xsl:with-param name="char22" select="$char5"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c5-6-MP">
        <xsl:param name="char5-6"/>
        <xsl:call-template name="F008-c22-23-MP">
            <xsl:with-param name="char22-23" select="$char5-6"></xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6_12-f-SOME">
        <xsl:param name="char6_12"/>
        <xsl:call-template name="F008-c23_29-f-SOME">
            <xsl:with-param name="char23_29" select="$char6_12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-BK">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-z-BK-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-CF">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23-CF">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-CF-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-CR">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-MX">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-MX-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-xz-SOME-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c6-MU">
        <xsl:param name="char6"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-ghi-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char6"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23-xz-SOME-origMan">
            <xsl:with-param name="char23" select="$char6"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-10-BK">
        <xsl:param name="char7-10"/>
        <xsl:call-template name="F008-c24-27-BK">
            <xsl:with-param name="char24-27" select="$char7-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-10-2bkq-BK">
        <xsl:param name="char7-10"/>
        <xsl:call-template name="F008-c24-27-2bkq-BK">
            <xsl:with-param name="char24-27" select="$char7-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-CR">
        <xsl:param name="char7"/>
        <xsl:call-template name="F008-c24-CR">
            <xsl:with-param name="char24" select="$char7"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-MP">
        <xsl:param name="char7"/>
        <xsl:call-template name="F008-c24-MP">
            <xsl:with-param name="char24" select="$char7"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c7-12-MU">
        <xsl:param name="char7-12"/>
        <xsl:call-template name="F008-c24-29-MU-origMan">
            <xsl:with-param name="char24-29" select="$char7-12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-10-CR">
        <xsl:param name="char8-10"/>
        <xsl:call-template name="F008-c25-27-CR">
            <xsl:with-param name="char25-27" select="$char8-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-10-bkq-CR">
        <xsl:param name="char8-10"/>
        <xsl:call-template name="F008-c25-27-bkq-CR">
            <xsl:with-param name="char25-27" select="$char8-10"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-abdefg-MP">
        <xsl:param name="char8"/>
        <xsl:call-template name="F008-c25-abdefg-MP">
            <xsl:with-param name="char25" select="$char8"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c8-acd-MP">
        <xsl:param name="char8"/>
        <xsl:call-template name="F008-c25-acd-MP-origMan">
            <xsl:with-param name="char25" select="$char8"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c9-CF">
        <xsl:param name="char9"/>
        <xsl:call-template name="F008-c26-CF">
            <xsl:with-param name="char26" select="$char9"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c11-SOME">
        <xsl:param name="char11"/>
        <xsl:call-template name="F008-c28-SOME">
            <xsl:with-param name="char28" select="$char11"/>
        </xsl:call-template>
    </xsl:template>  
    
    <xsl:template name="F006-c12-BK">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c29-BK">
            <xsl:with-param name="char29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-CR">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c29-CR">
            <xsl:with-param name="char29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-MP">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c12-VM">
        <xsl:param name="char12"/>
        <xsl:call-template name="F008-c23_29-abcor-SOME">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
        <xsl:call-template name="F008-c23_29-dqs-SOME-origMan">
            <xsl:with-param name="char23_29" select="$char12"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-BK">
        <xsl:param name="char13"/>
        <xsl:call-template name="F008-c30-BK">
            <xsl:with-param name="char30" select="$char13"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-14-MU">
        <xsl:param name="char13-14"/>
        <xsl:call-template name="F008-c30-31-MU">
            <xsl:with-param name="char30-31" select="$char13-14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c13-14-__-MU">
        <xsl:param name="char13-14"/>
        <xsl:call-template name="F008-c30-31-__-MU">
            <xsl:with-param name="char30-31" select="$char13-14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c14-BK">
        <xsl:param name="char14"/>
        <xsl:call-template name="F008-c31-BK">
            <xsl:with-param name="char31" select="$char14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c14-MP">
        <xsl:param name="char14"/>
        <xsl:call-template name="F008-c31-MP">
            <xsl:with-param name="char31" select="$char14"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-BK">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-BK">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-MP-origMan">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-gk-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-gk-MP">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-17-jm-MP">
        <xsl:param name="char16-17"/>
        <xsl:call-template name="F008-c33-34-jm-MP">
            <xsl:with-param name="char33-34" select="$char16-17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-MU">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-MU">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-dgiklmno-VM">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-VM">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c16-abcdfmnoprstvw-VM">
        <xsl:param name="char16"/>
        <xsl:call-template name="F008-c33-VM-origMan">
            <xsl:with-param name="char33" select="$char16"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-abc-BK">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-abc-BK">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-d-BK">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-d-BK">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="F006-c17-VM">
        <xsl:param name="char17"/>
        <xsl:call-template name="F008-c34-VM">
            <xsl:with-param name="char34" select="$char17"/>
        </xsl:call-template>
    </xsl:template>

    <!--007-->
    <!--char00-->
    <xsl:template name="F007-c00">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="Test337" select="boolean(ancestor::marc:record/marc:datafield[@tag='337'])"/>
        <xsl:variable name="F337" select="ancestor::marc:record/marc:datafield[@tag='337']/marc:subfield[@code='b']"/>
        <xsl:choose>
            <xsl:when test="$char00 = 'o' or $char00 = 'a' or $char00 = 'm' or $char00 = 'k' or $char00 = 'q' or $char00 = 'g' or $char00 = 'r' or $char00 = 'f' or $char00 = 't'">
                <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.h5tb-zk94#', $char00)}"/>
            </xsl:when>
            <xsl:when test="$char00 = 'c'">
                <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#c'}"/>
                <xsl:if test="$F337 = 'c'">
                    <rdamo:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1003'}"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char00 = 'd'">
                <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#d'}"/>
                <xsl:if test="not($Test337)">
                    <rdamo:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1007'}"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char00 = 'h'">
                <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#h'}"/>
                <rdamo:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1002'}"/>
            </xsl:when>
            <xsl:when test="$char00 = 's'">
                <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#s'}"/>
                <rdamo:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1001'}"/>
            </xsl:when>
            <xsl:when test="$char00 = 'v'">
                <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#v'}"/>
                <rdamo:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1008'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!--position 01-->
    <xsl:template name="F007-c01">
        <xsl:param name="agg"/>
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char01" select="substring(., 2, 1)"/>
        <xsl:variable name="Test338" select="boolean(ancestor::marc:record/marc:datafield[@tag='338'])"/>
        <xsl:if test=" $char00 = 'c' and ($char01 = 'a' or $char01 = 'c' or $char01 = 'e' or $char01 = 'b' or $char01 = 'd' or $char01 = 'f' or $char01 = 'h' or $char01 = 'j' or $char01 = 'k' or $char01 = 'm' or $char01 = 'o' or $char01 = 'r' or $char01 = 's')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.q8qv-nz89#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'd' and ($char01 = 'a' or $char01 = 'b' or $char01 = 'c' or $char01 = 'e')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.xrxa-qa70#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'h' or ($char01 = 'a' or $char01 = 'b' or $char01 = 'c' or $char01 = 'd' or $char01 = 'e' or $char01 = 'f' or $char01 =  'g' or $char01 = 'h' or $char01 = 'j')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.exa1-z360#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'k' or ($char01 = 'a' or $char01 = 'c' or $char01 = 'd' or $char01 = 'e' or $char01 = 'f' or $char01 = 'g' or $char01 = 'h' or $char01 = 'i' or $char01 = 'j' or $char01 = 'k' or $char01 = 'l' or $char01 = 'n' or $char01 = 'o' or $char01 = 'p' or $char01 = 'q' or $char01 = 'r' or $char01 = 's' or $char01 = 'v')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.gs2r-s451#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'f' and ($char01 = 'a' or $char01 = 'b' or $char01 = 'c' or $char01= 'd')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.kb0p-ta35#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char01 = 'b' or $char01 = 'd' or $char01 = 'e' or $char01 = 'g' or $char01 = 'i' or $char01 = 'q' or $char01 = 'r' or $char01 = 's' or $char01 = 't' or $char01 = 'w')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.enb6-8r41#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'a' and ($char01 = 'd' or $char01 = 'g' or $char01 = 'j' or $char01 = 'k' or $char01 = 'q' or $char01 = 'r' or $char01 = 's' or $char01 = 'y')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.096m-0415#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'g' and ($char01 = 'c' or $char01 = 'd' or $char01 = 'f' or $char01 = 'o' or $char01 = 's' or $char01 = 't')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.kdz3-qx35#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'v' and ($char01 = 'c' or $char01 = 'd' or $char01 = 'f' or $char01 = 'r')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.n7sa-ny50#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'm' and ($char01 = 'f' or $char01 = 'o' or $char01 = 'r' or $char01 = 'c')">
            <rdamo:P30335 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.043f-gn39#', $char01)}"/>
        </xsl:if>
        <xsl:if test="$char01 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1032'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1014'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1037'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 't'">
                    <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.eqmf-h666#c'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1051'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1015'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1021'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1045'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 't'">
                    <rdamo:P30199 rdf:resource="{'https://doi.org/10.6069/uwlswd.eqmf-h666#a'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1012'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1024'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1070'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 't'">
                    <rdamo:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'd'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1013'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1026'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType1035'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1004'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 't'">
                    <rdamo:P30137 rdf:resource="{'https://doi.org/10.6069/uwlswd.eqmf-h666#d'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1060'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'e'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1014'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1022'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1003'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'f'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1012'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1023'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1033'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.kdz3-qx35#f'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1052'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'h'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1017'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1027'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'j'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1013'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1056'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'k'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1011'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1013'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'z'">
                    <rdamo:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.h5tb-zk94#z'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'o'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' and not($Test338)">
                    <rdamo:P30001 rdf:resource="{'https://www.rdaregistry.info/termList/RDACarrierType/#1013'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1069'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1036'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'g'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1028'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'r'">
            <xsl:choose>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1034'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1053'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 's'">
            <xsl:choose>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1040'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1007'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 't'">
            <xsl:choose>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1039'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1008'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char01 = 'i' and $char00 = 's'">
            <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1005'}"/>
        </xsl:if>
        <xsl:if test="$char01 = 'q' and $char00 = 's'">
            <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1006'}"/>
        </xsl:if>
        <xsl:if test="$char01 = 'w' and $char00 = 's'">
            <rdamo:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1071'}"/>
        </xsl:if>
    </xsl:template>
    
    <!--char03-->
    <xsl:template name="F007-c03">
        <xsl:param name="agg"/>
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char01" select="substring(., 2, 1)"/>
        <xsl:variable name="char03" select="substring(., 4, 1)"/>
        <xsl:variable name="Test338" select="boolean(ancestor::marc:record/marc:datafield[@tag='338'])"/>
        <xsl:if test="$char00= 's' and ($char03='a' or $char03='b' or $char03='c' or $char03='d' or $char03= 'e' or $char03= 'f' or $char03= 'h' or $char03= 'i' or $char03= 'k' or $char03= 'l' or $char03= 'm' or $char03= 'o' or $char03= 'p' or $char03= 'r')">
            <rdamo:P30201 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.m935-w309#', $char03)}"/>
        </xsl:if> 
        <xsl:if test="$char00 = 'm' and ($char03 = 'h' or $char03= 'm' or $char03='z')">
            <rdamo:P30456 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4s9w-5e47#', $char03)}"/>
        </xsl:if>
        <xsl:if test="not($agg)">
            <xsl:choose>
                <xsl:when test="$char03 = 'a' and ($char00 = 'c' or $char00='d' or $char00='a')">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1002'}"/>
                </xsl:when>
                <xsl:when test="$char03 = 'b' and $char00 = 'c'">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1002'}"/>
                </xsl:when>
                <xsl:when test="$char03 = 'c' and ($char00 = 'c' or $char00='d' or $char00='a')">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1003'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'c' and ($char03 = 'g' or $char03 = 'm')">
                    <rdamo:P30456 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4ee2-4t34#', $char03)}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char03 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1002'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm' or $char00 = 'k' or $char00 = 'g' or $char00 = 'v'">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if> 
        <xsl:if test="$char03 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1003'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.3z3f-7k53#n'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.c9fa-t776#m'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.d1cd-6t83#m'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char03 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1001'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k' or $char00 = 'g' or $char00 = 'v'">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char03 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'm' or $char00 = 'k' or $char00 = 'g' or $char00 = 'v'">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1003'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char03 = 'h'">
            <xsl:choose>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.3z3f-7k53#h'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.c9fa-t776#h'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!--char04-->
    <xsl:template name="F007-c04">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char01" select="substring(., 2, 1)"/>
        <xsl:variable name="char03" select="substring(., 4, 1)"/>
        <xsl:variable name="char04" select="substring(., 5, 1)"/>
        <xsl:if test="$char00 = 'h' and ($char04 = 'a' or $char04 = 'd' or $char04 = 'f' or $char04 = 'g' or $char04 = 'h' or $char04 = 'l' or $char04 = 'm' or $char04 = 'o' or $char04 = 'p')">
            <rdamd:P30169>
                Code value label
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char00 = 'm' and ($char04 = 'a' or $char04 = 'b' or $char04 = 'd' or $char04 = 'e')">
            <rdamo:P30163 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.c9kk-6x09#', $char04)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'v' and ($char04 = 'a' or $char04 = 's' or $char04 = 'v')">
            <rdamo:P30104 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.b441-n943#', $char04)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'g' and ($char04 = 'j' or $char04 = 'k' or $char04 = 'm')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.d6e1-f386#', $char04)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'a' and ($char04 = 'q' or $char04 = 'r' or $char04 = 's' or $char04 = 't' or $char04 = 'y')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4r20-tp49#', $char04)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char04 = 'q' or $char04 = 'm' or $char04 = 's')">
            <rdamo:P30184 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.0av9-3018#', $char04)}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        3 1/2 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'd' or $char00 = 'a'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1025'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1005'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'e'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        12 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'd' or $char00 = 'k' or $char00 = 'a' or $char00 = 'g'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1037'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1013'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'g'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        4 3/4 in. or 12 cm.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'd' or $char00 = 'a' or $char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1039'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1009'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'h'">
            <xsl:choose>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1004'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'i'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        1 1/8 x 2 3/8 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'd' or $char00 = 'a' or $char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1029'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'j'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        3 7/8 x 2 1/2 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1016'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'k' and $char00 = 'v'">
            <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1012'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'm' and $char00 = 'v'">
            <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1010'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'q' and $char00 = 'v'">
            <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1008'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'o'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        5 1/4 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'k' or $char00 = 'g'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1025'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1005'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'v'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30169>
                        8 in.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'd' or $char00 = 'a' or $char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1020'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd' or $char00 = 'a'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1045'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1004'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1015'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd' or $char00 = 'a'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1036'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30163 rdf:resource="{'http://rdaregistry.info/termList/presFormat/1012'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1006'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1014'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'd'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd' or $char00 = 'a'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k' or $char00 = 'g'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1006'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'f'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd' or $char00 = 'a' or $char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1035'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30163 rdf:resource="{'http://rdaregistry.info/termList/presFormat/1008'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1011'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'l' and ($char00 = 'd' or $char00 = 'a' or $char00 = 'k')">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1042 '}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'm' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'https://doi.org/10.6069/uwlswd.84qn-zz83#m'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'n' and ($char00 = 'd' or $char00 = 'a' or $char00 = 'k')">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1041'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'q' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1015'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'p'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd' or $char00 = 'a' or $char00 = 'k'">
                    <rdamo:P30304 rdf:reosurce="{'http://rdaregistry.info/termList/RDAMaterial/1028'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamo:P30104 rdf:resource="{'http://rdaregistry.info/termList/videoFormat/1007'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char04 = 'r' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1031'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 's' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1036'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 't' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1045'}"/>
        </xsl:if>
        <xsl:if test="$char04 = 'w' and ($char00 = 'd' or $char00 = 'a' or $char00 = 'k')">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1026'}"/>
        </xsl:if>
    </xsl:template>
    
    <!--char05-->
    <xsl:template name="F007-c05">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char01" select="substring(., 2, 1)"/>
        <xsl:variable name="char03" select="substring(., 4, 1)"/>
        <xsl:variable name="char04" select="substring(., 5, 1)"/>
        <xsl:variable name="char05" select="substring(., 6, 1)"/>
        <xsl:if test="$char00 = 'm' and ($char05 = 'a' or $char05 = 'b')">
            <rdamo:P30454 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.adnr-df48#', $char05)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'g' and ($char05 = 'a' or $char05 = 'b')">
            <rdamo:P30454 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.7jyk-8w28#', $char05)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'v' and ($char05 = 'a' or $char05 = 'b')">
            <rdamo:P30454 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.vjb7-fc54#', $char05)}"/>
        </xsl:if>
        <xsl:if test="$char05 = ' '">
            <xsl:choose>
                <xsl:when test="$char00 = 'c' or $char00 = 'g' or $char00 = 'v'">
                    <rdamo:P30454 rdf:resource="{'https://www.rdaregistry.info/termList/soundCont/#1002'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30454 rdf:resource="{'https://doi.org/10.6069/uwlswd.adnr-df48#pound'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamo:P30454 rdf:resource="{'https://www.rdaregistry.info/termList/soundCont/#1001'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'http://rdaregistry.info/termList/RDAReductionRatio/1001'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1005'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'f'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd'">
                    <rdamo:P30191 rdf:resource="{'https://doi.org/10.6069/uwlswd.3x83-se08#'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30191 rdf:resource="{'https://doi.org/10.6069/uwlswd.jc99-4089#f'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1035'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'z' and $char00 = 'a'">
            <rdamo:P30191 rdf:resource="{'https://doi.org/10.6069/uwlswd.jc99-4089#z'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'http://rdaregistry.info/termList/RDAReductionRatio/1002'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1004'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'http://rdaregistry.info/termList/RDAReductionRatio/1003'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1006'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'd'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'http://rdaregistry.info/termList/RDAReductionRatio/1004'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'e'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'http://rdaregistry.info/termList/RDAReductionRatio/1005'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1037'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'v'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30263 rdf:resource="{'https://doi.org/10.6069/uwlswd.gk9v-z457#v'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1020'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'g' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1039'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'h' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'i' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1029'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'l' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1042'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'https://doi.org/10.6069/uwlswd.vwq2-t991#m'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <xsl:if test="$char03 = 'i'">
                        <rdamo:P30307 rdf:resource="{'http://rdaregistry.info/termList/groovePitch/1005'}"/>
                    </xsl:if>
                    <xsl:if test="$char03 = 'a' or $char03 = 'b' or $char03 = 'c' or $char03 = 'e'">
                        <rdamo:P30308 rdf:resource="{'http://rdaregistry.info/termList/grooveWidth/1002'}"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 'n' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1041'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'o' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1025'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'p' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1028'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'q' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1015'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'r' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1031'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 's'">
            <xsl:choose>
                <xsl:when test="$char00 = 'k'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1036'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <xsl:if test="$char03 = 'h'">
                        <rdamo:P30307 rdf:resource="{'http://rdaregistry.info/termList/groovePitch/1006'}"/>
                    </xsl:if>
                    <xsl:if test="$char03 = 'd'">
                        <rdamo:P30308 rdf:resource="{'http://rdaregistry.info/termList/grooveWidth/1001'}"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char05 = 't' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1045'}"/>
        </xsl:if>
        <xsl:if test="$char05 = 'w' and $char00 = 'k'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1026'}"/>
        </xsl:if>
    </xsl:template>
    
    <!--char06-->
    <xsl:template name="F007-c06">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char01" select="substring(., 2, 1)"/>
        <xsl:variable name="char03" select="substring(., 4, 1)"/>
        <xsl:variable name="char04" select="substring(., 5, 1)"/>
        <xsl:variable name="char05" select="substring(., 6, 1)"/>
        <xsl:variable name="char06" select="substring(., 7, 1)"/>
        <xsl:if test="$char00 = 'm' and ($char06 = 'a' or $char06 = 'b' or $char06 = 'c' or $char06 = 'd' or $char06 = 'e' or $char06 = 'f' or $char06 = 'g' or $char06 = 'h' or $char06 = 'i')">
            <rdamo:P30206 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.x1zh-4148#', $char06)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'g' and ($char06 = 'a' or $char06 = 'b' or $char06 = 'c' or $char06 = 'd' or $char06 = 'e' or $char06 = 'f' or $char06 = 'g' or $char06 = 'h' or $char06 = 'i')">
            <rdamo:P30206 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.yayd-4y11#', $char06)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'v' and ($char06 = 'a' or $char06 = 'b' or $char06 ='c' or $char06 = 'd' or $char06 = 'e' or $char06 = 'f' or $char06 = 'g' or $char06 = 'h' or $char06 = 'i')">
            <rdamo:P30206 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.9r2z-x073#', $char06)}"/>
        </xsl:if>
        <xsl:if test="$char06 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30187 rdf:resource="{'http://rdaregistry.info/termList/RDAproductionMethod/1001'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        3 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char06 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30187 rdf:resource="{'http://rdaregistry.info.termList/RDAproductionMethod/1008'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        5 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char06 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.d36s-9s16#c'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        7 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char06 = 'd'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.d36s-9s16#d'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        10 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char06 = 'e' and $char00 = 's'">
            <rdamd:P30169>
                12 in.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char06 = 'f' and $char00 = 's'">
            <rdamd:P30169>
                16 in.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char06 = 'g' and $char00 = 's'">
            <rdamd:P30169>
                4 3/4 in. or 12 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char06 = 'j' and $char00 = 's'">
            <rdamd:P30169>
                3 7/8 x 2 1/2 in.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char06 = 'o' and $char00 = 's'">
            <rdamd:P30169>
                5 1/4 x 3 7/8 in.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char06 = 's' and $char00 = 's'">
            <rdamd:P30169>
                2 3/4 x 4 in.
            </rdamd:P30169>
        </xsl:if>
    </xsl:template>
    
    <!--char07-->
    <xsl:template name="F007-c07">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char07" select="substring(., 8, 1)"/>
        <xsl:if test="$char07 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1001'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm' or $char00 = 'g'">
                    <rdamd:P30169>
                        Standard 8 mm.
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamd:P30169>
                        8 mm.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char07 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1002'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm' or $char00 = 'g'">
                    <rdamd:P30169>
                        Super 8 mm./single 8 mm.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char07 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        1/4 in. tape width
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'a'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1003'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamd:P30169>
                        1/4 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char07 = 'c' and ($char00 = 'm' or $char00 = 'g')">
            <rdamd:P30169>
                9.5 mm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'd' and($char00 = 'm' or $char00 = 'g')">
            <rdamd:P30169>
                16 mm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'e' and ($char00 = 'm' or $char00 = 'g')">
            <rdamd:P30169>
                28 mm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'f' and ($char00 = 'm' or $char00 = 'g')">
            <rdamd:P30169>
                35 mm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'g' and ($char00 = 'm' or $char00 = 'g')">
            <rdamd:P30169>
                70 mm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'j' and $char00 = 'g'">
            <rdamd:P30169>
                2x2 in. or 5x5 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'k' and $char00 = 'g'">
            <rdamd:P30169>
                2 1/4 x 2 1/4 in. or 6x6 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 's' and $char00 = 'g'">
            <rdamd:P30169>
                4x5 in. or 10x13 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 't' and $char00 = 'g'">
            <rdamd:P30169>
                5x7 in. or 13x18 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'v' and $char00 = 'g'">
            <rdamd:P30169>
                8x10 in. or 21x26 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'w' and $char00 = 'g'">
            <rdamd:P30169>
                9x9 in. or 23x23 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'x' and $char00 = 'g'">
            <rdamd:P30169>
                10x10 in. or 26x26 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'y' and $char00 = 'g'">
            <rdamd:P30169>
                7x7 in. or 18x18 cm.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'l' and $char00 = 's'">
            <rdamd:P30169>
                1/8 in. tape width
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'o'">
            <xsl:choose>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        1/2 in. tape width
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamd:P30169>
                        1/2 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char07 = 'p'">
            <xsl:choose>
                <xsl:when test="$char00 = 's'">
                    <rdamd:P30169>
                        1 in. tape width
                    </rdamd:P30169>
                </xsl:when>
                <xsl:when test="$char00 = 'v'">
                    <rdamd:P30169>
                        1 in.
                    </rdamd:P30169>
                </xsl:when>
            </xsl:choose>
            </xsl:if>
        <xsl:if test="$char07 = 'q' and $char00 = 'v'">
            <rdamd:P30169>
                2 in.
            </rdamd:P30169>
        </xsl:if>
        <xsl:if test="$char07 = 'r' and $char00 = 'v'">
            <rdamd:P30169>
                3/4 in.
            </rdamd:P30169>
        </xsl:if>
    </xsl:template>

    <!--char08-->
    <xsl:template name="F007-c08">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char08" select="substring(., 9, 1)"/>
        <xsl:if test="$char00 = 'm' and ($char08 = 'k' or $char08 = 'm' or $char08 = 'q')">
            <rdamo:P30184 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.er3s-pg07#', $char08)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'g' and ($char08 = 'j' or $char08 = 'k' or $char08 = 'm')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.n3ew-mc60#', $char08)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'v' and ($char08 = 'k' or $char08 = 'm' or $char08 = 'q')">
            <rdamo:P30184 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.r74w-5w82#', $char08)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char08 = 'a' or $char08 = 'b' or $char08 = 'c' or $char08 = 'd' or $char08 = 'e' or $char08 = 'f')">
            <rdamo:P30185 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.fh0k-hk62#', $char08)}"/>
        </xsl:if>
        <xsl:if test="$char08 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'g'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1006'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char08 = 'd' and $char00 = 'g'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
        </xsl:if>
        <xsl:if test="$char08 = 'e' and $char00 = 'g'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1037'}"/>
        </xsl:if>
        <xsl:if test="$char08 = 'k' and $char00 = 'g'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1037'}"/>
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
        </xsl:if>
        <xsl:if test="$char08 = 'h' and $char00 = 'g'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
        </xsl:if>
        <xsl:if test="$char08 = 'j' and $char00 = 'g'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1012'}"/>
        </xsl:if>
        <xsl:if test="$char08 = 's' and ($char00 = 'm' or $char00 = 'v')">
            <rdamo:P30184 rdf:resource="{'http://rdaregistry.info/termList/configPlayback/1002'}"/>
        </xsl:if> 
    </xsl:template>
    
    <!--char09-->
    <xsl:template name="F007-c09">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char09" select="substring(., 10, 1)"/>
        <xsl:if test="$char00 = 'f' and ($char09 = 'a' or $char09 = 'b')">
            <rdamo:P30199 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.ry8c-5814#', $char09)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char09 = 'i' or $char09 = 'm')">
            <rdamo:P30191 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4sxq-pn90#', $char09)}"/>
        </xsl:if>
        <xsl:if test="$char09 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        One file format
                    </rdamd:P30137>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1006'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char09 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1002'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1016'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char09 = 'c' and $char00 = 'h'">
            <rdamo:P30456 rdf:resource="{'http://rdaregistry.info/termList/RDAColourContent/1003'}"/>
        </xsl:if>
        <xsl:if test="$char09 = 'd' and $char00 = 's'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1002'}"/>
        </xsl:if>
        <xsl:if test="$char09 = 'r' and $char00 = 's'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1008'}"/>
        </xsl:if>
        <xsl:if test="$char09 = 's' and $char00 = 's'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1015'}"/>
        </xsl:if>
        <xsl:if test="$char09 = 't' and $char00 = 's'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1017'}"/>
        </xsl:if>
        <xsl:if test="$char09 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Multiple file formats
                    </rdamd:P30137>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30456 rdf:resource="{'https://doi.org/10.6069/uwlswd.x654-gd54#m'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!--char10-->
    <xsl:template name="F007-c10">
        <xsl:variable name="char10" select="substring(., 11, 1)"/>
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:if test="$char00 = 's' and ($char10 = 'a' or $char10 = 'b' or $char10 = 'c' or $char10 = 'g' or $char10 = 'i' or $char10 = 'm' or $char10 = 'r')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.hteb-5554#', $char10)}"/>
        </xsl:if>
        <xsl:if test="$char10 = 'l' and $char00 = 's'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
        </xsl:if>
        <xsl:if test="$char10 = 's' and $char00 = 's'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1034'}"/>
        </xsl:if>
        <xsl:if test="$char10 = 'w' and $char00 = 's'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1044'}"/>
        </xsl:if>
        <xsl:if test="$char10 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamo:P30137>
                        Quality assurance target(s): Absent.
                    </rdamo:P30137>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1047'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1001'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char10 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1046'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30196 rdf:resource="{'http://rdaregistry.info/termList/RDAPolarity/1002'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char10 = 'c' and $char00 = 'h'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1048'}"/>
        </xsl:if>
        <xsl:if test="$char10 = 'p'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Quality assurance target(s): Present.
                    </rdamd:P30137>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1029'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char10 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30304 rdf:resource="{'https://doi.org/10.6069/uwlswd.m9z2-3g03#m'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1022'}"/>
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1029'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <!--char11-->
    <xsl:template name="F007-c11">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char11" select="substring(., 12, 1)"/>
        <xsl:if test="$char11 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Antecedent/source: File reproduced from original.
                    </rdamd:P30137>
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1005'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char11 = 'b'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Antedecent/source: File reproduced from microform.
                    </rdamd:P30137> 
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1010'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char11 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Antedecent/source: File reproduced from an electronic resource.
                    </rdamd:P30137> 
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1014'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char11 = 'c'">
            <xsl:choose>
                <xsl:when test="$char00 = 'd'">
                    <rdamd:P30137>
                        Antedecent/source: File reproduced from an intermediate (not microform).
                    </rdamd:P30137> 
                </xsl:when>
                <xsl:when test="$char00 = 'm'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1019'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char11 = 'm'">
            <xsl:choose>
                <xsl:when test="$char00 = 'c'">
                    <rdamd:P30137>
                        Antedecent/source: Mixed.
                    </rdamd:P30137> 
                </xsl:when>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1007'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char11 = 'e' and $char00 = 'm'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1005'}"/>
        </xsl:if>
        <xsl:if test="$char11 = 'o' and $char00 = 'm'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1009'}"/>
        </xsl:if>
        <xsl:if test="$char11 = 'r' and $char00 = 'm'">
            <rdamo:P30191 rdf:resource="{'http://rdaregistry.info/termList/RDAGeneration/1011'}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char11 = 'h' or $char11 = 'l')">
            <rdamo:P30164 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.pm5s-5m12#', $char11)}"/>
        </xsl:if>
    </xsl:template>
    
    <!--char12-->
    <xsl:template name="F007-c12">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char12" select="substring(., 13, 1)"/>
        <xsl:if test="$char00 = 'c' and ($char12 = 'a' or $char12 = 'b' or $char12 = 'd' or $char12 = 'm')">
            <rdamo:P30124 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.hwb2-j275#', $char12)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'h' and ($char12 = 'c' or $char12 = 'd' or $char12 = 'm' or $char12 = 'p' or $char12 = 'r' or $char12 = 't')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.404b-ss58#', $char12)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 'm' and ($char12 = 'c' or $char12 = 'd' or $char12 = 'm' or $char12 = 'p' or $char12 = 'r' or $char12 = 't')">
            <rdamo:P30304 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.fqx4-1d72#', $char12)}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'a'">
            <xsl:choose>
                <xsl:when test="$char00 = 'm' or $char00 = 'h'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1033'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1009'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char12 = 'b' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1001'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'c' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1006'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'e' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'https://doi.org/10.6069/uwlswd.a3v4-v844#e'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'f' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1005'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'g' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1007'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'h' and $char00 = 's'">
            <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1002'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'd'">
            <xsl:choose>
                <xsl:when test="$char00 = 'h'">
                    <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1033'}"/>
                </xsl:when>
                <xsl:when test="$char00 = 's'">
                    <rdamo:P30138 rdf:resource="{'http://rdaregistry.info/termList/specPlayback/1003'}"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$char12 = 'i' and ($char00 = 'h' or $char00 = 'm')">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1023'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 'p' and $char00 = 'h'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1030'}"/>
        </xsl:if>
        <xsl:if test="$char12 = 't' and $char00 = 'h'">
            <rdamo:P30304 rdf:resource="{'http://rdaregistry.info/termList/RDAMaterial/1040'}"/>
        </xsl:if>
    </xsl:template>
    
    <!--char13-->
    <xsl:template name="F007-c13">
        <xsl:variable name="char00" select="substring(., 1, 1)"/>
        <xsl:variable name="char13" select="substring(., 14, 1)"/>
        <xsl:if test="$char00 = 'm' and ($char13 = 'a' or $char13 = 'b' or $char13 = 'c' or $char13 = 'd' or $char13 = 'e' or $char13 = 'f' or $char13 = 'g' or $char13 = 'h' or $char13 = 'i' or $char13 = 'j' or $char13 = 'k' or $char13 = 'l' or $char13 = 'm' or $char13 = 'p' or $char13 = 'q' or $char13 = 'r' or $char13 = 's' or $char13 = 't' or $char13 = 'v' or $char13 = 'z')">
            <rdamo:P30456 rdf:reosurce="{concat('https://doi.org/10.6069/uwlswd.gdvf-z086#', $char13)}"/>
        </xsl:if>
        <xsl:if test="$char00 = 's' and ($char13 = 'a' or $char13 = 'b' or $char13 = 'd' or $char13 = 'e')">
            <rdamo:P30125 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.v4qn-rb56#', $char13)}"/>
        </xsl:if>
        <xsl:if test="$char13 = 'a' and $char00 = 'c'">
            <rdamd:P30137>
                Reformatting quality: Access.
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char13 = 'p' and $char00 = 'c'">
            <rdamd:P30137>
                Reformatting quality: Preservation.
            </rdamd:P30137>
        </xsl:if>
        <xsl:if test="$char13 = 'r' and $char00 = 'c'">
            <rdamd:P30137>
                Reformatting quality: Replacement.
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <!-- 008 -->
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
    
    <xsl:template name="F008-c7-14" expand-text="yes">
        <xsl:param name="char6"/>
        <xsl:param name="char7-14"/>
        <xsl:param name="date1" select="translate(substring($char7-14, 1, 4), 'u', 'X')"/>
        <xsl:param name="date2" select="translate(substring($char7-14, 5, 4), 'u', 'X')"/>
        <xsl:choose>
            <xsl:when test="$char6 = 'e'">
                <xsl:if test="matches($date1, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>{$date1}</xsl:text>
                        <xsl:if test="matches(substring($date2, 1, 2), '[\d]+[X]*')">
                            <xsl:text>-{substring($date2, 1, 2)}</xsl:text>
                        </xsl:if>
                        <xsl:if test="matches(substring($date2, 1, 2), '[\d]+[X]*') and matches(substring($date2, 3, 2), '[\d]+[X]*')">
                            <xsl:text>-{substring($date2, 3, 2)}</xsl:text>
                        </xsl:if>
                    </rdamd:P30278>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'm'">
                <xsl:if test="matches($date1, '[\d]+[X]*') and matches($date2, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>{$date1}/{$date2}</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
                <xsl:if test="not(matches($date1, '[\d]+[X]*')) and matches($date2, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>/{$date2}</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
                <xsl:if test="matches($date1, '[\d]+[X]*') and not(matches($date2, '[\d]+[X]*'))">
                    <rdamd:P30278>
                        <xsl:text>{$date1}/</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
                <xsl:if test="not(matches($date1, '[\d]+[X]*')) and not(matches($date2, '[\d]+[X]*'))">
                    <rdamd:P30137>
                        <xsl:text>Dates of publication unknown.</xsl:text>
                    </rdamd:P30137>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'p'">
                <xsl:choose>
                    <xsl:when test="matches($date1, '[\d]+[X]*')">
                        <rdamd:P30278>
                            <xsl:text>{$date1}/..</xsl:text>
                        </rdamd:P30278>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdamd:P30137>
                            <xsl:text>Date of manifestation unknown.</xsl:text>
                        </rdamd:P30137>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$char6 = 'q'">
                <xsl:if test="matches($date1, '[\d]+[X]*') and matches($date2, '[\d]+[X]*')">
                    <rdamd:P30278>
                        <xsl:text>[{$date1}..{$date2}]</xsl:text>
                    </rdamd:P30278>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$char6 = 'r' or $char6 = 's' or $char6 = 't'">
                <xsl:choose>
                    <xsl:when test="matches($date1, '[\d]+[X]*')">
                        <rdamd:P30011>
                            <xsl:text>{$date1}</xsl:text>
                        </rdamd:P30011>
                    </xsl:when>
                    <xsl:otherwise>
                        <rdamd:P30137>
                            <xsl:text>Date of publication unknown.</xsl:text>
                        </rdamd:P30137>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c15-17">
        <xsl:param name="char15-17"/>
        <xsl:if test="$char15-17 != '   ' and $char15-17 != '|||' and not(starts-with($char15-17, ' '))">
            <rdamo:P30279 rdf:resource="{normalize-space(concat('http://id.loc.gov/vocabulary/countries/', $char15-17))}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-21-BK">
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
    
    <xsl:template name="F008-c18-CR">
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
    
    <xsl:template name="F008-c18-21-MP">
        <xsl:param name="char18-21"/>
        <xsl:choose>
            <xsl:when test="$char18-21 = '    '">
                <rdaed:P20071>
                    <xsl:text>No relief shown.</xsl:text>
                </rdaed:P20071>
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="$char18-21" regex=".{{1}}">
                    <xsl:matching-substring>
                        <xsl:if test=". != ' ' and . != '|' and . != 'z'">
                            <xsl:choose>
                                <xsl:when test=". = 'h'">
                                    <rdae:P20318 rdf:resource="{'https://doi.org/10.6069/uwlswd.1c2x-cj09#hx'}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdae:P20318 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.1c2x-cj09#', .)}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c18-21-MP-aggWor" expand-text="yes">
        <xsl:param name="char18-21"/>
        <xsl:choose>
            <xsl:when test="$char18-21 = '    '">
                <rdawd:P10330>
                    <xsl:text>No relief shown.</xsl:text>
                </rdawd:P10330>
            </xsl:when>
            <xsl:otherwise>
                <xsl:analyze-string select="$char18-21" regex=".{{1}}">
                    <xsl:matching-substring>
                        <xsl:if test=". != ' ' and . != '|' and . != 'z'">
                            <xsl:choose>
                                <xsl:when test=". = 'h'">
                                    <rdawd:P10330>
                                        <xsl:text>Relief representation: https://doi.org/10.6069/uwlswd.1c2x-cj09#hx</xsl:text>
                                    </rdawd:P10330>
                                </xsl:when>
                                <xsl:otherwise>
                                    <rdawd:P10330>
                                        <xsl:text>Relief representation: {concat('https://doi.org/10.6069/uwlswd.1c2x-cj09#', .)}</xsl:text>
                                    </rdawd:P10330>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c18-19-MU">
        <xsl:param name="char18-19"/>
        <xsl:if test="not(contains($char18-19, ' ')) and not(contains($char18-19, '|')) 
            and $char18-19 != 'nn' and $char18-19 != 'uu' and $char18-19 != 'zz'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.8rpj-ek77#', $char18-19)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-20-VM" expand-text="yes">
        <xsl:param name="char18-20"/>
        <xsl:if test="matches($char18-20, '\d\d\d') and $char18-20 != '000'">
            <rdaed:P20219>
                <xsl:text>Duration: {$char18-20} minutes.</xsl:text>
            </rdaed:P20219>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-20-VM-aggWor" expand-text="yes">
        <xsl:param name="char18-20"/>
        <xsl:if test="matches($char18-20, '\d\d\d') and $char18-20 != '000'">
            <rdawd:P10351>
                <xsl:text>Duration: {$char18-20} minutes.</xsl:text>
            </rdawd:P10351>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c18-20-VM-origMan" expand-text="yes">
        <xsl:param name="char18-20"/>
        <xsl:if test="$char18-20 = '000'">
            <rdamd:P30137>
                <xsl:text>Duration: exceeds 16 hours, 39 minutes.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c19-CR">
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
    
    <xsl:template name="F008-c20-MU">
        <xsl:param name="char20"/>
        <xsl:if test="$char20 != ' ' and $char20 != '|' and $char20 != 'u' and $char20 != 'z' and $char20 != 'n'">
            <xsl:choose>
                <xsl:when test="$char20 = 'h'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1002'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'i'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1003'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'k'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1011'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'l'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1007'}"/>
                </xsl:when>
                <xsl:when test="$char20 = 'p'">
                    <rdae:P20209 rdf:resource="{'http://rdaregistry.info/termList/formatNoteMus/1006'}"/>
                </xsl:when>
                <xsl:otherwise>
                    <rdae:P20209 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.06xx-6744#', $char20)}"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c20-MU-aggWor" expand-text="yes">
        <xsl:param name="char20"/>
        <xsl:if test="$char20 != ' ' and $char20 != '|' and $char20 != 'u' and $char20 != 'z' and $char20 != 'n'">
            <xsl:choose>
                <xsl:when test="$char20 = 'h'">
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: http://rdaregistry.info/termList/formatNoteMus/1002</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="$char20 = 'i'">
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: http://rdaregistry.info/termList/formatNoteMus/1003</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="$char20 = 'k'">
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: http://rdaregistry.info/termList/formatNoteMus/1011</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="$char20 = 'l'">
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: http://rdaregistry.info/termList/formatNoteMus/1007</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:when test="$char20 = 'p'">
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: http://rdaregistry.info/termList/formatNoteMus/1006</xsl:text>
                    </rdawd:P10330>
                </xsl:when>
                <xsl:otherwise>
                    <rdawd:P10330>
                        <xsl:text>Format of notated music: {concat('https://doi.org/10.6069/uwlswd.06xx-6744#', $char20)}</xsl:text>
                    </rdawd:P10330>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c21-CR">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 != ' ' and $char21 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.62zz-1534#', $char21)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c21-MU">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 = 'd' or $char21 = 'e' or $char21 = 'f'">
            <rdae:P20209 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.ywjs-vr46#', $char21)}"/>
        </xsl:if>    
    </xsl:template>
    
    <xsl:template name="F008-c21-MU-aggWor" expand-text="yes">
        <xsl:param name="char21"/>
        <xsl:if test="$char21 = 'd' or $char21 = 'e' or $char21 = 'f'">
            <rdawd:P10330>
                <xsl:text>Format of notated music: {concat('https://doi.org/10.6069/uwlswd.ywjs-vr46#', $char21)}</xsl:text>
            </rdawd:P10330>
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
    
    <xsl:template name="F008-c22-SOME-aggWor">
        <xsl:param name="char22"/>
        <xsl:choose>
            <xsl:when test="$char22 != ' ' and $char22 != '|'">
                <rdawo:P10217 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.aec4-nv40#', $char22)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c22-CR">
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
    
    <xsl:template name="F008-c22-23-MP">
        <xsl:param name="char22-23"/>
        <xsl:if test="not(contains($char22-23, ' ')) and not(contains($char22-23, '|')) and $char22-23 != 'zz'">
            <rdae:P20216 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4jrs-m847#', $char22-23)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c22-23-MP-aggWor">
        <xsl:param name="char22-23"/>
        <xsl:if test="not(contains($char22-23, ' ')) and not(contains($char22-23, '|')) and $char22-23 != 'zz'">
            <rdawo:P10355 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.4jrs-m847#', $char22-23)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-dqs-SOME-origMan">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'd'">
                <rdam:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'q'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#q'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 's'">
                <rdam:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1003'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-ghi-SOME-origMan">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'g'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#gx'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'h'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#hx'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'i'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#ix'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-abcor-SOME">
        <xsl:param name="char23_29"/>
        <xsl:choose>
            <xsl:when test="$char23_29 = 'a'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#a'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'b'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1022'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'c'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1028'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'o'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1018'}"/>
            </xsl:when>
            <xsl:when test="$char23_29 = 'r'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#r'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-f-SOME">
        <xsl:param name="char23_29"/>
        <xsl:if test="$char23_29 = 'f'">
            <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23_29-f-SOME-aggWor" expand-text="yes">
        <xsl:param name="char23_29"/>
        <xsl:if test="$char23_29 = 'f'">
            <rdawd:P10330>
                <xsl:text>Form of tactile notation: http://rdaregistry.info/termList/TacNotation/1001</xsl:text>
            </rdawd:P10330>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-xz-SOME-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'x' or $char23 = 'z'">
            <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#zx'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-z-BK-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'z'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#zx'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-CF-origMan">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'q'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#q'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-CF">
        <xsl:param name="char23"/>
        <xsl:if test="$char23 = 'o'">
            <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.3d5s-zx23#o'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c23-MX-origMan">
        <xsl:param name="char23"/>
        <xsl:choose>
            <xsl:when test="$char23 = 'j'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#jx'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 'p'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#px'}"/>
            </xsl:when>
            <xsl:when test="$char23 = 't'">
                <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.dh5m-5y16#tx'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c24-27-BK">
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
    
    <xsl:template name="F008-c24-27-2bkq-BK">
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
    
    <xsl:template name="F008-c24-CR">
        <xsl:param name="char24"/>
        <xsl:if test="$char24 != ' ' and $char24 != '|'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.jfr5-z647#', $char24)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c24-MP">
        <xsl:param name="char24"/>
        <xsl:choose>
            <xsl:when test="$char24 = 'e'">
                <rdaed:P20317>
                    <xsl:text>Greenwich</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'f'">
                <rdaed:P20317>
                    <xsl:text>Ferro</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'g'">
                <rdaed:P20317>
                    <xsl:text>Paris</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'p'">
                <rdaed:P20317>
                    <xsl:text>Philadelphia</xsl:text>
                </rdaed:P20317>
            </xsl:when>
            <xsl:when test="$char24 = 'w'">
                <rdaed:P20317>
                    <xsl:text>Washington, D.C.</xsl:text>
                </rdaed:P20317>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c24-MP-aggWor">
        <xsl:param name="char24"/>
        <xsl:choose>
            <xsl:when test="$char24 = 'e'">
                <rdawd:P10330>
                    <xsl:text>Prime meridian: Greenwich</xsl:text>
                </rdawd:P10330>
            </xsl:when>
            <xsl:when test="$char24 = 'f'">
                <rdawd:P10330>
                    <xsl:text>Prime meridian: Ferro</xsl:text>
                </rdawd:P10330>
            </xsl:when>
            <xsl:when test="$char24 = 'g'">
                <rdawd:P10330>
                    <xsl:text>Prime meridian: Paris</xsl:text>
                </rdawd:P10330>
            </xsl:when>
            <xsl:when test="$char24 = 'p'">
                <rdawd:P10330>
                    <xsl:text>Prime meridian: Philadelphia</xsl:text>
                </rdawd:P10330>
            </xsl:when>
            <xsl:when test="$char24 = 'w'">
                <rdawd:P10330>
                    <xsl:text>Prime meridian: Washington, D.C.</xsl:text>
                </rdawd:P10330>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c24-29-MU-origMan">
        <xsl:param name="char24-29"/>
        <xsl:analyze-string select="$char24-29" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". != ' ' and . != '|' and . != 'n' and . != 'z'">
                    <xsl:choose>
                        <xsl:when test=". = 'j'">
                            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.nt0v-d633#jx'}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <rdam:P30455 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.nt0v-d633#', .)}"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c25-27-CR">
        <xsl:param name="char25-27"/>
        <xsl:analyze-string select="$char25-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = ' ' or . = '|' or . = 'b' or . = 'k' or . = 'q'"/>
                    <xsl:otherwise>
                        <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.cr35-yd51#', .)}"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c25-27-bkq-CR">
        <xsl:param name="char25-27"/>
        <xsl:analyze-string select="$char25-27" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
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
    
    <xsl:template name="F008-c25-abdefg-MP">
        <xsl:param name="char25"/>
        <xsl:if test="$char25 = 'a' or $char25 = 'b' or $char25 = 'd'
            or $char25 = 'e' or $char25 = 'f' or $char25 = 'g'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.vw5v-gh79#', $char25)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c25-acd-MP-origMan">
        <xsl:param name="char25"/>
        <xsl:choose>
            <xsl:when test="$char25 = 'a'">
                <rdam:P30003 rdf:resource="{'http://rdaregistry.info/termList/ModeIssue/1001'}"/>
            </xsl:when>
            <xsl:when test="$char25 = 'c'">
                <rdam:P30003 rdf:resource="{'http://rdaregistry.info/termList/ModeIssue/1005'}"/>
            </xsl:when>
            <xsl:when test="$char25 = 'd'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c26-CF">
        <xsl:param name="char26"/>
        <xsl:if test="$char26 != 'u' and $char26 != 'z' and $char26 != ' ' and $char26 != '|'">
            <rdam:P30018 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.mkjn-bp10#', $char26)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c28-SOME">
        <xsl:param name="char28"/>
        <xsl:if test="$char28 != ' ' and $char28 != '|' and $char28 != 'u'">
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
    
    <xsl:template name="F008-c29-BK">
        <xsl:param name="char29"/>
        <xsl:if test="$char29 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.t1gh-8294#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c29-CR">
        <xsl:param name="char29"/>
        <xsl:if test="$char29 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.6mz0-ta86#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-BK">
        <xsl:param name="char30"/>
        <xsl:if test="$char30 = '1'">
            <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.tq9s-1157#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-31-MU">
        <xsl:param name="char30-31"></xsl:param>
        <xsl:analyze-string select="$char30-31" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". != ' ' and . != '|' and . != 'n' and . != 'z'">
                    <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.23tq-5e25#', .)}"/>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c30-31-__-MU">
        <xsl:param name="char30-31"/>
        <xsl:if test="$char30-31 = '  '">
            <rdae:P20331 rdf:resource="{'https://doi.org/10.6069/uwlswd.23tq-5e25#pound'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c30-31-__-MU-aggWor" expand-text="yes">
        <xsl:param name="char30-31"/>
        <xsl:if test="$char30-31 = '  '">
            <rdawd:P10330>
                <xsl:text>Category of expression: https://doi.org/10.6069/uwlswd.23tq-5e25#pound</xsl:text>
            </rdawd:P10330>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c31-BK">
        <xsl:param name="char31"/>
        <xsl:if test="$char31 = '1'">
            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.m0xp-h565#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c31-MP">
        <xsl:param name="char31"/>
        <xsl:if test="$char31 = '1'">
            <rdam:P30455 rdf:resource="{'https://doi.org/10.6069/uwlswd.2h4d-g549#1'}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-BK">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != 'u' and $char33 != '|' and $char33 != ' '">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.f447-ax91#', $char33)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-CR">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'a'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Basic Roman.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'b'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Extended Roman.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'c'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Cyrillic.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'd'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Japanese.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'e'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Chinese.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'f'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Arabic.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'g'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Greek.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'h'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Hebrew.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'i'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Thai.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'j'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Devanagari.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'k'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Korean.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
            <xsl:when test="$char33 = 'l'">
                <rdamd:P30137>
                    <xsl:text>Original alphabet or script of title: Tamil.</xsl:text>
                </rdamd:P30137>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-gk-MP">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'g'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#gx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'k'">
                        <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#k'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-jm-MP">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". = 'm'">
                    <rdae:P20061 rdf:resource="{'http://rdaregistry.info/termList/TacNotation/1001'}"/>
                </xsl:if>
                <xsl:if test=". = 'j'">
                    <rdae:P20001 rdf:resource="{'http://rdaregistry.info/termList/RDAContentType/1002'}"/>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-jm-MP-aggWor" expand-text="yes">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:if test=". = 'm'">
                    <rdawd:P10330>
                        <xsl:text>Form of tactile notation: http://rdaregistry.info/termList/TacNotation/1001</xsl:text>
                    </rdawd:P10330>
                </xsl:if>
                <xsl:if test=". = 'j'">
                    <rdawo:P10349 rdf:resource="{'http://rdaregistry.info/termList/RDAContentType/1002'}"/>
                </xsl:if>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-34-MP-origMan">
        <xsl:param name="char33-34"/>
        <xsl:analyze-string select="$char33-34" regex=".{{1}}">
            <xsl:matching-substring>
                <xsl:choose>
                    <xsl:when test=". = 'a'">
                        <rdam:P30187 rdf:resource="{'http://rdaregistry.info/termList/RDAproductionMethod/1001'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'b'">
                        <rdam:P30187 rdf:resource="{'http://rdaregistry.info/termList/RDAproductionMethod/1008'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'c'">
                        <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#cx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'd'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#dx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'e'">
                        <rdam:P30187 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#e'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'f'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#fx'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'g'">
                        <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'j'">
                        <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1045'}"/>
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#j'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'l'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#l'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'n'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#n'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'o'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#o'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'p'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#p'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'q'">
                        <rdam:P30199 rdf:resource="{'http://rdaregistry.info/termList/fontSize/1002'}"/>
                    </xsl:when>
                    <xsl:when test=". = 'r'">
                        <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.rw25-p125#r'}"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template name="F008-c33-MU">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != ' ' and $char33 != '|' and $char33 != 'n' and $char33 != 'u' and $char33 != 'z'">
            <rdae:P20331 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.axz0-z371#', $char33)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-MU-aggWor" expand-text="yes">
        <xsl:param name="char33"/>
        <xsl:if test="$char33 != ' ' and $char33 != '|' and $char33 != 'n' and $char33 != 'u' and $char33 != 'z'">
            <rdawd:P10330>
                <xsl:text>Category of expression: {concat('https://doi.org/10.6069/uwlswd.axz0-z371#', $char33)}</xsl:text>
            </rdawd:P10330>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c33-VM">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'd'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#d'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'g'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#g'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'i'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#i'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'k'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#k'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'l'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#l'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'm'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#m'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'n'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#n'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'o'">
                <rdaw:P10004 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#o'}"/>
            </xsl:when>        
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c33-VM-origMan">
        <xsl:param name="char33"/>
        <xsl:choose>
            <xsl:when test="$char33 = 'a'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#a'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'b'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#b'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'c'">
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#c'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'd'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'f'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1036'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#f'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'm'">
                <rdam:P30002 rdf:resource="{'http://rdaregistry.info/termList/RDAMediaType/1005'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'n'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1048'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'o'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1045'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'p'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1030'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#p'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'q'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#q'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'r'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#r'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 's'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1040'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#s'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 't'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#t'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'v'">
                <rdam:P30001 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#v'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#v'}"/>
            </xsl:when>
            <xsl:when test="$char33 = 'w'">
                <rdam:P30001 rdf:resource="{'http://rdaregistry.info/termList/RDACarrierType/1059'}"/>
                <rdam:P30335 rdf:resource="{'https://doi.org/10.6069/uwlswd.qgc0-9r48#w'}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="F008-c34-abc-BK">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'a' or $char34 = 'b' or $char34 = 'c'">
            <rdaw:P10004 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.x4ce-sd21#', $char34)}"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-d-BK">
        <xsl:param name="char34"/>
        <xsl:if test="$char34 = 'd'">
            <rdamd:P30137>
                <xsl:text>Contains biographical information.</xsl:text>
            </rdamd:P30137>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="F008-c34-VM">
        <xsl:param name="char34"/>
        <xsl:choose>
            <xsl:when test="$char34 = 'a' or $char34 = 'c' or $char34 = 'l'">
                <rdaw:P10222 rdf:resource="{concat('https://doi.org/10.6069/uwlswd.eje7-jq11#', $char34)}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
