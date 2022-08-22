import processing.dxf.*;
import peasy.*;
import peasy.PeasyCam;
import processing.opengl.PGL;
import processing.opengl.PGraphics3D;
import processing.opengl.PJOGL;

Datos datos;
Mapa[] mapas = new Mapa[2];

int cantMapas = 1;
int separacion = 2;
String archivo_de_referencia = "datos.csv";
PFont f;

PeasyCam c;
String[] sett;

PGraphics icong;
boolean piramide =false;
boolean rect = false;
boolean proyec= true;
boolean record = false;

void settings() {
  fullScreen(P3D, 2);
  PJOGL.setIcon("C3D.png");
  smooth();
}

void arreglarCam() {
  c.setViewport(0, 0, width, height);
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();
  pg.endPGL();
  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (0, 0, width, height);
  pgl.viewport(0, 0, width, height);
  c.feed();
  perspective(60 * PI/180, width/(float)height, 1, 5000);
}

void mouseReleased() {
  if (mostrarTut) {
    mostrarTut = false;
    lista_datos.open();
  }
}

void camaraInterfaz() {
  c = new PeasyCam(this, 0);
  arreglarCam();
  c.setActive(false);
}

void instanciarDatos() {
  if (datos == null) {
    datos = new Datos(archivo_de_referencia);
  }
}

void instanciarFuente() {
  f = createFont("georgia.ttf", 48, true);
}

void instanciarMapas() {
  String ruta = "argentina_map_simple_expandido_V1.svg";
  for (int i = 0; i < cantMapas; i++) {
    if (mapas[i] == null) {
      mapas[i] = new Mapa(ruta, this, i * (separacion+width/2), 0, (width / cantMapas - (separacion * (i))), height);
      if (mapas[i] == mapas[1]) {
        mapas[1].cambiarDatos(ruta);
      }
    } else {
      mapas[i].setCam(i * (separacion+width/2), 0, (width / cantMapas - (separacion * (i))), height);
      //mapas[i].renovarDatos();
      mapas[i].cambiarDatos(ruta);

    }
  }
}

void limpiarPantalla() {
  setGLGraphicsViewport(0, 0, width, height);
  background(0);
}

void dibujarPrograma() {
  for (int i = 0; i < cantMapas; i++) {
    pushMatrix();
    mapas[i].dibujar();
    arreglarCam();
    dibujarInterfaz();
    popMatrix();
  }
}

void desactivarCamara() {
  if (cp5.isMouseOver()) {
    for (int i = 0; i < cantMapas; i++) {
      mapas[i].cam.setActive(false);
    }
  } else {
    for (int i = 0; i < cantMapas; i++) {
      mapas[i].cam.setActive(true);
    }
  }
}

void setGLGraphicsViewport(int x, int y, int w, int h) {
  PGraphics3D pg = (PGraphics3D) this.g;
  PJOGL pgl = (PJOGL) pg.beginPGL();
  pg.endPGL();
  pgl.enable(PGL.SCISSOR_TEST);
  pgl.scissor (x, y, w, h);
  pgl.viewport(x, y, w, h);
}

//Datos
class Datos {

  String[] valores;
  String[] linea;
  String[][] data;

  String [] provincias = {"caba-big", "buenos-aires", "catamarca", "chaco", 
    "chubut", "cordoba", "corrientes", "entre-rios", 
    "formosa", "jujuy", "la-pampa", "la-rioja", 
    "mendoza", "misiones", "neuquen", "rio-negro", 
    "salta", "san-juan", "san-luis", "santa-cruz", 
    "santa-fe", "santiago-del-estero", "tierra-del-fuego", 
    "tucuman"};
    
  float[] poblacion;

  float maxPoblacion; //= 15625084; //BsAs.
  float minPoblacion; //= 127205; // Tierra del Fuego
  
  int cantDatosNuevos = 0;
  int cantDatosEco = 9;

  Datos(String s) {
    linea = loadStrings(s);
    agregarArchivo();
    crearDatos();
    poblacion = new float[data.length-1];
  }
  
  void agregarArchivo() {
    String archivo2 = "nuevosdatos.csv";
    String[] l = loadStrings(archivo2);
    cantDatosNuevos = l.length;
   for (int i = 0; i < cantDatosNuevos; i++) {
      valores = split (l[i], ';');
      for (int j = 0; j < valores.length; j++) {
        linea[j] = linea[j]+';'+valores[j]; 
      }
    }
  }
  
