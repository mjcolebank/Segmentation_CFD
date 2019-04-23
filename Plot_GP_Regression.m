%% Plot the GP results from Mihaela
clear; clc; close all; 
addpath('from Mihaela/');
MIN_RES = 0.002.*0.1;
%%
load('GP_LengthValues2.mat');
L1sd_LB = lengthValues(:,1);
L1sd_UB = lengthValues(:,5);
L2sd_LB = lengthValues(:,2);
L2sd_UB = lengthValues(:,4);
Lmean    = lengthValues(:,3);
L = load('regression_L2.txt');
X_L = L(1,:).*0.1;
Y_L = L(2,:);
XL_space = X_gp.*0.1;%linspace(min(X_L),max(X_L),10000);

inbetween1 = [L1sd_LB' fliplr(L1sd_UB')];
inbetween2 = [L2sd_LB' fliplr(L2sd_UB')];
a = figure(1); 
% subplot(2,1,1); 
hold on;
f1 = fill([XL_space fliplr(XL_space)],inbetween1,[0.85 0.85 0.85]);
f1.EdgeColor = [0.85 0.85 0.85];
f2 = fill([XL_space fliplr(XL_space)],inbetween2,[0.6 0.6 0.6]);
f2.EdgeColor = [0.6 0.6 0.6];
h1 = plot(XL_space,Lmean,'k','LineWidth',4);
h2 = plot(X_L,Y_L,'k*','LineWidth',2,'MarkerSize',12);
h3 = plot(XL_space(1:100:end),MIN_RES./XL_space(1:100:end),'--','Color',[0.2 0.2 0.2],'LineWidth',2);
% xlabel('Length (cm)');
ylabel('Coefficient of Variation')
set(gca,'FontSize',40);
% a.Position = [300 740 600 1200];
grid on;
axis tight

load('GP_reg_var_L.mat');
a = figure(2);
% subplot(2,1,2);
hold on;
% inbetweenvarL = [fliplr(var_length(:,2)); var_length(:,3)];
% X_varL = [fliplr(var_length(:,1)); var_length(:,1)];
% f2 = fill(X_varL,inbetweenvarL,[0.6 0.6 0.6]);
% f2.EdgeColor = [0.6 0.6 0.6];
plot(var_length(:,1).*0.1,var_length(:,2).*0.1,'-.r','LineWidth',3);
plot(var_length(:,1).*0.1,var_length(:,3).*0.1,'-.r','LineWidth',3);
h1 = plot(var_length(:,1).*0.1, var_length(:,4).*0.1,'k','LineWidth',4);
set(gca,'FontSize',40);
ylabel('Variance (cm^2)');
xlabel('Length (cm)');
set(gca,'FontSize',40);
grid on;
axis tight



%%
load('GP_RadiusValues2.mat');
R1sd_LB = radiusValues(:,1);
R1sd_UB = radiusValues(:,5);
R2sd_LB = radiusValues(:,2);
R2sd_UB = radiusValues(:,4);
Rmean    = radiusValues(:,3);
R = load('regression_R2.txt');
X_R = R(:,1).*0.1;
Y_R = R(:,2);
XR_space = X_gp.*0.1;%linspace(min(X_R),max(X_R),10000);
XR_space2 = X_gp.*0.1;%linspace(0.06,max(X_R),10000);

inbetween1 = [R1sd_LB' fliplr(R1sd_UB')];
inbetween2 = [R2sd_LB' fliplr(R2sd_UB')];
a = figure(3); 
% subplot(2,1,1);
hold on;
f3 = fill([XR_space fliplr(XR_space)],inbetween1,[0.85 0.85 0.85]);
f3.EdgeColor = [0.85 0.85 0.85];
f4 = fill([XR_space fliplr(XR_space)],inbetween2,[0.6 0.6 0.6]);
f4.EdgeColor = [0.6 0.6 0.6];
plot(XR_space,Rmean,'k','LineWidth',4);
plot(X_R,Y_R,'k*','LineWidth',2,'MarkerSize',12)
plot(XR_space2(1:50:end),MIN_RES./XR_space2(1:50:end),'--','Color',[0.2 0.2 0.2],'LineWidth',2)
% xlabel('Radius (cm)');
% ylabel('Coefficient of Variation')
set(gca,'FontSize',40);
% a.Position = [300 740 600 1200];
grid on;
axis tight

