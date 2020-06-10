class Robot implements Comparable<Robot> {
 
  //posicionamiento
  private int x=350, y=100;
  private int lastX=350, lastY=100, itt = 0;
  private int orientation=90;
  
  //sensores
  protected LightSensor sensorRight = new LightSensor(-10, -10);
  protected LightSensor sensorLeft = new LightSensor(10, -10);
  
  //estado
  private boolean dead;
  private long score;
  private int turn;
  private long iterations;
  
  //cromosomas
  protected int vel;
  protected int d;
  protected int giro[] = new int[4];
  
  public Robot(int giro[], int vel, int d){
    dead = false;
    for(int i=0; i<4; i++){
      this.giro[i]=giro[i];
    }
    this.vel = vel;
    this.d = d;
    turn = 0;
    iterations = 0;
  }
  
  public void draw(){ 
    
    if(dead){
      return;
    }
    
    pushMatrix();
    rectMode(CENTER);
    translate(x, y);
    rotate(radians(orientation));
    fill(color(0, 0, 255));  
    rect(0, 0, 30, 30);
    fill(color(255,0,0));
    //rect(0, -6, 5, 14);
    fill(0);
    ellipse(10, -10, 2, 2);
    ellipse(0, -10, 2, 2);
    ellipse(-10, -10, 2, 2);
    popMatrix();
    
    fill(255);
    ellipse(sensorRight.getX(), sensorRight.getY(), 2, 2);
    ellipse(sensorLeft.getX(), sensorLeft.getY(), 2, 2);
  }
  
  private boolean vueltaMarcada=true;
  
  public void move(){
    if(dead)
      return;    
    
    //mover    
    x+=vel*sin(radians(orientation));
    y-=vel*cos(radians(orientation));
    
    sensorRight.setPosition((int)(x+d*cos(radians(orientation))), (int)(y+d*sin(radians(orientation))));
    sensorLeft.setPosition((int)(x-d*cos(radians(orientation))), (int)(y-d*sin(radians(orientation))));
    
    iterations++;
    itt++;
    
    //checar vuelta
    if(x>=340 && x<=360 && y>=70 && y<=130){
      if(!vueltaMarcada){
        turn++;
        vueltaMarcada=true;
      }
    }
    else {
      vueltaMarcada = false;
    }
    
    //matar
    if(green(sensorLeft.getColor())==255 || red(sensorRight.getColor())==255){
      dead = true;
      return;
    }
    if(turn==2){
      dead = true;
      return;
    }
    if(itt==20){
      itt = 0;
      if(abs(x-lastX)+abs(y-lastY)<10){
        dead = true;
        return;
      }
      lastX = x;
      lastY = y;
    }
    
    
    //seguir Linea
    if(sensorLeft.isWhite() && sensorRight.isWhite()){
      rotateRobot(giro[0]);
    }
    if(!sensorLeft.isWhite() && sensorRight.isWhite()){
      rotateRobot(giro[1]);
    }
    if(sensorLeft.isWhite() && !sensorRight.isWhite()){
      rotateRobot(giro[2]);
    }
    if(!sensorLeft.isWhite() && !sensorRight.isWhite()){
      rotateRobot(giro[3]);
    }
  }
  
  public long getScore(){
    if(!dead) //todavia no ha terminado
      return 0;
      
    score = 0;
    if(turn <2){ //fallo
      score = 800000000; //penalizacion
      if(turn == 1){ //completo una vuelta
        if(y>200){ //quedo abajo
          score -= 400000000;
          score -= (700-x);
        }
        else{ //quedo arriba
          if(x>340){
            score -= 300000000;
            score -= x;
          }
          else {
            score -= 450000000;
            score -= x;
          }
        }
      }
      else{ //no completo vuelta
        if(y>200){ //quedo abajo
          score -= 100000000;
          score -= (700-x);
        }
        else {
          if(x>340){
            score -= x;
          }
          else {
            score -= 150000000;
            score -= x;
          }
        }
      }
    }
    else { //lo logro
      score = iterations;
    }
      
    return score;
  }
  
  protected void rotateRobot(int g){
      orientation+=g;
  }
  
  public Robot crossover(Robot couple){
    
    //selecciona valores
    int giro[] = new int[4];
    int vel;
    int d;
    for(int i=0; i<4; i++){
      if(int(random(10))%2==0){
        giro[i] = this.giro[i];
      }
      else {
        giro[i] = couple.giro[i];
      }
    }
    
    if(int(random(10))%2==0){
      vel = this.vel;
    }
    else {
      vel = couple.vel;
    }
    
    if(int(random(10))%2==0){
      d = this.d;
    }
    else {
      d = couple.d;
    }
    
    
    Robot robot = new Robot(giro, vel, d);
    return robot;
  }
  
  public void mutate(){
    vel = min(max(vel + (int)(randomGaussian()*5), 1), 62);
    d = min(max(d + (int)(randomGaussian()*3), 2), 15);
    
    for(int i=0; i<4; i++){
      giro[i] = min(max(giro[i] + (int)(randomGaussian()*3), -178), 178);
    }
  }
  
  @Override     
  public int compareTo(Robot robot) {          
    return this.getScore()<robot.getScore() ? -1 : (this.getScore()==robot.getScore() ?0:1);     
  }  
  
  public int[] getGiro(){
    return giro;
  }
  
  public int getVel(){
    return vel;
  }
  public int getD(){
    return d;
  }

}
