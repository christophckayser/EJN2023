clear; close all

% Experiment 1 - The influence of SOA on the ventriloquism bias
% makes Figure 2

load('F:\CKDATA\Projects\projects\Multisensory_decoding\\Kayser.JVis\ND01_RelTiming\DataND01.mat','Data_all');
% the data are stored as follows:
% Data_all holds all single trial (AV-A pairs!) data, 
%   [biasve,biasvae,dva,dvasq,apos,aposA,vpos,SOA,resp,respA,ones(size(biasve))*s];
%   biasve: the ventriloquism bias on that AV trial
%   biasvae: the aftereffect on the immediate following A trial
%   dva: The spatial disrepancy on the AV trial
%   apos: The sound position in the AV trial
%   aposA: The sound position in the A trial
%   vpos: The position of the visual stimulus in the AV trial
%   SOA:  The SOA in the AV trial
%   resp: the actual response ni the AV trial
%   respA: the actual response in the A trial
%   subject number


Colorvector(1,:) = [0,80,160]/250;
Colorvector(2,:) = [40,180,250]/250; %
Colorvector(3,:) = [40,40,40]/250;
Colorvector(4,:) = [250,140,20]/250; %
Colorvector(5,:) = [160,40,0]/250; %

Label = {'AV-600','AV-300','AV0','AV+300','AV+600'};
nsub = 22;

% --------------------------------------------------------------------------------
% Display response error vs. DVA 
% --------------------------------------------------------------------------------
dvas = unique(Data_all(:,3));
figure(1);clf;
for soa =1:5
  for s=1:nsub
    for d=1:length(dvas)
      j = find( (Data_all(:,end)==s).*(Data_all(:,3)==dvas(d)).*(Data_all(:,8)==soa));
      VEbias(s,d) = mean(Data_all(j,1));
    end
  end
  
  subplot(1,2,1); hold on
  ckmeanline(dvas+(soa-2.5)*0.7,VEbias,2,Colorvector(soa,:))
  axis([-40 40 -15 15])
  line([-40 40],[0 0],'Color',[0.2 0.2 0.2]);
  text(20,-1.4*soa-4,Label{soa},'FontSize',11,'color',Colorvector(soa,:))
  xlabel('spatial discrepancy (V-A)[\circ]'); ylabel('judgement error [\circ]');
  set(gca,'XTick',[dvas],'XTickLabel',dvas,'YTick',[-15:5:15]);
end



% --------------------------------------------------------------------------------
% compute linear slopes
% --------------------------------------------------------------------------------
for soa =1:5
  for s=1:nsub
    j = find( (Data_all(:,end)==s).*(Data_all(:,8)==soa));
    
    dva = Data_all(j,3); % dva
    biasve = Data_all(j,1); % ve judgement error
  biasve= ck_zscore(biasve);
  dva= ck_zscore(dva);
    model = dva;
    model(:,2) = 1;
    b =regress(biasve,model);;
    BiasVE(s,soa) = b(1);
  end
end


subplot(1,2,2);
ckmeanplotcompact(BiasVE,2,1,[],Colorvector);
axis([0.5 5.5 -0.4 1]);
set(gca,'XTick',[1:5],'XTickLabel',Label,'YTick',[-0.4:0.2:1]);
ylabel('ventriloquism slope')
line([0 6],[0 0],'Color',[0.2 0.2 0.2]);


% --------------------------------------------------------------------------------
% individual contrasts against zero
% --------------------------------------------------------------------------------
for cond=1:5
  [bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,cond),0);
  Stat_each_VE(cond,:) = [bf10,stats.tstat,pValue];
end
% large BF are rounded
Stat_each_VE(:,1) = round(Stat_each_VE(:,1));
% add to figure
for cond=1:5
  subplot(1,2,2);
  tmp = Stat_each_VE(cond,1);
  if tmp>10000
    tmp = floor(log10(tmp));
    text(cond,0.95,sprintf('~1e%d',tmp),'FontSize',10);
  else
    text(cond,0.95,sprintf('%d',tmp),'FontSize',10);
  end
  
end

ckfigure_setall(gcf,'TickLength',[0.02 0.02]);
ckfigure_setall(gcf,'Box','Off');
ckfigure_setall(gcf,'FontSize',11);

