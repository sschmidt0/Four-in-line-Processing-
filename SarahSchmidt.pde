// importem la biblioteca ControlP5
import controlP5.*;

/*
 * Fitxer principal del programa
 * Des d'aquí es controla el flux general d'execució i es faran les crides a les funcions auxiliars 
 */
 
/*
 * Aquí declarem tots els objectes i variables globals que necessitem
 */
// Variable per accedir a controlP5
ControlP5 cp5;

// Variables tauler
int[][] tauler;
int files;
int columnes;
int midaCaselles;
int columnaSeleccionada;

// Variables fitxes
int[] fitxesJugador;
int[] fitxesOrdinador;
int quantitatFitxes;
int jugMenys;
int ordMenys;

// Variables posicionar fitxes
int posicioX; 
int posicioY;
int casella;

// Variables estats/frames
int frame;

// Variables temps
int time_now;
int time_old;
int time_delta;
float comptador;

// Variable jugador actiu: 0 = jugador, 1 = ordinador
int jugadorActiu;

// Variables per controlar joc
boolean seguir;
boolean fitxaPosicionada;
boolean columnaPlena;

// Variables per canviar la font
PFont font;

// Variables per l'animació de la fitxa
float incr;
int animacioColumna;
boolean animacio;

/*
 * Funció d'inicialització
 * Aquí es definirà l'entorn inicial i s'inicialitzarà totes les variables necessaries
 * Aquesta funció s'executa una vegada just al iniciar-se el programa
 */
void setup() {
  size(800, 600);
  background(255, 255, 255);
  stroke(0, 0, 0);
  frameRate(32);
  
  // initzialitzar variable control P5 i afegir botons
  cp5 = new ControlP5(this);
  
  cp5.addButton("JUGAR")
                .setValue(0)
                .setPosition(width - 120, 20)
                .setSize(100, 50);
  
  cp5.addButton("SORTIR")
                .setValue(0)
                .setPosition(width - 120, 80)
                .setSize(100, 50);
  
  // inicialització de les variables
    // Variables tauler  
    midaCaselles = 1;
    // Variables fitxes
    quantitatFitxes = (files * columnes) / 2;
    fitxesJugador = new int[quantitatFitxes];
    fitxesOrdinador = new int[quantitatFitxes];
    jugMenys = 1;
    ordMenys = 0;
    // Variables posicionar fitxes
    posicioX = 600;
    posicioY = 230;
    // Variables estats/frames i temps
    frame = 1;
    time_now = 0;
    time_delta = 0;
    time_old = 0;
    comptador = 0.0;
    // Variable jugador actiu
    jugadorActiu = 1;
    // Variables per controlar joc
    fitxaPosicionada = false;
    columnaPlena = false;
    // Variables per canviar la font
    font = loadFont("SignPainter80.vlw");
    textFont(font);
    // Variables per l'animació de la fitxa
    animacio = false;
    incr=1;
}

/*
 * Funció de repintat / actualització de la pantalla
 */
void draw() {
  fill(230, 230, 230);
  stroke(0, 0, 0);

  switch (frame) {
    case 1: 
      inici();
      // clock() perquè comenci a calcular el temps d'execució
      clock();
      dibuixarTauler();

      // per controlar el temps des de l'inicialització del programa
      //perquè després d'haver dibuixat el tauler (després de 13 ms) canviï de frame
      if (comptador > 13) {
        frame = 2;
        comptador = 0.0;
      }
      break;
    case 2: 
      // clock() perquè comenci a calcular el temps d'execució
      clock();
      dibuixarFitxes(0); 
      dibuixarFitxes(1);

      // perquè després d'haver dibuixat les fitxes (després de 32 ms) canviï de frame
      if (comptador > 32) {
        frame = 3;
      }
      break;
    case 3:
      imprimirTitol();
      if (seguir) {
        frame = 4;
        comptador = 0.0;
      }
      break;
    case 4:
      joc();
      break;
  }
}

