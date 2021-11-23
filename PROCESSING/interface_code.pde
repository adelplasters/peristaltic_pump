import processing.serial.*;
Serial myPort;  // Create local object from Serial library
String receivedString; //Decleare a new string (array of characters)
int end=10;

int x, y, l, h, xi, yi, xb=20, yb=20, lb=180, hb=70, xb2=53, yb2=47, lb2=178, hb2=61, velocita, lt=75, ht=25, ls=90, hs=200, i=0, j=-hs/2;
boolean rectOver = false;
//int on;
//int of=0;
PFont f, f2, f3, f4;
int vel;
int prec_val2=1; //per accensione/spegnimento
int prec_val3=1;//per dir.rotazione
int prec_val4=0;
int val2=0;
int val1;
int v;
int rotation = +1;


void setup(){
    fullScreen();
    f=createFont("GeosansLight.ttf", 34);
    f2=createFont("DS-DIGI.ttf", 34); //digital text on display
    f3=createFont("Arrows.ttf", 30); // arrows
    f4=loadFont("Raleway-SemiBold-48.vlw"); //reset
    textFont(f);
    
    String portName = Serial.list()[0];    
    myPort = new Serial(this, portName, 9600);    //creo elemento seriale "COM6"
    myPort.clear();
    receivedString= myPort.readStringUntil(end);
    receivedString=null;

    
}



void draw(){
    update(mouseX, mouseY);
    //background(120, 120, 90);
    fill (0);
    noStroke();
    rect (0, 0, width, height);
    fill (120, 120, 90);
    rect (10, 10, width-20, height-20, 20);
    prec_val4 = val2;
    while ( myPort.available() > 0) {  // If data is available,
    receivedString= myPort.readStringUntil(end);
    }               
    if (receivedString!=null) {              // If the serial value is 0,
    String[] a=split(receivedString, ',');
    //println(v);
    int val1=Integer.parseInt(a[0].trim());
    //on=Integer.parseInt(a[1].trim());
    velocita=Integer.parseInt(a[1].trim());
    rotation=Integer.parseInt(a[2].trim());
    
   print(val1);
      //print(on);
         print(velocita);
            println(rotation);



    
    //conversione velocita 10/310 --> 2/14
    if(rotation==+1){
    v=ceil(rotation*(0.04*velocita+1.6));}
    else if (rotation==-1){
    v=floor(rotation*(0.04*velocita+1.6));}
    
    if(velocita==0){
      vel=0;
      v=0;}
    
    
    
    //Faccio lo switch case
    //switch(val1){
    //  case 0:                                               //controllo accensione
    //  if(val2>0 && on==false && prec_val2>val2){            //    ACCENSIONE: se tengo premuto (cioè val2>0), il flag on è falso (cioè la pompa è spenta) e il valore prec di val2 è
    //    on=true;                                            //    più grande di quello attuale, on va true e la v è settata a 4, cioè valore intermedio
    //    v=6;
    //    velocita=60;
    //  } else if(val2>0 && on==true && prec_val2>val2){      //    SPEGNIMENTO:se tengo premuto (cioè val2>0), il flag on è vero (cioè la pompa è accesa) e il valore prec di val2 è
    //    on=false;                                           //    più grande di quello attuale, on va a false e v e precal2 diventano nulli--> pompa spenta
    //    v=0;  
    //    velocita=0;
    //    prec_val2=0;
    //    rotation=false;
    //  }
      
    //  if(val2>0)                                             //se tengo premuto, entro anche in questo if: precval2 è uguale a val2
    //  {
    //    prec_val2=val2;
    //  } else if(val2==0 && prec_val2==1){                    //se non premo e precval è 1 (caso iniziale), INCREMENTO precval
    //   prec_val2+=1; 
    //  }
    //  break;
      
      
      
    //  case 1:                                                //controllo SPEED -: vado giù di 2
    //  if(val2>0 && on==true && v>2 && prec_val4<val2){
    //    v-=2;
    //    velocita-=20;
    //  }
    //  if(val2>0 && on==true && v<-2 && v<0 && prec_val4<val2){
    //    v+=2;
    //    velocita-=20;
    //  }
    //  break;
      
    //  case 2:                                                   //controllo SPEED +: vado su di 2
    //  if(val2>0 && on==true && v<10 && v>0 && prec_val4<val2){
    //    v+=2;
    //    velocita+=20;
    //  }
    //  if(val2>0 && on==true && v>-10 && v<0 && prec_val4<val2){
    //    v-=2;
    //    velocita+=20;
    //  }
    //  break;
      
    //  case 3:                                                                       //controllo direzione
    //  if(val2>0 && on==true && rotation==false && prec_val3>val2){                  //se premo, la pompa è accesa e precval è più grande della seconda cifra
    //    rotation=true;
    //    v=-v;
    //  } else if(val2>0 && on==true && rotation==true && prec_val3>val2){
    //    rotation=false;
    //    v=-v;  
    //    prec_val3=0;
    //  }
      
    //  if(val2>0)
    //  {
    //    prec_val3=val2;
    //  } else if(val2==0 && prec_val3==1){
    //   prec_val3+=1; 
    //  }
    //  break;

    //}
    
    
    
// Costruisco la pompa:
  // cornice
  stroke(100, 85, 60);
  strokeWeight(8);
  //noFill();
  fill (150, 150, 90, 40);
  rect (width/2-360, height/2-320, 720, 400, 18);
  strokeWeight(0);
  noFill();
  
  // dispositivo
  int x,y;
  x=width/2+150;
  y=height/2-150+175;
  
  pompa(v,lt,ht,ls,hs);
//fine pompa

// Costruisco il bottone di RESET
  reset();
// fine RESET  


// Costruisco le spie
  int xs=480, ys=120, lsp=950, hsp=200; //dimensioni cornice delle spie
  spie(xs,ys,lsp,hsp,val1);
  
//Stampo valori
  pushMatrix();
     valori(width/2+450,height/2-250,150,200);
  popMatrix();
  
//Stampo i comandi
  fill(0);
  //strokeWeight(3);
  rect(45,210,220,220,10);
  fill(70,70,64,130);
  rect(50,215,210,210,8);
  textSize(40);
  fill(255);
  //textFont(f4);
  text("Gestures", 58, 260);
  text("Gestures", 59, 260);
  text("Gestures", 60, 260);
  String s = "- simple touch to switch between menu items\n\n- long touch to select the item";
  textFont(f);
  textSize(20);
  noFill();
  text(s,58,275,200,300);
  text(s,59,275,200,300);
  strokeWeight(0);
  for (int i=0; i<14; i++) {
    fill (255, 28-i);
    rect (52, 216, 205, 1*i,8);
  }

  
  } 
}

