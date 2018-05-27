function modeloKNN (X, Y, h)
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
    
    ind1=Ytrain==1;
    ind2=Ytrain==2;
    ind3=Ytrain==3;

    Xtrain1=Xtrain(ind1,:);
    Xtrain2=Xtrain(ind2,:);
    Xtrain3=Xtrain(ind3,:);

    funcion1=parzenWindow(Xtest,Xtrain1,Ytrain,h);
    funcion2=parzenWindow(Xtest,Xtrain2,Ytrain,h);
    funcion3=parzenWindow(Xtest,Xtrain3,Ytrain,h);

    funcion=[funcion1,funcion2,funcion3];

    [~,Yesti]=max(funcion,[],2);

    Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
    Error=1-Eficiencia;

    disp(strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia)));
    disp(strcat('El error de clasificación en prueba es: ',{' '},num2str(Error)));
end