load('GP_reg_var_R.mat');
a = figure(4);
% subplot(2,1,2);
hold on;
% inbetweenvarL = [fliplr(var_length(:,2)); var_length(:,3)];
% X_varL = [fliplr(var_length(:,1)); var_length(:,1)];
% f2 = fill(X_varL,inbetweenvarL,[0.6 0.6 0.6]);
% f2.EdgeColor = [0.6 0.6 0.6];
plot(var_rad(:,1).*0.1,var_rad(:,2).*0.1,'-.r','LineWidth',3);
plot(var_rad(:,1).*0.1,var_rad(:,3).*0.1,'-.r','LineWidth',3);
h1 = plot(var_rad(:,1).*0.1, var_rad(:,4).*0.1,'k','LineWidth',4);
set(gca,'FontSize',40);
% ylabel('Variance (cm^2)');
xlabel('Radius (cm)');
set(gca,'FontSize',40);
grid on;
axis tight


%% 
markersym = {'*b','^g','om','^r','ok','^c','<b','pc','k+'};
% for k=10%5:-1:3`
%     filename = strcat('Dimensions_',num2str(k),'gen.txt');
%     Dimensions = load(filename)
%     L = Dimensions(:,1).*10;
%     R = Dimensions(:,2).*10;
%     figure(1); hold on;
%     for i=1:length(L)
%         ID = find(L(i) <= XL_space, 1, 'first' );
%         xi = L(i);
%         if isempty(ID)
%             if L(i) < XL_space(1)
%                 yi = Lmean(1);
%             else
%                 yi = Lmean(end);
%             end
%         else
%             yi = Lmean(ID);
%         end
%         h4 = plot(xi,yi,markersym{k-2},'MarkerSize',12,'LineWidth',3);
%     end
% %     legend([f1 f2 h1 h2 h3 h4],{'\sigma','2\sigma','GP Mean','Coeff. Var. Data','Analytical Bound','Extrapolated Values'})
%     figure(2); hold on;
%     for i=1:length(R)
%         ID = find(R(i) <= XR_space, 1, 'first' );
%         xi = R(i);
%         if isempty(ID)
%             if R(i) < XR_space(1)
%                 yi = Rmean(1);
%             else
%                 yi = Rmean(end);
%             end
%         else
%             yi = Rmean(ID);
%         end
%         plot(xi,yi,markersym{k-2},'MarkerSize',12,'LineWidth',3);
%     end
% end
2

%% Plot new CV points
% ms = 1;
% [R_cv,L_cv] = get_dim_data;
% figure(1); hold on;
% plot(L_cv(:,1),L_cv(:,2),markersym{ms},'MarkerSize',12);
% figure(2); hold on;
% plot(R_cv(:,1),R_cv(:,2),markersym{ms},'MarkerSize',12);
% figure(3); hold on;
% plot([1:length(R_cv(:,1))],R_cv(:,1),markersym{ms},'MarkerSize',12);
% figure(4); hold on;
% plot([1:length(R_cv(:,2))],R_cv(:,2),markersym{ms},'MarkerSize',12);
%% Now plot variance
% r_var = (Rmean - R1sd_LB).^2;
% r_var_var = var(r_var);
% figure(3); hold on;
% plot(XR_space,r_var,'-.k','LineWidth',3);
% plot(XR_space,r_var + 2*r_var_var,'-.r','LineWidth',3);
% plot(XR_space,r_var - 2*r_var_var,'-.r','LineWidth',3);