/////////////////////////////////////////////////////////////////////////////////////      POMPA 

void pompa(int v,int lt, int ht,int ls, int hs){
    // Tubi che scendono
    noStroke();
    fill(0, 0, 128);
    rect(width/2-150, height/2-150, 25, 200, 0, 0, 12, 12);
    fill(0, 0, 128);
    rect(width/2+125, height/2-150, 25, 200, 0, 0, 12, 12);
    
    // Serbatoi
    pushMatrix(); //Serbatoio destro
    int x,y;
      x=width/2+150;
      y=height/2-150+175;

      translate(x, y);
      
     //tubo
      noStroke();
      rect(-25,0,lt+25,ht, 12, 0, 0, 12);
      //serbatoio
      stroke(0);
      strokeWeight(5);
      beginShape(LINES);
      vertex(lt, 0);
      vertex(lt, -hs+ht);
      vertex(lt+ls, -hs+ht);
      vertex(lt+ls, ht);
      vertex(lt, ht);
      vertex(lt+ls, ht);
      strokeWeight(0);
      endShape();
    
     //Serbatoio destro: se v è positiva si riempie, negativa si svuota    
    if(v>0){
      if (i>-hs/2) { 
        rect(lt, i, ls, hs/8-i);
        i=i-1; 
      }else if (i==-hs/2) { 
        rect(lt, i, ls, ht-i);
      }
     }
     else if(v<0){
       if (i<0){
         rect(lt, i, ls, hs/8-i);
         i=i+1;
       }else if(i==0){ 
        rect(lt, i, ls, ht+i);
       }   
     }
      
    popMatrix();
    
    pushMatrix(); //Serbatoio sinistro
      x=width/2-150;
      y=height/2-150+175;
      translate(x, y);
       
     //tubo
     noStroke();
     rect(25,0,-lt-25,ht, 0, 12, 12, 0);
     //serbatoio
     stroke(0);
     strokeWeight(5);
     beginShape(LINES);
     vertex(-lt, 0);
     vertex(-lt, -hs+ht);
     vertex(-lt-ls, -hs+ht);
     vertex(-lt-ls, ht);
     vertex(-lt, ht);
     vertex(-lt-ls, ht);
     strokeWeight(0);
     endShape();
             
    //Serbatoio sinistro: se v è positiva si svuota, negativa si riempie
     if(v>0){
      if (j<0){ 
        rect(-lt, j, -ls, hs/8-j);
        j=j+1;
      }else if(j==0){  
        rect(-lt, j, -ls, ht+j);
       }
      }
    else if(v<0){
      if(j>-hs/2){ 
        rect(-lt, j, -ls, hs/8-j);
        j=j-1;
      }else if(j==-hs/2){ 
        rect(-lt, j, -ls, ht-j);
      }    
    }
    popMatrix();
    
    
    // I due cerchi
    stroke(0);
    strokeWeight(1);
    //fill(#B40000);
    fill(0);
    ellipse(width/2, height/2-150, 308, 308);
    fill(100);
    ellipse(width/2, height/2-150, 300, 300);
    strokeWeight(0);
    fill(127);
    ellipse(width/2, height/2-150, 250, 250);
    

    // Costruisco le pale
    fill(222);
    noStroke();
    // traslo origine delle coordinate
    x=width/2;
    y=height/2-150;
      
    beginShape();
      
      pushMatrix();
        arco(x,y); 
      popMatrix();
      
      //barra sotto
      fill(100);
      noStroke();
      arc(x, y, 300, 300, radians(0), radians(180), PIE);
      fill(127);
      noStroke();
      arc(x, y, 250, 250, radians(0), radians(180), PIE);
      fill(222);
      strokeWeight(0);
      
      pushMatrix();
        pale(x,y); 
      popMatrix();
      
    endShape();

    //cerchio al centro
    fill(0);
    ellipse(width/2, height/2-150, 50, 50);

}  
// Fine pompa


