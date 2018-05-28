function variableSFS(X, Y, numMuestras, rept, numArboles)

    EficienciaTest=zeros(1,rept); %Vector con la eficiencia de los modelos en cada iteración
    %Variables para el proceso de seleccion de caracteriticas
    %Si desea ver los resultados en cada iteracion use 'iter', pero si solo desea ver el resultado final use 'final'
    opciones = statset('display','iter');
    %Use 'forward' para busqueda hacia adelante o 'backward' para busqueda hacia atras
    sentido = 'forward'; 

    %Selección de caracteristicas:
    %en el primer return estara 0 o 1 si se incluye o no la caracteristica
    %en el segundo return se guarda el historial de las caracteristicas añadidas.
    [caracteristicasElegidas, ~] = sequentialfs(@funcionForest, X, Y,'direction', sentido, 'options', opciones);

    %Se dejan las caracteristicas a trabajar, antes del entrenamiento y validación del modelo.
    X = X(:, caracteristicasElegidas);

    %Entrenamiento y validacion del sistema
    for fold=1:rept
        %Se particionan las muestras de entrenamiento y prueba%
        rng('default');
        particion=cvpartition(numMuestras,'Kfold',rept);
        indices=particion.training(fold);
        Xtrain=X(particion.training(fold),:);
        Xtest=X(particion.test(fold),:);
        Ytrain=Y(particion.training(fold));
        Ytest=Y(particion.test(fold));  

        %Normalización de datos%
        [Xtrain,mu,sigma] = zscore(Xtrain);
        Xtest = (Xtest - repmat(mu,size(Xtest,1),1))./repmat(sigma,size(Xtest,1),1);

        % Estas instrucciones lo que hacen es que realizan la seleccion de caracteristicas en cada iteracion. Pero esto es muy demorado!!

% % % % %         [caracteristicasElegidas, proceso] = sequentialfs(@funcionForest,Xtrain,Ytrain,'direction',sentido,'options',opciones);
% % % % %         XReducidas = X(:, caracteristicasElegidas);
% % % % %         [NumMuestras,~] = size(XReducidas);
% % % % %         indices=randperm(NumMuestras);
% % % % %         porcionEntrenamiento = round(NumMuestras*0.7);
% % % % %         Xtrain=XReducidas (indices(1:porcionEntrenamiento),:);
% % % % %         Xtest=XReducidas(indices(porcionEntrenamiento+1:end),:);
% % % % %         Ytrain=Y(indices(1:porcionEntrenamiento),:);
% % % % %         Ytest=Y(indices(porcionEntrenamiento+1:end),:);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %Entrenamiento del modelo
        Modelo = TreeBagger(numArboles,Xtrain,Ytrain);

        %Se hayan las predicciones del modelo según el modelo
        %entrenado y las muestras separadas para la validacion
        Yest = predict(Modelo,Xtest);
        Yest = str2double(Yest);

        %Y se calcula la eficiencia de la iteracion
        EficienciaTest(fold) = sum(Ytest == Yest)/length(Ytest);
    end

    %Se muestra cuál fue la eficiencia promedio del sistema
    Eficiencia = mean(EficienciaTest);
    IC = std(EficienciaTest);
    Texto=['La eficiencia obtenida fue = ', num2str(Eficiencia),' +- ',num2str(IC)];
    disp(Texto);
end