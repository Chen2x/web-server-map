
class Page { //stores page as an object
  String name;
  String parent;
  int x, y, leng;
  ArrayList<Page> children = new ArrayList<Page>();
  ArrayList<String> childrenName = new ArrayList<String>(); //kind of redundant but it allows the children to be gotten later
  

  Page(String n, String p) { //params
    name = n;
    parent = p;
    
  }
  //TableRow save = nodes.addRow();
  
  
  String name() {
    return name;
  }
  String parent() {
    return parent;
  }

  ArrayList<Page> children() {
    return children;
  }

  ArrayList<String> childrenName() {
    return childrenName;
  }

  void addChild(Page newChild) { //adds a child to the arraylist as a page
    children.add(newChild);
    childrenName.add(newChild.name());
  }

  void storeNode(int xp, int yp) { //xy coordinates
    x = xp;
    y = yp;   
    leng = int(name.length()*6.5); //just here for now because it needs to be set for drag and drop to work
    //save.setString("name", name);
    //save.setInt("x", x);
    //save.setInt("y", y);
  }
  
  void storeLen(int len){ //length of the name
    leng = len;
    
  }

  void drawNode() { //actually draws the boxes and text 
    if (name != "Device_01") {
      fill(0, 150, 240, 40);
      rect(x, y, leng, -10);
      fill(0);
      text(name, x, y);
    }
  }

  void drawLine() { //draws the lines by using the parent x,y and the arraylsit children x,y   

    for (int i=0; i<children.size(); i++) {
      if ((name().equals("Reporting"))||(name().equals("Production"))||(name().equals("System"))||(name().equals("Access"))) {     
        stroke(200);
        line(width/2, 150, children.get(i).x(), children.get(i).y());
      } else if ((name().equals("Device_01"))) {
        y = 100;
      } else {
        stroke(200);
        line(children.get(i).x(), children.get(i).y(), x, y);
      }
    }
  }

  int x() {
    return x;
  }

  int y() {
    return y;
  }

  int leng() {
    return leng;
  }
}