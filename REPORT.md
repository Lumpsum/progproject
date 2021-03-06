#Verslag

Naam: Martijn de Jong

Studentnummer: 10774807

Datum: 02-02-2017

##Beschrijving
Deze app maakt het mogelijk om meldingen te maken in de wijk (postcode gebied). Deze meldingen zijn te zien voor iedereen in de wijk. Deze meldingen worden gecategoirseerd in de volgende categorieen: verdachte situaties, aandachtspunten, evenementen, klachten en berichten. Een melding bestaat uit een titel, beschrijving, categorie, tijdstempel en locatie. Het is voor buren mogelijk om te reageren op deze meldingen en zo samen contact te houden over een specifiek onderwerp. Meldingen kan je ook volgen, zodat de gebruiker zelf kan bepalen wat hij of zij wilt volgen in de buurt. Door het melden van een probleem laagdrempelig te houden, door bijvoorbeeld maar 5 categorieen te gebruiken, zal de gebruiker snel een melding kunnen maken. Daarnaast is een apart overizcht voor de meldingen die de gebruiker zelf heeft gemaakt, hier kan de gebruiker ook zijn/haar melding verwijderen. In de tab 'Verkennen' kan de gebruiker de buurt verkennen en op de kaart de verschillende meldingen zien en zo een globaal beeld krijgen van (probleem-)gebieden in de wijk. In de 'Instellingen' tab kan de gebruiker zijn/haar informatie en profielfoto aanpassen en uitloggen. Door middel van een navigatie balk bovenaan de app kan de gebruiker altijd zien op welk scherm hij/zij zich bevindt, terug indien de gebruiker verder dan het beginscherm komt, acties uitvoeren en het sidebar menu raadplegen.


##Technisch ontwerp

###Viewcontrollers
- LoginViewController: Hier kan de gebruiker inloggen met een emailadres en wachtwoord. Indien de gebuiker al is ingelogd zal de listner dit constanteren en de segue naar de MainViewController direct uitvoeren. Daarnaast is het mogelijk om door te klikken naar de SignUpViewController.
- SignUpViewController: De gebruiker kan hier een nieuw account aanmaken. Hiervoor worden de noodzakelijke gegevens als input gevraagd.
- MainViewController: Deze viewcontroller wordt gebruikt voor drie schermen die te bereieken zijn uit het sidebar menu: 'Overizcht', 'Mijn Meldingen' en 'Volgend'. Indien de functie van de VC 'Overzicht' is, verschijnt rechts boven in de navigatiebar de knop om een nieuwe melding te maken. Deze knop is niet beschikbaar voor de andere twee functies. Indien de functie 'Mijn Meldingen' is, kan de gebruiker door middel van 'swipe to delete' zijn of haar melding verwijderen uit de database.
- NewMentionViewController: Hier kan de gebruiker een nieuwe melding plaatsen. De gebruiker moet een titel, categorie, locatie en bericht invoeren om een melding te maken. De huidige locatie wordt automatisch opgehaald en ingevuld, deze kan gewijzigd worden door een pinpoint op een kaart te plaatsen in de PickLocationViewController.
- PickLocationViewController: De gebruiker kan een pinpoint op de kaart plaatsen, de locatie wordt doorgegeven aan de NewMentionViewController.
- SingleMentionViewController: Deze viewcontroller laat een enkele melding zien. De titel, tijdstempel, auteur, categorie, locatie, reacties en het bericht wordt weergegeven. Het is voor de gebruiker mogelijk om een reactie toe te voegen in het reactieveld.
- ExploreViewController: Dit scherm geeft een kaart weer waarop alle meldingen in de wijk als pinpoint worden weergegeven. Elk pinpoint laat de titel van de melding zien als er op getapt wordt.
- SettingsViewController: Hier kan de gebruiker zijn of haar profielfoto, voornaam, achternaam, email en postcode aanpassen.
- SidebarMenuTableViewController: Deze controller wordt gebruikt om het menu weer te geven en de elementen aan de juiste VC'ers te linken.

