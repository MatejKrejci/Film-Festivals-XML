<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <!-- Nastavenínamespace -->
    <ns uri="http://matej-krejci.cz/xml/filmFestivals" prefix="ff"/>
    
    <!-- kontrola dat -->
    <pattern>
        <title>Kontrola dat festivalu</title>
        <rule context="ff:dates">
            <assert test="ff:end >= ff:start">
                CHYBA: Datum konce festivalu (<value-of select="ff:end"/>) musí být po nebo rovno datu začátku (<value-of select="ff:start"/>).
            </assert>
        </rule>
    </pattern>
    
    <!-- kontrola součt filmů -->
    <pattern>
        <title>Kontrola počtu filmů</title>
        <rule context="/ff:numberOfFilms">
            <assert test="@total = (@featureFilms + (if (@shortFilms) then @shortFilms else 0) + (if (@documentaryFilms) then @documentaryFilms else 0))">
                CHYBA: Celkový počet filmů (<value-of select="@total"/>) musí odpovídat součtu celovečerních (<value-of select="@featureFilms"/>), 
                krátkých (<value-of select="if (@shortFilms) then @shortFilms else '0'"/>) 
                a dokumentárních (<value-of select="if (@documentaryFilms) then @documentaryFilms else '0'"/>) filmů.
            </assert>
        </rule>
    </pattern>
    
    <!-- kontrola vítězů u nadcházejících festivalů -->
    <pattern>
        <title>Kontrola vítězů u budoucích festivalů</title>
        <rule context="/ff:filmFestivals/ff:festival[@status='upcoming']/ff:awards/ff:award">
            <assert test="not(@winner)">
                CHYBA: Nadcházející festival '<value-of select="ancestor::ff:festival/@name"/>' nemůže mít uvedené vítěze cen.
            </assert>
        </rule>
    </pattern>
    
    <!-- kontrola kapacity -->
    <pattern>
        <title>Kontrola kapacity</title>
        <rule context="/ff:filmFestivals/ff:festival/ff:location/ff:capacity">
            <assert test=". > 0 and . &lt;= 100000">
                CHYBA: Kapacita (<value-of select="."/>) musí být mezi 1 a 100000.
            </assert>
        </rule>
    </pattern>
    
    <!-- kontrola cena vstupenek -->
    <pattern>
        <title>Kontrola cen vstupenek</title>
        <rule context="/ff:filmFestivals/ff:festival/ff:tickets/ff:ticket">
            <assert test="@price > 0">
                CHYBA: Cena vstupenky musí být větší než 0.
            </assert>
            <assert test="text() = 'basic' or text() = 'premium'">
                CHYBA: Typ vstupenky musí být buď 'basic' nebo 'premium'.
            </assert>
        </rule>
    </pattern>

</schema>
