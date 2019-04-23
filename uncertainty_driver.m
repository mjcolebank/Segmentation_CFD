%% This script will be used to understand the effects of geometric measurement on a
%  system of blood vessels, where we assume that the radius,length, and
%  connectivity are subject to uncertainty about their measurment and
%  population average. MJC 2/1/18
%%
clc;
% close all;
% clear;
rng(10);
filename = 'M1P4_lower30_smooth6.5_Data.mat';
network = load(filename);
connectivity = network.connectivity;
max_iter = 5000;
pressures  = cell(max_iter,3);
flows      = cell(max_iter,3);
areas      = cell(max_iter,3);
wavespeeds = cell(max_iter,3);
geometry   = cell(max_iter,1);
parameters = cell(max_iter,1);
max_pts = 1024;
vessel_measurements = network.vessel_details;
% connectivity = network.connectivity;
%% Algorithm 7: Get simplified connectivity?
[simple_connectivity,terminal] = find_simple_connectivity(connectivity, vessel_measurements);% Has number for parent, daughter1, and daughter2
%% Algorithm 8: Make Directed Grpah
make_directed_graph(simple_connectivity,terminal);
%% HARD CODED SIMPLE BIFURCATION
% simple_connectivity = simple_connectivity(1,:);
% terminal = simple_connectivity(1,2:3);


