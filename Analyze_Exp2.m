clear; 


% analysis of ND02 data. We focus only on trials with A judgements here,
% ignoring those with V judgements
% we analyze both the ventriloquism bias and the aftereffect bias

% Label{1} = 'AVs - jA';
% Label{2} = 'AVs - jVs';
% Label{3} = 'AVd - jA';
% Label{4} = 'AVd - jVd';
% Label{5} = 'AVsVd - jA';
% Label{6} =  'AVsVd - jVs';
% Label{7} = 'AVsVd - jVd';
% Label{8} = 'AVsVd0 - jA';

Label{1} = 'AVs';
Label{2} = 'AVs';
Label{3} = 'AVd';
Label{4} = 'AVd';
Label{5} = 'AVsVd';
Label{6} =  'AVsVd';
Label{7} = 'AVsVd';
Label{8} = 'AVsVd0';


load('DataND02.mat','Data_all');

nsub = 20;
dvas = unique(Data_all{1}(:,3));


% --------------------------------------------------------------------------------
% compute judgement errors , also those not analyzed later
% --------------------------------------------------------------------------------
for cond=1:8

  for s=1:nsub % participant
    for d=1:length(dvas)
      j = find( (Data_all{cond}(:,end)==s).*(Data_all{cond}(:,3)==dvas(d)));
      VEerror{cond}(s,d) = mean(Data_all{cond}(j,1));
      VAEerror{cond}(s,d) = mean(Data_all{cond}(j,2));
    end
  end
end


% --------------------------------------------------------------------------------
% compute linear slopes for all conditions, also those not analyzed later
% --------------------------------------------------------------------------------
for cond=1:8
  for s=1:nsub % participant
    j = find( (Data_all{cond}(:,end)==s));
    dva = Data_all{cond}(j,3);
    biasve = Data_all{cond}(j,1);
    biasvae = Data_all{cond}(j,2);

    biasve= ck_zscore(biasve);
    biasvae= ck_zscore(biasvae);
    dva= ck_zscore(dva);

    model = dva;
    model(:,2) = 1;
    b =regress(biasve,model);
    BiasVE(s,cond) = b(1);
    Offsets(s,cond) = b(2);
    b = regress(biasvae,model);;
    BiasVAE(s,cond) = b(1);
  end
end

% invert sign of bias strength for jV trials, for sake of consistency.
BiasVE(:,[2,4,6,7]) = - BiasVE(:,[2,4,6,7]);



% --------------------------------------------------------------------------------
% compute individual contrasts against zero
% --------------------------------------------------------------------------------
for cond=1:8
  [bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,cond),0);
  Stat_each_VE(cond,:) = [bf10,stats.tstat,pValue];
  
  [bf10,pValue,CI,stats] = bf.ttest(BiasVAE(:,cond),0);
  Stat_each_VAE(cond,:) = [bf10,stats.tstat,pValue];
end

sname = 'Exp2.mat';
% save(sname,'BiasVE','BiasVAE','Label','Stat_each_VE','Stat_each_VAE','VEerror','VAEerror');





% --------------------------------------------------------------------------------
% statistics in Table 2 and text
% --------------------------------------------------------------------------------

fprintf('---------------------------------------------------\n')
fprintf('VE for Table 2\n')
fprintf('AV0V300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,5),BiasVE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,5),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)
  
fprintf('\nAVcontrol vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,8),BiasVE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AVcontrol vs AV0V300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,8),BiasVE(:,5));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('\nSOA effects \n')
fprintf('AV0 vs AV300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,1),BiasVE(:,3));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)



% --------------------------------------------------------------------------------
% statistics in Table4 
% --------------------------------------------------------------------------------

fprintf('---------------------------------------------------\n')
fprintf('VAE for Table 4\n')
fprintf('AV0V300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,5),BiasVAE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,5),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)


return




