//INTERFACE
PImage img,out;
String text="           Start The Game!";
String txt="";
Couple BA,BP;
Couple Bsize= new Couple(180,55);
boolean BAOver = false;
boolean BPOver = false; 
boolean BAClick = false;
boolean BAClicked=false;
boolean BPClicked=true;
boolean BPClick = false; 
boolean debut=true;
PFont font;
String ha;
float t;
int nv;
int choice=2;

//Variables 
int q;
ArrayList<EtatTaquin> sol;
int l;
EtatTaquin bi,Curent,BUT,Init;
int taille;
int [][] M=
{
  {4,6,8},
  {2,7,5},
  {0,3,1},
};
int [][] N=
{
  {1,2,3},
  {7,4,5},
  {8,6,0},
};


int [][] Goal=
{
  {1,2,3},
  {8,0,4},
  {7,6,5},
};



//INIT
void setup(){
  size(550,400);
  taille=(212-5*4)/3;
  Init=new EtatTaquin(M,null,GetZero(M),choice);
  BUT=new EtatTaquin(Goal,null,GetZero(Goal),choice);
  Curent=Init;
  img = loadImage("9.png");
  BA=new Couple(350,180);
  BP=new Couple(350,80); 
  font = loadFont("SofiaProSoftW01-RegularIt-30.vlw");
  textFont(font, 20);
  
}



void draw(){
  
   background( 254, 242, 215 );
   update();
    
    //Ecran du debut
  if(debut) {Curent=BUT;ha="Play Game"; }
  else{ 
    ha="   Restart"; 
    if(choice==1)     text="Cases mal placées="+Curent.h + "     G=" +Curent.g+"    F=" +Curent.f;
    if (choice==2) text="Distance Manhattan ="+Curent.h + "     G=" +Curent.g+"    F=" +Curent.f;
  }
  

  
  buildImage(Curent);

    //si je veux jouer
    if(BPClick){
      
      mousePressed();
       BAClicked=false;
        debut=false;
        Curent=Init;
        BPClick=false;
        BPClicked=true;
    }
    
  
  if(BPClicked) mousePressed();
    
    //executer ALGO A pour trouver solution
    if(BAClick) 
     {
       BPClicked=false;
       debut=false;
       Curent.Fazer=null;
       sol=AlgoA();
       q=sol.size()-1;       
       BAClick=false;
       BAClicked=true;
       txt=  "Nodes Visited: "+nv + "      Time: " + t+" ms";
     }
     
     
     //Affichage de la solution trouvée
      if (BAClicked)
      {
        int k=0;
        BPClicked=false;
        if(q>=0)
       {print("\nQ="+q);
         Curent=sol.get(q);
         delay(500);
         Curent.printEtat();
         q--;
         if(k==1) q=-3;
         if(q==-1) {q=0;k=1;}
       }else BAClicked=false;

       
    }
      
      
//INTERFACE--------------------------------------------------------------------------------------------
      //rectangle
        fill(color(50, 55, 100));
        rect(0, 300, 550, 150);
        //fill(color( 128, 219, 248));
        fill(color( 254, 246, 228));
        text(text, 135, 315 , 400, 200);
      
        fill(color( 254, 246, 228));
        text(txt, 135, 360 , 400, 200);
        
        
     if(!debut && Curent.EqualMatrice(Goal) && BPClicked)
     {
      // print("\nYOU WIN"); 
      fill(color(50, 55, 100));
      rect(55, 100, 200, 100);
      fill(color( 128, 219, 248 ));
      text("You Win!", 110, 140 , 260, 200);
     }


//PLAY
 
   if (BPOver) {
    fill(color(60, 65, 110));
  } else {
    fill(color(50, 55, 100));
  }
  stroke(color(19, 94, 185));
  rect(BP.x, BP.y, Bsize.x, Bsize.y);
 // fill(color( 128, 219, 248));
  fill(color( 254, 242, 215));
  text(ha, BP.x+45, BP.y+20 , 260, 200);


//SOLUTION
 if (BAOver) {
    fill(color(60, 65, 110));

  } else{  
    fill(color(50, 55, 100));
  }
  stroke(color(19, 94, 185));
  rect(BA.x, BA.y, Bsize.x, Bsize.y);
  fill(color( 254, 242, 215));
 // fill(color( 128, 219, 248 ));
  text("Show Solution", BA.x+30, BA.y+20 , 260, 200);
  
  



   
}  




