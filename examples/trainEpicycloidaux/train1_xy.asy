/* train épi config 1 3D xy
   v1.0
   Exemple de la bibliothèque
   04/06/2024
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
triple eye = (0,0,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// Import de la structure commmune à toutes les projections
include "train1.asy" ; 



// Noms des points
namePoint(O,"O",(-2.5,2.5)) ;
namePoint(C,"C",(0,2.5)) ;

// Noms CEC
nameClasse2points("1", O+0.75*b0.x, A, pos=1*N, p=CEC1) ;
nameClasse1point("2", B, pos=1*W, p=CEC2) ;
nameClasse1point("3", dot(C-O, b0.x)*b0.x, pos=1*NE, p=CEC3) ;
nameClasse2points("4", A+R3*b0.y, E-1*b0.x+R3*b0.y, pos=(0,-0.15), p=CEC4) ;