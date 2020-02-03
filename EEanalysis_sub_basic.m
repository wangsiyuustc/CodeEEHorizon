function out = EEanalysis_sub_basic(game)
    % by Siyu Wang (sywangr@email.arizona.edu)
    % 08/09/2019
    horizons = [5 10];
    c5 = game.choice(:,5);
    c5_lm = game.c_lm(:,5);
    c5_hi = game.c_hi(:,5);
    c5_rp = game.c_rp(:,5);
    out.n_game = size(game, 1);
    for hi = 1:length(horizons)
        idx_h = game.cond_horizon == horizons(hi);
        % basic directed/random, repeat
        VAR16_n_game = sum(idx_h);
        idx_22 = game.dI == 0;
        idx_13 = game.dI ~= 0;
        out.p_hi13(hi) = mean(c5_hi(idx_h & idx_13));
        out.p_lm13(hi) = nanmean(c5_lm(idx_h & idx_13));
        out.p_lm22(hi) = nanmean(c5_lm(idx_h & idx_22));
        out.p_lm(hi) = nanmean(c5_lm(idx_h));
        out.p_rp13(hi) = nanmean(c5_rp(idx_h & idx_13));
        out.p_rp22(hi) = nanmean(c5_rp(idx_h & idx_22));
        out.p_rp(hi) = nanmean(c5_rp(idx_h));
        VAR16_all_p_hi = nanmean(game.c_hi(idx_h, :),1);
        VAR16_all_p_lm = nanmean(game.c_lm(idx_h, :),1);
        VAR16_all_p_ac = nanmean(game.c_correct(idx_h, :),1);
        VAR16_all_p_rp = nanmean(game.c_rp(idx_h, :),1);
        VAR16_all_RT = nanmean(game.RT(idx_h,:),1);
        % repeat trial analysis
        if any(strcmp(fieldnames(game),'c_repeatagree2_c5'))
            out.p_inconsistent13(hi) = nanmean(game.c_repeatagree2_c5(idx_h & idx_13) == 0,1);
            out.p_inconsistent22(hi) = nanmean(game.c_repeatagree2_c5(idx_h & idx_22) == 0,1);
            out.p_inconsistent(hi) = nanmean(game.c_repeatagree2_c5(idx_h) == 0,1);
            % theory
            out.p_inconsistent13_randomtheory(hi) = 2 * out.p_lm13(hi) * (1-out.p_lm13(hi));
            out.p_inconsistent22_randomtheory(hi) = 2 * out.p_lm22(hi) * (1-out.p_lm22(hi));
            out.p_inconsistent_randomtheory(hi) = 2 * out.p_lm(hi) * (1-out.p_lm(hi));
        end
        % pattern analysis
%         for pi = 1:7
%             idx_p = game.choicepattern == pi-1;
%             VAR16_Pattern_p_hi(pi) = nanmean(c5_hi(idx_h & idx_p));
%             VAR16_Pattern_p_lm(pi) = nanmean(c5_lm(idx_h & idx_p));
%             VAR16_Pattern_p_rp(pi) = nanmean(c5_rp(idx_h & idx_p));
%         end
        % variables with different names for long/short horizons
        Vars = who;
        Vars = Vars(cellfun(@(x)length(strfind(x, 'VAR16')), Vars) == 1);
        for vi = 1:length(Vars)
            tVar = Vars{vi};
            out.([tVar(7:end) '_h' num2str(hi*5-4)]) = eval(tVar);
        end
    end
    out.p_di = out.p_hi13(:,2) - out.p_hi13(:,1);
    out.p_ra = out.p_lm22(:,2) - out.p_lm22(:,1);
    out.p_ac = nanmean(game.c_correct(:,10));
    n_c10_correct = nansum(game.c_correct(:,10));
    % ac chance, needs check
    nmax = 200;
    pas = abs(pascal(nmax + 1,1));
    w = repmat(1./sum(pas, 2), 1, nmax + 1); 
    p = w.*pas;
    cump = cumsum(p,2);
    out.pvalue_ac = 1-cump(out.n_game_h6+1, max(n_c10_correct,1));
end