In Main.storyboard is nog een extra viewcontroller te zien van de class 'SWRevealViewController'. Deze viewcontroller is nodig om het menu onder de andere viewcontrollers te laten 'verdwijnen' als een menuitem geselecteerd wordt. Onderstaand een schema van de viewcontrollers en de bijbehordende methoden. De standaard methoden viewDidLoad() en didReceiveMemoryWarning() zijn hierin niet opgenomen.

<img src="https://github.com/Martijn66/progproject/blob/master/doc/diagram_new.png">

###Modellen
- GlobalCode Struct: Deze struct wordt gebruikt om alle actuele data in de gehele app toegankelijk te hebben. De meldingen worden onder 'mentions' in een lijst opgeslagen. De informatie over de ingelogde gebruiker, zoals uid, naam en postcode, wordt opgeslagen in de dictionary 'user'. De lijst met unieke id's van de meldingen die de ingelogde gebruikers volgt wordt opgeslagen in een lijst 'followlist'. In de variabel 'selectedMention' is in een dictionary de informatie van de geselecteerde item opgeslagen. Het item wordt in de MainViewController geselecteerd om vervolgens volledig weergegeven te worden in de SingelMentionViewController. Er is gekozen om deze informatie via deze variabel mee te geven in plaats van via een prepareForSegue functie, omdat de informatie ook nog aangepast kan worden (denk aan de reacties) als de SingleMentionViewController al geopend is. Omdat de informatie centraal in een varaiabel staat kan deze worden aagepast door de hulpfunctie fillMentionsArray() van updateMentions(). De variabelen 'uidNameDict' en 'uidPictureDict' bevatten een dicitonary van respectievelijk uid's en namen van de gebruikers en uid's en linkjes naar de profielfoto's van gebruikers. Deze informatie wordt gebruikt om de naam en foto's weer te geven bij de meldingen in de MainViewController en in de SingleViewController bij zowel de melding als reacties.
- Mention Struct: Een instantie van deze struct is een elkele melding. De meldingen worden opgehaald uit Firebase en met alle eigenschappen (key, titel, categorie, user id, locatie, bericht, tijdstempel en reacties) als instantie geinitialiseerd om vervolges in de mentions lijst te verzamelen. Ook wordt deze struct gebruikt om een nieuwe melding weg te schrijven in Firebase. Gebruik van deze struct voor meldingen zorgt ervoor dat de infromatie van een meldingen altijd compleet is. De locatie wordt weggeschreven in een dictionary met twee key-value paren, 'longitude' en 'latitude', als string. De reacties worden opgeslagen als een lijst van lijsten, waarbij elke lijst bestaat uit drie elementen: userid, tijdstempel, en bericht (string) en dit representeert 1 reactie. Alle overige eigenschappen zijn ook als string weggeschreven. De functie toAnyObject() kan aangeroepen worden en geeft van de instantie een dictionary met alle eigenschappen terug.
- User Struct: Deze struct wordt voor dezelfde doeleinden gebruik als de Mention Struct, maar dan voor een gebruiker. Naast de userid en email die standaard in Firebase worden weggeschreven bij het aanmaken van een account, wordt ook de voornaam, achternaam, postcode en een lijst van id's van melding die gevolgd worden door de gebruiker opgeslagen.
- Custom Cells: MentionCell en CommentCell zijn twee classes voor cellen uit tableviews die gebruikt worden. De eerste wordt gebruikt in de MainViewController en de tweede in de SingleMentionViewController voor het weergeven van de reacties. In de MentionCell wordt de regel code `messageField.contentInset = UIEdgeInsetsMake(-4,-4,0,0)` gebruikt om de padding van het UITextView element weg te halen zodat de text goed uitgelijnd staat met de titel er boven.
- MapPointer Class: Deze class wordt gebruikt om pinpoints te plaatsen op de kaart in de ExploreViewController en de SingleMentionViewController. De instanties van deze class worden als parameter meegegeven aan de addAnnotation() functie die op een MapView toegepast kan worden.
- Image Extentie: Deze extentie van de UIImage is uit een tutorial van 'Lets Build That App' (zie credits). Als een profielfoto geladen moet worden wordt eerst gekeken of de foto onder de pictureUrl al opgeslagen is in het cache geheugen. Indien dit zo is wordt de foto daaruit gehaald en weergegeven in de ImageView. Als dit niet zo is wordt de foto gedownload van Firebase, opgeslagen in het cache geheugen en weergegeven. Het cache geheugen wordt gewist als de app wordt afgesloten.
- ViewController Extentie: Deze extentie is van Goktugyil (zie credits) en zorgt simpelweg voor het herkennen van een tapgesture ergens op het beeldscherm en laat het toetsenbord zakken indien deze actief is.
- TextField Extentie: Deze extentie is van Nhgrif (zie credits) en zorgt ervoor dat de return toets bij een UITextField kan gekoppeld worden aan een ander UITextField en daarmee dit veld kan activeren.
- SWRevealViewController.h, SWRevealViewController.m en Buurt-Bridging-Header.h zijn de Objective-C bestanden die horen bij de sidebar menu bibliotheek van Simon NG (zie credtis). 

