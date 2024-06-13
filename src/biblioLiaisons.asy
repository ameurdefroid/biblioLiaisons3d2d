/* Bibilotheque de liaisons mécaniques V Fr
Non performant mais pratique.
v.0.1
Anthony Meurdefroid
*/

/* -------------------------------------- */
/* imports packages */

import three ;
import solids ;
// home package for stl file
import STLforBLM ;
import animation ;







/* ------------------------------------ */ 

/* Auxillary function */

//https://www.123calculus.com/point-plan-plus-proche-page-7-60-600.html
// point au hasard -> projeté sur le plan -> construction d'une base
triple vecteurLocalOrth(triple point, triple axis) {
real A = axis.x ;
real B = axis.y ;
real C = axis.z ;
real D = - A*point.x - B*point.y -C*point.z ;

real a = 3.14159, b = 6.24159, c = 6.34159 ;
// si par hasard c'est le même point ...
if (point.x==a && point.y==b && point.x==c) {
    a = a+1;
}

// point du plan le plus proche d'un point improbable :
real tN = - (a*A+b*B+c*C+D) / (A^2+B^2+C^2) ;
real xN = a + tN*A ;
real yN = b + tN*B ;
real zN = c + tN*C ;
triple v = (xN-point.x, yN-point.y, zN-point.z) ;
return unit(v) ;
}


// plane ?

bool isPlane(triple eye) {
    bool cond = false ;
if (eye.x == eye.y && eye.x == 0) {cond = true;}
else if (eye.y == eye.z && eye.y ==  0) {cond = true;}
else if (eye.x == eye.z && eye.x ==  0) {cond = true;}
    else {cond = false;}
return cond ;
}


/* ------------------------------------ */ 




/* -------------------------------------- */
/* New objects */
// Basis
struct basis  {
triple x ;
triple y ;
triple z ;
triple[] tab = new triple[3];
int number ;
real angle ;
basis parent ;
triple shareAxis ;
}

// Create a new basis j/i with angular position theta about axis of rotation
basis rotationBasis(int number, basis parent, real theta, string axis, triple axisShared) {
write('Begin basis ' + (string)number + ' ... ' ) ;
basis newBasis ;
newBasis.parent = parent ;
newBasis.angle = theta ;
if (axis == 'x') {
newBasis.y = cos(theta)*parent.y + sin(theta)*parent.z ;
newBasis.z = cos(theta)*parent.z - sin(theta)*parent.y ;
newBasis.x = axisShared ;
}
else if (axis == 'y') {
newBasis.z = cos(theta)*parent.z + sin(theta)*parent.x ;
newBasis.x = cos(theta)*parent.x - sin(theta)*parent.z ;
newBasis.y = axisShared ;
}
else 
{
newBasis.x = cos(theta)*parent.x + sin(theta)*parent.y ;
newBasis.y = cos(theta)*parent.y - sin(theta)*parent.x ;
newBasis.z = axisShared ;
}
newBasis.tab[0] = newBasis.x ;
newBasis.tab[1] = newBasis.y ;
newBasis.tab[2] = newBasis.z ;
newBasis.number = number ;
newBasis.shareAxis = axisShared ;
write('... end basis ' + (string)number + '. \n ') ;
return newBasis ;
}



basis createBasis(int number, basis parent, real theta, triple x, triple y) {
write('Begin basis ...') ;
triple z = unit(cross(x,y)) ; 
basis newBasis ;
newBasis.parent = parent ;
newBasis.angle = theta ;
newBasis.x = newBasis.tab[0] = x ;
newBasis.y = newBasis.tab[1] = y ;
newBasis.z = newBasis.tab[2] = z ;
newBasis.number = number ;
newBasis.shareAxis = z ;
write('... end basis.\n') ;
return newBasis ;
}




void showBasis(basis b, triple point, triple coeff=(1,1,1), pen style=black+0.25) {
string number = (string)b.number ;
write('show basis ' + number + ' ... ') ; 
real rr = 0.1 ; // rayon axe perp

path3 temp ;
string label ;
align alignLocal ;
// z
temp = point -- point+coeff.z*b.z ;
label = "$\vec{z}_{"+number+"}$" ;
alignLocal = project(1*b.z) ;
if (!isPlane(currentprojection.camera)) {
draw(temp, style, Arrow3) ;
label(label, point+coeff.z*b.z, style, align=alignLocal) ;
}
else {
if (abs(dot(b.z, currentprojection.camera)) != 1) {
    draw(project(temp), style, Arrow) ;
    label(label, project(point+coeff.z*b.z), style, align=alignLocal) ;
}
else {
    path3 c = shift(point)*align(unit(b.z))*scale(rr,rr,0)*unitcircle3 ; 
    filldraw(project(c), white, style) ;
    label(label, project(point+coeff.z*b.z), style, align=(-2,-2)) ;
}
}

// y
temp = point -- point+coeff.y*b.y ;
label = "$\vec{y}_{"+number+"}$" ;
alignLocal = project(1*b.y) ;
if (!isPlane(currentprojection.camera)) {
draw(temp, style, Arrow3) ;
label(label, point+coeff.y*b.y, style, align=alignLocal) ;
}
else {
if (abs(dot(b.y, currentprojection.camera)) != 1) {
    draw(project(temp), style, Arrow) ;
    label(label, project(point+coeff.y*b.y), style, align=alignLocal) ;
}
else {
    path3 c = shift(point)*align(unit(b.y))*scale(rr,rr,0)*unitcircle3 ; 
    filldraw(project(c), white, style) ;
    label(label, project(point+coeff.y*b.y), style, align=(-2,-2)) ;
}
}

// x
temp = point -- point+coeff.x*b.x ;
label = "$\vec{x}_{"+number+"}$" ;
alignLocal = project(1*b.x) ;
if (!isPlane(currentprojection.camera)) {
draw(temp, style, Arrow3) ;
label(label, point+coeff.x*b.x, style, align=alignLocal) ;
}
else {
if (abs(dot(b.x, currentprojection.camera)) != 1) {
    draw(project(temp), style, Arrow) ;
    label(label, project(point+coeff.x*b.x), style, align=alignLocal) ;
}
else {
    path3 c = shift(point)*align(unit(b.x))*scale(rr,rr,0)*unitcircle3 ; 
    filldraw(project(c), white, style) ;
    label(label, project(point+coeff.x*b.x), style, align=(-2,-2)) ;
}
}

write('... end show basis ' + number + '.\n') ; 
}


void showAxis(basis b, int[] tabAxis, triple point, real coeff=1, pen style=black+0.25) {

string number = (string)b.number ;
string label ;
for (int i=0; i<tabAxis.length; ++i){
    if (!isPlane(currentprojection.camera)) {
    draw(point--point+coeff*b.tab[tabAxis[i]], style, Arrow3) ; 
    }
    else {
    draw(project(point--point+coeff*b.tab[tabAxis[i]]), style, Arrow) ;   
    }
    if (tabAxis[i] == 0) {
    label = "$\vec{x}_{"+number+"}$" ; }
    else if (tabAxis[i] == 1) {
    label = "$\vec{y}_{"+number+"}$" ; }
    else {
    label = "$\vec{z}_{"+number+"}$" ; }

    align alignLocal = project(1*b.tab[tabAxis[i]]) ;
    if (!isPlane(currentprojection.camera)) {   
    label(label, point+coeff*b.tab[tabAxis[i]], style, align=alignLocal) ;}
    else {
        label(label, project(point+coeff*b.tab[tabAxis[i]]), style, align=alignLocal) ;
    }
}
}


/*---------------------------*/

void showParameter(triple point, triple axis1, triple axis2, string name, real coeff=1, pen style=black+0.25) {

triple axeLocal = unit(axis1+axis2) ;
align alignLocal = project(1*axeLocal) ;

if (!isPlane(currentprojection.camera)) {
draw(L=Label(name, position=Relative(0.5), align=alignLocal), 
arc(point, point+coeff*axis1, point+coeff*axis2), style, Arrow3) ;
}
else {
    draw(L=Label(name, position=Relative(0.5), align=alignLocal), 
    project(arc(point, point+coeff*axis1, point+coeff*axis2)), style, Arrow) ;

}

}


int [] AxesToDraw(basis b, triple point) {

bool test = false ;
int i=0 ;
while (i<b.tab.length && test) {
test = b.tab[i] == b.shareAxis ;
++i ;
}
int [] tabAxis ={} ;
if (i-1==0) {
   tabAxis.push(1) ;
   tabAxis.push(2) ;}
else if (i-1==1) {
   tabAxis.push(0) ;
   tabAxis.push(2) ;}
else {
   tabAxis.push(0) ;
   tabAxis.push(1) ;}
showAxis(b, tabAxis, point) ;
return tabAxis ;
}



void changeBasis(basis b2, basis b1, triple point,string name) {

showBasis(b1, point) ;
int [] tabAxis = AxesToDraw(b2, point) ;
write('fnkleùnfk ', tabAxis) ;
triple axis1 ;
triple axis2 ;
for (int i=0;i<2;++i) {
axis1 = b1.tab[tabAxis[i]] ;
axis2 = b2.tab[tabAxis[i]] ;
showParameter(point, axis1, axis2, name) ;}
}




/* -------------------------------------- */
/* Default object */
triple O = (0,0,0) ;
triple x0 = (1,0,0) ;
triple y0 = (0,1,0) ;
triple z0 = (0,0,1) ;

basis b0 ;
b0.x = b0.tab[0] = x0 ;
b0.y = b0.tab[1] = y0 ;
b0.z = b0.tab[2] = z0 ;
b0.number = 0 ;






/* -------------------------------------- */
/* Parameters */
// default thickness
defaultpen(0.75);













/* ------------------------------------ */
/* Joints */

/* ------------------------------------ */ 
/* 1 dof - translation -- "Glissière" */

