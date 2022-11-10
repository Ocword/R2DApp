void Menu() {
  hint(DISABLE_DEPTH_TEST);
  c.beginHUD();
  background(0);
  colorMode(RGB);
  imageMode(CENTER);
  image(R2Dlogo, width * 3/8, height/2 - 50);
  image(C3Dlogo, width * 5/8, height/2 - 50);
  C3D.bClick(2);
  exploracionDeDatos.show();
  exploracionDeDatos.bText();
  exploracionDeDatos.bClick(1);
  loadData.show();
  loadData.bText();
  loadData.bClick(3);
  c.endHUD();
  hint(ENABLE_DEPTH_TEST);
}





class Boton {
  PVector size, pos;
  color rgb;
  String text;


  Boton(float _x, float _y, float w, float h, color _rgb, String _text) {
    pos = new PVector(_x, _y);
    size = new PVector(w, h);
    rgb = _rgb;
    text = _text;

    fill(rgb);
  }

  Boton(float _x, float _y, float w, float h, color _rgb) {
    pos = new PVector(_x, _y);
    size = new PVector(w, h);
    rgb = _rgb;
    show();
  }

  void show() {
    mColor();
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);
  }

  void mColor() {
    if ((mouseX >= pos.x - size.x/2) && (mouseX <= pos.x + size.x/2) && (mouseY <= pos.y + size.y/2) && (mouseY >= pos.y - size.y/2)) fill(255, 0, 0);
    else fill(rgb);
  }

  void bText() {

    textSize(30);
    fill(255);
    text(text, pos.x, pos.y);
  }

  void bClick(int cond) {
    if ((mouseX >= pos.x - size.x/2) && (mouseX <= pos.x + size.x/2) && (mouseY <= pos.y + size.y/2) && (mouseY >= pos.y - size.y/2) && mousePressed && mouseButton == LEFT) index = cond;
  }
}