set(gcf,'Position',[  146         341        1200         405]);
FigureDir = 'F:/CKDATA/Projects/projects/Multisensory_decoding/Kayser.JVis/paper';
snamef = sprintf('%s/Figure2.png',  FigureDir);
print('-dpng',snamef);
snamef = sprintf('%s/Figure2.jpg',  FigureDir);
print('-djpeg','-r300',snamef);


sname = 'F:/CKDATA/Projects/projects/Multisensory_decoding/Kayser.JVis/Exp1.mat';
save(sname,'BiasVE');



% --------------------------------------------------------------------------------
% Test an effect of SOA magnitude
% --------------------------------------------------------------------------------

Table =[];
for soa =1:5
  for s=1:nsub
    soamag = abs(soa-3);
    tmp = [BiasVE(s,soa),soamag,s];
    Table = cat(1,Table,tmp);
  end
end

Table = array2table(Table,'VariableNames',{'VE','Soa','Sub'});
Table.Sub = categorical(Table.Sub);
Table.Soa = categorical(Table.Soa);

% model without SoaData_avgSC
Model{1} = fitglme(Table, ...
    'VE ~ 1 +  (1 | Sub) ', ...
    'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'MPL',...
    'DummyVarCoding', 'reference', 'PLIterations', 500, 'InitPLIterations', 20);
% model with Soa
Model{2} = fitglme(Table, ...
    'VE ~ 1 + Soa +  (1 | Sub)  ', ...
    'Distribution', 'Normal', 'Link', 'Identity', 'FitMethod', 'MPL',...
    'DummyVarCoding', 'reference', 'PLIterations', 500, 'InitPLIterations', 20);

% each factor is sign. in full model
anova(Model{2})
 
BIC = [];
for m = 1 : length(Model)
    BIC = cat(2, BIC, Model{m}.ModelCriterion.BIC);
end
BIC = BIC-min(BIC);
% and the BF in favor of an effect (positive) or the Null (negative)
dBIC = BIC(1)-BIC(2); BF = exp(dBIC/2);
if dBIC<0, BF = -1./BF; end; 
fprintf('SOA influence for VE: dbic: %3.3f   BF %3.3f \n',dBIC,BF);


%% ----------------------------------------------------------------------
% pairwise comparisons using Bayesian t-tests
% ----------------------------------------------------------------------

% effects of J and V
lab = {'VE','VAE'};
xx=1;


fprintf('%s bias compared beteen timings\n',lab{xx});
% 1) 0 vs abs(300)
[bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,3),mean(BiasVE(:,[2,4]),2));
Stattest{xx}(1,:) = [bf10,stats.tstat,pValue];
fprintf('+0 vs 300 \t BF=%3.2f \t t=%1.2f \t p=%1.5f\n',Stattest{xx}(1,1),Stattest{xx}(1,2),Stattest{xx}(1,3));

% 2) +300 vs -300
[bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,2),BiasVE(:,4));
Stattest{xx}(2,:) = [bf10,stats.tstat,pValue];
fprintf('+300 vs -300 \t BF=%3.2f \t t=%1.2f \t p=%1.5f\n',Stattest{xx}(2,1),Stattest{xx}(2,2),Stattest{xx}(2,3));
% 3) +600 vs -600
[bf10,pValue,CI,stats] = bf.ttest(BiasVE(:,1),BiasVE(:,5));
Stattest{xx}(3,:) = [bf10,stats.tstat,pValue];
fprintf('+600 vs -600 \t BF=%3.2f \t t=%1.2f \t p=%1.45f\n',Stattest{xx}(3,1),Stattest{xx}(3,2),Stattest{xx}(3,3));
% 3) 300 vs 600
[bf10,pValue,CI,stats] = bf.ttest(mean(BiasVE(:,[2,4]),2),mean(BiasVE(:,[1,5]),2));
Stattest{xx}(4,:) = [bf10,stats.tstat,pValue];
fprintf('300 vs 600 \t BF=%3.2f \t t=%1.2f \t p=%1.5f\n',Stattest{xx}(4,1),Stattest{xx}(4,2),Stattest{xx}(4,3));






