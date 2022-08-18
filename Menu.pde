

void Menu() {
  background(0);
  image(R2Dlogo, width/4, height/2);
}





class Boton {
  PVector size, pos;
  color rgb;
  String text;


  Boton(float _x, float _y, float w, float h, String _text) {
    pos = new PVector(_x, _y);
    size = new PVector(w, h);
    rgb = color(120,255,255);
    text = _text;

    fill(rgb);
  }

  Boton(float _x, float _y, float w, float h, color _rgb) {
    pos.set(_x, _y);
    size.set(w, h);
    rgb = _rgb;
    show();
  }

  void show() {
    mColor();
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);
  }

  void mColor() {
    if ((mouseX >= pos.x - size.x/2) && (mouseX <= pos.x + size.x/2) && (mouseY <= pos.y + size.y/2) && (mouseY >= pos.y - size.y/2)) fill(255,255,255);
    else fill(rgb);
  }

  void bText() {

    textSize(30);
    fill(255);
    text(text, pos.x, pos.y);
  }
  
}
