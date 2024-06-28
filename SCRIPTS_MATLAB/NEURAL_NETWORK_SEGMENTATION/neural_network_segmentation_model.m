% Questo script carica un set di immagini di cani, crea maschere di segmentazione per identificare i cani nelle immagini, 
% addestra una rete neurale per classificare i pixel come cane o non cane e infine utilizza la rete per segmentare un nuovo cane in un'immagine.

%un metodo di ottimizzazione perfetta sarebe calcolare la soglia in modo
%dinamico oppure aumentare la dimensione delle immagini oppure modificare
%il numero di layer nascosti

% 1. PREPARAZIONE DEI DATI
% ------------------------

dimensione_immagine = [100 100]; % Scegli la dimensione che preferisci

% Carica immagini di gatti e crea maschere di segmentazione manuali.
% Supponiamo di avere diciannove immagini:
cane1  = imread('cane1.jpg');
cane2  = imread('cane2.jpg');
cane3  = imread('cane3.jpg');
cane4  = imread('cane4.jpg');
cane5  = imread('cane5.jpg');
cane6  = imread('cane6.jpg');
cane7  = imread('cane7.jpg');
cane8  = imread('cane8.jpg');
cane9  = imread('cane9.jpg');
cane10 = imread('cane10.jpg');
cane11 = imread('cane11.jpg');
cane12 = imread('cane12.jpg');
cane13 = imread('cane13.jpg');
cane14 = imread('cane14.jpg');
cane15 = imread('cane15.jpg');
cane16 = imread('cane16.jpg');
cane17 = imread('cane17.jpg');
cane18 = imread('cane18.jpg');
cane19 = imread('cane19.jpg');

% Converti in scala di grigi e ridimensiona
cane1  = double(rgb2gray(cane1)) / 255;
cane2  = double(rgb2gray(cane2)) / 255;
cane3  = double(rgb2gray(cane3)) / 255;
cane4  = double(rgb2gray(cane4)) / 255;
cane5  = double(rgb2gray(cane5)) / 255;
cane6  = double(rgb2gray(cane6)) / 255;
cane7  = double(rgb2gray(cane7)) / 255;
cane8  = double(rgb2gray(cane8)) / 255;
cane9  = double(rgb2gray(cane9)) / 255;
cane10 = double(rgb2gray(cane10)) / 255;
cane11 = double(rgb2gray(cane11)) / 255;
cane12 = double(rgb2gray(cane12)) / 255;
cane13 = double(rgb2gray(cane13)) / 255;
cane14 = double(rgb2gray(cane14)) / 255;
cane15 = double(rgb2gray(cane15)) / 255;
cane16 = double(rgb2gray(cane16)) / 255;
cane17 = double(rgb2gray(cane17)) / 255;
cane18 = double(rgb2gray(cane18)) / 255;
cane19 = double(rgb2gray(cane19)) / 255;

cane1  = imresize(cane1, dimensione_immagine);
cane2  = imresize(cane2, dimensione_immagine); 
cane3  = imresize(cane3, dimensione_immagine);
cane4  = imresize(cane4, dimensione_immagine);
cane5  = imresize(cane5, dimensione_immagine);
cane6  = imresize(cane6, dimensione_immagine);
cane7  = imresize(cane7, dimensione_immagine);
cane8  = imresize(cane8, dimensione_immagine);
cane9  = imresize(cane9, dimensione_immagine); 
cane10 = imresize(cane10, dimensione_immagine);
cane11 = imresize(cane11, dimensione_immagine);
cane12 = imresize(cane12, dimensione_immagine);
cane13 = imresize(cane13, dimensione_immagine);
cane14 = imresize(cane14, dimensione_immagine);
cane15 = imresize(cane15, dimensione_immagine);
cane16 = imresize(cane16, dimensione_immagine);
cane17 = imresize(cane17, dimensione_immagine);
cane18 = imresize(cane18, dimensione_immagine);
cane19 = imresize(cane19, dimensione_immagine); 

% Crea maschere dopo il ridimensionamento
soglia = 130;

maschera1  = double(cane1 > soglia/255);
maschera2  = double(cane2 > soglia/255);
maschera3  = double(cane3 > soglia/255);
maschera4  = double(cane4 > soglia/255);
maschera5  = double(cane5 > soglia/255);
maschera6  = double(cane6 > soglia/255);
maschera7  = double(cane7 > soglia/255);
maschera8  = double(cane8 > soglia/255);
maschera9  = double(cane9 > soglia/255);
maschera10 = double(cane10 > soglia/255);
maschera11 = double(cane11 > soglia/255);
maschera12 = double(cane12 > soglia/255);
maschera13 = double(cane13 > soglia/255);
maschera14 = double(cane14 > soglia/255);
maschera15 = double(cane15 > soglia/255);
maschera16 = double(cane16 > soglia/255);
maschera17 = double(cane17 > soglia/255);
maschera18 = double(cane18 > soglia/255);
maschera19 = double(cane19 > soglia/255);

% Verifica le dimensioni
[righe, colonne] = size(cane1);

% Assicurati che tutte le immagini abbiano le stesse dimensioni
for i = 2:19
    assert(all(size(eval(['cane' num2str(i)])) == [righe, colonne]), ['Errore: cane1 e cane' num2str(i) ' hanno dimensioni diverse']);
end

% Assicurati che tutte le maschere abbiano le stesse dimensioni
for i = 1:19
    assert(all(size(eval(['maschera' num2str(i)])) == [righe, colonne]), ['Errore: maschera' num2str(i) ' ha dimensioni errate']);
end

% Crea un dataset combinando le immagini.
dati = [cane1(:); cane2(:); cane3(:); cane4(:); cane5(:); cane6(:); cane7(:); cane8(:); cane9(:); cane10(:); cane11(:); cane12(:); cane13(:); cane14(:); cane15(:); cane16(:); cane17(:); cane18(:); cane19(:)];
etichette = [maschera1(:); maschera2(:); maschera3(:); maschera4(:); maschera5(:); maschera6(:); maschera7(:); maschera8(:); maschera9(:); maschera10(:); maschera11(:); maschera12(:); maschera13(:); maschera14(:); maschera15(:); maschera16(:); maschera17(:); maschera18(:); maschera19(:)];

% 2. ADDESTRAMENTO DELLA RETE
% ------------------------

% Crea una rete neurale completamente connessa.
nascosti = 20; % Numero di neuroni nascosti
net = feedforwardnet(nascosti);

% Addestra la rete.
net = train(net, dati', etichette');

% 3. SEGMENTAZIONE DI UNA NUOVA IMMAGINE
% -------------------------------------

% Carica la nuova immagine.
nuova_immagine = imread('coniglio1.jpg'); % Assicurati di avere un'immagine gatto20.jpg
nuova_immagine = double(rgb2gray(nuova_immagine)) / 255;
nuova_immagine = imresize(nuova_immagine, dimensione_immagine);

% Classifica ogni pixel dell'immagine.
predizioni = net(nuova_immagine(:)'); % Trasforma in vettore riga

% Crea la maschera di segmentazione.
maschera_segmentata = reshape(predizioni > 0.5, size(nuova_immagine));

% 4. VISUALIZZAZIONE
% -----------------

figure;
subplot(1,2,1); imshow(nuova_immagine); title('Nuova immagine');
subplot(1,2,2); imshow(maschera_segmentata); title('Maschera segmentata');