// ************************************************************ CONTROL EVENTS ********************************************************************************
// ************ funció per controlar els events dels botons ************
void controlEvent(ControlEvent theEvent) {
  if (theEvent.getController().getName().equals("JUGAR")) {
    // quan apretem el botó "jugar" començem el joc
    seguir = true;
  }
  
  if (theEvent.getController().getName().equals("SORTIR")) {
    // quan apretem el boto "sortir" seguir agafa el valor false, en la funció mousePressed llavors podem cridar exit()
    seguir = false;
  }
}

// ************************************************************ PRÀCTICA 1 ************************************************************************************
// ************ funció clock per determinar el temps d'execució de diferents funcions en loop for ************
void clock() {
  time_now = millis();
  time_delta = time_now - time_old;
  time_old = time_now;
  // per regular la velocitat de dibuixar cada una de les fitxes
  comptador += (time_delta / 200.0);
}

// ************ funció que dibuixa el tauler ************
void dibuixarTauler() {
  // condició fins on es poden extendre les caselles i amb això el tauler
  if (midaCaselles <= 60) {
    background(255, 255, 255);
    // dibuixar el tauler 8x8
    for (int x = 0; x < files; x++) {
      for (int y = 0; y < columnes; y++) {
        rect(x * midaCaselles + 30, y * midaCaselles + 90, midaCaselles, midaCaselles);
      }
    }
    // perquè es facin més grans les caselles i amb això tot el tauler
    midaCaselles++;
  }
}

// ************ funció que dibuixa les fitxes del jugador / de l'ordinador ************
void dibuixarFitxes(int bloc) {
  // per diferenciar entre el bloc de fitxes del jugador i el de l'ordinador: canvia color i posició horitzontal
  if (bloc == 0) {
    fill(255, 0, 0);
    posicioX = 600;
  } else {
    fill(0, 0, 255);
    posicioX = 680;
  }
  // dibuixar les 32 fitxes per a cada jugador
  // mentre que comptador sigui menor a la longitud de l'array, o sigui perquè pari després d'haver dibuixat 32 fitxes
  if (comptador < fitxesJugador.length) {
    for (int i = 0; i < comptador; i++) {
      ellipse(posicioX, 10 * i + 230, midaCaselles - 4, midaCaselles - 4);
    }
  }
}

// ************ funció que imprimeix el títol i pregunta jugar o sortir ************
void imprimirTitol() {
  fill(0, 0, 0);
  textSize(180);
  text("4 in line", 60, height / 2 + 40);
}

// ************************************************************ MOUSE PRESSED ********************************************************************************
// ************ funció que controla quan fem click amb el ratolí ************
void mousePressed() {
  // quan apretem el boto "jugar"
  if (seguir) {  
    casellaLliura(); 
    animacioColumna = columnaSeleccionada;
    animacio = true;
  }
  // quan apretem el boto "sortir" seguir agafa el valor false i sortim
  // HI HA UNA INTERFERÈNCIA QUE NO EM PUC EXPLICAR, NO PUC POSAR EXIT() PERQUÈ ES TANCA EL JOC EN APRETAR QUALSEVOL BOTÓ. PER AIXÒ UTILITZO EL mouseX I mouseY
  //if (seguir == false) {
    //exit();
  //}
  if ((mouseX >= 680 && mouseX <= 780) && (mouseY >= 82 && mouseY <= 132)) {
    exit();
  }
}


