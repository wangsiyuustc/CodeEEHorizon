function EEbayes_analysis(bayes_data, outputdir, outname, bayes_params)
    % by siyu, under revision
    if ~exist('bayes_params')
        bayes_params.nchains = 4; % How Many Chains?
        bayes_params.nburnin = 2000; % How Many Burn-in Samples?
        bayes_params.nsamples = 4000; % How Many Recorded Samples?
    end
    openpool;
    md = bayes_data.modelname;
    mddir = '~/SIYUWANG/WilsonLab/Code/CodeHorizonTask';
    bayes_data = rmfield(bayes_data, 'modelname');
    msize = [];
    switch md

    end
    init0 = get_bayesinit(params, bayes_params.nchains, msize);
    [samples, stats, structArray, tictoc] = fit_matjags(modelfile, bayes_data, init0, bayes_params, params);
    closepool;
    save(fullfile(outputdir, [outname,'_bayesresult.mat']),'stats','tictoc');
    save(fullfile(outputdir, [outname,'_bayessamples.mat']),'samples','-v7.3');
end
function init0 = get_bayesinit(params, nchains, msize)
    if ~exist('msize') || isempty(msize)
        msize = [1, 1];
    end
    for i=1:nchains
        S = [];
        for j = 1:length(params)
            str = params{j};
            if ~isempty(strfind(str,'_p'))
                S.(str) = ones(msize);
            elseif ~isempty(strfind(str,'_n'))
                S.(str) = zeros(msize);
            end
        end
        init0(i) = S;
    end
end
function [samples, stats, structArray, tictoc] = fit_matjags(modelfile, datastruct, init0, bayes_params, params)
    doparallel = 1; % use parallelization
    fprintf( 'Running JAGS...\n' );
    tic
    [samples, stats, structArray] = matjags( ...
        datastruct, ...                     % Observed data
        modelfile, ...    % File that contains model definition
        init0, ...                          % Initial values for latent variables
        'doparallel' , doparallel, ...      % Parallelization flag
        'nchains', bayes_params.nchains,...              % Number of MCMC chains
        'nburnin', bayes_params.nburnin,...              % Number of burnin steps
        'nsamples', bayes_params.nsamples, ...           % Number of samples to extract
        'thin', 1, ...                      % Thinning parameter
        'monitorparams', params, ...     % List of latent variables to monitor
        'savejagsoutput' , 1 , ...          % Save command line output produced by JAGS?
        'verbosity' , 1 , ...               % 0=do not produce any output; 1=minimal text output; 2=maximum text output
        'cleanup' , 1 );                    % clean up of temporary files?
    tictoc = toc
end
function openpool()
    global poolobj;
    poolobj = gcp('nocreate'); % If no pool, do not create new one.
    if isempty(poolobj)
        poolsize = 0;
    else
        poolsize = poolobj.NumWorkers;
    end
    if poolsize == 0
        parpool;
    end
end
function closepool()
    global poolobj;
    delete(poolobj);
end
// case 'simplemodel'
//     modelfile = fullfile(mddir, 'HBayesModel_simple.txt');
//     params = {'kNoise_p','lamdaNoise_p','Noise',...
//         'A_n','dA_p','b_n','db_p','dNs',...
//         'As','bs'};
