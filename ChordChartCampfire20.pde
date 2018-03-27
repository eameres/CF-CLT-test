 
PFrame f;
secondApplet s;
import java.awt.Frame;

//int[][][] myColors;
int interval;
int target = 0;
int difficultyLevel = 3;
int vStart = 0;
String resultTxt = "";

final static String[] kLetters = {
  "N1", "O1", "P1", "Q1", "R1", "S1", "T1", "U1", "V1", "W1", "X1", "Y1", "Z1", 
  "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
  "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
  "A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1", "J1", "K1", "L1", "M1",
};

int[] mArr = { 0,1,0,1,0,1,0,1,0,1 };

boolean initialized = false;
boolean matching = false;
int[] freq;
int[] pattern;

final static String countFileDirectory = "";  // implicitly "data" for Processing (Java)
// final static String countFileDirectory = "letterpairs/";  // for direct Processing.js deployment

// Number of lines in the data file heading
final static int HEADING_LINES = 3;

ChordChart chart;
static color[] colorSpectrum;
static int[][] fourColors;
static int numRings = 5;

String[] str = new String[0];
int nInt;
boolean wall = true;
boolean floor = true;
boolean started = false;
boolean askEffort = false;
boolean labels = false;

static final byte PATTERN = 0, LEVEL = 1, NBACK1 = 2, NBACK2 = 3, NBACK3 = 4, NBACK4 = 5;

int countMode = 100;
static final int mTrials = 4;

int countViz = 100;
static final int trials = 10;

static final int patterns = 12;

boolean highlightKey[];

byte mode = PATTERN;

DisposeHandler dh;

boolean sketchFullScreen() {
  return true;
}

boolean initViz = false;
long seedCounter = 0;

int pttrnDistance(int a,int b)
{
 int dist = 0;
 a =  pattern[a];
 b =  pattern[b];
 
  for (int i = 0; i < numRings;i++){
    dist  += (fourColors[i][a] != fourColors[i][b]) ? 1: 0;
    //println("fc "+a+","+b+","+fourColors[i][a]+","+fourColors[i][b]);
  }
  //println("distance "+dist);
  return(dist);
}