// Funzione che costruisce le 3 barre della pompa
void pale(int xo, int yo) {
    translate(xo, yo);
    
 // regolo velocità 
   if(velocita>0){
    vel+=v;
    rotate(radians(vel));
   }else if(velocita<0){
     vel-=abs(v);
     rotate(radians(vel));
   }
   
   if(velocita==0){
     //vel=0; //posizione iniziale delle pale: metti 30 per non far vedere il blu
    rotate(radians(0));
   }
   
// barra1 
  rotate(radians(120));
  beginShape(QUADS);
    vertex(-15, 0);
    vertex(15, 0);
    vertex(15, 150);
    vertex(-15, 150);
  endShape();
  
  // barra2
  rotate(radians(120));
  beginShape(QUADS);
    vertex(-15, 0);
    vertex(15, 0);
    vertex(15, 150);
    vertex(-15, 150);
  endShape();

  // barra3
  rotate(radians(120));
  beginShape(QUADS);
    vertex(-15, 0);
    vertex(15, 0);
    vertex(15, 150);
    vertex(-15, 150);
  endShape();

}

//parte sotto della pompa
void arco(int xo, int yo) {
  translate(xo, yo);
  rotate(radians(vel));
//arco in mezzo tra due pale
  beginShape();
  if(v!=0){
    fill(0, 0, 128, 200);
  }else if(v==0){
    fill(100);
  }
    arc(0, 0, 300, 300, -radians(25), radians(85), PIE);
    fill(127);
    arc(0, 0, 250, 250, -radians(25), radians(85), PIE);
    fill(222);
  endShape();
}

