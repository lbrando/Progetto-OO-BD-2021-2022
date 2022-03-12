# PROGETTO OO-BD 2021-2022
Progetto di Object Orientation e Basi Di Dati per il CdL in Informatica della Federico II.
- Autori: Lucia Brando ed Enrico Amatore
- Professore di Object Orientation: Sergio Di Martino
- Professore di Basi Di Dati: Adriano Peron
## LINK

[Drive del Progetto di Basi Di Dati](https://drive.google.com/drive/u/0/folders/1gU2ERtXEZ6hTgcm9EjcCy9ix6l7xUDj0)



## Traccia

Si sviluppi un sistema informativo, composto da una base di dati relazionale e da un applicativo Java dotato di GUI (Swing o JavaFX), per la gestione di corsi di formazione. Il sistema permette ad un operatore di gestire corsi di formazione. Un corso è caratterizzato da un nome, una descrizione, un tasso di presenze minimo necessario (e.g.: 75%), un numero massimo di partecipanti, e da una o più lezioni. Ciascuna lezione è caratterizzata da un titolo, una descrizione, una durata (espressa in ore), e una data e orario di inizio. I corsi possono inoltre essere organizzati in aree tematiche definibili dagli operatori, e un corso può appartenere a più aree tematiche. Gli operatori possono anche iscrivere studenti ai corsi e, per ogni lezione, tenere traccia delle presenze/assenze degli studenti iscritti. Il sistema permette di effettuare interrogazioni avanzate sui corsi erogati, con possibilità di filtraggio per una o più categorie, per data, per parole chiave. Inoltre, il sistema permette di visualizzare, per ciascun corso, statistiche sul tasso di frequenza (e.g.: numero medio, minimo e massimo di studenti a lezione, percentuale di riempimento media) e un prospetto dove sono evidenziati gli studenti che hanno ottenuto il numero minimo di presenze e sono quindi idonei al superamento del corso. 
Per i gruppi composti da 3 membri: Il sistema permette, per ciascun corso, l’inserimento di zero o più test di valutazione. Un test, come una lezione, è caratterizzato da un titolo, una descrizione, una durata (espressa in ore), e una data e orario di inizio. Un test di valutazione non può sovrapporsi a una lezione dello stesso corso. Inoltre, ogni test ha un punteggio minimo (espresso in centesimi) per il superamento. Per ciascun test, un operatore può indicare, per ciascuno studente iscritto al corso, il punteggio ottenuto. Inoltre, il sistema include un prospetto finale dove sono evidenziati tutti gli studenti che hanno superato il corso, ovvero che hanno ottenuto il numero minimo di presenze e almeno il punteggio minimo a tutti i test.

## Cosa abbiamo utilizzato:

- PgAdmin 4 e PostreSQL per implementare il database
- Eclipse per sviluppare il codice Java e le Interfacce
- Visual Paradigm per la costruzione del Class Diagram e Sequence Diagram
- GitHub per la creazione delle repository
- Google Drive per la condivisione del codice sorgente e della documentazione
- Microsoft Word per la documentazione
- Documentazione di PosgreSQL (https://www.postgresql.org/docs/)
- Moqups per la progettazione dei mockups
