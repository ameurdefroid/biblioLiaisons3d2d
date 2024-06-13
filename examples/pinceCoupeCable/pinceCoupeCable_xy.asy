/* pince coupe cable xy
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
triple eye = (0.,0.,1) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;





// Import de la structure commmune à toutes les projections
include "pinceCoupeCable_structure.asy" ; 


showBasis(b0, O, coeff=(length(G-O)+1, h+1, 2)) ; 




// Noms des points
namePoint(C,"C",(-2.5,-2)) ;
namePoint(O,"O",(2,2)) ;
namePoint(Bp,"B'",(0,2)) ;
namePoint(B,"B",(0,-2)) ;
namePoint(Q,"Q",(-2,2)) ;
namePoint(P,"P",(-2,-2)) ;
namePoint(K,"K",(-2,1.25)) ;
namePoint(L,"L",(-2,-1.25)) ;
namePoint(M,"M",(0,2.5)) ;
namePoint(G,"G",(2,-2)) ;


// Numéro classes
nameClasse2points("1", O-1*b0.x, O, pos=1*N + 0.5*W, p=CEC0) ;
nameClasse2points("3", C+h*b0.y, O+h*b0.y, pos=1*N, p=CEC3) ;
nameClasse2points("2", C-h*b0.y, O-h*b0.y, pos=1*S, p=CEC2) ;
nameClasse2points("5'", Q, K, pos=1*E, p=CEC5p) ;
nameClasse2points("5", P, L, pos=1*E, p=CEC5) ;
nameClasse1point("8", C, pos=1.5*E, p=CEC0) ;
nameClasse2points("7", Bp, B, pos=2.5*E + 1.25*N, p=CEC0) ;
nameClasse2points("4", dot(K-O, b0.x)*b0.x, M, pos=1*S, p=CEC4) ;
nameClasse2points("6", M+0.5*b0.x, G, pos=2.5*N, p=CEC0) ;