// Parameters
real esp = 2 ;
real R1 = 0.5 ;
real R3 = 3 ;
real R2 = (R3-R1)/2 ;

// creation des points
triple A = O + esp*b0.x ;
triple B = A + (R1+R2)*b0.y ;
triple C = B + esp*b0.x ;
triple D = A + 2*esp*b0.x ;
triple E = D + 1.5*esp*b0.x ;



// Couleurs CEC
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = blue ;
pen CEC3 = deepgreen ;
pen CEC4 = purple ;



// base
showBasis(b0, O, coeff=(length(E-O)+2, R3+1, R3+1)) ; 

// Habillage commun
// CEC
link(O--A, CEC1) ;
link(B--C, CEC2) ;
link(C -- D-esp*b0.x -- D, CEC3) ;

// Bâti
real decBati = -1 ;
triple O1 = O + decBati*b0.y ;
triple D1 = D + decBati*b0.y ;
triple E1 = E + decBati*b0.y ;
link(O -- O1, CEC0) ;
link(D -- D1, CEC0) ;
link(E -- E1, CEC0) ;
bati(O1, b0.x, -b0.y, CEC0) ;
bati(D1, b0.x, -b0.y, CEC0) ;
bati(E1, b0.x, -b0.y, CEC0) ;

// Liaisons
liaisonPivot(O, b0.x, b0.y, CEC0, CEC1) ;
transEngrenages(A, b0.x, R1, CEC1, B, b0.x, CEC2) ;
transEngrenages(A, b0.x, R3, CEC4, B, b0.x, CEC2, offset=length(E-A)-1) ;
liaisonPivot(C, b0.x, b0.y, CEC3, CEC2) ;
liaisonPivot(D, b0.x, b0.y, CEC0, CEC3) ;
liaisonPivot(E, b0.x, b0.y, CEC0, CEC4) ;

