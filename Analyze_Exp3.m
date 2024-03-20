clear;


% analysis of ND03 data. 
% we analyze both the ventriloquism bias and the aftereffect bias


load('DataND03.mat','Data_all');
nsub = 24;

% Conditions :
Label{1} = 'AVs';
Label{2} = 'AVd';
Label{3} = 'AVa';
Label{4} = 'AVsVd';
Label{5} = 'AVsVa';
Label{6} = 'AVaVd';

%   tmp = [biasve,biasvae,dva1,dva2,apos,aposA,ones(size(biasve))*s];
dvas = unique(Data_all{1}(:,3));


% --------------------------------------------------------------------------------
% compute judgement errors , also those not analyzed later
% --------------------------------------------------------------------------------
for cond=1:6

  for s=1:nsub % participant
    for d=1:length(dvas)
      j = find( (Data_all{cond}(:,end)==s).*(Data_all{cond}(:,3)==dvas(d)));
      VEerror{cond}(s,d) = mean(Data_all{cond}(j,1));
      VAEerror{cond}(s,d) = mean(Data_all{cond}(j,2));
    end
  end
end
% --------------------------------------------------------------------------------
% compute linear slopes
% --------------------------------------------------------------------------------
for cond=1:6
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
    b = regress(biasve,model);;
    BiasVE(s,cond) = b(1);
    b = regress(biasvae,model);;
    BiasVAE(s,cond) = b(1);
    StdVE(s,cond) = std(biasve);

  end
end


% --------------------------------------------------------------------------------
% compute individual contrasts against zero
% --------------------------------------------------------------------------------
for cond=1:6
  [bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,cond),0);
  Stat_each_VE(cond,:) = [bf10,stats.tstat,pValue];
  
  [bf10,pValue,CI,stats] = bf.ttest(BiasVAE(:,cond),0);
  Stat_each_VAE(cond,:) = [bf10,stats.tstat,pValue];
end

sname = 'Exp3.mat';
save(sname,'BiasVE','BiasVAE','Label','Stat_each_VE','Stat_each_VAE','VEerror','VAEerror','StdVE');




% --------------------------------------------------------------------------------
% statistics in Table 2 and text
% --------------------------------------------------------------------------------


fprintf('---------------------------------------------------\n')
fprintf('for Table 2\n')
fprintf('AV0V300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,4),BiasVE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,4),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)
  
fprintf('AV0V-300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,5),BiasVE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V-300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,5),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-3000V+300 vs AV-300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,6),BiasVAE(:,3));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-3000V+300 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,6),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)


fprintf('\nSOA effects \n')
fprintf('AV0 vs AV+-300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,1),mean(BiasVE(:,[2,3]),2));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-300 vs AV+300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVE(:,2),BiasVE(:,3));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)



% --------------------------------------------------------------------------------
% statistics in Table4 
% --------------------------------------------------------------------------------

fprintf('---------------------------------------------------\n')
fprintf('VAE for Table 4\n')


fprintf('AV0V300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,4),BiasVAE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,4),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)
  
fprintf('AV0V-300 vs AV0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,5),BiasVAE(:,1));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV0V-300 vs 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,5),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-3000V+300 vs AV-300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,6),BiasVAE(:,3));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-3000V+300 0 ');
[bf10,pValue,CI,stats] =  bf.ttest(BiasVAE(:,6),0);
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)



return

Label{1} = 'AVs';
Label{2} = 'AVd';
Label{3} = 'AVa';
Label{4} = 'AVsVd';
Label{5} = 'AVsVa';
Label{6} = 'AVaVd';

