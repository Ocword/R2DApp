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
