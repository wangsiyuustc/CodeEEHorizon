function EEbayes_analysis(bayes_data, outputdir, outname, bayes_params)
    defaultpath = '/Users/siyuwang/SIYUWANG/LabWilson/CodeEEHorizon/BayesModels';
    if ~exist('bayes_params')
        bayes_params.nchains = 4; % How Many Chains?
        bayes_params.nburnin = 2000; % How Many Burn-in Samples?
        bayes_params.nsamples = 4000; % How Many Recorded Samples?
    end
    openpool;
    md = bayes_data.modelname;
    mddir = '~/SIYUWANG/LabWilson/CodeEEHorizon';
    bayes_data = rmfield(bayes_data, 'modelname');
    switch md
%         case 'simplemodel'
%             modelfile = fullfile(mddir, 'HBayesModel_simple.txt');
%             params = {'kNoise_p','lamdaNoise_p','Noise',...
%                 'A_n','dA_p','b_n','db_p','dNs',...
%                 'As','bs'};  
        case {'2noisemodel','2noisemodelB','2noisemodelC','2noisemodelD'}
            params = {'NoiseDet_k_p','NoiseDet_lambda_p','NoiseDet',...
                'NoiseRan_k_p', 'NoiseRan_lambda_p','NoiseRan', ...
                'InfoBonus_mu_n','InfoBonus_sigma_p','bias_mu_n','bias_sigma_p', ...
                'NoiseRan_sub','NoiseDet_sub', 'Infobonus_sub','bias_sub',...
                'dInfoBonus','dbias','dNoiseRan','dNoiseDet','dNoiseRan_sub','dNoiseDet_sub',...
                'P'};
            init0 = get_bayesinit(params, bayes_params.nchains, 'simple');
            modelfile = ['model_2noise' md(12:end) '.txt'];
        case {'2noisemodelE'}
            params = {'NoiseRan_k_p', 'NoiseRan_lambda_p','NoiseRan', ...
                'InfoBonus_mu_n','InfoBonus_sigma_p','bias_mu_n','bias_sigma_p', ...
                'NoiseRan_sub','Infobonus_sub','bias_sub',...
                'dInfoBonus','dbias','dNoiseRan','dNoiseRan_sub',...
                'P'};
            init0 = get_bayesinit(params, bayes_params.nchains, 'simple');
            modelfile = ['model_2noiseE.txt'];
        case {'2noisemodelF'}
            params = {'NoiseDet_k_p','NoiseDet_lambda_p','NoiseDet',...
                'InfoBonus_mu_n','InfoBonus_sigma_p','bias_mu_n','bias_sigma_p', ...
                'NoiseDet_sub', 'Infobonus_sub','bias_sub',...
                'dInfoBonus','dbias','dNoiseDet','dNoiseDet_sub',...
                'P'};
            init0 = get_bayesinit(params, bayes_params.nchains, 'simple');
            modelfile = ['model_2noiseF.txt'];
            
    end
    [samples, stats, structArray, tictoc] = fit_matjags(fullfile(defaultpath, modelfile), bayes_data, init0, bayes_params, params);
    closepool;
    save(fullfile(outputdir, [outname,'_bayesresult.mat']),'stats','tictoc');
    save(fullfile(outputdir, [outname,'_bayessamples.mat']),'samples','-v7.3');
end
function init0 = get_bayesinit(params, nchains, option)
    switch option
        case 'simple'
            for i=1:nchains
                S = [];
                for j = 1:length(params)
                    str = params{j};
                    if ~isempty(strfind(str,'_p'))
                        S.(str) = ones([1 1]);
                    elseif ~isempty(strfind(str,'_n'))
                        S.(str) = zeros([1 1]);
                    end
                end
                init0(i) = S;
            end
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