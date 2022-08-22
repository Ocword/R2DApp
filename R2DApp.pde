//R2D------------------------------------------------------------------------------------------------------------------
Table table;
float maxX, minX, maxY, minY;
//float [][] datosR2D;
Table nombres;
//String [] nombre;
Circulitos [] datosR2D;

int index = 0;

PImage R2Dlogo;
PImage C3Dlogo;

Boton R2D;
Boton C3D;
Boton exploracionDeDatos;

int[] colores = { 4, -1, -1, -1,  1,  1,  0,  2, -1, -1, -1,  0,  0, -1, -1, -1,  1,
        1,  0,  2, -1, -1,  3,  1,  3, -1,  1,  3, -1,  1, -1,  4,  1, -1,
       -1,  1,  3,  0,  4,  0, -1,  3, -1,  3, -1,  2,  4,  3,  0,  3, -1,
        1,  3,  4, -1, -1, -1, -1, -1, -1, -1,  0,  4,  4, -1,  0,  4,  4,
        0,  3,  2,  2,  4,  3, -1,  4,  4, -1,  2,  2,  2,  1,  4,  0, -1,
        4,  4,  2,  2,  2,  2,  2,  2, -1,  1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1};

int textos = 0;

void setup() {
  //C3D
  camaraInterfaz();
  instanciarDatos();
  instanciarFuente();
  pushStyle();
  colorMode(HSB);
  instanciarMapas();
  popStyle();
  setupGUI();
  
  //R2D
  maxX = -111111;
  minX = 9999999;
  maxY = maxX;
  minY = minX;
  
  ellipseMode(RADIUS);
  textAlign(CENTER, CENTER);
  //frameRate(1);

  table = loadTable("paresOrdenados.csv", "header");
  nombres = loadTable("nombres.csv", "header");
  datosR2D = new Circulitos[107];
  int i= 0;
  for (TableRow row : table.rows()) {
    // You can access the fields via their column name (or index)
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    println(x, y);

    minX = min(minX, x);
    minY = min(minY, y);
    maxX = max(maxX, x);
    maxY = max(maxY, y);

    datosR2D[i] = new Circulitos(x, y);
    i++;
  }
  println(maxX, minX, maxY, minY);


  for ( i = 0; i<106; i++) {
    float x = datosR2D[i].pos.x;
    float y = datosR2D[i].pos.y;

    x = map(x, minX, maxX, 20, width-20);
    y = map(y, minY, maxY, 20, height-20);
    datosR2D[i].pos.x = x;
    datosR2D[i].pos.y = y;
  }


  i=0;
  for (TableRow row : nombres.rows()) {
    // You can access the fields via their column name (or index)
    String n = row.getString(0);
    datosR2D[i].nombre= n;
    datosR2D[i].num = i;
    println(i, n);
    i++;
  }
  
  R2Dlogo = loadImage("R2Dlogo.jpeg");
  C3Dlogo = loadImage("C3Dlogo.png");
  
  R2D = new Boton(width * 3/8, height/2 - 50, 332, 332, color(0, 0));
  C3D = new Boton(width * 5/8, height/2 - 50, 400, 212, color(0, 0));
  exploracionDeDatos = new Boton(width * 3/8, height * 5/8 + 20, 332, 50, "Exploración de datosR2D");
}

void draw() {
  switch (index) {
    case 0:
      Menu();
      break;
    case 1:
      R2D();
      break;
    case 2:
      C3D();
      break;
  }
}



//Programa C3D
void C3D() {
  noStroke();
  limpiarPantalla();

  //Grabar
  if (record) {
    String nombreOutput = datos.data[0][mapas[0].SELECTOR].replace("(", "").replace(")", "").replace("%", "");
    mapas[0].map.scale(-1, 1, 1);
    mapas[0].map.rotate(-90);
    beginRaw(DXF, nombreOutput+".dxf");
  }

  desactivarCamara();
  dibujarPrograma();

  //Dejar de grabar
  if (record) {
    endRaw();
    record = false;
    mapas[0].map.scale(-1, 1, 1);
    mapas[0].map.rotate(-90);
  }
}


//Programa de R2D
void R2D() {

  translate(- width/2, - height/2,120);
  background(0);
  colorMode(HSB);
  ellipse(mouseX, mouseY, 20, 20);
  textos =0;
  for (int i = 0; i<106; i++) {
    float xi = datosR2D[i].pos.x;
    float yi = datosR2D[i].pos.y;
    for (int j = i+1; j<106; j++) {
      float xj = datosR2D[j].pos.x;
      float yj = datosR2D[j].pos.y;
      if (dist(xi, yi, xj, yj)<10) {
        datosR2D[i].pos.x += random( 5);
        datosR2D[i].pos.y += random( 5);
      }
    }
  }

  for (int i = 0; i<106; i++) {
    datosR2D[i].mostrar();
  }
}