/////////////////////////////////////////////////////////////////////////////////////      INDICATORI DEL MENU
void spie(int x, int y, int ls, int hs, int val1){

  // cornice  
  fill (0);
  rect (width/2-x, height/2+y, ls, hs, 6);
  fill (165,174,138);
  rect (width/2-x+2, height/2+y+4, ls-4, hs-10, 5);
  for (int i=0; i<14; i++) {
    fill (255, 27-i);
    rect (width/2-x+4, height/2+y+8, ls-10, 1*i, 5);
  }
  
  // spie
    xi=width/2-x;
    yi=height/2+hs;
    l=40;
    h=25;
    
    
    // Device state
    pushMatrix();
      indicatore_stato(xi+80, yi+70, l, h);
    popMatrix();
    noFill();
    if (val1==0){
      fill(#FFFF00);
    }
    else
    {
      noFill();
    }

    stroke(255);
    rect(xi+l/2-7, yi-50, lb+10, hb, 8);
    fill(255);
    textFont(f);
    fill(0);
    text("Device state", xi+l/2, yi-5);


    xi=width/2-(x-350);
    yi=height/2+hs;

    // Speed
    pushMatrix();
      indicatore_velocita(xi-10, yi+70, l, h, v);
    popMatrix();
    noFill();
    
    if (val1==1){
      fill(#FFFF00);
    }
    else
    {
      noFill();
    }

    stroke(255);
    rect(xi+l/2, yi-50, lb/2+5, hb, 8);
    
    if (val1==2){
      fill(#FFFF00);
    }
    else
    {
      noFill();
    }
    
    rect(xi+l/2+120, yi-50, lb/2+5, hb, 8);
    fill(255);
    textFont(f);
    textSize(25);
    fill(0);
    text("Speed -", xi+l-15, yi-5);
    fill(255);
    textFont(f);
    textSize(25);
    fill(0);
    text("Speed +", xi+l+110, yi-5);
    
    
    xi=width/2+(x-210);
    yi=height/2+hs;

    // Direction
    pushMatrix();
      indicatore_direzione(xi+35, yi+70, l, h);
    popMatrix();
    noFill();
    stroke(255);

    if (val1==3){
      fill(#FFFF00);
    }
    else
    {
      noFill();
    }
    
    rect(xi+l/2-35, yi-50, lb+5, hb, 8);
    fill(255);
    textFont(f);
    textSize(35);
    fill(0);
    text("Direction", xi+l/2, yi-5);

}



void indicatore_stato(int x, int y, int l, int h){
      translate(x, y);
      fill(255);
      stroke(0);
      strokeWeight(2);
      if(v!=0){
        fill(0,255,0);
        rect(0,0, l, h);
        fill(255);
        rect(l,0, l, h);
      } else if(v==0){
        fill(255);
        rect(0,0, l, h);
        fill(255,0,0);
        rect(l,0, l, h);
      }
      strokeWeight(0);
}


void indicatore_velocita(int x, int y, int l, int h, int v){
      translate(x, y);
      fill(255);
      stroke(0);
      strokeWeight(2);

        if(v==2 || v==-2){
        fill(#ffa500);
        rect(0,0, l, h);
        fill(255);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      } else if(v==4 || v==-4){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        fill(255);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      } else if(v==6 || v==-6){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        fill(255);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      }else if(v==8 || v==-8){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        fill(255);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      }else if(v==10 || v==-10){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        fill(255);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      } else if(v==12 || v==-12){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        fill(255);
        rect(6*l,0, l, h);
      }else if(v==14 || v==-14){
        //fill(255);
        fill(#ffa500);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      }else if(v==0){
        fill(255);
        rect(0,0, l, h);
        rect(l,0, l, h);
        rect(2*l,0, l, h);
        rect(3*l,0, l, h);
        rect(4*l,0, l, h);
        rect(5*l,0, l, h);
        rect(6*l,0, l, h);
      }
      
      strokeWeight(0);
}


void indicatore_direzione(int x, int y, int l, int h){
      translate(x, y);
      fill(255);
      stroke(0);
      strokeWeight(2);
      
      if(rotation==1 && v!=0){
        fill(#4682b4);
        rect(0,0, l, h);
        fill(255);
        rect(l,0, l, h);
      } else if(rotation==-1 && v!=0){
        fill(255);
        rect(0,0, l, h);
        fill(#4682b4);
        rect(l,0, l, h);
      } else if(v==0){
        fill(255);
        rect(0,0, l, h);
        rect(l,0, l, h);
      }
      fill(0);
      textFont(f3);
      //text(orario, l/8+3, h/2+9);
      text("Z", l/8+3, h/2+11);
      //text(antiorario, l+l/4-4, h/2+9);
      text("Y", l+l/4-4, h/2+11);
      strokeWeight(0);
}

/////////////////////////////////////////////////////////////////////////////////////      RESET
void reset(){
  fill (100, 85, 60);
  rect (29, 34, 225, 86, 18);
  for (int i=0; i<35; i++) {
    fill(42, 42, 0, 27-i);
    rect (29, 34, 225, i+36, 18);
  } 
  fill (0);
  rect (51, 44, 182, 67, 11);
  
  // se ci sono sopra
   if (rectOver) {
    fill (172, 0, 0);
    rect (58, 49, 168, 59, 7);
   } else {
    fill (255, 0, 0);
    rect (53, 47, 178, 61, 7);
    }
    
    textFont(f4);
    textSize(35);
     fill(255, 255, 255);
    text ("RESET", 90, 92);
    fill(255, 115, 119);
    text ("RESET", 92, 92);
    textFont(f);
    
    for (int i=0; i<11; i++) {
      fill (255, 40-i);
      rect (56, 51, 172, 2*i, 5);
    }
    for (int i =0; i<30;i++) {
      fill(22, 22, 0, 27-i);
      rect (52, 112, 181, i-10, 18);
    }
}


//Cicli per il pulsante
//Se ho il mouse sopra il bottone, diventa vera anche rectOver
void update(int x, int y) {
  if(overRect(xb2, yb2, lb2, hb2)) {
    rectOver = true;
  }
}

//Se schiaccio il bottone, esce un quadrato rosso
void mousePressed() {
  if(rectOver){
     fill (90, 90, 50);
      rect (29, 34, 225, 86, 18);
      for (int i=0; i<35; i++) {
        fill(42, 42, 0, 27-i);
        rect (29, 34, 225, i+36, 18);
      } 
      fill (0);
      rect (51, 44, 182, 67, 11);    
    
      fill (172, 0, 0);
      rect (63, 47, 158, 56, 7);
      textSize(35);
       fill(255, 255, 255);
      text ("RESET", 100, 92);
      fill(255, 0,0);
      text ("RESET", 101, 92);
      for (int i=0; i<11; i++) {
        fill (255, 40-i);
        rect (66, 51, 152, 2*i, 5);
      }
      for (int i =0; i<30;i++) {
        fill(22, 22, 0, 27-i);
        rect (62, 112, 161, i-10, 18);
      }
    
    // Comunicazione Arduino
      myPort.write("Reset");
      println("Reset");
      //Il tasto RESET ripristina velocità a 4 e rotazione CW
      if(v!= 0){ 
      //on=1;
      //rotation=false;
      rotation=+1;
      v=8;
      velocita=160;
      }
  }

}

//Inizializzo una booleana overRect che diventa vera se il mouse sta sopra il bottone
boolean overRect(int xb2, int yb2, int lb2, int hb2)  {
  rectOver=false;
  if (mouseX >= xb2 && mouseX <= xb2+lb2 && 
      mouseY >= yb2 && mouseY <= yb2+hb2) {
    return true;
  } else {
    return false;
  }
}


/////////////////////////////////////////////////////////////////////////////////////      VALORI CORRENTI
//Stampo gli indici
void valori(int x, int y, int l, int h){
      translate(x, y);
      
      stroke(#808080);
      //fill(105);
      fill(#F2F2F2);
      rect(-5,-5, l+10, h+10);
      fill(0, 0, 128, 50);
      rect(0,0, l, h);
      
      //Print on/off
      rect(5,10,l-10,50);
      if(velocita!=0){
        textSize(35);
        textFont(f2);
        fill(#008000);
        text("ON", l/2-15,45);
      } else if (velocita==0){
        textFont(f2);
        fill(#FF0000);
        text("OFF", l/2-20,45);
      }
      
      //Print the speed
      fill(0, 0, 128, 50);
      rect(5, 75,l-10,50);
      fill(#008000);
      textFont(f2);
      text(velocita, l/2-15, 115);
          
      //Print direction
      fill(0, 0, 128, 50);
      rect(5,140,l-10,50);
      if(v>0){
        textSize(35);
        textFont(f2);
        fill(#008000);
        text("CW", l/2-15,180);
      } else if(v<0){
        textSize(35);
        textFont(f2);
        fill(#008000);
        text("CCW", l/2-20, 180);
      }
      
      
      fill(0);
      textSize(35);
      textFont(f);
      text("Current Values", -20, -20); 
}
