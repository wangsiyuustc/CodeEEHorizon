function EEplot_2noise_modelcomparison(gp, simugp)
    plt_figure(6,4,[],[],[],1);
    plt_setparams('fontsize_face', 20, 'fontsize_leg', 15, 'linewidth', 2);
    plt_setfig('color', {'AZred', 'AZblue'});
    plt_setfig('xlabel', [repmat({''},1,20), repmat({'horizon'},1,4)], ...
        'ylabel', [{'model A'} repmat({''},1,3), {'model B'} repmat({''},1,3), ...
        {'model C'} repmat({''},1,3), {'model D'} repmat({''},1,3), ...
        {'model E'} repmat({''},1,3), {'model F'} repmat({''},1,3)], ...
        'title', [{'p(high info)', 'p(low mean)', 'p(inconsistent), [1 3]', 'p(inconsistent), [2 2]', ...
        } repmat({''}, 1, 20)], 'xlim', [0.5 2.5], 'xtick', [1 2], 'xticklabel', [1 6], ...
        'legend', [repmat({{'',''}},1,23), {{'data', 'model'}}], ...
        'legloc', 'SouthEast', ...
        'ylim', repmat({[0.35 0.65],[0 0.35],[0 0.35],[0 0.35]},1,6), ...
        'ytick', repmat({[0.4:0.1:0.6],[0:.1:0.3],[0:.1:0.3],[0:.1:0.3]},1,6));
    for mi = 1:6
        tgp = simugp.(['model' char(64+mi)]);
        plt_new;
        plt_lineplot(gp.av_p_hi13, gp.ste_p_hi13);
        plt_lineplot(tgp.av_p_hi13, tgp.ste_p_hi13);
        
        plt_new;
        plt_lineplot(gp.av_p_lm22, gp.ste_p_lm22);
        plt_lineplot(tgp.av_p_lm22, tgp.ste_p_lm22);
        
        plt_new;
        plt_lineplot(gp.av_p_inconsistent13, gp.ste_p_inconsistent13);
        plt_lineplot(tgp.av_p_inconsistent13, tgp.ste_p_inconsistent13);
        
        plt_new;
        plt_lineplot(gp.av_p_inconsistent22, gp.ste_p_inconsistent22);
        plt_lineplot(tgp.av_p_inconsistent22, tgp.ste_p_inconsistent22);
    end
    plt_update;
    plt_save('2noise_6modelcomparison');
end