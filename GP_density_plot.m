% Galaxy data
addpath('GPstuff-4.7/');
%%
figure(1); clf;
r=load('density_R.txt');
hold on; %subplot(1,2,1); 
[F,XI,U]=ksdensity(r);
xt=XI';
% subplot(1,2,2);
lgpdens(r,xt);
plot(XI,F,'r');
axis tight
title('Galaxy data')
% true density is unknown
drawnow

%%
figure(2); clf;
l=load('density_L.txt');
hold on; %subplot(1,2,1); 
[F,XI,U]=ksdensity(l);
xt=XI';
% subplot(1,2,2);
lgpdens(l,xt);
plot(XI,F,'r');
axis tight
title('Galaxy data')
% true density is unknown
drawnow