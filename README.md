README 

Nel seguente file saranno esplorati tutti i passaggi necessari affinchè l'app possa funzionare correttamente.

                                                    
                                                    
                                                        CAP 1: Docker RMF

Il primo passaggio è quello di alzare i Container Docker necessari per la simulazione di Open RMF.
Si noti che tali container dovranno necessariamente essere alzati in ambiente Linux. 
Si assume che nel sistema è già installato Docker, quindi tale procedura di installazione è omessa.

Aprire il terminale e lanciare in tre terminali diversi i seguenti comandi:

CONTAINER DELLA SIMULAZIONE OPEN RMF:

docker run --network=host \
-it ghcr.io/open-rmf/rmf_deployment_template/rmf-simulation:latest \
bash -c "ros2 launch rmf_demos_gz office.launch.xml \
headless:=1 \
server_uri:=ws://localhost:8000/_internal"

CONTAINER API SIMULAZIONE - GUI

docker run --network=host \
-it ghcr.io/open-rmf/rmf_deployment_template/rmf-web-rmf-server:latest

CONTAINER GUI: (opzionale per il funzionamento dell'interfaccia, ma necessario per la visualizzazione sulla mappa)

docker run -p 3000:80 \
-it ghcr.io/open-rmf/rmf_deployment_template/rmf-web-dashboard-local:latest

Una volta che tutti i container saranno stati avviati (il primo potrebbe richiedere qualche instante più degli altri, specialmente al primo avvio), recarsi tramite il seguente link (http://localhost:3000/dashboard) all'interfaccia messa a disposizione da Open RMF per la visualizzazione della mappa con i robot.

A differenza dell'interfaccia sviluppata dal sottoscritto, quella di cui sopra funziona solo ed esclusivamente sul dispositivo su cui sta girando la simulazione (aka "server").



                                                    CAP 2: REVERSE PROXY NGINX

SPIEGAZIONE PRELIMINARE

La simulazione Open RMF è concepita per inviare e ricevere le informazioni tramite localhost esponendo degli endpoint sulle porte 8000 e 8083. Nello specifico il fetch delle task viene effettuato tramite la porta 8000 sull'endpoint "/tasks". Tale implementazione non reca alcun disturbo finchè l'interfaccia viene eseguita in localhost sul server stesso, ma non appena si prova ad accedere a tale porta da remoto tramite un dispositivo diverso dal server, la richiesta http restituisce un codice di errore.

La soluzione a questo problema è stata quella di implementare un Reverse Proxy tramite Nginx. Così facendo possiamo esporre la porta 8082 per ricevere la richieste dal client (al posto della porta 8000), e inoltrarle alla porta 8000. 



PROCEDURA DI CREAZIONE DEL REVERSE PROXY

Eseguire i seguenti passaggi sul server.

STEP 1: installare nginx

    sudo apt update
    sudo apt install nginx


STEP 2: configurare il proxy 

    sudo nano /etc/nginx/sites-available/default

sovrascrivere il contenuto con quanto segue:

“””
    server {
        listen 8082;
        server_name myServer.ddns.org;  # Modificare a piacere

        location / {
            proxy_pass http://localhost:8000;  # Inoltra le richieste alla porta 8000
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
“””


STEP 3: salvare e chiudere 

STEP 4: riavviare nginx

    sudo systemctl restart nginx






                                                    CAP 3: IMPORTARE L'INTERFACCIA

Il modo più immediato per eseguire l'app è quello di runnarla in modalità debug tramite Visual Studio Code (o altro IDE), ma di seguito sono riportati i passaggi da seguire per importarla su dispositivi iOS, ipadOS, MacOS e Linux.
E' possibile eseguire l'aplicazione anche su Windows e dispositivi Android, ma il dettaglio dell'importazione in questi casi non è riportanto nel presente file, anche se facilemnte reperibile in rete.

Naturalmente è necessario clonare il progetto dalla repo git del sottoscritto al seguente link: 
https://github.com/frankydedo/fleet_manager 


iOS e ipadOS

Per importare l'app sui dispositivi mobile di Apple ci sono due modalità: quella definitiva (richiede un abbonamento al programma Apple Developer da $100/anno), oppure la modalità "Profile" (di seguito spiegata) che da diritto all'utilizzo dell'applicazione con una scadenza di 7 giorni, dopo i quali è comunque possibile eseguire nuovamente l'importazione e avere diritto ad ulteriori 7 giorni a oltranza. 

Per procedere è necessario XCode:
Una volta recatisi nella direcotry "ios" del progetto, aprire con XCode il file relativo al workspace denominato "Runner.xcworkspace".
Una volta aver selezionato il dispositivo corretto su cui importare l'app (può essere collegato al computer via cavo o anche rimandendo sotto la stessa rete wi-fi), andare nella barra in alto di XCode e alla voce "Product" selezionare l'opzione "Profile". Questo farà partire la Build al termine della quale troveremo l'app sul dispositivo mobile con il nome di "R.O.A.M." e il logo blu col robottino.
Prima di poterla eseguire ci si deve recare nelle impostazioni del dispositivo per autorizzare lo sviluppatore (Impostazioni -> Generali -> VPN e gestione dispositivo -> fpdedomi@gmail.com). 



MacOS

Assicurasi di avere Flutter installato.

Recarsi da terminale nella directory del progetto e eseguire il comando:
    flutter build macos 

Recarsi alla directory "./build/macos/Build/Products/Release" e lanciare l'eseguibile. 



Linux

Assicurasi di avere Flutter installato.

Recarsi da terminale nella directory del progetto e eseguire il comando:
    flutter build linux

Recarsi alla directory "./build/linux/release/bundle/" e lanciare l'eseguibile.





                                                    CAP 4: IMPOSTAZIONI INTERFACCIA

L'interfaccia è dotata di una sezione dedicata alle impostazioni di rete. 
Qui è possibile:
    - Controllare lo stato della connessione col server;
    - Abilitare la modalità "localhost" (consigliata nel momento in cui l'app venga eseguita sul server stesso, così da "baypassare" le richieste http);
    - Impostare l'IP address privato del server. Questo di default è impostato a 192.168.1.5, ma può essere modificato a seconda del caso specifico.

Si noti che tutte le impostazioni sono salvate su Database impementato tramite Hive, risolvendo la necessità di modificare ad ogni avvio.



NOTE IMPORTANTI:
Una volta eseguiti questi passaggi si sarà in grado utilizzare l'interfaccia con tutte le sue funzionalità, a patto che ci si trovi sotto la stessa LAN del server.

Idealmente è possibile implementare una versione dell'interfaccia che consenta al client di accedere ai dati del server anche da una rete differente. Per fare ciò è necessario implementare un DDNS (tramite il quale associare un nome all'IP server, e.g. youbiquoServer.ddns.org), e un Port Forwarding sul router del server. Tale implementazione non è stato possibile farla per motivi di tempo, ma in futuro non è da escludere come possibile miglioria. 
