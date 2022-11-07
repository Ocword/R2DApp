Boton loadData;

import java.util.*;
import java.io.*;

Button guardar;

String newNameData;

String buenosAiresData;
String catamarcaData;
String chacoData;
String chubutData;
String CABA;
String cordobaData;
String corrientesData;
String entreRiosData;
String formosaData;
String jujuyData;
String laPampaData;
String laRiojaData;
String mendozasData;
String misionesData;
String neuquenData;
String rioNegroData;
String saltaData;
String sanJuanData;
String sanLuisData;
String santaCruzData;
String santaFeData;
String sgoDelEsteroData;
String tierraDelFuegoData;
String tucumanData;

ControlP5 cp5LD;
PrintWriter output;

void loadDataGUI() {

  background(0);
  cp5LD = new ControlP5(this);
  cp5LD.setAutoDraw(false);
  
  cp5LD.addTextfield("newNameData")
    .setPosition(width*0.5-75, 20)
    .setSize(150, 30);

  cp5LD.addTextfield("buenosAiresData")
    .setPosition(width*0.5-75-200, 100)
    .setSize(150, 30);

  cp5LD.addTextfield("catamarcaData")
    .setPosition(width*0.5-75, 100)
    .setSize(150, 30);

  cp5LD.addTextfield("chacoData")
    .setPosition(width*0.5-75+200, 100)
    .setSize(150, 30);

  cp5LD.addTextfield("chubutData")
    .setPosition(width*0.5-75-200, 160)
    .setSize(150, 30);

  cp5LD.addTextfield("CABA")
    .setPosition(width*0.5-75, 160)
    .setSize(150, 30);

  cp5LD.addTextfield("cordobaData")
    .setPosition(width*0.5-75+200, 160)
    .setSize(150, 30);

  cp5LD.addTextfield("corrientesData")
    .setPosition(width*0.5-75-200, 220)
    .setSize(150, 30);

  cp5LD.addTextfield("entreRiosData")
    .setPosition(width*0.5-75, 220)
    .setSize(150, 30);

  cp5LD.addTextfield("formosaData")
    .setPosition(width*0.5-75+200, 220)
    .setSize(150, 30);

  cp5LD.addTextfield("jujuyData")
    .setPosition(width*0.5-75-200, 280)
    .setSize(150, 30);

  cp5LD.addTextfield("laPampaData")
    .setPosition(width*0.5-75, 280)
    .setSize(150, 30);

  cp5LD.addTextfield("laRiojaData")
    .setPosition(width*0.5-75+200, 280)
    .setSize(150, 30);

  cp5LD.addTextfield("mendozasData")
    .setPosition(width*0.5-75-200, 340)
    .setSize(150, 30);

  cp5LD.addTextfield("misionesData")
    .setPosition(width*0.5-75, 340)
    .setSize(150, 30);

  cp5LD.addTextfield("neuquenData")
    .setPosition(width*0.5-75+200, 340)
    .setSize(150, 30);

  cp5LD.addTextfield("rioNegroData")
    .setPosition(width*0.5-75-200, 400)
    .setSize(150, 30);

  cp5LD.addTextfield("saltaData")
    .setPosition(width*0.5-75, 400)
    .setSize(150, 30);

  cp5LD.addTextfield("sanJuanData")
    .setPosition(width*0.5-75+200, 400)
    .setSize(150, 30);

  cp5LD.addTextfield("sanLuisData")
    .setPosition(width*0.5-75-200, 460)
    .setSize(150, 30);

  cp5LD.addTextfield("santaCruzData")
    .setPosition(width*0.5-75, 460)
    .setSize(150, 30);

  cp5LD.addTextfield("santaFeData")
    .setPosition(width*0.5-75+200, 460)
    .setSize(150, 30);

  cp5LD.addTextfield("sgoDelEsteroData")
    .setPosition(width*0.5-75-200, 520)
    .setSize(150, 30);

  cp5LD.addTextfield("tierraDelFuegoData")
    .setPosition(width*0.5-75, 520)
    .setSize(150, 30);

  cp5LD.addTextfield("tucumanData")
    .setPosition(width*0.5 - 75+200, 520)
    .setSize(150, 30);

  guardar = cp5LD.addButton("Guardar")
    .setPosition(width*0.5 - 35, height*0.8)
    .setSize(70, 30)
    .setLabel("Guardar");

  output = createWriter("data.csv");
}

void insertData() {
  hint(DISABLE_DEPTH_TEST);
  c.beginHUD();
  background(0);
  cp5LD.draw();
  c.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

//void controlSave(ControlEvent Save) {
//  if (Save.isFrom(guardar)) {
//    newNameData = cp5LD.get(Textfield.class, "newNameData").getText();

//    buenosAiresData = cp5LD.get(Textfield.class, "buenosAiresData").getText();
//    catamarcaData = cp5LD.get(Textfield.class, "catamarcaData").getText();
//    chacoData = cp5LD.get(Textfield.class, "chacoData").getText();
//    chubutData = cp5LD.get(Textfield.class, "chubutData").getText();
//    CABA = cp5LD.get(Textfield.class, "CABA").getText();
//    cordobaData = cp5LD.get(Textfield.class, "cordobaData").getText();
//    corrientesData = cp5LD.get(Textfield.class, "corrientesData").getText();
//    entreRiosData = cp5LD.get(Textfield.class, "entreRiosData").getText();
//    formosaData = cp5LD.get(Textfield.class, "formosaData").getText();
//    jujuyData = cp5LD.get(Textfield.class, "jujuyData").getText();
//    laPampaData = cp5LD.get(Textfield.class, "laPampaData").getText();
//    laRiojaData = cp5LD.get(Textfield.class, "laRiojaData").getText();
//    mendozasData = cp5LD.get(Textfield.class, "mendozasData").getText();
//    misionesData = cp5LD.get(Textfield.class, "misionesData").getText();
//    neuquenData = cp5LD.get(Textfield.class, "neuquenData").getText();
//    rioNegroData = cp5LD.get(Textfield.class, "rioNegroData").getText();
//    sanJuanData = cp5LD.get(Textfield.class, "sanJuanData").getText();
//    sanLuisData = cp5LD.get(Textfield.class, "sanLuisData").getText();
//    santaCruzData = cp5LD.get(Textfield.class, "santaCruzData").getText();
//    santaFeData = cp5LD.get(Textfield.class, "santaFeData").getText();
//    sgoDelEsteroData = cp5LD.get(Textfield.class, "sgoDelEsteroData").getText();
//    tierraDelFuegoData = cp5LD.get(Textfield.class, "tierraDelFuegoData").getText();
//    tucumanData = cp5LD.get(Textfield.class, "tucumanData").getText();

//    println("Nombre: " + newNameData);

//    println("Buenos Aires: " + buenosAiresData);
//  }
//}
