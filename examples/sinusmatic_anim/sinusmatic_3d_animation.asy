/* Sinusmatic 3d animation
   v1.0
   Exemple de la bibliothèque
   11/06/2024
   Anthony Meurdefroid */



// Paramètres de sortie
// Qualité diminuée mais correcte
settings.render = -2 ;
settings.prc = false ;
settings.tex="pdflatex";


// Import biblio des laisons
import biblioLiaisons ;
/* Le point O(0,0,0) et un objet base b0 avec
b0.x = (1,0,0)
b0.y = (0,1,0)
b0.z = (0,0,1)
est générée par défaut */


//usepackage("animate");
import animation;
// Global = false pour éviter les out of memory
animation Anim = animation(global=false);


// taille police
defaultpen(fontsize(10pt));

// mise à l'échelle des dimensions - ne pas changer à mon avis
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde le point (0,0,0)
triple eye = (-1,1,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;



/* Structure sinusmatic */

// Parameters :

real OB = 3 ;
real OC = 3 ;
real OA = 1 ;
real CD = 4 ;
real DE = 1 ;


// CEC 
pen CEC0 = black ;
pen CEC1 = blue ;
pen CEC2 = orange ;
pen CEC3 = deepgreen ;
pen CEC4 = red ;




// Animation -- paramètres
int n = 36 ;
real pas = 360/n ;

// Boite englobante 
triple coinBas = (-OB)*b0.x + (-OA)*b0.y + (-OB)*b0.z ;
triple coinHaut = (OB)*b0.x + (OC)*b0.y + (OB)*b0.z ;
parallelepipedBounding(coinBas, coinHaut) ;



for(int i=0; i < n ; ++i) {
   save();
   real theta10 = i*pas/360*2*pi ;
   // Relation LES
   real theta21 = atan(OC/OB) ;
   real theta40 = atan(-OB/OC*sin(theta10)) ;

   // Bases et points :
   basis b1 = rotationBasis(1, b0, theta10, 'y', b0.y) ;
   basis b2 = rotationBasis(2, b1, theta21, 'z', b1.z) ;
   basis b4 = rotationBasis(4, b0, theta40, 'x', b0.x) ;

   triple A = -OA*b0.y ;
   triple B = -OB*b1.x ;
   triple C = OC*b0.y ;
   triple D = C + CD*b0.x ;
   triple E = D + DE*b0.x ;

   real posPG = 1/2*length(C-B) ;
   triple B1 = B + posPG*b2.x ;
   triple A1 = A - 1*b0.x ;
   triple D1 = D - 1*b0.y ;

   // Liaisons
   liaisonPivot(A, b0.y, b1.z, CEC0, CEC1) ;
   liaisonRotule(B, b2.x, CEC2, CEC1) ;
   liaisonPivotGlissant(B1, b2.x, CEC2, CEC3) ;
   liaisonPivot(C, b4.z, b4.x, CEC3, CEC4) ;
   liaisonPivot(D, b0.x, b4.z, CEC0, CEC4) ;

   // relier :
   link(O -- -3/4*OB*b1.x -- -3/4*OB*b1.x-0.5*b0.y -- -OB*b1.x-0.5*b0.y -- B, CEC1 ) ;
   link(B -- B + 1/3*posPG*b2.x -- B + 1/3*posPG*b2.x +0.5*b2.y 
   -- B + 1*posPG*b2.x +0.5*b2.y  -- B1, CEC2) ;
   link(B1 -- C, CEC3) ;
   link(C -- C+1*b4.z -- C+1*b4.z+1*b0.x -- C+1*b0.x -- D, CEC4) ;

   // Bâti
   link(D -- D1, CEC0) ;
   bati(D1, b0.x, -b0.y, CEC0) ;
   link(A -- A1, CEC0) ;
   bati(A1, b0.y, -b0.x, CEC0) ;

  Anim.add(); // Add currentpicture to animation.
  restore();

}


erase();

endAnimationPDF(Anim) ;