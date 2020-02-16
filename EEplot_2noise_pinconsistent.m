function EEplot_2noise_pinconsistent(gp)
    plt_figure(1,2,[],[],[],1);
    plt_setfig('color', {{'AZcactus', 'AZblue', 'AZred'}, {'AZsand', 'AZblue', 'AZred'}});
    plt_setfig('xlabel', 'horizon', 'ylabel', {'p(inconsistent)','p(inconsistent)'}, ...
        'title', {'[1 3] condition','[2 2] condition'}, 'legloc', {'SouthWest','SouthWest'}, ...
        'legend', {'behavioral data','deterministic noise only','random noise only'}, ...
        'xlim', [0.5 2.5], 'xtick', [1 2], 'xticklabel', [1 6]);
    plt_new;
    plt_lineplot(gp.av_p_inconsistent13, gp.ste_p_inconsistent13);
    plt_lineplot([0 0], [0 0]);
    plt_lineplot(gp.av_p_inconsistent13_randomtheory, gp.ste_p_inconsistent13_randomtheory);
    plt_sigstar_y(gp.av_p_inconsistent13, 1:2, gp.pvalue_p_inconsistent13, 'right');
    plt_new;
    plt_lineplot(gp.av_p_inconsistent22, gp.ste_p_inconsistent22);
    plt_lineplot([0 0], [0 0]);
    plt_lineplot(gp.av_p_inconsistent22_randomtheory, gp.ste_p_inconsistent22_randomtheory);
    plt_sigstar_y(gp.av_p_inconsistent22, 1:2, gp.pvalue_p_inconsistent22, 'right');
    plt_update;
    plt_addABCs;
    plt_save('2noise');
end