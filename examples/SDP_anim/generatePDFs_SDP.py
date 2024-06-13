# AM
import numpy as np
import os
# os.chdir(r"path/to/your/folder/depending/on/your/pov")

nbPoints = 18
Ltheta = np.arange(0,2*np.pi,2*np.pi/nbPoints)

shortName = 'SDP_3d_anim_'

for i in range(len(Ltheta)) :
    chemin = "" # same as before
    f1 = open(chemin + shortName + 'python.asy')
    toutesLesLignes = f1.readlines()
    f1.close()

    nom = shortName + str(i) + '.asy'
    fid = open(nom,'w')
    for ligne in toutesLesLignes :
        if 'real theta6 = 10/360*2*pi ;' in ligne :
            aEcrire = 'real theta6 = '+ str(Ltheta[i])
            fid.write(aEcrire + ' ;\n')
        else :
            fid.write(ligne)

    fid.close()
    commande = ' "C:/Program Files/Asymptote/asy.exe" -f pdf -noView -compact -o '+ shortName + str(i) + ' '  + nom
    os.system(commande)
    print("OK figure " + str(i))
    
    commande = 'del '+ nom
    os.system(commande)
    print("OK suppression " + str(i))

#merge pdfs 
from pypdf import PdfWriter
merger = PdfWriter()
for i in range(len(Ltheta)) :
    pdf =  shortName + str(i) + '.pdf'
    merger.append(pdf)

merger.write(shortName + 'all.pdf')
merger.close()




