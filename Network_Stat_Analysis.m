%% Analyze the data provided from the networks
% MJC 3/16/18
clear; close all;
plot_sym = {'ks','rs','bs','cs','k*','r*','b*','c*','k+','r+','b+','c+','ks','ro','bo','co','kd','rd','bd','cd','k^','r^','b^','c^'};
conn_name = 'Connectivity_';
dim_name  = 'Dimensions_';
theta1 = [22 25 26  26   26   27  29.9 30  30  30  31   33  34  34  35  35  35  36  36  37  43.6];
theta2 = [5   6 4.7 4.8  5.1  5.8  4.6 5.7 6.5  8  5.6  5.1 3.3 3.4 3.6 4.8 6.8  4  4.1 3.9 7.62];
num_par = length(theta1);
time = linspace(0,0.11,1024);
%% Pressure and Flow analysis
% results = load('Network_Simulations_stiffmed.mat');
% P1 = zeros(num_par,1024); P2 = zeros(num_par,1024); P3 = zeros(num_par,1024);
% Q1 = zeros(num_par,1024); Q2 = zeros(num_par,1024); Q3 = zeros(num_par,1024);
% A1 = zeros(num_par,1024); A2 = zeros(num_par,1024); A3 = zeros(num_par,1024);
% C1 = zeros(num_par,1024); C2 = zeros(num_par,1024); C3 = zeros(num_par,1024);
% for i=1:num_par
%     if i~=12 && i~=10 && i~=17 && i~=2
%     P1(i,:) = results.pressures{i,1}; P2(i,:) = results.pressures{i,2}; P3(i,:) = results.pressures{i,3};
%     Q1(i,:) = results.flows{i,1}; Q2(i,:) = results.flows{i,2}; Q3(i,:) = results.flows{i,3};
%     A1(i,:) = results.areas{i,1}; A2(i,:) = results.areas{i,2}; A3(i,:) = results.areas{i,3};
%     C1(i,:) = results.wavespeeds{i,1}; C2(i,:) = results.wavespeeds{i,2}; C3(i,:) = results.wavespeeds{i,3};
%     figure(1000); hold on;
%     plot(time,P1(i,:));
%     end
% end
% figID = 1;
% % vessel 1
% meanP1 = mean(P1,1);
% maxP1  = max(P1,[],2);
% pulse1 = maxP1 - min(P1,1);
% stdP1  = std(P1,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanP1, 'k', 'LineWidth',3);
% h2 = plot(time, meanP1 + stdP1, 'r--','LineWidth',3);
% plot(time, meanP1 - stdP1, 'r--','LineWidth',3);
% axis([0 0.11 9 26 ]);
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanQ1 = mean(Q1,1);
% maxQ1  = max(Q1,[],2);
% totalflowQ1 = sum(Q1.*time,2);
% stdQ1  = std(Q1,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanQ1, 'k', 'LineWidth',3);
% h2 =plot(time, meanQ1 + stdQ1, 'r--','LineWidth',3);
% plot(time, meanQ1 - stdQ1, 'r--','LineWidth',3);
% axis tight
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanC1 = mean(C1,1);
% stdC1  = std(C1,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanC1, 'k', 'LineWidth',3);
% h2 =plot(time, meanC1 + stdC1, 'r--','LineWidth',3);
% plot(time, meanC1 - stdC1, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% %vessel 2
% meanP2 = mean(P2,1);
% maxP2  = max(P2,[],2);
% pulse2 = maxP2 - min(P2,[],1);
% stdP2 = std(P2,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanP2, 'k', 'LineWidth',3);
% h2 =plot(time, meanP2 + stdP2, 'r--','LineWidth',3);
% plot(time, meanP2 - stdP2, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanQ2 = mean(Q2,1);
% maxQ2  = max(Q2,[],2);
% totalflowQ2 = sum(Q2.*time,2);
% stdQ2  = std(Q2,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanQ2, 'k', 'LineWidth',3);
% h2 =plot(time, meanQ2 + stdQ2, 'r--','LineWidth',3);
% plot(time, meanQ2 - stdQ2, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanC2 = mean(C2,1);
% stdC2  = std(C2,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanC2, 'k', 'LineWidth',3);
% h2 =plot(time, meanC2 + stdC2, 'r--','LineWidth',3);
% plot(time, meanC2 - stdC2, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanP3 = mean(P3,1);
% maxP3  = max(P3,[],2);
% pulse3 = maxP3 - min(P3,[],1);
% stdP3  = std(P3,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanP3, 'k', 'LineWidth',3);
% h2 =plot(time, meanP3 + stdP3, 'r--','LineWidth',3);
% plot(time, meanP3 - stdP3, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanQ3 = mean(Q3,1);
% maxQ3  = max(Q3,[],1);
% totalflowQ3 = sum(Q3.*time,2);
% stdQ3  = std(Q3,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanQ3, 'k', 'LineWidth',3);
% h2 =plot(time, meanQ3 + stdQ3, 'r--','LineWidth',3);
% plot(time, meanQ3 - stdQ3, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;
% 
% meanC3 = mean(C3,1);
% stdC3  = std(C3,1);
% figure(figID); clf; hold on;
% h1 = plot(time, meanC3, 'k', 'LineWidth',3);
% h2 =plot(time, meanC3 + stdC3, 'r--','LineWidth',3);
% plot(time, meanC3 - stdC3, 'r--','LineWidth',3);
% axis tight;
% legend([h1 h2],{'Mean', '(\pm) Standard Deviation'});
% set(gca,'FontSize',30);
% grid on;
% figID = figID + 1;


%% WIA
% rho = 1.055; g = 981; lr = 0.1;
% rgL = rho*g*lr;
% for i=1:num_par
%     WIA(P1(i,:)',Q1(i,:)',A1(i,:)',C1(i,:)',rgL,rho,'Root')
%     WIA(P2(i,:)',Q2(i,:)',A2(i,:)',C2(i,:)',rgL,rho,'Root')
%     WIA(P3(i,:)',Q3(i,:)',A3(i,:)',C3(i,:)',rgL,rho,'Root')
% end

%% Windkessel BC analysis
% load('Network_BCs.mat');
% load('Network_RTCT.mat');
% RT = zeros(length(BC_save),1);
% CT = zeros(length(BC_save),1);
% bc_leng = length(BC_save);
% for i=1:bc_leng
%     bc_curr = BC_save{i};
%     rt_curr = RT_CT{i}(:,1);
%     ct_curr = RT_CT{i}(:,2);
%     figure(7000+i); clf; hold on;
%     plot(log(bc_curr(:,1)),'s','MarkerSize',12);
%     figure(8000+i); clf; hold on;
%     plot(log(bc_curr(:,2)),'s','MarkerSize',12);
%     figure(9000+i); clf; hold on;
%     plot(log(bc_curr(:,3)),'s','MarkerSize',12);
%     RT(i) = 1./(1./sum(bc_curr(:,1) + bc_curr(:,2)));
%     CT(i) = sum(ct_curr);
% end
% figure(1098); 
% plot(log(RT),'k*','MarkerSize',20);
% axis([0  bc_leng+1 10 max(log(RT))])
% xlabel('Network');
% ylabel('(mmHg s/ml)')
% xticks(0:num_par+1)
% title('Log Total Resistance of Network')
% grid on;
% set(gca,'FontSize',30);
% figure(1099); 
% plot(CT,'r*','MarkerSize',20);
% axis([0 bc_leng+1 0.6 max(CT)])
% xlabel('Network');
% ylabel('(cm^3/mmHg)')
% xticks(0:num_par+1)
% title('Total Compliance of Network')
% grid on;
% set(gca,'FontSize',30);
%% Length and Radius Analysis
figure(1); clf; %length
figure(2); clf; %radius
names = {};
h = [];
R = [];%zeros(15,num_par);
L = [];%zeros(15,num_par);
%%
% for i=1:num_par
%     disp(i)
%     if i < 100 %i~=12 && i~=10 && i~=17 && i~=2
%     fconn = strcat(conn_name,num2str(theta1(i)),'_',num2str(theta2(i)),'.txt');
%     fdim  = strcat(dim_name,num2str(theta1(i)),'_',num2str(theta2(i)),'.txt');
%     conn = dlmread(fconn);
%     dim  = dlmread(fdim);
%     parent = conn(1,1);
%     % Analysis one side first
%     figure(1); hold on
%     if i==1 %Ensures matlab thinks h is a line
%         h = plot(0,dim(1,1),plot_sym{i},'MarkerSize',10);
%     else
%         h(end+1) = plot(0,dim(1,1),plot_sym{i},'MarkerSize',10);
%     end
%     figure(2); hold on;
%     plot(0,dim(1,2),plot_sym{i},'MarkerSize',10);
%     %% Append radius and length into a matrix
%     L(1,i) = dim(1,1);
%     R(1,i) = dim(1,2);
%     vesselID = 1;
%     generation = 0;
%     % side 1
%     p1 = 0; p2 = [];
%     starts = []; ends = []; %Initialize information for digraphs
%     %% Note, we have to add one each time d1 or d2 is an index for a matrix,
%     % since d1 corresponds to the daughter ID, but we start from zero, so
%     % we must add one each time. (see dim(d1+1,2), for example.
%     while generation < 3
%         p1new = [];
%         p2new = [];
%         if ~isempty(p1)
%             for t=1:length(p1)
%                 nextparent = find(conn(:,1) == p1(t));
%                 starts(end+1) = conn(nextparent,1); %Repeat twice for dirgraph
%                 starts(end+1) = conn(nextparent,1);
%                 d1 = conn(nextparent,2);
%                 ends(end+1) = d1;
%                 figure(1); hold on
%                 plot(vesselID,dim(d1+1,1),plot_sym{i},'MarkerSize',10);
%                 figure(2); hold on;
%                 plot(vesselID,dim(d1+1,2),plot_sym{i},'MarkerSize',10);
%                 vesselID = vesselID + 1;
%                 L(vesselID,i) = dim(d1+1,1);
%                 R(vesselID,i) = dim(d1+1,2);
%                 d2 = conn(nextparent,3);
%                 ends(end+1) = d2;
%                 figure(1); hold on
%                 plot(vesselID,dim(d2+1,1),plot_sym{i},'MarkerSize',10);
%                 figure(2); hold on;
%                 plot(vesselID,dim(d2+1,2),plot_sym{i},'MarkerSize',10);
%                 vesselID = vesselID + 1;
%                 L(vesselID,i) = dim(d2+1,1);
%                 R(vesselID,i) = dim(d2+1,2);
%                 p1new(end+1) = d1;
%                 p2new(end+1) = d2;
%             end
%         end
%         if ~isempty(p2)
%             for t=1:length(p2)
%                 nextparent = find(conn(:,1) == p2(t));
%                 starts(end+1) = conn(nextparent,1); %Repeat twice for dirgraph
%                 starts(end+1) = conn(nextparent,1);
%                 d1 = conn(nextparent,2);
%                 ends(end+1) = d1;
%                 figure(1); hold on
%                 plot(vesselID,dim(d1+1,1),plot_sym{i},'MarkerSize',10);
%                 figure(2); hold on;
%                 plot(vesselID,dim(d1+1,2),plot_sym{i},'MarkerSize',10);
%                 vesselID = vesselID + 1;
%                 L(vesselID,i) = dim(d1+1,1);
%                 R(vesselID,i) = dim(d1+1,2);
%                 d2 = conn(nextparent,3);
%                 ends(end+1) = d2;
%                 figure(1); hold on
%                 plot(vesselID,dim(d2+1,1),plot_sym{i},'MarkerSize',10);
%                 figure(2); hold on;
%                 plot(vesselID,dim(d2+1,2),plot_sym{i},'MarkerSize',10);
%                 vesselID = vesselID + 1;
%                 L(vesselID,i) = dim(d1+1,1);
%                 R(vesselID,i) = dim(d2+1,2);
%                 p1new(end+1) = d1;
%                 p2new(end+1) = d2;
%             end
%         end
%         p1 = p1new;
%         p2 = p2new;
%         generation = generation + 1;
%     end
% %     figure(10+i);
% %     plot(digraph(starts+1,ends+1));
% %     axis([0 5 0 3.5])
% %     names{end+1} = strcat('Network',num2str(i));
%     end
% end
% deleteID = [12 10 17 2];
% L(:,deleteID) = []; %Quick fix
% R(:,deleteID) = [];


%% Vessels to compare
name1 = 'M1P4_lower';
name2 = '_smooth';
name3 = '_Data.mat';
vessels_included{1}  =  [0 1   31 151 71 32 90    89 179 219 182 224 220 225 244] + 2;
vessels_included{2}  =  [0 1   97 2   155 98 193  156 282 330 283 338 333 339 386] + 2;
vessels_included{3}  =  [0 1   107 2  108 228 109 195 283 327 284 328 429 390 329] + 2;
vessels_included{4}  =  [0 170 171 358 172 299 208 173 1   50   2  57  53 58 100] + 2;
vessels_included{5}  =  [0 169 170 361 171 298 205 172 1   50   2  52 164 53 94] + 2;
vessels_included{6}  =  [0 181 182 373 183 312 221 184 1   54   2 57 177 58 103] + 2;
vessels_included{7}  =  [0 1   100 2 158 101 198 159 295 339 296 345 340  346 387] + 2;
vessels_included{8}  =  [0 181 182 388 183 321 224 184 1 54   2  60  56   61 110] + 2;
vessels_included{9}  =  [0 183 184 393 185 326 186 285 1 56   2  58 178   59 112] + 2;
vessels_included{10}  = [0 1   98  2  152 99   188 153 281 323 282 329 324 330 369] + 2;
vessels_included{11}  = [0 183 286 184 348 287 349 448 1  52   2  59  55 60 109] + 2;
vessels_included{12}  = [0 196 197 416 198 345 240 199 1 56 2 63 59 144 64] + 2;
vessels_included{13}  = [0 1 117 2 118 260 119 216 331 381 332 388 384 389 438] + 2;
vessels_included{14}  = [0 183 184 380 185 319 221 186 1 56 2 63 59 64 108] + 2;
vessels_included{15}  = [0 1   105 2   169 106 170 268 305 355 306 356 470 357 403] + 2;
vessels_included{16}  = [0 182 183 379 184 312 185 277  1  56   2  64   59 133 65] + 2;
vessels_included{17}  = [0 150 151 326 203 152 241 204 1    46   2  52  48 114  53] + 2;
vessels_included{18}  = [0 1  102  2   160 103 200 161 297 343 298 349 344 350 385] + 2;
vessels_included{19} = [0 146 147 305  148 258 176 149 1   42   2   48 44   49 85] + 2;
vessels_included{20} = [0 1   94  2   150 95  188 151 285 331 286 337 332 338 373] + 2;
vessels_included{21} = [0 1   38   2   62  39 78   63 120 138 121 140 139 141 162] + 2;

num_vessels = length(vessels_included{1});
L = zeros(num_vessels,num_par);
R = zeros(num_vessels,num_par);
generation_analysis = {};
for i=1:num_par
    network = load(strcat(name1,num2str(theta1(i)),name2,num2str(theta2(i)),name3));
    connectivity = network.connectivity;
    dets = network.vessel_details;
    disp(i)
    sub_generation = {};
    for j=1:num_vessels
        L(j,i) = dets{vessels_included{i}(j),3};
        R(j,i) = dets{vessels_included{i}(j),4};
        figure(1); hold on;
        plot(j-1,L(j,i),plot_sym{i},'MarkerSize',10);
        hold off;
        figure(2); hold on;
        plot(j-1,R(j,i),plot_sym{i},'MarkerSize',10);
        hold off;
    end
    %% Now go through and save information about each generation
    char_ID = 64;
    size_dets = size(dets,1);
    for j=1:25
       generation = char_ID + j;
       ids = [];
       for k=2:size_dets
           if strcmp(dets{k,1}(1),char(generation))
                ids(end+1) = k;
           end
       end
       if ~isempty(ids)
           sub_generation{end+1,1} = char(generation);
           sub_generation{end,2} = ids;
       end
    end
    generation_analysis{end+1} = sub_generation;
end
%%
sym_ID = 1;
for i=1:num_vessels
%     if i~=12 && i~=10 && i~=17 && i~=2
    L_int = 0.5*min(L(i,:)):0.0001:1.5*max(L(i,:));
%    [fl,xil,Hl] = ksdensity(L(i,:),L_int,'Support','positive');
    [fl,xil,Hl] = ksdensity(L(i,:),'Support','positive');
   figure(1); hold on;
   normfl = fl./norm(fl);
   plot(normfl+(i-1)+0.05,xil,'k-','LineWidth',3);
%    plot((i-1).*ones(num_par,1),L(i,:),plot_sym{sym_ID},'MarkerSize',10)
   
   R_int = 0.5*min(R(i,:)):0.00001:1.5*max(R(i,:));
%    [fr,xir,Hr] = ksdensity(R(i,:),R_int,'Support','Positive');
[fr,xir,Hr] = ksdensity(R(i,:),'Support','Positive');
   figure(2); hold on;
   normfr = fr./norm(fr);
   plot(normfr+(i-1)+0.05,xir,'k-','LineWidth',3);
%    plot((i-1).*ones(num_par,1),R(i,:),plot_sym{sym_ID},'MarkerSize',10)
   
   figure(100+i); clf; hold on;
   plot(xil,normfl,'r','LineWidth',3);
   muL = mean(L(i,:));
%    [H,P,CI] = ttest(L(i,:));
%    plot(ones(1,100).*CI(1),linspace(0,1,100),'--k','LineWidth',3);
%    plot(ones(1,50).*muL,linspace(0,1,50),'-ok','LineWidth',1);
%    plot(ones(1,100).*CI(2),linspace(0,1,100),'--k','LineWidth',3);
   
   
   figure(200+i); clf; hold on;
   plot(xir,normfr,'m','LineWidth',3);
%    muR = mean(R(i,:));
%    [H,P,CI] = ttest(R(i,:));
%    plot(ones(1,100).*CI(1),linspace(0,1,100),'--k','LineWidth',3);
%    plot(ones(1,50).*muR,linspace(0,1,50),'-ok','LineWidth',1);
%    plot(ones(1,100).*CI(2),linspace(0,1,100),'--k','LineWidth',3);
%   
% sym_ID = sym_ID + 1;
end

%% Try Bootstrapping
% num_samp = 100000;
% cut_offs = linspace(0,1,num_par+1);
% l_order = sort(L,2);
% r_order = sort(R,2);
% l_boot_mean_mat = zeros(num_samp,12);
% r_boot_mean_mat = zeros(num_samp,12);
% l_boot_std_mat = zeros(num_samp,12);
% r_boot_std_mat = zeros(num_samp,12);
% for i=1:num_vessels
%     l_rand = rand(num_samp,num_par);
%     r_rand = rand(num_samp,num_par);
%     l_boot = zeros(num_samp,num_par);
%     r_boot = zeros(num_samp,num_par);
%     for k=num_par:-1:1
%        l_boot = l_boot + (cut_offs(k+1)>=l_rand & l_rand>cut_offs(k)).*l_order(i,k); %Each column should be values
%        r_boot = r_boot + (cut_offs(k+1)>=r_rand & r_rand>cut_offs(k)).*r_order(i,k); % the given vessel
%     end
%     l_boot_mean_mat(:,i) = mean(l_boot,2); %Mean of each row
%     r_boot_mean_mat(:,i) = mean(r_boot,2);
%     l_boot_std_mat(:,i)  = sqrt((1./(num_par-1)).*sum( (l_boot - mean(l_boot,2)).^2,2));
%     r_boot_std_mat(:,i)  = sqrt((1./(num_par-1)).*sum( (r_boot - mean(r_boot,2)).^2,2));
% end
% l_boot_mean = mean(l_boot_mean_mat,1); %Mean of each column
% r_boot_mean = mean(r_boot_mean_mat,1);
% l_boot_std  = std(l_boot_mean_mat,1);
% r_boot_std  = std(r_boot_mean_mat,1);
% LB_l = l_boot_mean - 2.*l_boot_std;
% UB_l = l_boot_mean + 2.*l_boot_std;
% LB_r = r_boot_mean - 2.*r_boot_std;
% UB_r = r_boot_mean + 2.*r_boot_std;
% %To make the legend right
% 
% %%
% for i=1:num_vessels
%     figure(100+i); hold on;
%     plot(ones(1,100).*LB_l(i),linspace(0,1,100),'--c','LineWidth',3);
%     plot(ones(1,50).*l_boot_mean(i),linspace(0,1,50),'-co','LineWidth',1);
%     plot(ones(1,100).*UB_l(i),linspace(0,1,100),'--c','LineWidth',3);
%     h1 = plot(nan,nan,'r','LineWidth',3);   
% %     h2 = plot(nan,nan,'-ok','LineWidth',1);
% %     h3 = plot(nan,nan,'--k','LineWidth',3);
%     h4 = plot(nan,nan,'-co','LineWidth',1);
%     h5 = plot(nan,nan,'--c','LineWidth',3);
%     legend([h1 h4 h5],{'KDE','Bootstrapping CI','Bootstrapping Mean'});
%     title(sprintf('Kernel Density and Confidence Interval for L%d',i));
%     set(gca,'FontSize',30); grid on;
%     
%     figure(200+i); hold on;
%     plot(ones(1,100).*LB_r(i),linspace(0,1,100),'--c','LineWidth',3);
%     plot(ones(1,50).*r_boot_mean(i),linspace(0,1,50),'-co','LineWidth',1);
%     plot(ones(1,100).*UB_r(i),linspace(0,1,100),'--c','LineWidth',3);
%     g1 = plot(nan,nan,'m','LineWidth',3);
%     h4 = plot(nan,nan,'-co','LineWidth',1);
%     h5 = plot(nan,nan,'--c','LineWidth',3);
%     legend([g1 h4 h5],{'KDE','Bootstrapping CI','Bootstrapping Mean'});
%     title(sprintf('Kernel Density and Confidence Interval for R%d',i));
%     set(gca,'FontSize',30); grid on;
% end
% 
% %%
% figure(1); grid on;
% set(gca,'FontSize',30);
% xticks(0:13);
% axis tight
% figure(2); grid on;
% set(gca,'FontSize',30);
% xticks(0:13);
% axis tight
%% Look at Generation Characteristics
R_gen = [];
for i=1:num_par
    network = load(strcat(name1,num2str(theta1(i)),name2,num2str(theta2(i)),name3));
    connectivity = network.connectivity;
    dets = network.vessel_details;
    gen_curr = generation_analysis{i};
    max_gen = size(gen_curr,1);
    for g = 1:max_gen
        num_in_gen = max(size(gen_curr{g,2}));
        L_temp = [];
        R_temp = [];
        for in_gen = 1:num_in_gen
            id = gen_curr{g,2}(in_gen);
            L_temp(end+1) = dets{id,3}; 
            R_temp(end+1) = dets{id,4};
        end
        L_gen(g,1:num_in_gen) = L_temp;
        R_gen(g,1:num_in_gen) = R_temp;
    end
    %% Now add some type of analysis on the radius and length in the generations
end

%% Second part: Look at total network characteristics
f1 = 'M1P4_lower';
f2 = '_smooth';
f3 = '_Data.mat';
numberofvessels     = zeros(num_par,1);
numberofgenerations = zeros(num_par,1);
total_volume        = zeros(num_par,1);
for i=1:num_par
    file = strcat(f1,num2str(theta1(i)),f2,num2str(theta2(i)),f3);
    A = load(file);
    numberofvessels(i) = size(A.vessel_details,1)-1;
    basechar = 65; %A corresponds to char(65)
    dets = A.vessel_details;
    for k=2:numberofvessels(i)+1
        if strcmp(char(basechar),dets{k,1}(1,1))
            basechar = basechar + 1; %Increment if we find the same letter
        end
        total_volume(i) = total_volume(i) + pi.*dets{k,3}.*dets{k,4}.^2;
    end
    numberofgenerations(i) = basechar - 65;
end
ves  = [theta1' theta2' numberofvessels];
gens = [theta1' theta2' numberofgenerations];
vol  = [theta1' theta2' total_volume];

figure(1000); plot(theta1,numberofvessels,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_1')
ylabel('Total number of vessels')
set(gca,'FontSize',32); grid on;
figure(1001); plot(theta1,numberofgenerations,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_1')
ylabel('Total number of Generations')
set(gca,'FontSize',32); grid on;
figure(1002); plot(theta1,total_volume,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_1')
ylabel('Total Volume')
set(gca,'FontSize',32); grid on;
figure(1003); plot(theta2,numberofvessels,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_2')
ylabel('Total number of vessels')
set(gca,'FontSize',32); grid on;
figure(1004); plot(theta2,numberofgenerations,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_2')
ylabel('Total number of Generations')
set(gca,'FontSize',32); grid on;
figure(1005); plot(theta2,total_volume,'ko','MarkerSize',12,'MarkerFace','k');
xlabel('\theta_2')
ylabel('Total Volume')
set(gca,'FontSize',32); grid on;
%% Now do some statistical analysis
X = [ones(1,num_par); theta1; theta2]';
[B_ves,BINT_gen] = regress(numberofvessels,X);
ves_fit1 = B_ves(1) + B_ves(2).*X(:,2);
ves_fit2 = B_ves(1) + B_ves(3).*X(:,3);
[B_gen,BINT_gen] = regress(numberofgenerations,X);
gen_fit1 = B_gen(1) + B_gen(2).*X(:,2);
gen_fit2 = B_gen(1) + B_gen(3).*X(:,3);
[B_vol,BINT_gen] = regress(total_volume,X);
vol_fit1 = B_vol(1) + B_vol(2).*X(:,2);
vol_fit2 = B_vol(1) + B_vol(3).*X(:,3);

%%
figure(1000); hold on;
plot(X(:,2),ves_fit1,'r','LineWidth',3);

figure(1001); hold on;
plot(X(:,2),gen_fit1,'r','LineWidth',3);

figure(1002); hold on;
plot(X(:,2),vol_fit1,'r','LineWidth',3);

figure(1003); hold on;
plot(X(:,3),ves_fit2,'r','LineWidth',3);

figure(1004); hold on;
plot(X(:,3),gen_fit2,'r','LineWidth',3);

figure(1005); hold on;
plot(X(:,3),vol_fit2,'r','LineWidth',3);



