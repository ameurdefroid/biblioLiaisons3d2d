/* DAE 2D zx
   v1.0
   Exemple de la bibliothèque
   10/06/2024
   Anthony Meurdefroid */

// Paramètres de sortie
// settings.outformat = "pdf" ;
settings.render = -4 ;
settings.prc = false ;

// Import biblio des laisons
import biblioLiaisons ;
/* Le point O(0,0,0) et un objet base b0 avec
b0.x = (1,0,0)
b0.y = (0,1,0)
b0.z = (0,0,1)
est générée par défaut */

// taille police
defaultpen(fontsize(10pt));

// mise à l'échelle des dimensions - ne pas changer à mon avis
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde le point (0,0,0)
triple eye = (0,1,0) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;



// Import de la structure commmune à toutes les projections
include "DAE_structure.asy" ; 



// Nom des points :
namePoint(O, 'O', pos=NE) ;
namePoint(A, 'A', pos=(0,2)) ;
namePoint(G, 'G', pos=(2.5,1.5)) ;
namePoint(I, 'I', pos=(0,2.5)) ;
namePoint(L, 'L', pos=(0,2.5)) ;
namePoint(E, 'E', pos=(-2,2)) ;
namePoint(C, 'C', pos=(2,2)) ;


// Bases :
int [] tab1 = new int[] {0}; 
//tab = {0} ;
showBasis(b0, O, coeff=(12,2,e/2+1), style=black+0.25+dashed) ;
link(O -- G+(0,0,-1), black+0.25+dashed) ;
