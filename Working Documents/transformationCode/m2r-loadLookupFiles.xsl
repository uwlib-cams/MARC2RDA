<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output name="xml" method="xml" indent="yes"/>
    <xsl:param name="lc_files" select="'subjectSchemes;genreFormSchemes;fingerprintschemes;identifiers;accessrestrictionterm;classSchemes;carriers;contentTypes;mediaTypes;mplayspeed;mtapeconfig;mencformat;nameTitleSchemes;languages'"/>
    <xsl:param name="rda_files" select="'AspectRatio;bookFormat;broadcastStand;RDAColourContent;RDAContentType;configPlayback;RDACarrierType;RDAExtensionPlan;MusNotation;noteMove;frequency;fontSize;fileType;RDAGeneration;groovePitch;grooveWidth;IllusContent;layout;RDAMaterial;ModeIssue;RDAMediaType;presFormat;RDAproductionMethod;RDAPolarity;RDARegionalEncoding;recMedium;RDAReductionRatio;soundCont;specPlayback;RDATypeOfBinding;trackConfig;typeRec;videoFormat'"/>
    <xsl:template match="/">
        <xsl:for-each select="tokenize($lc_files, ';')">
            <xsl:result-document format="xml" href="lookup/lc/{.||'.rdf'}">
                <xsl:copy-of select="document(concat('https://id.loc.gov/vocabulary/', ., '.rdf'))"/>
            </xsl:result-document>
        </xsl:for-each>
        <xsl:for-each select="tokenize($rda_files, ';')">
            <xsl:result-document format="xml" href="lookup/rda/{.||'.xml'}">
                <xsl:copy-of select="document(concat('http://www.rdaregistry.info/xml/termList/', ., '.xml'))"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>