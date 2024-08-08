/* pompe à pistons axiaux 2d xy
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
include "pompePistonsAxiaux_structure.asy" ; 


showBasis(b0, O, coeff=(length(D-O)+1, Rdisque, 2)) ; 


// Noms des points
namePoint(C,"C",(2.5,0)) ;
namePoint(D,"D",(2.5,2)) ;
namePoint(B,"B",(-2.5,2.5)) ;
namePoint(A,"A",(0,2.5)) ;
namePoint(H,"H",(1,1)) ;
namePoint(O,"O",(2,3)) ;

// Numéro classes
nameClasse1point("0", O-1*b0.y, pos=3.5*E, p=CEC0) ;
nameClasse2points("1", H, A, pos=2*E, p=CEC1) ;
nameClasse2points("2", A, B, pos=1*N, p=CEC2) ;
nameClasse2points("3", C, B, pos=1*N, p=CEC3) ;