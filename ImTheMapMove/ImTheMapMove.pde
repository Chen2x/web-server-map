import processing.pdf.*;

XML xml;
Boolean xmlpages = true;
Boolean record = false;

ArrayList<Page> pages = new ArrayList<Page>();
void setup() {
  //size(1200, 1400, PDF, "GUI_Structure.pdf");
  size(1200, 1400);
  background(255);
  xml = loadXML("GUI_Structure.xml");
  textSize(12);
  fill(0);
  textSize(20);
  text("Device_01", width/2, 50);
  //noLoop();
  getXML(xml);
  familyTree();
  text("Main Menu", width/2, 150);
  textSize(12);
  drawMap(pages.get(0), 50, 0, width, width/2, 50);
}

void draw() {
  if (record){
    beginRecord(PDF, "GUI_Structure.PDF");
  }
  background(255);
   //<>//
  //drawMap(pages.get(0), 50, 0, width, width/2, 50);
  for (int i = 0; i < pages.size(); i++) {
    pages.get(i).drawLine();
    pages.get(i).drawNode();
    
  }
  textSize(20);
  text("Device_01", width/2, 50);
  text("Main Menu", width/2, 150);
  textSize(12);
  if (record){
    endRecord();
    exit();
  }
 //<>//
  //textSize(20);
  //text("Device_01", width/2, 50);
  ////noLoop();
  //getXML(xml);
  //familyTree();
  ////for (int i = 0; i < pages.size(); i++) { 
  ////  println("name:", pages.get(i).name(), "     parent:", pages.get(i).parent(), "      Children:", pages.get(i).childrenName());
  ////}
  ////println(pages.get(0).childrenName());
  //text("Main Menu", width/2, 150);
  //textSize(12);
  //drawMap(pages.get(0), 50, 0, width, width/2, 50);
  ////save("GUI_Structure.jpg");
  ////exit();
}

void getXML(XML xml) {
  XML[] tree = (((xml.getChild("Device")).getChild("Page")).getChildren("Group"));
  pages.add(new Page("Device_01", "The Computer"));
  for (int i=0; i < tree.length; i++) {
    String name = tree[i].getString("title");
    pages.add(new Page(name, "Device_01"));
    getPage(tree[i], name);
  }
}

XML getPage(XML branch, String parent) {
  XML[] leaf = branch.getChildren("Page"); 

  XML[] xmlLeaf = branch.getChildren("XMLPage");

  if ((leaf.length == 0)) {    
    //println();
    return null;
  }
  for (int i=0; i < leaf.length; i++) {
    //println(leaf[i]);
    if (getPage(leaf[i], leaf[i].getString("title")) == null) {
      pages.add(new Page(leaf[i].getString("title"), parent));
    } else {
      getPage(leaf[i], leaf[i].getString("title"));
    }
  }
  if (xmlpages) {
    for (int i=0; i < xmlLeaf.length; i++) {
      println(xmlLeaf[i].getString("title"));
      if (getPage(xmlLeaf[i], xmlLeaf[i].getString("title")) == null) {
        pages.add(new Page(xmlLeaf[i].getString("title"), parent));
      } else {
        getPage(xmlLeaf[i], xmlLeaf[i].getString("title"));
      }
    }
  }
  return null;
}

void drawMap(Page parent, int level, int start, int end, int x, int y) {
  for (int k = 0; k < parent.childrenName().size(); k++) {
    int adjh = y+209-k*15;
    int adjx = int(start + k*(end-start)/parent.childrenName().size())+100;
    stroke(200);
    if (parent.childrenName().size()> 15) {
      adjh=y+250+k*12;
      adjx = int(start + k*(end-start)/parent.childrenName().size())+100;
      start = -140;
      end = width-130;
    }
    if (level+80+k*17 < y) {
      level = y;
    }
    if (parent.name().equals("Machine Information")) {
      adjh+=20;
    } else if (parent.name().equals("Device_01")) {
      adjh+=-100;
      start += 50;
      end -= 50;
    }
    if (start < -140) {
      start = 10;
    }
    if (adjx < 0) {
      adjx = 10;
    }
    if (adjx > width - 150) {
      adjx = width - 150;
    }
    println(parent.name());
    if ((parent.name().equals("Reporting"))||(parent.name().equals("Production"))||(parent.name().equals("System"))||(parent.name().equals("Access"))) {     
      line(width/2, 150, adjx, adjh);
    } else if ((parent.name().equals("Device_01"))) {
      adjh = 100;
    } else {
      stroke(200);
      line(x, y, adjx, adjh);
    }
    parent.children().get(k).storeNode(adjx, adjh, int(parent.children().get(k).name().length()*6.5));
    //fill(0, 150, 240, 40);
    //rect(adjx, adjh, parent.children().get(k).name().length()*6.5, -10);
    fill(0);
    text(parent.children().get(k).name(), adjx, adjh);
    drawMap(parent.children().get(k), level+100, adjx-width/7, adjx+width/80, adjx, adjh);
  }
}

void familyTree() {
  for (int x = 0; x < pages.size(); x++) {
    for (int y = 0; y < pages.size(); y++) {
      if (pages.get(x).name() == pages.get(y).parent()) {
        pages.get(x).addChild(pages.get(y));
      }
    }
  }
}

void mouseDragged(){
  //println(mousePressed);
  for (int p = 0; p < pages.size(); p ++){
    //println("yuuuhhhhh");
    if ((mouseX > pages.get(p).x())&&(mouseY > pages.get(p).y()-10)&&(mouseX < (pages.get(p).x()+pages.get(p).leng()))&&(mouseY < pages.get(p).y())){
      println("TRUUUUU");
      pages.get(p).storeNode(mouseX-pages.get(p).leng()/2, mouseY+5, pages.get(p).leng());
      pages.get(p).drawLine();
      pages.get(p).drawNode();
    }
  }
}

void keyPressed(){
  if (keyCode == ENTER){
    record = true;
  }
}