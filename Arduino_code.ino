#include <CapacitiveSensor.h>
#include <Stepper.h>

CapacitiveSensor touch = CapacitiveSensor(3,2);
Stepper myStepper(200, 11, 9, 10, 8); 


int flag;
int flag2;
int lastFlag;
int lastFlag2;
int count;
int stepvalue=0; // se valore positivo, rotazione oraria; se valore negativo, rotazione antioraria. 
int vel=0; 


int ledPin[] = {4,5,6,7};              //array dei pin che sono collegati ai led
bool statePin[] = {LOW, LOW, LOW, LOW};   //array degli stati dei led (all'inizio sono tutti spenti)

 

//dichiarazione variabili necessarie a far lampeggiare il led selezionato senza delay 
unsigned long previousMillis = 0;         //variabile che salva l'ultimo istante in cui il led è stato acceso 
unsigned long interval = 200;             //intervallo di tempo a cui far lampeggiare il led (in millisecondi)
int countTime=0;
int state;

int switchdirection=1; // variabile direzione rotazione motore
int on=0;               //variabile accensione motore
  
void setup() {
  Serial.begin(9600);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  flag = 0;
  flag2= 0;
  lastFlag =0;
  lastFlag2 = 0;
  count = 0;
  state = 0;
  myStepper.setSpeed(vel); // funzione per impostare la velocità del motore in RPM
  
}

 

