<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- result2html.xsl: 	
        put result into json syntax
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->
<xsl:output method="html"/>

<xsl:template match="text()"/>

<xsl:template match="/">
    <html>
      <head>
        <title>jamun - shelf status</title>
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
                jamun - shelf title check
        </div>
        <div class="clear"/>
        <xsl:choose>
            <xsl:when test="count(//code) &gt; 0">
                <xsl:variable name="responseCode">
                    <xsl:value-of select="number(//code)"/>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$responseCode = 200">
                        <h1>Perfect! The shelf is accessible.</h1>
                    </xsl:when>
                    <xsl:otherwise>
                        <h1>oh-oh, expecting a response code of <strong>200</strong>
                        not <xsl:value-of select="$responseCode"/></h1>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <h1>No response detected!</h1>
            </xsl:otherwise>
        </xsl:choose>
        </div>
        </div>
    </body>
    </html>
</xsl:template>

<xsl:template match="code">
        <h1><xsl:value-of select="."/></h1>
</xsl:template>

</xsl:stylesheet>
