function variableCorrelacionFisher(X, Y, alpha)
    X = zscore(X);
    [correlacion,p]= corrcoef([X,Y],'alpha',alpha);
    figure(1); plottable(correlacion); title('Matriz De Correlacion X');
    figure(2); imagesc(correlacion); colorbar;
    figure(3); plottable(p); title('Matriz De Valores P');
    indicesClase1 = find(Y == 1);
    indicesClase2 = find(Y == 2);
    indicesClase3 = find(Y == 3);

    mediaClase1 = mean(X(indicesClase1,:) ,1);
    mediaClase2 = mean(X(indicesClase2,:) ,1);
    mediaClase3 = mean(X(indicesClase3,:) ,1);        
    media = [mediaClase1; mediaClase2; mediaClase3];

    varClase1 = var(X(indicesClase1,:) ,1);
    varClase2 = var(X(indicesClase2,:) ,1);
    varClase3 = var(X(indicesClase3,:) ,1);

    varianza = [varClase1; varClase2; varClase3];

    coef = zeros(1,12);
    for i=1:2
        for j=1:2
            if (j ~= i)
                numerador = (media(i,:) - media(j,:)).^2;
                denominador = varianza(i,:) + varianza(j,:);
                coef = coef + (numerador./denominador);
            end
        end
    end
    Texto = ['Indice de Fisher: ', num2str(coef)];
    disp(Texto);

    coefN = coef./max(coef);
    Texto = ['Indice de Fisher Normalizado: ', num2str(coefN)];
    disp(Texto);

    figure(4)
    ejeX = 1:12;
    stem(ejeX, coefN);
    title('Indices Fisher Normalizados');
end