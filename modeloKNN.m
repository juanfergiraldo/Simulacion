function modeloKNN (X, Y, k)

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
    
    Eficiencia = (sum(Yesti==Ytest))/length(Ytest);
    Error = 1-Eficiencia;    
    disp(strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia)));
    disp(strcat('El error de clasificación en prueba es: ',{' '},num2str(Error)));
end