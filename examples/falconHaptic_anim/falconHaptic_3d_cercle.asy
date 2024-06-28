/* FaucFalconHapticheuse 
   v1.0
   Exemple de la bibliothèque
   26/06/2024
   Anthony Meurdefroid */

   /* anim cercle */


// Paramètres de sortie
// settings.outformat = "pdf" ;
// settings.render = -4 ; 
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
triple eye = (1,0.5,0.5) ;
// quel vecteur vers le haut
triple up = (0,1,0) ;
// MAJ scène + pas d'effet de lumière (variables globales importées par les packages)
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight;


// parameters
// lengths
real coeff = 1/10 ;
real a = coeff * 60 ;
real b = coeff * 102.5 ;
real c = coeff * 15.7 ;
real d = coeff * 11.5 ;
real e = coeff * 11.5 ;
real f = coeff * 26.2 ;
real g = coeff * 27.9 ;
real r = coeff * 36.6 ;
real s = coeff * 27.2 ;
// pour le bras
real Rb = coeff * 56 ;
real angleRb = pi ;
real angleOffsetRb = 150/360*2*pi ;
real epRb = coeff * 18 ;
// sans mise à l'échelle
real dec = 1 ;

// boite
triple coinBas = (-(r+Rb), -(r+Rb), -(Rb)) ;
triple coinHaut = ((r+Rb), (r+Rb), (180*coeff+dec)) ;
parallelepipedBounding(coinBas, coinHaut) ;

// basis 0
showBasis(b0, O, coeff=(r+Rb+dec,r+Rb+dec, 180*coeff + 2*dec), style=black+0.25) ;

// angle des bras sur la stucture
real offset = 14.44/360*2*pi ;
real phi1 = offset + pi/2 ;
real phi2 = offset + pi/2 + 2*pi/3 ;
real phi3 = offset + pi/2 + 4*pi/3 ;

real [] tabPhi = {phi1, phi2, phi3} ;

// astuce pour documentation
// animationScriptPython()
// LES 
// à partir de px py pz on détermine les 9 angles

real theta11 = -43.91176741617755/360*2*pi ;
real theta12 = -121.37904182964914/360*2*pi ;
real theta13 = -101.5025119978509/360*2*pi ;

real theta21 = -52.758992671300945/360*2*pi ;
real theta22 = -127.33858559183459/360*2*pi ;
real theta23 = -83.3608370861816/360*2*pi ;

real theta31 = -33.95648982439326/360*2*pi ;
real theta32 = -114.62790830330272/360*2*pi ;
real theta33 = -83.50808130826137/360*2*pi ;

real [][] tabTheta = {{theta11, theta12, theta13}, {theta21, theta22, theta23}, {theta31, theta32, theta33}} ;



// CEC
pen CEC0 = black ;
pen CEC1 = magenta ;
pen CEC2 = deepgreen ;
pen CEC3 = blue ;
pen CEC4 = red ;
pen CEC5 = lightolive ;

// répétition du bras
int nbBras = 3 ;
for (int i=0; i < nbBras; ++i) {

   // Extraction
   real theta1 = tabTheta[i][0] ;
   real theta2 = tabTheta[i][1] ;
   real theta3 = tabTheta[i][2] ;
   real phi = tabPhi[i] ;


   // local basis 
   basis b1 = rotationBasis(1, b0, phi, 'z', b0.z) ;
   basis b11 = rotationBasis(11, b1, theta1, 'y', b1.y) ;
   basis b12 = rotationBasis(12, b1, theta2, 'y', b1.y) ;
   basis b13 = rotationBasis(13, b12, theta3, 'z', b12.z) ;

   // points
   triple A = r*b1.x - s*b1.y ;
   triple B = A + a*b11.x ;
   triple C = B + e*b12.x ;
   triple D = C + b*b13.y ;
   triple E = D + d*b12.x ;
   triple P = E - c*b1.x + f*b1.y ;

   triple F = C - g/2*b1.y ;
   triple G = C + g/2*b1.y ;
   triple H = D - g/2*b1.y ;
   triple I = D + g/2*b1.y ;

   // Habillage
   link(O -- O - s*b1.y -- A, CEC0) ;
   //link(A - dec*b1.y  -- B - dec*b1.y, CEC1) ;
   link(B -- C -- F -- G, CEC2) ;
   link(F - dec*b12.z -- H - dec*b12.z, CEC3) ;
   link(I - dec*b12.z -- G - dec*b12.z, CEC3) ;
   link(E -- D -- H -- I, CEC4) ;
   link(E -- E + f*b1.y -- P, CEC5) ;

   // Forme particulière
   basis b111 = rotationBasis(111, b11, angleRb, 'y', b11.y) ;
   basis b112 = rotationBasis(112, b111, -angleOffsetRb, 'y', b111.y) ;
   triple A1 = A + Rb*b111.x ;
   triple A2 = A + Rb*b112.x ;
   link(B+dec*b1.y -- A2+dec*b1.y -- A2, CEC1) ;
   link(A+dec*b1.y -- A1+dec*b1.y -- A1, CEC1) ;

   path3 line = -epRb/2*b0.x -- epRb/2*b0.x ;
   // compliqué pour rien ...
   draw(shift(A1)*rotate((phi-pi/2)/(2*pi)*360, O, b0.z)*line, CEC1) ;
   draw(shift(A2)*rotate((phi-pi/2)/(2*pi)*360, O, b0.z)*line, CEC1) ;
   revolution portionCyl = revolution(O, shift(O+Rb*b111.x)*rotate((phi-pi/2)/(2*pi)*360, O, b0.z)*line, -b1.y, angle1=0, angle2=angleOffsetRb*360/(2*pi)) ;
   draw(shift(A)*surface(portionCyl), CEC1+opacity(0.1)) ;


   // Liaisons
   liaisonPivot(A, b1.y, b11.z, CEC0, CEC1) ;
   liaisonPivot(B, b1.y, b11.z, CEC2, CEC1) ;
   liaisonPivot(F, b12.z, b13.y, CEC2, CEC3) ;
   liaisonPivot(G, b12.z, b13.y, CEC2, CEC3) ;
   liaisonPivot(H, b12.z, b13.y, CEC4, CEC3) ;
   liaisonPivot(I, b12.z, b13.y, CEC4, CEC3) ;
   liaisonPivot(E, b1.y, b1.z, CEC4, CEC5) ;

   // Noms des points
   //surcharge
   /*namePoint(O,"O",SE) ;
   namePoint(A,"A_1",SE) ;
   namePoint(B,"B",SE) ;
   namePoint(C,"C",SE) ;
   namePoint(D,"D",SE) ;
   namePoint(E,"E",SE) ;
   namePoint(P,"P(20.8,5.2,147)",SE) ;
   namePoint(F,"F",SE) ;
   namePoint(G,"G",SE) ;
   namePoint(H,"H",SE) ;
   namePoint(I,"I",SE) ;*/

   if (i==0){
      addDisque(O, b0.z, s, CEC0) ;
      addDisque(P, b0.z, c, CEC5) ;
      triple Poignee = P + 3*dec*b0.z ;
      link(P -- Poignee, CEC5) ;
      addSphere(Poignee, 1.5*dec, CEC5) ;
      path3 trajectoire = unitcircle3 ;
      draw(shift((140*coeff + 3*dec)*b0.z)*align(b0.z)*scale3(50*coeff)*trajectoire, black+dashed+0.5) ;
   }
}








