#Buurt
Programmeerproject 16/17

Naam: Martijn de Jong

Studentnummer: 10774807

Beschrijving:

Deze repository bevat alle bestanden en aanvullende documenten van de app 'Buurt'. Deze iOS app is gemaakt voor het vak 'Programmeerproject' van de minor Programmeren aan de Universiteit van Amsterdam.

---
##Projectvoorstel
De app 'Buurt' is een verbetering op het opkomend aantal Whatsapp-groepen in buurten. Deze groepen zijn in het leven geroepen om samen de buurt in de gate te houden en verdachte situaties te delen met buren. Een chat kan echter snel onoverzichtelijk worden en biedt geen snel overzicht van wat er speelt in de buurt. Deze app brengt buren met elkaar in contact en maakt het mogelijk om melding te maken van bijvoorbeeld verdachte situaties, aandachtspunten en misstanden in de wijk.


###Features
Deze app maakt het mogelijk om meldingen te maken in een postcode gebied. Deze meldingen zijn te zien voor iedereen in de buurt. Deze meldingen worden gecategoirseerd in de volgende categorieen: verdachte situaties, aandachtspunten, evenementen, klachten en berichten. Voor deze categorieen is ook een filter beschikbaar via de navigatiebalk. Daarnaast is het mogelijk om te reageren op deze meldingen en zo samen contact te houden over een specifiek onderwerp. Meldingen kan je ook volgen, zodat de gebruiker zelf kan bepalen wat hij of zij wilt volgen in de buurt. Door het melden van een probleem laagdrempelig te houden, door bijvoorbeeld maar 5 categorieen te gebruiken, zal de gebruiker snel een melding kunnen maken. Tot slot kan elke gebruiker ook buiten zijn of haar gebied de meldingen bekijken via de 'In de buurt' tab. 

Mogelijke extra features:
- Verschillende soorten gebruikers, zoals een beheerder, wijkagent, ambtenaar en buur.
- Het kunnen markeren als voltooid of afgehandeld van berichten.
- Chatten mogelijk maken.

###Schetsen
<img src="https://github.com/Martijn66/progproject/blob/master/doc/11.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/12.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/13.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/14.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/15.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/16.png" width=30%>

###Data
De meeste data wordt geleverd door de gebruikers zelf. Deze data wordt opgeslagen in een database en is vervolgens te raadplegen door de andere gebruikers. Daarnaast wordt er data verkregen met gebruik van MapKit waarbij coordinaten van een locatie worden opgehaald.


###Componenten
Deze app kan verdeeld worden in verschillende componenten. Het loginscherm wordt in principe alleen getoond bij het de eerste keer opnenen van de app. In dit scherm kan een account aangemaakt worden of indien de gebruiker al een account heeft kan hij of zij inloggen. Het startscherm bestaat uit een feed van de laatste meldingen en een hot topic dat bepaald is met behulp van het aantal reacties en de tijdstamp van de melding. In dit overzicht is het ook mogelijk om meldingen te volgen. Deze meldingen worden in een apart scherm weergegeven. Daarnaast is er een scherm voor elke melding, waarbij de naam, categorie, beschrijving, optioneel een foto, locatie op kaart en reacties zijn opgenomen. Daarnaast is natuurlijk ook een scherm waarbij de gebruiker een melding kan maken. Dit scherm is snel te bereiken via de tab bar, zodat de drempel voor het maken van een melding laag is. Het 'In de buurt' scherm toont een grote kaart met daar onder een tableview waarbij men ook buiten de eigen buurt de meldingen kan zien. Hiervoor wordt gebruik gemaakt van de huidige locatie van de iPhone.


###Externe Componenten
Voor het opslaan van de meldingen en daarbij behoordende informatie en data en het beheren van accounts zal Google Firebase gebruikt worden. Daarnaast zal MapKit van Apple gebruikt worden voor het weergeven van de kaarten en verkrijgen van de coordinaten. 


###Technische uitdagingen
Het gebruik maken van de locatie zal waarschijnlijk het meest uitdagend zijn. Er zijn echter genoeg mogelijkheden om locatievoorziening te gebuiken. Apple heeft een eigen MapKit die gebruikt kan worden, een alternatief zou de Google API kunnen zijn. Daarnaast zou ik gebruik kunnen maken van Facebook tijdens het aanmeldingsproces. In dit geval hoeft de gebruiker zelf geen naam op te geven en profielfoto. Dit laatste is niet belangrijk, maar kan de app wel visueel aantrekkelijker maken. In het technisch ontwerp zal ik dieper ingaan op de structuur van de database.


###Vergelijkbare app's
In de App store zijn vergelijkbare app's beschikbaar. De app 'BuurtApp' heeft niet veel goede beoordelingen. In de slechte recensies wordt voornamelijk aangegeven dat de app crasht en niet naar behoren werkt. De app 'Nextdoor' daarentegen heeft 4 sterren over alle versies en krijgt zeer goede recencies. Wel zijn er drie punten van kritiek te vinden: reclame in de app, spam en ongewenste berichten en de hoeveelheid persoonlijke gegevens die de app wilt weten.

Dit laatste punt is denk ik belangrijk om rekening mee te houden. Zo is voor het bepalen van de buurt de postcode in eerste instantie genoeg informatie, daarnaast is een (gebruikers)naam verplicht, maar een profielfoto is bijvoorbeeld optioneel.Ik denk dat het zeer belangrijk om de scope van de app niet al te breed te maken en het maken en ontvangen van meldingen centraal moet staan. De drempel om deel te nemen aan deze app moet zo laag mogelijk zijn.

[![BCH compliance](https://bettercodehub.com/edge/badge/Martijn66/progproject)](https://bettercodehub.com)
