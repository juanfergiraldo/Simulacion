clc
clear all
close all

load('drug_comsuption.mat')
X = DB(:,1:12);
%Yamphet 14, Ycaffeine 17, Ycanabis 18, Ynicotine 29

disp('1. Amphetamine')
disp('2. Caffeine')
disp('3. Cannabis')
disp('4. Nicotine')
switch input('Seleccione la droga a analizar: ')
    case 1
        Y = DB(:,14);
    case 2
        Y = DB(:,17);
    case 3
        Y = DB(:,18);
    case 4
        Y = DB(:,29);
end

rept = 10; % Aqui establezco el numero de pliegues que se usaran para la validacion cruzada y las iteraciones para entrenar (Deben ser las mismas)
numClases=length(unique(Y)); %%% Se determina el número de clases del problema.
numMuestras=size(X,1); % Aqui determino cuantas son las muestras de entrenamiento

disp('1. K Vecinos más cercanos')
disp('2. Ventana de Parzen')
disp('3. Random Forest')
disp('4. SVM')
switch input('Ingrese el numeral del modelo a elegir: ')   
    case 1      %%% modelo kNN %%%
        k = 4;
        modeloKNN(X, Y, k);
    case 2      %%% modelo ventana de Parzen %%%
        h = 0.5;
        modeloParzenWindow(X, Y, h);
    case 3 %%% modelo de Random forest
        numArboles = 10;
        modeloRandomForest(rept, numClases, numMuestras, numArboles, X, Y);
    case 4 %%% modelo de SVM
        boxConstraint = 0.01;
        gamma = 0.01;
        tipoK = 1;
        modeloSVM(rept, numClases, numMuestras, boxConstraint, gamma, tipoK, X, Y);
    otherwise
        disp('Numero inválido')
end