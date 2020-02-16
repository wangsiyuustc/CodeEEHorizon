function EEplot_2noise_hyperpriors(sp)
    names = {'Random noise - \sigma_{ran}','Random noise - \sigma_{ran}',...
        'Deterministic noise - \sigma_{det}','Deterministic noise - \sigma_{det}'};
    global plt_params
    plt_figure(2,2,[],[],[],1);
    plt_setparams('fontsize_leg', 20, 'linewidth', 2);
    plt_setfig('xlim', {[-1 22],[-3 12], [-1 22], [-3 12]}, 'ylim', [0 1.2], ...
        'ytick', [0:0.2:1.2], 'xtick',{0:4:20,-3:3:12,0:4:20,-3:3:12});
    color = {{'AZblue','AZred'},{'black'},{'AZblue','AZred'},{'black'}};
    fns = {'NoiseRan', 'NoiseDet'};
    stepsize = 0.02;
    xbins = [-10:stepsize:30];
    plt_setfig('color', color, 'legend', {{'h = 1','h = 6'},{'change'},{'h = 1','h = 6'},{'change'}},...
        'ylabel', {'posterior density','','posterior density',''}, ...
        'xlabel', {'','','noise standard deviation [points]', 'noise standard deviation [points]'}, ...
        'title', names);
    ymax = 1.2;
    for i = 1:2
        fn = fns{i};
        plt_new;
        for hi = 1:2
            td = sp.(fn);
            td = squeeze(td(:,:,hi));
            td = reshape(td, 1, []);
            tl = hist(td, xbins)/(length(td)*stepsize);
            plt_lineplot(tl, [], xbins);
        end
        hold on;
        plot([0 0],[0 ymax], '--k','LineWidth', plt_params.param_figsetting.linewidth/2);
        hold off;
        
        plt_new;
        td = sp.(['d' fn]);
        td = reshape(td, 1, []);
        tl = hist(td, xbins)/(length(td)*stepsize);
        plt_lineplot(tl, [], xbins);
        hold on;
        plot([0 0],[0 ymax], '--k','LineWidth', plt_params.param_figsetting.linewidth/2);
        hold off;
    end
    plt_update;
    plt_save('hyperprior');
end
