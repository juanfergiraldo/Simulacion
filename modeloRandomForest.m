function modeloRandomForest(rept, numClases, numMuestras, numArboles, X, Y)
      
    for fold=1:rept

        %%% Se hace la partici?n de las muestras %%%
        %%%      de entrenamiento y prueba       %%%
        
        rng('default');
        particion=cvpartition(numMuestras,'Kfold',rept);
        indices=particion.training(fold);
        Xtrain=X(particion.training(fold),:);
        Xtest=X(particion.test(fold),:);
        Ytrain=Y(particion.training(fold));
        Ytest=Y(particion.test(fold));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%% Se normalizan los datos %%%

        [XtrainNormal,mu,sigma] = zscore(Xtrain);
        XtestNormal = (Xtest - repmat(mu,size(Xtest,1),1))./repmat(sigma,size(Xtest,1),1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Entrenamiento de los modelos. Recuerde que es un modelo por cada clase. %%%

        Modelo=entrenarForest(numArboles,XtrainNormal,Ytrain);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Validación de los modelos. %%%
        
        Yest=testForest(Modelo,XtestNormal);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        MatrizConfusion = zeros(numClases,numClases);   
        for i=1:size(Xtest,1)
           MatrizConfusion(Yest(i),Ytest(i)) = MatrizConfusion(Yest(i),Ytest(i)) + 1;
        end
        EficienciaTest(fold) = sum(diag(MatrizConfusion))/sum(sum(MatrizConfusion));
        PrecisionClase=[];
        EficienciaClase=[];
        for i=1:size(MatrizConfusion,1)
            PresicionClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(:,i));
            EficienciaClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(i,:));
        end
    end
    
    Eficiencia = mean(EficienciaTest);
    IC = std(EficienciaTest);
    ICE = std(EficienciaClase);
    ICP = std(PresicionClase);
    
    Texto=['La eficiencia obtenida fue = ', num2str(Eficiencia),' +- ',num2str(IC)];
    disp(Texto);
    disp(MatrizConfusion);
    disp(strcat('La eficiencia por clase obtenida fue: ', num2str(EficienciaClase), ' +-', num2str(ICE)));
    disp(strcat('La precision por clase obtenida fue: ', num2str(PresicionClase), ' +-', num2str(ICP)));    
end