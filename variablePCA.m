function variablePCA(X, Y, numMuestras, rept, umbralPorcentajeDeVarianza)
    EficienciaTest=zeros(1,rept); % Se inicializa un vector columna en donde se guardara la eficiencia de los modelos en cada iteracion

    for fold=1:rept
        %%% Se hace la partición de las muestras %%%
        %%%      de entrenamiento y prueba       %%%
        rng('default');
        particion=cvpartition(numMuestras,'Kfold',rept);
        indices=particion.training(fold);
        Xtrain=X(particion.training(fold),:);
        Xtest=X(particion.test(fold),:);
        Ytrain=Y(particion.training(fold));
        Ytest=Y(particion.test(fold));

        %%% Se normalizan los datos %%%

        [Xtrain,mu,sigma] = zscore(Xtrain);
        Xtest = (Xtest - repmat(mu,size(Xtest,1),1))./repmat(sigma,size(Xtest,1),1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Ahora, se extraen los componentes principales, de modo que:

        % Se usa la función PCA de matalab para obtener los coeficientes de los componentes principales, los scores, las
        % varianzas de los componentes principales y el porcentaje de varianza explicada de estos. La sumatoria de este ultimo
        % retorno debe dar un total del 100%
        [coefCompPrincipales,scores,covarianzaEigenValores,~,porcentajeVarianzaExplicada,~] = pca(Xtrain);

        % A continuacion, se almacena el numero original de variables que tiene el sistema
        numVariables = length(covarianzaEigenValores);
        % También, se crea un variable con la cual se guardara el numero de componentes principales cuyos porcentajes de varianza sumada superan el porcentaje de varianza limite deseada
        numCompAdmitidos = 0;

        % Luego, se crean unas variables que almacenaran coordenadas de unas graficas que se dibujaran más adelante
        porcentajeVarianzaAcumulada = zeros(numVariables,1);
        puntosUmbral = ones(numVariables,1)*umbralPorcentajeDeVarianza;
        ejeComponentes = 1:numVariables;

        % PARA k que comienza en 1 HASTA el numero original de componentes HAGA
        for k=1:numVariables
            % Sume la varianza de los componentes 1 hasta k y guardelo en porcentajeVarianzaAcumulada(k)
            porcentajeVarianzaAcumulada(k) = sum(porcentajeVarianzaExplicada(1:k));

            %porcentajeVarianzaAcumulada(k) = sum(covarianzaEigenValores(1:k)) ./ sum(covarianzaEigenValores); % Otra forma de hacer la instruccion anterior pero los valores quedan entre 0 y 1.

            % SI la suma de los k componentes supera el limite de varianza deseado Y todavia no se ha establecido un numero de componentes a dejar para el sistema ENTONCES
            if (sum(porcentajeVarianzaExplicada(1:k)) >= umbralPorcentajeDeVarianza) && (numCompAdmitidos == 0)
                numCompAdmitidos = k; % Se guarda el numero de la iteracion puesto que este es el numero de componentes a tener en cuenta para el sistema
            end
        end

        % Una vez se calculan los varianzas acumuladas, se dibujan dos graficas:

        % La primera es una grafica de la magnitud de los EigenValores
        figure(1)
        stem(ejeComponentes, covarianzaEigenValores)
        xlim([1 numVariables]);
        title('Varianza de los componentes principales');
        xlabel('Componentes principales');
        ylabel('EigenValor');

        % La segunda grafica consiste en la acumulacion progresiva de la varianza a medida que se recorren los componentes y cual es el limite o umbral de varianza acumulada que se fijo para incluir el numero de componentes principales.
        figure(2)
        plot(ejeComponentes, porcentajeVarianzaAcumulada);
        xlim([1 numVariables]);
        hold on;
        plot(ejeComponentes, puntosUmbral,'r');
        title('Varianza acumulada de los componentes principales');
        xlabel('Componentes principales');
        ylabel('Varianza explicada (%)');
        hold off;

        % Ya determinado el numero de componentes con los que se quiere trabajar se estiman o proyectan los datos sobre dichos componentes principales para que el sistema trabaje con ellos
        aux = Xtrain*coefCompPrincipales;
        Xtrain = aux(:,1:numCompAdmitidos);

        aux = Xtest*coefCompPrincipales;
        Xtest = aux(:,1:numCompAdmitidos);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Se hace el entrenamiento del modelo
        NumArboles=15;
        Modelo = TreeBagger(NumArboles,Xtrain,Ytrain);

        % Se obtienen las predicciones del modelo con base al modelo
        % entrenado y las muestras separadas para la validacion del sistema
        Yest = predict(Modelo,Xtest);
        Yest = str2double(Yest);

        % Por ultimo, se calcula la eficiencia de esta iteracion
        EficienciaTest(fold) = sum(Ytest == Yest)/length(Ytest);
    end

    % Una vez sale del ciclo, se muestra cual fue la eficiencia promedio del sistema
    Eficiencia = mean(EficienciaTest);
    IC = std(EficienciaTest);
    Texto=['La eficiencia obtenida fue = ', num2str(Eficiencia),' +- ',num2str(IC)];
    disp(Texto);
end