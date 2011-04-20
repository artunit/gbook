<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
version="1.0">

<!-- mailme.xsl: send a message when things go astray
 
    (c) Copyright GNU General Public License (GPL)
    @author <a href="http://www.uwindsor.ca/library">art rhyno</a>
-->

<xsl:output method="xml"/>

<xsl:param name="smtp-host"/>
<xsl:param name="smtp-port"/>
<xsl:param name="smtp-from"/>
<xsl:param name="smtp-to"/>
<xsl:param name="user-id"/>

<xsl:template match="/">
<document xmlns:email="http://apache.org/cocoon/transformation/sendmail">
    <email:sendmail>
        <email:smtphost><xsl:value-of select="$smtp-host"/></email:smtphost>
        <email:smtpport><xsl:value-of select="$smtp-port"/></email:smtpport>
        <email:from><xsl:value-of select="$smtp-from"/></email:from>
        <email:to><xsl:value-of select="$smtp-to"/></email:to>
        <email:subject>gdata notification</email:subject>
        <email:body>
        Please check your bookshelf 
        <xsl:text> - </xsl:text>
        <a href="http://books.google.ca/books?uid={$user-id}&amp;source=gbs_lp_bookshelf_list">
        <xsl:text>http://books.google.ca/books?uid=</xsl:text>
        <xsl:value-of select="$user-id"/>
        <xsl:text>&amp;source=gbs_lp_bookshelf_list</xsl:text>
        </a>
      </email:body>
    </email:sendmail>
</document>
</xsl:template>
</xsl:stylesheet>
