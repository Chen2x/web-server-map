import processing.pdf.*; //<>// //<>//
import java.io.File;

Table nodes;
XML xml;
Boolean xmlpages = true;
Boolean record = false;
Boolean fullRun;
ArrayList<Page> pages = new ArrayList<Page>();

ArrayList<TableRow> pgStore = new ArrayList<TableRow>();

void setup() {  //run once to setup
  //size(1200, 1400);
  size(1200, 1000);
  background(255);
  xml = loadXML("GUI_Structure.xml"); 
  nodes = loadTable((dataPath("nodestore.csv")));
  textSize(12);
  fill(0);
  textSize(20);
  text("Device_01", width/2, 50);
  noLoop(); //this temporarily stops looping in the draw function for efficiency

  fullRun = (nodes != null); //boolean for if the csv file exists
  if (nodes != null) { //if csv exists then load data from csv rather than xml
    nodes = loadTable(dataPath("nodestore.csv"), "header");
    
    for (TableRow row : nodes.rows()) {
      Page np = new Page(row.getString("name"), row.getString("parent"));
      pages.add(np);
      np.storeNode(row.getInt("x"), row.getInt("y"));
    }
    familyTree();
  
  } else { //normal run using xml and sets up the csv for storage
    nodes = new Table();
    nodes.addColumn("name");
    nodes.addColumn("parent");
    nodes.addColumn("x");
    nodes.addColumn("y");
    getXML(xml);
    familyTree();
    drawMap(pages.get(0), 50, 0, width, width/2, 50);
    setTable();
  }

  text("Main Menu", width/2, 150);
  textSize(12);
  //drawMap(pages.get(0), 50, 0, width, width/2, 50);
  //setTable();
}

void draw() {
  if (record) { //record is only true after user manipulation, enter is pressed
    beginRecord(PDF, "GUI_Structure.PDF");
  }
  background(255);
  
  for (int i = 0; i < pages.size(); i++) { //accesses page objects to generate map using nodes and lines
    pages.get(i).drawLine();
    pages.get(i).drawNode();
  }

  textSize(20);
  text("Device_01", width/2, 50);
  text("Main Menu", width/2, 150);
  textSize(12);
  if (record) { //this is after record when the pdf is generated from a single loop and the program exits
    endRecord();
    saveTable(nodes, dataPath("nodestore.csv"));
    exit();
  }
}

void getXML(XML xml) { //first step in getting xml. 
  XML[] tree = (((xml.getChild("Device")).getChild("Page")).getChildren("Group"));
  pages.add(new Page("Device_01", "The Computer"));
  for (int i=0; i < tree.length; i++) { //adds the big 4 categories
    String name = tree[i].getString("title");
    pages.add(new Page(name, "Device_01")); //adds them as pages with Device_01 as parent
    getPage(tree[i], name);
  }
}

XML getPage(XML branch, String parent) { //recursively branches down xml paths
  XML[] leaf = branch.getChildren("Page");  //creates an array splitting the xml by the page block

  XML[] xmlLeaf = branch.getChildren("XMLPage"); //idk if were supposed to do xml page but why not

  if ((leaf.length == 0)) { //return null if empty to end recursion
    //println();
    return null;
  }
  for (int i=0; i < leaf.length; i++) { //loops through array of xml
    //println(leaf[i]);
    if (getPage(leaf[i], leaf[i].getString("title")) == null) { //if this xml has no children then add this to pages
      pages.add(new Page(leaf[i].getString("title"), parent)); //if this is called recursion is terminated
    } else { //if page has children
      getPage(leaf[i], leaf[i].getString("title")); //go deeper by a level
    }
  }
  if (xmlpages) { //didnt know if I needed to do the same for xmlpages so the boolean sets it
    for (int i=0; i < xmlLeaf.length; i++) { //same thing as above
      //println(xmlLeaf[i].getString("title"));
      if (getPage(xmlLeaf[i], xmlLeaf[i].getString("title")) == null) {
        pages.add(new Page(xmlLeaf[i].getString("title"), parent));
      } else {
        getPage(xmlLeaf[i], xmlLeaf[i].getString("title"));
      }
    }
  }
  return null;
}

