clear; 

% Figure 3 - Ventriloquism biases for Experiments 2 / 3

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


% --------------------------------------------------------------------------------
% Exp 2
% --------------------------------------------------------------------------------
Colorvector(1,:) = [250,140,20]/250; %;
Colorvector(2,:) = [40,180,250]/250; %
Colorvector(3,:) = [0,80,160]/250;
Colorvector(4,:) = [160,40,0]/250; %


CondOrder = [1,3,5,8]; % we show only data for conditions wiht auditory judgements
nsub = 20;

load('Exp2.mat');
load('DataND02.mat','Data_all');
figure

Label{1} = 'AV0';
Label{2} = 'AV0';
Label{3} = 'AV+300';
Label{4} = 'AV+300';
Label{5} = 'AV0V+300';
Label{6} =  'AV0V+300';
Label{7} = 'AV0V+300';
Label{8} = 'AV0cont';

% -----------------------------------
% judgement errors
dvas = unique(Data_all{1}(:,3));

for cond=1:4
  usecond = CondOrder(cond);
  VEbias = VEerror{usecond};
  off = floor(cond/3);
  y = cond; if y>2 y=y-2; end
  
  subplot(2,3,1+off); hold on
  ckmeanline(dvas+(y-2.5)*0.5,VEbias,2,Colorvector(cond,:))
  axis([-12 12 -8 8])
  line([-10 10],[0 0],'Color',[0.2 0.2 0.2]);
  text(2,-1.2*y-3,Label{usecond},'FontSize',10,'color',Colorvector(cond,:))
  xlabel('spatial discrepancy (V-A)[\circ]'); ylabel('judgement error [\circ]');
  set(gca,'XTick',[dvas],'XTickLabel',dvas,'YTick',[-8:2:8]);
end

% -----------------------------------
%  slopes 
ax = subplot(2,3,3); hold on
ckmeanplotcompact(BiasVE(:,CondOrder),2,1,[],Colorvector);
ylabel('slope');
line([0.5 4.5],[0 0],'Color',[0.2 0.2 0.2]);
axis([0.5 4.5 -0.3 1.2]); hold on
set(gca,'YTick',[-0.3:0.2:1.2],'XTick',[])

% add Bayesfactors
BF = round(Stat_each_VE(CondOrder));
for cond=1:4
  usecond = CondOrder(cond);
  h =text(cond-0.2,-0.4,Label{usecond},'FontSize',10,'Color',Colorvector(cond,:));
    set(h,'Rotation',-30);

    tmp = BF(cond);
  if tmp>10000
    tmp = floor(log10(tmp));
    text(cond,1.1,sprintf('1e%d',tmp),'FontSize',10);
  else
    text(cond,1.1,sprintf('%d',tmp),'FontSize',10);
  end
end
set(gca,'YTick',[-0.3:0.3:1.2],'XTick',[])

subplot(2,3,1);
title('one visual')

subplot(2,3,2);
title('two visual')
subplot(2,3,3);
title('ventriloquism slope')

pp = get(subplot(2,3,3),'Position');
pp(3) = pp(3)*1.15;
set(subplot(2,3,3),'Position',pp);




% --------------------------------------------------------------------------------
% Exp 3
% --------------------------------------------------------------------------------
clear Bias* Data_all VEbias VAEbias
nsub = 24;

Colorvector(1,:) = [250,140,20]/250; %;
Colorvector(2,:) = [40,180,250]/250; %
Colorvector(3,:) = [40,250,180]/250; %
Colorvector(4,:) = [0,80,160]/250;
Colorvector(5,:) = [160,40,0]/250; %
Colorvector(6,:) = [20,160,80]/250; %
load('Exp3.mat');
load('DataND03.mat','Data_all');


% Conditions :
Label{1} = 'AV0';
Label{2} = 'AV+300';
Label{3} = 'AV-300';
Label{4} = 'AV0V+300';
Label{5} = 'AV-300V0';
Label{6} = 'AV-300V+300';


% -----------------------------------
% judgement errors

dvas = unique(Data_all{1}(:,3));
for cond=1:6
  VEbias = VEerror{cond};

  off = floor(cond/4);
  c = subplot(2,3,4+off); hold on
  y = cond; if y>3 y=y-3; end
  ckmeanline(dvas+(y-2.5)*0.5,VEbias,2,Colorvector(cond,:))
  axis([-12 12 -8 8])
  line([-10 10],[0 0],'Color',[0.2 0.2 0.2]);
  text(2,-1.2*y-3,Label{cond},'FontSize',10,'color',Colorvector(cond,:))
  xlabel('spatial discrepancy (V-A)[\circ]'); ylabel('judgement error [\circ]');
  set(gca,'XTick',[dvas],'XTickLabel',dvas,'YTick',[-8:2:8]);

end


% -----------------------------------
%  slopes 
CondOrder = [3,1,2,5,6,4];

% add Bayesfactors
BF = round(Stat_each_VE);

ax = subplot(2,3,6);
ckmeanplotcompact(BiasVE(:,CondOrder),2,1,[],Colorvector(CondOrder,:));
ylabel('slope');
line([0.5 7],[0 0],'Color',[0.2 0.2 0.2]);
axis([0.5 7 -0.3 1.2]); hold on
set(gca,'XTickLabelRotation',45)
for cond=1:6
  h = text(cond-0.2,-0.4,Label{CondOrder(cond)},'FontSize',10,'Color',Colorvector(CondOrder(cond),:));
  set(h,'Rotation',-30);
    
  tmp = BF(CondOrder(cond));
  if tmp>10000
    tmp = floor(log10(tmp));
    text(cond,1.1,sprintf('1e%d',tmp),'FontSize',10);
  else
    text(cond,1.1,sprintf('%d',tmp),'FontSize',10);
  end
end
set(gca,'YTick',[-0.3:0.3:1.2],'XTick',[])


pp = get(subplot(2,3,6),'Position');
pp(3) = pp(3)*1.15;
set(subplot(2,3,6),'Position',pp);


% -------------------------------------------------------------
% figure tuning

subplot(2,3,1)
text(-16,9.5,'A','FontSize',16,'Fontweight','Bold');
subplot(2,3,4)
text(-16,9.5,'B','FontSize',16,'Fontweight','Bold');


ckfigure_setall(gcf,'TickLength',[0.02 0.02]);
ckfigure_setall(gcf,'Box','Off');
ckfigure_setall(gcf,'FontSize',11);

