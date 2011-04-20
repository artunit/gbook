<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:email="http://apache.org/cocoon/transformation/sendmail">

<!-- result2json.xsl:   
        put result into json syntax
 
    (c) Copyright GNU General Public License (GPL)
    @author <a href="http://librarycog.uwindsor.ca">art rhyno</a>
-->
<xsl:output method="json"/>

<xsl:template match="text()"/>

<xsl:template match="/">
    <xsl:text>{"result":"</xsl:text>
    <xsl:value-of select="//email:success"/>
    <xsl:text>"}</xsl:text>
</xsl:template>

</xsl:stylesheet>
