function out = EEanalysis_sub_MLEbasic(game)
    X0.additionalX = [0];
    LB.additionalX = [-100];
    UB.additionalX = [100];
    for hi = 1:2
        idxh = game.cond_horizon == hi*5;
        xfit = MLEfit_choicecurve((game.choice(idxh,5) == 2) + 0, game.dR(idxh,4), game.dI(idxh), 1, [0 0], X0, LB, UB, 1, 0, 'off');
        out.MLE_noise(hi) = xfit.noise;
        out.MLE_infobonus(hi) = xfit.additionalX;
        out.MLE_bias(hi) = xfit.bias;
    end
    out.MLE_dnoise = out.MLE_noise(:,2) - out.MLE_noise(:,1);
    out.MLE_dinfobonus = out.MLE_infobonus(:,2) - out.MLE_infobonus(:,1);
    out.MLE_dbias = out.MLE_bias(:,2) - out.MLE_bias(:,1);
end
