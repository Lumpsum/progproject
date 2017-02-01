##Verslag

Naam: Martijn de Jong

Studentnummer: 10774807

Datum: 02-02-2017

###Beschrijving
Deze app maakt het mogelijk om meldingen te maken in de wijk (postcode gebied). Deze meldingen zijn te zien voor iedereen in de wijk. Deze meldingen worden gecategoirseerd in de volgende categorieen: verdachte situaties, aandachtspunten, evenementen, klachten en berichten. Een melding bestaat uit een titel, beschrijving, categorie, tijdstempel en locatie. Het is voor buren mogelijk om te reageren op deze meldingen en zo samen contact te houden over een specifiek onderwerp. Meldingen kan je ook volgen, zodat de gebruiker zelf kan bepalen wat hij of zij wilt volgen in de buurt. Door het melden van een probleem laagdrempelig te houden, door bijvoorbeeld maar 5 categorieen te gebruiken, zal de gebruiker snel een melding kunnen maken. Daarnaast is een apart overizcht voor de meldingen die de gebruiker zelf heeft gemaakt, hier kan de gebruiker ook zijn/haar melding verwijderen. In de tab 'Verkennen' kan de gebruiker de buurt verkennen en op de kaart de verschillende meldingen zien en zo een globaal beeld krijgen van (probleem-)gebieden in de wijk. In de 'Instellingen' tab kan de gebruiker zijn/haar informatie en profielfoto aanpassen en uitloggen. Door middel van een navigatie balk bovenaan de app kan de gebruiker altijd zien op welk scherm hij/zij zich bevindt, terug indien de gebruiker verder dan het beginscherm komt, acties uitvoeren en het sidebar menu raadplegen.

Navigatie:
<img src="https://github.com/Martijn66/progproject/blob/master/doc/27.png" width=30%>

###Technisch ontwerp

####Viewcontrollers
- LoginViewController: Hier kan de gebruiker inloggen met een emailadres en wachtwoord. Indien de gebuiker al is ingelogd zal de listner dit constanteren en de segue naar de MainViewController direct uitvoeren. Daarnaast is het mogelijk om door te klikken naar de SignUpViewController.
- SignUpViewController: De gebruiker kan hier een nieuw account aanmaken. Hiervoor worden de noodzakelijke gegevens als input gevraagd.
- MainViewController: Deze viewcontroller wordt gebruikt voor drie schermen die te bereieken zijn uit het sidebar menu: 'Overizcht', 'Mijn Meldingen' en 'Volgend'. Indien de functie van de VC 'Overzicht' is, verschijnt rechts boven in de navigatiebar de knop om een nieuwe melding te maken. Deze knop is niet beschikbaar voor de andere twee functies. Indien de functie 'Mijn Meldingen' is, kan de gebruiker door middel van 'swipe to delete' zijn of haar melding verwijderen uit de database.
- NewMentionViewController: Hier kan de gebruiker een nieuwe melding plaatsen. De gebruiker moet een titel, categorie, locatie en bericht invoeren om een melding te maken. De huidige locatie wordt automatisch opgehaald en ingevuld, deze kan gewijzigd worden door een pinpoint op een kaart te plaatsen in de PickLocationViewController.
- PickLocationViewController: De gebruiker kan een pinpoint op de kaart plaatsen, de locatie wordt doorgegeven aan de NewMentionViewController.
- SingleMentionViewController: Deze viewcontroller laat een enkele melding zien. De titel, tijdstempel, auteur, categorie, locatie, reacties en het bericht wordt weergegeven. Het is voor de gebruiker mogelijk om een reactie toe te voegen in het reactieveld.
- ExploreViewController: Dit scherm geeft een kaart weer waarop alle meldingen in de wijk als pinpoint worden weergegeven. Elk pinpoint laat de titel van de melding zien als er op getapt wordt.
- SettingsViewController: Hier kan de gebruiker zijn of haar profielfoto, voornaam, achternaam, email en postcode aanpassen.
- SidebarMenuTableViewController: Deze controller wordt gebruikt om het menu weer te geven en de elementen aan de juiste VC'ers te linken.

In Main.storyboard is nog een extra viewcontroller te zien van de class 'SWRevealViewController'. Deze viewcontroller is nodig om het menu onder de andere viewcontrollers te laten 'verdwijnen' als een menuitem geselecteerd wordt. 


####Objecten

####

####Functies

#### Firebase structuur
