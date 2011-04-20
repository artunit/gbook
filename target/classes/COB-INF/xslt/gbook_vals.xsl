<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook_vals.xsl: 	
        pull out needed google value for volume
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->
<xsl:output method="json"/>


<xsl:template match="text()"/>

<xsl:template match="/">
    <xsl:variable name="volid">
    <xsl:choose>
        <xsl:when test="count(//a[contains(@href,'books?id=')]) &gt; 0">
            <xsl:variable name="urlraw">
                <xsl:value-of select="//a[contains(@href,'books?id=')]/@href"/>
            </xsl:variable>
            <xsl:variable name="urlmod">
                <xsl:value-of select="substring-after($urlraw,'books?id=')"/>
            </xsl:variable>
            <xsl:if test="string-length($urlmod) &gt; 0">
                <xsl:value-of select="substring-before($urlmod,'&amp;')"/>
            </xsl:if>
        </xsl:when>
        <xsl:otherwise> 
            <xsl:text></xsl:text>
        </xsl:otherwise> 
    </xsl:choose>
    </xsl:variable> 

    <xsl:text>{"volid":"</xsl:text>
        <xsl:value-of select="$volid"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
