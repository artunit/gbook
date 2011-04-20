<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook_check.xsl: 	
        push out total results
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->
<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/">
    <xsl:variable name="totResults">
    <xsl:choose>
        <xsl:when test="count(//openSearch:totalResults) &gt; 0">
            <xsl:value-of select="//openSearch:totalResults"/>
        </xsl:when>
        <xsl:otherwise> 
            <xsl:text></xsl:text>
        </xsl:otherwise> 
    </xsl:choose>
    </xsl:variable> 

    <xsl:text>{"totResults":"</xsl:text>
        <xsl:value-of select="$totResults"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
