<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:seth="http://seth.sourceforge.net">

<!-- token.xsl: 	
	set up HTTP interaction with evergreen
 
	(c) Copyright GNU General Public License (GPL)
	@author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->

<xsl:param name="googleHost"/>

<xsl:template match="text()"/>

<xsl:template match="/google">
	<seth:execute-retrieval>

	<!-- use specific User Agent -->
	<seth:useragent>Mozilla/4.5</seth:useragent>

	<!-- timeout (in seconds) -->
	<seth:timeout>60</seth:timeout>

	<!-- where to go -->
	<!--
	<seth:url>https://windsor.concat.ca/osrf-gateway-v1</seth:url>
	-->
	<seth:url><xsl:value-of select="$googleHost"/></seth:url>

	<seth:nvp name="accountType"><xsl:value-of select="accountType"/></seth:nvp>
	<seth:nvp name="Email"><xsl:value-of select="Email"/></seth:nvp>
	<seth:nvp name="Passwd"><xsl:value-of select="Passwd"/></seth:nvp>
	<seth:nvp name="service"><xsl:value-of select="service"/></seth:nvp>
	<seth:nvp name="source"><xsl:value-of select="source"/></seth:nvp>
<!--
	<xsl:for-each select="parms/parm">
		<seth:nvp name="param" jsspace="true"><xsl:value-of select="."/></seth:nvp>
	</xsl:for-each>
-->
	<seth:method>POST</seth:method>

	</seth:execute-retrieval>
</xsl:template>

</xsl:stylesheet>
