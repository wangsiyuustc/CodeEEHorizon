function out = EEpreprocess_game_sub_repeatedgame(games)
    games = table_autofieldcombine(games);
    games.choice4 = games.choice(:, 1:4);
    games.reward4 = games.reward(:, 1:4);
    games.c5 = games.choice(:,5);
    out = ANALYSIS_repeatedgame(games, {'choice4','reward4'}, 'c5');
end