###Globale functies
- updateMentions(selectedKey: String?): Mentions ophalen uit Firebase voor actieve postcode en plaatsen in 'currentInfo.mentions' en updaten 'currentInfo.selectedMention'.
- fillMentionsArray(replies: Bool, mentionData: NSDictionary, mentionKey: String, selectedKey: String?): Daadwerkelijk vullen van de bovengenoemde variabelen en onderscheid maken tussen de meldingen met en zonder reacties. Dit is nodig omdat als er geen reacties zijn de 'replies' eigenschap met een default waarde wordt geinitialiseerd. Dit heeft de voorkeur gekregen boven een optionele eigenschap, omdat de structuur dan al aanwezig is voor het wegschrijven naar Firebase.
- updateCurrentUserInfo()
- updateUserDict()
- getTimeDifference(inputDate: String) -> String: Neemt een tijdstempel als parameter en vergelijkt deze tijd met de huidige tijd. Geeft een string terug in de vorm van 'Nu', 'x minuten', 'x uur' of een datum.
- setProfilePictures(pictureUrl: String?, pictureHolder: UIImageView, userid: String)
- centerMapOnLocation(location: CLLocation, regionRadius: CLLocationDistance, map: MKMapView)
- setMenuButton(controller: UIViewController, button: UIBarButtonItem)


[SCHEMA INVOEGEN]

###Firebase structuur
De firebase structuur bestaat uit twee hoofdtakken: 'mentions' en 'users'

- mentions
    - postcode
        - mention_id
            - addedByUser
            - category
            - timeStamp
            - titel
            - location
                - latitude
                - longitude
            - message
            - replies
                - []
                    - [user_id, timestamp, message]
- users
    - user_id
        - email
        - firstName
        - lastName
        - postcode
        - profilePictureUrl
        - followlist
            - [mention_id, mention_id]

###Uitdagingen
Voor het sidebar menu is gebruik gemaakt van een Objective-C bibliotheek. Het bridging bestand werd door XCode zelf aangemaakt. De grootste uitdaging was het koppelen van de viewcontrollers in Main.storyboard en de MainViewController een andere functies geven afhankelijk van het menuitem dat geselecteerd wordt. Een seguefuntie gebruiken in SideBarMenuTableViewController werkte niet, evenals een variabel in de MainViewController aanpassen vanuit een segue functie in het Objective-C header bestand. Uiteindelijk bleek de segue functie die ik gebruikte in de SideBarMenuTableViewController een Swift 2 functie te zijn en geen Swift 3. Nu wordt in de variabel 'viewFunction' vanuit de SideBarMenuTableViewController gezet welke functie, 'feed', 'follow' of 'mymentions', de MainViewController heeft. Aan de hand van deze variabel worden de juiste mentions ingeladen en de juiste knoppen en functies beschikbaar gemaakt.

Bij de meldingen in zowel het overzicht als in de SingleMentionViewController wilde ik graag het tijdstip van plaatsen weergeven in de vorm van 'nu', 'x minuten', 'x uur' of datum. Hiervoor heb ik een functie geschreven. De tijdstempel sloeg ik op als een string in de vorm '2017-02-02 10:45:32 +0000'. Deze moest eerst omgezet worden naar een NSDate format met behulp van een formatter functie, vervolgens moet de interval berekend worden tussen die tijd en de huidige tijd en aan de hand daarvan een string terug gegeven worden in de juiste vorm. Dit had ik volledig werkend. Deze tijdstempel wilde ik echter ook gebruiken om op te sorteren in het overzicht. Daarom heb ik er voor gekozen om vrij laat nog de tijd op te slaan als aantal seconden sinds 1970. Doordat de tijdstempels nu een double zijn, kunnen deze makkelijk onderling vergeleken worden. Doordat ik de hier eerder genoemde functie apart had staan kon ik deze aanpassing gemakkelijk maken.

