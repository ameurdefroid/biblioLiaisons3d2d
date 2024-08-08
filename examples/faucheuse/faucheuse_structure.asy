/* faucheuse structure */

// parameters
// lengths
real coeff = 1/8 ;
real decA = coeff * 17 ;
real r1 = coeff * 10 ;
real rg = coeff * 13/2 ;
real decD = coeff * 30 ;
real decH = coeff *17 ;
real decF = coeff *17 ;
real decBati = coeff*8 ;

// angle
real theta = pi/4 ;
real phi = atan(-r1*cos(theta)/decD) ;
// LES
real y = sin(phi)*decH ;


// basis
basis b1 = rotationBasis(1, b0, theta, 'x', b0.x) ;
basis b3 = rotationBasis(3, b0, phi, 'z', b0.z) ;

// points
triple A = O - decA*b0.x ;
triple A1 = O - decA/2*b0.x ;
triple B = O + r1*b1.y ;
triple B1 = B - decA/2*b0.x ;
triple D = O + decD*b0.x ;
triple H = D + decH*b0.x ;
triple E = D + decH*b3.x ;
triple F = H + decF*b0.y ;

// CEC
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = blue ;
pen CEC4 = deepgreen ;

// Link
link(A -- A1 -- B1 -- B, CEC1) ;
link(D -- E, CEC3) ;
link(F -- H, CEC4) ;
bati(A+decBati*b0.y, b0.x, b0.y, CEC0) ;
link(A -- A+decBati*b0.y, CEC0) ;
bati(D-decBati*b0.z-decBati*b0.y, b0.x, -b0.y, CEC0) ;
link(D -- D-decBati*b0.z -- D-decBati*b0.z-decBati*b0.y, CEC0) ;
bati(F-decBati*b0.x, b0.y, -b0.x, CEC0) ;
link(F -- F-decBati*b0.x, CEC0) ;


// Bases et paramétrages
showBasis(b0, O, coeff=(decD+decH+1,2*r1+1.5,2*r1+1)) ; 


// Ponctuelle galet / U en C
// Ushape
triple Bproj = O + dot(B-O, b0.y)*b0.y ;
link(D -- Bproj + rg*b3.x -- Bproj + rg*b3.x + rg*b3.y, CEC3) ;
addUshape(Bproj-1.5*r1*b0.z, b3.x, b0.z, 2*rg, 3*r1, 2*rg, CEC3) ;
// galet
real angleStart = pi/3 ;
real angleEnd = 2*pi/3 ;
path3 arcPath = arc(O,rg*cos(angleStart)*b0.x+rg*sin(angleStart)*b0.y,rg*cos(angleEnd)*b0.x+rg*sin(angleEnd)*b0.y, normal=b0.z) ;
revolution galetSurf = revolution(O, arcPath, -b0.x, angle1= 0, angle2=360) ;
draw(shift(B)*galetSurf.silhouette(), CEC2) ;
draw(shift(B)*surface(galetSurf), CEC2+opacity(0.1)) ;
path3 circle1 = shift(B + rg*cos(angleStart)*b0.x)*align(unit(b0.x))*scale(rg*sin(angleStart),rg*sin(angleStart),0)*unitcircle3 ;
draw(circle1, CEC2);
path3 circle2 = shift(B - rg*cos(angleStart)*b0.x)*align(unit(b0.x))*scale(rg*sin(angleStart),rg*sin(angleStart),0)*unitcircle3 ;
draw(circle2, CEC2);
link(B -- B + rg*b0.y, CEC2) ;
link(B -- B - rg*b0.y, CEC2) ;


// teeth jigsaw blade
// motif elementaire dans le plan 
path3 tooth = O --  (1,1/3,0) -- (1,2/3,0) -- (0,1,0) -- cycle ;
real nbTeeth = 3 ;
for(int i=0; i < nbTeeth; ++i) {
   link(shift(H+y*b0.y)*shift((-i*0.75+y-1)*b0.y)*scale3(0.5)*tooth, CEC4) ;
   draw(surface(shift(H+y*b0.y)*shift((-i*0.75+y-1)*b0.y)*scale3(0.5)*tooth), CEC4+0.8*white) ;
}
link(H+y*b0.y -- shift((-(nbTeeth-1)*0.75+y-1)*b0.y)*(H+y*b0.y), CEC4) ;
link(H+y*b0.y -- H+(y+decF+r1)*b0.y, CEC4) ;


// Ponctuelle sphere U 
//Ushape
addUshape(H+y*b0.y-0.25*b0.z, b0.x, b0.z, 0.5, 0.5, 0.5, CEC4) ;
// sphere
real rayonSphere = 0.25 ;
addSphere(E, rayonSphere, CEC3) ;


// liaisons
liaisonPivot(A, b0.x, b1.y, CEC0, CEC1) ;
liaisonPivot(B, b1.x, b1.y, CEC2, CEC1) ;
liaisonPivot(D, b0.z, b0.x, CEC3, CEC0) ;
liaisonGlissiere(F, b0.y, b0.x, CEC0, CEC4) ;


