/* Bielle manivelle 3D autre
   v1.0.1
   Exemple de la bibliothèque
   31/07/2024
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

// mise à l'échelle des dimensions - ne pas changer 
unitsize(1cm);


// Mise à jour de la scène :
// d'où on regarde le point (0,0,0)
triple eye = (1.5,0.5,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Import de la structure commmune à toutes les projections
include "BM_structure.asy" ; 


// Bases et paramétrages
showBasis(b0, O, coeff=(length(D-O)+1,R+1,2)) ; 
int[] tabIndices = {0,1} ;
showAxis(b1, tabIndices, O, R+1, style=black+0.25) ;
showParamAng(O, b0.x, b1.x, "$\theta_{1}$") ;
showParamAng(O, b0.y, b1.y, "$\theta_{1}$") ;

int[] tabIndices = {0} ;
showAxis(b2, tabIndices, B, 2, style=black+0.25) ;
showParamAng(B, b0.x, b2.x, "$\theta_{2}$") ;
showParamLin(O, B, b0.x, -b0.y, "$x$", offset=0.75, pos=1*N, style=CEC3+0.25) ;

// Noms des points
namePoint(O,"O",NE) ;
namePoint(A,"A",NE) ;
namePoint(C,"C",(2,2)) ;
namePoint(B,"B",(-2,-2)) ;