  void renovarDatos(int SELECCION) {
    getPoblacion(SELECCION);
  }

  void crearDatos() {
    valores = split (linea[0], ';');
    
    data = new String[linea.length][valores.length];

    //Cantidad de filas encontradas en el archivo
    for (int i = 0; i < linea.length; i++) {
      valores = split (linea[i], ';');

      //Cantidad de columnas que tiene el archivo
      for (int j = 0; j < valores.length; j++) {
        data[i][j] = valores[j];
      }
    }
  }
  
  void getPoblacion(int SELECCION) {
    for (int i = 1; i < data.length; i++) {
      String s = data[i][SELECCION].replace(",", ".");
      poblacion[i-1] = float(s); 
    }
  }
  
  void setMaximo(int seleccion) {
    float segundoMax = 0;
    float acum = 0;
    switch (seleccion) {
      
      case 0: //Valor por defecto donde maximo equivale a la provincia con dato maximo
      for (int i = 0; i < poblacion.length; i++) {
        if (i == 0 || maxPoblacion < poblacion[i]) {
          maxPoblacion = poblacion[i];
        }
      }
      break;
      
      case 1: //Donde la provincia maxima es igual al segundo maximo
      segundoMax = minPoblacion;
      for (int i = 0; i < poblacion.length; i++) {
        if (maxPoblacion != poblacion[i] && segundoMax < poblacion[i] ) {
          segundoMax = poblacion[i];
        }
      }
      maxPoblacion = segundoMax;
      break;
      
      case 2: 

      for (int i = 0; i < poblacion.length; i++) {
        acum += poblacion[i];
      }
      acum = acum / poblacion.length;
      maxPoblacion = acum;
      break;
      
      default:
      break;
    }

  }
  
  void setMinimo(int selector) {
    switch (selector) {
      case 0:
      for (int i = 0; i < poblacion.length; i++) {
        if (i == 0 || minPoblacion > poblacion[i]) {
          minPoblacion = poblacion[i];
        }
      }
      break;
      
      case 1:
      break;
      
      case 2: 
        minPoblacion = 0;
      break;
      
      default:
      
      break;
    }
  }

  void getMaximo() {
    for (int i = 0; i < poblacion.length; i++) {
      if (i == 0 || maxPoblacion < poblacion[i]) {
        maxPoblacion = poblacion[i];
      }
    }
  }

  void getMinimo() {
    for (int i = 0; i < poblacion.length; i++) {
      if (i == 0 || minPoblacion > poblacion[i]) {
        minPoblacion = poblacion[i];
      }
    }
  }
}


//GUI
import controlP5.*;
import java.util.*;

ControlP5 cp5;
String busq = "";
boolean mostrarTut = true;
boolean auto_rotar = true;
PImage t1, t2, t3, t4, t5, t6, t7, nota;

//Boton guardar mapa
Button guardarMapa;
//boton rotar automatica
Button rotar_auto;
//Boton ocultar Datos
Button ocultar_datos;
//Lista de formatos 3D
DropdownList lista_3d;
//Lista de datos estadisticos
ScrollableList lista_datos;
//Seleccion de maximo / minimo a mostrar
ScrollableList opcionesMapa;
//Guardar y cargar estados de camara
ScrollableList estadosCam;
//CheckBox modo dos mapas
CheckBox m2m/*, autoHideUI*/;
Button autoHideUI;
//campo de busqueda
Textfield campoBusqueda;
//Boton de area de texto
Button ord_datos;

int padd_entre_op = 12;
boolean escondido = false;
String ordenLog = "default";
boolean esconderPresionado = false;
Textarea textoMap1, textoMap2;
String log = "Datos del censo 2010 y otros documentos de organismos nacionales (mismo año)";

PFont pfont;
ControlFont font;

void setupGUI() {

  pfont = createFont("times.ttf", 9, true);
  font = new ControlFont(pfont);

  if (cp5 == null) {
    cp5 = new ControlP5(this);
    cp5.setAutoDraw(false);
    cargarTutorial();
    crearInterfaz();
  }
}

