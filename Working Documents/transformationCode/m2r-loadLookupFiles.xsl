<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- run to load and save local files from LC and RDA vocabularies -->
    <!-- to add new vocabularies, add the name of the vocabulary as seen in the URL provided by the source to the semi-colon separated list -->
    <!-- for lc, add to the lc_files param. For example, to add LC's Name and Title Authority Source Codes from https://id.loc.gov/vocabulary/nameTitleSchemes.html, you would add nameTitleSchemes to the list -->
    <!-- for rda, add to the rda_files param. For example, to add RDA's Video Format vocabulary from https://www.rdaregistry.info/termList/videoFormat/, you would add videoFormat to the list -->
    <!-- then re-run this XSLT transformation. Set this file as both XML URL and XSL URL. Do not set an output file for the transformation, xsl:result-document is in use -->
    
    <xsl:output name="xml" method="xml" indent="yes"/>
    <xsl:param name="lc_files" select="'subjectSchemes;genreFormSchemes;fingerprintschemes;identifiers;accessrestrictionterm;classSchemes;carriers;contentTypes;mediaTypes;mplayspeed;mtapeconfig;mencformat;nameTitleSchemes;languages;musiccodeschemes;nationalbibschemes;languageschemes'"/>
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