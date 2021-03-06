function EEplot_2noise_parameter_recovery(p1, p2)
    plt_figure(4,2,[],[],[],1);
    plt_setparams('islegmark', false, 'dotsize', 15, 'fontsize_leg', 15, 'fontsize_face', 20, ...
        'linewidth', 2, 'islegbox', 0);
    fns = {'Infobonus_sub', 'bias_sub', 'NoiseRan_sub', 'NoiseDet_sub'};
    plt_setfig('color', {{'black'},{'black'},{'black'},{'black'},{'black'},{'black'},{'black'},{'black'}},...
        'ylabel', {'Fit A','Fit A','Fit b','Fit b', ...
        'Fit \sigma^{ran}', 'Fit \sigma^{ran}', 'Fit \sigma^{det}', 'Fit \sigma^{det}'}, ...
        'xlabel', {'Simulated A','Simulated A','Simulated b','Simulated b', ...
        'Simulated \sigma^{ran}', 'Simulated \sigma^{ran}', 'Simulated \sigma^{det}', 'Simulated \sigma^{det}'}, ...
        'title', {'H = 1', 'H = 6', '','','','','',''},...
        'legloc', 'NorthWest');
    for i = 1:4
        fn = fns{i};
        d1 = p1.(fn);
        d2 = p2.(fn);
        for hi = 1:2
            plt_new;
            str{i*2-2+hi} = plt_scatter(d1(hi,:)', d2(hi,:)', 'diag');
        end
    end
    plt_setfig('legend', strcat({'A', 'A','b','b',...
        '\sigma_{ran}','\sigma_{ran}','\sigma_{det}','\sigma_{det}'}, ...
        {', ',', ',', ',', ',', ',', ',', ',', '}, str));
    plt_update;
    plt_save('parameter_recovery');
end
