function Modelo = entrenarForest(numArboles,X,Y)

    Modelo = TreeBagger(numArboles,X,Y); % Aqui se entrena el random forest con los datos de entrenamiento

end