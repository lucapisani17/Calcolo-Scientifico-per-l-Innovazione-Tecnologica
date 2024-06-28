% Script per la segmentazione di immagini usando Active Contours Without Edges (ACWE)

% --- Caricamento e pre-elaborazione dell'immagine ---
img = imread('shou.jpg');  
img = double(rgb2gray(img));       % Conversione in scala di grigi

% --- Impostazione dei parametri ---
iterNum = 100;             % Numero di iterazioni per ACWE
truncated_len = 5;          % Controlla la dimensione iniziale del contorno
c0 = 2;                     % Costante per l'inizializzazione del level set
mu = 1;                    % Penalità di lunghezza (regolarità del contorno)
lambda1 = 1;                % Peso per il termine dei dati della regione interna
lambda2 = 1;                % Peso per il termine dei dati della regione esterna
timestep = 0.1;              % Passo temporale per l'evoluzione
v = 1;                     % Forza del palloncino 
epsilon = 1;               % Regolarizzazione per la funzione delta di Dirac
pc = 1;                    % Peso per la regolarizzazione della distanza 

% --- Inizializzazione della funzione level set 'u' ---
u = ones(size(img, 1), size(img, 2)) * c0;  % Inizializza come esterno
u([truncated_len:end-truncated_len], [truncated_len:end-truncated_len]) = -c0; % Imposta interno

% --- Visualizzazione del contorno iniziale ---
figure; imshow(img, []); hold on; axis off; axis equal;
title('Immagine originale con contorno iniziale');
[c, h] = contour(u, [0 0], 'r'); 
pause(0.1); 

% --- Ciclo principale per l'evoluzione di ACWE ---
for n = 1:iterNum
    u = acwe(u, img, timestep, mu, v, lambda1, lambda2, pc, epsilon, 1); 

    % Visualizza il contorno in evoluzione ogni 10 iterazioni
    if mod(n, 10) == 0
        imshow(img, []); hold on; axis off; axis equal;
        [c, h] = contour(u, [0 0], 'r');
        title(['Evoluzione all''iterazione: ', num2str(n)]);
        hold off;
        pause(0.1);
    end
end

% --- Visualizzazione dei risultati finali ---
figure; imshow(img, []); hold on; axis off; axis equal;
[c, h] = contour(u, [0 0], 'r');
title('Contorno di segmentazione finale');

figure; imagesc(u); axis off; axis equal;
title('Funzione Level Set finale');

% --- Funzione ACWE ---
function u = acwe(u0, Img, timestep, mu, v, lambda1, lambda2, pc, epsilon, numIter)
u = u0; 
for k1 = 1:numIter
    u = neumannBoundCond(u); 
    K = curvature_central(u); 

    DrcU = (epsilon / pi) ./ (epsilon^2 + u.^2); 
    Hu = 0.5 * (1 + (2 / pi) * atan(u ./ epsilon));

    th = 0.5;
    inside_idx = find(Hu(:) < th); 
    outside_idx = find(Hu(:) >= th);

    c1 = mean(Img(inside_idx)); 
    c2 = mean(Img(outside_idx));

    data_force = -DrcU .* (mu * K - v - lambda1 * (Img - c1).^2 + lambda2 * (Img - c2).^2);
    P = pc * (4 * del2(u) - K); 
    u = u + timestep * (data_force + P); 
end
end 

% --- Funzioni di supporto ---
function g = neumannBoundCond(f)
[nrow, ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]); 
end  

function k = curvature_central(u)
[ux, uy] = gradient(u);
normDu = sqrt(ux.^2 + uy.^2 + 1e-10); 
Nx = ux ./ normDu; 
Ny = uy ./ normDu;
[nxx, ~] = gradient(Nx); 
[~, nyy] = gradient(Ny);
k = nxx + nyy; 
end 