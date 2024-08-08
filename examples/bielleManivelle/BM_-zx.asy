/* Bielle manivelle 2D -zx -- Crank and rod system
   v1.0.1
   Module example 
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
triple eye = (0,1,0) ;
// quel vecteur vers le haut
triple up = (0,0,-1) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Import de la structure commmune à toutes les projections
include "BM_structure.asy" ; 

// Bases et paramétrages
showBasis(b0, O, coeff=(length(D-O)+1,R+1,2)) ; 

