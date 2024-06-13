/* pince coupe cable iso
   v1.0
   Exemple de la bibliothèque
   05/06/2024
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
include "pinceCoupeCable_structure.asy" ; 


showBasis(b0, O, coeff=(length(G-O)+1, h+1, 2)) ; 




// Noms des points
namePoint(C,"C",(-2.5,0)) ;
namePoint(O,"O",(1.25,1.25)) ;
namePoint(Bp,"B'",(0,2)) ;
namePoint(B,"B",(0,-2)) ;
namePoint(Q,"Q",(-1.5,2)) ;
namePoint(P,"P",(2,-2)) ;
namePoint(K,"K",(1,.25)) ;
namePoint(L,"L",(0.25,-.5)) ;
namePoint(M,"M",(1.5,2.5)) ;
namePoint(G,"G",(2,-2.5)) ;



