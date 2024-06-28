% Questo script carica un'immagine, applica il metodo di thresholding 
% di Otsu per segmentarla e quindi visualizza e salva l'immagine 
% binaria risultante. Include anche un miglioramento del contrasto 
% e un filtraggio del rumore opzionali.

% --- Caricamento e preparazione dell'immagine ---

% Carica l'immagine
percorso_immagine = 'cane16.jpg'; % Sostituisci con il percorso della tua immagine
immagine = imread(percorso_immagine);

% Converti in scala di grigi se necessario
if size(immagine, 3) == 3
  immagine = rgb2gray(immagine);
end

% Visualizza l'immagine originale
figure;
imshow(immagine);
title('Immagine originale');

% --- Miglioramento dell'immagine (opzionale) ---

% Miglioramento del contrasto (regola i limiti per un maggiore contrasto)
immagine = imadjust(immagine, [0.2 0.8], []); 

% Filtraggio del rumore (applica un filtro mediano per ridurre il rumore)
immagine = medfilt2(immagine, [3 3]); 

% --- Calcolo della soglia (metodo di Otsu) ---

% Calcola automaticamente la soglia ottimale con il metodo di Otsu
soglia = graythresh(immagine); 

% --- Applicazione della soglia ---

% Crea un'immagine binaria: 
% - pixel > soglia -> bianchi (1)
% - pixel <= soglia -> neri (0)
immagine_segmentata = immagine > soglia; 

% --- Visualizzazione e salvataggio ---

% Visualizza l'immagine segmentata
figure;
imshow(immagine_segmentata);
title(['Immagine segmentata (Soglia di Otsu: ' num2str(soglia) ')']);

% Salva l'immagine segmentata come file PNG
imwrite(immagine_segmentata, 'immagine_segmentata.png');