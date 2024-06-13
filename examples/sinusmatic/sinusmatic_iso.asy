/* Sinusmatic 3D iso
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
triple eye = (-1,1,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;



// Import de la structure commmune à toutes les projections
include "sinusmatic_structure.asy" ; 




// Nom des points :
namePoint(O, 'O', pos=(1,1)) ;
namePoint(B, 'B', pos=(0,2)) ;
namePoint(A, 'A', pos=(2,0)) ;
namePoint(C, 'C', pos=(2,2)) ;
namePoint(D, 'D', pos=(1,1)) ;

// Bases :
int [] tab1 = new int[] {0}; 
//tab = {0} ;
showBasis(b0, O, coeff=(4,6,4), style=black+0.25+dashed) ;
showAxis(b1, tab1, B, coeff=6.5, style=black+0.25+dashed) ;
showAxis(b2, tab1, B, coeff=6, style=black+0.25+dashed) ;

tab1[0] = 1 ;
showAxis(b4, tab1, C, coeff=3, style=black+0.25+dashed) ;
tab1[0] = 2 ;
showAxis(b4, tab1, C, coeff=2, style=black+0.25+dashed) ;
showAxis(b0, tab1, C, coeff=2, style=black+0.25+dashed) ;


// Paramètres
showParameter(C, b0.y, b4.y, "$\theta_{40}$", coeff=1.5, style=black+0.25) ;
showParameter(C, b0.z, b4.z, "$\theta_{40}$", coeff=1.5, style=black+0.25) ;
showParameter(O, b0.x, b1.x, "$\theta_{10}$", coeff=2.75, style=black+0.25) ;
showParameter(B, b1.x, b2.x, "$\theta_{21}$", coeff=1, style=black+0.25) ;