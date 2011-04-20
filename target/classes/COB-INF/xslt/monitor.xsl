<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>jamun - status</title>
        <link rel="stylesheet" href="reset.css"/>
        <link rel="stylesheet" href="text.css"/>
        <link rel="stylesheet" href="960.css"/>
        <link rel="stylesheet" href="greensky.css"/>
        <link rel="stylesheet" href="jamun.css"/>
        <xsl:apply-templates select="document/header/style"/>
        <xsl:apply-templates select="document/header/script"/>
      </head>
      <body>
    <div class="container_16">
    <div class="grid_16">
        <div id="custom_header">
                <a href="./">
                <img src="jamun.jpg" class="logo" align="left"/>
                </a>
                jamun - pipeline central
        </div>
    <div class="clear"/>

        <xsl:apply-templates select="document/body/*"/>

    </div>
    </div><!-- end .container_16 -->
      </body>
    </html>
  </xsl:template>

  <xsl:template match="row">
    <div class="grid_15">
      <xsl:apply-templates select="column"/>
    </div>
    <div class="clear"/>
  </xsl:template>
 
  <xsl:template match="column">
    <span>
      <h4><xsl:value-of select="@title"/></h4>
       <div class="clear"/>
      <xsl:apply-templates/>
    </span> 
  </xsl:template>

  <xsl:template match="section">
    <xsl:choose> 
      <xsl:when test="../../../section">
        <h5><xsl:value-of select="title"/></h5>
      </xsl:when>
      <xsl:when test="../../section">
        <h4><xsl:value-of select="title"/></h4>
      </xsl:when>
      <xsl:when test="../section">
        <h4><xsl:value-of select="title"/></h4>
      </xsl:when>
    </xsl:choose>
    <p>
      <xsl:apply-templates select="*[name()!='title']"/>
    </p>
  </xsl:template>

<!--
  <xsl:template match="source">
    <div class="grid_14 column-shading-left column-shading-right logfile">
        <xsl:value-of select="."/>
    </div>
  </xsl:template>
-->
 
  <xsl:template match="link">
    <a href="{@href}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="strong">
    <b>
      <xsl:apply-templates/>
    </b>
  </xsl:template>
 
  <xsl:template match="anchor">
    <a name="{@name}">
      <xsl:apply-templates/>
    </a>
  </xsl:template>
 
  <xsl:template match="para">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="@*|node()" priority="-1">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
