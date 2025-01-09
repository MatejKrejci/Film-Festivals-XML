<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xpath-default-namespace="http://matej-krejci.cz/xml/filmFestivals">
    
    <!-- formát html soubor -->
    <xsl:output method="html" version="5.0" encoding="UTF-8" indent="yes" doctype-system="about:legacy-compat"/>
    
    <!-- Parametry -->
    <xsl:param name="title" select="'Filmové Festivaly'"/>
    
    <!-- Variables -->
    <xsl:variable name="upcoming-festivals" select="/filmFestivals/festival[@status='upcoming']"/>
    <xsl:variable name="past-festivals" select="/filmFestivals/festival[@status='past']"/>
    
    <!-- Hlavní šablona, generuje index.html -->
    <xsl:template match="/">
        <!-- generevání hlavní stránky -->
        <xsl:result-document href="index.html" method="html">
            <xsl:call-template name="html-page">
                <xsl:with-param name="page-title" select="$title"/>
                <xsl:with-param name="content">
                    <section class="upcoming">
                        <h2>Nadcházející festivaly</h2>
                        <xsl:apply-templates select="$upcoming-festivals" mode="summary"/>
                    </section>
                    
                    <section class="past">
                        <h2>Proběhlé festivaly</h2>
                        <xsl:apply-templates select="$past-festivals" mode="summary">
                            <xsl:sort select="dates/start" order="descending"/>
                        </xsl:apply-templates>
                    </section>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:result-document>
        
        <!-- Generování stránek pro jednotlivé festivaly -->
        <xsl:for-each select="/filmFestivals/festival">
            <xsl:result-document href="festival_{translate(@name, ' ', '_')}.html" method="html">
                <xsl:call-template name="html-page">
                    <xsl:with-param name="page-title" select="@name"/>
                    <xsl:with-param name="content">
                        <xsl:apply-templates select="."/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
    <!-- Šablona pro HTML strukturu -->
    <xsl:template name="html-page">
        <xsl:param name="page-title"/>
        <xsl:param name="content"/>
        <html lang="cs">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title><xsl:value-of select="$page-title"/></title>
                <link rel="stylesheet" href="style.css"/>
            </head>
            <body>
                <nav>
                    <ul>
                        <li><a href="index.html">Filmové Festivaly Seznam</a></li>
                    </ul>
                </nav>
                <main>
                    <xsl:copy-of select="$content"/>
                </main>
                <footer>
                    <p>© Databáze Filmových Festivalů</p>
                </footer>
            </body>
        </html>
    </xsl:template>
    
    <!-- Šablona pro souhrn festivalu -->
    <xsl:template match="festival" mode="summary">
        <article class="festival-summary">
            <h3>
                <a href="festival_{translate(@name, ' ', '_')}.html">
                    <xsl:value-of select="@name"/>
                </a>
            </h3>
            <div class="logo-container">
                <img src="{image[@type='logo']/@url}" 
                     alt="{image[@type='logo']/@alt}" 
                     class="festival-logo"/>
            </div>
            <p class="location">
                <xsl:value-of select="location/city"/>, 
                <xsl:value-of select="location/country"/>
            </p>
            <p class="dates">
                <xsl:value-of select="format-date(dates/start, '[D]. [M]. [Y]')"/> - 
                <xsl:value-of select="format-date(dates/end, '[D]. [M]. [Y]')"/>
            </p>
        </article>
    </xsl:template>
        
    <!-- Šablona pro detail festivalu -->
    <xsl:template match="festival">
        <article class="festival-detail">
            <h1><xsl:value-of select="@name"/></h1>
            
            <section class="festival-images">
                <xsl:apply-templates select="image"/>
            </section>
            
            <section class="festival-info">
                <h2>Základní informace</h2>
                <p class="location">
                    <strong>Místo konání:</strong>
                    <xsl:value-of select="location/venue"/>,
                    <xsl:value-of select="location/city"/>,
                    <xsl:value-of select="location/country"/>
                </p>
                <p class="dates">
                    <strong>Termín:</strong>
                    <xsl:value-of select="format-date(dates/start, '[D]. [M]. [Y]')"/> - 
                    <xsl:value-of select="format-date(dates/end, '[D]. [M]. [Y]')"/>
                </p>
                <p class="capacity">
                    <strong>Kapacita:</strong>
                    <xsl:value-of select="location/capacity"/> míst
                </p>
            </section>
            
            <xsl:if test="awards">
                <section class="festival-awards">
                    <h2>Ocenění</h2>
                    <ul>
                        <xsl:apply-templates select="awards/award"/>
                    </ul>
                </section>
            </xsl:if>
            
            <section class="festival-guests">
                <h2>Speciální hosté</h2>
                <ul>
                    <xsl:apply-templates select="specialGuests/guest"/>
                </ul>
            </section>
            
            <section class="festival-tickets">
                <h2>Vstupenky</h2>
                <p>Měna: <xsl:value-of select="tickets/@currency"/></p>
                <ul>
                    <xsl:apply-templates select="tickets/ticket"/>
                </ul>
            </section>
            
            <p class="website">
                <a href="{website}">Oficiální web festivalu</a>
            </p>
        </article>
    </xsl:template>
    
    <!-- dodatečný šablony -->
    <xsl:template match="image">
        <figure class="festival-image {@type}">
            <img src="{@url}" 
                 alt="{@alt}"
                 class="festival-image-png"
                 loading="lazy"/>
            <figcaption><xsl:value-of select="@alt"/></figcaption>
        </figure>
    </xsl:template>
    
    <xsl:template match="award">
        <li class="award">
            <strong><xsl:value-of select="@category"/>: </strong>
            <xsl:value-of select="."/>
            <xsl:if test="@winner"> - <xsl:value-of select="@winner"/></xsl:if>
        </li>
    </xsl:template>
    
    <xsl:template match="guest">
        <li class="guest">
            <xsl:value-of select="."/>
            (<xsl:value-of select="@role"/>, <xsl:value-of select="@nationality"/>)
        </li>
    </xsl:template>
    
    <xsl:template match="ticket">
        <li class="ticket {.}">
            <span class="ticket-type"><xsl:value-of select="."/></span>
            <span class="ticket-price"><xsl:value-of select="@price"/></span>
            <span class="ticket-availability"><xsl:value-of select="@availability"/></span>
        </li>
    </xsl:template>
    
</xsl:stylesheet> 