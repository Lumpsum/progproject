##Design Document

Naam: Martijn de Jong

Studentnummer: 10774807

Datum: 11-01-2017

###Ontwerpschema
Dit schema geeft de verschillende ViewControllers weer en de daarbij gebruikte functies. Rechts boven zijn de diverse functies en stukken code te zien die centraal in een bestand opgenomen zullen worden zodat deze in verschillende controllers gebruikt kunnen worden.
<img src="https://github.com/Martijn66/progproject/blob/master/doc/diagram.png">

###UI Schetsen
<img src="https://github.com/Martijn66/progproject/blob/master/doc/11.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/12.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/13.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/14.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/15.png" width=30%>
<img src="https://github.com/Martijn66/progproject/blob/master/doc/16.png" width=30%>

###Frameworks
- Firebase
- MapKit
- Meldingen Openbare Ruimte Amsterdam Dataset (optioneel)

###Structuur Firebase
- mentions
  - mention_id
    - postcode
      - category
        - addedByUser
        - timeStamp
        - titel
        - location
        - message
        - pictures
        - replies
- users
  - user_id
    - firstName
    - lastName
    - postcode
    - profilePicture
    - favourites
    - role (optioneel)
