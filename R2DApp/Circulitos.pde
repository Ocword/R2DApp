class  Circulitos {
  PVector pos;
  int   num;
  String  nombre;
  int radio = 10;

  Circulitos(float x, float y) {
    pos = new PVector(x, y);
  }

  void mostrar() {
    
    color c = color(map(colores[num], -1, 5, 0, 200), 255, 255);
    fill(c);
    ellipse(pos.x, pos.y, radio, radio);


    c = color((map(colores[num], -1, 5, 0, 200))+128%255, 255, 255);
    fill(c);
    text(num, pos.x, pos.y);

    fill(255);
    if (dist(pos.x, pos.y, mouseX, mouseY)<radio*3) {

      text(nombre, width/2 , height/2+ textos*10);
      textos ++;
    }
  }
}
