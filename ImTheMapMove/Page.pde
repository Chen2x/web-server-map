
class Page{
  String name;
  String parent;
  int x, y, leng;
  ArrayList<Page> children = new ArrayList<Page>();
  ArrayList<String> childrenName = new ArrayList<String>();
  
  Page(String n, String p){
    name = n;
    parent = p;
  }
  
  String name(){
    return name;
  }
  String parent(){
    return parent;
  }
  
  ArrayList<Page> children(){
    return children;
  }
  
  ArrayList<String> childrenName(){
    return childrenName;
  }
  
  void addChild(Page newChild){
    children.add(newChild);
    childrenName.add(newChild.name());
  }
  
  void storeNode(int xp, int yp, int len){
    leng = len;
    x = xp;
    y = yp;
    //fill(0, 150, 240, 40);
    //rect(x, y, len, -10);
    //fill(0);
    //text(name, x, y);
  }
  
  void drawNode(){
    fill(0, 150, 240, 40);
    rect(x, y, leng, -10);
    fill(0);
    text(name, x, y);
  }
  
  int x(){
    return x;
  }
  
  int y(){
    return y;
  }
  
  int leng(){
    return leng;
  }
  
  void toChildren(){
    //for (int i = 0; i<
  }
  
}