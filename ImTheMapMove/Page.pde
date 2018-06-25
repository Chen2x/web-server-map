
class Page {
  String name;
  String parent;
  int x, y, leng;
  ArrayList<Page> children = new ArrayList<Page>();
  ArrayList<String> childrenName = new ArrayList<String>();
  

  Page(String n, String p) {
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

  void addChild(Page newChild) {
    children.add(newChild);
    childrenName.add(newChild.name());
  }

  void storeNode(int xp, int yp) {
    x = xp;
    y = yp;   
    leng = int(name.length()*6.5);
    //save.setString("name", name);
    //save.setInt("x", x);
    //save.setInt("y", y);
  }
  
  void storeLen(int len){
    leng = len;
    
  }

  void drawNode() {
    if (name != "Device_01") {
      fill(0, 150, 240, 40);
      rect(x, y, leng, -10);
      fill(0);
      text(name, x, y);
    }
  }

  void drawLine() {    

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

  void toChildren() {
    //for (int i = 0; i<
  }
}