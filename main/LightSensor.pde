class LightSensor{
  
   private int x, y;
  
   public LightSensor(int x, int y){
     setPosition(x, y);
   }
   
   public void setPosition(int x, int y){
     this.x = x;
     this.y = y;
   }
   
   public int getX(){
     return x;
   }
   
   public int getY(){
     return y;
   }
   
   public boolean isWhite(){
     return red(pixels[y*width+x]) == 255 || green(pixels[y*width+x]) == 255;
   }
   
   public int getColor(){
     return pixels[y*width+x];
   }
   
   public void draw(){
     fill(0);
     ellipse(x, y, 2, 2);
   }
   
}
