/* Structure sinusmatic */

// Parameters :

real OB = 3 ;
real OC = 3 ;
real OA = 1 ;
real CD = 4 ;
real DE = 1 ;


real theta10 = -30/360*2*pi ;
// Relation LES
real theta21 = atan(OC/OB) ;
real theta40 = atan(-OB/OC*sin(theta10)) ;


// Bases et points :
basis b1 = rotationBasis(1, b0, theta10, 'y', b0.y) ;
basis b2 = rotationBasis(2, b1, theta21, 'z', b1.z) ;
basis b4 = rotationBasis(4, b0, theta40, 'x', b0.x) ;


triple A = -OA*b0.y ;
triple B = -OB*b1.x ;
triple C = OC*b0.y ;
triple D = C + CD*b0.x ;
triple E = D + DE*b0.x ;

real posPG = 1/2*length(C-B) ;
triple B1 = B + posPG*b2.x ;
triple A1 = A - 1*b0.x ;
triple D1 = D - 1*b0.y ;


// CEC 
pen CEC0 = black ;
pen CEC1 = blue ;
pen CEC2 = orange ;
pen CEC3 = deepgreen ;
pen CEC4 = red ;

// Liaisons
liaisonPivot(A, b0.y, b1.z, CEC0, CEC1) ;
liaisonRotule(B, b2.x, CEC2, CEC1) ;
liaisonPivotGlissant(B1, b2.x, CEC2, CEC3) ;
liaisonPivot(C, b4.z, b4.x, CEC3, CEC4) ;
liaisonPivot(D, b0.x, b0.z, CEC0, CEC4) ;

// relier :
link(O -- -3/4*OB*b1.x -- -3/4*OB*b1.x-0.5*b0.y -- -OB*b1.x-0.5*b0.y -- B, CEC1 ) ;
link(B -- B + 1/3*posPG*b2.x -- B + 1/3*posPG*b2.x +0.5*b2.y 
-- B + 1*posPG*b2.x +0.5*b2.y  -- B1, CEC2) ;
link(B1 -- C, CEC3) ;
link(C -- C+1*b4.z -- C+1*b4.z+1*b0.x -- C+1*b0.x -- D, CEC4) ;

// Bâti
link(D -- D1, CEC0) ;
bati(D1, b0.x, -b0.y, CEC0) ;
link(A -- A1, CEC0) ;
bati(A1, b0.y, -b0.x, CEC0) ;