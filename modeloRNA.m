function modeloRNA (X, Y, epochs, capas_neuronas, numMuestras, rept)

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
    %%% Se hace la partici�n entre los conjuntos de entrenamiento y prueba.
    %%% Esta partici�n se hace forma aletoria %%%

    %porcentaje=round(N*0.7);
    %rng('default');
    %ind=randperm(N); %%% Se seleccionan los indices de forma aleatoria
    
    %Errors = zeros(10,1);
    
    EficienciaTest = zeros(1,rept);
    
    for fold = 1:rept
        
        rng('default');
        particion=cvpartition(numMuestras,'Kfold',rept);
        Xtrain=X(particion.training(fold),:);
        Xtest=X(particion.test(fold),:);
        Ytrain=Yfinal(particion.training(fold),:);
        Ytest=Yfinal(particion.test(fold));


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Normalizaci�n %%%

        [Xtrain,mu,sigma]=zscore(Xtrain);
        [Xtest,mu,sigma]=zscore(Xtest);

        %%%%%%%%%%%%%%%%%%%%%

        %%% Se crea y se entrena el modelo  %%%
        
        model = entrenarMLP(Xtrain, Ytrain, capas_neuronas, epochs);
        
        %%% Se aplica la regresi�n usando ANN-MLP  %%%

        Yesti = validarMLP(model, Xtest);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Se encuentra el error en la clasificaci�n %%%
        error = perform(model, Ytest, Yesti);
        %classes = vec2ind(Yesti);
        EficienciaTest(fold,1) = 1 - error;        
        
    end
    
    Texto=strcat('La eficiencia en clasificaci�n es: ', num2str(mean(EficienciaTest)));
    disp(Texto);
    
end