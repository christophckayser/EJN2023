clear; 

% analyze data from task ND04 with two visual stimuli

load('DataND04.mat','Data_all','Label');
nsub = 21;

% Conditions :
Label{1} = 'AVs';
Label{2} = 'AVd';
Label{3} = 'AVa';
Label{4} = 'AVsVd';
Label{5} = 'AVsVa';
Label{6} = 'AVaVd';

%   tmp = [biasve,biasvae,dva,apos,aposA,resp,respA,vspos,vdpos,vapos,ones(size(biasve))*s];

% --------------------------------------------------------------------------------
% compute judgement errors , also those not analyzed later
% --------------------------------------------------------------------------------
dvas = unique(Data_all{1}(:,3));
for cond=1:6
  for s=1:nsub % participant
    for d=1:length(dvas)
      j = find( (Data_all{cond}(:,end)==s).*(Data_all{cond}(:,3)==dvas(d)));
      VEerror{cond}(s,d) = mean(Data_all{cond}(j,1));
      VAEerror{cond}(s,d) = mean(Data_all{cond}(j,2));
      Ntrials(cond,s,d) = length(j);
    end
  end
end

% --------------------------------------------------------------------------------
% compute linear slopes
% --------------------------------------------------------------------------------
% --------------------------------------------------------
% slope for AV trials
Pairings{1} = [1,8]; % AV condition, DVA
Pairings{2} = [2,9]; % AV condition, DVA
Pairings{3} = [3,10]; % AV condition, DVA


for cond=1:3
  for s=1:nsub
    j = find( (Data_all{cond}(:,end)==s));

    apos = Data_all{cond}(j,4);
    v1 = Data_all{cond}(j,Pairings{cond}(2));
    dv1 = v1-apos;
    vebias = Data_all{cond}(j,1);

    vebias= ck_zscore(vebias);
    dv1= ck_zscore(dv1);
    model = dv1;
    model(:,2)=1;
    beta = regress(vebias,model);
    BetaVE1(s,cond,:) = beta(1);
  end
end

% --------------------------------------------------------
% slope for AVV trials
% AVsVd
Pairings{1} = [4,8,9]; % AV condition, DVA1, DVA2
% AVsVa
Pairings{2} = [5,8,10]; 
% AVaVd
Pairings{3} = [6,10,9]; 


for pair=1:3
  cond = Pairings{pair}(1);
  for s=1:nsub
    j = find( (Data_all{cond}(:,end)==s));

    apos= Data_all{cond}(j,4);
    vebias = Data_all{cond}(j,1);
    v1 = Data_all{cond}(j,Pairings{pair}(2));
    v2 = Data_all{cond}(j,Pairings{pair}(3));
    dv1 = v1-apos;
    dv2 = v2-apos;

    dva = [dv1,dv2];
    dva= ck_zscore(dva);

    vebias= ck_zscore(vebias);
   
    model = dva;
    model(:,3)=1;
    beta = regress(vebias,model);
    BetaVE2(s,pair,:) = beta(1:2);

    model = dva;
    model(:,3) = dva(:,1).*dva(:,2);
    model(:,4)=1;

    BetaVE3(s,pair,:) = beta(1:3);
  end
end


% VE STD
for cond=1:6
  for s=1:nsub % participant
    j = find( (Data_all{cond}(:,end)==s));
    biasve = Data_all{cond}(j,1);
    StdVE(s,cond) = std(biasve);
  end
end



sname = 'Exp4.mat';
save(sname,'BetaVE2','BetaVE1','Label','VEerror','VAEerror','StdVE','BetaVE3');

% -------------------------------------------------Data_avgC-------------------------------
% statistics in Table 2 and text
% --------------------------------------------------------------------------------


fprintf('---------------------------------------------------\n')

fprintf('\nSOA effects \n')
fprintf('AV0 vs AV+-300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BetaVE1(:,1),mean(BetaVE1(:,[2,3]),2));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)

fprintf('AV-300 vs AV+300 ');
[bf10,pValue,CI,stats] =  bf.ttest(BetaVE1(:,2),BetaVE1(:,3));
fprintf('t=%1.2f, p=%1.5f, BF=%3.1f \n',stats.tstat,pValue,bf10)





fprintf('---------------------------------------------------\n')

fprintf('Interaction terms\n');
for c=1:3
  [bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,c,3),0);
  fprintf('inter \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
end


fprintf('---------------------------------------------------\n')


fprintf('weights compared within each condition \n');
% weight of each visual stimulus comapred between pairs
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,1,1),BetaVE3(:,1,2));
fprintf('AVsVd \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);

[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,2,1),BetaVE3(:,2,2));
fprintf('AVsVa \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);

[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,3,1),BetaVE3(:,3,2));
fprintf('AVaVd \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
fprintf('\n')




fprintf('---------------------------------------------------\n')
fprintf('weights compared between conditions \n');
% weight of each visual stimulus comapred between pairs
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,1,1),BetaVE3(:,2,1));
fprintf('V0 in AV0V+ and AV-V0 \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,1,1),BetaVE1(:,1));
fprintf('V0 in AV0V+ and AV0 \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,2,1),BetaVE1(:,1));
fprintf('V0 in AV-V0 and AV0 \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);

[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,1,2),BetaVE3(:,3,2));
fprintf('V+300 in AV0V+ and AV-V+ \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,1,2),BetaVE1(:,2));
fprintf('V+300 in AV0V+ and AV+ \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,3,2),BetaVE1(:,2));
fprintf('V+300 in AV-V+ and AV+ \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);

[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,2,2),BetaVE3(:,3,1));
fprintf('V-300 in AV-V0 and AV-V+ \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,2,2),BetaVE1(:,3));
fprintf('V-300 in AV-V0 and AV- \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);
[bf10,pValue,CI,stats] = bf.ttest(BetaVE3(:,3,1),BetaVE1(:,3));
fprintf('V-300 in AV-V+ and AV- \t BF=%3.2f \t t=%1.2f \t p=%1.4f\n',bf10,stats.tstat,pValue);






return