void nextViz(){
    
  IntList inventory;
  String string1 = "", string2="", stringa="",stringc="";
  int nShades = 5;
  
  if (askEffort)
    return;
  
  if (countViz++ >= trials){
      if (started)
        askEffort = true;
      
      if ((countMode % 2) == 0){
        floor ^= true;
        wall ^= true;
      }
      
      if (mode == PATTERN)
        mode = LEVEL;
      else
        mode = PATTERN;
        
      countViz = 1;
      
      if (countMode++ >= mTrials){
        
        ++seedCounter;
        str = append(str,millis()+ ", newseed, "+ countViz +", "+countMode+","+seedCounter);
        countMode = 1;
        
        for (int i = 1; i < mArr.length; i++) 
        {
         int j = int(random(0, i+1)); 
         int temp = mArr[i];
         
         mArr[i] = mArr[j]; 
         mArr[j] = temp; 
        }
      }
      
      str = append(str,millis()+ ", newseed, reseed, "+ countViz +", "+countMode+","+seedCounter);
      randomSeed(seedCounter);
      

   }
   
  
  vStart = millis();
  
  for(int i= 0; i < 52; i++)
    highlightKey[i] = false;
  
  numRings = 5; //min(12,6 + difficultyLevel);
  if (mode == LEVEL)
    numRings *= 2;
  
  /*  
  inventory = new IntList();
  
  for(int i = 0; i < numRings;i++)
    inventory.append(i%nShades);
    
  inventory.shuffle(this);
  */
  int[] myArr;
  myArr = new int[nShades];
  
  
  for(int i = 0; i < myArr.length; i++)
    myArr[i] = i;
  
  for (int i = 1; i < myArr.length; i++) 
  {
   int j = int(random(0, i+1)); 
   int temp = myArr[i];
   
   myArr[i] = myArr[j]; 
   myArr[j] = temp; 
  }
  
   
  str = append(str,millis()+ ", nextViz() called, "+ key);
  str = append(str,millis()+ ", floor-wall, "+ floor + ","+ wall);
  str = append(str,millis()+ ", mode, "+ ((mode==PATTERN)?"pattern":"level"));
  str = append(str,millis()+ ", counters, "+ countViz +", "+countMode+","+seedCounter);
  
  for(int i = 0; i < numRings; i++){
      //fourColors[i][0] = (int)((255/(nShades-1))*inventory.get(i));
      fourColors[i][0] = (int)((255/(nShades-1))*myArr[i%nShades]);
     }
  
  for(int j = 1; j < patterns; j++){   
    for(int i = 0; i < numRings; i++){
      fourColors[i][j] = fourColors[i][0];
    }
    //for(int i = 4; i < numRings; i++){
      fourColors[(j+1)%numRings][j] = fourColors[j%numRings][0];
      fourColors[j%numRings][j] = fourColors[(j+1)%numRings][0];
      
    if (j > patterns/2){
      fourColors[(j+3)%numRings][j] = fourColors[(j+2)%numRings][0];
      fourColors[(j+2)%numRings][j] = fourColors[(j+3)%numRings][0];
    }
  }
  /*
  //for(int i = 2; i < numRings-2; i++)
  {
    int i = (int)random(numRings-2)+2;
    for(int j = 0; j < patterns/2; j+=2){
      fourColors[i][j+patterns/2] = (int)fourColors[i+1][0];
      fourColors[i+1][j+patterns/2] = (int)fourColors[i][0];
    }    
  }*/
  
  if (mode == PATTERN){
    for(int j = 0; j < patterns; j++){
      stringc = "";
       for(int i = 0; i < numRings; i++){
        stringc += "," + fourColors[i][j];
      }
      str = append(str,millis()+ ", pattern, "+ j + stringc);
    }
  }
  
  int lastRR = -1;
  int lastFF = -1;
  int rr ;
  int ff ;
  int first = -1;
  
  for(int j = 0; j < 52; j++){
    
    ff = (int)((random(1)*(float)numRings)/3);
    //println(ff);
          
    if (lastFF == ff)
      ff = (ff + 1) % numRings/3;
    
    freq[j] = ff + (numRings/2);
    lastFF = ff;
    
    /*   
    if (random(10) < 8)
      pattern[j] = (int)random(patterns-1); 
    else
      pattern[j] = 0;
    */
    
    rr = (int)random(patterns-1);
    
    if (first == -1)
      first = rr;
    
    if (lastRR == rr)
      rr = (rr+1) % 4;
      
    if (random(10) < 8)
      pattern[j] = rr;
    else
      pattern[j] = 0;
      
    lastRR = rr;
  }
  
  stringa = "lttr";
  string1 = "freq";
  string2 = "pttn";
  
  for (int i = 0; i < kLetters.length; i++){
    stringa = stringa + "," + kLetters[i];
    string1 = string1 + "," + freq[i];
    string2 = string2 + "," + pattern[i];
  }
  str = append(str,millis()+ ", New Visualization ");
  str = append(str,millis()+ ","+stringa);
  str = append(str,millis()+ ","+string2);
  str = append(str,millis()+ ","+string1);
}
void setup() {
  String[] fName;
  PFrame f = new PFrame();
  highlightKey = new boolean[52];

  if (displayWidth == 1440)
    size(720, 720);
  else{
    size(1080, 1080);
    f.setLocation(-8,-32);
  }
  //f.setUndecorated(true);
  
  dh = new DisposeHandler(this);

  if (random(2) > 1){
    wall = true;
    floor = false;
  }else{
    wall = false;
    floor = true;
  }

  randomSeed(0);
  fName = loadStrings("trialCount.txt");
  
  if (fName != null)
    nInt = int(fName[0]);
  else nInt = 0;
  
  str = append(str,millis()+ ", Starting Up(), " + month() +"/" + nf(day(),2) +"/" + year() + " , "+hour()+":"+nf(minute(),2)+":"+nf(second(),2));
  str = append(str,millis()+ ", starting Trial, "+nInt);
  str = append(str,millis()+ ", Random Seed," + 0 );
  
  //myColors = new int[numRings][72][3];
  fourColors = new int[256][64];
  freq = new int[52];
  pattern = new int[52];

  //preseed patterns
  
  /*
  for (int j = 0; j < 52; j++){   
    if (random(10) < 8)
      pattern[j] = (int)random(patterns-1); 
    else
      pattern[j] = 0;
  }
  */
  nextViz();
//  size(1000, 820);

  // Define the color pallette to be used when creating the chords
  colorSpectrum = colorSpectrum2();
//  colorSpectrum = colorSpectrum1();
  
  // Create the chart and legend
  createChart("info-retr.counts");
  
  smooth();
  
  // Keep the frame rate low, the chord chart is expensive to redraw
  frameRate(10);
  //s.frameRate(10);
  if ((mode == NBACK1) || ( mode == NBACK2) || ( mode == NBACK3))
    interval = 30;
  else
    interval = 90;
    
  initialized = true;

}

