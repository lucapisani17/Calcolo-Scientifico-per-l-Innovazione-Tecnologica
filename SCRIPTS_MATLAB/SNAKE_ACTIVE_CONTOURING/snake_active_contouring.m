% Questo script carica un'immagine e applica l'algoritmo active contour 
% (contorni attivi) utilizzando due maschere iniziali diverse. 
% Vengono testati diversi numeri di iterazioni per l'algoritmo 
% active contour e i risultati vengono visualizzati.

% --- Lettura e preparazione dell'immagine ---

% Lettura immagine
I = imread('snake.jpg'); 

% Conversione in scala di grigi se l'immagine è a colori
if size(I,3) == 3
    I = rgb2gray(I); % Conversione in scala di grigi
end

% --- Definizione delle maschere ---

% Definizione delle dimensioni della maschera (1/3 dell'immagine)
mask_width = round(size(I, 2) / 3);
mask_height = round(size(I, 1) / 3);

% --- Maschera 1 ---
% La prima maschera è posizionata al centro dell'immagine

% Coordinate del centro della maschera 1
mask_center_x_1 = round(mask_width / 2);
mask_center_y_1 = round(mask_height / 2);

% Creazione maschera 1 (matrice di booleani)
mask1 = false(size(I)); % Inizializzazione con valori "false"
% Definizione delle righe e colonne della maschera 
% (centrata sulle coordinate calcolate)
start_row_1 = max(1, mask_center_y_1 - round(mask_height/2));
end_row_1 = min(size(I, 1), start_row_1 + mask_height - 1);
start_col_1 = max(1, mask_center_x_1 - round(mask_width/2));
end_col_1 = min(size(I, 2), start_col_1 + mask_width - 1);
% Impostazione a "true" i pixel della maschera
mask1(start_row_1:end_row_1, start_col_1:end_col_1) = true;

% --- Maschera 2 ---
% La seconda maschera è posizionata nel quarto in basso a destra dell'immagine

% Coordinate del centro della maschera 2
mask_center_x_2 = round(3 * size(I, 2) / 4);
mask_center_y_2 = round(3 * size(I, 1) / 4);

% Creazione maschera 2 (matrice di booleani)
mask2 = false(size(I)); % Inizializzazione con valori "false"
% Definizione delle righe e colonne della maschera 
% (centrata sulle coordinate calcolate)
start_row_2 = max(1, mask_center_y_2 - round(mask_height/2));
end_row_2 = min(size(I, 1), start_row_2 + mask_height - 1);
start_col_2 = max(1, mask_center_x_2 - round(mask_width/2));
end_col_2 = min(size(I, 2), start_col_2 + mask_width - 1);
% Impostazione a "true" i pixel della maschera
mask2(start_row_2:end_row_2, start_col_2:end_col_2) = true;

% --- Applicazione di active contour e visualizzazione ---

% Definizione delle iterazioni per active contour
iterations_array = [300, 600, 2000];

% Ciclo for per diverse iterazioni
for i = 1:length(iterations_array)
    iterations = iterations_array(i);

    % Applicazione di activecontour con maschera 1
    bw1 = activecontour(I, mask1, iterations); 
    % 'bw1' conterrà la maschera finale dopo l'evoluzione del contorno

    % Applicazione di activecontour con maschera 2
    bw2 = activecontour(I, mask2, iterations);
    % 'bw2' conterrà la maschera finale dopo l'evoluzione del contorno

    % --- Visualizzazione dei risultati ---

    figure; % Crea una nuova figura per ogni iterazione
    
    subplot(2, 3, 1); % Immagine originale
    imshow(I);
    title('Immagine originale');

    subplot(2, 3, 2); % Maschera iniziale 1
    imshow(mask1);
    title('Maschera iniziale 1');

    subplot(2, 3, 3); % Maschera iniziale 2
    imshow(mask2);
    title('Maschera iniziale 2');

    subplot(2, 3, 4); % Contorno 1
    imshow(bw1);
    title(['Contorno 1 (', num2str(iterations), ' iterazioni)']);

    subplot(2, 3, 5); % Contorno 2
    imshow(bw2);
    title(['Contorno 2 (', num2str(iterations), ' iterazioni)']);

    subplot(2, 3, 6); % Contorni sovrapposti all'immagine originale
    imshow(I);
    hold on;
    visboundaries(bw1, 'Color', 'r'); % Contorno 1 in rosso
    visboundaries(bw2, 'Color', 'g'); % Contorno 2 in verde
    title(['Contorni sovrapposti (', num2str(iterations), ' iterazioni)']);

    disp(['Completato con ', num2str(iterations), ' iterazioni'])
end