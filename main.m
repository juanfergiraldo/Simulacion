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
        Yreal = DB(:,14);
    case 2
        Yreal = DB(:,17);
    case 3
        Yreal = DB(:,18);
    case 4
        Yreal = DB(:,29);
end
Y = change3Class(Yreal);    %%se transforma la salidas de 7 clases a 3

rept = 10; % Aqui establezco el numero de pliegues que se usaran para la validacion cruzada y las iteraciones para entrenar (Deben ser las mismas)
numClases=length(unique(Y)); %%% Se determina el n�mero de clases del problema.
numMuestras=size(X,1); % Aqui determino cuantas son las muestras de entrenamiento

disp('1. K Vecinos m�s cercanos')
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
        disp('Numero inv�lido')
end