//Fonction qui transforme une matrice en affichage 
 void buildImage(EtatTaquin XE )
 {
  
   background( 254, 242, 215 );
   int X[][]=CopieMatrice(XE.Matrice);
   if (X!=null)
   {
     out=createImage(taille,taille,RGB);
  for(int i=0; i< X.length ; i++)
  {
      for(int j=0; j< X.length ; j++)
      {
         if(X[i][j]!=0){
            
               
              
              out.copy(img, 0, taille*(X[i][j]-1)+1 , 63,63, 0, 0 ,64 ,64  ); 
              out.updatePixels();
              image(out,5*(j+1)+(j*taille)+50,(5*(i+1))+(i*taille)+50);
              //image(out,5*(j+1)+(j*taille),(5*(i+1))+(i*taille) );
              
         }else /*print("\n Matrice 0")*/; 
      
      }
      
    
  }
     
     out=null;
   }else /*print("\n Matrice null")*/;
 }
 
 
 
//SWAP des cases
void mousePressed()

    
{//pour ne pas changer la matrice mere
   int X[][]= CopieMatrice(Curent.Matrice);
  if(mousePressed){

    //CLICK BOUTONS
    if(BAOver) BAClick=true;
    if(BPOver) BPClick=true;
    
    //CLICK CASE DE JEU
    //matrice existe
   if (X!=null)
   {
     if ( (index(mouseY) !=-1) && (index(mouseX) !=-1))
     {
       // ^ ou one w only one 
       if(abs(Curent.Zero.x-index(mouseY) )== 1 ^ abs(Curent.Zero.y-index(mouseX))  ==1) 
       {
         X[Curent.Zero.x][Curent.Zero.y]=X[index(mouseY)][index(mouseX)];
         X[index(mouseY)][index(mouseX)]=0;
         
         
         Curent= new EtatTaquin(X,Curent, GetZero(X),choice) ;
         
       }//else print("\n 0 is not next");
     }//else  print("\n Click sur un carré");    
     
   }  
  }
}



//Pour ne pas changer la matrice mother
int[][] CopieMatrice(int [][] M)
  {
    int[][] Matrice =new int[3][3];
    if(M!=null)
    {
       for(int i=0; i< M.length ; i++)
    {
        for(int j=0; j< M.length ; j++)
        {
          Matrice[i][j]=M[i][j];
        }
    }
     }else print("Matrice affectée null:  125\n");
     
     return Matrice;
  }


//je lui donne le x ou le y de la sourie elle me dit qu'elle case de la matrice je veux deplacer
//69= 5(espace sep)+50(espace vide)+64(taille)
int index(int h){
  
  if ( (h>=5+50) &&  (h<69+50) ) return 0;
  else if ( (h>=74+50) &&  (h<138+50) ) return 1;
  else if ( (h>=143+50) &&  (h<207+50) ) return 2;
  else return -1;
  
  
}




//succs dune matrice
ArrayList<EtatTaquin> Succs(EtatTaquin d){
  
  //renvoie les succs de la case vide
 
  ArrayList<EtatTaquin> ss=new ArrayList<EtatTaquin>();
  EtatTaquin q;
  int [][]M=new int[3][3];

    if(GetZero(d.Matrice).x!=0) 
      { 
        M=MatriceSucc(GetZero(d.Matrice),new Couple(GetZero(d.Matrice).x-1,GetZero(d.Matrice).y ), d.Matrice);
        q=new EtatTaquin( M, d, GetZero(M),choice) ; 
        ss.add(q);
      }  //case en haut existe
    
  
    if(GetZero(d.Matrice).x!=2) 
      { 
        M=MatriceSucc(GetZero(d.Matrice),new Couple(GetZero(d.Matrice).x+1,GetZero(d.Matrice).y ), d.Matrice);
        q=new EtatTaquin( M, d, GetZero(M),choice ) ; 
        ss.add(q);
      }  //case en bas existe
    
    if(GetZero(d.Matrice).y!=0) 
      { 
        M=MatriceSucc(GetZero(d.Matrice),new Couple(GetZero(d.Matrice).x,GetZero(d.Matrice).y-1 ),d.Matrice);
        q=new EtatTaquin( M, d, GetZero(M),choice ) ;
        ss.add(q);} 
        
        //case a gauche existe
    
  
      if(GetZero(d.Matrice).y!=2) {
      
      M=MatriceSucc(GetZero(d.Matrice),new Couple(GetZero(d.Matrice).x,GetZero(d.Matrice).y+1 ), d.Matrice);
      q=new EtatTaquin( M, d, GetZero(M) ,choice) ;
      ss.add(q);
      }//case a droite exite  
   

  return ss;

}


//returns le zero dune matrice 
Couple GetZero(int [][] X)
{
   if (X!=null)
   { 
  for(int i=0; i< X.length ; i++)
  {
      for(int j=0; j< X.length ; j++)
      {
         if(X[i][j]==0) return new Couple(i,j);
      
      }
    
  }
   }else print("\n Matrice null");
   
   return null;
}


