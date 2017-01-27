## Better Code Hub Report

Het volgende rapport heeft alleen betrekking op de Swift code. De Objective-C code van de sidebar menu library en Ruby code van de Cocoa Pods is niet meegenomen.

<img src="https://github.com/Martijn66/progproject/blob/master/doc/bettercodebefore.png">

### Write Short Units of Code
De functie updateMentions() scoort oranje doordat deze functie 31 regels code heeft. Deze kan zeker nog wat korter gemaakt worden door gebruik van een hulpfunctie.

### Write Simple Units of Code
Wederom scoort hier de updateMentions() functie oranje, dit is zoals hier boven genoemd aan te passen. Daarnaast scoort ook een tableView functie (func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)) oranje. Hier zijn namelijk 6 branching points aanwezig. In mijn optiek is dit niet anders in te delen omdat deze VC voor drie soorten schermen gebruikt wordt en dus een uitgebreide check plaats moet vinden.

### Write Code Once
Hierbij wordt wat duplicaat code aangegeven. De code om informatie van de huidige gebruiker op te halen uit Firebase komt nu nog dubbel voor. De hulpfunctie is namelijk al geschreven, maar nog niet in de hoofdfunctie geimplementeerd. Daarnaast wordt de LocatieManager() aangegeven als duplicaat. Maar dit is nodig omdat in twee verschillende VC de locatie opgehaald moet worden.

### Keep Unit Interfaces Small
De initialisatie van MentionItem scoort rood en die van de User scoort oranje. Deze inits zijn niet korter te maken of op te delen, dus deze zal ik ook niet aanpassen. De 'replies' eigenschap van MentionItem moet ook een default waarde hebben en niet optioneel zijn omdat de datastructuur (Array in Array) al bekend moet zijn voor Firebase. Wel zijn er nog wat gele punten waar winst te behalen is.

### Separate Concerns in Modules
NVT

### Couple Architecture Components Loosely
NVT

### Keep Architecture Components Balanced
Scoort rood, maar dit is niet van toepassing op een kleine app.

### Keep Your Codebase Small
Prima score met 0.08.

### Automate Tests
Scoort rood, maar is niet van toepassing bij dit project.

### Write Clean Code
Geeft groen, maar er moet nog wel goed gekeken worden naar commentaar en opmaak van de code.


