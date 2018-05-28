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
drug = input('Seleccione la droga a analizar: ');
switch drug
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

%if(drug == 1) %% Se hace SMOTE en la clase 3 de anfetamina (desbalance)
 %   [X, Y] = tecnicaSMOTE(X, Y, 3, 0.2);    %%% 20% de sobremuestreo artificial
%end
%if(drug == 2)
 %   [X, Y] = tecnicaSMOTE(X, Y, 1, 0.2);    %%% 20% de sobremuestreo artificial
 %   [X, Y] = tecnicaSMOTE(X, Y, 2, 0.2);    %%% 20% de sobremuestreo artificial
 %   [X, Y] = tecnicaSubmuestreo(X, Y, 3, 0.1);   %%% 10% de submuestreo
%end
disp('1. K Vecinos más cercanos')
disp('2. Ventana de Parzen')
disp('3. RNA')
disp('4. Random Forest')
disp('5. SVM')
disp('6. Selección variables - Correlación y Fisher')
disp('7. Selección variables - SFS')
disp('8. Extracción variables - PCA')

rept = 10; % Aqui establezco el numero de pliegues que se usaran para la validacion cruzada y las iteraciones para entrenar (Deben ser las mismas)
numClases=length(unique(Y)); %%% Se determina el número de clases del problema.
numMuestras=size(X, 1); % Aqui determino cuantas son las muestras de entrenamiento

switch input('Ingrese el numeral del modelo a elegir: ')   
    case 1      %%% modelo kNN %%%
        k = 6;
        modeloKNN(numClases, X, Y, k);
    case 2      %%% modelo ventana de Parzen %%%
        h = 0.9;
        modeloParzenWindow(numClases, X, Y, h);
    case 3      %%% modelo Redes Neuronales %%%
        epocas = 10;
        capas_neuronas = [20];
        modeloRNA(X, Y, epocas, capas_neuronas, numMuestras, rept);
    case 4      %%% modelo de Random forest %%%
        numArboles = 40;
        modeloRandomForest(rept, numClases, numMuestras, numArboles, X, Y);
    case 5      %%% modelo de SVM %%%
        boxConstraint = 1;
        gamma = 10;
        tipoK = 2;
        modeloSVM(rept, numClases, numMuestras, boxConstraint, gamma, tipoK, X, Y);
    case 6      %%% Correlacion y Fisher %%%
        alpha = 0.05;
        variableCorrelacionFisher(X, Y, alpha);   
    case 7      %%% SFS %%%
        variableSFS(X, Y, numMuestras, rept);
    case 8
        umbralPorcentajeDeVarianza = 85; % Como ultimo parametro del sistema se establece el porcentaje de varianza que definira cuantos componentes se deben incluir para el sistema
        variablePCA(X, Y, numMuestras, rept, umbralPorcentajeDeVarianza);    
    otherwise
        disp('Numero inválido')
end