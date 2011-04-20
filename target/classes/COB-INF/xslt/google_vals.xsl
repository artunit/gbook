<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:seth="http://seth.sourceforge.net">

<!-- token.xsl: 	
	set up HTTP interaction with evergreen
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->

<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/retrieval-results">
    <xsl:variable name="body">
    <xsl:value-of select="contents/html/body"/>
    </xsl:variable>
    <xsl:text>{"Auth":"</xsl:text>
<!--
    <xsl:value-of select="count(contents)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="count(contents/html)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="count(contents/html/body)"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="contents/html/body"/>
    <xsl:text>-</xsl:text>
-->
    <xsl:value-of select="substring-after($body,'Auth=')"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