De reactieseigenschap van een melding bestaat uit een lijst van lijsten met de benodigde informatie per reactie op de melding. Deze lijst is echter leeg bij de initialisatie van een melding, omdat er nog geen reacties zijn. Eerst had ik een testlijst meegegeven met de initialisatie en bij de eerste reactie werd deze overschreven. Dit heb ik aangepast omdat dit geen mooie oplossing heeft. Een melding kan nu geinitialiseerd worden met of zonder de eigenschap van reacties. Indien deze niet wordt meegegeven wordt een default waarde hier aan toegekend. Indien deze default waarde is toegekend, wordt er nog niks weg geschreven voor de reacties in Firebase. Pas als de eerste reactie geplaatst wordt, wordt de tak voor reacties aangemaakt in Firebase. Op deze manier staat er geen nepinformatie in Firebase. Voor de lijst met volgende berichten die bij de initialisatie van een gebruiker wordt aangemaakt, wordt wel nog een lijst met een 'nep'-string meegegeven. Dit kan in de toekomst nog op dezelfde manier aangepast worden.

Bij het implementeren van de postcode check, waarbij alleen de berichten worden geladen uit het postcodegebied van de gebruiker, was de grote uitdaging de volgorde van handelingen. Als eerst moet de postcode bekend zijn die opgeslagen is onder de user tak in Firebase om vervolgens alle mentions op te halen die onder deze postcode zijn weggeschreven in de mentions tak. Bij kleine hoeveelheden meldingen kan dit locaal gebeuren nadaat alles is opgehaald, maar als het aantal meldingen groter wordt, kost dit onnodig veel data, tijd en ruimte. Om ervoor te zorgen dat eerst de gebruikersgegevens en daarmee de postcode worden opgehaald is er gewerkt met een notificatie. In de functie setCurrentUserInfo() wordt de informatie van de gebruiker opgehaald en in een variabel opgeslagen. Als dit gebeurt is wordt in de functie  loadAllData(), die een notificatie krijgt dat de gebruikers informatie is opgehaald en weggeschreven, de rest van de benodigde data opgehaald. Dit gebeurt tevens in een Dispatch Group, zodat de applicatie niet vast loopt tijdens dit asynchrone proces.

###Verdediging beslissingen
Het eerste ontwerp van de app bestond uit een navigatiebar bovenaan en een tabbar onderaan het scherm. In het overzicht zou men de meldingen kunnen filteren op soort en vanuit het overzicht moest de gebuiker een nieuwe melding kunnen maken. Om al deze functionaliteiten een plek een knop te geven op het scherm, zou het scherm aardig vol worden. Als oplossing heb ik gekozen om een sidebar menu te implementeren. En nieuwe melding is wel nog te maken vanuit de MainViewController, maar de navigatie naar de andere viewcontrollers gaat via dit menu. De filterfuntie is uiteindelijk weg gelaten omdat de categorie van de meldingen dmv een icoon al duidlijk zijn in het overzicht.

De gebruiker kan zich maar in 1 postcode gebied tegelijk inschrijven. Hiervoor is gekozen omdat de aanname is dat de gebruiker slechts in 1 postcode gebied woonachtig is. Ik realiseer echter dat de gebruiker bijvoorbeeld op een grens van twee postcode gebieden kan wonen en om die reden graag op de hoogte blijft van beide postcode gebieden. Dit zou ik in de toekomst gemakkelijk kunnen worden toegevoegd door een lijst van postcodes op te slaan bij de gebruiker in Firebase en dan eventueel een keuzemenu te implementeren. Nu is het mogelijk om te switchen van postcode gebied door de postcode aan te passen in het instellingen scherm.




- Sidebar menu
- Self sizing cells
- Geofencing / Andere buurten kijken / notificaties

