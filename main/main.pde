/*
 Salazar Alanis Victor Yoguel
 
 Algoritmos Geneticos aplicados al control de un seguidor de linea
*/

import java.util.*;

int population = 50;
int generations = 150;

ArrayList<Robot> robotGeneration = new ArrayList<Robot>();
ArrayList<Robot> bestRobot = new ArrayList<Robot>();

PrintWriter best, all;

/*
Segun la evidencia empirica de Alander (1992) que dice
que la poblacion debe ser entre l y 2l, por lo tanto la poblacion la asigno a 50
*/
int generation = 1;
long fittest = 990000000;
int numberOfRun = 1;

void setup() {
  size(700, 400);
  
  best = createWriter("best.txt");
  all = createWriter("all.txt");
  
  //poblacion inicial
  for(int i=0; i<population; i++){
    robotGeneration.add(new Robot(new int[]{(int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60)}, 
             (int)random(1, 50), (int)random(2, 16)));
  }
  
  //definir la poblacion inicial como la mejor hasta ahora
  for(int i=0; i<population; i++){
    bestRobot.add(robotGeneration.get(i));
  }
  
}

void draw(){
  
  //review();
  
  drawStage();
  
  if(compute()){ //si ya terminaron todos los individuos
    reduction();
    crossover();
    mutation();
    all.println(numberOfRun + "\t" + generation + "\t" + fittest);
    all.flush();
    best.println(numberOfRun + "\t" + fittest
    + bestRobot.get(0).getGiro()[0] + "\t" + bestRobot.get(0).getGiro()[1] + "\t" + bestRobot.get(0).getGiro()[2] + "\t" + bestRobot.get(0).getGiro()[3] + "\t" 
    + bestRobot.get(0).getVel() + "\t" + bestRobot.get(0).getD());
    best.flush();
    generation++;
  }
  
  //delay(100);
  
}

void review(){
  if(generation == generations){
    
    best.println(numberOfRun + "\t" + fittest
    + bestRobot.get(0).getGiro()[0] + "\t" + bestRobot.get(0).getGiro()[1] + "\t" + bestRobot.get(0).getGiro()[2] + "\t" + bestRobot.get(0).getGiro()[3] + "\t" 
    + bestRobot.get(0).getVel() + "\t" + bestRobot.get(0).getD());
    best.flush();
    
    numberOfRun++;
    println(numberOfRun);
    
    //resetear
    fittest = 990000000;
    generation = 1;
    robotGeneration = new ArrayList<Robot>();
    bestRobot = new ArrayList<Robot>();
    
    //poblacion inicial
    for(int i=0; i<population; i++){
      robotGeneration.add(new Robot(new int[]{(int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60)}, 
               (int)random(1, 50), (int)random(2, 16)));
    }
    
    //definir la poblacion inicial como la mejor hasta ahora
    for(int i=0; i<population; i++){
      bestRobot.add(robotGeneration.get(i));
    }
  }
}

boolean compute(){ //iterar la poblacion
  boolean finished=true;
  
  for(Robot robot : robotGeneration){
    robot.move();
    robot.draw();
    finished &= (robot.getScore()!=0);
  }
  
  return finished;
}

void reduction(){  //seleccionar mejor poblacion (se selecciona de forma elitista)
  for(Robot robot: robotGeneration){
    bestRobot.add(robot);  
  }
  
  Collections.sort(bestRobot); 
  
  /*for(Robot robot:bestRobot){
    println(robot.getScore());
  }*/
  
  for(int i=bestRobot.size()-1; i>=population; i--){
    bestRobot.remove(i);
  }
  
  fittest = bestRobot.get(0).getScore();
  
}

void crossover(){ //se genera la nueva poblacion
  robotGeneration = new ArrayList<Robot>();
  
  for(int i=0; i<5; i++){ //agrega 5 random para evitar convergencia
    robotGeneration.add(new Robot(new int[]{(int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60), (int)random(-60, 60)}, 
             (int)random(1, 50), (int)random(2, 16)));
  }
  
  for(int i=0; i<population-5; i++){ //para cada nuevo individuo
  
    //seleccion por torneo
    Robot a, b;
    
    Robot a1 = bestRobot.get(int(random(20)));
    Robot a2 = bestRobot.get(int(random(20)));
    a = a1.getScore()<a2.getScore()? a1:a2;
    
    Robot b1 = bestRobot.get(int(random(20)));
    Robot b2 = bestRobot.get(int(random(20)));
    b = b1.getScore()<b2.getScore()? b1:b2;
    
    if(random(1)< 0.9){
      robotGeneration.add(a.crossover(b));
    }
    else {
      if(a.getScore()>b.getScore()){
        a = b;
      }
      robotGeneration.add(new Robot(a.getGiro(), a.getVel(), a.getD())); 
    }
    
    
  }
  
  
  
}

void mutation(){  //mutar la poblacion
  for(Robot robot : robotGeneration){
    if(random(1)< 0.9){
      robot.mutate();
    }
  }
}

void drawStage(){
  //pintar pixeles para procesamiento
  rectMode(CENTER);
  background(color(255, 0, 255));
  strokeWeight(0);
  fill(color(255, 0, 0));
  rect(350, 200, 650, 350);
  strokeWeight(7);
  fill(color(0, 255, 0));
  rect(350, 200, 500, 200, 200);
  loadPixels();
  
  //pintar escenario visual
  strokeWeight(4);
  background(255);
  fill(255);
  rect(350, 200, 500, 200, 200);
  
  //texto
  fill(0);
  textSize(30);
  text("Gen:", 30, 30);
  text(generation, 100, 30);
  text("Fittest:", 300, 30);  
  text(fittest, 400, 30);
  strokeWeight(1);
}
