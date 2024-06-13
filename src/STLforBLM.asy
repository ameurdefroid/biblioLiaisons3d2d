import three ;
import solids ;

struct objectSTL {
    surface surf ;
    path3 [] edgesToDraw ;
    triple[] normals  ;
    triple [][] mesh ;
    triple[][] edges ;
    triple[] vertices  ;
    int[][] tabIndicesMesh ;   
}


// bool if edge in array
bool edgeIn(triple [] localEdge, triple[][] edges) {
    int n = edges.length ;
    for (int i=0;i<n ;++i){
        triple[] edge = edges[i] ;
        triple edge1 = edge[0] ;
        triple edge2 = edge[1] ;
        if (edge1 == localEdge[0] && edge2 == localEdge[1] ) {return true ;}
        
        triple temp0 =  localEdge[0]  ;
        triple temp1 =  localEdge[1]  ;
        if (edge1 == temp1 && edge2 == temp0 ) {return true ;}
    }
    return false;
}


// bool if vertice in array
bool verticeIn( triple vertice, triple[] listeVertices) {
    int n = listeVertices.length ;
    for (int i=0; i<n ;++i) {
        if (vertice==listeVertices[i]) {return true ;}
    }
    return false ;
}


// ----------------------------------------------------------


objectSTL readstlfileFull(string filename, transform3 transf, transform3 normaleOrientation, triple obs, bool ascii=true) {
  objectSTL newObject ;
  assert(ascii, "Reading binary stl files not implemented.");
  file stlfile = input(filename).word();  // Set up a file to read whitespace-delimited items.
  string nextword;
  real x, y, z;
  nextword = stlfile;  // Reading from a file is done by assignment in Asymptote.
  assert(nextword == "solid", filename + " is not a well-formed stl file.");
  string name = stlfile;

  
  int cptMesh = -1 ;

  
 while (!eof(stlfile)) {
    nextword = stlfile;
    if (nextword == "endsolid") break;
    else if (nextword == "facet") {
      ++ cptMesh ;  
      nextword = stlfile;
      assert(nextword == "normal");
      x = stlfile; y = stlfile; z = stlfile;
      triple temp  = normaleOrientation*(x, y, z);
      newObject.normals.push(temp) ;

      nextword = stlfile; assert(nextword == "outer");
      nextword = stlfile; assert(nextword == "loop");
      triple[] verticesMesh = new triple[3];
      for (int i = 0; i < 3; ++i) {
        nextword = stlfile; assert(nextword == "vertex");
        x = stlfile; y = stlfile; z = stlfile;
        verticesMesh[i] = transf*scale3(1/10) *(x,y,z); // 1/10 car cao en mm -> ramené en cm

        //test presence vertices verticeIn
        if (!verticeIn(verticesMesh[i], newObject.vertices)) {
        newObject.vertices.push(verticesMesh[i]) ;
        }
      }

      newObject.mesh.push(verticesMesh) ;

      triple [] localEdge = new triple[2];

      localEdge[0] = verticesMesh[0] ;
      localEdge[1] = verticesMesh[1] ;
      

      if (newObject.edges.length == 0) {
        newObject.edges.push(localEdge) ;
      }
      else if (!edgeIn(localEdge, newObject.edges)) {
      newObject.edges.push(localEdge) ;
      }

      triple [] localEdge = new triple[2];
      localEdge[0] = verticesMesh[0] ;
      localEdge[1] = verticesMesh[2] ;
      if (!edgeIn(localEdge, newObject.edges)) {
       newObject.edges.push(localEdge) ;
      }

      triple [] localEdge = new triple[2];
      localEdge[0] = verticesMesh[1] ;
      localEdge[1] = verticesMesh[2] ;
      if (!edgeIn(localEdge, newObject.edges)) {
     newObject.edges.push(localEdge) ;
      }




      nextword = stlfile; assert(nextword == "endloop");
      nextword = stlfile; assert(nextword == "endfacet");
      path3 tt = verticesMesh[0] -- verticesMesh[1] -- verticesMesh[2] -- cycle ;
      patch triangle = patch(tt);
      newObject.surf.s.push(triangle);

           }
      }

      write('Fin balayage STL file \n') ;

     write('Computation connectivity edges ... \n') ;

     int j, cpt ;
     triple vertice1, vertice2 ;
     bool boolVertice1, boolVertice2 ;
     int[][] tabIndicesMesh = new int[newObject.edges.length][2];
     for (int i=0; i<newObject.edges.length;++i) {
        for (int j=0; j<2;++j){
            tabIndicesMesh[i][j] = -1 ;
        }
     }

     for (int i=0; i<newObject.edges.length; ++i) {
           triple[] edgeLocal = newObject.edges[i] ;
           
           vertice1 = edgeLocal[0] ;
           vertice2 = edgeLocal[1] ;
           boolVertice1 = false ;  
           boolVertice2 = false ;
           cpt = 0 ;
           j = 0 ;
           while (!( (boolVertice1 && boolVertice2 && cpt ==2) || (j>=newObject.mesh.length))) {
            boolVertice1 = false ;
            boolVertice2 = false ;
            //write('premier ', vertice1, vertice2) ;
            for (int k=0; k<3; ++k) {
                //write(j,k) ;
                //write('AAA  ' ,newObject.mesh[j]) ;
                //write(newObject.mesh[j][k]) ;
                if (vertice1 == newObject.mesh[j][k]) {
                    boolVertice1 = true ;
                }
                if (vertice2 == newObject.mesh[j][k]) {
                    boolVertice2 = true ;
                }
                //write(boolVertice1,boolVertice2) ;
            }
            if (boolVertice1 && boolVertice2) {
                tabIndicesMesh[i][cpt]=j ;
                //write(i, cpt , j) ;
                ++cpt ;
                
            }                     
            ++j ;
            //write('---------') ;
           }
           //write(tabIndicesMesh) ;

         newObject.tabIndicesMesh = tabIndicesMesh ;
           
     }

     // edge à tracer
     
     for (int i=0; i<newObject.tabIndicesMesh.length;++i) {
        triple[] M1 , M2 = new triple[3] ;
        triple n1, n2 ;
        int i1 = newObject.tabIndicesMesh[i][0] ;
        int i2 = newObject.tabIndicesMesh[i][1] ;
        if (i1!=-1 && i2!=-1) {
        n1 = newObject.normals[i1] ;
        n2 = newObject.normals[i2] ;
        //write('---------------------') ;
        //write(n1,n2) ;
        if (abs(dot(n1,n2)) < 0.7) {
            path3 tempPath = newObject.edges[i][0] -- newObject.edges[i][1] ;
            newObject.edgesToDraw.push(tempPath) ;
        }
        //triple vv = (1,1,1) ;
        if (sgn(dot(n1, obs)) != sgn(dot(n2, obs)))  {
            path3 tempPath = newObject.edges[i][0] -- newObject.edges[i][1] ;
            newObject.edgesToDraw.push(tempPath) ;
        }

        }

     }
     

   
return newObject ;
}
