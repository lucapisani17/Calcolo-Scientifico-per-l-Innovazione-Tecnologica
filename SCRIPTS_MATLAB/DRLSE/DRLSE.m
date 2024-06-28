function eigg_segmentation_DRLSE

% Questa funzione implementa l'algoritmo  Distance Regularized Level Set Evolution (DRLSE) 
% per la segmentazione di immagini. L'algoritmo si basa sull'evoluzione di una curva di livello 
% che si muove verso i bordi dell'oggetto da segmentare. 
% La funzione prende in input un'immagine in scala di grigi e restituisce una 
% matrice binaria che rappresenta la segmentazione dell'immagine.

close all;

%% Step 1: Lettura dell'immagine in scala di grigi
Img = imread('eigg_scotland.jpg');
Img = rgb2gray(Img);

%% Step 2: Scelta dei parametri
timestep = 5;   % Passo temporale per l'evoluzione della curva di livello
mu = 0.2;       % Coefficiente del termine di regolarizzazione della distanza
lambda = 5;    % Coefficiente del termine di lunghezza della curva di livello
alfa = -3;      % Coefficiente del termine di area all'interno della curva di livello
epsilon = 1.5;  % Parametro per l'approssimazione della funzione delta di Dirac
c0 = 2;        % Valore iniziale della funzione di livello
maxiter = 602;  % Numero massimo di iterazioni
sigma = 2.0;   % Deviazione standard del kernel gaussiano per lo smoothing

%% Step 3: Smoothing dell'immagine con un filtro gaussiano
G = fspecial('gaussian', 30, sigma); % Creazione del kernel gaussiano
Img_smooth = conv2(Img, G, 'same');   % Convoluzione dell'immagine con il kernel

%% Step 4: Calcolo della funzione edge indicator
[Ix, Iy] = gradient(Img_smooth);   % Calcolo del gradiente dell'immagine
f = Ix.^2 + Iy.^2;                 % Norma al quadrato del gradiente
g = exp(-f);                       % Funzione edge indicator (valori bassi sui bordi)

% Visualizzazione della funzione edge indicator
figure(3);
imagesc(g);
axis off; axis equal;
colormap(jet);
colorbar;
title('Plot della funzione edge indicator (g)');

%% Step 5: Inizializzazione della funzione di livello (phi)
phi = -c0 * ones(size(Img)); % Inizializzazione con valore negativo costante
phi(50:650, 50:500) = c0;     % Impostazione di una regione iniziale positiva

% Visualizzazione della funzione di livello iniziale
figure(1);
imagesc(phi);
axis off; axis equal;
colormap(jet);
title('Funzione di livello iniziale (phi)');

% Calcolo del gradiente della funzione edge indicator
[vx, vy] = gradient(g);

%% Ciclo principale dell'algoritmo DRLSE
for k = 1:maxiter
    %% Step 6: Applicazione delle condizioni al contorno di Neumann
    phi = neumannBoundCond(phi);
    
    %% Step 7: Calcolo del termine di regolarizzazione della distanza
    distRegTerm = distReg_p2(phi);
    
    %% Step 8: Calcolo del termine di area
    diracPhi = dirac(phi, epsilon);  % Approssimazione della delta di Dirac
    areaTerm = diracPhi .* g;         % Moltiplicazione per la funzione edge indicator
    
    %% Step 9: Calcolo del termine di lunghezza
    [phi_x, phi_y] = gradient(phi);               % Gradiente della funzione di livello
    s = sqrt(phi_x.^2 + phi_y.^2);                % Norma del gradiente
    Nx = phi_x ./ (s + 1e-10);                   % Componente x della normale alla curva
    Ny = phi_y ./ (s + 1e-10);                   % Componente y della normale alla curva
    edgeTerm = diracPhi .* (vx .* Nx + vy .* Ny) + ... % Termine di adattamento ai bordi
               diracPhi .* g .* div(Nx, Ny);          % Termine di regolarizzazione della curvatura
    
    %% Step 10: Aggiornamento della funzione di livello
    phi = phi + timestep * (mu/timestep * distRegTerm + ...
                            lambda * edgeTerm + ...
                            alfa * areaTerm);
    
    %% Visualizzazione dei risultati ogni 50 iterazioni
    if mod(k, 50) == 1
        h = figure(2);
        set(gcf, 'color', 'w');
        
        % Visualizzazione del contorno sovrapposto all'immagine
        subplot(1, 2, 1);
        II = repmat(Img, [1 1 3]); % Conversione dell'immagine in RGB
        imshow(II); 
        axis off; axis equal; hold on;  
        q = contour(phi, [0, 0], 'r'); % Visualizzazione del contorno (phi = 0)
        msg = ['Risultato del contorno, iterazione numero = ', num2str(k)];
        title(msg);
        
        % Visualizzazione 3D della funzione di livello
        subplot(1, 2, 2);
        mesh(-phi, [-2 2]); 
        hold on;  
        contour(phi, [0, 0], 'r', 'LineWidth', 2); % Visualizzazione del contorno
        view([180-30 -65-180]);      
        msg = ['Funzione di livello (phi), iterazione numero = ', num2str(k)];
        title(msg);
        
        pause(0.1);
    end
end

%% Step 12: Visualizzazione del risultato finale
figure(3);
imagesc(Img, [0, 255]); 
axis off; axis equal; 
colormap(gray); 
hold on;  
contour(phi, [0, 0], 'r'); % Visualizzazione del contorno finale
msg = ['Iterazione numero: ', num2str(k)];
title(msg);

end

%% Funzioni di supporto

% Funzione per il calcolo del termine di regolarizzazione della distanza
function f = distReg_p2(phi)
    [phi_x, phi_y] = gradient(phi);
    s = sqrt(phi_x.^2 + phi_y.^2);
    a = (s >= 0) & (s <= 1);
    b = (s > 1);
    ps = a .* sin(2 * pi * s) / (2 * pi) + b .* (s - 1); 
    dps = ((ps ~= 0) .* ps + (ps == 0)) ./ ((s ~= 0) .* s + (s == 0)); 
    f = div(dps .* phi_x - phi_x, dps .* phi_y - phi_y) + 4 * del2(phi);
end

% Funzione per il calcolo della divergenza
function f = div(nx, ny)
    [nxx, ~] = gradient(nx);
    [~, nyy] = gradient(ny);
    f = nxx + nyy;
end

% Funzione per l'approssimazione della delta di Dirac
function f = dirac(x, sigma)
    f = (1 / (2 * sigma)) * (1 + cos(pi * x / sigma));
    b = (x <= sigma) & (x >= -sigma);
    f = f .* b;
end

% Funzione per l'applicazione delle condizioni al contorno di Neumann
function g = neumannBoundCond(f)
    [nrow, ncol] = size(f);
    g = f;
    g([1 nrow], [1 ncol]) = g([3 nrow-2], [3 ncol-2]);
    g([1 nrow], 2:end-1) = g([3 nrow-2], 2:end-1);
    g(2:end-1, [1 ncol]) = g(2:end-1, [3 ncol-2]);
end