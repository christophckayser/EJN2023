
clear;  


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


%% --------------------------------------------------------

load('DataND04.mat','Data_all','Label');
load('Exp4.mat');

Label{1} = 'AV0';
Label{2} = 'AV+300';
Label{3} = 'AV-300';
Label{4} = 'AV0V+300';
Label{5} = 'AV-300V0';
Label{6} = 'AV-300V+300';
nsub = 21;

Colorvector(1,:) = [250,140,20]/250; %;
Colorvector(2,:) = [40,180,250]/250; %
Colorvector(3,:) = [40,250,180]/250; %
Colorvector(4,:) = [0,80,160]/250;
Colorvector(5,:) = [160,40,0]/250; %
Colorvector(6,:) = [20,160,80]/250; %

figure(8);clf;
% -------------------------------------------------------------------------------
% figure with biases

dvas = unique(Data_all{1}(:,3));
for cond=1:6
  VEbias = VEerror{cond};
  off = floor(cond/4);
  y = cond; if y>3 y=y-3; end

  subplot(2,2,off+1); hold on
  ckmeanline(dvas+(y-2.5)*0.5,VEbias,2,Colorvector(cond,:))
  text(5,-1*y-3,Label{cond},'FontSize',10,'color',Colorvector(cond,:))
  xlabel('spatial discrepancy (V-A)[\circ]'); ylabel('judgement error [\circ]');
  set(gca,'XTick',[dvas],'XTickLabel',dvas,'YTick',[-8:2:8]);
  axis([-12 12 -8 8])
  line([-10 10],[0 0],'Color',[0.2 0.2 0.2]);
  
end

subplot(2,2,1);
title('one visual')
text(-15,9,'A','FontSize',16,'Fontweight','Bold');

subplot(2,2,2);
title('two visual')

% dataformat
% tmp = [biasve,biasvae,dva,apos,aposA,resp,respA,8 vspos,9 vdpos,10 vapos,ones(size(biasve))*s];


%% ---------------------------------------------------------
% figure 
Colorvector(1,:) = [250,140,20]/250; %;
Colorvector(2,:) = [40,180,250]/250; %
Colorvector(3,:) = [40,250,180]/250; %
Colorvector(4,:) = [0,80,160]/250;
Colorvector(5,:) = [160,40,0]/250; %
Colorvector(6,:) = [20,160,80]/250; %
clear Label

Label{1} = 'AV0V+300';
Label{2} = 'AV-300V0';
Label{3} = 'AV-300V+300';


subplot(2,2,3); hold on
usecol(1,:) = [1,2];
usecol(2,:) = [1,3];
usecol(3,:) = [3,2];
for pair=1:3
  tmp = sq(BetaVE3(:,pair,[1,2]));
  ckmeanplotcompact(tmp,2,1,[],Colorvector(usecol(pair,:),:),[1,2]+(pair-1)*3);
end
line([0.5 9],[0 0],'Color',[0.2 0.2 0.2]);
set(gca,'XTick',[1,4,7]+0.5)
axis([0.5 9 -0.2 1])
a = get(gca,'Position');
a(3) = a(3)-0.1;
set(gca,'Position',a);

xp = [1.5,4.5,7.5]-0.5;
for k=1:3
  h = text(xp(k),-0.25,Label{k},'FontSize',9,'Color',[0 0 0]);
  set(h,'Rotation',-30);
end

ylabel('ventriloquism slope');

text(-0.9,1.05,'B','FontSize',16,'Fontweight','Bold');
term = {'V-300','V0','V+300'}; ord = [3,1,2]'
for cond=1:3
  text(cond*2,0.95,term{cond},'FontSize',11,'color',Colorvector(ord(cond),:))
end


% all conditions
clear tmp;
tmp{1} = [BetaVE1(:,3),sq(BetaVE3(:,2,2)),sq(BetaVE3(:,3,1))]; % Va
tmp{2} = [BetaVE1(:,1),sq(BetaVE3(:,1,1)),sq(BetaVE3(:,2,1))]; % Vs
tmp{3} = [BetaVE1(:,2),sq(BetaVE3(:,1,2)),sq(BetaVE3(:,3,2))]; % Vd
cols = [3,1,2];
subplot(2,2,4); hold on
for pair=1:3
  ckmeanplotcompact(tmp{pair},2,1,[],Colorvector(cols(pair),:),[1:3]+(pair-1)*4);
end
axis([0.5 12 -0.2 1])
ylabel('ventriloquism slope');
line([0.5 12],[0 0],'Color',[0.2 0.2 0.2]);
a = get(gca,'Position');
a(1) = a(1)-0.1;
a(3) = a(3)+0.1;
set(gca,'Position',a);
set(gca,'XTick',[1,2,3,5,6,7,9,10,11])
str ={'AV-300','AV-300V0','AV-300V+300','AV0','AV0V+300','AV-300V0','AV+300','AV0V+300','AV-300V+300','AV+300'};
xp = [1,2,3,5,6,7,9,10,11];
for k=1:9
  h = text(xp(k),-0.25,str{k},'FontSize',9,'Color',[0 0 0]);
  set(h,'Rotation',-30);

end

for cond=1:3
  h = text(cond*3,0.95,term{cond},'FontSize',11,'color',Colorvector(ord(cond),:))
end

text(-0.9,1.05,'C','FontSize',16,'Fontweight','Bold');


ckfigure_setall(gcf,'TickLength',[0.02 0.02]);
ckfigure_setall(gcf,'Box','Off');
ckfigure_setall(gcf,'FontSize',11);

