<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- idents2json.xsl: 	
        put idents into json syntax
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->
<xsl:output method="json"/>

<xsl:param name="start"/>
<xsl:param name="stop"/>

<xsl:template match="text()"/>

<xsl:template match="/idents">
  <xsl:text>{"idents":[</xsl:text>
    <xsl:for-each select="ident[position() &gt; number($start) and
                position() &lt;= number($stop)]">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="position() &lt; last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
    </xsl:for-each>
  <xsl:text>]}</xsl:text>
</xsl:template>

</xsl:stylesheet>