void draw() {
  background(204);
  //drawChartTitle();
  chart.draw();
  //legend.draw();
  s.redraw();
}

void dumpStrings(){
  
  if (str.length > 0){
    String[] nameX = new String[1];
    
    nameX[0] = ""+(++nInt);
    saveStrings("trial"+nInt+".csv", str);
    saveStrings("trialCount.txt", nameX);
    str = new String[0];
  }
}

int numAsked = 1;

void kp(char kpKey,int wKey){
  
  if (!started){
    started = true;
    target = 10;
    vStart = millis();
    return;
  }
  
  if (askEffort){
    vStart = millis();
    if ((kpKey == ENTER)){
      
      if (numAsked > 3){
        askEffort = false;
        numAsked = 0;
      }
      
      numAsked++;
        
      if (resultTxt.length() >= 1)
        str = append(str,millis()+ ",message, "+resultTxt);
      resultTxt = "";
    }else{
      if ((kpKey >= ' ') && (kpKey <= '~')){
        resultTxt += kpKey;
        return;
      }
      if (kpKey == BACKSPACE){
        resultTxt = resultTxt.substring(0,resultTxt.length()-1);
        return;
      }
    }
  }
  
  str = append(str,millis()+",kp"+(matching?",m":",n")+ (wall?",w,":",f,")+"keypress, "+wKey+","+ kpKey+","+(millis()-vStart));
  
  //if( kpKey == ' ')
  //  nextViz();
  
  if ((kpKey >= 'a') && (kpKey <= 'z')){
    highlightKey[kpKey - 'a'] ^= true;
    str = append(str,millis()+ ",alpha, "+wKey+","+ kpKey+","+ highlightKey[kpKey - 'a']);
    target = 0;
  }
  
  if ((kpKey >= '0') && (kpKey <= '9'))
    target = 0;
  
  switch(kpKey){
    case TAB:
    case ESC:
      dumpStrings();
      break;
    case ' ':
      target = 0;
      break;
      /*
    case '1':
      mode = PATTERN;
      interval = 50*3;
      str = append(str,millis()+ ", MODE CHANGE, PATTERN");
      target = 0;
      break;
    case '2':
      mode = LEVEL;
      interval = 50*3;
      str = append(str,millis()+ ", MODE CHANGE, LEVEL");
      target = 0;
      break;
      */
    case ',':
      wall ^= true;
      str = append(str,millis()+ ", WALL, " + (wall ? "ON" : "OFF"));
      break;
    case '.':
      floor ^= true;
      str = append(str,millis()+ ", FLOOR, " + (floor ? "ON" : "OFF"));
      break;
    case '+':
      difficultyLevel++;
      str = append(str,millis()+ ", difficultyLevel, " + difficultyLevel);
      target = 0;
      break;
    case '-':
      difficultyLevel--;
      str = append(str,millis()+ ", difficultyLevel, " + difficultyLevel);
      target = 0;
      break;    
    case '>':
      interval++;
      str = append(str,millis()+ ", interval, " + interval);
      break;
    case '<':
      interval--;
      str = append(str,millis()+ ", interval, " + interval);
      break;
    default:
      break;
  }
}