void cargarTutorial() {
  t1 = loadImage("Tutorial/T1.png");
  t2 = loadImage("Tutorial/T2.png");
  t3 = loadImage("Tutorial/T3.png");
  t4 = loadImage("Tutorial/T4.png");
  t5 = loadImage("Tutorial/T5.png");
  t6 = loadImage("Tutorial/T6.png");
  t7 = loadImage("Tutorial/T7.png");
  nota = loadImage("Tutorial/nota.png");

  if (t1 == null || t2 == null || t3 == null || t4 == null || t5 == null || t6 == null || t7 == null || nota == null) {
    mostrarTut = false;
  }
}

void crearInterfaz() {
  guardarMapa = cp5.addButton("Guardar Mapa")
    .setPosition(width*0.88, height*0.925)
    .setSize(70, 30)
    .setLabel("Guardar Mapa")
    ;

  ocultar_datos = cp5.addButton("Ocultar")
    .setPosition(width-220 - 10 + 200 - 50, height*0.2 + 5 + 385)
    .setSize(50, 25)
    .setLabel("Ocultar")
    ;

  lista_datos = cp5.addScrollableList("Lista de datos estadisticos")
    .setFont(font)
    .setPosition(padd_entre_op, 0)
    .setBarHeight(35)
    .setItemHeight(35)
    .setColorBackground(color(60))
    .setColorActive(color(255, 128))
    .close()
    ;
  crearDatos();

  pushStyle();
  font.setSize(16);
  campoBusqueda = cp5.addTextfield("")
    .setPosition(padd_entre_op , height - 30 - 20)
    .setSize(200, 30)
    .setFont(font)
    .setColor(225)
    .setColorLabel(30)
    .setAutoClear(false)
    .setText("Ingrese busqueda...")
    ;
    font.setSize(12);
  popStyle();

  lista_3d = cp5.addDropdownList("Formatos 3D")
    .setPosition(lista_datos.getWidth() + padd_entre_op * 2, 0)
    .setSize(80, 150) //100
    .setBackgroundColor(color(190, 190, 0))
    .setItemHeight(35)//20
    .setBarHeight(35)//15
    .addItem("Estilo 3D_ARG", 0)
    .addItem("Estilo Recto", 1)
    .addItem("Estilo Puntual", 2)
    .setColorBackground(color(60))
    .setColorActive(color(255, 128))
    .close()
    ;

  textoMap1 = cp5.addTextarea("Datos 1")
    .setPosition(width-220, height*0.2)
    .setSize(200, 385)
    .setFont(createFont("arial", 12))
    .setLineHeight(14)
    .setColor(color(128))
    .setColorBackground(color(255, 100))
    .setColorForeground(color(255, 100))
    .setBorderColor(54);
  textoMap1.setText(log);

  textoMap2 = cp5.addTextarea("Datos 2")
    .setPosition(width-220, height*0.2)
    .setSize(200, 385)
    .setFont(createFont("arial", 12))
    .setLineHeight(14)
    .setColor(color(128))
    .setColorBackground(color(255, 100))
    .setColorForeground(color(255, 100));
  textoMap2.setText(log);
  textoMap2.hide();

  m2m = cp5.addCheckBox("m2m")
    .setPosition(lista_datos.getWidth()+lista_3d.getWidth() + padd_entre_op * 3, 7)
    .setSize(25, 25)
    .setColorLabel(0)
    .addItem("Modo dos mapas", 0)
    ;

  autoHideUI = cp5.addButton("autoHideUI")
    .setPosition(width - padd_entre_op - 50, 5)
    .setSize(50, 30)
    .setLabel("Esconder")
    ;

  rotar_auto = cp5.addButton("Rotar")
    .setPosition(width - padd_entre_op - autoHideUI.getWidth() - padd_entre_op - 50, 5)
    .setSize(50, 30)
    .setLabel("Rotar")
    ;

  opcionesMapa = cp5.addScrollableList("Opciones de zoom")
    .setPosition(lista_datos.getWidth()+lista_3d.getWidth() + m2m.getWidth() + 90 + padd_entre_op * 4, 0)
    .setSize(260, 250) //300
    .setBackgroundColor(color(190, 190, 0))
    .setItemHeight(35)//20
    .setBarHeight(35)//15
    .addItem("Valor max.: provincia con valor mas alto", 0)
    .addItem("Valor max.: segunda provincia con valor mas alto", 1)
    .addItem("Valor max.: el valor promedio de los valores", 2)
    .addItem("Valor min.: provincia con valor mas bajo", 3)
    .addItem("Valor min.: usar 0 como minimo", 4)
    .setColorBackground(color(60))
    .close()
    .setColorActive(color(255, 128));

  estadosCam = cp5.addScrollableList("Estados de camara")
    .setPosition(lista_datos.getWidth()+lista_3d.getWidth() + m2m.getWidth() + 90 + opcionesMapa.getWidth() + padd_entre_op * 5, 0)
    .setSize(200, 200)
    .setBackgroundColor(color(190, 190, 0))
    .setItemHeight(35)//20
    .setBarHeight(35)//15
    .addItem("Guardar el estado de camara actual", 0)
    .addItem("Volver el estado al valor guardado", 1)
    .setColorBackground(color(60))
    .close()
    .setColorActive(color(255, 128));

    //Callback listener para campo busqueda
    campoBusqueda.onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        campoBusqueda.setText("");
      }
    });
}

