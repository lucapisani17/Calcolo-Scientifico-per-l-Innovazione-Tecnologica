%% Segmentazione con metodo K-MEANS

% Questo script implementa un algoritmo di segmentazione di immagini utilizzando il metodo K-means. 
% L'obiettivo è quello di dividere l'immagine in regioni (cluster) di pixel con caratteristiche simili.

% Imposta il percorso dell'immagine
immagine_path = 'cane10.jpg'; 

% Leggi l'immagine
x = imread(immagine_path);

% Visualizza l'immagine originale
figure(1); 
subplot(1,2,1);
imshow(x); 
title('Immagine originale');

% Converti l'immagine in double e normalizza i valori nell'intervallo [0, 1]
% Questa operazione è utile per l'algoritmo K-means, che è sensibile alla scala dei dati.
x = double(x) / 255;

% Ottieni le dimensioni dell'immagine
[M, N, P] = size(x); % M = righe, N = colonne, P = canali di colore (es. 3 per RGB)

% Riformula l'immagine come una matrice 2D (righe * colonne, canali)
% Questa trasformazione è necessaria per applicare K-means, che opera su matrici 2D.
immagine_2D = reshape(x, M*N, P);

% Applica K-means con 2 cluster
K = 2; % Numero di cluster desiderati. In questo caso, si cercano due gruppi di pixel.
idx = kmeans(immagine_2D, K); % Applica K-means. 'idx' conterrà l'indice del cluster per ogni pixel.

% Riformula i risultati del clustering nella forma originale dell'immagine
% In questo modo, 'immagine_segmentata' avrà le stesse dimensioni dell'immagine originale.
immagine_segmentata = reshape(idx, M, N);

% Visualizza l'immagine segmentata
subplot(1,2,2);
imshow(immagine_segmentata, []); % Visualizza l'immagine segmentata. '[]' usa la scala di grigi di default.
title('Immagine segmentata (K-means)');

% Applica una mappa di colori per una migliore visualizzazione
colormap(jet); % Usa la mappa di colori "jet" per visualizzare i cluster in modo più chiaro.
colorbar; % Mostra la barra dei colori per interpretare i valori dei cluster.