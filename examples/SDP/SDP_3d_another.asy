/* SDP 3D autre
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
triple eye = (1.5,-0.5,0.5) ;
// quel vecteur vers le haut
triple up = (0,0,1) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// CEC :
pen CEC0 = black ;
pen CEC5 = brown ;
pen CEC4 = blue ;
pen CEC6 = green ;
pen CEC1 = purple ;
pen CEC3 = orange ;
pen CEC7 = red ;
pen CEC8 = pink ;
pen CEC9 = magenta ;


// Parameters :
// LES 1
real lambda1 = 2 ;

real alpha = 20/360*2*pi ;
basis b5 = rotationBasis(5, b0, alpha, 'x', b0.x) ;

real mu = tan(alpha)*lambda1 ;
triple B = -lambda1*b0.y ;
triple H = mu*b0.z ;
link(O--B--H, CEC5) ;

namePoint(O, "O") ;
namePoint(B, "B") ;
namePoint(H, "H") ;



liaisonGlissiere(O, b0.y, b0.x, CEC0, CEC5) ;
liaisonGlissiere(H, b5.y, b5.x, CEC4, CEC5) ;

real l_OP = 2 ;
triple Op = l_OP*b0.z ;
real l_OP_OPP = 2.5 ;
triple Opp = Op + l_OP_OPP*b0.z ;
triple Oppp = Opp + 0.5*b0.z ;
liaisonGlissiere(Op, b0.z, b0.x, CEC0, CEC4) ;
liaisonPivot(Opp, b0.z, b0.x, CEC6, CEC0) ;

real l4 = 6 ;
triple E = l4*b0.z ;
link(H--Op, CEC4) ;
link(Op + (0,0,1) -- Op + (0,1,1) -- E + (0,1,0), CEC4) ;

real Rcroi = 1 ;
triple E1 = E - Rcroi*b0.y + Rcroi*b0.z ;
triple E2 = E + Rcroi*b0.y + Rcroi*b0.z ;

link(E -- E-Rcroi*b0.y -- E1, CEC4) ;
link(E -- E+Rcroi*b0.y -- E2, CEC4) ;

// LES2 : Il faudrait créer un f(x) = 0 pour extraire beta de la LES -> je l'impose (on pourrait cherche un elinéarisation pour faire un peu mieux)
real beta = -30/360*2*pi ;
real theta6 = 10/360*2*pi ;

basis b6 = rotationBasis(6, b0, theta6, 'z', b0.z) ;

real theta1 = atan(-tan(beta)*sin(theta6)) ;
basis b1 = rotationBasis(1, b0, theta1, 'y', b0.y) ;

real theta3 = sgn(cos(theta6))*acos(cos(beta)/cos(theta1)) ;
basis b3 = rotationBasis(3, b0, theta3, 'x', b0.x) ;


triple E3 = E + Rcroi*b1.x + Rcroi*b0.z ;
triple E4 = E - Rcroi*b1.x + Rcroi*b0.z ;

liaisonRotule(E1, b0.z, CEC1, CEC4) ;
liaisonLineaireAnnulaire(E2, b0.y, -b0.z, CEC4, CEC1) ;

liaisonRotule(E3, -unit((b1.z+b3.z)), CEC1, CEC3) ;
liaisonLineaireAnnulaire(E4, b1.x, unit((b1.z+b3.z)), CEC3, CEC1) ;


link(E1--E2, CEC1) ;
link(E3--E4, CEC1) ;

triple n3 = unit((b1.z+b3.z)) ;
triple Ea = E + Rcroi*b0.z + Rcroi*n3 ;
link(E3 -- E3 + Rcroi*n3 -- Ea, CEC3) ;
link(E4 -- E4 + Rcroi*n3  -- Ea, CEC3) ;


real l_Opp_D = 2 ;
triple D = Oppp - l_Opp_D*b6.y ;
liaisonPivot(D, b6.x, b6.y, CEC6, CEC7) ;
link(D -- Oppp, CEC6) ;

real b3 = 2 ; // mesurer sur plan
triple I = Ea + b3*n3 ;
triple u3 = unit(cross(n3, b6.x)) ;
liaisonPivot(I, n3, u3, CEC8, CEC3) ;

triple C = I - l_Opp_D*u3 ;
liaisonPivot(C, b6.x, b6.y, CEC8, CEC7) ;

namePoint(D, "D") ;
namePoint(C, "C") ;


link(C--I, CEC8) ;
link(Ea -- I, CEC3) ;
link(C -1*b6.x -- D -1*b6.x, CEC7) ;
namePoint(I, "I") ;




// poulie courroie
triple Z = Opp - 3*b0.y ;
transPoulieCourroie(Opp, b0.z, 0.5, CEC6, Z, b0.z, 1., CEC9) ;
liaisonPivot(Z + (0,0,-2), b0.z, b0.x, CEC0, CEC9) ;
link(Z -- Z + (0,0,-2), CEC9) ;


// basis
showBasis(b0, O, coeff=(5,5,15), style=black+0.25) ;

// finir joliment la poulie encastrée au cylindre - arêtes :
path3 cerclePoulie = circle(Opp,0.35*(2)^(1/2)/2, b0.z) ;
draw(shift(0.15/2*b0.z)*cerclePoulie, CEC6) ;
draw(shift(-0.15/2*b0.z)*cerclePoulie, CEC6) ;
//cerclePoulie = circle(Z,0.35*(2)^(1/2)/2, b0.z) ;
//draw(shift(0.15/2*b0.z)*cerclePoulie, CEC9) ;
//draw(shift(-0.15/2*b0.z)*cerclePoulie, CEC9) ;


// plaque
triple P = I + b3*n3 ;
link(I -- P, CEC3) ;
real s = 2 ;
path3 plaque = s*u3 + s*b6.x -- s*u3 - s*b6.x -- -s*u3 - s*b6.x -- -s*u3 + s*b6.x -- cycle ;
draw(surface(shift(P)*plaque), CEC3+opacity(0.1)) ;
draw(shift(P)*plaque, CEC3) ;

// bati(s)
bati(O-(0,0,1), b0.y, -b0.z, CEC0) ;
link(O -- O-(0,0,1), CEC0) ;

bati(Op+(0,-2,0), b0.z, -b0.y, CEC0) ;
link(Opp -- Opp + (0,0,-1) -- Opp + (0,-1,-1) -- Op + (0,-1,0), CEC0) ;
link(Op -- Op+(0,-2,0), CEC0) ;

bati(Z+(0,-1,-2), b0.z, -b0.y, CEC0) ;
link(Z+(0,-1,-2) -- Z+(0,0,-2), CEC0) ;


