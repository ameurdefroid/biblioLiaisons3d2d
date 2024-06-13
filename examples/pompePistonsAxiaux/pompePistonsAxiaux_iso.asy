/* pompe à pistons axiaux 3d iso
   v1.0
   Exemple de la bibliothèque
   06/06/2024
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
triple eye = (-1,1,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;

// Import de la structure commmune à toutes les projections
include "pompePistonsAxiaux_structure.asy" ; 

// paramétrage
showBasis(b0, O, coeff=(length(D-O)+1, Rdisque, 2)) ; 
showBasis(b0, H, coeff=1.5*(1,1,1)) ; 
int [] tabAxis = {1,2} ;
showAxis(b1, tabAxis , H, 1.5) ;
showParameter(H, b0.z, b1.z, "$\theta$", coeff=0.75, style=black+0.25) ;







