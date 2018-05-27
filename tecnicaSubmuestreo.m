function [Xbalanceada, Ybalanceada] = tecnicaSubmuestreo(X, Y, claseMinoritaria, porcentajeSubMuestreo)
    numClassDesbalanceada = sum(Y == claseMinoritaria);
    numMuestrasRemover = numClassDesbalanceada*porcentajeSubMuestreo;
    for i=1:numMuestrasRemover        
        indexClass = find(Y == claseMinoritaria);
        indiceRandom = randsample(indexClass, 1);
        X(indiceRandom, :) = [];
        Y(indiceRandom, :) = [];
    end    
    Xbalanceada = X;
    Ybalanceada = Y;
end