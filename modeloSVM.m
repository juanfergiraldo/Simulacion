function modeloSVM(rept, numClases, numMuestras, boxConstraint, gamma, tipoK, X, Y)
    
    EficienciaTest=zeros(1,rept);
    
    for fold=1:rept

        %%% Se hace la partición de las muestras %%%
        %%%      de entrenamiento y prueba       %%%
        
        rng('default');
        particion=cvpartition(numMuestras,'Kfold',rept);
        Xtrain=X(particion.training(fold),:);
        Xtest=X(particion.test(fold),:);
        Ytrain=Y(particion.training(fold),:);
        Ytest=Y(particion.test(fold));

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% Se normalizan los datos %%%

        [Xtrain,mu,sigma]=zscore(Xtrain);
        Xtest=(Xtest - repmat(mu,size(Xtest,1),1))./repmat(sigma,size(Xtest,1),1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%% Entrenamiento de los modelos. Se usa la metodologia One vs All. %%%
        
        %%%% Primero - Se separan las muestras y se entrena un modelo para cada clase%%%%
        
        Ytrain1 = Ytrain; % Se copian las etiquetas de entrenamiento en una primera particion de clase 1 contra todas las otras clases
        Ytrain1(Ytrain1~=1)=-1; % Las otras clases se les da la etiqueta -1.
        % Ytrain1(Ytrain1==1)=1;  %% Esta instrucción no es necesaria porque la clase 1 ya es de por si la clase 1.
        Modelo1 = entrenarSVM(Xtrain,Ytrain1,'c',boxConstraint,gamma,tipoK); % Se entrena el modelo.
        alpha1 = Modelo1.alpha;
        b1 = Modelo1.b;

        Ytrain2 = Ytrain; % De igual modo, se copian otra vez las etiquetas de entrenamiento en una segunda particion de clase 2 contra todas las otras clases
        Ytrain2(Ytrain2~=2)=-1; % Todas las clases diferentes de 2 se les nombrara -1
        Ytrain2(Ytrain2==2)=1; % Y todas las etiquetas de clase 2 se les llamara 1
        Modelo2 = entrenarSVM(Xtrain,Ytrain2,'c',boxConstraint,gamma,tipoK); % Se entrena el modelo.
        alpha2 = Modelo2.alpha;
        b2 = Modelo2.b;
        
        Ytrain3 = Ytrain; % De igual modo, se hace una tecera partición de clase 3 contra todas las otras clases
        Ytrain3(Ytrain3~=3)=-1; % Lo que no sea 3 se vuelve la clase -1. O sea, las demas.
        Ytrain3(Ytrain3==3)=1; % Lo que es 3 pasa a ser la clase 1.
        Modelo3 = entrenarSVM(Xtrain,Ytrain3,'c',boxConstraint,gamma,tipoK); % Se entrena el modelo.
        alpha3 = Modelo3.alpha;
        b3 = Modelo3.b;
        
        %%% Segundo - Se hacen las predicciones en base a cada uno de los clasificadores entrenados %%%
        
        % NOTA: El segundo retorno de la función simlssvm me devuelve el valor verdadero de la predicción o valor continuo.
        [Yest1,YestContinuo1]=testSVM(Modelo1,Xtest);
        [Yest2,YestContinuo2]=testSVM(Modelo2,Xtest);
        [Yest3,YestContinuo3]=testSVM(Modelo3,Xtest);
        
        if (tipoK == 1)
            K = kernel_matrix(Xtrain, 'lin_kernel', [], Xtest);
        elseif (tipoK == 2)
            K = kernel_matrix(Xtrain, 'RBF_kernel', gamma, Xtest);
        end
        % Tenga presente que kernel_matrix ya es el reultado de la matrix kernel ya multiplicada por los tn
        
        Ytemp1 = (alpha1'*K + b1)';
        Ytemp2 = (alpha2'*K + b2)';
        Ytemp3 = (alpha3'*K + b3)';
        
        %%% Tercero - Se hace la prediccion en base a cual es el mayor
        
        YestContinuo=[YestContinuo1,YestContinuo2,YestContinuo3];
        Ytemp=[Ytemp1,Ytemp2,Ytemp3];
        
        [~,Yest]=max(YestContinuo,[],2); % Estas Y estimadas salen del 2do retorno de la funcion simlssvm
        [~,Yesti]=max(Ytemp,[],2); % Estas Y estimadas salen del calculo manual de la funcion y(x) = sum(an*tn*k(x,xn)) + b
        
        % Nota: Revisamos y dio igual
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Cuarto - Se calculan los aciertos de la diagonal de la matriz de
        %               confusión para luego calcular la eficiencia.
        
        MatrizConfusion=zeros(numClases,numClases);
        for i=1:size(Xtest,1)
            MatrizConfusion(Yest(i),Ytest(i))=MatrizConfusion(Yest(i),Ytest(i)) + 1;
        end
        EficienciaTest(fold)=sum(diag(MatrizConfusion))/sum(sum(MatrizConfusion));
        
    end
    
    Eficiencia = mean(EficienciaTest);
    IC = std(EficienciaTest);
    Texto=['La eficiencia obtenida fue = ', num2str(Eficiencia),' +- ',num2str(IC)];
    disp(Texto);
end