void keyPressed() { // Press a key to save the data
  kp(key,0);
}

void drawChartTitle() {
  String title = "Frequency of English Language Letter Pairs";
  pushStyle();
  fill(20);
  textSize(24);
  textAlign(CENTER, BOTTOM);
  text(title, width / 2.0, 40.0);
  popStyle();
}

/**
 * Build the chart and the associated color legend panel.
 */
void createChart(String countFile) {
  // Create an instance of ChordChart
  chart = new ChordChart((int)(height / 2) - (labels?20:0) , kLetters);
  
  defaultChords();
}

color[] colorSpectrum1() {
  pushStyle();
  colorMode(HSB, 360, 100, 100);
  color[] colors = new color[]{
    color(330, 80, 80),
    color(270, 80, 80),
    color(210, 80, 80),
    color(150, 80, 80),
    color(90, 80, 80),
    color(30, 80, 80)
  };
  popStyle();
  return colors;
}

color[] colorSpectrum2() {
  pushStyle();
  colorMode(HSB, 360, 100, 100);
  color[] colors = new color[]{
    color(210, 80, 80),
    color(210, 80, 30),
    color(210, 80, 30),
    color(120, 80, 80),
    color(90, 80, 80),
    color(60, 80, 80),
    color(30, 80, 80),
    color(0, 80, 80)
  };
  popStyle();
  return colors;
}

color[] colorSpectrum3() {
  pushStyle();
  colorMode(HSB, 360, 100, 100);
  color[] colors = new color[]{
    color(330, 80, 80),
    color(300, 80, 80),
    color(270, 80, 80),
    color(240, 80, 80),
    color(210, 80, 80),
    color(180, 80, 80),
    color(150, 80, 80),
    color(120, 80, 80),
    color(90, 80, 80),
    color(60, 80, 80),
    color(30, 80, 80)
  };
  popStyle();
  return colors;
}

void defaultChords(){
  
  if (true){
    int p,q;
    for (p = 0+13; p < 26+13;p++)
      if (pattern[p] == 0)
        break;
        
   //if (random(10) > 5){
   if (mArr[countViz-1] == 1){
     matching = true;
    str = append(str,millis()+ ",m, match");
     for (q = 25+13; q > 0; q--)
        if (pattern[q] == 0)
          break;
   }else{
     matching = false;
    str = append(str,millis()+ ",m, no-match");
     for (q = 25+13; q > 0; q--)
        if (pattern[q] != 0)
          break;
   }
   
    str = append(str,millis()+ ",TestPair, "+ p+","+q+","+ pattern[p]+","+pattern[q]+","+(matching?",m":",n")+","+countViz+","+ pttrnDistance(p,q)+","+ (freq[p]-freq[q]));
    chart.addChord(kLetters[p], kLetters[q],colorSpectrum[0],6);
    
    for (int i = 0; i < 6; i++)
        chart.addChord(kLetters[(int)random(52)], kLetters[(int)random(52)],colorSpectrum[2],6);

  }else{
  String first = kLetters[10+(int)random(7)]; // should be k,l,m,n or o
  
  for (int i = 0; i < 1; i++){
    chart.addChord(first, kLetters[19+ (int)random(7)],colorSpectrum[0],6);
    chart.addChord(first, kLetters[ (int)random(7)],colorSpectrum[0],6);
  }  
  if (false) // distractor chords 
    if (difficultyLevel > 4){
      for (int i = 0; i < difficultyLevel-3; i++)
        chart.addChord(kLetters[(int)random(26)], kLetters[(int)random(26)],colorSpectrum[0],6);
    }
  }
}
class Chord {
  String _label1;
  String _label2;
  float _angle1;
  float _angle2;
  int _index1;
  int _index2;
  float _thickness = 0.3;
  color _color = color(250);
  color _highlightColor = color(250);
  
