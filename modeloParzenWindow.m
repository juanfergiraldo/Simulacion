function modeloKNN (X, Y, h)
    n = size(X,1);

    porcentaje = round(n*0.7);
    rng('default');
    ind = randperm(n);

    Xtrain = X(ind(1:porcentaje),:);
    Xtest = X(ind(porcentaje+1:end),:);
    Ytrain = Y(ind(1:porcentaje),:);
    Ytest = Y(ind(porcentaje+1:end),:);

    ind0=Ytrain==0;
    ind1=Ytrain==1;
    ind2=Ytrain==2;
    ind3=Ytrain==3;
    ind4=Ytrain==4;
    ind5=Ytrain==5;
    ind6=Ytrain==6;

    Xtrain0=Xtrain(ind0,:);
    Xtrain1=Xtrain(ind1,:);
    Xtrain2=Xtrain(ind2,:);
    Xtrain3=Xtrain(ind3,:);
    Xtrain4=Xtrain(ind4,:);
    Xtrain5=Xtrain(ind5,:);
    Xtrain6=Xtrain(ind6,:);

    funcion0=parzenWindow(Xtest,Xtrain0,Ytrain,h);
    funcion1=parzenWindow(Xtest,Xtrain1,Ytrain,h);
    funcion2=parzenWindow(Xtest,Xtrain2,Ytrain,h);
    funcion3=parzenWindow(Xtest,Xtrain3,Ytrain,h);
    funcion4=parzenWindow(Xtest,Xtrain4,Ytrain,h);
    funcion5=parzenWindow(Xtest,Xtrain5,Ytrain,h);
    funcion6=parzenWindow(Xtest,Xtrain6,Ytrain,h);

    funcion=[funcion0,funcion1,funcion2,funcion3,funcion4,funcion5,funcion6];

    [~,Yesti]=max(funcion,[],2);

    Eficiencia=(sum(Yesti==Ytest))/length(Ytest);
    Error=1-Eficiencia;

    disp(strcat('La eficiencia en prueba es: ',{' '},num2str(Eficiencia)));
    disp(strcat('El error de clasificación en prueba es: ',{' '},num2str(Error)));
end