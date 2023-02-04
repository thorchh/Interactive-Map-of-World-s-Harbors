PImage mapimg;

int infRadius = 5;
float zoom = 1;
float infXX = 0;
float infYY =0;
float infRate = 0.7;

int clat = 0;
int clon = 0;

int width = 1024;
int height = 512;

Table ports = new Table();
Port[] portsS;

float mercX(float lon){
  lon = radians(lon);
  float a = ((height)/(2*PI)) * pow(2,zoom);
  float b = lon+ PI;
  return a*b;
}

float distance(float x1, float y1, float x2, float y2){
  return sqrt((pow(x2-x1,2))+ pow(y2-y1,2));
}

float mercY(float lat){
  lat = radians(lat);
  float a = ((height)/(2*PI)) * pow(2,zoom);
  float b = tan(PI/4 + lat/2);
  float c = PI - log(b);
  return a*c;
}

boolean overCircle(float x, float y, float infX, float infY) {
  float disX = x - infX;
  float disY = y - infY;
  if(sqrt(sq(disX) + sq(disY)) < infRadius ) {
    return true;
  } else {
    return false;
  }
}



public class Port{
  String portName;
  boolean infState;
  float portX;
  float portY;
  int portRow;
  int portSize;
  
  boolean getState(){
    return infState;
  }
  float getX(){
    return portX;
  }
  float getY(){
    return portY;
  }
  String getName(){
    return portName;
  }
  void editState(boolean a){
    infState = a;
  }
  
  public Port(String name, boolean state, float x, float y, int row, int size) {
    portName = name;
    infState = state;
    portX = x;
    portY = y;
    portRow = row;
    portSize = size;
  }
  
  public void display(){
    if (infState == true){
      fill(255, 255, 255, 200);
    }
    else{
      fill(255, 0, 255, 200);
    }
    
    float mapPortSize = map(portSize,1,5,1,10);
    ellipse(portX,portY,mapPortSize,mapPortSize);

  }
}


public void settings() {
  size(width, height);
}

void setup() {

  
  String url = "https://api.mapbox.com/styles/v1/mapbox/dark-v9/static/0,0," + zoom + "/" + width+ "x"+height +"?access_token=pk.eyJ1IjoidGhvcmMwMDAyIiwiYSI6ImNranpoNmU5YzA3Y3Uyb3QxaWxldnE2cDkifQ.2mD8ja1bfnnZqNnH5qtb2w";
  mapimg = loadImage(url, "jpg");
  println(url);
  ports = loadTable("https://geonode.wfp.org/geoserver/wfs?typename=geonode%3Awld_trs_ports_wfp&outputFormat=csv&version=1.0.0&request=GetFeature&service=WFS", "csv,header");
  
  translate(width / 2, height / 2);
  imageMode(CENTER);
  image(mapimg, 0, 0);
  
  float cx = mercX(clon);
  float cy = mercY(clat);
  
  
  portsS = new Port[ports.getRowCount()];
  
  
  for (int i=0; i < ports.getRowCount(); i++) {
    float lat = ports.getFloat(i,"latitude");
    float lon = ports.getFloat(i,"longitude");
    float x = mercX(lon) - cx;
    float y = mercY(lat) - cy;
    
    //println(i, mercX(lon), portsS.length);
    
    String name = ports.getString(i,1);
    boolean state = false;
    int portSize;
    if (ports.getString(i,4). equals("Very Small")){
      portSize = 1;
    }
    else if (ports.getString(i,4). equals("Unknown")){
      portSize = 3;
    }
    else if (ports.getString(i,4). equals("Medium")){
      portSize = 3;
    }
    else if (ports.getString(i,4). equals("Small")){
      portSize = 2;
    }
    else if (ports.getString(i,4). equals("Large")){
      portSize = 5;
    }
    else{
      portSize = 4;
    }
    portsS[i] = new Port(name,state,x,y,i,portSize);
  }
  
  for (int i=0; i < ports.getRowCount(); i++){
    portsS[i].display();
  }
    

  }
  
//thor yay :)


public void draw(){
   for (int j = 0; j< ports.getRowCount();j++) {
     
    if ( (int(portsS[j].getY()) == int(mouseY-256))&&(int(portsS[j].getX()) == int(mouseX-512))) {
      println(portsS[j].getName());
      }
    }
    
    //for (int l = 0; l< ports.getRowCount();l++) {
      //if 
      //if (overCircle(infXX, infYY, portsS[l].getX(), portsS[l].getY())){
       // portsS[l].editState(true);
      //}
    //}
}