void drawMap(Page parent, int level, int start, int end, int x, int y) { //this one is real stupid
  for (int k = 0; k < parent.childrenName().size(); k++) { //more recursion
    int adjh = y+209-k*15; //adjustment for height of branches
    int adjx = int(start + k*(end-start)/parent.childrenName().size())+100; //adjustement for x value
    stroke(200);
    if (parent.childrenName().size()> 15) { //these if statements are specific conditions such as not going off screen
      adjh=y+150+k*12;
      adjx = int(start + k*(end-start)/parent.childrenName().size())+100;
      start = -140;
      end = width-130;
    }
    if (level+80+k*17 < y) {
      level = y;
    }
    if (parent.name().equals("Machine Information")) {
      adjh-=50;
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
    //println(parent.name());
    if ((parent.name().equals("Reporting"))||(parent.name().equals("Production"))||(parent.name().equals("System"))||(parent.name().equals("Access"))) {     
      line(width/2, 150, adjx, adjh);
    } else if ((parent.name().equals("Device_01"))) {
      adjh = 100;
    } else {
      stroke(200);
      line(x, y, adjx, adjh);
    } //back to important stuff. 
    parent.children().get(k).storeNode(adjx, adjh); //stores the x,y adjustment values 
    parent.children().get(k).storeLen(int(parent.children().get(k).name().length()*6.5)); //finds the length of the string, useful for boxes
    fill(0);
    text(parent.children().get(k).name(), adjx, adjh); //write text to screen
    drawMap(parent.children().get(k), level+100, adjx-width/7, adjx+width/80, adjx, adjh); //recursion again and again and again and again 
  }
}

void familyTree() { //goes through parents children names and adds them as objects. For easier data access within the object itself
  for (int x = 0; x < pages.size(); x++) {
    for (int y = 0; y < pages.size(); y++) {
      if (pages.get(x).name() == pages.get(y).parent()) {
        pages.get(x).addChild(pages.get(y));
      }
    }
  }
}
 
void setTable() { //populates the table/csv file with the current pages
  for (int i = 0; i<pages.size(); i ++) {
    pgStore.add(nodes.addRow());
    pgStore.get(i).setString("name", pages.get(i).name());
    pgStore.get(i).setString("parent", pages.get(i).parent());
    pgStore.get(i).setInt("x", pages.get(i).x());
    pgStore.get(i).setInt("y", pages.get(i).y());
  }
}

void mouseDragged() { //for drag and drop of the nodes. Currently works for fullrun and not fullrun
  
  loop(); //loop is manually turnd on so that the coordinates update
  for (int p = 0; p < pages.size(); p ++) { //this is veeeerrrrry stupid and innefficient but this works for now
    //println(mouseX > pages.get(p).x(), mouseY > pages.get(p).y()-10, pages.get(p).leng());
    if ((mouseX > pages.get(p).x())&&(mouseY > pages.get(p).y()-10)&&(mouseX < (pages.get(p).x()+pages.get(p).leng()))&&(mouseY < pages.get(p).y())) { //checks to see the mouse is inside the box
      //println("truu");
      pages.get(p).storeNode(mouseX-pages.get(p).leng()/2, mouseY+4); //stores new x,y coordinates 
      pages.get(p).storeLen(pages.get(p).leng()); //I regret having to include so much info in the objects
      if (!fullRun){ //choose whether to set csv or change csv based on run type
        pgStore.get(p).setInt("x", pages.get(p).x());
        pgStore.get(p).setInt("y", pages.get(p).y());
      } else{
        nodes.getRow(p).setInt("x", pages.get(p).x());
        nodes.getRow(p).setInt("y", pages.get(p).y());
      }
      pages.get(p).drawLine(); //redraws objects 
      pages.get(p).drawNode();
    }
  }
}

void mouseReleased() {
  noLoop(); //kills looping if boolean mouseReleased is false
}

void keyPressed() { //once enter is pressed, draw loops one more time, record = true and the program is closed
  if (keyCode == ENTER) {
    loop();
    record = true;
  }
}