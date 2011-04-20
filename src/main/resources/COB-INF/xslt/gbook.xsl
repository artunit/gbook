<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- gbook.xsl: 	
	set up HTTP interaction with google book search
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://projectconifer.ca">art rhyno</a>
-->

<xsl:param name="identtype"/>
<xsl:param name="ident"/>
<xsl:param name="identlength"/>

<xsl:template match="text()"/>

<xsl:template match="/">
	<seth:execute-retrieval>

	<!-- use specific User Agent -->
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

        <!-- where to go -->
        <seth:url>http://www.google.com/search</seth:url>
        <seth:nvp name="tbo">p</seth:nvp>
        <seth:nvp name="tbm">bks</seth:nvp>
        <seth:nvp name="q"><xsl:value-of select="identtype"/>:<xsl:value-of select="$ident"/></seth:nvp>
        <seth:nvp name="num"><xsl:value-of select="$identlength"/></seth:nvp>

        <!-- GET or POST -->
        <seth:method>GET</seth:method>

        <!-- limit to certain tags -->
        <seth:limit>a</seth:limit>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
