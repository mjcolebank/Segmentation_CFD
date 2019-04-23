%% Try to fit a Statistical model to the results
% Define the different models
clear; close all; clc;
exp_f = @(x,pars) pars(1).*exp(pars(2).*x);
rat_f = @(x,pars)pars(1)./(x + pars(2));
power_f = @(x,pars) pars(1).*x.^pars(2);
poly1 = @(x,pars) pars(1) + pars(2).*x;
poly2 = @(x,pars) pars(1) + pars(2).*x + pars(3).*x.^2;
poly3 = @(x,pars) pars(1) + pars(2).*x + pars(3).*x.^2 + pars(4).*x.^3;

[R,L] = get_dim_data;
%% LEave out 15
% id = 1:19;
% id = id(id ~= 15);
% R = R(id,:);
% L = L(id,:);

%% Or add upper bound

% R(end,1) = 0;
% R(end,2) = 1;
% R(end,3) = nan;
% Define the minimum resolution
MIN_RES = 0.002;
%% Do OLS fit and find parameter confidence intervals

%% Call all the different models for the function AND the residual

log_X_flag = 0;
log_Y_flag = 0;
recip_X_flag = 0;
recip_Y_flag = 0;
res_flag = -1;

%%
if log_X_flag == 1
    X = log(R(:,1));
    rspace = linspace(min(X).*1.1,max(X).*0.9,100);
else
    X = R(:,1);
    rspace = linspace(0.1,0.5,100);
end

if log_Y_flag == 1
    Y = log(R(:,2));
else
    Y = R(:,2);
end

if recip_X_flag == 1
    X = 1./R(:,1);
end

if recip_Y_flag == 1
    Y = 1./R(:,2);
end
%%


