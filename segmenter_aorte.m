function [X,Y,Centre,Diametre] = segmenter_aorte(CT_scan,i)
%Cette fonction prend un scan et un indice de progression en entrée et renvoie le contour de l'aorte
%ainsi que son diametre et la position de son centre

%On ajoute du contraste sur l'image
CT_scan = imadjust(CT_scan);
%On coupe pour avoir la zone qui nous intéresse
Im_scan_crop = imcrop(CT_scan,[200 200 140 120]);
%On passe en noir et blanc pour pouvoir sélectionner une zone
Im_scan_crop_bw = imbinarize(Im_scan_crop,0.88);
%On isole la lumière aortique
if i<=66
    Lumiere_aortique = bwselect(Im_scan_crop_bw,83,83);
else
    Lumiere_aortique = bwselect(Im_scan_crop_bw,82,64);
end

%On récupère le centre et le diamètre équivalent de la lumière aortique
Forme = regionprops(Lumiere_aortique,'Centroid','EquivDiameter');
Centre = Forme.Centroid;
Diametre = Forme.EquivDiameter;
%On récupère tous les points qui délimite la forme de la lumière aortique.
Contour = edge(Lumiere_aortique,'canny');
[X,Y] = find(Contour);

end