  Chord(String label1, String label2, float angle1, float angle2, color clr, float thickness) {
    _label1 = label1;
    _label2 = label2;
    _angle1 = angle1;
    _angle2 = angle2;
    _color = clr;
    _thickness = thickness;
  }
    
  Chord(String label1, String label2, float angle1, float angle2, color clr, float thickness,int i1, int i2) {
    _label1 = label1;
    _label2 = label2;
    _angle1 = angle1;
    _angle2 = angle2;
    _index1 = i1;
    _index2 = i2;
    _color = clr;
    _thickness = thickness;
  }
  Chord(String label1, String label2, float angle1, float angle2, color clr) {
    _label1 = label1;
    _label2 = label2;
    _angle1 = angle1;
    _angle2 = angle2;
    _color = clr;
  }
  
  Chord(String label1, String label2, float angle1, float angle2) {
    _label1 = label1;
    _label2 = label2;
    _angle1 = angle1;
    _angle2 = angle2;
  }

  void draw(int xc, int yc, int radius, boolean highlight, int dSub,float aOff,float xOff) {
    pushStyle();
    
    // Tension: from 0.0 to 1.0, larger value brings chords
    // further from center
    float tension = 0.750;
    float adjAngle = 1.0;
    
    if (!floor){
      adjAngle = .66;
      //aOff += PI/208.0;
    }
    float x1 = xc + radius * cos(_angle1*adjAngle+aOff);
    float y1 = yc + radius * sin(_angle1*adjAngle+aOff);

    float x2 = xc + tension * radius * cos(_angle1*adjAngle+aOff);
    float y2 = yc + tension * radius * sin(_angle1*adjAngle+aOff);

    float x3 = xc + tension * radius * cos(_angle2*adjAngle+aOff);
    float y3 = yc + tension * radius * sin(_angle2*adjAngle+aOff);

    float x4 = xc + radius * cos(_angle2*adjAngle+aOff);
    float y4 = yc + radius * sin(_angle2*adjAngle+aOff);

    noFill();
    stroke(_color);
    strokeWeight(_thickness);
    s.noFill();
    s.stroke(_color);
    s.strokeWeight(_thickness/2);
    
    if ( highlight ) {
      stroke(_highlightColor);
      strokeWeight(2);
      // strokeWeight(2 * _thickness);
    }    
    //if (floor)
    {
      strokeCap(SQUARE);
      bezier(x1, y1, x2, y2, x3, y3, x4, y4);
      // line(x1, y1, x4, y4);
    }
    
    //if (wall)
    {
      s.strokeCap(SQUARE);
          /*{
            int xCalc;
            s.noStroke();
            xCalc = (_labels.length-i-1)*(s.width/_labels.length)+1;
            xCalc += xOffset;
            xCalc %= s.width;
            s.rect(xCalc,(numRings-j-1)*((s.height-65)/numRings)+21,(s.width/_labels.length)-1,((s.height-65)/numRings)-1);
            if ((xCalc + (s.width/_labels.length)-1) > s.width)
              s.rect(xCalc-s.width,(numRings-j-1)*((s.height-65)/numRings)+21,(s.width/_labels.length)-1,((s.height-65)/numRings)-1);
          }*/  

      
      //s.bezier(_index1*dSub + (dSub/2)+5, s.height - 50, _index1*dSub+ (dSub/2)+5, s.height,   _index2*dSub+ (dSub/2)+5, s.height, _index2*dSub+ (dSub/2)+5, s.height - 50);
    }
    popStyle();
  }
  
  String getLabel1() { return _label1; }
  String getLabel2() { return _label2; }
  
  float getAngle1() { return _angle1; }
  float getAngle2() { return _angle2; }
  
  String toString() {
    return _label1 + "-" + _label2;
  }
}

class ChordChart {
  int _xc;
  int _yc;
  int _radius;
  int _gRadius;
  int _bRadius;

  Chord[] _chords = new Chord[0];  
  String[] _labels;

