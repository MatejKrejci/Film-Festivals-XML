<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xpath-default-namespace="http://matej-krejci.cz/xml/filmFestivals">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Hlavní šablona -->
    <xsl:template match="/">
        <fo:root>
            <!-- Nastavení rozložení stránky  9velikost papíru a okraje) -->
            <fo:layout-master-set>
                <!-- Nastavení vzhledu stránky u které to nebudeš měnit (velikost A4, okraje) -->
                <fo:simple-page-master master-name="content"
                    page-width="210mm" page-height="297mm"
                    margin-top="20mm" margin-bottom="20mm"
                    margin-left="25mm" margin-right="25mm">
                    
                    <!-- Definice regionů stránky -->
                    <fo:region-body margin-top="25mm" margin-bottom="25mm"/>
                    <fo:region-before extent="20mm"/>
                    <fo:region-after extent="20mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            
            <!-- Obsah dokumentu -->
            <fo:page-sequence master-reference="content">
                <!-- Záhlaví -->
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center" font-size="10pt" border-bottom="1pt solid black">
                        Film Festivals - Overview
                    </fo:block>
                </fo:static-content>
                
                <!-- Zápatí -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block text-align="center" font-size="10pt">
                        Page <fo:page-number/> of <fo:page-number-citation ref-id="last-page"/>
                    </fo:block>
                </fo:static-content>
                
                <!-- Hlavní obsah -->
                <fo:flow flow-name="xsl-region-body">
                    <!-- Titulní strana -->
                    <fo:block font-size="24pt" font-weight="bold" text-align="center" space-after="2cm">
                        Film Festivals
                    </fo:block>
                    
                    <!-- Tabulka obsahu -->
                    <fo:block font-size="16pt" font-weight="bold" space-after="5mm">Contents</fo:block>
                    <fo:block space-after="1cm">
                        <!-- Seřazení festivalů podle data -->
                        <xsl:for-each select="//festival">
                            <xsl:sort select="dates/start" order="descending"/>
                            <fo:block space-after="3mm">
                                <!-- Přidáme pozici v seznamu -->
                                <xsl:value-of select="position()"/>
                                <fo:inline>. </fo:inline>
                                <!-- Název festivalu -->
                                <fo:basic-link internal-destination="festival_{generate-id()}" font-size="14pt">
                                    <xsl:value-of select="@name"/>
                                </fo:basic-link>
                                <!-- Status festivalu -->
                                <fo:inline> - <xsl:value-of select="@status"/></fo:inline>
                            </fo:block>
                        </xsl:for-each>
                    </fo:block>
                    
                    <!-- Festivaly -->
                    <xsl:apply-templates select="//festival">
                        <xsl:sort select="dates/start" order="descending"/>
                    </xsl:apply-templates>
                    
                    <!-- Značka poslední strany pro číslování -->
                    <fo:block id="last-page"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
    
    <!-- Šablona pro festival -->
    <xsl:template match="festival">
        <!-- Nová stránka pro každý festival -->
        <fo:block id="festival_{generate-id()}" break-before="page" space-after="1cm">
            <!-- Název festivalu -->
            <fo:block font-size="14pt" font-weight="bold" space-after="3mm">
                <xsl:value-of select="@name"/>
            </fo:block>
            
            <!-- Logo festivalu -->
            <fo:block text-align="center" space-after="5mm">
                <fo:external-graphic src="{image[@type='logo']/@url}"
                    content-height="scale-to-fit"
                    height="3cm"
                    content-width="scale-to-fit"
                    width="8cm"/>
            </fo:block>
            
            <!-- Základní informace -->
            <fo:table space-after="5mm" width="100%">
                <fo:table-column column-width="30%"/>
                <fo:table-column column-width="70%"/>
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold">Venue:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="location/venue"/>,
                                <xsl:value-of select="location/city"/>,
                                <xsl:value-of select="location/country"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold">Date:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block>
                                <xsl:value-of select="format-date(dates/start, '[D]. [M]. [Y]')"/> - 
                                <xsl:value-of select="format-date(dates/end, '[D]. [M]. [Y]')"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block font-weight="bold">Capacity:</fo:block>
                        </fo:table-cell>
                        <fo:table-cell>
                            <fo:block><xsl:value-of select="location/capacity"/> seats</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            
            <!-- Ocenění -->
            <xsl:if test="awards">
                <fo:block font-weight="bold" space-before="3mm">Awards:</fo:block>
                <fo:list-block space-before="2mm">
                    <xsl:for-each select="awards/award">
                        <fo:list-item>
                            <fo:list-item-label>
                                <fo:block>•</fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="5mm">
                                <fo:block>
                                    <xsl:value-of select="@category"/>: 
                                    <xsl:value-of select="."/>
                                    <xsl:if test="@winner"> - <xsl:value-of select="@winner"/></xsl:if>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </xsl:for-each>
                </fo:list-block>
            </xsl:if>
            
            <!-- Vstupenky -->
            <fo:block font-weight="bold" space-before="3mm">Tickets:</fo:block>
            <fo:table space-before="2mm" width="100%">
                <fo:table-column column-width="33%"/>
                <fo:table-column column-width="33%"/>
                <fo:table-column column-width="34%"/>
                <fo:table-header>
                    <fo:table-row background-color="#f0f0f0">
                        <fo:table-cell border="1pt solid black" padding="2mm">
                            <fo:block font-weight="bold">Type</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="1pt solid black" padding="2mm">
                            <fo:block font-weight="bold">Price (<xsl:value-of select="tickets/@currency"/>)</fo:block>
                        </fo:table-cell>
                        <fo:table-cell border="1pt solid black" padding="2mm">
                            <fo:block font-weight="bold">Availability</fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <xsl:for-each select="tickets/ticket">
                        <fo:table-row>
                            <fo:table-cell border="1pt solid black" padding="2mm">
                                <fo:block><xsl:value-of select="."/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="1pt solid black" padding="2mm">
                                <fo:block><xsl:value-of select="@price"/></fo:block>
                            </fo:table-cell>
                            <fo:table-cell border="1pt solid black" padding="2mm">
                                <fo:block><xsl:value-of select="@availability"/></fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </xsl:for-each>
                </fo:table-body>
            </fo:table>
            
            <!-- Odkaz na web -->
            <fo:block space-before="3mm">
                Website: <fo:basic-link external-destination="{website}" color="blue">
                    <xsl:value-of select="website"/>
                </fo:basic-link>
            </fo:block>
        </fo:block>
    </xsl:template>
    
</xsl:stylesheet>