%%
%%
for i=1:6
    [f1,res1,par_opt] = call_regression_function(i,X,Y);
    for j=1:6
        if res_flag == 0
            % Normal residuals
            [f2,res2] = call_regression_function(j,X,res1);
        elseif res_flag == -1
            % Squared residuals
            [f2,res2] = call_regression_function(j,X,res1.^2);
        else
            % Log residuals
            [f2,res2] = call_regression_function(j,X,log(res1));
        end
        % Now plot f(x), f(res) and the residual
        figure(10*i+j);
        
        subplot(1,3,1); hold on;
        plot(X,Y,'k*');
        plot(rspace,f1(rspace),'r','LineWidth',3);
        plot(rspace,MIN_RES./rspace,'--k','LineWidth',2);
        set(gca,'FontSize',20);
        var_exp = sum((f1(X)-mean(Y)).^2);
        var_unexp = sum((Y-f1(X)).^2);
        var_tot = var_exp + var_unexp;
        R2 = 1 - var_unexp./var_tot;
        title(sprintf('R^2:   %f',R2));
        if res_flag == 0
            subplot(1,3,2); hold on;
            plot(X,res1,'k*');
            plot(rspace,f2(rspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f2(X)-mean(res1)).^2);
            var_unexp = sum((res2-f2(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
            
        elseif res_flag == -1
            subplot(1,3,2); hold on;
            plot(X,res1.^2,'k*');
            plot(rspace,f2(rspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f2(X)-mean(res1.^2)).^2);
            var_unexp = sum((res1.^2-f2(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
            
        else
            subplot(1,3,2); hold on;
            plot(X,log(res1),'k*');
            plot(rspace,f2(rspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f1(X)-mean(log(res1))).^2);
            var_unexp = sum((log(res1)-f1(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
        end
        
        subplot(1,3,3); hold on;
        plot(X,res2,'r*');
        plot(rspace,zeros(100,1),'--k','LineWidth',3);
        set(gca,'FontSize',20);
        
        
        %         subplot(1,4,4); hold on;
        %         plot(R(:,1),f1(R(:,2)),'r*');
        %         plot(rspace,rspace,'--r','LineWidth',3);
        %         set(gca,'FontSize',20);
%         set(gcf, 'Position', [200 800 1400 1000]);
    end
end
n = length(X);

%% Step 2a): Now fit the residuals using a smoothing spline
% [f_weights,res_new,par_opt] = call_regression_function(3,X,res1.^2);%fit(X,res1.^2,'smooth');
% figure; hold on;
% plot(X,res1.^2,'ko');
% plot(rspace,f_weights(rspace),'r');
% xlim([min(X) max(X)])
% weights_new = f_weights(X);
% tol = 10^(-8);
% dif_weights = 10^6;
% % Step 3: Have a loop?
% figure; hold on;
% plot(X,Y,'k*','LineWidth',2.5);
% plot(rspace,f1(rspace),'LineWidth',2);
% exitflag = 0;
% R2_new = 0;
% while dif_weights > tol && exitflag ~=1
%     [f1_wls,res_new,par_opt] = call_weighted_regression_function(3,X,Y,weights_new);
%     [f_weights,res,par_opt] = call_regression_function(3,X,res_new.^2);%fit(X,res1.^2,'smooth');
%     weights_old = weights_new;
%     weights_new = f_weights(X);
%     half_weights_new = weights_new.^(1/2);
%     dif_weights = sum( (weights_new - weights_old).^2);
% %     var_exp = sum(weights_new'*(f1_wls(X)-mean(half_weights_new'*Y)).^2);
%     var_unexp = sum((half_weights_new.*(Y-f1_wls(X))).^2);
%     var_tot = sum((half_weights_new.*Y - mean(half_weights_new.*Y)).^2);%var_exp + var_unexp;
%     R2 = 1 - var_unexp./var_tot;
%     R2_old = R2_new;
%     R2_new = R2;
%     if R2_new > R2_old
%         model_use = {f1_wls,res_new,par_opt};
%         mean_errors = mean(res_new)
%         plot(rspace,f1_wls(rspace),'LineWidth',2);
%         R2_new
%     else
%         R2_old
%         exitflag = 1;
%     end
% end
%% Step 2b) OR try to model the weights as the squared mean.
weights = f1(X).^-2;
figure; hold on;
plot(X,res1.^2,'ko');
plot(X,weights,'r');
xlim([min(X) max(X)])
weights_new = weights./sum(weights);
tol = 10^(-10);
dif_weights = 10^6;
 var_exp = sum((f1(X)-mean(Y)).^2);
 var_unexp = sum((Y-f1(X)).^2);
 var_tot = var_exp + var_unexp;
 R2 = 1 - var_unexp./var_tot
 mean_errors = mean(res1)
    
figure; hold on;
plot(X,Y,'k*','LineWidth',2.5);
plot(rspace,f1(rspace),'LineWidth',2);
% Step 3b:
R2_old = 0;
R2_new = R2;
exitflag = 0;
while dif_weights > tol && exitflag ~=1
    [f1_wls,res_new,par_opt] = call_weighted_regression_function(1,X,Y,weights_new);
    weights_old = weights_new;
    weights_new = (f1_wls(X).^-2)./sum(f1_wls(X).^-2);%(f1_wls(X).^2)./sum(f1_wls(X).^2);
    half_weights_new = weights_new.^(-1/2);
    dif_weights = sum( (weights_new - weights_old).^2);
%     var_exp = sum(weights_new'*(f1_wls(X)-mean(half_weights_new'*Y)).^2);
    var_unexp = sum((half_weights_new.*(Y-f1_wls(X))).^2);
    var_tot = sum((half_weights_new.*Y - mean(half_weights_new.*Y)).^2);%var_exp + var_unexp;
    R2 = 1 - var_unexp./var_tot;
    R2_old = R2_new;
    R2_new = R2;
    if R2_new > R2_old
        model_use = {f1_wls,res_new,par_opt};
        mean_errors = mean(res_new)
        plot(rspace,f1_wls(rspace),'LineWidth',2);
        R2_new
    else
        R2_old
%         exitflag = 1;
    end
end
%%
figure;
subplot(1,2,1); hold on;
plot(X,Y,'k*','MarkerSize',10,'LineWidth',3);
plot(rspace,f1_wls(rspace),'r','LineWidth',3);
plot(rspace,MIN_RES./rspace,'--k','LineWidth',2);
axis tight;
set(gca,'FontSize',20);
subplot(1,2,2); hold on;
plot(log(X),Y - f1_wls(X),'r*','MarkerSize',10,'LineWidth',2);
plot(log(rspace),0.*rspace,'--k','LineWidth',3); axis tight;
set(gca,'FontSize',20);



figure; subplot(1,2,1); hold on;
plot(X,Y,'k*','MarkerSize',10,'LineWidth',2);
plot(rspace,f1_wls(rspace),'r','LineWidth',3);
plot(rspace,MIN_RES./rspace,'--k','LineWidth',2);
set(gca,'FontSize',20);
var_exp = sum((f1(X)-mean(Y)).^2);
var_unexp = sum((Y-f1(X)).^2);
var_tot = var_exp + var_unexp;
R2 = 1 - var_unexp./var_tot;
title(sprintf('R^2:   %f',R2));

subplot(1,2,2); hold on;
plot(X,res_new,'r*','MarkerSize',10,'LineWidth',2);
plot(rspace,0.*rspace,'--k','LineWidth',3);
set(gca,'FontSize',20);

%% Now do the same for the length measurements

%% Call all the different models for the function AND the residual

log_X_flag = 0;
log_Y_flag = 0;
recip_X_flag = 0;
recip_Y_flag = 0;
res_flag = -1;

%%
include = 1:19;%[1 2 3 11];
if log_X_flag == 1
    X = log(L(include,1));
    Lspace = linspace(min(X).*1.1,max(X).*0.9,100);
else
    X = L(include,1);
    Lspace = linspace(min(X).*0.9,max(X).*1.1,100);
end

if log_Y_flag == 1
    Y = log(L(include,2));
else
    Y = L(include,2);
end

if recip_X_flag == 1
    X = 1./L(include,1);
end

if recip_Y_flag == 1
    Y = 1./L(include,2);
end
%%

%%
%%
for i=1%1:6
    [f1,res1,par_opt] = call_regression_function(i,X,Y);
    for j=1:6
        if res_flag == 0
            % Normal residuals
            [f2,res2] = call_regression_function(j,X,res1);
        elseif res_flag == -1
            % Squared residuals
            [f2,res2] = call_regression_function(j,X,res1.^2);
        else
            % Log residuals
            [f2,res2] = call_regression_function(j,X,log(res1));
        end
        % Now plot f(x), f(res) and the residual
        figure(10*i+j);
        
        subplot(1,3,1); hold on;
        plot(X,Y,'k*');
        plot(Lspace,f1(Lspace),'r','LineWidth',3);
        plot(Lspace,MIN_RES./Lspace,'--k','LineWidth',2);
        set(gca,'FontSize',20);
        var_exp = sum((f1(X)-mean(Y)).^2);
        var_unexp = sum((Y-f1(X)).^2);
        var_tot = var_exp + var_unexp;
        R2 = 1 - var_unexp./var_tot;
        title(sprintf('R^2:   %f',R2));
        if res_flag == 0
            subplot(1,3,2); hold on;
            plot(X,res1,'k*');
            plot(Lspace,f2(Lspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f2(X)-mean(res1)).^2);
            var_unexp = sum((res2-f2(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
            
        elseif res_flag == -1
            subplot(1,3,2); hold on;
            plot(X,res1.^2,'k*');
            plot(Lspace,f2(Lspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f2(X)-mean(res1.^2)).^2);
            var_unexp = sum((res1.^2-f2(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
            
        else
            subplot(1,3,2); hold on;
            plot(X,log(res1),'k*');
            plot(Lspace,f2(Lspace),'r','LineWidth',3);
            set(gca,'FontSize',20);
            var_exp = sum((f1(X)-mean(log(res1))).^2);
            var_unexp = sum((log(res1)-f1(X)).^2);
            var_tot = var_exp + var_unexp;
            R2 = 1 - var_unexp./var_tot;
            title(sprintf('LM:   %f',R2*19));
        end
        
        subplot(1,3,3); hold on;
        plot(X,res2,'r*');
        plot(Lspace,zeros(100,1),'--k','LineWidth',3);
        set(gca,'FontSize',20);
        
        
        %         subplot(1,4,4); hold on;
        %         plot(R(:,1),f1(R(:,2)),'r*');
        %         plot(Lspace,Lspace,'--r','LineWidth',3);
        %         set(gca,'FontSize',20);
%         set(gcf, 'Position', [200 800 1400 1000]);
    end
end
n = length(X);

%% Step 2a): Now fit the residuals using a smoothing spline
% [f_weights,res_new,par_opt] = call_regression_function(3,X,res1.^2);%fit(X,res1.^2,'smooth');
% figure; hold on;
% plot(X,res1.^2,'ko');
% plot(Lspace,f_weights(Lspace),'r');
% xlim([min(X) max(X)])
% weights_new = f_weights(X);
% tol = 10^(-8);
% dif_weights = 10^6;
% % Step 3: Have a loop?
% figure; hold on;
% plot(X,Y,'k*','LineWidth',2.5);
% plot(Lspace,f1(Lspace),'LineWidth',2);
% exitflag = 0;
% R2_new = 0;
% while dif_weights > tol && exitflag ~=1
%     [f1_wls,res_new,par_opt] = call_weighted_regression_function(3,X,Y,weights_new);
%     [f_weights,res,par_opt] = call_regression_function(3,X,res_new.^2);%fit(X,res1.^2,'smooth');
%     weights_old = weights_new;
%     weights_new = f_weights(X);
%     half_weights_new = weights_new.^(1/2);
%     dif_weights = sum( (weights_new - weights_old).^2);
% %     var_exp = sum(weights_new'*(f1_wls(X)-mean(half_weights_new'*Y)).^2);
%     var_unexp = sum((half_weights_new.*(Y-f1_wls(X))).^2);
%     var_tot = sum((half_weights_new.*Y - mean(half_weights_new.*Y)).^2);%var_exp + var_unexp;
%     R2 = 1 - var_unexp./var_tot;
%     R2_old = R2_new;
%     R2_new = R2;
%     if R2_new > R2_old
%         model_use = {f1_wls,res_new,par_opt};
%         mean_errors = mean(res_new)
%         plot(Lspace,f1_wls(Lspace),'LineWidth',2);
%         R2_new
%     else
%         R2_old
%         exitflag = 1;
%     end
% end
%% Step 2b) OR try to model the weights as the squared mean.
weights = f1(X).^-2;
figure; hold on;
plot(X,res1.^2,'ko');
plot(X,weights,'r');
xlim([min(X) max(X)])
weights_new = weights./sum(weights);
tol = 10^(-10);
dif_weights = 10^6;
 var_exp = sum((f1(X)-mean(Y)).^2);
 var_unexp = sum((Y-f1(X)).^2);
 var_tot = var_exp + var_unexp;
 R2 = 1 - var_unexp./var_tot
 mean_errors = mean(res1)
    
figure; hold on;
plot(X,Y,'k*','LineWidth',2.5);
plot(Lspace,f1(Lspace),'LineWidth',2);
% Step 3b:
R2_old = 0;
R2_new = R2;
exitflag = 0;
num_iter = 100;
iter = 1;
while dif_weights > tol && exitflag ~=1 && iter ~=num_iter
    [f1_wls,res_new,par_opt] = call_weighted_regression_function(1,X,Y,weights_new);
    weights_old = weights_new;
    weights_new = (f1_wls(X).^-2)./sum(f1_wls(X).^-2);%(f1_wls(X).^2)./sum(f1_wls(X).^2);
    half_weights_new = weights_new.^(-1/2);
    dif_weights = sum( (weights_new - weights_old).^2);
%     var_exp = sum(weights_new'*(f1_wls(X)-mean(half_weights_new'*Y)).^2);
    var_unexp = sum((half_weights_new.*(Y-f1_wls(X))).^2);
    var_tot = sum((half_weights_new.*Y - mean(half_weights_new.*Y)).^2);%var_exp + var_unexp;
    R2 = 1 - var_unexp./var_tot;
    R2_old = R2_new;
    R2_new = R2;
    if R2_new > R2_old
        model_use = {f1_wls,res_new,par_opt};
        mean_errors = mean(res_new)
        plot(Lspace,f1_wls(Lspace),'LineWidth',2);
        R2_new
    else
        R2_old
%         exitflag = 1;
    end
    iter = iter+1;
end
%%
figure;
subplot(1,2,1); hold on;
plot(X,Y,'k*','MarkerSize',10,'LineWidth',3);
plot(Lspace,f1_wls(Lspace),'r','LineWidth',3);
plot(Lspace,MIN_RES./Lspace,'--k','LineWidth',2);
axis tight;
set(gca,'FontSize',20);
subplot(1,2,2); hold on;
plot(X,Y - f1_wls(X),'r*','MarkerSize',10,'LineWidth',2);
plot(Lspace,0.*Lspace,'--k','LineWidth',3); axis tight;
set(gca,'FontSize',20);



figure; subplot(1,2,1); hold on;
plot(X,Y,'k*','MarkerSize',10,'LineWidth',2);
plot(Lspace,f1_wls(Lspace),'r','LineWidth',3);
plot(Lspace,MIN_RES./Lspace,'--k','LineWidth',2);
set(gca,'FontSize',20);
var_exp = sum((f1(X)-mean(Y)).^2);
var_unexp = sum((Y-f1(X)).^2);
var_tot = var_exp + var_unexp;
R2 = 1 - var_unexp./var_tot;
title(sprintf('R^2:   %f',R2));

subplot(1,2,2); hold on;
plot(X,res_new,'r*','MarkerSize',10,'LineWidth',2);
plot(Lspace,0.*Lspace,'--k','LineWidth',3);
set(gca,'FontSize',20);