  color _backgroundColor = color(20);
  color _labelTextColor = color(0);
  color _labelBackgroundColor = color(205);
  color _labelHighlightTextColor = color(255);
  color _labelHighlightBackgroundColor = color(140);
  int   _labelCornerRadius = 3;
  
  // Labels around edge of ChordChart
  PFont  _labelFont;
  int    _labelMargin = 10;
  int    _labelSize = 16;
  String _textFamily = "Helvetica";

  float _angleClose = PI / 12.0;  // For measuring closeness to mouse

  // Region of chart that is mouse sensitive
  final float _minMouseOverRadiusPct = 0.70;
  float _innerMouseOverRadius;
  float _outerMouseOverRadius;

  /** Create a new chart */
  ChordChart(int x, int y, int radius, String[] labels) {
    _xc = x;
    _yc = y;
    //_radius = (int)((radius*1.33)/3);
    //_bRadius = (int)((radius*1.66)/3);
    _radius = (int)((radius*2)/3);
    _bRadius = (int)((radius*1)/3);
    _innerMouseOverRadius = _minMouseOverRadiusPct * radius;
    _outerMouseOverRadius = radius + _labelMargin + _labelSize;
    _labels = labels;
    _labelFont = createFont(_textFamily, _labelSize, true);
    _angleClose = TWO_PI / (float)labels.length / 2.0;
  }

  /** Create a chart in the center of the window */
  ChordChart(int radius, String[] labels) {
    this(width / 2, height / 2, radius, labels);
  }

  /** Chord with a default color and thickness */
  Chord addChord(String label1, String label2) {
    return addChord(label1, label2, color(250), 0.3);
  }

  /** Chord with a default color */
  Chord addChord(String label1, String label2, color colr) {
    return addChord(label1, label2, colr, 0.3);
  }

  Chord addChord(String label1, String label2, color colr, float thickness) {
    int index1 = indexForLabel(label1);
    int index2 = indexForLabel(label2);
         
    str = append(str,millis()+ ", Adding Chord, "+ label1+","+label2);

    // Index not found for some label
    if ( (index1 < 0) || (index2 < 0) ) return null;

    float angle1 = labelAngle(index1);
    float angle2 = labelAngle(index2);

    Chord c = new Chord(label1, label2, angle1, angle2, colr, thickness,_labels.length-index1-1,_labels.length-index2-1);
    _chords = (Chord[])append(_chords, c);
    return c;
  }

  int indexForLabel(String label) {
    for ( int i=0; i < _labels.length; i++ ) {
      if ( _labels[i].equals(label) ) {
        return i;
      }
    }
    println("Warning: No chord found for label \"" + label + "\"");  // debugging
    return -1;
  }

