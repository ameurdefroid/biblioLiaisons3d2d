settings.render = -4 ;
settings.prc = false ;
import biblioLiaisons ;
defaultpen(fontsize(10pt)) ;
unitsize(1cm) ;
triple eye = (1,1,1) ;
triple up = (0,1,0) ;
currentprojection = orthographic(eye, up, O) ;
currentlight = nolight ;
showBasis(b0, O, coeff=1.5*(1,1,1)) ;
transEngrenages(O, b0.x, 1.25, red, O+(0,0,1), b0.x, blue) ;