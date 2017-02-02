## Dag 1 (09-01-2017)
Voorstel uitgewerkt.

## Dag 2 (10-01-2017)
Design document uitgwerkt. Conncectie met Firebase gemaakt, mogelijk om data weg te schrijven.

## Dag 3 (11-01-2017)
Eerste meeting met groep gehad, ideeen uitgewisseld. Niks veranderd aan plan. Mogelijk om data op te halen uit Firebase. Gekozen om niet een extra vertakking te maken voor de categorie van een bericht, maar deze als eigenschap mee te geven. Dit zorgt ervoor dat ik makkelijker het icoon kan inladen in de feed.

## Dag 4 (12-01-2017)
Registreren en inloggen bij Firebase voor gebruiker gemaakt. Extra informatie zoals naam en postcode wordt tijdens de registratie weggeschreven in de database.

## Dag 5 (13-01-2017)
Probleem: Soms tweemaal inlog segue, mogelijke oorzaak is de listener. Sidebar menu geimplementeerd met behulp van een Objective-C library. Gebruikers naam laden bij de berichten in de feed, het probleem was dat de namen asynchroon geladen werden. Dit is opgelost door in de viewDidLoad de namen te laden en in een dict te zetten.

## Dag 6 (16-01-2017)
Van coordinaat naar straatnaam en postcode. Tijdsinterval tussen opgeslagen tijd en actuele tijd en omzetten naar notatie nu/minuten/uren/dagen/weken. Reageren implementeren. Probleem was eerst dat ik niet aan de key van het geselecteerde bericht kon komen. Dit kon na van alles proberen echter heel makkelijk door de 'toAnyObject' methode aan te passen en de key mee terug te geven. 

## Dag 7 (17-01-2017)
Reageren is nu mogelijk op een speciefieke melding. Probleem was eerst dat de meest recente comment overschreven werd, maar door de data opnieuw in te laden is dit probleem verholpen. Mapkit geimplementeerd, kaartje met pin is nu zichtbaar op de pagina van een enkele melding. Ook de 'In de buurt' ViewController aangemaakt, ook hierbij worden alle pins geplaatst op de kaart. Er kan nog niet doorgelinkt worden naar de pagina's van de meldingen.

## Dag 8 (18-01-2017)
Naast de startUpdateLocation() methode heb ik ook de requestLocation() methode geimplementeerd. Instellingen scherm functioneel gemaakt. Start gemaakt met het mogelijk maken van berichten volgen, extra eigenschap aan de 'user' class gegeven hiervoor. Gewerkt aan de Style Guide.

## Dag 9 (19-01-2017)
Style Guide besproken met de groep en afgemaakt. Volgen van berichten nu mogelijk en weggeschreven in Firebase. Proberen om dezelfde ViewController te gebruiken voor zowel feed als volgen, maar ik kan geen identifier checken door het sidemenu dat ik gebruik. Opgelost! Na struinen door de Objective-C bestanden en vanalles geprobeerd te hebben kwam Julian er achter dat ik gebruik maakte van een Swift 2 functie, die in Swift 3 net wat anders in elkaar zit. Nieuw probleem was de navigation controller die tussen de twee controllers in zit, dit is opgelost door eerst te linken naar de nav controller en dan door naar de destination controller.

## Dag 10 (20-01-2017)
Alpha versie gepresenteerd.

## Dag 11 (23-01-2017)
De gebruiker gegevens worden nu ingeladen voordat de mentions worden opgehaald, nu kan de postcode gecheckt worden en worden alleen de berichten ingeladen die uit deze postcode komen. Probleem: asynchrone processen op de juiste volgorde uitvoeren en wachten totdat het ene proces klaar is. Gebruik gemaakt van dispatch groepen hiervoor. Wel nog een probleem met het volgen van een melding. SingleMentionViewController aangepast, het bericht zelf scrollt nu mee als de gebruiker meer reacties wilt zien. View verplaatst nu ook omhoog als het toetsenbord verschijnt, de gebruiker kan nu zien wat hij/zij typt.

