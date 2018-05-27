function Ynueva = change3Class(Y)
    Ynueva(Y==1)=1;
    Ynueva(Y==2)=1;
    Ynueva(Y==3)=1;
    Ynueva(Y==4)=1;
    Ynueva(Y==5)=2;
    Ynueva(Y==6)=2;
    Ynueva = Ynueva';
end