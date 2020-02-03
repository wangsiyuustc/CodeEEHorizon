function [sub, preprocessedData, idxsub] = EEanalysis_default(filename, opt_sub, opt_game_sublevel, opt_analysis_sub, savedir, saveprefix)
    disp(sprintf('ANALYZING file - %s', filename));
    rawdata = readtable(filename, 'Delimiter', ",");
    preprocessedData = EEpreprocess_game_basic(rawdata);
    idxsub = ANALYSIS_subjectselection(preprocessedData, opt_sub);
    EEpreprocess_game_subjectdependent = @(games, idxsub, options)ANALYSIS_game_subjectdependent(games, idxsub, options, {'repeatedgame'}, {'EEpreprocess_game_sub_repeatedgame'});
    preprocessedData = EEpreprocess_game_subjectdependent(preprocessedData, idxsub, opt_game_sublevel);
    EEanalysis_subjectlevel_main = @(games, idxsub, options)ANALYSIS_sub(games, idxsub, options, {'basic','MLE'},{'EEanalysis_sub_basic','EEanalysis_sub_MLEbasic'});
    sub = EEanalysis_subjectlevel_main(preprocessedData, idxsub, opt_analysis_sub);
    if exist('savedir')
        if ~exist('saveprefix')
            saveprefix = '';
        end
        [~,tfilename] = fileparts(filename);
        if contains(tfilename, 'RAW_')
            tfilename = tfilename(5:end);
        end
        if contains(tfilename, 'DATA_')
            tfilename = tfilename(6:end);
        end
        if contains(tfilename, '.csv')
            tfilename = filename(1:end-4);
        end
        if ~isempty(saveprefix)
            tfilename = [saveprefix, '_', tfilename];
        end
        writetable(sub, fullfile(savedir, ['SUB_', tfilename, '.csv']));
        writetable(preprocessedData, fullfile(savedir, ['processedData_', tfilename, '.csv']));
        save(fullfile(savedir, ['idxsub_' tfilename]), 'idxsub');
    end
end
