

clear; close all;
% figure 5

% analyze standard deviations of judgement errors. Are they bimodal?
% we compute the SD and calculate the quality of fit of a single gaussian.
% if the data are distributed differentially for trials with one visual and
% two visual stimuli, the quality of fit should differ

% --------------------------------------------------------------------------------------------
% Experiment 2
fprintf('------------------- Exp 2\n')
load('DataND02.mat','Data_all');
useCond = [1,3,5,8]; % JA only
nsub = 20;
for cond=1:4
  for s=1:nsub % participant
    j = find( (Data_all{useCond(cond)}(:,end)==s));
    biasve = Data_all{useCond(cond)}(j,1);
    StdVE{1}(s,cond) = std(biasve);
    % KS statistics vs. normal
    [H,P,KSSTAT] = kstest( (biasve-mean(biasve))./std(biasve) );
    KS{1}(s,cond) = KSSTAT;
  end
end
k = [max(KS{1}(:,[1:2]),[],2) max(KS{1}(:,[1:2]+2),[],2)];
m = mean(k);ss = sem(k);
fprintf('KS statistics %1.3f +- %1.3f  vs %1.3f +- %1.3f \n',m(1),ss(1),m(2),ss(2));



% --------------------------------------------------------------------------------------------
% Experiment 3
fprintf('------------------- Exp 3\n')
load('DataND03.mat','Data_all');
nsub = 24;
for cond=1:6
  for s=1:nsub % participant
    j = find( (Data_all{cond}(:,end)==s));
    biasve = Data_all{cond}(j,1);
    StdVE{2}(s,cond) = std(biasve);
   % KS statistics vs. normal
    [H,P,KSSTAT] = kstest( (biasve-mean(biasve))./std(biasve) );
    KS{2}(s,cond) = KSSTAT;   
  end
end
k = [max(KS{2}(:,[1:3]),[],2) max(KS{2}(:,[1:3]+3),[],2)];
m = mean(k);ss = sem(k);
fprintf('KS statistics %1.3f +- %1.3f  vs %1.3f +- %1.3f \n',m(1),ss(1),m(2),ss(2));

% --------------------------------------------------------------------------------------------
% Experiment 4
fprintf('------------------- Exp 4\n')

load('DataND04.mat','Data_all','Label');
nsub = 21;
for cond=1:6
  for s=1:nsub % participant
    j = find( (Data_all{cond}(:,end)==s));
    biasve = Data_all{cond}(j,1);
    StdVE{3}(s,cond) = std(biasve);
    [H,P,KSSTAT] = kstest( (biasve-mean(biasve))./std(biasve) );
    KS{3}(s,cond) = KSSTAT;
  end
end
% ks stats aross conditions
k = [max(KS{3}(:,[1:3]),[],2) max(KS{3}(:,[1:3]+3),[],2)];
m = mean(k);ss = sem(k);
fprintf('KS statistics %1.3f +- %1.3f  vs %1.3f +- %1.3f \n',m(1),ss(1),m(2),ss(2));

%% figures

figure(10);clf;

Colorvector(1,:) = [0.2 0.2 0.2]; %;
Colorvector(2,:) = [0.6 0.6 0.6]; %

hold on;
usen= [2,2,3];
for k=1:3
  SD =  [mean(StdVE{k}(:,[1:usen(k)]),2) mean(StdVE{k}(:,[1:usen(k)]+usen(k)),2)];
  ckmeanplotcompact(SD,2,1,[],Colorvector,[1:2]+(k-1)*2.5);
  axis([0.5 8 4 12]);
  ylabel('[SD]');
  set(gca,'XTick',[1,2,3.5,4.5,6,7],'XTickLabel',{'1Vis','2Vis'})
  text(1.5+(k-1)*2.5,12,sprintf('Exp %d',k+1));

  [bf10,pValue,CI,stats] =  bf.ttest(SD(:,1),SD(:,2));
  fprintf('t=%1.4f, p=%1.4f, BF=%3.2f \n',stats.tstat,pValue,bf10);


end




ckfigure_setall(gcf,'TickLength',[0.02 0.02]);
ckfigure_setall(gcf,'Box','Off');
ckfigure_setall(gcf,'FontSize',11);

