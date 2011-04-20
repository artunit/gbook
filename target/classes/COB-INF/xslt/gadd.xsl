<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gadd.xsl: 	
	set up HTTP interaction with evergreen
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->

<xsl:template match="text()"/>

<xsl:template match="/google">
	<seth:execute-retrieval>

	<!-- use specific User Agent -->
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

        <seth:authsub><xsl:value-of select="normalize-space(authsub)"/></seth:authsub>
        <seth:volume><xsl:value-of select="normalize-space(volid)"/></seth:volume>

	<seth:url>http://books.google.com/books/feeds/users/<xsl:value-of select="normalize-space(userid)"/>/collections/<xsl:value-of select="normalize-space(shelfid)"/>/volumes</seth:url>
	<seth:method>POST</seth:method>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