  void draw() {
    // Draw the filled circle
    pushStyle();
    fill(_backgroundColor);
    ellipseMode(RADIUS);
    //ellipse(_xc, _yc, _radius, _radius);
    ellipse(_xc, _yc, height/2+4,height/2+4);
    
    colorMode(HSB); 
    s.colorMode(HSB);
    
    s.fill(0,0,0);
    s.rect(0, 0, s.width, s.height);
     
    //s.fill(0,0,204);
    //s.rect(0, ((s.height/3)-12), s.width, s.height);
    
    //s.fill(0,0,0);
    //s.rect(0, ((s.height/3)-12)+_labelSize*2, s.width, s.height);
    popStyle();
    
    if (!started){
      textSize(32);
      textAlign(CENTER, CENTER);
      
      translate(_xc,_yc-48);
      //rotate(HALF_PI);                       // rotate the text by 90 degrees
    
      //text("For Patterns: ", 0, -96);                   // move to the center of the circular chart  
      text("press 0 if connected patterns/bars match", 0, -64);       // move to the center of the circular chart  
      text("press 1 if they are slightly different", 0, -32);       // move to the center of the circular chart 
      text("press 2 if they are very different", 0, +0);       // move to the center of the circular chart  
      //text("press 3 etc...", 0, +32);       // move to the center of the circular chart   
      
      translate(0,12);
      
      //text("For Bars: ", 0, 64);                   // move to the center of the circular chart  
      //text("press 0 if connected levels match", 0, 96);       // move to the center of the circular chart  
      //text("press 1 if connected levels do not match", 0, 128);       // move to the center of the circular chart 
      text("Timing is part of your score.  Good Luck !", 0, +172);       // move to the center of the circular chart  
      return;
    }
    
    if (askEffort){
      colorMode(HSB);
      textSize(32);
      translate(_xc,_yc-112);
      //rotate(HALF_PI);                       // rotate the text by 90 degrees
    
      fill(0,0,255);
      textAlign(CENTER, CENTER);
      
      if (numAsked == 1){
        text("On a scale of 1-9,", 0, 0);        // move to the center of the circular chart  
        text("How much Mental effort did that take?", 0, 32);       // move to the center of the circular chart  
        text("1 very,very easy, 5 middle, 9 very,very hard", 0, 64);       // move to the center of the circular chart  
      }else if (numAsked == 2){
        text("On a scale of 1-9,", 0, 0);        // move to the center of the circular chart  
        text("How difficult was it to come to a confident conclusion?", 0, 32);     // move to the center of the circular chart  
        text("1 very,very easy, 5 middle, 9 very,very hard", 0, 64);       // move to the center of the circular chart  

    }else if (numAsked == 3){
      text("On a scale of 1-9,", 0, 0);        // move to the center of the circular chart          
      text("How difficult was it to remember the patterns ?", 0, 32);     // move to the center of the circular chart  
      text("1 very, very easy, 5 middle, 9 very,very hard", 0, 64);       // move to the center of the circular chart  
      
    } else {
      text("Anything else you wish to add? (enter to continue) ", 0, 0);        // move to the center of the circular chart  
    }
      textSize(20);
      text(resultTxt, 0, 96);       // move to the center of the circular chart  
      //askEffort = false; 
      return;
    }

    // Draw each of the letter labels
    drawLabels();
    
    if (askEffort)
      return;
      
      
    if ((mode == PATTERN) || (mode == LEVEL)){
      // Draw the chords between letters
      for (int i = _chords.length-1; i >= 0; i-- ) {
        Chord c = _chords[i];
  
        _chords[i].draw(_xc, _yc, _radius+(floor?0:_bRadius), false,s.width/_labels.length,angleOffset,xOffset);
     }
     pushStyle();
     noFill();
     strokeWeight(2);
     stroke(128,128,128);
     ellipse(_xc,_yc,((_radius+(floor?0:_bRadius))*2)-2,((_radius+(floor?0:_bRadius))*2)-2);
     if ((millis() - vStart) > 5000){
       textSize(20);
       text(str((millis() - vStart)/1000), _xc, _yc);       // move to the center of the circular chart  
     }
     popStyle();
    }
  }
  
  float angleOffset = PI*.48;
  float xOffset = 0.0;
  
