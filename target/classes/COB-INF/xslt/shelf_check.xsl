<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- shelf_check.xsl: 	
	see if there is a problem by checking a value against shelf
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:param name="userid"/>
<xsl:param name="shelf"/>
<xsl:param name="isbn"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<seth:execute-retrieval>

	<!-- use specific User Agent -->
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

	<seth:url>
	<xsl:text>http://books.google.com/books/feeds/users/</xsl:text>
	<xsl:value-of select="$userid"/>
	<xsl:text>/collections/</xsl:text>
	<xsl:value-of select="$shelf"/>/volumes</seth:url>
	<seth:nvp name="q"><xsl:value-of select="$isbn"/></seth:nvp>
	<seth:method>GET</seth:method>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
