function [Xbalanceada, Ybalanceada] = tecnicaSMOTE(X, Y, numClases, numMuestras)
    for i=1:numClases
        numClassDesbalanceada = sum(Y == i);
        if(numClassDesbalanceada < numMuestras*0.2)
            break;
        end
    end
    porcentajeSobreMuestreo = 0.2;
    numMuestrasNuevas = porcentajeSobreMuestreo*numClassDesbalanceada;
    indexClass3 = find(Y == 3);
    for i=1:numMuestrasNuevas
        random1 = randsample(indexClass3, 1);
        random2 = randsample(indexClass3, 1);
        muestra1 = X(random1,:);
        muestra2 = X(random2,:);
        media = muestra1 + muestra2;
        media = media/2;
        aux = muestra1 - media;
        aux = abs(aux) * (-1 + 2.*rand());
        nuevaMuestra = media + aux;
        X = [X;nuevaMuestra];
        Y = [Y;3];
    end
    Xbalanceada = X;
    Ybalanceada = Y;
end