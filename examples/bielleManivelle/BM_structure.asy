/* Structure bielle manivelle */

// Parameters :
real R = 2 ;
real L = 3 ;
real theta10 = 55/360*2*pi ;
real theta20 = asin(-R/L*sin(theta10)) ;
real pos = R*cos(theta10) + L *sqrt(1-(R/L*sin(theta10))^2) ;

// Basis 
basis b1 = rotationBasis(1, b0, theta10, 'z', b0.z) ;
basis b2 = rotationBasis(2, b0, theta20, 'z', b0.z) ;

// Points
triple A = R*b1.x ;
triple B = pos*b0.x ;
real dec = 1 ;
triple C = B + 2*dec*b0.x ;
triple D = B + 4*dec*b0.x ;

// CEC 
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = deepgreen ;

// Link and ground link
real decBati = 1.25 ;
bati(O-decBati*b0.y, b0.x, -b0.y, CEC0) ;
link(O-decBati*b0.y -- O, CEC0) ;
bati(C-decBati*b0.y, b0.x, -b0.y, CEC0) ;
link(C-decBati*b0.y -- C, CEC0) ;
real prof = -1 ;
path3 pCEC1 = O -- O+prof*b0.z -- A+prof*b0.z -- A ;
link(pCEC1, CEC1) ;
link(A--B, CEC2) ;
link(B--D, CEC3) ;

// Liaisons
liaisonPivot(O, b0.z, b0.x, CEC0, CEC1) ;
liaisonPivotGlissant(A, b0.z, CEC2, CEC1) ;
liaisonRotule(B, -b0.x, CEC2, CEC3) ;
liaisonGlissiere(C, b0.x, b0.y, CEC0, CEC3) ;

// Formes supplémentaires
addCylinder(D, b0.x, 0.35, 0.25, CEC3) ;