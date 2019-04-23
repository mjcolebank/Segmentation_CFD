%% This script will be used to understand the effects of connectivity on a
%  system of blood vessels, where we assume that the radius,length, and
%  connectivity are subject to uncertainty about their measurment and
%  population average. MJC 1/29/18
%%
% clc;
close all;
clear;
%% DETERMINES HOW MANY GENERATIONS YOU WANT TO HAVE TO BEGIN WITH
gen_ID = 12;
%%
name1 = 'M1P4_lower';
name2 = '_smooth';
name3 = '_Data.mat';
% theta1 = [22 24 25 27 29 29.87 30 32 33  34  34  35  35  35  36 36 36   37   43.6]; %35 3.6 needs to be fixed
% theta2 = [5   3  6  3  3 4.56   8  3 5.1 3.3 3.4 3.6 4.8 6.8  3  4  4.1 3.92  7.62];
theta1 = [22 25 26  26   26   27  28  29.9 30  30  30  31  31  32  33   33    34  34  35  35  35  36  36  37  43.6];
theta2 = [5   6 4.7 4.8  5.1  5.8 6   4.6 5.7 6.5  8  5.6 6.1 4.1 4.2  5.1   3.3 3.4 3.6 4.8 6.8  4  4.1 3.9 7.62];
theta1 = theta1(16);
theta2 = theta2(16);
for network_id=1:length(theta1)
    filename = strcat(name1,num2str(theta1(network_id)),name2,num2str(theta2(network_id)),name3);
    network = load(filename);
    connectivity = network.connectivity;
    max_iter = 1;
    max_pts = 1024;
    vessel_measurements = network.vessel_details;
    time = linspace(0,0.11,1024);
    P_all = {}; Q_all = {}; A_all = {}; C_all = {};
    network_figure = 1;
    G = {}; %For all the graphs
    BC_all = {};% Store boundary conditions
    dim_all = {};% store dimensions
    conserved_all = {}; %For checking to ensure boundary conditions are perserved
    % connectivity = network.connectivity;
    %% Algorithm 7: Get simplified connectivity?
    [simple_connectivity,terminal] = find_simple_connectivity(connectivity, vessel_measurements);% Has number for parent, daughter1, and daughter2
    %% Algorithm 8: Make Directed Grpah
    %     make_directed_graph(simple_connectivity,terminal);
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
    generation_find = {1,2:3,4:7,8:15,16:31,32:63,64:127,128:255,256:511,512:1023,1024:2047};
    terminal_cell   = {};
    terminal_cell{end+1} = 1;
    new_daughters   = [2, 4, 8, 16, 32, 64, 128, 256, 512,1024,2048];
    for i=1:12%length(simple_connectivity)
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
        else %Ensure the right and left principal pathways are perserved
            d1 = simple_connectivity(1,2);
            d2 = simple_connectivity(1,3);
            if vessel_measurements{d1,4} > vessel_measurements{d2,4}
                generation{end+1} = simple_connectivity(1,:);
            else
                simple_connectivity(1,2:3) = simple_connectivity(1,[3 2]);
                generation{end+1} = simple_connectivity(1,:);
            end
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
    test_network = generation{gen_ID};
    test_terminal = terminal_cell{gen_ID};
    %% Define the connectivity
    vessel_ids = unique(test_network)';
    num_vessels = max(size(unique(test_network)));%size(vessel_measurements,1)-1;%length(vessels_21);
    measurements = zeros(num_vessels,2);
    big_R        = cell(num_vessels,1);
    %     mean_XYZ     = zeros(num_vessels,3);
    %     XYZ          = cell(num_vessels,1);
    for i=1:num_vessels %Go back through and reassign number (so you don't have 1 2 and 800 has your vessel #s)
        if any(test_network == i)
        else
            where_greater = find(test_network > i);
            min_of = min(test_network(where_greater));
            where_min = find(test_network == min_of);
            N_vessel = length(vessel_measurements{test_network(where_min(1)),2}(:,4));
            vessel_start = max(1,round(N_vessel.*0.1));
            vessel_end   = round(N_vessel.*0.8);
            measurements(i,1) = round(vessel_measurements{test_network(where_min(1)),3}.*0.1,3);
            measurements(i,2) = round(vessel_measurements{test_network(where_min(1)),4}.*0.1,3);
            %             mean_XYZ(i,:)     = mean(vessel_measurements{test_network(where_min(1)),2}(vessel_start:vessel_end,1:3));
            %             XYZ{i}            = vessel_measurements{test_network(where_min(1)),2}(:,1:3);
            big_R{i,1}        = vessel_measurements{test_network(where_min(1)),2}(vessel_start:vessel_end,4).*0.1;
            test_network(where_min) = i;
            if any(test_terminal == min_of)
                where_term = find(test_terminal == min_of);
                test_terminal(where_term) = i;
            end
        end
    end
    
    %% THE MOST IMPORTANT STEP: Go back and fix indicies once the trifurcations have been dealt with
    dlmwrite('connectivity.txt',test_network-1,'\t');
    dlmwrite('terminal_vessels.txt',test_terminal-1,'\t');
    %%
    num_terminal = length(test_terminal);
    dim_mat = zeros(num_vessels,2);
    id = 1;
    for i=1:num_vessels
        L(i) = measurements(i,1);%round(vessel_measurements{vessels_21(i),3}.*0.1,3);
        R(i) = measurements(i,2);%round(vessel_measurements{vessels_21(i),4}.*0.1,3);
        %% VERY IMPORTANT TO INCLUDE THIS FOR SIMULATIONS
        if L(i) < 0.025
            L(i) = 0.025;
        end
        dim_mat(id,:) = [L(i) R(i)];
        id = id+1;
    end
    
    
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
    % Make a loop here to take out single bifurcations based on radii
    temp_network = test_network; %Make a temporary network that will be reduced
    temp_terminal = test_terminal;%Make a temporary terminal array that will be reduced
    size_network = size(temp_network,1);
    first_iteration_flag = 1; %Run the full network once
    graph_pressure_id = 20;
    num_terminal = length(temp_terminal);
    while size_network > 1
        if size_network == 1
            dim_mat = [L(1) R(1)];
            dlmwrite('Dimensions.txt',dim_mat,'\t');
            num_vessels = 1;
            num_terminal = 1;
            temp_network = [1 0 0];
            size_network = -1;
        elseif first_iteration_flag~=1 %Edit connectivity by collapsing one bif
            terminal_leng = length(temp_terminal);
            terminal_row = zeros(terminal_leng,3);
            % Find where all the terminal vessels are and then save their
            % location and their volume for truncation.
            for i = 1:terminal_leng
                [where_row,where_col] = find(temp_terminal(i) == temp_network);%(:,2:3)
                terminal_row(i,1:2) = [where_row,where_col];
                terminal_row(i,3) = L(temp_terminal(i)).*R(temp_terminal(i)).^2;
            end
            %             unique_terminal = unique(terminal_row(:,1));
            %             vol_comp = zeros(length(unique_terminal),3);
            %             for k=1:length(unique_terminal)
            %                 where = find(unique_terminal(k) == terminal_row(:,1)); %Find where the terminal vessel is
            %                 if length(where) == 1 %This ensures that we only reduce bifurcations
            %                     vol_comp(k,1) = unique_terminal(k);
            % %                     vol_comp(k,2) = unique_terminal(k);
            %                     vol_comp(k,2) = terminal_row(where(1),2);
            %                 end
            %             end
            %             [who,where] = sort(vol_comp(:,2),'ascend');
            % Sort the volume measurements
            [who,where] = sort(terminal_row(:,3),'ascend');
            % Need to now see if multiple branches have the same volume:
            % If so, we take the branch furthest downstream (e.g., biggest
            % number in the structure)
            select_branch = max(where(find(who(1) == who)));
            %% Add loop here to make sure youi don't remove MPA
            % The branch that needs to be collapsed
            collapse_branch = terminal_row(max(select_branch),1);
            parent = temp_network(collapse_branch,1);
            if parent == 1
                select_branch = max(where(find(who(1) == who)));
                collapse_branch = terminal_row(max(select_branch),1);
                parent = temp_network(collapse_branch,1);
            end
            % Find the daughter branches that are/are NOT going to be collapsed
            daughter_remove = temp_terminal(select_branch);
            daughter_keep = temp_network(collapse_branch, ...
                find(temp_network(collapse_branch,2:3)~=daughter_remove)+1);
            % Now, we want to append the length and radius to the parent,
            % and get rid of the bifurcation in the connectivity matrix
            new_L = L(parent) + L(daughter_keep);
            new_R = mean([big_R{parent};big_R{daughter_keep}]);
            deltaR = (R(parent)-new_R)./R(parent)
            L(parent) = round(new_L,3);
            R(parent) = round(new_R,3);
            L([daughter_keep daughter_remove]) = [];
            R([daughter_keep daughter_remove]) = [];
            % Remove terminal branches from indexing (could be both
            % daughters)
            terminal_remove = [select_branch; find(temp_terminal == daughter_keep)];
            %             temp_network;
            if length(terminal_remove)==1
                % Need to get rid of the terminal branch and then adjust
                % all other vessels in the tree.
                temp_terminal(terminal_remove) = [];
                temp_network(collapse_branch,:) = [];
                size_network = size(temp_network,1);
                num_vessels = num_vessels - 2;
                num_terminal = num_terminal - 1;
            else
                % Need to get rid of the two terminal branches for the
                % daughters and replace it with the parent/daughter combo.
                temp_terminal(min(terminal_remove)) = parent;
                temp_terminal(max(terminal_remove)) = [];
                temp_network(collapse_branch,:) = [];
                size_network = size(temp_network,1);
                num_vessels = num_vessels - 2;
                num_terminal = num_terminal - 1;
            end
            %             parent
            %             daughter_keep
            %             daughter_remove
            
            %% Added for sanity check: plot 3D structures with collapsing vessels
            %             figure; hold on;
            %             for i=1:num_vessels+2
            %                 if i== daughter_keep
            %                     plot3(XYZ{i}(:,1),XYZ{i}(:,2),XYZ{i}(:,3),'bo');
            %                 elseif i==daughter_remove
            %                     plot3(XYZ{i}(:,1),XYZ{i}(:,2),XYZ{i}(:,3),'ro');
            %                 elseif i== parent
            %                     plot3(XYZ{i}(:,1),XYZ{i}(:,2),XYZ{i}(:,3),'go');
            %                 else
            %                     plot3(XYZ{i}(:,1),XYZ{i}(:,2),XYZ{i}(:,3),'ko');
            %                 end
            %                 text(XYZ{i}(1,1),XYZ{i}(1,2),XYZ{i}(1,3),strcat('V',num2str(i)),'Fontsize',20);
            %             end
            %             XYZ{daughter_remove} = {};
            %             if iscell([XYZ{parent}; XYZ{daughter_keep}])
            %                 XYZ{parent} = cell2mat([XYZ{parent}; XYZ{daughter_keep}]);
            %             else
            %                 XYZ{parent} = [XYZ{parent}; XYZ{daughter_keep}];
            %             end
            %             XYZ{daughter_keep} = {};
            %             XYZ_new = {};
            %             XYZ_old = XYZ;
            %             for i=1:num_vessels+2
            %                 if ~isempty(XYZ{i})
            %                     XYZ_new{end+1} = XYZ{i};
            %                 else
            %                     i
            %                 end
            %             end
            %             XYZ = XYZ_new;
            
            %             R_conserved       = 1./ (1./Rtotal(collapse_d1) + 1./Rtotal(collapse_d2))
            for k=1:size_network %GO BACK AND RENUMBER
                if temp_network(k,1) > parent
                    temp_network(k,1) = temp_network(k,1) - 1;
                end
                if temp_network(k,2) > parent
                    temp_network(k,2) = temp_network(k,2) - 1;
                end
                if temp_network(k,3) > parent
                    temp_network(k,3) = temp_network(k,3) - 1;
                end
                if temp_network(k,1) >= daughter_remove
                    temp_network(k,1) = temp_network(k,1) - 1;
                end
                if temp_network(k,2) >= daughter_remove
                    temp_network(k,2) = temp_network(k,2) - 1;
                end
                if temp_network(k,3) >= daughter_remove
                    temp_network(k,3) = temp_network(k,3) - 1;
                end
            end
            %             temp_network
            for k=1:num_terminal
                if temp_terminal(k) > parent
                    temp_terminal(k) = temp_terminal(k) - 1;
                end
                if temp_terminal(k) >= daughter_remove
                    temp_terminal(k) = temp_terminal(k) - 1;
                end
            end
            num_terminal = length(temp_terminal);
            r4l     = zeros(num_vessels,1);
            Q       = zeros(num_vessels,1);
            Rtotal  = zeros(num_vessels,1);
            R1      = zeros(num_vessels,1);
            R2      = zeros(num_vessels,1);
            CT      = zeros(num_vessels,1);
            dim_mat = [L;R]';
            dlmwrite('Dimensions.txt',dim_mat,'\t')
        else
            %             figure; hold on;
            %             for i=1:num_vessels
            %                 plot3(XYZ{i}(:,1),XYZ{i}(:,2),XYZ{i}(:,3),'ko');
            %                 text(XYZ{i}(1,1),XYZ{i}(1,2),XYZ{i}(1,3),strcat('V',num2str(i)),'Fontsize',20);
            %             end
            first_iteration_flag = 0;
            r4l     = zeros(num_vessels,1);
            Q       = zeros(num_vessels,1);
            Rtotal  = zeros(num_vessels,1);
            R1      = zeros(num_vessels,1);
            R2      = zeros(num_vessels,1);
            CT      = zeros(num_vessels,1);
            dlmwrite('Dimensions.txt',dim_mat,'\t')
        end
        dim_all{end+1} = dim_mat;
        %% Add a loop here to do the following: we want to reorder the
        % connectivity matrix and the terminal vessels so we get the
        % largest values first (i.e. vessel 27 before 1) so the C code can
        % parse it correctly.
        temp_terminal = sort(temp_terminal);
        [who,where] = sort(temp_network(:,1));
        temp_network = temp_network(where,:);
        dlmwrite('connectivity.txt',temp_network-1,'\t');
        dlmwrite('terminal_vessels.txt',temp_terminal-1,'\t');
        
        
        
        
        starts = zeros(size(temp_network,1).*2,1);
        ends   = zeros(size(temp_network,1).*2,1);
        starts(1:size(temp_network,1),1) = temp_network(:,1);
        ends(1:size(temp_network,1),1) = temp_network(:,2);
        starts(size(temp_network,1)+1:end,1) = temp_network(:,1);
        ends(size(temp_network,1)+1:end,1) = temp_network(:,3);
        
        % Use this to make it look more like a tree
        %         starts = [1; starts+1];
        %         ends = [2; ends+1];
        if ~any(ends == 0)
            G{end+1} = digraph(starts,ends);
            %             figure;
            %             Gplot = plot(G{end},'Layout','layered','Direction','down');
            %             labelnode(Gplot,1:num_vessels,1:num_vessels);
            
        end
        
        for i=1:num_vessels
            r4l(i) = (R(i).^4)./L(i);
        end
        conn_inc = 1;
        %%If any parameters are zero or INF, its because those vessels are unused
        for i=temp_network(:,1)'
            if i==1
                Q(i) = Qnd;
            end
            if any(temp_network(:,1) == i) && size(temp_network,2) > 1 && temp_network(1,2) ~= 0
                d1 = temp_network(conn_inc,2); %Assign Daughters
                d2 = temp_network(conn_inc,3);
                Q(d1) = Q(i)*r4l(d1)./(r4l(d1) + r4l(d2));
                Q(d2) = Q(i)*r4l(d2)./(r4l(d1) + r4l(d2));
                conn_inc = conn_inc + 1;
            end
        end
        clear Rtotal R1 R2 CT
        for i=1:num_vessels
            Rtotal(i) = Pnd./Q(i);
            R1(i) = round(ratio.*Rtotal(i),4);
            R2(i) = round(Rtotal(i)-R1(i),4);
            CT(i) = tau./Rtotal(i);
        end
        % Added step to check if we are conserving resistance
        conserved_mat = zeros(length(temp_network(:,1)),6);
        if num_vessels > 1
            for k=1:length(temp_network(:,1))
                conserved_mat(k,1) = Rtotal(temp_network(k,1));
                conserved_mat(k,2) = Rtotal(temp_network(k,2));
                conserved_mat(k,3) = Rtotal(temp_network(k,3));
                conserved_mat(k,4) = 1./( (1./conserved_mat(k,2)) + (1./conserved_mat(k,3)));
                conserved_mat(k,5) = CT(temp_network(k,1));
                conserved_mat(k,6) = CT(temp_network(k,2)) + CT(temp_network(k,3));
            end
        end
        conserved_all{end+1} = conserved_mat;
        %         figure(10001); subplot(1,2,1); hold on;
        %         plot(num_vessels,sum(conserved_mat(:,4)),'*');
        %         subplot(1,2,2); hold on;
        %         plot(num_vessels,sum(1./conserved_mat(:,4)),'*');
        %
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
        BC_all{end+1} = [temp_terminal', BC_matrix];
        f3 = 5e+05;
        
        %%%%%%% THIS IS FOR A SIMPLE BIFURCATION!!!!! %%%%%%%%%%%
        %%
        param_curr = param(:,1);
        p = num2cell(param_curr); % Tells you how many geometries have satisfied your constraint.
        
        %% Inputs are sor06, # vessels, # terminal, and stiffness
        %             tic
        %             fprintf('Number of vessels: %f\n',num_vessels);
        %             unix(sprintf( strcat('./sor06',sprintf(' %f %f %g ', num_vessels, num_terminal, f3) ) ) );
        %             toc
        dataV1 = [];%load ('pu1_C.2d');
        if isempty(dataV1)
        else
            %plot the first vessel
            [t,x,pressure,q,A,C] = gnuplot(dataV1);
            P1 = pressure(:,floor((end)/2));  Q1 = q(:,floor((end)/2)); ...
                A1 = A(:,floor((end)/2)); C1 = C(:,floor((end)/2));
            figure(101); hold on;
            plot(time,P1,'LineWidth',3);
            set(gca,'FontSize',30);
            hold off;
            %%
            %                 figure(1000);hold on;
            %                 subplot(1,2,2);
            %                 plot(time,P1,'LineWidth',5);
            %                 axis([0 0.11 9 23]);
            %                 grid on;
            %                 set(gca,'FontSize',30);
            %                 %                 print('-depsc',strcat('Network',num2str(graph_pressure_id-19),'.eps'));
            %                 hold off;
            %                 figure(102); hold on;
            %                 plot(time,Q1,'LineWidth',3);
            %                 set(gca,'FontSize',30);
            %                 hold off;
            %                 figure(103); hold on;
            %                 plot(time,A1,'LineWidth',3);
            %                 set(gca,'FontSize',30);
            %                 hold off;
            %                 figure(104); hold on;
            %                 strain = (1 - sqrt(min(A1)./A1));
            %                 plot(P1,strain,'LineWidth',3);
            %                 set(gca,'FontSize',30);
            %                 hold off;
            %plot the second and third vessels
            dataV1 = load ('pu2_C.2d');
            if~isempty(dataV1) && num_vessels > 1
                [t,x,pressure,q,A,C] = gnuplot(dataV1);
                P2 = pressure(:,floor((end)/2));  Q2 = q(:,floor((end)/2)); ...
                    A2 = A(:,floor((end)/2)); C2 = C(:,floor((end)/2));
                %                     figure(201); hold on;
                %                     plot(time,P2,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(202); hold on;
                %                     plot(time,Q2,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(203); hold on;
                %                     plot(time,A2,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(204); hold on;
                %                     strain = (1 - sqrt(min(A2)./A2));
                %                     plot(P2,strain,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                dataV1 = load ('pu3_C.2d');
                [t,x,pressure,q,A,C] = gnuplot(dataV1);
                P3 = pressure(:,floor((end)/2));  Q3 = q(:,floor((end)/2)); ...
                    A3 = A(:,floor((end)/2)); C3 = C(:,floor((end)/2));
                %                     figure(301); hold on;
                %                     plot(time,P3,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(302); hold on;
                %                     plot(time,Q3,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(303); hold on;
                %                     plot(time,A3,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                %                     figure(304); hold on;
                %                     strain = (1 - sqrt(min(A1)./A1));
                %                     plot(P1,strain,'LineWidth',3);
                %                     set(gca,'FontSize',30);
                %                     hold off;
                P_all{end+1} = [P1 P2 P3];
                Q_all{end+1} = [Q1 Q2 Q3];
                A_all{end+1} = [A1 A2 A3];
                C_all{end+1} = [C1 C2 C3];
            end
            graph_pressure_id = graph_pressure_id+1;
        end
        
        
    end
    %     savename = strcat('Connectivity_Data_new',num2str(theta1(network_id)),'_',num2str(theta2(network_id)),'.mat');
    %     save(savename,'P_all','Q_all','A_all','C_all','G')
    %     figure(101); axis([0 0.11 8 23]); grid on;
    %     print('-depsc','All_pressures1.eps');
    % figure(201);axis([0 0.11 8 23]); grid on;
    % print('-depsc','All_pressures2.eps');
    % figure(301);axis([0 0.11 8 23]); grid on;
    % print('-depsc','All_pressures3.eps');
    % figure(102); axis([0 0.11 -0.03 0.6]);grid on;
    % print('-depsc','All_flows1.eps');
    % figure(202);axis([0 0.11 -0.03 0.5]);grid on;
    % print('-depsc','All_flows2.eps');
    % figure(302);axis([0 0.11 -0.03 0.15]);grid on;
    % print('-depsc','All_flows3.eps');
    % toc
    % save(filename,'data')
end