void mostrarTutorial() {
  image(t1, padd_entre_op-10, lista_datos.getBarHeight()-10); // Menos diametro/2 (d = 20)
  image(t2, lista_datos.getWidth() + padd_entre_op * 2 + 10 - t2.width, lista_datos.getBarHeight()-10); // Menos diametro/2 (d = 20)
  image(t3, lista_datos.getWidth()+lista_3d.getWidth() + m2m.getWidth() + 90 + padd_entre_op * 4 - 10, lista_datos.getBarHeight()-10); // Menos diametro/2 (d = 20)
  image(t4, width - padd_entre_op - 130 + 10 - t4.width, 7 + autoHideUI.getHeight() ); // Menos diametro/2 (d = 20)
  image(t5, width-220 + 10 - t5.width, height*0.2 + textoMap1.getHeight() - 10); // Menos diametro/2 (d = 20)
  image(t6, width*0.88 + 10 - t6.width, height*0.925 + guardarMapa.getHeight() - 10 - 10 -t6.height); // Menos diametro/2 (d = 20)
  image(t7, padd_entre_op, height-10-t7.height);
  image(nota, width*0.2, height/2);
}

void crearDatos() {
  lista_datos.setBarHeight(35);
  lista_datos.setItemHeight(35);
  int tam = 0;
  String s;
  for (int i = 1; i < datos.data[0].length; i++) {
    s = datos.data[0][i];
    s = s.toLowerCase();
    s.replace('é', 'e');
    s.replace('í', 'i');
    s.replace('ó', 'o');
    s.replace('ú', 'u');
    s.replace('á', 'a');
    s.replace('ü', 'u');

    String[] resul = match(s, busq);
    if (resul != null || busq == "") {

      lista_datos.addItem(s, i);
      if (datos.data[0].length <= i + datos.cantDatosNuevos) {
        CColor c = new CColor();
        lista_datos.getItem(i-1).put("color", c);
      } else if (i + datos.cantDatosEco >= datos.data[0].length - datos.cantDatosNuevos) {
        CColor c = new CColor();
        color w = color(91, 219, 100);
        c.setBackground(w);
        lista_datos.getItem(i-1).put("color", c);
      }
      tam++;
    }
  }
  if (lista_datos.getBarHeight() + 35 * tam + 1 * tam < height - lista_datos.getBarHeight() - 5) {
    lista_datos.setSize(420, int(lista_datos.getBarHeight() + 35 * tam + 1 * tam)); //350
  } else {
    lista_datos.setSize(420, height-1 - lista_datos.getBarHeight() - 5);
  }
  lista_datos.setColorBackground(color(60));
  lista_datos.setColorActive(color(255, 128));
}

void esconderUI() {
  rotar_auto.hide();
  lista_datos.close();
  lista_3d.close();
  opcionesMapa.close();
  estadosCam.close();
  estadosCam.hide();
  lista_datos.hide();
  lista_3d.hide();
  opcionesMapa.hide();
  m2m.hide();
  autoHideUI.hide();
  guardarMapa.hide();
  escondido = true;
}

void mostrarUI() {
  rotar_auto.show();
  lista_datos.show();
  lista_3d.show();
  opcionesMapa.show();
  estadosCam.show();
  m2m.show();
  autoHideUI.show();
  if (cantMapas == 1) {
    guardarMapa.show();
  }
  escondido = false;
}

void esconder_mostrarUI() {
  if (esconderPresionado) {
    if (mouseY < 36 || cp5.isMouseOver()) {
      if (!textoMap1.isMouseOver() || !textoMap2.isMouseOver()) {
        mostrarUI();
      }
    } else if (!escondido) {
      esconderUI();
    }
  }
  if (lista_datos.isOpen()) {
    campoBusqueda.show();
  } else {
    campoBusqueda.hide();
  }

}