void liaisonGlissiere(triple center, triple direction, triple orientation, pen c1, pen c2) {
write('Begin glissiere : point ' + (string)center + ', axis ' + (string)direction + ' ... ') ;

// dimensions
real a = 0.35 ;
real L = 1 ;
real t = 2 ;
triple Zlocal = unit(cross(direction, orientation)) ;

if (!isPlane(currentprojection.camera)) {
// Points
triple P1 = shift(-L/2*direction)*(-a/2*orientation - a/2*Zlocal) ; 
triple P2 = shift(-L/2*direction)*(+a/2*orientation - a/2*Zlocal) ; 
triple P3 = shift(-L/2*direction)*(+a/2*orientation + a/2*Zlocal) ; 
triple P4 = shift(-L/2*direction)*(-a/2*orientation + a/2*Zlocal) ; 


// paths
path3 square1 = P1 -- P2 -- P3 -- P4 -- cycle ;
path3 square2 = shift(L*direction)*(square1) ;

draw(shift(center)*square1, c1) ;
draw(shift(center)*square2, c1) ;
draw(shift(center)*(P1--P3), c2) ;
draw(shift(center)*(P2--P4), c2) ;
draw(shift(center)*shift(L*direction)*(P1--P3), c2) ;
draw(shift(center)*shift(L*direction)*(P2--P4), c2) ;

surface parallelipipede = extrude(square1, L*direction) ;
draw(shift(center)*parallelipipede,white) ;
draw(shift(center)*surface(square1),white) ;
draw(shift(center)*surface(square2),white) ;

draw(shift(center)*(P1 -- shift(L*direction)*P1), c1) ;
draw(shift(center)*(P2 -- shift(L*direction)*P2), c1) ;
draw(shift(center)*(P3 -- shift(L*direction)*P3), c1) ;
draw(shift(center)*(P4 -- shift(L*direction)*P4), c1) ;

draw(shift(center)*(-t/2*direction -- t/2*direction), c2) ;
}
else {
if (dot(currentprojection.camera, direction) == 1) {
    write('ortho') ;
    // Points
    triple P1 = (-a/2*orientation - a/2*Zlocal) ; 
    triple P2 = (+a/2*orientation - a/2*Zlocal) ; 
    triple P3 = (+a/2*orientation + a/2*Zlocal) ; 
    triple P4 = (-a/2*orientation + a/2*Zlocal) ; 

    path3 square = P1 -- P2 -- P3 -- P4 -- cycle ;
    filldraw(project(shift(center)*square), white, c1) ;
    draw(project(shift(center)*(P1 -- P3)), c2) ;
    draw(project(shift(center)*(P2 -- P4)), c2) ;
    draw(project(shift(center)*square), c1) ;
}
else if (dot(currentprojection.camera, direction) == 0) {
    write('in the plane') ;
     // Points
    if (abs(dot(orientation, currentprojection.camera)) == 1) {
        orientation = unit(cross(currentprojection.camera, direction)) ;
    }
    triple P1 = (-L/2*direction - a/2*orientation) ; 
    triple P2 = (+L/2*direction - a/2*orientation) ; 
    triple P3 = (+L/2*direction + a/2*orientation) ; 
    triple P4 = (-L/2*direction + a/2*orientation) ; 
    path3 square = P1 -- P2 -- P3 -- P4 -- cycle ;
    draw(project(shift(center)*(-t/2*direction -- t/2*direction)), c2) ;
    filldraw(project(shift(center)*square), white, c1) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end glissiere : point ' + (string)center + ', axis ' + (string)direction + '.\n') ;
}

/* ------------------------------------ */ 



/* ------------------------------------ */ 
/* 1 dof - rotation -- "Pivot" */

void liaisonPivot(triple point, triple axis, triple stopAxis, pen c1, pen c2) {
write('Begin pivot : point ' + (string)point + ', axis ' + (string)axis + ' ...') ;
//PArameters
real cyl_r = 0.35*(2)^(1/2)/2 ;
real cyl_h = 1 ;
real posStop = 3/4 ;
real lStop = 0.25 ;

if (!isPlane(currentprojection.camera)) {

revolution cylSolid = cylinder(-cyl_h/2*unit(axis), cyl_r, cyl_h, axis) ;
surface cylinder = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitcylinder ;
surface disq_cyl = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitdisk ;
surface disq_cyl1 = shift(point)*align(unit(axis))*shift((0,0,cyl_h/2))*scale(cyl_r,cyl_r,0)*unitdisk ;

draw(cylinder, white) ;
draw(disq_cyl, white) ;
draw(disq_cyl1, white) ;
draw(point-cyl_h*unit(axis)--point+cyl_h*unit(axis), c2) ;
draw(point-posStop*cyl_h*unit(axis) + lStop*stopAxis --point-posStop*cyl_h*unit(axis) - lStop*stopAxis, c2);
draw(point+posStop*cyl_h*unit(axis) + lStop*stopAxis --point+posStop*cyl_h*unit(axis) - lStop*stopAxis, c2);

// In case of silhouette pb ...
path3 circle = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3 ;
draw(shift(-cyl_h/2*unit(axis))*circle, c1) ;
draw(shift(+cyl_h/2*unit(axis))*circle, c1) ;

draw(shift(point)*cylSolid.silhouette(), c1) ;

}
else {
if (abs(dot(currentprojection.camera, axis)) == 1) {
    write('ortho') ;
    path3 c = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3 ;
    filldraw(project(c), white, c1) ;
}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    triple axisPerp = unit(cross(currentprojection.camera, axis)) ;
    path3 rectangle = + 1/2*cyl_h*axis + cyl_r*axisPerp  --   - 1/2*cyl_h*axis + cyl_r*axisPerp 
    -- -1/2*cyl_h*axis - cyl_r*axisPerp -- +1/2*cyl_h*axis - cyl_r*axisPerp -- cycle ;
    filldraw(project(shift(point)*rectangle), white, c1) ;
    path3 line = -cyl_h*unit(axis)-- +cyl_h*unit(axis) ;
    draw(project(shift(point)*line), c2) ;
    path3 stop1 = -posStop*cyl_h*unit(axis) + lStop*axisPerp -- -posStop*cyl_h*unit(axis) - lStop*axisPerp ;
    path3 stop2 = +posStop*cyl_h*unit(axis) + lStop*axisPerp -- +posStop*cyl_h*unit(axis) - lStop*axisPerp ;
    draw(project(shift(point)*stop1), c2) ;
    draw(project(shift(point)*stop2), c2) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end pivot : point ' + (string)point + ', axis ' + (string)axis + '.\n') ;
}

/* ------------------------------------ */ 



/* ------------------------------------ */ 
/* 1 dof - screw -- "Hélicoïdale" */

void liaisonHelicoidale(triple point, triple axis, pen c1, pen c2) {
write('Begin helicoidale : point ' + (string)point + ', axis ' + (string)axis + ' ...') ;
real cyl_r = 0.35*(2)^(1/2)/2 ;
real cyl_h = 1 ;
real t = 2 ;

triple axisPerp = vecteurLocalOrth(point, axis) ;
triple axisPerp2 = unit(cross(axis, axisPerp)) ;

real pas = 3.0 ;

if (!isPlane(currentprojection.camera)) {

revolution cylSolid = cylinder(-cyl_h/2*unit(axis), cyl_r, cyl_h, axis) ;
surface cylinder = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitcylinder ;
surface disq_cyl = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitdisk ;
surface disq_cyl1 = shift(point)*align(unit(axis))*shift((0,0,cyl_h/2))*scale(cyl_r,cyl_r,0)*unitdisk ;

draw(shift(point)*cylSolid.silhouette(128), c1) ;
draw(cylinder, white) ;
draw(disq_cyl, white) ;
draw(disq_cyl1, white) ;
draw(point-cyl_h*unit(axis)--point+cyl_h*unit(axis), c2) ;

// In case of silhouette pb ...
path3 circle = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3 ;
draw(shift(-cyl_h/2*unit(axis))*circle, c1) ;
draw(shift(+cyl_h/2*unit(axis))*circle, c1) ;


real xl(real t) {return axisPerp.x*cyl_r*cos(pas*2*pi*t) + axisPerp2.x*cyl_r*sin(pas*2*pi*t) + axis.x*t ;}
real yl(real t) {return axisPerp.y*cyl_r*cos(pas*2*pi*t) + axisPerp2.y*cyl_r*sin(pas*2*pi*t) + axis.y*t ;}
real zl(real t) {return axisPerp.z*cyl_r*cos(pas*2*pi*t) + axisPerp2.z*cyl_r*sin(pas*2*pi*t) + axis.z*t ;}


path3 p = graph(xl, yl, zl, -cyl_h/2, +cyl_h/2);
draw(shift(point)*p, c1) ;
}
else 
{
if (dot(currentprojection.camera, axis) == 1) {
    write('ortho') ;
    path3 c = circle(point, cyl_r, normal = axis) ;
    path arcFin = arc(project(point), 0.8*cyl_r, 0., 270.) ;
    filldraw(project(c), white, c1) ;
    draw(arcFin, c2 + 0.5) ;

}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    // Points
    axisPerp = unit(cross(currentprojection.camera, axis)) ;
    triple P1 = (-cyl_h/2*axis - cyl_r*axisPerp) ; 
    triple P2 = (+cyl_h/2*axis - cyl_r*axisPerp) ; 
    triple P3 = (+cyl_h/2*axis + cyl_r*axisPerp) ; 
    triple P4 = (-cyl_h/2*axis + cyl_r*axisPerp) ; 
    path3 square = P1 -- P2 -- P3 -- P4 -- cycle ;
    draw(project(shift(point)*(-t/2*axis -- t/2*axis)), c2) ;
    filldraw(project(shift(point)*square), white, c1) ;

    // filet
    real xl(real tt) {return tt*project(axis).x + 2/3*cyl_r*sin(pas*tt*2*pi/cyl_h)*project(axisPerp).x ;}
    real yl(real tt) {return tt*project(axis).y + 2/3*cyl_r*sin(pas*tt*2*pi/cyl_h)*project(axisPerp).y ;}

    path p = graph(xl, yl, -cyl_h/2, +cyl_h/2) ;
    draw(shift(project(point))*p, c2+0.5) ;
    //superimpose
    draw(project(shift(point)*square), c1) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end helicoidale : point ' + (string)point + ', axis ' + (string)axis + '\n') ;
}

/* ------------------------------------ */ 



/* ------------------------------------ */ 
/* 2 dof - rotation / translation -- "Pivot glissant" */

void liaisonPivotGlissant(triple point, triple axis, pen c1, pen c2) {
write('Begin pivot glissant : point ' + (string)point + ', axis ' + (string)axis + ' ...') ;
//PArameters
real cyl_r = 0.35*(2)^(1/2)/2 ;
real cyl_h = 1 ;
//real posStop = 3/4 ;
//real lStop = 0.3 ;

if (!isPlane(currentprojection.camera)) {

revolution cylSolid = cylinder(-cyl_h/2*unit(axis), cyl_r, cyl_h, axis) ;
surface cylinder = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitcylinder ;
surface disq_cyl = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitdisk ;
surface disq_cyl1 = shift(point)*align(unit(axis))*shift((0,0,cyl_h/2))*scale(cyl_r,cyl_r,0)*unitdisk ;

draw(cylinder, white) ;
draw(disq_cyl, white) ;
draw(disq_cyl1, white) ;
draw(point-cyl_h*unit(axis)--point+cyl_h*unit(axis), c2) ;
//draw(point-posStop*cyl_h*unit(axis) + lStop*stopAxis --point-posStop*cyl_h*unit(axis) - lStop*stopAxis, c2);
//draw(point+posStop*cyl_h*unit(axis) + lStop*stopAxis --point+posStop*cyl_h*unit(axis) - lStop*stopAxis, c2);

// In case of silhouette pb ...
path3 circle = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3 ;
draw(shift(-cyl_h/2*unit(axis))*circle, c1) ;
draw(shift(+cyl_h/2*unit(axis))*circle, c1) ;

draw(shift(point)*cylSolid.silhouette(), c1) ;
}
else {
if (abs(dot(currentprojection.camera, axis)) == 1) {
    write('ortho') ;
    path3 cercle1 = circle(point, cyl_r, normal = axis) ;
    filldraw(project(cercle1), white, c1) ;
    path3 cercle2 = circle(point, 0.05*cyl_r, normal = axis) ;
    filldraw(project(cercle2), c2, c2) ;
}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    triple axisPerp = unit(cross(currentprojection.camera, axis)) ;
    path3 rectangle = + 1/2*cyl_h*axis + cyl_r*axisPerp  --   - 1/2*cyl_h*axis + cyl_r*axisPerp 
    -- -1/2*cyl_h*axis - cyl_r*axisPerp -- +1/2*cyl_h*axis - cyl_r*axisPerp -- cycle ;
    filldraw(project(shift(point)*rectangle), white, c1) ;
    path3 line = -cyl_h*unit(axis)-- +cyl_h*unit(axis) ;
    draw(project(shift(point)*line), c2) ;
    // superimpose
    draw(project(shift(point)*rectangle), c1) ;
    //path3 stop1 = -posStop*cyl_h*unit(axis) + lStop*stopAxis -- -posStop*cyl_h*unit(axis) - lStop*stopAxis ;
    //path3 stop2 = +posStop*cyl_h*unit(axis) + lStop*stopAxis -- +posStop*cyl_h*unit(axis) - lStop*stopAxis ;
    //draw(project(shift(point)*stop1), c2) ;
    //draw(project(shift(point)*stop2), c2) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end pivot glissant : point ' + (string)point + ', axis ' + (string)axis + '\n') ;
}

/* ------------------------------------ */ 






/* ------------------------------------ */ 
/* 2 dof - rotations -- "Rotule à doigt" */

void liaisonRotuleDoigt(triple centre, triple axis, triple tige, pen c1, pen c2, bool rapide=true, triple obs=currentprojection.camera) {
write('Begin rotule a doigt center ' + (string)centre +' ...') ;
// parameters
real R = 0.25 ;
real h = 0.35 ;
real r = 0.25 *R ;
real ep = 0.15 * R ;

if (!isPlane(currentprojection.camera)) {

transform3 matOrientation = shift(centre)*transform3(axis, tige) ;
transform3 normaleOrientation = transform3(axis, tige) ;
string filename  ;
if (rapide == true) {
filename = 'rotuleCreuxDoigtRapide.stl' ;
}
else {
 filename = 'rotuleCreuxDoigt.stl' ;
}
write(filename) ;
objectSTL AAA = readstlfileFull(filename, matOrientation, normaleOrientation, currentprojection.camera ) ;
// Informations 
write('----------------') ;
write('MESH') ;
//write(AAA.mesh) ;
write('nb elements : ' , AAA.mesh.length) ;
write('EDGES') ;
//write(AAA.edges) ;
write('nb edges : ' , AAA.edges.length) ;
write('NORMALS') ;
//write(AAA.normals) ;
write('nb normals : ' , AAA.normals.length) ;
write('VERTICES') ;
//write(AAA.vertices) ;
write('nb vertices : ', AAA.vertices.length) ;
write('----------------') ;
write('TABINDICES MESH') ;
//write(AAA.tabIndicesMesh) ;
write('nb : ', AAA.tabIndicesMesh.length) ;
write('----------------') ;
write('EDGES TO DRAW') ;
//write(AAA.edgesToDraw) ;
write('nb : ', AAA.edgesToDraw.length) ;
write('----------------') ;



draw(AAA.surf, white) ;
draw(AAA.edgesToDraw, c2) ;

surface bouleSurf = shift(centre)*align(unit(axis))*scale3(R)*unitsphere ;
draw(bouleSurf, white) ;
revolution bouleRev = sphere(O, R) ;
draw (shift(centre)*bouleRev.silhouette(64),c1) ;

revolution cylSolid = normaleOrientation*cylinder(O, r, h, b0.y) ;
surface cylinder = align(unit(b0.y))*scale(r,r,h)*unitcylinder;
surface disq_cyl = shift(h*b0.y)*align(unit(b0.y))*scale(r,r,h)*unitdisk;
surface disq_cyl1 = align(unit(b0.y))*scale(r,r,h)*unitdisk;

real coeffProj = R*cos(asin(r/R)) ;
path3 inter = shift(coeffProj*b0.y)*align(unit(b0.y))*scale3(r)*unitcircle3 ;
path3 bout = align(unit(b0.y))*scale3(r)*unitcircle3  ;

draw(matOrientation*cylinder, white) ;
draw(matOrientation*disq_cyl, white) ;
draw(matOrientation*disq_cyl1, white) ;

draw(shift(centre)*cylSolid.silhouette(), c1) ;
draw(matOrientation*inter, c1) ;
draw(matOrientation*bout, c1) ;
}

else {
triple center = centre ;
if (dot(currentprojection.camera, axis) == 1) {
    write('ortho') ;

}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    if (dot(tige, currentprojection.camera) >0) {
        tige = unit(cross(axis, tige)) ;
    }
    path3 demirot = arc(center, center+(R+ep)*tige, center-(R+ep)*tige, currentprojection.camera) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    fill(project(demirot -- cycle), white) ;
    draw(project(demirot), c2) ;
    filldraw(project(rotule), white, c1) ;
    draw(project(shift(center)*(R*tige -- (R+2*ep)*tige)), c1) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
    write('but why not !') ;
        if (dot(tige, currentprojection.camera) >0) {
        tige = unit(cross(axis, tige)) ;
    }
    path3 demirot = arc(center, center+(R+ep)*tige, center-(R+ep)*tige, currentprojection.camera) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    fill(project(demirot -- cycle), white) ;
    draw(project(demirot), c2) ;
    filldraw(project(rotule), white, c1) ;
    draw(project(shift(center)*(R*tige -- (R+2*ep)*tige)), c1) ;
}
}
write('... end rotule à doigt center ' + (string)centre +'.\n') ;
}

/* ------------------------------------ */


/* ------------------------------------ */ 
/* 3 dof - rotations -- "Rotule" */

void liaisonRotule(triple center, triple axis, pen c1, pen c2) {
write('Begin rotule center ' + (string)center +' ...') ;
real R = 0.25 ;
real ep = 0.15*R ;

triple axisPerp = vecteurLocalOrth(center, axis) ;
triple axisPerp2 = unit(cross(axis, axisPerp)) ;

if (!isPlane(currentprojection.camera)) {

real xli(real t) {return axisPerp2.x*(0) + axisPerp.x*(-sqrt(R^2-t^2)) + axis.x*(-t) ;}
real yli(real t) {return axisPerp2.y*(0) + axisPerp.y*(-sqrt(R^2-t^2)) + axis.y*(-t) ;}
real zli(real t) {return axisPerp2.z*(0) + axisPerp.z*(-sqrt(R^2-t^2)) + axis.z*(-t) ;}

real xle(real t) {return axisPerp2.x*(0) + axisPerp.x*(-sqrt((R+ep)^2-t^2)) + axis.x*(-t) ;}
real yle(real t) {return axisPerp2.y*(0) + axisPerp.y*(-sqrt((R+ep)^2-t^2)) + axis.y*(-t) ;}
real zle(real t) {return axisPerp2.z*(0) + axisPerp.z*(-sqrt((R+ep)^2-t^2)) + axis.z*(-t) ;}

path3 cInt = graph(xli,yli,zli,0,R,20,operator..) ;
path3 cExt = graph(xle,yle,zle,0,(R+ep),20,operator..) ;

revolution rInt = revolution(cInt, axis) ;
revolution rExt = revolution(cExt, axis) ;

draw(shift(center)*rInt.silhouette(128), c2) ;
draw(shift(center)*rExt.silhouette(128), c2) ;


surface creuxExtSurf = shift(center)*align(unit(axis))*scale3(-(R+ep)*1)*unithemisphere ;
//surface creuxIntSurf = shift(centre)*align(unit(axis))*scale3(-R)*unithemisphere ;
surface creuxDisque = shift(center)*align(unit(axis))*scale(R+ep,R+ep,0)*unitdisk ;
surface bouleSurf = shift(center)*align(unit(axis))*scale3(R)*unitsphere ;

// draw :
draw (creuxExtSurf, white) ;
draw (bouleSurf, white) ;
draw (creuxDisque, white) ;

revolution bouleRev = sphere(O, R) ;
draw (shift(center)*bouleRev.silhouette(128), c1) ;

}
else {
if (abs(dot(currentprojection.camera, axis)) == 1) {
    write('ortho') ;

}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    axisPerp = unit(cross(currentprojection.camera, axis)) ;
    path3 demirot = arc(center, center+(R+ep)*axisPerp, center-(R+ep)*axisPerp, currentprojection.camera) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    fill(project(demirot -- cycle), white) ;
    draw(project(demirot), c2) ;
     filldraw(project(rotule), white, c1) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
    write('but why not !') ;
        axisPerp = unit(cross(currentprojection.camera, axis)) ;
    path3 demirot = arc(center, center+(R+ep)*axisPerp, center-(R+ep)*axisPerp, currentprojection.camera) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    fill(project(demirot -- cycle), white) ;
    draw(project(demirot), c2) ;
     filldraw(project(rotule), white, c1) ;
}
}
write('... end rotule center' + (string)center + '.\n') ;
}

/* ------------------------------------ */



/* ------------------------------------ */ 
/* 3 dof - 1 rotation / 2 translations -- "Appui-plan" */

void liaisonAppuiPlan(triple center, triple normal, triple orientation, pen c1, pen c2) {
write('Begin appui plan center ' + (string)center + ' normal ' + (string)normal + ' ...') ;

real L = 1 ;
real dec = 0.15 ;
triple vv = unit(cross(normal,orientation)) ;

triple P11 = L/2*orientation + L/2*vv ;
triple P12 = P11 - L*vv ;
triple P13 = P12 - L*orientation ;
triple P14 = P13 + L*vv ;
path3 pathPlan = P11 -- P12 -- P13 -- P14 -- cycle ;

if (!isPlane(currentprojection.camera)) {

draw(shift(center)*shift(-dec/2*normal)*pathPlan, c2) ;
surface surfPlan = surface(pathPlan) ;
draw(shift(center)*shift(-dec/2*normal)*surfPlan, white) ;

draw(shift(center)*shift(dec/2*normal)*pathPlan, c1) ;
draw(shift(center)*shift(dec/2*normal)*surfPlan, white) ;
}
else {
if (dot(currentprojection.camera, normal) == 1) {
    write('ortho') ;
    filldraw(project(shift(center)*shift(dec/2*orientation)*shift(dec/2*vv)*pathPlan), white, c2) ;
    filldraw(project(shift(center)*shift(currentprojection.camera)*pathPlan), white, c1) ;

}
else if (dot(currentprojection.camera, normal) == 0) {
    write('in the plane') ;
    triple dirLocal ;
    if (dot(currentprojection.camera, orientation) == 0) {
        dirLocal = orientation ;
    }
    else {dirLocal = vv ;}
    P11 = dec/2*normal + L/2*dirLocal ;
    P12 = dec/2*normal - L/2*dirLocal ;
    P13 = -dec/2*normal + L/2*dirLocal ;
    P14 = -dec/2*normal - L/2*dirLocal ;
    fill(project(shift(center)*(P11 -- P12 -- P14 -- P13 -- cycle)), white) ;
    draw(project(shift(center)*(P11 -- P12)), c1) ;
    draw(project(shift(center)*(P13 -- P14)), c2) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end appui plan ' + (string)center + ' normal ' + (string)normal +'.\n') ;
}


/* ------------------------------------ */



/* ------------------------------------ */ 
/* 4 dof - 3 rotations / 1 translation -- "Linéaire annulaire" */


void liaisonLineaireAnnulaire(triple center, triple direction, triple cdc, pen c1, pen c2) {
// cdc cote demi cylindre
write('Begin linéaire annulaire centre ' + (string)center + ' axis ' + (string) direction + ' ...') ;
real R = 0.25 ;
real L = 1. ;
real ep = 0.15*R ;

if (!isPlane(currentprojection.camera)) {
triple Zlocal = unit(cross(cdc, direction)) ;

triple P1 =  -(R+ep)*Zlocal - L/2*direction ;
triple P2 =  -(R)*Zlocal - L/2*direction ;
triple P3 =  (R)*Zlocal - L/2*direction ;
triple P4 =  (R+ep)*Zlocal - L/2*direction ;

path3 hemiCircleInt = shift(- L/2*direction)*(arc(O, R*Zlocal, -R*Zlocal, normal=direction)) ;
path3 hemiCircleExt = shift(- L/2*direction)*(arc(O, (R+ep)*Zlocal, -(R+ep)*Zlocal, normal=direction)) ;

surface hemiCylinderInt = extrude(hemiCircleInt, L*direction) ;
surface hemiCylinderExt = extrude(hemiCircleExt, L*direction) ;
draw(shift(center)*hemiCylinderInt, white) ;
draw(shift(center)*hemiCylinderExt, white) ;

path3 pathC1 = P1 -- P2 -- reverse(hemiCircleInt)  -- P3 -- P4 -- hemiCircleExt -- P1 -- cycle ;
path3 pathC2 = shift(L*direction)*pathC1 ;
//write(pathC1) ;
draw(shift(center)*pathC1, c1) ;
draw(shift(center)*pathC2, c1) ;
surface bouchon1 = surface(pathC1) ;
surface bouchon2 = surface(pathC2) ;
draw(shift(center)*bouchon1, white) ;
draw(shift(center)*bouchon2, white) ;


path3 pathD1 = P1 -- P1+L*direction -- P2+L*direction -- P2 -- cycle ;
path3 pathD2 = P3 -- P3+L*direction -- P4+L*direction -- P4 -- cycle ;
draw(shift(center)*pathD1, c1) ;
draw(shift(center)*pathD2, c1) ;
surface surfD1 = surface(pathD1) ;
surface surfD2 = surface(pathD2) ;
draw(shift(center)*surfD1, white) ;
draw(shift(center)*surfD2, white) ;


revolution rExt = revolution(O, P1 -- P1+L*direction, direction, angle1 = 180, angle2 = 360) ;
draw (shift(center)*rExt.silhouette(),c1) ;

surface bouleSurf = shift(center)*align(unit(direction))*scale3(R)*unitsphere ;
draw (bouleSurf, white) ;
revolution bouleRev = sphere(O, R) ;
draw (shift(center)*bouleRev.silhouette(),c2) ;

}
else {
if (dot(currentprojection.camera, direction) == 1) {
    write('ortho') ;
    triple axisPerp = unit(cross(currentprojection.camera, -cdc)) ;
    path3 demirot = arc(center, center+(R+ep)*axisPerp, center-(R+ep)*axisPerp, currentprojection.camera) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    fill(project(demirot -- cycle), white) ;
    draw(project(demirot), c1) ;
    filldraw(project(rotule), white, c2) ;
    path3 plat = center+(R+ep)*cdc + (R+ep)*axisPerp -- center+(R+ep)*cdc - (R+ep)*axisPerp ;
    draw(project(plat), c1) ;
}
else if (dot(currentprojection.camera, direction) == 0) {
    write('in the plane') ;
    if (abs(dot(currentprojection.camera, cdc)) == 1) {
        cdc = -unit(cross(currentprojection.camera, direction)) ;
    }
    path3 rectangle = L/2*direction -- L/2*direction + (R+ep)*cdc -- -L/2*direction + (R+ep)*cdc 
    -- -L/2*direction -- cycle ;
    filldraw(project(shift(center)*rectangle), white, c1) ;
    path3 rotule = circle(center, R, currentprojection.camera) ;
    filldraw(project(rotule), white, c2) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end linéaire annulaire centre ' + (string)center + ' axis ' + (string) direction + '.\n') ;
}


/* ------------------------------------ */






/* ------------------------------------ */ 
/* 4 dof - 2 rotations / 2 translations -- "Linéaire rectiligne" */

void liaisonLineaireRectiligne(triple centre, triple normale, triple droiteContact, pen c1, pen c2) {
write('Begin lineaire rectiligne centre ' + (string)centre + ' normal ' + (string)normale + ' ddc ' + (string)droiteContact + ' ...') ;

triple vv = unit(cross(normale, droiteContact)) ;
real e = 0.35 ;
real Lt = 0.75 ;
real Lp = 1 ;
triple PC = centre-Lt/2*droiteContact+0.01*normale ;
triple P1 = PC + cos(pi/3)*e*vv + sin(pi/3)*e*normale ;
triple P2 = PC - cos(pi/3)*e*vv + sin(pi/3)*e*normale ;
path3 triangle = PC -- P1  -- P2 -- cycle ;

triple P11 = centre + Lp/2*droiteContact + Lp/2*vv ;
triple P12 = P11 - Lp*vv ;
triple P13 = P12 - Lp*droiteContact ;
triple P14 = P13 + Lp*vv ;

if (!isPlane(currentprojection.camera)) {

// surfaces

surface tri1 = surface(triangle) ;
surface tri2 = surface(shift(Lt*droiteContact)*triangle) ;
surface pyr = extrude(triangle, Lt*droiteContact) ;

draw(pyr, white) ;
draw(tri1, white) ;
draw(tri2, white) ;

// edges
path3 eC = PC -- shift(Lt*droiteContact)*PC ;
path3 eC1 = P1 -- shift(Lt*droiteContact)*P1 ;
path3 eC2 = P2 -- shift(Lt*droiteContact)*P2 ;

draw (triangle, c1) ;
draw (shift(Lt*droiteContact)*triangle, c1) ;
draw (eC, c1) ;
draw (eC1, c1) ;
draw (eC2, c1) ;



path3 plan = P11 -- P12 -- P13 -- P14 -- cycle ;
surface planSurf = surface(plan) ;
draw (plan, c2) ;
draw (planSurf, white) ;
}
else {
if (dot(currentprojection.camera, normale) == 1) {
    write('ortho') ;
    path3 plan = P11 -- P12 -- P13 -- P14 -- cycle ;
    filldraw(project(plan), white, c2) ;
    path3 rect = P1 -- P2 -- shift(Lt*droiteContact)*P2 -- shift(Lt*droiteContact)*P1 -- cycle ;
    filldraw(project(rect), white, c1) ; 

}
else if (dot(currentprojection.camera, normale) == 0) {
    write('in the plane') ;
    if (abs(dot(currentprojection.camera, droiteContact)) == 1) {
        filldraw(project(triangle), white, c1) ;
        draw(project(P11 -- P13), c2) ;

    }
    else {
        real coeffInc = 0.1 ; // 10 en moins % 
        triple Q11 = centre + sin(pi/3)*e*normale + Lt/2*droiteContact ;
        triple Q12 = Q11 - Lt*droiteContact ;
        triple Q13 = centre - (1-coeffInc)*Lt/2*droiteContact + 0.01*normale ;
        triple Q14 = centre + (1-coeffInc)*Lt/2*droiteContact + 0.01*normale ;
        path3 trap = Q11 -- Q12 -- Q13 -- Q14 -- cycle ;
        filldraw(project(trap), white, c1) ;
        draw(project(P13 -- P12), c2) ;

    }
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end lineaire rectiligne centre ' + (string)centre + ' normal ' + (string) normale + ' ddc ' + (string)droiteContact + '.\n') ;
}


/* ------------------------------------ */



/* ------------------------------------ */ 

/* 5 dof - 3 rotations / 2 translations -- "Ponctuelle" */

void liaisonPonctuelle(triple center, triple normal, triple orientation, pen c2, pen c1) {
write('Begin ponctuelle centre ' + (string)center + ' normal ' + (string)normal + ' ...') ;

real L = 1 ;
real R = 0.25 ;
real dec = 0.001 ;
triple vv = unit(cross(normal,orientation)) ;

triple P11 = L/2*orientation + L/2*vv ;
triple P12 = P11 - L*vv ;
triple P13 = P12 - L*orientation ;
triple P14 = P13 + L*vv ;
path3 pathPlan = P11 -- P12 -- P13 -- P14 -- cycle ;

if (!isPlane(currentprojection.camera)) {

draw(shift(center)*pathPlan, c1) ;
surface surfPlan = surface(pathPlan) ;
draw(shift(center)*surfPlan, white) ;


surface bouleSurf = scale3(R)*unitsphere ;
draw (shift(center)*shift((R+dec)*normal)*bouleSurf, white) ;
revolution bouleRev = sphere(O, R) ;
draw (shift(center)*shift((R+dec)*normal)*bouleRev.silhouette(64), c2) ;
}
else {
if (abs(dot(currentprojection.camera, normal)) == 1) {
    write('ortho') ;
    path3 pBoul = align(unit(currentprojection.camera))*scale3((R+dec)*1)*unitcircle3 ;
    filldraw(project(shift(center)*pathPlan), white, c1) ;
    filldraw (project(shift(center)*shift((R+dec)*normal)*pBoul), white, c2) ;

}
else if (dot(currentprojection.camera, normal) == 0) {
    write('in the plane') ;
    path3 pBoul = align(unit(currentprojection.camera))*scale3((R+dec)*1)*unitcircle3 ;
    
    filldraw (project(shift(center)*shift((R+dec)*normal)*pBoul), white, c2) ;
    if (dot(P12-P11, currentprojection.camera)==0) {
    draw(project(shift(center)*(P11 -- P12)), c1) ;}
    else {draw(project(shift(center)*(P13 -- P12)), c1) ;}
    
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end ponctuelle centre ' + (string)center + ' normal ' + (string)normal + '.\n') ;

}



/* ------------------------------------ */ 


/* ------------------------------------ */ 
/* Transmission de puissance : engranges */
// une seule commande pour parallèles et coniques

void transEngrenages(triple c1, triple n1, real r1, pen CEC1, triple c2, triple n2, pen CEC2, real offset = 1.0) {
write('Begin engrenages at ' + (string)c1 + ' and ' + (string)c2 + ' ...') ;
real ep = 0.15 ;
real lw = linewidth(defaultpen)*1/72*2.54 ;

// calcul de r2 :
real dist = length(cross(c2-c1,n2))/length(n2) ;
real r2 = dist-r1 ;


if (!isPlane(currentprojection.camera)) {
// cas axes parallèles :
if (abs(dot(n1,n2))==1) {
	if (r2 > 0) {
		revolution cylSolid1 = cylinder(-ep/2*unit(n1), r1, ep, n1) ;
		surface cylinder1 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,ep)*unitcylinder;
		surface disq_cyl11 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,0)*unitdisk;
		surface disq_cyl12 = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*scale(r1,r1,0)*unitdisk;

		draw(cylinder1, white) ;
		draw(disq_cyl11, white) ;
		draw(disq_cyl12, white) ;

		path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
		draw(shift(-ep/2*unit(n1))*circle1, CEC1) ;
		draw(shift(+ep/2*unit(n1))*circle1, CEC1) ;
		draw(shift(c1)*cylSolid1.silhouette(), CEC1) ;


		revolution cylSolid2 = cylinder(-ep/2*unit(n2), r2, ep, n2) ;
		surface cylinder2 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,ep)*unitcylinder;
		surface disq_cyl21 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,0)*unitdisk;
		surface disq_cyl22 = shift(c2)*align(unit(n2))*shift((0,0,ep/2))*scale(r2,r2,0)*unitdisk;

		draw(cylinder2, white) ;
		draw(disq_cyl21, white) ;
		draw(disq_cyl22, white) ;

		path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
		draw(shift(-ep/2*unit(n2))*circle2, CEC2) ;
		draw(shift(+ep/2*unit(n2))*circle2, CEC2) ;
		draw(shift(c2)*cylSolid2.silhouette(), CEC2) ;
	}
	
	else {
		r2 = abs(r2) ;
			revolution cylSolid2 = cylinder(-ep/2*unit(n2), r2, ep, n2) ;
			surface cylinder2 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,ep)*unitcylinder;
			surface disq_cyl21 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,0)*unitdisk;
			surface disq_cyl22 = shift(c2)*align(unit(n2))*shift((0,0,ep/2))*scale(r2,r2,0)*unitdisk;

			draw(cylinder2, white) ;
			draw(disq_cyl21, white) ;
			draw(disq_cyl22, white) ;

			path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
			draw(shift(-ep/2*unit(n2))*circle2, CEC2) ;
			draw(shift(+ep/2*unit(n2))*circle2, CEC2) ;
			draw(shift(c2)*cylSolid2.silhouette(), CEC2) ;
			
			path3 topCover2_Inner = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*arc(O, O+(r1,0,0), O+(r1,0,0), normal = b0.z) ;
			path3 topCover2_Outter = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*arc(O, O+(r1+ep,0,0), O+(r1+ep,0,0), normal = b0.z) ;
			path3 closedTopCover = topCover2_Inner -- reverse(topCover2_Outter) -- cycle ;
			
			
			draw(topCover2_Inner ^^ topCover2_Outter, CEC1) ;
			draw(shift(-ep*n1)*(topCover2_Inner ^^ topCover2_Outter), CEC1) ;
			draw(surface(closedTopCover), white) ;
			draw(surface(shift(-ep*n1)*closedTopCover), white) ;
			
			
			surface cylinderOutter = extrude(topCover2_Outter, -ep*n1) ;
			surface cylinderInner = extrude(topCover2_Inner, -ep*n1) ;
			draw(cylinderOutter, white) ;
			draw(cylinderInner, white) ;
			
			revolution rExt = revolution(c1, shift(c1)*align(unit(n1))*(O+(r1+ep,0,-ep/2) -- O+(r1+ep,0,ep/2)), n1, angle1 = 0, angle2 = 360) ;
			draw (rExt.silhouette(128), CEC1) ;
}
}
else {
if (sgn(dot(n1,n2))<0) {
    write('Attention : il faut un delta 1 + delta 2 < 90°') ;
}

// intersection
triple tempA = cross(c1,n1) ;
triple tempB = cross(c2,n1) ;
triple tempC = cross(n2,n1) ;
real tp = 0 ;
if (abs(tempC.z) != 0) {
tp = (tempA.z - tempB.z)/tempC.z ;
}
else if (abs(tempC.x) != 0) {
tp = (tempA.x - tempB.x)/tempC.x ;
}
else {
tp = (tempA.y - tempB.y)/tempC.y ;
}
triple I = c2 + tp*n2 ;

real d1 = length(I-c1) ;
real delta1 = atan(r1/d1) ;
real sindelta1delta2 = length(cross(unit(n1), unit(n2))) ;
real delta2 = asin(sindelta1delta2) - delta1 ;


triple zlocal = unit(cross(n1, n2)) ;
triple er1 = unit(cross(n1, zlocal)) ;
triple P1 = c1 + r1*er1 ;

triple ugen1 = unit(P1-I) ;
// idem pour verif
real dd = length(P1-I) ;
dd = sqrt(d1^2+r1^2) ;
real r2compute = sin(delta2)*dd ;

real d2 =  r2compute/tan(delta2) ;

triple c2p = I - d2*n2 ;
triple er2 = unit(cross(n2, zlocal)) ;
triple P2 = c2p + r2compute*er2 ;
triple ugen2 = unit(P2-I) ;



real deltaR1 = sin(delta1) * ep/2 ;
real decR1 =  cos(delta1) * ep/2 ;

revolution coneSolid1 = revolution(O, O + r1*er1 -ep/2*ugen1 -- O + r1*er1 + ep/2*ugen1, n1) ;
path3 circle11 = shift(c1)*shift(decR1*unit(n1))*align(unit(n1))*scale(r1-deltaR1,r1-deltaR1,0)*unitcircle3 ;
path3 circle12 = shift(c1)*shift(-decR1*unit(n1))*align(unit(n1))*scale(r1+deltaR1,r1+deltaR1,0)*unitcircle3 ;

surface cone1 = extrude(circle11, circle12) ;
surface disq_cone11 = surface(circle11) ;
surface disq_cone12 = surface(circle12) ;

draw(cone1, white) ;
draw(disq_cone11, white) ;
draw(disq_cone12, white) ;
draw(shift(c1)*coneSolid1.silhouette(256), CEC1) ;
// pb avec silhouette par moment
draw(circle11, CEC1) ;
draw(circle12, CEC1) ;

real deltaR2 = sin(delta2) * ep/2 ;
real decR2 =  cos(delta2) * ep/2 ;

revolution coneSolid2 = revolution(O, O + r2compute*er2 -ep/2*ugen2 -- O + r2compute*er2 + ep/2*ugen2, n2) ;
path3 circle21 = shift(c2p)*shift(decR2*unit(n2))*align(unit(n2))*scale(r2compute-deltaR2,r2compute-deltaR2,0)*unitcircle3 ;
path3 circle22 = shift(c2p)*shift(-decR2*unit(n2))*align(unit(n2))*scale(r2compute+deltaR2,r2compute+deltaR2,0)*unitcircle3 ;

surface cone2 = extrude(circle21, circle22) ;
surface disq_cone21 = surface(circle21) ;
surface disq_cone22 = surface(circle22) ;

draw(cone2, white) ;
draw(disq_cone21, white) ;
draw(disq_cone22,white) ;
draw(shift(c2p)*coneSolid2.silhouette(256), CEC2) ;
// pb avec silhouette par moment
draw(circle21, CEC2) ;
draw(circle22, CEC2) ;


draw(c2 -- c2p, CEC2) ;

}
}
else {
if (abs(dot(currentprojection.camera, n1)) == 1) {
    if (abs(dot(currentprojection.camera, n2)) != 1) {
        write('not in the plane neither ortho  ! ') ;
    }
    else {
    write('ortho') ;
	if (r2 > 0) {
		path3 circle1 = shift(c1)*align(unit(n1))*scale(r1-lw/2,r1-lw/2,0)*unitcircle3 ;
		path3 circle2 = shift(c2)*align(unit(n2))*scale(r2-lw/2,r2-lw/2,0)*unitcircle3 ;
		draw(project(circle1), CEC1) ;
		draw(project(circle2), CEC2) ;
	}
	else {
		r2 = abs(r2) ;
		path3 circle1 = shift(c1)*align(unit(n1))*scale(r1+lw/2,r1+lw/2,0)*unitcircle3 ;
		path3 circle2 = shift(c2)*align(unit(n2))*scale(r2-lw/2,r2-lw/2,0)*unitcircle3 ;
		draw(project(circle1), CEC1) ;
		draw(project(circle2), CEC2) ;
		
	}
    }

}
else if (dot(currentprojection.camera, n1) == 0) {
    write('in the plane') ;
    real l1 = 2*(r1-lw/2) ;
    real l2 = 2*(r2-lw/2) ;


    // cas axes parallèles :
    if (abs(dot(n1,n2))==1) {
    triple vv1 = unit(cross(currentprojection.camera, n1)) ;
    triple vv2 = unit(cross(currentprojection.camera, n2)) ;

	if (r2 > 0 )
	{
	path3 b1 = shift(-l1/2*vv1)*c1 -- shift(l1/2*vv1)*c1 ;
    path3 b2 = shift(-l2/2*vv2)*c2 -- shift(l2/2*vv2)*c2 ;
    path3 b3 = shift(-ep/2*n1)*c1 -- shift(ep/2*n1)*c1 ;
    path3 b4 = shift(-ep/2*n2)*c2 -- shift(ep/2*n2)*c2 ;
    draw(project(b1), CEC1) ;
    draw(project(b2), CEC2) ;
    draw(project(shift(-l1/2*vv1)*b3), CEC1) ;
    draw(project(shift(l1/2*vv1)*b3), CEC1) ;
    draw(project(shift(-l2/2*vv2)*b4), CEC2) ;
    draw(project(shift(+l2/2*vv2)*b4), CEC2) ;
	}
	else {
		r2 = abs(r2) ;
		real l3 = 2*(r1+lw/2) ;
		real l4 = 2*(r2-lw/2) ;
		
		path3 b1 = shift(-l4/2*vv2)*c2 -- shift(l4/2*vv2)*c2 ;
		path3 b2 = shift(-ep/2*n2)*c2 -- shift(ep/2*n2)*c2 ;
		
		draw(project(b1), CEC2) ;
		draw(project(shift(-l4/2*vv2)*b2), CEC2) ;
		draw(project(shift(+l4/2*vv2)*b2), CEC2) ;
		
		
		path3 b3 = shift(-ep/2*n1)*c1 -- shift(ep/2*n1)*c1 ;
		path3 b4 = shift(-l3/2*vv1)*c1 -- shift(-(l3/2+ep)*vv1)*c1 ;
		path3 b5 = shift(-(l3/2+ep)*vv1)*c1 -- shift(offset*n1)*shift(-(l3/2+ep)*vv1)*c1 -- shift(offset*n1)*shift((l3/2+ep)*vv1)*c1 -- shift((l3/2+ep)*vv1)*c1 ;
		

		draw(project(shift(-l3/2*vv1)*b3), CEC1) ;
		draw(project(shift(l3/2*vv1)*b3), CEC1) ;
		draw(project(b4), CEC1) ;
		draw(project(shift((l3+ep)*vv1)*b4), CEC1) ;
		draw(project(b5), CEC1) ;
	
	}
    }
	
    else {
    if (sgn(dot(n1,n2))<0) {
        write('Attention : il faut un delta 1 + delta 2 < 90°') ;
    }
    // intersection
triple tempA = cross(c1,n1) ;
triple tempB = cross(c2,n1) ;
triple tempC = cross(n2,n1) ;
real tp = 0 ;
if (abs(tempC.z) != 0) {
tp = (tempA.z - tempB.z)/tempC.z ;
}
else if (abs(tempC.x) != 0) {
tp = (tempA.x - tempB.x)/tempC.x ;
}
else {
tp = (tempA.y - tempB.y)/tempC.y ;
}
triple I = c2 + tp*n2 ;

real d1 = length(I-c1) ;
real delta1 = atan(r1/d1) ;
real sindelta1delta2 = length(cross(unit(n1), unit(n2))) ;
real delta2 = asin(sindelta1delta2) - delta1 ;


triple zlocal = unit(cross(n1, n2)) ;
triple er1 = unit(cross(n1, zlocal)) ;
triple P1 = c1 + r1*er1 ;
triple P11 = c1 - r1*er1 ;

triple ugen1 = unit(P1-I) ;
triple ugen11 = unit(P11-I) ;
// idem pour verif
real dd = length(P1-I) ;
dd = sqrt(d1^2+r1^2) ;
real r2compute = sin(delta2)*dd ;

l2 = 2*(r2compute-lw/2) ;

real d2 =  r2compute/tan(delta2) ;

triple c2p = I - d2*n2 ;
triple er2 = unit(cross(n2, zlocal)) ;
triple P2 = c2p + r2compute*er2 ;
triple ugen2 = unit(P2-I) ;
triple P21 = c2p - r2compute*er2 ;
triple ugen21 = unit(P21-I) ;



real deltaR1 = sin(delta1) * ep/2 ;
real decR1 =  cos(delta1) * ep/2 ;
real deltaR2 = sin(delta2) * ep/2 ;
real decR2 =  cos(delta2) * ep/2 ;


path3 b1 = shift(c1)* (-l1/2*er1 -- l1/2*er1) ;
path3 b2 = shift(c2p)* (-l2/2*er2 -- l2/2*er2) ;
draw(project(b1), CEC1) ;
draw(project(b2), CEC2) ;
path3 b3 = shift(c1)* (l1/2*er1 -ep/2*ugen1 -- l1/2*er1 + ep/2*ugen1);
path3 b4 = shift(c1)* (-l1/2*er1 -ep/2*ugen11 -- -l1/2*er1 + ep/2*ugen11);
draw(project(b3), CEC1) ;
draw(project(b4), CEC1) ;
path3 b5 = shift(c2p)* (l2/2*er2 -ep/2*ugen2 -- l2/2*er2 + ep/2*ugen2);
path3 b6 = shift(c2p)* (-l2/2*er2 -ep/2*ugen21 -- -l2/2*er2 + ep/2*ugen21);
draw(project(b5), CEC2) ;
draw(project(b6), CEC2) ;

draw(project(c2 -- c2p), CEC2) ;

    }    
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('.. end engrenages at ' + (string)c1 + ' and ' + (string)c2 + '.\n') ;
}

/* ------------------------------------ */






/* ------------------------------------ */
/* Transmission de puissance : poulie courroie */

void transPoulieCourroie(triple c1, triple n1, real r1, pen CEC1, triple c2, triple n2, real r2, pen CEC2) {
write('Begin poulie courroie at ' + (string)c1 + ' and ' + (string)c2 + ' ...') ;

real ep = 0.15 ;

if (!isPlane(currentprojection.camera)) {
// cas axes parallèles :
if (abs(dot(n1,n2))==1) {
revolution cylSolid1 = cylinder(-ep/2*unit(n1), r1, ep, n1) ;
surface cylinder1 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,ep)*unitcylinder;
surface disq_cyl11 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,0)*unitdisk;
surface disq_cyl12 = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*scale(r1,r1,0)*unitdisk;

draw(cylinder1, white) ;
draw(disq_cyl11, white) ;
draw(disq_cyl12, white) ;

path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
draw(shift(-ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(+ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(c1)*cylSolid1.silhouette(), CEC1) ;



revolution cylSolid2 = cylinder(-ep/2*unit(n2), r2, ep, n2) ;
surface cylinder2 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,ep)*unitcylinder;
surface disq_cyl21 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,0)*unitdisk;
surface disq_cyl22 = shift(c2)*align(unit(n2))*shift((0,0,ep/2))*scale(r2,r2,0)*unitdisk;

draw(cylinder2, white) ;
draw(disq_cyl21, white) ;
draw(disq_cyl22, white) ;

path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
draw(shift(-ep/2*unit(n2))*circle2, CEC2) ;
draw(shift(+ep/2*unit(n2))*circle2, CEC2) ;
draw(shift(c2)*cylSolid2.silhouette(), CEC2) ;


// courroie
triple xlocal = unit(c2-c1) ;
real entraxe = length(cross(c2-c1,n2))/length(n2) ;
real beta = asin((r2-r1)/entraxe) ;

real theta1 = pi-2*beta ;
real theta2 = pi+2*beta ;
triple ylocal = unit(cross(xlocal,n1)) ;

real angleContact1 = pi/2 + beta ;
triple pc11 = c1 + r1*cos(angleContact1)*xlocal + r1*sin(angleContact1)*ylocal ;
triple pc21 = c2 + r2*cos(angleContact1)*xlocal + r2*sin(angleContact1)*ylocal ;

real angleContact2 = - pi/2 - beta ;
triple pc12 = c1 + r1*cos(angleContact2)*xlocal + r1*sin(angleContact2)*ylocal ;
triple pc22 = c2 + r2*cos(angleContact2)*xlocal + r2*sin(angleContact2)*ylocal ;

path3 courroie1 = pc11 +ep/2*n1 -- pc11  - ep/2*n1 -- pc21 -ep/2*n1 -- pc21 + ep/2*n1 --cycle ;
draw(surface(courroie1), lightgray) ;
path3 courroie2 = pc12 +ep/2*n1 -- pc12  - ep/2*n1 -- pc22 -ep/2*n1 -- pc22 + ep/2*n1 --cycle ;
draw(surface(courroie2), lightgray) ;



//path3 arc1 = (0,0,0) -- arc((1,0,0), (0,0,0),(1,0,-1)) -- (1, 1, -1) -- cycle;
real surEp = 1.005 ;

bool sensCourroie1 ;
bool sensCourroie2 ;
if (r2>r1) {sensCourroie1 = true ; sensCourroie2 = false;} 
else {sensCourroie1 = false ; sensCourroie2 = true;} 

path3 a1 = arc(c1, pc11, pc12, direction=sensCourroie1) ;
transform3 orTransf1 = transform3(xlocal, ylocal, n1) ;
surface arc1 =  scale(xlocal, surEp)*scale(ylocal, surEp)*extrude(shift(-ep/2*n1)*a1, shift(ep/2*n1)*a1) ;
draw(surface(arc1), lightgray) ;

path3 a2 = arc(c2, pc21, pc22, direction=sensCourroie2) ;
surface arc2 = scale(xlocal, surEp)*scale(ylocal, surEp) * extrude(shift(-ep/2*n2)*a2, shift(ep/2*n2)*a2) ;
draw(surface(arc2), lightgray) ;

draw(shift(ep/2*n1)*(pc11 -- pc21), black+0.25) ;
draw(shift(ep/2*n1)*(pc12 -- pc22), black+0.25) ;
draw(shift(-ep/2*n1)*(pc11 -- pc21), black+0.25) ;
draw(shift(-ep/2*n1)*(pc12 -- pc22), black+0.25) ;
}
}
else {
if (abs(dot(currentprojection.camera, n1)) == 1) {
    write('ortho') ;
    path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
    path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
    draw(project(circle1), CEC1) ;
    draw(project(circle2), CEC2) ;

    // courroie
triple xlocal = unit(c2-c1) ;
real entraxe = length(cross(c2-c1,n2))/length(n2) ;

real beta = asin((r2-r1)/entraxe) ;
real theta1 = pi-2*beta ;
real theta2 = pi+2*beta ;
triple ylocal = unit(cross(xlocal,n1)) ;

real angleContact1 = pi/2 + beta ;
triple pc11 = c1 + r1*cos(angleContact1)*xlocal + r1*sin(angleContact1)*ylocal ;
triple pc21 = c2 + r2*cos(angleContact1)*xlocal + r2*sin(angleContact1)*ylocal ;

real angleContact2 = - pi/2 - beta ;
triple pc12 = c1 + r1*cos(angleContact2)*xlocal + r1*sin(angleContact2)*ylocal ;
triple pc22 = c2 + r2*cos(angleContact2)*xlocal + r2*sin(angleContact2)*ylocal ;

draw(project(pc11 -- pc21), gray) ;
draw(project(pc12 -- pc22), gray) ;

bool sensCourroie1 ;
bool sensCourroie2 ;
if (r2>r1) {sensCourroie1 = true ; sensCourroie2 = false;} 
else {sensCourroie1 = false ; sensCourroie2 = true;} 

path3 a1 = arc(c1, pc11, pc12, direction=sensCourroie1) ;
path3 a2 = arc(c2, pc21, pc22, direction=sensCourroie2) ;
draw(project(a1), gray) ;
draw(project(a2), gray) ;


}
else if (dot(currentprojection.camera, n1) == 0) {
    write('in the plane') ;

    triple vv1 = unit(cross(currentprojection.camera, n1)) ;
    triple vv2 = unit(cross(currentprojection.camera, n2)) ;

    path3 b1 = shift(-r1*vv1)*c1 -- shift(r1*vv1)*c1 ;
    path3 b2 = shift(-r2*vv2)*c2 -- shift(r2*vv2)*c2 ;
    path3 b3 = shift(-ep/2*n1)*c1 -- shift(ep/2*n1)*c1 ;
    path3 b4 = shift(-ep/2*n2)*c2 -- shift(ep/2*n2)*c2 ;

    fill(project(b1 -- reverse(b2) -- cycle), white) ;
    draw(project(shift(-ep/2*n1)*b1), CEC1) ;
    draw(project(shift(-ep/2*n2)*b2), CEC2) ;

    draw(project(shift(-r1*vv1)*b3), CEC1) ;
    draw(project(shift(r1*vv1)*b3), CEC1) ;
    draw(project(shift(-r2*vv2)*b4), CEC2) ;
    draw(project(shift(+r2*vv2)*b4), CEC2) ;


    draw(project(shift(r1*vv1)*c1 -- shift(-r2*vv2)*c2), gray) ;
    draw(project(shift(-r1*vv1)*c1 -- shift(r1*vv1)*c1), gray) ;
    draw(project(shift(-r2*vv2)*c2 -- shift(r2*vv2)*c2), gray) ;

    
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}

write('... end poulie courroie at ' + (string)c1 + ' and ' + (string)c2 + '.\n') ;
}



/* ------------------------------------ */



/* ------------------------------------ */
/* Transmission de puissance : roue et vis sans fin */

void transRoueVis(triple c1, triple n1, pen CEC1, triple c2, triple n2, pen CEC2) {
write('Begin roue et vis sans fin at ' + (string)c1 + ' and ' + (string)c2 + ' ...') ;

// vis
real r1 = 0.35*(2)^(1/2)/2 ;
real h1 = 1 ;
// roue
real h2 = 1/2*2*r1 ;
real r2 = length(c2-c1) - r1 ;

// epaisseur trait en cm
real lw = linewidth(defaultpen)*1/72*2.54 ;

if (!isPlane(currentprojection.camera)) {

revolution cylSolid = cylinder(-h1/2*unit(n1), r1, h1, n1) ;
surface cylinder = shift(c1)*align(unit(n1))*shift((0,0,-h1/2))*scale(r1,r1,h1)*unitcylinder ;
surface disq_cyl = shift(c1)*align(unit(n1))*shift((0,0,-h1/2))*scale(r1,r1,h1)*unitdisk ;
surface disq_cyl1 = shift(c1)*align(unit(n1))*shift((0,0,h1/2))*scale(r1,r1,0)*unitdisk ;

draw(shift(c1)*cylSolid.silhouette(128), CEC1) ;
draw(cylinder, white) ;
draw(disq_cyl, white) ;
draw(disq_cyl1, white) ;
//draw(point-h1*unit(n1)--point+h1*unit(axis), c1) ;

// In case of silhouette pb ...
path3 circle = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
draw(shift(-h1/2*unit(n1))*circle, CEC1) ;
draw(shift(+h1/2*unit(n1))*circle, CEC1) ;




real pas = 3.0 ;
triple axisPerp = vecteurLocalOrth(c1, n1) ;
triple axisPerp2 = unit(cross(n1, axisPerp)) ;

real xl(real t) {return axisPerp.x*r1*cos(pas*2*pi*t) + axisPerp2.x*r1*sin(pas*2*pi*t) + n1.x*t ;}
real yl(real t) {return axisPerp.y*r1*cos(pas*2*pi*t) + axisPerp2.y*r1*sin(pas*2*pi*t) + n1.y*t ;}
real zl(real t) {return axisPerp.z*r1*cos(pas*2*pi*t) + axisPerp2.z*r1*sin(pas*2*pi*t) + n1.z*t ;}


path3 p = graph(xl, yl, zl, -h1/2, +h1/2);
draw(shift(c1)*p, CEC1) ;


// roue

revolution cylSolid2 = cylinder(-h2/2*unit(n2), r2, h2, n2) ;
surface cylinder2 = shift(c2)*align(unit(n2))*shift((0,0,-h2/2))*scale(r2,r2,h2)*unitcylinder;
surface disq_cyl21 = shift(c2)*align(unit(n2))*shift((0,0,-h2/2))*scale(r2,r2,0)*unitdisk;
surface disq_cyl22 = shift(c2)*align(unit(n2))*shift((0,0,h2/2))*scale(r2,r2,0)*unitdisk;

draw(cylinder2, white) ;
draw(disq_cyl21, white) ;
draw(disq_cyl22, white) ;

path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
draw(shift(-h2/2*unit(n2))*circle2, CEC2) ;
draw(shift(+h2/2*unit(n2))*circle2, CEC2) ;
draw(shift(c2)*cylSolid2.silhouette(), CEC2) ;
}

else {
    triple erlocal = unit(c2-c1) ;
if (abs(dot(currentprojection.camera, n1)) == 1) {
    write('ortho vis') ;
    path3 circle = shift(c1)*align(unit(n1))*scale(r1-lw,r1-lw,0)*unitcircle3 ;
    filldraw(project(circle), white, CEC1) ;
    
    triple vv = unit(cross(n1, erlocal)) ;
    real rayonArc = r1+lw ;
    real theta = asin(h2/2 / rayonArc) ;

    draw(project(shift(c2)*(-(r2-lw)*erlocal -- (r2-lw)*erlocal)), CEC2) ;

    path3 arc1 = arc(c1, c1+rayonArc*(cos(theta)*erlocal + sin(theta)*vv), c1+rayonArc*(cos(theta)*erlocal - sin(theta)*vv)) ;
    draw(project(arc1), CEC2) ;
	triple centerOtherArc = shift(2*(c2-c1))*(c1) ;
    path3 arc2 = arc(centerOtherArc, centerOtherArc+rayonArc*(-cos(theta)*erlocal + sin(theta)*vv), centerOtherArc+rayonArc*(-cos(theta)*erlocal - sin(theta)*vv)) ;
    draw(project(arc2), CEC2) ;
}
else if (abs(dot(currentprojection.camera, n2)) == 1) {
    write('ortho roue ') ;
    path3 rect = -h1/2*n1 + r1*erlocal --  -h1/2*n1 - r1*erlocal -- h1/2*n1 - r1*erlocal -- h1/2*n1 + r1*erlocal -- cycle ;
    filldraw(project(shift(c1)*(rect)), white, CEC1) ;
    path3 circle = shift(c2)*align(unit(n2))*scale(r2-lw,r2-lw,0)*unitcircle3 ;
    filldraw(project(circle), white, CEC2) ;    
}
else if (dot(currentprojection.camera, n1) == 0 && dot(currentprojection.camera, n2) == 0) {
	write('Vue ortho ') ;
	triple vv = unit(cross(n1, erlocal)) ;
	if (dot(c1-c2,currentprojection.camera) >0){
	path3 rect2 = -h2/2*n2 + r2*n1 --  -h2/2*n2 - r2*n1 -- h2/2*n2 - r2*n1 -- h2/2*n2 + r2*n1 -- cycle ;
    filldraw(project(shift(c2)*(rect2)), white, CEC2) ;
	path3 rect = -h1/2*n1 + r1*vv --  -h1/2*n1 - r1*vv -- h1/2*n1 - r1*vv -- h1/2*n1 + r1*vv -- cycle ;
    filldraw(project(shift(c1)*(rect)), white, CEC1) ;
	}
	else {
		path3 rect2 = -h2/2*n2 + r2*n1 --  -h2/2*n2 - r2*n1 -- h2/2*n2 - r2*n1 -- h2/2*n2 + r2*n1 -- cycle ;
	path3 rect = -h1/2*n1 + r1*vv --  -h1/2*n1 - r1*vv -- h1/2*n1 - r1*vv -- h1/2*n1 + r1*vv -- cycle ;
    filldraw(project(shift(c1)*(rect)), white, CEC1) ;
	    filldraw(project(shift(c2)*(rect2)), white, CEC2) ;
	}
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end roue et vis sans fin  at ' + (string)c1 + ' and ' + (string)c2 + '.\n') ;
}



/* ------------------------------------ */



/* ------------------------------------ */
/* Transmission de puissance : pignon crémaillière */

void transPignonCremailliere(triple c1, triple n1, pen CEC1, triple c2, triple n2, real r2, pen CEC2) {
write('Begin pignon cremailliere at ' + (string)c1 + ' and ' + (string)c2 + ' ...') ;
real ep = 0.15 ;
real h2 = ep/5 ;
triple axeLocal = unit(cross(n2,n1)) ;
real lw = linewidth(defaultpen)*1/72*2.54 ;

// pignon
real r1 = 0.98*(length(c2-c1) - h2/2);

if (!isPlane(currentprojection.camera)) {
revolution cylSolid1 = cylinder(-ep/2*unit(n1), r1, ep, n1) ;
surface cylinder1 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,ep)*unitcylinder;
surface disq_cyl11 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,0)*unitdisk;
surface disq_cyl12 = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*scale(r1,r1,0)*unitdisk;

draw(cylinder1, white) ;
draw(disq_cyl11, white) ;
draw(disq_cyl12, white) ;

path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
draw(shift(-ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(+ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(c1)*cylSolid1.silhouette(), CEC1) ;


// cremailliere
triple P1 = c2 + ep/2*n1 + h2*axeLocal ;
triple P2 = c2 + ep/2*n1 - h2*axeLocal ;
triple P3 = c2 - ep/2*n1 - h2*axeLocal ;
triple P4 = c2 - ep/2*n1 + h2*axeLocal ;
path3 rectangle = P1 -- P2 -- P3 -- P4 -- cycle ;
surface parallelipipede = extrude(shift(-r2/2*n2)*rectangle, r2*n2 ) ;

draw(shift(-r2/2*n2)*rectangle, CEC2) ;
draw(shift(r2/2*n2)*rectangle, CEC2) ;

draw(parallelipipede, white) ;
draw(shift(-r2/2*n2)*surface(rectangle), white) ;
draw(shift(r2/2*n2)*surface(rectangle), white) ;

draw(shift(-r2/2*n2)*P1 -- shift(r2/2*n2)*P1, CEC2) ;
draw(shift(-r2/2*n2)*P2 -- shift(r2/2*n2)*P2, CEC2) ;
draw(shift(-r2/2*n2)*P3 -- shift(r2/2*n2)*P3, CEC2) ;
draw(shift(-r2/2*n2)*P4 -- shift(r2/2*n2)*P4, CEC2) ;
}

else {
if (abs(dot(currentprojection.camera, n1)) == 1) {
    write('ortho pignon') ;
    r1 = length(c2-c1) - lw;
    path3 circle = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
    
    triple P1 = -r2/2*n2 + h2*axeLocal ;
    triple P2 = P1 - 2*h2*axeLocal ;
    triple P3 = P2 + r2*n2 ;
    triple P4 = P3 + 2*h2*axeLocal ;
    path3 rect = P1 --  P2 -- P3 -- P4 -- cycle ;
    pen axeEng = linetype(new real[] {8,4,2,4});
    fill(project(shift(c2)*rect), white) ;
    draw(project(shift(c2)*(P1--P2--P3--P4)), CEC2) ;
    draw(project(shift(c2)*(P1--P4)), CEC2+axeEng) ;
    
    filldraw(project(circle), white, CEC1) ;




}
else if (abs(dot(currentprojection.camera, n2)) == 1) {
    write('ortho cremailliere') ;
    path3 b1 = -r1*axeLocal -- r1*axeLocal ;
    path3 b2 = -ep/2*n1 -- ep/2*n1 ;
    draw(project(shift(c1)*b1), CEC1) ;
    draw(project(shift(-r1*axeLocal)*shift(c1)*b2), CEC1) ;
    draw(project(shift(r1*axeLocal)*shift(c1)*b2), CEC1) ;
    draw(project(shift(c2)*b2), CEC2) ;    
}
else if (dot(currentprojection.camera, axeLocal) == 1) {
    write('above') ;
    path3 rect = -ep/2*n1 - r2/2*n2 -- -ep/2*n1 + r2/2*n2 -- +ep/2*n1 + r2/2*n2 -- +ep/2*n1 - r2/2*n2 -- cycle ;
    filldraw(project(shift(c2)*rect), white, CEC2) ;

    path3 b1 = -r1*n2 -- r1*n2 ;
    path3 b2 = -ep/2*n1 -- ep/2*n1 ;
    draw(project(shift(c1)*b1), CEC1) ;
    draw(project(shift(-r1*n2)*shift(c1)*b2), CEC1) ;
    draw(project(shift(r1*n2)*shift(c1)*b2), CEC1) ;    
}
else {
    write('not in the plane neither ortho or hidden ! ') ;
}
}
write('... end pignon cremailliere at ' + (string)c1 + ' and ' + (string)c2 + '.\n') ;
}




/* ------------------------------------ */
/* Transmission de puissance : chaîne */

void transChaine(triple c1, triple n1, real r1, pen CEC1, triple c2, triple n2, real r2, pen CEC2) {
write('Begin chaine at ' + (string)c1 + ' and ' + (string)c2 + ' ...') ;

real ep = 0.15 ;

if (!isPlane(currentprojection.camera)) {
// cas axes parallèles :
if (abs(dot(n1,n2))==1) {
revolution cylSolid1 = cylinder(-ep/2*unit(n1), r1, ep, n1) ;
surface cylinder1 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,ep)*unitcylinder;
surface disq_cyl11 = shift(c1)*align(unit(n1))*shift((0,0,-ep/2))*scale(r1,r1,0)*unitdisk;
surface disq_cyl12 = shift(c1)*align(unit(n1))*shift((0,0,ep/2))*scale(r1,r1,0)*unitdisk;

draw(cylinder1, white) ;
draw(disq_cyl11, white) ;
draw(disq_cyl12, white) ;

path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
draw(shift(-ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(+ep/2*unit(n1))*circle1, CEC1) ;
draw(shift(c1)*cylSolid1.silhouette(), CEC1) ;



revolution cylSolid2 = cylinder(-ep/2*unit(n2), r2, ep, n2) ;
surface cylinder2 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,ep)*unitcylinder;
surface disq_cyl21 = shift(c2)*align(unit(n2))*shift((0,0,-ep/2))*scale(r2,r2,0)*unitdisk;
surface disq_cyl22 = shift(c2)*align(unit(n2))*shift((0,0,ep/2))*scale(r2,r2,0)*unitdisk;

draw(cylinder2, white) ;
draw(disq_cyl21, white) ;
draw(disq_cyl22, white) ;

path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
draw(shift(-ep/2*unit(n2))*circle2, CEC2) ;
draw(shift(+ep/2*unit(n2))*circle2, CEC2) ;
draw(shift(c2)*cylSolid2.silhouette(), CEC2) ;


// chaine -- copie integrale courroie
triple xlocal = unit(c2-c1) ;
real entraxe = length(cross(c2-c1,n2))/length(n2) ;
real beta = asin((r2-r1)/entraxe) ;

real theta1 = pi-2*beta ;
real theta2 = pi+2*beta ;
triple ylocal = unit(cross(xlocal,n1)) ;

real angleContact1 = pi/2 + beta ;
triple pc11 = c1 + r1*cos(angleContact1)*xlocal + r1*sin(angleContact1)*ylocal ;
triple pc21 = c2 + r2*cos(angleContact1)*xlocal + r2*sin(angleContact1)*ylocal ;

real angleContact2 = - pi/2 - beta ;
triple pc12 = c1 + r1*cos(angleContact2)*xlocal + r1*sin(angleContact2)*ylocal ;
triple pc22 = c2 + r2*cos(angleContact2)*xlocal + r2*sin(angleContact2)*ylocal ;

path3 courroie1 = pc11 +ep/2*n1 -- pc11  - ep/2*n1 -- pc21 -ep/2*n1 -- pc21 + ep/2*n1 --cycle ;
draw(surface(courroie1), lightgray) ;
path3 courroie2 = pc12 +ep/2*n1 -- pc12  - ep/2*n1 -- pc22 -ep/2*n1 -- pc22 + ep/2*n1 --cycle ;
draw(surface(courroie2), lightgray) ;



//path3 arc1 = (0,0,0) -- arc((1,0,0), (0,0,0),(1,0,-1)) -- (1, 1, -1) -- cycle;
real surEp = 1.005 ;

bool sensCourroie1 ;
bool sensCourroie2 ;
if (r2>r1) {sensCourroie1 = true ; sensCourroie2 = false;} 
else {sensCourroie1 = false ; sensCourroie2 = true;} 

path3 a1 = arc(c1, pc11, pc12, direction=sensCourroie1) ;
transform3 orTransf1 = transform3(xlocal, ylocal, n1) ;
surface arc1 =  scale(xlocal, surEp)*scale(ylocal, surEp)*extrude(shift(-ep/2*n1)*a1, shift(ep/2*n1)*a1) ;
draw(surface(arc1), lightgray) ;
draw(scale(xlocal, surEp)*scale(ylocal, surEp) *a1, black+0.25+dashdotted) ;

path3 a2 = arc(c2, pc21, pc22, direction=sensCourroie2) ;
surface arc2 = scale(xlocal, surEp)*scale(ylocal, surEp) * extrude(shift(-ep/2*n2)*a2, shift(ep/2*n2)*a2) ;
draw(surface(arc2), lightgray) ;
draw(scale(xlocal, surEp)*scale(ylocal, surEp) *a2, black+0.25+dashdotted) ;

//draw(shift(ep/2*n1)*(pc11 -- pc21), black+0.25+dashdotted) ;
//draw(shift(ep/2*n1)*(pc12 -- pc22), black+0.25+dashdotted) ;
//draw(shift(-ep/2*n1)*(pc11 -- pc21), black+0.25+dashdotted) ;
//draw(shift(-ep/2*n1)*(pc12 -- pc22), black+0.25+dashdotted) ;
draw(pc11 -- pc21, black+0.25+dashdotted) ;
draw(pc12 -- pc22, black+0.25+dashdotted) ;
}
}
else {
if (abs(dot(currentprojection.camera, n1)) == 1) {
    write('ortho') ;
    path3 circle1 = shift(c1)*align(unit(n1))*scale(r1,r1,0)*unitcircle3 ;
    path3 circle2 = shift(c2)*align(unit(n2))*scale(r2,r2,0)*unitcircle3 ;
    draw(project(circle1), CEC1) ;
    draw(project(circle2), CEC2) ;

    // courroie
triple xlocal = unit(c2-c1) ;
real entraxe = length(cross(c2-c1,n2))/length(n2) ;

real beta = asin((r2-r1)/entraxe) ;
real theta1 = pi-2*beta ;
real theta2 = pi+2*beta ;
triple ylocal = unit(cross(xlocal,n1)) ;

real angleContact1 = pi/2 + beta ;
triple pc11 = c1 + r1*cos(angleContact1)*xlocal + r1*sin(angleContact1)*ylocal ;
triple pc21 = c2 + r2*cos(angleContact1)*xlocal + r2*sin(angleContact1)*ylocal ;

real angleContact2 = - pi/2 - beta ;
triple pc12 = c1 + r1*cos(angleContact2)*xlocal + r1*sin(angleContact2)*ylocal ;
triple pc22 = c2 + r2*cos(angleContact2)*xlocal + r2*sin(angleContact2)*ylocal ;

draw(project(pc11 -- pc21), gray+dashdotted) ;
draw(project(pc12 -- pc22), gray+dashdotted) ;

bool sensCourroie1 ;
bool sensCourroie2 ;
if (r2>r1) {sensCourroie1 = true ; sensCourroie2 = false;} 
else {sensCourroie1 = false ; sensCourroie2 = true;} 

path3 a1 = arc(c1, pc11, pc12, direction=sensCourroie1) ;
path3 a2 = arc(c2, pc21, pc22, direction=sensCourroie2) ;
draw(project(a1), gray+dashdotted) ;
draw(project(a2), gray+dashdotted) ;


}
else if (dot(currentprojection.camera, n1) == 0) {
    write('in the plane') ;

    triple vv1 = unit(cross(currentprojection.camera, n1)) ;
    triple vv2 = unit(cross(currentprojection.camera, n2)) ;

    path3 b1 = shift(-r1*vv1)*c1 -- shift(r1*vv1)*c1 ;
    path3 b2 = shift(-r2*vv2)*c2 -- shift(r2*vv2)*c2 ;
    //path3 b3 = shift(-ep/2*n1)*c1 -- shift(ep/2*n1)*c1 ;
    //path3 b4 = shift(-ep/2*n2)*c2 -- shift(ep/2*n2)*c2 ;

    fill(project(b1 -- reverse(b2) -- cycle), white) ;
    draw(project(b1), CEC1, Arrows) ;
    draw(project(b2), CEC2, Arrows) ;

    //draw(project(shift(-r1*vv1)*b3), CEC1) ;
    //draw(project(shift(r1*vv1)*b3), CEC1) ;
    //draw(project(shift(-r2*vv2)*b4), CEC2) ;
    //draw(project(shift(+r2*vv2)*b4), CEC2) ;


    draw(project(shift(-r1*vv1)*c1 -- shift(r2*vv2)*c2), gray+dashdotted) ;
    //draw(project(shift(-r1*vv1)*c1 -- shift(r1*vv1)*c1), gray+dashdotted) ;
    //draw(project(shift(-r2*vv2)*c2 -- shift(r2*vv2)*c2), gray+dashdotted) ;

    
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}

write('... end poulie courroie at ' + (string)c1 + ' and ' + (string)c2 + '.\n') ;
}










/* ------------------------------------ */


/* ------------------------------------ */
/* Relier -- pour accepter 2D et 3D */
void link(path3 chemin, pen CEC) {
if (!isPlane(currentprojection.camera)) {
    draw(chemin, CEC) ;
}
else {
draw(project(chemin), CEC) ;
}
}







/* ------------------------------------ */






/* ------------------------------------ */
/* Bâti */
void bati(triple point, triple dirGB, triple orPB, pen CEC) {
write('Begin bati ...') ;
real lGB = 1 ;
real lPB = 0.25 ;
int nb = 5 ;

if (!isPlane(currentprojection.camera)) {
draw(point - lGB/2*dirGB  -- point + lGB/2*dirGB, CEC)   ; 
for (int i=-1; i<nb; ++i){
    triple P1 = point - lGB/2*dirGB + lPB*orPB + i*lGB/nb*dirGB ;
    triple P2 = point - lGB/2*dirGB + (i+1)*lGB/nb*dirGB ;
    draw(P1 -- P2, CEC) ;
}
}
else {
draw(project(point - lGB/2*dirGB  -- point + lGB/2*dirGB), CEC)   ; 
for (int i=-1; i<nb; ++i){
    triple P1 = point - lGB/2*dirGB + lPB*orPB + i*lGB/nb*dirGB ;
    triple P2 = point - lGB/2*dirGB + (i+1)*lGB/nb*dirGB ;
    draw(project(P1 -- P2), CEC) ;
}
}
write('... end bati.\n') ;
}


/* ------------------------------------ */




/* ------------------------------------ */
/* Shapes to add */

void addCylinder(triple point, triple axis, real cyl_r, real cyl_h, pen CEC) {
write('Begin add cylinder at ' + (string)point + ' ...') ;
if (!isPlane(currentprojection.camera)) {
revolution cylSolid = cylinder(-cyl_h/2*unit(axis), cyl_r, cyl_h, axis) ;
surface cylinder = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,cyl_h)*unitcylinder ;
surface disq_cyl = shift(point)*align(unit(axis))*shift((0,0,-cyl_h/2))*scale(cyl_r,cyl_r,0)*unitdisk ;
surface disq_cyl1 = shift(point)*align(unit(axis))*shift((0,0,cyl_h/2))*scale(cyl_r,cyl_r,0)*unitdisk ;

draw(cylinder, white) ;
draw(disq_cyl, white) ;
draw(disq_cyl1, white) ;

path3 circle = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3 ;
draw(shift(-cyl_h/2*unit(axis))*circle, CEC) ;
draw(shift(+cyl_h/2*unit(axis))*circle, CEC) ;

draw(shift(point)*cylSolid.silhouette(), CEC) ;
}
else {
if (abs(dot(currentprojection.camera, axis)) == 1) {
    write('ortho') ;
    path3 c = shift(point)*align(unit(axis))*scale(cyl_r,cyl_r,0)*unitcircle3  ;
    filldraw(project(c), white, CEC) ;
}
else if (dot(currentprojection.camera, axis) == 0) {
    write('in the plane') ;
    triple axisPerp = unit(cross(currentprojection.camera, axis)) ;
    path3 rectangle = + 1/2*cyl_h*axis + cyl_r*axisPerp  --   - 1/2*cyl_h*axis + cyl_r*axisPerp 
    -- -1/2*cyl_h*axis - cyl_r*axisPerp -- +1/2*cyl_h*axis - cyl_r*axisPerp -- cycle ;
    filldraw(project(shift(point)*rectangle), white, CEC) ;
    //path3 line = -cyl_h*unit(axis)-- +cyl_h*unit(axis) ;
    //draw(project(shift(point)*line), CEC) ;
    //path3 stop1 = -posStop*cyl_h*unit(axis) + lStop*stopAxis -- -posStop*cyl_h*unit(axis) - lStop*stopAxis ;
    //path3 stop2 = +posStop*cyl_h*unit(axis) + lStop*stopAxis -- +posStop*cyl_h*unit(axis) - lStop*stopAxis ;
    //draw(project(shift(point)*stop1), c2) ;
    //draw(project(shift(point)*stop2), c2) ;
}
else {
    write('not in the plane neither ortho  ! ') ;
}
}
write('... end add cylinder at ' + (string)point + '.\n') ;


}



/* ------------------------------------ */



void addDisque(triple centre, triple normal, real R, pen CEC){
	write('Begin add disque at ' + (string)centre + ' ...') ;
path3 disque = shift(centre)*align(unit(normal))*circle(O,R) ;
if (!isPlane(currentprojection.camera)) {
draw(disque, CEC) ;
draw(surface(disque), CEC+opacity(0.1)) ;
}
else {
filldraw(project(disque), CEC+opacity(0.1), CEC) ;
}
write('... end add disque at ' + (string)centre + '.\n') ;
}


/* ------------------------------------ */



void addSurfConique(triple sommet, triple axis, real hauteur, real demiAngle, pen CEC) {
write('Begin addSurfConique ') ;
triple axisPerp = unit(cross(axis,currentprojection.camera)) ;    
path3 generatrice = sommet -- (sommet+hauteur*axis+hauteur*tan(demiAngle)*axisPerp) ;
path3 circle = shift(sommet+hauteur*axis)*align(unit(axis))*scale(hauteur*tan(demiAngle),hauteur*tan(demiAngle),0)*unitcircle3 ;

if (!isPlane(currentprojection.camera)) {
revolution cone = revolution(O, generatrice, axis, angle1 = 0, angle2 = 360) ;
draw(cone.silhouette(256), CEC) ;
draw(surface(cone), CEC+opacity(0.1)) ;
draw(circle, CEC);
}
else {
	if (abs(dot(currentprojection.camera, axis))==1) {
	draw(project(circle), CEC);
	fill(project(circle), CEC+opacity(0.1));
	}
	else if (dot(currentprojection.camera, axis) == 0) {
path3 generatriceBis = sommet -- (sommet+hauteur*axis-hauteur*tan(demiAngle)*axisPerp) ;
path triangle = project(generatrice) -- project(reverse(generatriceBis)) -- cycle ;
filldraw(triangle, CEC+opacity(0.1), CEC) ;
	}
	else {
	    write('not in the plane neither ortho  ! ') ;
}
}
write('... end addSurfConique. \n') ;
}


/* ------------------------------------ */


void addSurfConiqueTronquee(triple sommet, triple axis, real hauteur1, real hauteur2, real demiAngle, pen CEC) {
write('Begin addSurfConique ') ;
triple axisPerp = unit(cross(axis,currentprojection.camera)) ;    
path3 generatrice = (sommet+hauteur1*axis+hauteur1*tan(demiAngle)*axisPerp) -- (sommet+hauteur2*axis+hauteur2*tan(demiAngle)*axisPerp) ;
path3 circle1 = shift(sommet+hauteur1*axis)*align(unit(axis))*scale(hauteur1*tan(demiAngle),hauteur1*tan(demiAngle),0)*unitcircle3 ;
path3 circle2 = shift(sommet+hauteur2*axis)*align(unit(axis))*scale(hauteur2*tan(demiAngle),hauteur2*tan(demiAngle),0)*unitcircle3 ;

if (!isPlane(currentprojection.camera)) {
revolution cone = revolution(O, generatrice, axis, angle1 = 0, angle2 = 360) ;
draw(cone.silhouette(256), CEC) ;
draw(surface(cone), CEC+opacity(0.1)) ;
draw(circle1, CEC);
draw(circle2, CEC);
}
else {
	if (abs(dot(currentprojection.camera, axis))==1) {
	draw(project(circle1), CEC);
	draw(project(circle2), CEC);
	fill(project(circle1) ^^ reverse(project(circle2)), CEC+opacity(0.1));
	}
else if (dot(currentprojection.camera, axis) == 0) {
path3 generatriceBis = (sommet+hauteur1*axis-hauteur1*tan(demiAngle)*axisPerp) -- (sommet+hauteur2*axis-hauteur2*tan(demiAngle)*axisPerp) ;
path triangle = project(generatrice) -- project(reverse(generatriceBis)) -- cycle ;
filldraw(triangle, CEC+opacity(0.1), CEC) ;
}
else {
	    write('not in the plane neither ortho  ! ') ;
}
}
write('... end addSurfConique. \n') ;
}






/* ------------------------------------ */



/* ------------------------------------ */ 
/* Name points */

void namePoint(triple point, string label, pair pos=NE) {
write('Begin namePoint ' + label) ;
string marker = "+" ;
triple place = point+1*currentprojection.camera ;

if (!isPlane(currentprojection.camera)) {
label("$"+marker+"$", place) ;
label("$"+label+"$", place, pos) ;
}
else 
{
label("$"+marker+"$", project(place)) ;
label("$"+label+"$", project(place), pos) ;
}
write('... end namePoint ' + label + '\n') ;
}




/* ------------------------------------ */



/* ------------------------------------ */ 
/* Classes numbers */

void nameClasse1point(string label, triple point1, pair pos=1.5*NE, pen p=currentpen) {
write('Begin nameClasse1point ' + label) ;
if (!isPlane(currentprojection.camera)) {
label("$("+label+")$", point1, pos, p);
}
else 
{
label("$("+label+")$", project(point1), pos, p);
}
write('... end nameClasse1point ' + label + '\n') ;
}


/* ------------------------------------ */ 

void nameClasse2points(string label, triple point1, triple point2, pair pos=1.5*NE, pen p=currentpen) {
write('Begin nameClasse2points ' + label) ;
if (!isPlane(currentprojection.camera)) {
triple midpoint(triple p1, triple p2) {
    real xm = (p1.x + p2.x) / 2;
    real ym = (p1.y + p2.y) / 2;
    real zm = (p1.z + p2.z) / 2;
    return (xm, ym, zm);
}
triple mid = midpoint(point1, point2);
label("$("+label+")$", mid, pos, p);
}
else 
{
pair midpoint(pair p1, pair p2) {
    real xm = (p1.x + p2.x) / 2;
    real ym = (p1.y + p2.y) / 2;
    return (xm, ym);
}
pair mid = midpoint(project(point1), project(point2));
label("$("+label+")$", mid, pos, p);
}
write('... end nameClasse2points ' + label + '\n') ;
}


/* ------------------------------------ */



/* ------------------------------------ */ 
/* Elements technologiques */



/* Ressort */
void addSpring(triple A, triple B, int N=8){
	write('Begin addSpring ' + (string)A + '...') ;
    real R = 0.35*(2)^(1/2)/2 ;
    real L = length(B-A) ;
    real pas = N/L ;
    int nbPoints = 36 * N ;
	triple axis = unit(B-A) ;
	pen couleur = black+0.75 ;

if (!isPlane(currentprojection.camera)) {

triple axisPerp = vecteurLocalOrth(A, axis) ;
triple axisPerp2 = unit(cross(axis, axisPerp)) ;
	
real xl(real t) {return axisPerp.x*R*cos(pas*2*pi*t) + axisPerp2.x*R*sin(pas*2*pi*t) + axis.x*t ;}
real yl(real t) {return axisPerp.y*R*cos(pas*2*pi*t) + axisPerp2.y*R*sin(pas*2*pi*t) + axis.y*t ;}
real zl(real t) {return axisPerp.z*R*cos(pas*2*pi*t) + axisPerp2.z*R*sin(pas*2*pi*t) + axis.z*t ;}

path3 p = graph(xl, yl, zl, 0, L, n=nbPoints);
path3 debut = A -- A+axisPerp*R ;
path3 fin = B -- B+axisPerp*R ;

draw(shift(A)*p, couleur) ;
draw(debut , couleur) ;
draw(fin, couleur) ;
}

else {
triple axisPerp = cross(currentprojection.camera, axis) ;
triple axisPerp2 = unit(cross(axis, axisPerp)) ;
	
real xl(real t) {return axisPerp.x*R*cos(pas*2*pi*t) + axisPerp2.x*R*sin(pas*2*pi*t) + axis.x*t ;}
real yl(real t) {return axisPerp.y*R*cos(pas*2*pi*t) + axisPerp2.y*R*sin(pas*2*pi*t) + axis.y*t ;}
real zl(real t) {return axisPerp.z*R*cos(pas*2*pi*t) + axisPerp2.z*R*sin(pas*2*pi*t) + axis.z*t ;}

path3 p = graph(xl, yl, zl, 0, L, n=nbPoints);
path3 debut = A -- A+axisPerp*R ;
path3 fin = B -- B+axisPerp*R ;
	
draw(project(shift(A)*p), couleur) ;
draw(project(debut), couleur) ;
draw(project(fin), couleur) ;
}

write('... end addSpring ' + (string)A  + '\n') ;
}



/* ------------------------------------ */



/* ------------------------------------ */ 
/* Bounding objects */



void simpleCubeBounding(real lim) {
write('Begin simpleCubeBounding ') ;

triple negativeVertex = -lim * (b0.x + b0.y + b0.z) ;
triple positiveVertex = lim * (b0.x + b0.y + b0.z) ;

if (!isPlane(currentprojection.camera)) {
draw(box(negativeVertex, positiveVertex), opacity(0.)) ;} // invisble doen't seem to work in 3D ; invisible ne semble pas marcher en 3D
else 
{draw(project(box(negativeVertex, positiveVertex)), invisible) ;}

write('... end simpleCubeBounding. \n') ;
}


/* ------------------------------------ */


void simpleSphereBounding(real lim) {
write('Begin simpleSphereBounding ') ;

if (!isPlane(currentprojection.camera)) {
draw(scale(lim,lim,lim)*unitsphere, opacity(0.)) ;} // invisble doen't seem to work in 3D ; invisible ne semble pas marcher en 3D
else 
{draw(scale(lim)*(unitcircle), opacity(0.)) ;}

write('... end simpleSphereBounding. \n') ;
}




void parallelepipedBounding(triple negativeVertex, triple positiveVertex) {
write('Begin parallelepipedBounding ') ;

if (!isPlane(currentprojection.camera)) {
draw(box(negativeVertex, positiveVertex), opacity(0.)) ;} // invisble doen't seem to work in 3D ; invisible ne semble pas marcher en 3D
else 
{draw(project(box(negativeVertex, positiveVertex)), invisible) ;}

write('... end parallelepipedBounding. \n') ;
}



/* ------------------------------------ */



/* ------------------------------------ */ 
/* animation */




void endAnimationPDF(animation anim) {
write('Begin endAnimationPDF ') ;
if (!isPlane(currentprojection.camera)) {
anim.movie(delay=100) ;
}
else {
label(anim.pdf(delay=36,"loop,controls",multipage=false));
}
write('... end endAnimationPDF. \n') ;
}


/* ------------------------------------ */ 
/* fake function for python animation */



void animationScriptPython() {}