## Dag 12 (24-01-2017)
User Feedback bij inlogscherm in de vorm van een alert toegevoegd. Gebruiker kan nu ook zijn postcode aanpassen in het instellingen scherm. EINDELIJK werkt alle code met Firebase goed. De postcode moet eerst opgehaald worden, daarna kan pas de rest ingeladen worden omdat het geen zin heeft om gelijk alle mentions in te laden van andere postcode gebieden. Het probleem was als ergens in de app (instellingen of volgen van een melding) iets in Firebase aangepast werd, de observer in de MainViewController vast liep. De oorzaak was dat in deze observer de dispatch groep verlaten moest worden, maar als in een ander scherm wat aangepast werd, werd deze observer niet eerst aan de dispatch groep toegevoegd. De oplossing is om ook te werken met een begin handler (http://stackoverflow.com/questions/39465789/swift-how-to-use-dispatch-group-with-multiple-called-web-service/40004392). Begin gemaakt met profielfoto's. Bericht kan nu ook onvolgd worden.'

## Dag 13 (25-01-2017)
Profielfoto's kunnen worden opgeslagen en worden opgehaald. Deze worden in het cache geheugen bewaard, zodat deze niet telkens opgehaald hoeven te worden als een ViewController opnieuw aangeroepen wordt. Na het plaatsen van een melding wordt nu een unwind segue uitgevoerd naar de feed. Berichten staan nu van nieuw naar oud gesorteerd. Je kan berichten verwijderen die van je zelf zijn onder de tab 'mijn meldingen'. Geen beginreactie meer nodig voor de initialisatie van een Mention object, parameter is nu optioneel en heeft een default waarde. Checkt nu in het registreer scherm of alles is ingevuld en of het controle wachtwoord goed is ingevuld. Geeft ook feedback met een alert aan de gebruiker. Probleem was nu dat bij de eerste reactie de index 1 wordt meegegeven waardoor de app crasht, opgelost door goed te checken wanneer er nog geen reacties zijn geplaatst.

## Dag 14 (26-01-2017)
De gebruiker kan bij het aanmaken van een nieuwe melding ook op de kaart een pin plaatsen ipv huidige locatie te gebruiken. Ook wordt in de schermen 'mijn meldingen' en 'volgend' naar het goede bericht doorgelinkt als hierop wordt geklikt. Huidige locatie bij nieuwe melding gefixt.

## Dag 15 (27-01-2017)
Presentatie

## Dag 16 (30-01-2017)
Alle viewcontrollers zijn responsive. Bestanden zijn 's avonds door mijn eigen backup overschreven, dus ik moest mijn commit van 1 uur 's middags terug zetten. Dus helaas wat dubbel werk gehad..

## Dag 17 (31-01-2017)
Segmentation Fault: 11 gefixt, dit had te maken met de referentie naar Firebase Storage. Deze had ik bovenaan in de VC class gedefineerd, en later in een functie gebruikt. Nu defineer ik de referentie pas in de functie. 

## Dag 18 (01-02-2017)
Code opgeruimd, hulpfuncties aangemaakt voor functies die erg lang werden. Functies die in meerdere ViewControllers gebruikt worden verplaatst en globaal gemaakt. Readme aangepast en report geschreven.

## Dag 19 (02-02-2017)
Timestamp aangepast van een NSDescription naar een TimeIntervalSince1970, nu worden de berichten juist op volgorde van nieuw naar oud gepresenteerd. Launchscreen toegevoegd. Dubbel check voor locatiegebruik geimplementeerd, zodat er geen crash is indien de locatie in de simulator niet aan staat. De functie setProfilePicture() wordt in de SettingsViewController nu in de viewDidAppear() aangeroepen ipv de viewDidLoad(). Het probleem was dat de afbeelding al werd toegevoegd voordat de dimensies van de UIImageView bekend waren, daardoor werd de radius die gebasseerd is op deze maten niet goed toegepast.
