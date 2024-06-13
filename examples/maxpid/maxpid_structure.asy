/* Maxpid structure */

// Parameters :
real Lx = 5 ;
real Ly = 3 ;
real R = 3 ;
real dec = 1.75 ;

// Relation LES
real theta20 = 40/360*2*pi ;
real lambda = sqrt(Lx^2 + Ly^2 + R^2  - 2*Ly*R*sin(theta20) + 2*Lx*R*cos(theta20)) ;
real theta10 = atan((R*sin(theta20)-Ly)/(Lx+R*cos(theta20))) ;
real pas = 0.6 ;
real theta31 = 2*pi / pas * lambda ;

// Bases et points :
basis b1 = rotationBasis(1, b0, theta10, 'z', b0.z) ;
basis b2 = rotationBasis(2, b0, theta20, 'z', b0.z) ;
basis b3 = rotationBasis(3, b1, theta31, 'x', b1.x) ;


triple A = Lx*b0.x ;
triple B = Ly*b0.y ;
triple C = A + R*b2.x ;
triple B1 = B + dec*b1.x ;
triple C1 = C - dec*b1.x ;


// CEC 
pen CEC0 = black ;
pen CEC1 = red ;
pen CEC2 = purple ;
pen CEC3 = deepgreen ;
pen CEC4 = blue ;

// Liaisons
liaisonPivot(A, b0.z, b0.x, CEC4, CEC0) ;
liaisonPivot(B, b0.z, b0.x, CEC1, CEC0) ;
liaisonPivot(C, b0.z, b2.y, CEC4, CEC3) ;
liaisonPivot(B1, b1.x, b3.y, CEC1, CEC2) ;
liaisonHelicoidale(C1, b1.x, CEC3, CEC2) ;


// Relier et bâti
bati(O, -b0.x, -b0.y, CEC0) ;
link(B-1*b0.z -- B-1*b0.z-1b0.y -- B-1*b0.y -- O -- A-1*b0.x -- A-1*b0.x-1*b0.z -- A-1*b0.z , CEC0) ;
link(A--C, CEC4) ;
link(B-- B+0.75*b1.y --  B+0.75*b1.y +dec*b1.x -- B1, CEC1) ;
link(C1 -- C1 + 1*b1.y -- C1 + 1*b1.y -1*b0.z --  C+ 1*b1.y -1*b0.z --  C -1*b0.z -- C, CEC3) ;
real lvis = sqrt((R+Lx)^2+Ly^2) - 2*dec + 1 ;
link(B1 - 1*b1.x -- B1 + lvis*b1.x, CEC2) ;
real brasSupp = 4 ;
triple D = C + brasSupp*b2.x ;
link(C -- D, CEC4) ;


// Formes en plus
addCylinder(D, b2.x, 0.5, 0.25, CEC4) ;