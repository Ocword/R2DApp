boolean cond = false;

void Menu() {
  
  
}





class Boton {
  PVector size, pos;
  color rgb;
  
  
  Boton(float _x, float _y, float w, float h) {
    pos = new PVector(_x, _y);
    size = new PVector(w, h);
    rgb = 255;
    
    fill(rgb);
  }
  
  Boton(float _x, float _y, float w, float h, color _rgb) {
    pos.set(_x, _y);
    size.set(w, h);
    rgb = _rgb;
    
    fill(rgb);
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);    
  }
  
  void show() {
    colorMode(RGB);
    rectMode(CENTER);
    rect(pos.x, pos.y, size.x, size.y);    
  }
  
  void mColor(color _rgb) {
    if ((mouseX >= pos.x - size.x/2) && (mouseX <= pos.x + size.x/2) && (mouseY <= pos.y + size.y/2) && (mouseY >= pos.y - size.y/2)) fill(_rgb);
    else fill(rgb);
  }
  
  void mousePress(color _rgb) {
    if (mousePressed){
      if ((mouseX >= pos.x - size.x/2) && (mouseX <= pos.x + size.x/2) && (mouseY <= pos.y + size.y/2) && (mouseY >= pos.y - size.y/2) && mouseButton == LEFT && mousePressed) fill(_rgb);
    }
    println(cond);
    cond = false;
  }
  
}


void mouseReleased() {
  cond = true;
}
