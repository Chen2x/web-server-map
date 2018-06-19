
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

  void storeNode(int xp, int yp, int len) {
    leng = len;
    x = xp;
    y = yp;
  }

  void drawNode() {
    fill(0, 150, 240, 40);
    rect(x, y, leng, -10);
    fill(0);
    text(name, x, y);
  }

  void drawLine() {    

    for (int i=0; i<children.size(); i++) {
      if ((name().equals("Reporting"))||(name().equals("Production"))||(name().equals("System"))||(name().equals("Access"))) {     
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