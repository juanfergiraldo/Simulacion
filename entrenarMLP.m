function net = entrenarMLP(Xent, Yent, capas_neuronas, ep)
        
    net = fitnet(capas_neuronas);

    net.trainParam.epochs = ep;

    net = train(net, Xent', Yent');
    
end