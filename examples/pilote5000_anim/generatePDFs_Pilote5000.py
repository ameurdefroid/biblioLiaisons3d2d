# AM
import numpy as np
import os
# os.chdir(r"path/to/your/folder/depending/on/your/pov")
chemin = "" # same as before


nbPoints = 18
Ltheta = np.linspace(-np.pi/6,np.pi/6,nbPoints)
shortName = 'Pilote5000_'


for i in range(len(Ltheta)) :

    f1 = open(chemin + 'Pilote5000_animation.asy')
    toutesLesLignes = f1.readlines()
    f1.close()

    nom =  shortName + str(i) + '.asy'
    fid = open(nom,'w')
    for ligne in toutesLesLignes :
        if 'real beta = pi/6 ;' in ligne :
            aEcrire = 'real beta = '+ str(Ltheta[i])
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






