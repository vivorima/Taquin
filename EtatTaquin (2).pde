public class EtatTaquin
{

  int[][] Matrice=new int[3][3];
  EtatTaquin Fazer=null;
  int f,g,h;
  Couple Zero;
  
  
  

 //constructeur 
   public EtatTaquin(int [][] M , EtatTaquin p , Couple Z, int choice)
  {
    this.SetMatrice(M);
    this.SetFather(p); 
    this.g=PlusG();
    this.h=this.h(choice,Goal);
    this.f=this.h+this.g;
    this.Zero=Z;
  
   }

  //affecte a mon etat une nvlle matrice
   void SetMatrice(int [][] M)
  {
    if(M!=null)
    {
       for(int i=0; i< M.length ; i++)
    {
        for(int j=0; j< M.length ; j++)
        {
          Matrice[i][j]=M[i][j];
        }
    }
     }else print("Matrice affectée null: EtatTaquin38\n");
  }
  
  
  //affecte a le pere de mon etat cette matrice 
   void SetFather(EtatTaquin F)
  {
    if(F!=null)
     this.Fazer=new EtatTaquin(F.Matrice,F.Fazer,F.Zero,choice);
     else this.Fazer=null;
    
    
  }
  
  
  
  //Calcul heuristique: case mal placée + //Distance de Manhattan 
  int  h(int HH, int [][] Goal)
  {
      if(Goal!=null)
    {
    int h=0;
    for(int i=0; i< Goal.length ; i++)
    {
        for(int j=0; j< Goal.length ; j++)
        {
          if (HH==1) {
            
              if (Matrice[i][j]!=Goal[i][j]) h++; 
          }
          
          if (HH==2){
                Couple c= Find(this.Matrice[i][j],Goal);
                if(c!=null) h=h+abs(c.x-i) + abs(c.y-j);    
                else print("\nErreur Co");
          }
          
        }
    }
    this.h=h;
    return h;
    }
     else return -1;
 
}


Couple Find (int x, int [][] matx)
{
  
  int i=0;
 while (i<matx.length)
 {
  int j=0;
    while (j<matx.length )
   {
     if (matx[i][j]==x) {Couple c=new Couple(i,j); return c;}
     j++;
   }
   i++;
 }
 
 return null;
}
  
  int PlusG()
  {
    if(Fazer!=null)
    return Fazer.g+1;
    return 0;
    
  }
  
  
  void setF(int g, int h)
  {
    this.g=g;
    this.h=h;
    this.f=g+h;
  }
  
   void setF(int f)
  {
    this.f=f;
  }
  
    boolean  EqualMatrice(int [][] M)
  {
      if(M!=null)
    {
    for(int i=0; i< M.length ; i++)
    {
        for(int j=0; j< M.length ; j++)
        {
          
          if (Matrice[i][j]!=M[i][j]) return false; 
        }
    }
    return true;
    
     }else return false;
  }
  
  
   boolean  PereEqualsTo(int [][] M)
  {
      if(M!=null)
    {
        for(int i=0; i< M.length ; i++)
        {
            for(int j=0; j< M.length ; j++)
            {
              
              if (Fazer.Matrice[i][j]!=M[i][j]) return false; 
            }
        }
        return true;
  
     }else return false;
  }
  
  
  
  void printEtat()
{
    println("\nh="+ h+"  g="+g +"  f="+f + "\n ZERO =" + Zero.x+","+ Zero.y);
    
              println("  0 1 2\n --------");
              
              println("0| " +Matrice[0][0] +" " +Matrice[0][1] +" " +Matrice[0][2]);
              println("1| " +Matrice[1][0] +" " +Matrice[1][1] +" " +Matrice[1][2]);
              println("2| " +Matrice[2][0] +" " +Matrice[2][1] +" " +Matrice[2][2]);
         
         
        
      /*  if (Fazer!=null) {print("\n Father"); Fazer.printEtat();} 
        else print("Father null");*/
        
        
}
  
  
  
  @Override
public boolean equals(Object other){
    if (other == null) return false;
    if (other == this) return true;
    if (!(other instanceof EtatTaquin))return false;
    EtatTaquin o = (EtatTaquin)other;
   return(o.EqualMatrice(this.Matrice));
}

}
