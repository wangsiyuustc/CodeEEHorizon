function EEplot_modelfree(gp, islm13, isreverse)
    if ~exist('isreverse')
        isreverse = 0;
    end
    if isreverse 
        ps = [2 1];
    else
        ps = [1 2];
    end
    if ~exist('islm13') || isempty(islm13)
        islm13 = 0;
    end
    plt_figure(1,2,[],[],[],1);
    if islm13
        legs = {{'[1 3]'},{'[2 2]','[1 3]'}};
        plt_setfig('legend', legs(ps));
    end
    ylabs = {'p(high info)','p(low mean)'};
    tts = {'directed exploration','random exploration'};
    plt_setfig('xlim', [0.5 2.5], 'xtick', [1 2], 'xticklabel', [1 6], ...
        'xlabel', 'horizon', 'ylabel', ylabs(ps), ...
        'title', tts(ps), 'legloc', 'NorthWest');
    for pi = ps
        switch pi
            case 1
                plt_new;
                plt_lineplot(gp.av_p_hi13, gp.ste_p_hi13);
                plt_sigstar_y(gp.av_p_hi13, 1:2, gp.pvalue_p_hi13, 'right');
            case 2
                plt_new;
                plt_lineplot(gp.av_p_lm22, gp.ste_p_lm22);
                plt_sigstar_y(gp.av_p_lm22, 1:2, gp.pvalue_p_lm22, 'right');
                if islm13
                    plt_lineplot(gp.av_p_lm13, gp.ste_p_lm13);
                    plt_sigstar_y(gp.av_p_lm13, 1:2, gp.pvalue_p_lm13, 'left');
                end
        end
    end
    plt_update;
    plt_addABCs;
    plt_save('modelfree');
end