void loop() {
  long value = touch.capacitiveSensor(500);    // è una misura di tempo; rappresenta il tempo necessario al condensatore per caricarsi, mediato su 1000 valori.
 
   // la variabile flag serve a segnalare quando il valore letto (value) è maggiore di 500 
  // cioè quando il dito tocca il senosore flag=1
  // quando il dito non lo tocca flag=0
  lastFlag = flag; //prima di aggiornare il valore di flag salvo il vecchio valore
                   //per identificare quando ho il passaggio da 1 a 0 (cioè quando il dito si stacca)
                   
//con questo if definisco il valore di flag
  if (value > 400){
    flag = 1;     
  }              
  else          
    flag = 0;





//con questo if rilevo il passaggio di flag da 1 a 0
  if ((lastFlag==1) && (flag==0)){
    
    digitalWrite(ledPin[count], statePin[count]); //quindi accendo o spengo il led in accordo con il suo stato
                                                                                               
    if (count==3)                                 //aggiorno la variabile count che funziona da indice per puntare un led
      count=0;                                    //(quindi passo al led successivo)
    else
      count++;
  
  }

// questo if serve a contare da quanto tempo sto tenendo premuto il senosore
  if(flag==1){
    countTime++;
  }
  else
    countTime=0;

 

//la variabile flag2 serve a segnalare quando il sensore è stato premuto per più di 100 cicli

  lastFlag2=flag2;  //prima di aggiornare il valore di flag2 salvo il vecchio valore
                    //per identificare quando ho il passaggio da 0 a 1 
                    //(cioè quando sono passati esattamente 30 cicli dall'inizio del tocco)
                    
//con questo if definisco il valore della variabile flag2
  if(countTime>=30){
    
     if(countTime%30 == 0)
      flag2++;
  }
  else
    flag2 = 0;

//con questo if rilevo il passaggio di flag2 da 0 a 1 
//e aggiorno lo stato del led selezionato (cioè faccio il toggle del suo stato)
  if ((lastFlag2==0) && (flag2==1) && (count==0 or count==3))
    statePin[count] =! statePin[count];
  
  switch (count){
    
    case 0: // regolo accensione e spegnimento
    if (statePin[count]==HIGH && on==0) 
    { 
      stepvalue=20; 
      vel=160;
      myStepper.setSpeed(vel);
      myStepper.step(stepvalue); // funzione bloccante usata per far ruotare il motore di stepvalue passi.
      on=1; // variabile usata per chiarire il fatto che il motore sia acceso
    }
    else if(statePin[count]==LOW)
    {
      stepvalue=0;
      myStepper.step(stepvalue);
      on=0;
      // dopo lo spegnimento resettiamo lo stato del motore
      vel=0;
      switchdirection=1;  
      statePin[3]=LOW;
      digitalWrite(ledPin[3], statePin[3]);
    }
    break;
    
    case 1: // case per diminuire la velocità
    if(vel>10 && lastFlag2<flag2 && on==1) {           //finché flag2 si incrementa, stiamo premendo, quindi la velocità continua a decrementarsi fino ad un minimo
      
      vel-=50;
      myStepper.setSpeed(vel);
      stepvalue-= (switchdirection)*6; // diminuiamo anche il numero di step per mantenere circa costante il tempo di esecuzione della funzione seguente
      myStepper.step(stepvalue);
      
    }
      
    break;
 
    
    case 2: //case per aumentare la velocità
     if(vel<310 && lastFlag2<flag2 && on==1) //finché flag2 si incrementa, stiamo premendo, quindi la velocità continua ad incrementarsi fino ad un massimo
    {                                                            
      vel+=50;
      myStepper.setSpeed(vel);
      stepvalue+=(switchdirection)*6;
      myStepper.step(stepvalue);
    }
    
    break;

    
    
    case 3:
   if(statePin[count]==HIGH && flag2>0 && on==1 && switchdirection==1) // la condizione dello switch direction mi serve per far entrare una sola volta nell'if
    {                                              // questo mi permette di cambiare direzione una volta sola
      stepvalue=-stepvalue;
      myStepper.step(stepvalue);
      switchdirection=-1;
    }
   else if (statePin[count]==LOW && flag2>0 && switchdirection==-1 && on==1)    // la condizione dello switch direction mi serve per far entrare una sola volta nell'if
    {                                                      // questo mi permette di cambiare direzione una volta sola
      stepvalue=-stepvalue;
      myStepper.step(stepvalue);
      switchdirection=1;
      
    } 
    
    
    break; 
  }
  
//con questo blocco di codice faccio lampeggiare il led selezionato senza usare il delay

  unsigned long currentMillis = millis(); //definisco la variabile con l'attuale istante di tempo dall'ultima accensione
  
  if(currentMillis - previousMillis > interval) { //se dall'ultimo aggiornamento dello stato del led è passato un intervallo di tempo 
                                                  //maggiore di quello definito allinizio (variabile interval) faccio il toggle dello stato
    previousMillis = currentMillis;               //aggiorno la variabile dell'ultimo aggiornamento
    
    state=! state; //if the LED is off turn it on and vice-versa

 

    if (flag2 ==0) //se non sono ancora passati 100 cicli dall'inizio del tocco fai lampeggiare il led
                   //se invece sono passati 100 cicli (c'è stato il tocco lungo) mostra lo stato del led (che si trova in statePin[])
      digitalWrite(ledPin[count], state);
  }
  delay(10);//fatto per avere meno rumore sulla lettura del sensore
  
  myStepper.step(stepvalue);
  
//variabili stampate per la comunicazione con Processing
  Serial.print(count);
  Serial.print(",");
  Serial.print(vel);
  Serial.print(",");
  Serial.println(switchdirection);

// blocco di codice per la reinizializzazione delle condizioni del motore nel caso venga premuto il tasto Reset su Processing
  if (Serial.available() > 0){
  String string  = Serial.readStringUntil('\n');
    if (string == "Reset" && on==true){
      
      count=0;    //lo mando a processing--> si illumina in grigio il pulsante del device state
      
      
      stepvalue=20;
      vel=160;
      switchdirection=+1;
      myStepper.setSpeed(vel);
      myStepper.step(stepvalue);
      
 
      statePin[0]=HIGH;                        //controllo accensione/spegnimento LED
      statePin[3]=LOW;
      digitalWrite(ledPin[0], statePin[0]);
      digitalWrite(ledPin[3], statePin[3]);
      
    }
    delay(10);}
}
