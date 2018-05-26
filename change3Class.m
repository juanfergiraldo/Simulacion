function Ynueva = change3Class(Y)
    Ynueva(Y==1)=2;
    Ynueva(Y==2)=2;
    Ynueva(Y==3)=2;
    Ynueva(Y==4)=2;
    Ynueva(Y==5)=3;
    Ynueva(Y==6)=3;    
    Ynueva(Y==0)=1;
    Ynueva = Ynueva';
end