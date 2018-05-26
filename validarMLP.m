function Yesti = validarMLP(Modelo, Xval)
    Yesti = sim(Modelo, Xval');
    Yesti = Yesti';
    %Yesti = round(Yesti);
end