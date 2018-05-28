function modeloKNN (numClases, X, Y, k)

    n = size(X,1);
    porcentaje = round(n*0.7);
    rng('default');
    ind = randperm(n);

    Xtrain = X(ind(1:porcentaje),:);
    Xtest = X(ind(porcentaje+1:end),:);

    Ytrain = Y(ind(1:porcentaje),:);
    Ytest = Y(ind(porcentaje+1:end),:);
    
    %%% Normalizaciï¿½n %%%

    [Xtrain,mu,sigma]=zscore(Xtrain);
    Xtest=normalizar(Xtest,mu,sigma);

    %%%%%%%%%%%%%%%%%%%%%

    Yesti = kNN(Xtest,Xtrain,Ytrain,k);
    
    MatrizConfusion = zeros(numClases, numClases);
    for i=1:size(Xtest,1)
        MatrizConfusion(Yesti(i),Ytest(i))= MatrizConfusion(Yesti(i),Ytest(i))+1;
    end
    PrecisionClase=[];
    EficienciaClase=[];
    for i=1:size(MatrizConfusion,1)
        PresicionClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(:,i));
        EficienciaClase(i)=MatrizConfusion(i,i)/sum(MatrizConfusion(i,:));
    end
    
    Eficiencia = (sum(Yesti==Ytest))/length(Ytest);
    Error = 1-Eficiencia;    
    disp(strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia)));
    disp(strcat('El error de clasificación en prueba es: ',{' '},num2str(Error)));
    disp(MatrizConfusion);
end