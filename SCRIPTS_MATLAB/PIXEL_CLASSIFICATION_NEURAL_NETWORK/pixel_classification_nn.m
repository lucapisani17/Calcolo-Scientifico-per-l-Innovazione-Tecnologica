% Questo script dimostra un esempio di classificazione di pixel 
% utilizzando una rete neurale feedforward in MATLAB. 
% L'obiettivo è quello di classificare i pixel di un'immagine 
% come "chiaro" o "scuro".

% --- Caricamento e pre-elaborazione dell'immagine ---

% Carica un'immagine di esempio e convertila in scala di grigi
img = imread('maya1.jpg');
img = rgb2gray(img); 

% Normalizza i valori dei pixel tra 0 e 1
img = double(img) / 255; 

% --- Creazione del set di dati ---

% Ottieni le dimensioni dell'immagine
[righe, colonne] = size(img);

% Trasforma l'immagine in un vettore di dati, dove ogni elemento 
% rappresenta un pixel
dati = reshape(img, righe*colonne, 1); 

% Crea le etichette per ogni pixel:
% - 1 (chiaro) se il valore del pixel è maggiore di 0.5
% - 0 (scuro) altrimenti
etichette = double(dati > 0.5); 

% --- Creazione e addestramento della rete neurale ---

% Definisci il numero di neuroni nello strato nascosto
nascosti = 10; 

% Crea una rete neurale feedforward con uno strato nascosto
net = feedforwardnet(nascosti);

% Addestra la rete neurale utilizzando i dati e le etichette create
% Nota: la funzione 'train' richiede i dati in input come matrici
% con le righe come campioni e le colonne come feature/output
net = train(net, dati', etichette'); 

% --- Test della rete ---

% Definisci un nuovo pixel da classificare (valore di grigio)
nuovo_pixel = 0.7; 

% Utilizza la rete neurale addestrata per predire la classe del nuovo pixel
predizione = net(nuovo_pixel);

% --- Visualizzazione del risultato ---

% Stampa la predizione in base al valore di output della rete
if predizione > 0.5
    disp('Il pixel è classificato come chiaro');
else
    disp('Il pixel è classificato come scuro');
end