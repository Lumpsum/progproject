## Dag 1
Voorstel uitgewerkt.

## Dag 2
Design document uitgwerkt. Conncectie met Firebase gemaakt, mogelijk om data weg te schrijven.

## Dag 3
Eerste meeting met groep gehad, ideeen uitgewisseld. Niks veranderd aan plan. Mogelijk om data op te halen uit Firebase. Gekozen om niet een extra vertakking te maken voor de categorie van een bericht, maar deze als eigenschap mee te geven. Dit zorgt ervoor dat ik makkelijker het icoon kan inladen in de feed.

## Dag 4
Registreren en inloggen bij Firebase voor gebruiker gemaakt. Extra informatie zoals naam en postcode wordt tijdens de registratie weggeschreven in de database.

## Dag 5
Probleem: Soms tweemaal inlog segue, mogelijke oorzaak is de listener. Sidebar menu geimplementeerd met behulp van een Objective-C library. Gebruikers naam laden bij de berichten in de feed, het probleem was dat de namen asynchroon geladen werden. Dit is opgelost door in de viewDidLoad de namen te laden en in een dict te zetten.

## Dag 6
Van coordinaat naar straatnaam en postcode. Tijdsinterval tussen opgeslagen tijd en actuele tijd en omzetten naar notatie nu/minuten/uren/dagen/weken. Reageren implementeren. Probleem was eerst dat ik niet aan de key van het geselecteerde bericht kon komen. Dit kon na van alles proberene echter heel makkelijk door de 'toAnyObject' methode aan te passen en de key mee terug te geven. 

## Dag 7
Reageren is nu mogelijk op een speciefieke melding. Probleem was eerst dat de meest recente comment overschreven werd, maar door de data opnieuw in te laden is dit probleem verholpen.