//elle SWAP deux position fune matrice 
void Move (Couple c1, Couple c2 ,int X[][])
{
  int temp;
  temp=X[c1.x][c1.y];
  X[c1.x][c1.y]=X[c2.x][c2.y];
  X[c2.x][c2.y]=temp;
}

//Elle swap deux ints d une matrice et elle te rends la nvlle matrice 
int[][] MatriceSucc (Couple c1, Couple c2 ,int X[][])
{
  int temp;
  int [][] copie= CopieMatrice(X);
  temp=copie[c1.x][c1.y];
  copie[c1.x][c1.y]=copie[c2.x][c2.y];
  copie[c2.x][c2.y]=temp;
  return copie;
}







//Etat init= Curent 
ArrayList<EtatTaquin> AlgoA()

{

  int t1=millis();
  EtatTaquin Deb=new EtatTaquin(Curent.Matrice,Curent.Fazer,Curent.Zero,choice);
   ArrayList<EtatTaquin> open= new ArrayList<EtatTaquin>() ;
  ArrayList<EtatTaquin> closed= new ArrayList<EtatTaquin>() ;
  boolean found=false;
  
 
    //Succs calcule matrice 3la 7ssab letat actuel de mon affichage 
    //je change zero.x zero.y quand je build i.e je build la matrice que je lui donne
    if(Deb.EqualMatrice(Goal)) found=true;    else 
    {
      
      open.add(Deb);
      
      while(!(open.isEmpty()) && !found  )
        {
          //trouve le min men open 
          EtatTaquin min=GetMin(open);
          if(min.EqualMatrice(Goal)) 
          {found=true;
            bi=min;
          }
          else{
                  open.remove(min);
                 if(closed.contains(min))
                 { 
                   EtatTaquin  ex= closed.get(closed.indexOf(min));
                     if(ex.f<=min.f) 
                     {    
                       closed.remove(ex);
                       closed.add(min);
                       open.add(ex);
                     
                     } 
                   }
                   else{
                    ArrayList<EtatTaquin> sccs=Succs(min);
                    for(int l=0;l<sccs.size(); l++)
                    {
                      EtatTaquin ss=sccs.get(l) ;
                      if(!open.contains(ss) && !closed.contains(ss) ){
                        
                      open.add(new EtatTaquin(sccs.get(l).Matrice, min, GetZero(sccs.get(l).Matrice),choice)); 
                     
                      
                      }
                    }
                    closed.add(min);
                   }
                 
               
          }//else  2
          
        }
             
            
            
             
    } //end if1  else1
    
    
    
    t=millis()-t1;
        print("\nTime:"+t);
        nv=closed.size();
        print("\nNodes visited:"+nv);
 
       if (found) {
             
          ArrayList<EtatTaquin> solution=new ArrayList<EtatTaquin>();
               
               while(bi !=null) {solution.add(bi);  bi=bi.Fazer;}
               
               return solution;
             
            } else return null;
         




}




EtatTaquin  GetMin(ArrayList<EtatTaquin> open)
{
  
  EtatTaquin m=new EtatTaquin(open.get(0).Matrice, open.get(0).Fazer, open.get(0).Zero,choice);
 
 
    for(int i=1; i<open.size();i++)
    {
          if (open.get(i).f< m.f) 
          {
             m=new EtatTaquin(open.get(i).Matrice, open.get(i).Fazer, open.get(i).Zero ,choice);
           }
     
    }
  
return m;
}





//fonctions pour laffichage 
//*****************************************************

void update() {
  
  
  if ( overRect(BP.x, BP.y, Bsize.x, Bsize.y) ) {
    BPOver = true;
     BAOver = false;
  } else
  if ( overRect(BA.x, BA.y, Bsize.x, Bsize.y) ) {
    BAOver = true;
    BPOver = false;
  } else BPOver= BAOver = false; // 

}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}







//fonction qui ne sert à rien finalement
//************************************************************

//on peut avoir plusieurs minimum mais ils resteront dans open dooonc one at a time 
ArrayList<EtatTaquin>  GetMins(ArrayList<EtatTaquin> open)
{
  ArrayList<EtatTaquin>  mins= new ArrayList<EtatTaquin>() ;
  EtatTaquin m=open.get(0);
  for(int i=1; i<open.size();i++)
  {
    if (open.get(i).f< m.f) {m=open.get(i);  }
   
  }
  
   mins.add(m);
   for(int i=1; i<open.size();i++)
  {
    if (open.get(i).f== m.f) {  mins.add(open.get(i));  }
   
  }

  return mins;
}