// ************************************************************ PRÀCTICA 2 ************************************************************************************
// ************ funció que dibuixa el tauler i les fitxes sense animació ************
void taulerIFitxes() {
  midaCaselles = 60;
  background(255, 255, 255);
  
  // dibuixar el tauler fila * columna (8x8)
  for (int x = 0; x < files; x++) {
    for (int y = 0; y < columnes; y++) {
      // casella amb fitxa de jugador
      if (tauler[x][y] == 1) {
        fill(255, 0, 0);
        ellipse(x * midaCaselles + 60, y * midaCaselles + 120, midaCaselles - 4, midaCaselles - 4); 
      }
      // casella amb fitxa de l'ordinador
      if (tauler[x][y] == 2) {
        fill(0, 0, 255);
        ellipse(x * midaCaselles + 60, y * midaCaselles + 120, midaCaselles - 4, midaCaselles - 4);  
      }
      // casella buida
      noFill();
      rect(x * midaCaselles + 30, y * midaCaselles + 90, midaCaselles, midaCaselles);
    }
  }
  // perquè desapareixi l'última fitxa de la pila de fitxes del jugador actiu
  if (columnaPlena == false) {
    if (jugadorActiu == 1) {
      jugMenys = 1;
      ordMenys = 0;
    } else {
      jugMenys = 0;
      ordMenys = 1;
    }
  }
  // dibuixar les fitxes del jugador
  fill(255, 0, 0);
  posicioX = 600;
  // mentre que comptador sigui menor a la longitud de l'array, o sigui perquè pari després d'haver dibuixat 32 fitxes
  for (int i = 0; i < fitxesJugador.length - jugMenys; i++) {
    ellipse(posicioX, 10 * i + 230, midaCaselles - 4, midaCaselles - 4);
  }
  //dibuixar les fitxes de l'ordinador
  fill(0, 0, 255);
  posicioX = 680;
  // mentre que comptador sigui menor a la longitud de l'array, o sigui perquè pari després d'haver dibuixat 32 fitxes
  for (int i = 0; i < fitxesOrdinador.length - ordMenys; i++) {
   ellipse(posicioX, 10 * i + 230, midaCaselles - 4, midaCaselles - 4);
  }
}

// ************ funció que dibuixa la fitxa activa sobre el tauler ************
void fitxaSobreTauler() {
  // color segons jugador actiu
  if (jugadorActiu == 1) {
    fill(255, 0, 0);
  }  else {
    fill(0, 0, 255);
  } 
  // actualitzar columna
  columnaSeleccionada = determinarColumna();
  ellipse(midaCaselles * columnaSeleccionada, midaCaselles, midaCaselles - 4, midaCaselles - 4);
}

// ************ funció que determinar columna segons la posició X del ratolí ************
int determinarColumna() {
  if (mouseX > 30 && mouseX < (30 + midaCaselles)) {
    return 1;
  } 
  if (mouseX >= (30 + midaCaselles) && mouseX < (30 + midaCaselles * 2)) {
    return 2;
  } 
  if (mouseX >= (30 + midaCaselles * 2) && mouseX < (30 + midaCaselles * 3)) {
    return 3;
  } 
  if (mouseX >= (30 + midaCaselles * 3) && mouseX < (30 + midaCaselles * 4)) {
    return 4;
  } 
  if (mouseX >= (30 + midaCaselles * 4) && mouseX < (30 + midaCaselles * 5)) {
    return 5;
  } 
  if (mouseX >= (30 + midaCaselles * 5) && mouseX < (30 + midaCaselles * 6)) {
    return 6;
  } 
  if (mouseX >= (30 + midaCaselles * 6) && mouseX <= (30 + midaCaselles * 7)) {
    return 7;
  } else {
    return 8;
  }
}

// ************ funció que cerca la pròxima casella lliura i actualitza el tauler ************
void casellaLliura() {
  for (int i = files - 1; i >= 0; i--) {
    if (tauler[columnaSeleccionada - 1][i] == 0) {
      casella = i + 1;
      columnaPlena = false;
      break;
    }
    if (tauler[columnaSeleccionada - 1][0] != 0) {
      columnaPlena = true;
    }
  }
}

void casellaAnimacio() {
  if (animacio == true) {
    ellipse(midaCaselles * animacioColumna, midaCaselles * incr, midaCaselles - 4, midaCaselles - 4);
    incr = incr + 0.5;
    // quan arribem al final de l'animació
    if(incr >= casella + 1) {
      tauler[columnaSeleccionada - 1][casella - 1] = jugadorActiu;
      incr = 1;
      animacio = false;
      canviarJugador();
    }
  }
}

