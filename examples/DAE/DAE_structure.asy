/* DAE structure */

// Parameters :
real e = 13.44 ;
real lbras = 1.20 ;
real lbielle = 3.56 ;
real lCECcrem = 6.04 ;
real CD = 4 ;
real DE = 1 ;
real h = 0.5 ;
real dec = 1.52 ;
real b = dec + 2 ;
real lJ = 2 ;
real JK = 3 ;
real KL = 2 ;
real Rpignon = 1.5 ;
 
// Relation LES
real theta80 = 0/360*2*pi ; // angle de sortie droit
real theta70 = acos((-(-dec)-lbras*cos(theta80))/(lbielle)) ;
real zcrem = -e/2 -sin(theta80)*lbras + lbielle*sin(theta70) ;
real zcrem2 = lCECcrem + zcrem ;
real theta10 = zcrem/Rpignon ; // volant 


// Bases et points :
basis b1 = rotationBasis(1, b0, theta10, 'x', b0.x) ;
basis b8 = rotationBasis(8, b0, theta80, 'y', b0.y) ;

triple A = e/2*b0.z ;
triple G = -e/2*b0.z ;
triple I = h*b0.y + b*b0.x ;
triple H = dec*b0.x + h*b0.y ;
triple Hp = dec*b0.x ;
triple J = I + lJ*b0.x ;
triple K = J + JK*b0.x  ;
triple L = K + KL*b0.x ;
triple E = Hp  + zcrem*b0.z ;
triple C = E + lCECcrem*b0.z ;
triple D = (0.6*zcrem) *b0.z +  dec*b0.x;
triple F = G + lbras*b8.x ;

// LES autre partie : pour faire autrement
/* pour placer le point B correctement 
   intersection des cercles trajectoires
   en 3d une surface et un path
   le premier ou le dernier point du tableau en fonction du sens de création du cercle
   ici j'ai vérifié à la main du coup
   -> le dernier */

path3 circle1 = circle(C, lbielle, normal=b0.y);
path3 circle2 = circle(A, lbras, normal=b0.y);
triple[] inter = intersectionpoints(circle1, surface(circle2));
triple B = inter.pop() ;
basis b6 ;
b6.x = unit(B-A) ;



// CEC 
pen CEC0 = black ;
pen CEC1 = blue ;
pen CEC2 = orange ;
pen CEC3 = deepgreen ;
pen CEC4 = purple ;
pen CEC5 = magenta ;
pen CEC6 = red ;
pen CEC7 = magenta ;
pen CEC8 = red ;



// relier :
link(L -- K, CEC1) ;
link(J -- K, CEC2) ;
link(J -- I, CEC3) ;
link(H -- I, CEC3) ;
link(C -- Hp, CEC4) ;
link(D -- Hp, CEC4) ;
link(E -- D, CEC4) ;
link(C -- B, CEC5) ;
link(A -- B, CEC6) ;
link(E -- F, CEC7) ;
link(F -- G, CEC8) ;


// Bâti
bati(L+(0,-1-h,0), b0.x, -b0.y, CEC0) ;
bati(I+(0,-1-h,0), b0.x, -b0.y, CEC0) ;
bati(A+(0,-1,0), b0.x, -b0.y, CEC0) ;
bati(G+(0,-1,0), b0.x, -b0.y, CEC0) ;
bati(D+(0,-1,0), b0.z, -b0.y, CEC0) ;

link(L -- L+(0,-1-h,0), CEC0) ;
link(I -- I+(0,-1-h,0), CEC0) ;
link(A -- A+(0,-1,0), CEC0) ;
link(G -- G+(0,-1,0), CEC0) ;
link(D -- D+(0,-1,0), CEC0) ;


// Liaisons
liaisonPivot(A, b0.y, b0.x, CEC6, CEC0) ;
liaisonPivot(G, b0.y, b0.x, CEC8, CEC0) ;
liaisonPivot(I, b0.x, b1.z, CEC0, CEC3) ;
liaisonPivot(L, b0.x, b1.y, CEC0, CEC1) ;
transPignonCremailliere(H, b0.x, CEC3, Hp, b0.z, Rpignon, CEC4) ;
liaisonRotuleDoigt(J, b0.x, b0.y, CEC2, CEC3, rapide=true) ;
liaisonRotuleDoigt(K, -b0.x, b0.z, CEC2, CEC1, rapide=true) ;
liaisonGlissiere(D, b0.z, b0.x, CEC0, CEC4) ;
liaisonRotule(C, b0.z, CEC5, CEC4) ;
liaisonRotule(E, -b0.z, CEC7, CEC4) ;
liaisonRotule(B, b6.x, CEC5, CEC6) ;
liaisonRotule(F, b8.x, CEC7, CEC8) ;
