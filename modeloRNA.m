function modeloRNA (X, Y, epochs, capas_neuronas, N)

    Yfinal = zeros(3,size(Y,1));
    for k = 1:length(Y)
        switch Y(k)
            case 1
                Yfinal(1,k)=1;
            case 2
                Yfinal(2,k)=1;
            case 3
                Yfinal(3,k)=1;
        end
    end
    Yfinal = Yfinal';
    %%% Se hace la partición entre los conjuntos de entrenamiento y prueba.
    %%% Esta partición se hace forma aletoria %%%

    porcentaje=round(N*0.7);
    rng('default');
    ind=randperm(N); %%% Se seleccionan los indices de forma aleatoria
    
    Errors = zeros(10,1);
    
    for k = 1:10

        Xtrain=X(ind(1:porcentaje),:);
        Xtest=X(ind(porcentaje+1:end),:);

        Ytrain=Yfinal(ind(1:porcentaje),:);
        Ytest=Yfinal(ind(porcentaje+1:end),:);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Normalización %%%

        [Xtrain,mu,sigma]=zscore(Xtrain);
        [Xtest,mu,sigma]=zscore(Xtest);

        %%%%%%%%%%%%%%%%%%%%%

        %%% Se crea y se entrena el modelo  %%%
        
        model = entrenarMLP(Xtrain, Ytrain, capas_neuronas, epochs);
        
        %%% Se aplica la regresión usando ANN-MLP  %%%

        Yesti = validarMLP(model, Xtest);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Se encuentra el error en la clasificación %%%
        error = perform(model, Ytest, Yesti);
        %classes = vec2ind(Yesti);
        Errors(k,1) = error;        
        
    end
    
    Texto=strcat('El Error en clasificación es: ', num2str(mean(Errors)));
    disp(Texto);
    
end