// ************ funció que activa el següent jugador ************
void canviarJugador() {
  if (columnaPlena == false) {
    // actualitzar jugador i quantitat fitxes
    if (jugadorActiu == 1) {
      jugadorActiu = 2;
      fitxesJugador = shorten(fitxesJugador);
    } else {
      jugadorActiu = 1;
      fitxesOrdinador = shorten(fitxesOrdinador);
    }
    casella = 0;
  }
}

// ************ funció que comprova la quantitat de fitxes que queden ************
void quantitatFitxes() { 
  if (fitxesJugador.length == 0 && fitxesOrdinador.length == 0) {
    background(255, 255, 255);
    inici();
    frame = 3;
  }
}

// ************ funció que inclou les altres funcions pròpies del joc ************
void joc() {
  clock();
  taulerIFitxes();
  fitxaSobreTauler();
  casellaAnimacio();
  comprovarGuanyador();
  quantitatFitxes();    
}

// ************ funció que comprova si hi ha un guanyador ************
void comprovarGuanyador() {
  // bucle per analitzar si hi ha quatre en línia en una columna
  for (int i = 0; i < files; i++) {
    for (int j = 0; j < columnes; j++) {
      if (i + 3 < files) {
        if (tauler[i][j] != 0 && tauler[i][j] == tauler[i + 1][j] && tauler[i][j] == tauler[i + 2][j] && tauler[i][j] == tauler[i + 3][j]) {
          imprimirGuanyador();
        }
      }
    }
  }
  // bucle per analitzar si hi ha quatre en línia en una fila
  for (int i = 0; i < files; i++) {
    for (int j = 0; j < columnes; j++) {
      if (j + 3 < columnes) {
        if (tauler[i][j] != 0 && tauler[i][j] == tauler[i][j + 1] && tauler[i][j] == tauler[i][j + 2] && tauler[i][j] == tauler[i][j + 3]) { 
          imprimirGuanyador();
        }
      }
    }
  }
  // bucle per analitzar si hi ha quatre en línia en la diagonal amunt/esquerra - avall/dreta
  for (int i = 0; i < files; i++) {
    for (int j = 0; j < columnes; j++) {
      if (i <= 4 && j <= 4) {
        if (tauler[i][j] != 0 && tauler[i][j] == tauler[i + 1][j + 1] && tauler[i][j] == tauler[i + 2][j + 2] && tauler[i][j] == tauler[i + 3][j + 3]) {
          imprimirGuanyador();
        }
      }
    }
  }
  // bucle per analitzar si hi ha quatre en línia en la diagonal avall/esquerra - amunt/dreta
  for (int i = 0; i < files; i++) {
    for (int j = 0; j < columnes; j++) {
      if (i >= 3 && j <= 4) {
        if (tauler[i][j] != 0 && tauler[i][j] == tauler[i - 1][j + 1] && tauler[i][j] == tauler[i - 2][j + 2] && tauler[i][j] == tauler[i - 3][j + 3]) {
          imprimirGuanyador();
        }
      }
    }
  }
}

// ************ funció que imprimeix al guanyador ************
void imprimirGuanyador() {
  // preparar temps de duració
  clock();
  comptador = 0.0;
  // imprimir el text
  background(255, 255, 255);
  fill(0, 0, 0);
  textSize(80);
  text("Felicitats, has guanyat!!", 70, height / 2); 
}

// ************ funció que (re)inicia els valors ************
void inici() {
  // (re)iniciar tauler a 0, treure les fitxes de l'array
  files = 8;
  columnes = 8;
  tauler = new int[files][columnes];
  // omplir caselles amb 0
  for (int i = 0; i < files; i++) {
    for (int j = 0; j < columnes; j++) {
      tauler[i][j] = 0;
    }
  }
  // valors inicials importants per al joc
  columnaSeleccionada = 8;
  jugadorActiu = 1;
  columnaPlena = false;
  seguir = false;
  // (re)iniciar els arrays de les fitxes
  quantitatFitxes = (files * columnes) / 2;
  fitxesJugador = new int[quantitatFitxes];
  fitxesOrdinador = new int[quantitatFitxes];
}