void colorearDatos() {
  if (mapas[0].SELECTOR != 0) {
    if (textoMap1.isVisible()) {
        for (int j = 0; j < cantMapas; j++) {
          float[] pos;
          if (j == 0) {
            pos = textoMap1.getPosition();
          }
          else {
            pos = textoMap2.getPosition();
          }
          for (int i = 0; i < mapas[j].colores.length; i++) {
            pushStyle();
            stroke(0);
            strokeWeight(2);
            fill(mapas[j].colores[i]);
            if (i != mapas[j].colores.length - 1) {
              rect(pos[0] - 12, pos[1] + 3 + i * 14, 12, 12);
            }
            else {
              rect(pos[0] - 12, pos[1] + 3 + (i+1) * 14, 12, 12);
            }
            popStyle();
        }
      }
    }
  }
}

void dibujarInterfaz() {
  hint(DISABLE_DEPTH_TEST);
  c.beginHUD();
  if (!record) {
    textFont(f, 30);
    fill(0, 30);
    text("" + nfc(frameRate, 1), width-100, 60);
    //Mostrar texto
    for (int i = 0; i < cantMapas; i++) {
      mapas[i].mostrarTexto();
      mapas[i].renovarDatos();
    }
    //Dibjuar leyendas de color de los datos
    colorearDatos();
    cp5.draw();
  }

  if (mostrarTut) {
    mostrarTutorial();
  }

  esconder_mostrarUI();
  c.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void modif_interfaz() {
  if (cantMapas == 2) {
    estadosCam.addItem("[mapa2] Guardar el estado de camara actual", 2);
    estadosCam.addItem("[mapa2] Volver el estado al valor guardado", 3);
    estadosCam.addItem("Copiar camara [mapa1] a camara [mapa2]", 4);
    estadosCam.addItem("Movimiento simultaneo", 5);
    textoMap2.show();
    textoMap2.setPosition(width-220, height*0.2);
    textoMap1.setPosition(width/2-220, height*0.2);
    guardarMapa.hide();
  } else {
    estadosCam.removeItem("[mapa2] Guardar el estado de camara actual");
    estadosCam.removeItem("[mapa2] Volver el estado al valor guardado");
    estadosCam.removeItem("Copiar camara [mapa1] a camara [mapa2]");
    estadosCam.removeItem("Movimiento simultaneo");
    guardarMapa.show();
    textoMap2.hide();
    textoMap1.setPosition(width-220, height*0.2);
  }
}

void crearBusqueda() {
  lista_datos.clear();
  crearDatos();
}

void colorearSeleccionado(int op) { //No usar
  //Creo los colores
  CColor c = new CColor();
  c.setBackground(color(255, 0, 0));
  CColor c2 = new CColor();
  c2.setBackground(color(60));

  if (cantMapas == 1) {
    //Le seteo el color al item
    cp5.get(ScrollableList.class, "Lista de datos estadisticos").getItem(op-1).put("color", c);
    if (mapas[0].SELECTOR != 0) {
      cp5.get(ScrollableList.class, "Lista de datos estadisticos").getItem(mapas[0].SELECTOR-1).put("color", c2);
    }
  } else {
    //Le seteo el color al item
    cp5.get(ScrollableList.class, "Lista de datos estadisticos").getItem(op-1).put("color", c);
    cp5.get(ScrollableList.class, "Lista de datos estadisticos").getItem(mapas[0].SELECTOR-1).put("color", c);
    if (mapas[1].SELECTOR != 0) {
      if (mapas[1].SELECTOR-1 != op-1) {
        //REVISAR
        cp5.get(ScrollableList.class, "Lista de datos estadisticos").getItem(mapas[1].SELECTOR-1).put("color", c2);
      }
    }
  }
}


void controlEvent(ControlEvent theEvent) {

  if (theEvent.isFrom(m2m)) {
    cantMapas = (int)m2m.getArrayValue()[0] + 1;
    modif_interfaz();
    setup();
  }
  else if (theEvent.isFrom(rotar_auto)) {
      if (auto_rotar) {
        auto_rotar = false;
      }
      else {
        auto_rotar = true;
      }
    } else if (theEvent.isFrom(autoHideUI)) {
    if (esconderPresionado) {
      esconderPresionado = false;
    }
    else {
      esconderPresionado = true;
    }
  } else if (theEvent.isFrom(opcionesMapa)) {
    if (opcionesMapa.getValue() == 0 || opcionesMapa.getValue() == 1 || opcionesMapa.getValue() == 2) {
      for (int i = 0; i < cantMapas; i++) {
        mapas[i].selectMaximo = (int)opcionesMapa.getValue();
      }
    } else if (opcionesMapa.getValue() == 3) {
      for (int i = 0; i < cantMapas; i++) {
        mapas[i].selectMinimo = 0;
      }
    } else if (opcionesMapa.getValue() == 4) {
      for (int i = 0; i < cantMapas; i++) {
        mapas[i].selectMinimo = 2;
      }
    }
  } else if (theEvent.isFrom(estadosCam)) {
    if (estadosCam.getValue() == 0) {
      mapas[0].grabarEstadoCam();
    } else if (estadosCam.getValue() == 1) {
      mapas[0].volverEstadoCam();
    } else if (estadosCam.getValue() == 2) {
      //grabar estado map 2
      mapas[1].grabarEstadoCam();
    } else if (estadosCam.getValue() == 3) {
      mapas[1].volverEstadoCam();
    } else if (estadosCam.getValue() == 4) {
      //poner las 2 cams como cam 1
      CameraState c;
      c = mapas[0].cam.getState();
      mapas[1].cam.setState(c, 1000);
    } else if (estadosCam.getValue() == 5) {
      //mover las 2 cams al mismo tiempo
    }
  } else if (theEvent.isFrom(guardarMapa)) {
    record = true;
  }
  else if (theEvent.isFrom(ocultar_datos)) {
    if (!textoMap1.isVisible() && cantMapas == 2) {
      textoMap1.show();
      textoMap2.show();
    }
    else if (!textoMap1.isVisible()) {
      textoMap1.show();
    }
    else if (textoMap1.isVisible() && cantMapas == 1) {
      textoMap1.hide();
      textoMap2.hide();
    }
    else {
      textoMap1.hide();
      textoMap2.hide();
    }
  }

  if (theEvent.isAssignableFrom(Textfield.class)) {
    busq = theEvent.getStringValue();
    crearBusqueda();
  }

  if (theEvent.isController()) {

    if (theEvent.getController() == lista_datos) {
  
      int op = int(theEvent.getController().getValue()+1);
      List l = lista_datos.getItems();
      String s;
      s = l.get(op-1).toString();
      String[] m = match(s, "name=(.*?),");
      for (int i = 0; i < datos.data[0].length; i++) {
        String opcion = datos.data[0][i];
        opcion = opcion.toLowerCase();
        opcion.replace('é', 'e');
        opcion.replace('í', 'i');
        opcion.replace('ó', 'o');
        opcion.replace('ú', 'u');
        opcion.replace('á', 'a');
        opcion.replace('ü', 'u');
        if (m[1].equals(opcion) == true) {
          op = i;
          println("encontrado");
          break;
        }
        else {
          println(m[1] + " ::: " + opcion +".");
        }
      }
      
      if (lista_datos.isActive()) {
        lista_datos.bringToFront();
      }

      if (cantMapas == 2) {
        mapas[1].SELECTOR = mapas[0].SELECTOR;
        mapas[0].SELECTOR = op;

        log = "";
        for (int j = 0; j < cantMapas; j++) {
          for (int i = 1; i < datos.data.length; i++) {
            log = log +(datos.data[i][0])+": \t\t "+(datos.data[i][mapas[j].SELECTOR])+ "\n";
          }
          if (j == 0) {
            textoMap1.setText(log);
            log = "";
          } else {
            textoMap2.setText(log);
          }
        }
      } else {
        mapas[0].SELECTOR = op;

        log = "";

        for (int i = 1; i < datos.data.length; i++) {
          log = log +(datos.data[i][0])+": \t"+(datos.data[i][mapas[0].SELECTOR])+ "\n";
        }
        textoMap1.setText(log);
      }
    }

    if (theEvent.getController() == lista_3d) {

      int op = int(theEvent.getController().getValue());

      if (op ==0) {
        piramide =false;
        rect = false;
        proyec= true;
      } else if (op ==1) {
        piramide =false;
        rect = true;
        proyec= false;
      } else if (op ==2) {
        piramide =true;
        rect = false;
        proyec= false;
      }
    }
    setup();
  }
}

//Mapa
class Mapa {

  int posCamX, posCamY, dimensionCamX, dimensionCamY;
  int selectMaximo = 0;
  int selectMinimo = 0;
  int SELECTOR = 0;
  color[] colores;
  PShape mapa_svg, map;
  PeasyCam cam;
  CameraState estado;
  PApplet p;

  Mapa (String ruta, PApplet p, int pCamX, int pCamY, int dCamX, int dCamY) {
    mapa_svg  = loadShape(ruta);
    map = createShape(GROUP);
    cam = new PeasyCam(p, 900);
    this.p = p;
    setCam(pCamX, pCamY, dCamX, dCamY);
    colores = new color[24];
    addChilds();
  }

  void renovarDatos() {
    datos.renovarDatos(SELECTOR);
  }

  void rotar() {
    if (auto_rotar) {
      cam.rotateX(sin(frameCount/100.0)/4000.0);
      cam.rotateY(cos(frameCount/100.0)/4000.0);
    }
  }

  void mostrarTexto() {
    textAlign(CENTER);
    fill(0);
    pushStyle();
    textSize(16);
    if (SELECTOR == 0) {
      text("República Argentina", posCamX+dimensionCamX/2, 60);
    } else {
      text(datos.data[0][SELECTOR], posCamX+dimensionCamX/2, 60);
      mostrarMaxMin();
    }
    popStyle();
  }

  void mostrarMaxMin() {
    int valMax = 0, valMin = 0;
    float[] vals = new float[datos.poblacion.length];
    for (int i = 0; i < datos.poblacion.length; i++) {
      String s =datos.data[i+1][SELECTOR].replace(",", ".");
      vals[i] = float(s);
    }
    //printArray(vals);
    float max = max(vals);
    float min = min(vals);
    pushStyle();
    textSize(14);

    for (int i = 0; i < datos.poblacion.length; i++) {
      if (vals[i] == max) {
        valMax = i;
      } else if (vals[i] == min) {
        valMin = i;
      }
    }
    if (valMax + 1 == 23) {
      text("Maximo "+ "Tierra del Fuego, Antártida.." + ": "+ max, posCamX+dimensionCamX * 0.25, height*0.9);
      text("Minimo "+datos.data[valMin+1][0]+": "+ min, posCamX+dimensionCamX * 0.75, height*0.9);
    }
    else if (valMin + 1 == 23) {
      text("Maximo "+datos.data[valMax+1][0]+": "+ max, posCamX+dimensionCamX * 0.25, height*0.9);
      text("Minimo "+ "Tierra del Fuego, Antártida.." + ": "+ min, posCamX+dimensionCamX * 0.75, height*0.9);
    }
    else {
      text("Maximo "+datos.data[valMax+1][0]+": "+ max, posCamX+dimensionCamX * 0.25, height*0.9);
      text("Minimo "+datos.data[valMin+1][0]+": "+ min, posCamX+dimensionCamX * 0.75, height*0.9);
    }
    popStyle();
  }

  void setCam(int pCamX, int pCamY, int dCamX, int dCamY) {
    posCamX = pCamX;
    posCamY = pCamY;
    dimensionCamX = dCamX;
    dimensionCamY = dCamY;
    cam.setMinimumDistance(500);
    cam.setMaximumDistance(1250);
    cam.setViewport(posCamX, posCamY, dimensionCamX, dimensionCamY);
  }

  void setGLGraphicsViewport(int x, int y, int w, int h) {
    PGraphics3D pg = (PGraphics3D) p.g;
    PJOGL pgl = (PJOGL) pg.beginPGL();
    pg.endPGL();
    pgl.enable(PGL.SCISSOR_TEST);
    pgl.scissor (x, y, w, h);
    pgl.viewport(x, y, w, h);
  }

  void grabarEstadoCam() {
    estado = cam.getState();
  }

  void volverEstadoCam() {
    cam.setState(estado, 1000);
  }

  void dibujar() {
    int y_inv =  height - posCamY - dimensionCamY;
    setGLGraphicsViewport(posCamX, y_inv, dimensionCamX, dimensionCamY);
    cam.feed();
    rotar();
    perspective(60 * PI/180, dimensionCamX/(float)dimensionCamY, 1, 5000);
    //background(#FCFAFA);
    background(#D8D8D8);
    translate(-150, -350, 0);
    lights();
    shape(map, 0, 0);
  }

  void cambiarDatos(String ruta) {
    renovarDatos();
    mapa_svg  = loadShape(ruta);
    map = createShape(GROUP);
    datos.setMaximo(selectMaximo);
    datos.setMinimo(selectMinimo);
    addChilds();
  }

  void  addChilds() {
     for (int i = 0; i < mapa_svg.getChildCount(); ++i) {
    PShape state = mapa_svg.getChild(i);

    if (i==1) {
      //Agregar base
      PShape arg = state.getChild("ARGENTINA");
      PShape base = connectShapesBase(arg, 10);
      if (SELECTOR!=0)map.addChild(base);

      for (int j = 0; j < datos.provincias.length; j++) {

        PShape provincia = state.getChild(datos.provincias[j]);

        //stroke(0, 20);

        float altura = map(datos.poblacion[j],datos.minPoblacion, datos.maxPoblacion, 10, 500);

          colores[j] = color(56+(altura/500*200), 255, 255);
          fill(colores[j]);

          PShape group = createShape(GROUP);

          PShape connect = connectShapes(provincia, altura);
          group.addChild(provincia);
          group.addChild(connect);

          map.addChild(group);
        }
      }
    }
  }

  PShape connectShapes(PShape normal, float offset) {
    float x=0, y=0;

    for (int i = 0; i < normal.getVertexCount(); i++) {
      PVector n = normal.getVertex(i);
      x+=n.x;
      y+=n.y;
    }
    x/=normal.getVertexCount();
    y/=normal.getVertexCount();
    // stroke(0, 20);
    //cantidad de puntos que saltea +1  ;  Ej; 1 = no saltea ningun punto
    int saltear = 1;
    PShape s = createShape();
    if (proyec) {
      s.beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < normal.getVertexCount()+1; i = i + saltear) {
        PVector n = normal.getVertex(i%normal.getVertexCount());
        s.vertex(n.x, n.y, 0);
        s.vertex((n.x+x+x)/3, (n.y+y+y)/3, offset);
      }
      //  noStroke();
      for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
        PVector n = normal.getVertex(i%normal.getVertexCount());
        s.vertex(x, y, offset);
        s.vertex((n.x+x+x)/3, (n.y+y+y)/3, offset);
      }
      s.endShape(CLOSE);
    } else if (piramide) {
      s.beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
        PVector n = normal.getVertex(i%normal.getVertexCount());
        s.vertex(n.x, n.y, 0);
        s.vertex(x, y, offset);
      }
      s.endShape(CLOSE);
    } else if (rect) {
      s.beginShape(TRIANGLE_STRIP);
      for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
        PVector n = normal.getVertex(i%normal.getVertexCount());
        s.vertex(n.x, n.y, 0);
        s.vertex(n.x, n.y, offset);
      }
      // noStroke();
      for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
        PVector n = normal.getVertex(i%normal.getVertexCount());
        s.vertex(x, y, offset);
        s.vertex(n.x, n.y, offset);
      }
      s.endShape(CLOSE);
    }
    noStroke();
    return s;
  }

  PShape connectShapesBase(PShape normal, float offset) {
    float x=0, y=0;

    for (int i = 0; i < normal.getVertexCount(); i++) {
      PVector n = normal.getVertex(i);
      x+=n.x;
      y+=n.y;
    }
    x/=normal.getVertexCount();
    y/=normal.getVertexCount();
    // stroke(220, 20);
    //cantidad de puntos que saltea +1  ;  Ej; 1 = no saltea ningun punto
    int saltear = 1;
    PShape s = createShape();

    int corrimiento = 9;

    s.beginShape(TRIANGLE_STRIP);
    s.fill(255);
    for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
      PVector n = normal.getVertex(i%normal.getVertexCount());
      s.vertex(n.x, n.y, -corrimiento);
      s.vertex(n.x, n.y, offset-corrimiento);
    }

    for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
      PVector n = normal.getVertex(i%normal.getVertexCount());
      s.vertex(x, y, offset-corrimiento);
      s.vertex(n.x, n.y, offset-corrimiento);
    }

    for (int i = 0; i < normal.getVertexCount()+1; i= i + saltear) {
      PVector n = normal.getVertex(i%normal.getVertexCount());
      s.vertex(x, y, -corrimiento);
      s.vertex(n.x, n.y, -corrimiento);
    }
    s.endShape(CLOSE);
    return s;
  }
}
