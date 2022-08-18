Table table;
float maxX, minX, maxY, minY;
//float [][] datos;
Table nombres;
//String [] nombre;
Circulitos [] datos;

int index = 0;

PImage R2Dlogo;

int[] colores = { 4, -1, -1, -1,  1,  1,  0,  2, -1, -1, -1,  0,  0, -1, -1, -1,  1,
        1,  0,  2, -1, -1,  3,  1,  3, -1,  1,  3, -1,  1, -1,  4,  1, -1,
       -1,  1,  3,  0,  4,  0, -1,  3, -1,  3, -1,  2,  4,  3,  0,  3, -1,
        1,  3,  4, -1, -1, -1, -1, -1, -1, -1,  0,  4,  4, -1,  0,  4,  4,
        0,  3,  2,  2,  4,  3, -1,  4,  4, -1,  2,  2,  2,  1,  4,  0, -1,
        4,  4,  2,  2,  2,  2,  2,  2, -1,  1, -1, -1, -1, -1, -1, -1, -1,
       -1, -1, -1, -1};

int textos = 0;

void setup() {
  fullScreen();
  maxX = -111111;
  minX = 9999999;
  maxY = maxX;
  minY = minX;
  colorMode(HSB);
  ellipseMode(RADIUS);
  textAlign(CENTER, CENTER);
  //frameRate(1);

  table = loadTable("paresOrdenados.csv", "header");
  nombres = loadTable("nombres.csv", "header");
  datos = new Circulitos[107];
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

    datos[i] = new Circulitos(x, y);
    i++;
  }
  println(maxX, minX, maxY, minY);


  for ( i = 0; i<106; i++) {
    float x = datos[i].pos.x;
    float y = datos[i].pos.y;

    x = map(x, minX, maxX, 20, width-20);
    y = map(y, minY, maxY, 20, height-20);
    datos[i].pos.x = x;
    datos[i].pos.y = y;
  }


  i=0;
  for (TableRow row : nombres.rows()) {
    // You can access the fields via their column name (or index)
    String n = row.getString(0);
    datos[i].nombre= n;
    datos[i].num = i;
    println(i, n);
    i++;
  }
  
  R2Dlogo = loadImage("R2Dlogo.jpge");
}

void draw() {
  switch (index) {
    case 0:
      Menu();
      break;
    case 1:
      R2D();
      break;
  }
}





//Programa de R2D
void R2D() {
  background(0);
  ellipse(mouseX, mouseY, 20, 20);
  textos =0;
  for (int i = 0; i<106; i++) {
    float xi = datos[i].pos.x;
    float yi = datos[i].pos.y;
    for (int j = i+1; j<106; j++) {
      float xj = datos[j].pos.x;
      float yj = datos[j].pos.y;
      if (dist(xi, yi, xj, yj)<10) {
        datos[i].pos.x += random( 5);
        datos[i].pos.y += random( 5);
      }
    }
  }

  for (int i = 0; i<106; i++) {
    datos[i].mostrar();
  }
}
