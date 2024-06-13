/* maxpid 3D iso
   v1.0
   Exemple de la bibliothèque
   11/06/2024
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
triple eye = (1,1,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Import de la structure commmune à toutes les projections
include "maxpid_structure.asy" ; 



// Noms des points
namePoint(A,"A",(-2,2)) ;
namePoint(B,"B",(-2,2)) ;
namePoint(C,"C",(2,-2)) ;
namePoint(D,"D",N) ;


// bases et paramétrages
showBasis(b0, O, coeff=(Lx+R, Ly+1, 2)) ; 
int [] tabAxis = {0} ;
showAxis(b2, tabAxis , A, R+brasSupp+1) ;
showParameter(A, b0.x, b2.x, "$\theta_{20}$", coeff=1.5, style=black+0.25) ;

showAxis(b0, tabAxis , B, lambda - 0.9) ;
showAxis(b1, tabAxis , B, lambda - 0.9) ;
showParameter(B, b0.x, b1.x, "$\theta_{10}$", coeff=lambda/2, style=black+0.25) ;