  void drawLabels() {
    boolean changed;
    
    //if (frameCount > target){
    if (1 > target){
      nextViz();
      target = frameCount + interval;
      changed = true;
      _chords = new Chord[0];  
      defaultChords();
    }else
      changed = false;
    
    if (askEffort)
      return;
    
    //angleOffset += PI/60;
    //xOffset += s.width/120;
    
    pushStyle();
    
    int ringWidth = _bRadius / numRings;
    
    colorMode(HSB); 
    s.colorMode(HSB); 
    
    float adjAngle = 1.0;
    
    if (!floor){
      angleOffset = PI*10.0/12.0;//PI*1.16;
      adjAngle = .66;
    }else
      angleOffset = PI * .48;
     
     for ( int i = 0; i < _labels.length; i++ ) {
       float angle = labelAngle(i)*adjAngle+angleOffset;
         
        pushMatrix();
        translate(_xc, _yc);                   // move to the center of the circular chart        
        
        noFill();
        strokeWeight(ringWidth);
        strokeCap(SQUARE);
        
        if (highlightKey[_labels[i].charAt(0)-'A'])
          s.fill(0,0,255);
        else
          s.fill(0,0,0);
          
        s.noStroke();
        
        for ( int j = 0 ; j < numRings; j++){ 
          strokeWeight(ringWidth-1);
          
          switch (mode){
            case PATTERN:
             if((_chords[0]._index1 == (_labels.length-i-1)) || (_chords[0]._index2 == (_labels.length-i-1)) || (countViz <= trials/2)){
                stroke(0,0,fourColors[j][pattern[i]]);
                s.fill(0,0,fourColors[j][pattern[i]]);
             }else{
                stroke(0,0,fourColors[j][pattern[i]]/4);
                s.fill(0,0,fourColors[j][pattern[i]]/4);
             }
              break;
            case LEVEL:
              if (freq[i] > j){
                stroke(0,0,64);
                s.fill(0,0,64);
              }else{
                if((_chords[0]._index1 == (_labels.length-i-1)) || (_chords[0]._index2 == (_labels.length-i-1)) || (countViz <= trials/2)){             
                  stroke(0,0,250);
                  s.fill(0,0,250);
                }else{
                  stroke(0,0,250/2);
                  s.fill(0,0,250/2);
                }
              }
              break;
           }
          
          if (floor){
            //arc(0,0,(ringWidth*(j+.5)+_radius)*2+_labelSize*2,(ringWidth*(j+.5)+_radius)*2+_labelSize*2,.001+angle-(PI/_labels.length),angle-.002 + PI/_labels.length);
            arc(0,0,(ringWidth*(j+.5)+_radius)*2,(ringWidth*(j+.5)+_radius)*2,.001+angle-(PI/_labels.length),angle-.002 + PI/_labels.length);
          }
          
          if (wall){
            float xCalc;
            float wallAdjust = 1.0;
            s.noStroke();
            xCalc = (_labels.length-i-1)*((float)s.width/(float)_labels.length)+1;
            if (!floor){
              wallAdjust = 0.66;
              xCalc *= .66;
              xCalc += s.width/6 + ((float)s.width/(float)_labels.length)/3;
            }
            xCalc += xOffset;
            xCalc %= s.width;
            s.rect((int)xCalc+1,((s.height/2)-12)+(numRings-j-1)*((s.height*1/2-(_labelSize*2))/numRings)+(_labelSize*2),(s.width/_labels.length)*wallAdjust-2,((s.height*1/2-(_labelSize*2))/numRings)-1);
            if ((xCalc + (s.width/_labels.length)-1) > s.width)
              s.rect(xCalc-s.width+1,((s.height/3)-12)+(numRings-j-1)*((s.height*2/3-(_labelSize*2))/numRings)+(_labelSize*2),(s.width/_labels.length)*wallAdjust-2,((s.height*2/3-(_labelSize*2))/numRings)-1);
          }  
        }
        popMatrix();
    }
    
    if (wall){
      s.fill(0,0,128);
      s.rect((int)0,((s.height/2)+12),6400,4);
    }
    popStyle();
  }

  float labelAngle(int index) {
    return TWO_PI - TWO_PI * (float)index / (float)_labels.length;
  }
}

public class PFrame extends Frame {
  
    public PFrame() {
        if (displayWidth == 1440)
          setBounds(0,0,640,480);
        else
          setBounds(0,0,6416,840);
        s = new secondApplet();
        add(s);
        
        s.init();
        show();
    }
}

public class secondApplet extends PApplet {
    
    public void setup() {
        if (displayWidth == 1440)
          size(1440,840);
        //else
        //  size(6416,840);
        //fullScreen(1);
        noLoop();
    }

    public void draw() {
        //drawMe();
        //s.redraw();
    }
    public void keyPressed() {
      kp(key,1);
    }
}

 
void stop()
{
  super.stop();
}

public class DisposeHandler
{
  DisposeHandler(PApplet pa)
  {
    pa.registerDispose(this);
  }
 
  public void dispose()
  {
    dumpStrings();
  }
}