%% For the sake of connectivity check, we need to order the connectivity in a way that
% renumbers that connectivity in a better manner (and gives us bifurcations
% near each other. Try doing it by generation
% note: per generation, vessels increase (at most) by 2i. One vessel
% will hence go to 2*1 = 2 new vessels, then at generation 2 we get 4.
% Similarly, the size of the connectivity goes 1,3,7,15 (so up by 2 4 8
% ect).
generation = {};
generation{end+1} = simple_connectivity(1,1);
num_conn = 1;
generation_find = {1,2:3, 4:7, 8:15, 16:31, 32:63, 64:127, 128:255};
terminal_cell   = {};
terminal_cell{end+1} = 1;
new_daughters   = [2, 4, 8, 16, 32, 64, 128, 256];
for i=1:9%length(simple_connectivity)
    if i~=1
        size_old = size(old_generation,1);
        num_conn = new_daughters(i-1); %Number of potential new daughters
        new_generation = zeros(size_old+num_conn,3);
        new_generation(1:size_old,:) = old_generation;
        new_inc = 1;
        clearID = [];
        for j=generation_find{i-1}
            d1 = old_generation(j,2);
            d2 = old_generation(j,3);
            if d1~=0
                d1_id = find(simple_connectivity(:,1) == d1);
                d2_id = find(simple_connectivity(:,1) == d2);
                if ~isempty(d1_id)
                    new_generation(size_old + 2*new_inc - 1,:) = simple_connectivity(d1_id,:);
                else
                    clearID(end+1) = size_old + 2*new_inc - 1;
                    %add terminal
                end
                if ~isempty(d2_id)
                    new_generation(size_old + 2*new_inc,:)  = simple_connectivity(d2_id,:);
                else
                    clearID(end+1) = size_old + 2*new_inc;
                    %add terminal
                end
                new_inc = new_inc + 1;
            end
        end
        generation{end+1} = new_generation;
    else
        generation{end+1} = simple_connectivity(1,:);
    end
    old_generation = generation{end};
    new_terminal = [];
    for k=1:size(old_generation,1)
        check1 = old_generation(k,2);
        check2 = old_generation(k,3);
        flag1  = isempty(find(old_generation(:,1) == check1,1));
        flag2  = isempty(find(old_generation(:,1) == check2,1));
        if flag1 == 1
            new_terminal(end+1) = check1;
        end
        if flag2 == 1
            new_terminal(end+1) = check2;
        end
    end
    terminal_cell{end+1} = new_terminal;
end

for k=1:length(generation)
    gen_curr = generation{k};
    where = find(gen_curr(:,1) == 0);
    gen_curr(where,:) = [];
    generation{k} = gen_curr;
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% THIS TELLS YOU HOW BIG THE NETWORK IS
gen_ID=10;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





test_network = generation{gen_ID};
test_terminal = terminal_cell{gen_ID};
%% Define the connectivity
vessel_ids = unique(test_network)';
num_vessels = max(size(unique(test_network)));%size(vessel_measurements,1)-1;%length(vessels_21);
measurements = zeros(num_vessels,2);
for i=1:num_vessels %Go back through and reassign number (so you don't have 1 2 and 800 has your vessel #s)
    if any(test_network == i)
    else
        where_greater = find(test_network > i);
        min_of = min(test_network(where_greater));
        where_min = find(test_network == min_of);
        measurements(i,1) = round(vessel_measurements{test_network(where_min(1)),3}.*0.1,3);
        measurements(i,2) = round(vessel_measurements{test_network(where_min(1)),4}.*0.1,3);
        test_network(where_min) = i;
        if any(test_terminal == min_of)
            where_term = find(test_terminal == min_of);
            test_terminal(where_term) = i;
        end
    end
end

%% THE MOST IMPORTANT STEP: Go back and fix indicies once the trifurcations have been dealt with
%     dlmwrite('connectivity.txt',test_network-1,'\t');
%     dlmwrite('terminal_vessels.txt',test_terminal-1,'\t');
%%
num_terminal = length(test_terminal);
data    = struct;
data.P  = zeros(max_iter, max_pts, num_vessels);
data.Q  = zeros(max_iter, max_pts, num_vessels);
data.A  = zeros(max_iter, max_pts, num_vessels);
data.C  = zeros(max_iter, max_pts, num_vessels);
data.G  = zeros(max_iter, num_vessels*2);
r4l     = zeros(num_vessels,1);
Q       = zeros(num_vessels,1);
Rtotal  = zeros(num_vessels,1);
R1      = zeros(num_vessels,1);
R2      = zeros(num_vessels,1);
CT      = zeros(num_vessels,1);
dim_mat = zeros(num_vessels,2);
id = 1;
%     for i=1:num_vessels
%         L_nom(i) = measurements(i,1);%round(vessel_measurements{vessels_21(i),3}.*0.1,3);
%         R_nom(i) = measurements(i,2);%round(vessel_measurements{vessels_21(i),4}.*0.1,3);
%         %% VERY IMPORTANT TO INCLUDE THIS FOR SIMULATIONS
%         % Except we are sampling, so this doesn't really need to be applied
%         if L_nom(i) < 0.025
%             L_nom(i) = 0.025;
%         end
%         dim_mat(id,:) = [L_nom(i) R_nom(i)];
%         id = id+1;
%     end
L_nom = measurements(:,1);
R_nom = measurements(:,2);
%     dim_mat = [L_nom; R_nom];
%     dlmwrite('Dimensions_10gen.txt',dim_mat,'\t')

%% Define parameter scaling from WKnominal
P_spread = 14.6986;
Q_spread = 0.1686;
con_factor = 1322.22;
g = 981;
ratio = 0.2;
tau = 15.38698261;
rho = 1.055;
mu = 0.049;
Lc = 0.1;
qc = 0.1;
Pnd = P_spread*(con_factor/rho/g/Lc);
Qnd = Q_spread/qc;
taufit = 0.1538698261;
RC = 7.4999;

temp_network = test_network; %Make a temporary network that will be reduced
temp_terminal = test_terminal;%Make a temporary terminal array that will be reduced
size_network = size(temp_network,1);
first_iteration_flag = 1; %Run the full network once
graph_pressure_id = 20;


%% Import the CDF from the Density Estimation
densL = load('icdf_GP_L.mat');
densR = load('icdf_GP_R.mat');
icdf_L = densL.GP_CDF_L;
icdf_R = densR.GP_CDF_R;
interval_L = densL.X_L;
interval_R = densR.X_R;
% Extend the ends for when things are close to 1
icdf_L(end+1) = 1;
icdf_R(end+1) = 1;
interval_L(end+1) = 1;
interval_R(end+1) = 1;
%% USE GP REGRESSION
gpL = load('GP_regression_L_9_17.mat');
gpR = load('GP_regression_R_9_17.mat');
phi_yL = gpL.Y_L;
phi_xL = gpL.X_L*0.1;
phi_yR = gpR.Y_R;
phi_xR = gpR.X_R*0.1;
%% Or just use the average standard deviation
% This is used to make enough samples so that negative dimensions can just
% get tossed.
max_total_iter = max_iter*5;
draw = unifrnd(0,1,max_total_iter,1);
draw_to_cdf_L = zeros(max_total_iter,1);
draw_to_cdf_R = zeros(max_total_iter,1);
perturbation_length  = zeros(max_total_iter,1);
perturbation_radius  = zeros(max_total_iter,1);
for i=1:max_total_iter
    if isempty(find(draw(i) <= interval_L,1))
        i
    elseif isempty(find(draw(i) <= icdf_L,1))
        i
    end
    %     find(draw(i) <= icdf_L,1)
    if i== 1851
        disp(i)
    end
    draw_to_cdf_L(i) = find(draw(i) <= icdf_L,1);
    draw_to_cdf_R(i) = find(draw(i) <= icdf_R,1);
    perturbation_length(i) = interval_L(draw_to_cdf_L(i));
    perturbation_radius(i) = interval_R(draw_to_cdf_R(i));
end
sigma_L = zeros(num_vessels,1);
sigma_R = zeros(num_vessels,1);
for i=1:length(L_nom)
    L_id = find(phi_xL >= L_nom(i),1,'first');
    R_id = find(phi_xR >= R_nom(i),1,'first');
    if isempty(L_id)
        L_id = 10000; %ASSIGN LARGEST VALUE
    end
    if isempty(R_id)
        R_id = 10000; %ASSIGN LARGEST VALUE
    end
    sigma_L(i) = phi_yL(L_id);
    sigma_R(i) = phi_yR(R_id);
end

%% The big loop
parpool('local')
for i=1%spmd
    iter = 1;
    perturbation_ID = 1;
    while iter <= max_iter
        L = L_nom.*(perturbation_length(perturbation_ID).*sigma_L + 1);
        R = R_nom.*(perturbation_radius(perturbation_ID).*sigma_R + 1);
        if any(R<=0) || any(L<=0)
            warning('Negative Dimensions');
            perturbation_ID = perturbation_ID+1;
        else
            if any(L < 0.025)
                id = find(L<0.025);
                L(id) = 0.025;
                %         for id_i = id
                %             fprintf('Length %d: %f.3\n',id_i,L(id_i));
                %         end
                
            end
            iter
            dim_mat = round([L R],3);
            geometry{iter} = dim_mat;
            dlmwrite('Dimensions.txt',dim_mat,'\t')
            %% Add a loop here to do the following: we want to reorder the
            % connectivity matrix and the terminal vessels so we get the
            % largest values first (i.e. vessel 27 before 1) so the C code can
            % parse it correctly.
            temp_terminal = sort(temp_terminal);
            [who,where] = sort(temp_network(:,1));
            temp_network = temp_network(where,:);
            dlmwrite('connectivity.txt',temp_network-1,'\t');
            dlmwrite('terminal_vessels.txt',temp_terminal-1,'\t');
            for i=1:num_vessels
                r4l(i) = (R(i).^4)./L(i);
            end
            conn_inc = 1;
            %%If any parameters are zero or INF, its because those vessels are unused
            for i=temp_network(:,1)'
                if i==1
                    Q(i) = Qnd;
                end
                if any(temp_network(:,1) == i) && size(temp_network,2) > 1
                    d1 = temp_network(conn_inc,2); %Assign Daughters
                    d2 = temp_network(conn_inc,3);
                    Q(d1) = Q(i)*r4l(d1)./(r4l(d1) + r4l(d2));
                    Q(d2) = Q(i)*r4l(d2)./(r4l(d1) + r4l(d2));
                    conn_inc = conn_inc + 1;
                end
            end
            for i=1:num_vessels
                Rtotal(i) = Pnd./Q(i);
                R1(i) = round(ratio.*Rtotal(i),4);
                R2(i) = round(Rtotal(i)-R1(i),4);
                CT(i) = tau./Rtotal(i);
            end
            param = zeros(num_vessels.*2 + length(temp_terminal).*3);
            inneri=1;
            for i=1:2:2*num_vessels
                param(i) = L(inneri);
                param(i+1) = R(inneri);
                inneri = inneri + 1;
            end
            inneri = 1;
            BC_matrix = zeros(length(temp_terminal),3);
            for i=2*num_vessels+1:3:length(param)
                param(i)   = round(R1(temp_terminal(inneri)),0);
                param(i+1) = round(R2(temp_terminal(inneri)),0);
                param(i+2) = round(CT(temp_terminal(inneri)),6);
                BC_matrix(inneri,:) = param(i:i+2,1);
                inneri = inneri+1;
            end
            dlmwrite('Windkessel_Parameters.txt',BC_matrix,'\t');
            parameters{iter} = BC_matrix;
            cross_area = sum(pi.*R(1).^2);
            Ehr0 = con_factor.*((0.8)*(cross_area.^2)*(Pnd./Qnd).^2./rho);
            simulation = zeros(4,7,1024);
            tic
            factor = 1;
            f3 = (factor).*5e+5;%linspace(5e+4,5e+6,100000);
            
            
            first_iteration_flag = 0;
            %%
            %     unix(sprintf('make clean'));
            %     unix(sprintf('make'));
            param_curr = param(:,1);
            p = num2cell(param_curr); % Tells you how many geometries have satisfied your constraint.
            
            %% Inputs are sor06, # vessels, # terminal, and stiffness
            unix(sprintf( strcat('./sor06',sprintf(' %f %f %g ', num_vessels, num_terminal, f3) ) ) );
            dataV1 = load ('pu1_C.2d');
            if isempty(dataV1)
            else
                %plot the first vessel
                %%
                [t,x,pressure,q,A,C] = gnuplot(dataV1);
                P1 = pressure(:,floor((end)/2));  Q1 = q(:,floor((end)/2)); ...
                    A1 = A(:,floor((end)/2)); C1 = C(:,floor((end)/2));
                %%
                dataV1 = load ('pu2_C.2d');
                if~isempty(dataV1)
                    [t,x,pressure,q,A,C] = gnuplot(dataV1);
                    P2 = pressure(:,floor((end)/2));  Q2 = q(:,floor((end)/2)); ...
                        A2 = A(:,floor((end)/2)); C2 = C(:,floor((end)/2));
                    %                     figure(21); hold on;
                    %                     plot(P2,'LineWidth',3);
                    %                     set(gca,'FontSize',30);
                    %                     hold off;
                    %                     figure(22); hold on;
                    %                     plot(Q2,'LineWidth',3);
                    %                     set(gca,'FontSize',30);
                    %                     hold off;
                    %                     figure(23); hold on;
                    %                     plot(A2,'LineWidth',3);
                    %                     set(gca,'FontSize',30);
                    %                     hold off;
                    %%
                    dataV1 = load ('pu3_C.2d');
                    [t,x,pressure,q,A,C] = gnuplot(dataV1);
                    P3 = pressure(:,floor((end)/2));  Q3 = q(:,floor((end)/2)); ...
                        A3 = A(:,floor((end)/2)); C3 = C(:,floor((end)/2));
                    
                    %%
                    pressures{iter}  = [P1 P2 P3];% P13 P15 P29 P30 P42 P45];
                    flows{iter}      = [Q1 Q2 Q3];% Q13 Q15 Q29 Q30 Q42 Q45];
                    areas{iter}      = [A1 A2 A3];% A13 A15 A29 A30 A42 A45];
                    wavespeeds{iter} = [C1 C2 C3];% C13 C15 C29 C30 C42 C45];
                end
                graph_pressure_id = graph_pressure_id+1;
            end
            
            iter = iter+1;
            perturbation_ID = perturbation_ID+1;
        end
    end
end
save('Geometry_UQ_Data_10gen_5000iter_lower30_smooth6.5.mat','pressures','flows','areas','wavespeeds','geometry');
% figure(11); axis([0 1024 8 37]); grid on;
% print('-depsc','All_pressures1_gen2.png');
% figure(21); axis([0 1024 8 37]); grid on;
% print('-depsc','All_pressures2_gen8.png');
% figure(31); axis([0 1024 8 37]); grid on;
% print('-depsc','All_pressures3_gen8.png');
% figure(12); axis([0 1024 -0.05 0.6]); grid on;
% print('-depsc','All_flows1_gen8.png');
% figure(22); axis([0 1024 -0.05 0.6]); grid on;
% print('-depsc','All_flows2_gen8.png');
% figure(32); axis([0 1024 -0.05 0.15]); grid on;
% print('-depsc','All_flows3_gen8.png');
toc
% save(filename,'data')

