function [Xbalanceada, Ybalanceada] = tecnicaSMOTE(X, Y, claseMayoritaria, porcentajeSobreMuestreo)
    numClassDesbalanceada = sum(Y == claseMayoritaria);
    numMuestrasNuevas = porcentajeSobreMuestreo*numClassDesbalanceada;
    indexClass = find(Y == claseMayoritaria);
    for i=1:numMuestrasNuevas
        random1 = randsample(indexClass, 1);
        random2 = randsample(indexClass, 1);
        muestra1 = X(random1,:);
        muestra2 = X(random2,:);
        media = muestra1 + muestra2;
        media = media/2;
        aux = muestra1 - media;
        aux = abs(aux) * (-1 + 2.*rand());
        nuevaMuestra = media + aux;
        X = [X;nuevaMuestra];
        Y = [Y;claseMayoritaria];
    end
    Xbalanceada = X;
    Ybalanceada = Y;
end