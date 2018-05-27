function Yesti = kNN(Xval,Xent,Yent,k)    
    %%% La función debe retornar el valor de predicción Yesti para cada una de 
    %%% las muestras en Xval. Por esa razón Yesti se inicializa como un vectores 
    %%% de ceros, de dimensión M.

    N=size(Xent,1);
    M=size(Xval,1);
    
    Yesti=zeros(M,1);
    dis=zeros(N,1);
        
    for j=1:M
        for i=1:N    
            dis(i) = sqrt(sum((Xval(j,:)-Xent(i,:)).^2));
        end   
        [B,I] = sort(dis);
        Yesti(j)=mode(Yent(I(1:k)));
    end
end