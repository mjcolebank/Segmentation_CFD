%% This script will be used to understand the effects of connectivity, radius
% and length on model prediction. Here, we load each unique geometry and
% then evaluate the model.
%%
clc;
close all;
clear;
name1 = 'M1P4_lower';
name2 = '_smooth';
name3 = '_Data.mat';
theta1 = [22 25 26  26   26   27  28  29.9 30  30  30  31  31  32  33   33    34  34  35  35  35  36  36  37  43.6];
theta2 = [5   6 4.7 4.8  5.1  5.8 6   4.6 5.7 6.5  8  5.6 6.1 4.1 4.2  5.1   3.3 3.4 3.6 4.8 6.8  4  4.1 3.9 7.62];
num_params = length(theta1);
pressures = cell(num_params*8,3);
flows    = cell(num_params*8,3);
areas    = cell(num_params*8,3);
wavespeeds = cell(num_params*8,3);
BC_save = {};
RT_CT   = {};
filenames = {};
% THIS IS NEW: Only the last 3 have been added
vessels_included{1}  =  [0 1   31  151 71  32  90  89  109 91  179 219 182 224 220 225 244 231 226 193 197 196 110 111 112    135 186 216 243 237 53 66 63 94] + 2;
vessels_included{2}  =  [0 1   97  2   155 98  193 156 194 247 282 330 283 338 333 339 387 347 340 298 299 301 195 197 196    226 296 327 382 365 130 147 142 275] + 2;
vessels_included{3}  =  [0 1   107 2   108 228 109 195 110 168 283 327 284 328 429 390 329 398 391 296 300 299 165 166 167    148 289 308 400 419 275 253 264 190] + 2;
vessels_included{4}  =  [0 170 171 358 172 299 208 173 209 271 1   50   2  57  53 58  100   59 93  44  48  47  268 269 270    263 9   29   89 76  335 314 325 292] + 2;
vessels_included{5}  =  [0 169 170 361 171 298 205 172 206 268 1   50   2  52 164 53  94    54 89  17  21  19  265 267 266    216 13  36   78  72 352 332 343 291] + 2;
vessels_included{6}  =  [0 181 182 373 183 312 221 184 251 222 1   54   2  57 177 58  103   59 96  17  21  19  308 310 309    279  9  41   85  77 348 326 337 224] + 2;
vessels_included{7}  =  [0 134 198 135 242 199 270 243 298 271 1   38   2  44  39 45  77    53 46  6   7    9  299 300 301    345 35  29   61  65 237 227 234 274] + 2;
vessels_included{8}  =  [0 1   100 2   158 101 198 159 230 199 295 339 296 345 340 346 387  354 347 311 312 314 231 232 233   261 309 336 384 381 155 146 141 204] + 2;
vessels_included{9}  =  [0 181 182 388 183 321 224 184 256 225 1   54  2   60  56  61  110  69  62  48  52  51  257 258 259   291 9   30  109 87  365 336 331 227] + 2;
vessels_included{10} =  [0 183 184 393 185 326 186 285 187 253 1   56  2   58  178 59  112  60  103 17  21  20  250 252 251   227 9   39  90  78  366 341 352 255] + 2;
vessels_included{11} =  [0 1   98  2   152 99  188 153 222 189 281 323 282 329 324 330 369 340 331 297 298  300 223 224 225   244 288 320 366 365 149 137 146 194] + 2;
vessels_included{12} =  [0 183 286 184 348 287 349 448 381 350 1   52  2   59  55  60  109 61  100 46  50   49  382 383 384   420 8   32  71  76  294 313 324 353] + 2;
vessels_included{13}  = [0 127 128 259 129 220 153 130 154 197 1   38  2   39  122 40  71  41  64  32  36   35  155 157 156   188 8   23  63  57  243 231 236 199] + 2;
vessels_included{14}  = [0 166 261 167 262 382 263 349 295 264 1   48  2   55  51  123 56  131 124 42  46   45  346 348 347   319 8   33  161 145 415 397 392 288] + 2;
vessels_included{15}  = [0 175 176 375 177 312 217 178 218 283 1   50  2   56  52  130 57  131 168 17  21   20  279 281 280   262 9   36  165 146 365 338 349 306] + 2;
vessels_included{16}  = [0 198 199 418 200 347 242 201 243 315 1   56  2   63  59  144 64  145 186 50  51   53  310 312 311   262 10  38  147 152 355 373 384 338] + 2;
vessels_included{17}  = [0 1   117 2   118 261 120 217 121 185 332 333 384 385 387 391 442 402 393 379 383  381 182 184 183   151 342 365 405 413 270 286 297 210] + 2;
vessels_included{18}  = [0 193 194 388 195 330 232 196 233 297 1   56  2   63  59  64  110 65 103  9   13   11  294 296 295   244 49  33  77  82  350 358 369 323] + 2;
vessels_included{19}  = [0 1   105 2   169 106 170 268 206 171 305 356 307 357 475 358 404 359 395 339 343  341 207 208 209   240 352 318 391 366 115 131 126 174] + 2;
vessels_included{20}  = [0 184 185 382 186 313 187 277 188 246 1   56  2   64  59  135 65  145 136 8   12   10  243 245 244   217 48  26  180 149 320 339 334 249] + 2;
vessels_included{21}  = [0 149 150 330 203 151 243 204 271 244 1   46  2   52  48  113 53  121 114 15  19   17  272 273 274   304 9   27  146 141 184 168 163 246] + 2;
vessels_included{22}  = [0 1  102  2   160 103 200 161 232 201 297 343 298 349 344 350 385 358 351 302 306  305 233 234 235   259 342 329 382 371 156 147 144 206] + 2;
vessels_included{23} = [0 149 150  305 151 260 179 152 207 180 1   42  2   48  44  49  86  85  80  13  17   16  256 258 257   242 10  30  77  73  300 282 293 201] + 2;
vessels_included{24} = [0 1   94   2   150 95  188 151 222 189 285 331 286 337 332  338 373 346 339 301 302 304 223 224 225   253 299 323 370 357 147 123 120 194] + 2;
vessels_included{25} = [0 1   38   2   62  39  78  63  90  79  120 138 121 140 139  141 162 147 142 128 130 129 91  92  93    119 125 137 148 156 50  59  58  81] + 2;


%% From Density Cross Validation
% vessels_included{1}  =  [0 1   31 151 71 32 90  89 109 91  179 219 182 224 220 225 244 231 226] + 2;
% vessels_included{2}  =  [0 1   97 2   155 98 193  156 194 247 282 330 283 338 333 339 387 347 340] + 2;
% vessels_included{3}  =  [0 1   107 2  108 228 109 195 110 168 283 327 284 328 429 390 329 398 391] + 2;
% vessels_included{4}  =  [0 170 171 358 172 299 208 173 209 271 1   50   2  57  53 58 100 59 93] + 2;
% vessels_included{5}  =  [0 169 170 361 171 298 205 172 206 268 1   50   2  52 164 53 94 54 89] + 2;
% vessels_included{6}  =  [0 181 182 373 183 312 221 184 251 222 1   54   2 57 177 58 103 59 96] + 2;
% vessels_included{7} = [0 134 198  135 242 199 270 243 298 271 1  38   2   44 39   45 77 53 46] + 2;
% vessels_included{8} = [0 1 100 2  158 101 198 159 230 199 295 339 296  345 340 346 387  354 347] + 2;
% vessels_included{9}  =  [0 181 182 388 183 321 224 184 256 225 1 54   2  60  56   61 110 69 62] + 2;
% vessels_included{10}  =  [0 183 184 393 185 326 186 285 187 253 1 56   2  58 178   59 112 60 103] + 2;
% vessels_included{11} = [0 1 98 2  152 99 188 153 222 189  281 323 282 329 324 330 369 340 331] + 2;
% vessels_included{12}  = [0 183 286 184 348 287 349 448 381 350 1  52   2  59  55 60 109 61 100] + 2;
% vessels_included{13}  = [0 127 128 259 129 220 153 130 154 197 1  38   2  39 122 40 71 41 64] + 2;
% vessels_included{14}  = [0 166 261 167 262 382 263 349 295 264 1  48   2 55 51 123 56 131 124] + 2;
% vessels_included{15}  = [0 175 176 375 177 312 217 178 218 283  1  50   2     56 52 130 57 131 168] + 2;
% vessels_included{16}  = [0 198 199 418 200 347 242 201 243 315 1   56 2 63 59 144 64 145 186] + 2;
% vessels_included{17}  = [0 1   117 2   118 261 120 217 121 185 332 333 384 385 387 391 442 402 393] + 2;
% vessels_included{18}  = [0 193 194 388 195 330 232 196 233 297  1   56  2  63    59 64  110 65 103] + 2;
% vessels_included{19}  = [0 1   105 2   169 106 170 268 206 171 305 356 307 357 475 358 404 359 395] + 2;
% vessels_included{20}  = [0 184 185 382 186 313 187 277 188 246 1   56   2  64   59 135 65 145 136] + 2;
% vessels_included{21}  = [0 149 150 330 203 151 243 204 271 244 1   46   2 52 48  113 53 121 114] + 2;
% vessels_included{22}  = [0 1  102  2   160 103 200 161 232 201 297 343 298 349 344 350 385 358 351] + 2;
% vessels_included{23} = [0 149 150 305 151 260 179 152 207 180 1 42 2 48 44 49 86 85 80] + 2;
% vessels_included{24} = [0 1 94 2 150 95 188 151 222 189 285 331 286 337 332  338 373 346 339] + 2;
% vessels_included{25} = [0 1   38   2   62  39 78   63 90 79 120 138 121 140 139 141 162 147 142] + 2;




%%
Umar_info = cell(num_params+1,2);
% Umar_info{1,1} = 'CONNECTIVITY';
% Umar_info = {};
Umar_info{1,1} = 'VESSELS';
Umar_info{1,2} = 'NODES';
%% Cell of networks
net = cell(num_params,1);
save_id = 1;
for network_id=5:8%:num_params
    network = load(strcat(name1,num2str(theta1(network_id)),name2,num2str(theta2(network_id)),name3));
    connectivity = network.connectivity;
    max_iter = 1;
    max_pts = 1024;
    vessel_measurements = network.vessel_details;
    % connectivity = network.connectivity;
    %% Algorithm 7: Get simplified connectivity?
    disp(network_id);
    [simple_connectivity,terminal] = find_simple_connectivity(connectivity, vessel_measurements);% Has number for parent, daughter1, and daughter2
    %% Algorithm 8: Make Directed Grpah
    % make_directed_graph(simple_connectivity,terminal);
    %% Save files for Umar's directed graphs
    %
    % Umar_info{network_id+1,1} = simple_connectivity;
    % dimensions = {};
    % start_end  = {};
    % vessels = unique(simple_connectivity);
    % start_end_test = [];
    % for i=1:length(vessels)
    %    dimensions{end+1} =  vessel_measurements{vessels(i),2};
    % % %    start_end{end+1} = dimensions{end}([1 end],1:3);
    %    start_end_test(end+1,1:3) = dimensions{end}(1,1:3);
    %    start_end_test(end+1,1:3) = dimensions{end}(end,1:3);
    % end
    % Umar_info{network_id+1,1} = dimensions;
    % start_end = unique(start_end_test,'rows');
    % Umar_info{network_id+1,2} = start_end;
    % network_file = strcat('NetworkInformation_',num2str(network_id));
    % save(network_file,'Umar_info');
    %% Check the 3D graphs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% TO PLOT ON TOP OF EACH OTHER USE THIS
    %     rmax = 0.12;
    %     rmin = 0.08;
    %     figure(112233); hold on;
    %     for i=2:max(size(vessel_measurements))
    %         if i==2 && network_id == 16
    %             xyzorigin =  vessel_measurements{i,2}(1,1:3);
    %         elseif i==2
    %             xyzorigin = [vessel_measurements{i,2}(1,1:2) xyzorigin(3)];
    %         end
    %         if network_id == 25
    %             vessel_measurements{i,2}(:,1:3) = vessel_measurements{i,2}(:,1:3) - xyzorigin;
    %             half = round(size(vessel_measurements{i,2},1)./2);
    %             plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'o')
    %             text(vessel_measurements{i,2}(half,1),vessel_measurements{i,2}(half,2),vessel_measurements{i,2}(half,3), ...
    %                 vessel_measurements{i,1})
    %         else
    %             vessel_measurements{i,2}(:,1:3) = vessel_measurements{i,2}(:,1:3) - xyzorigin;
    %             half = round(size(vessel_measurements{i,2},1)./2);
    %             plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'o')
    %             text(vessel_measurements{i,2}(half,1),vessel_measurements{i,2}(half,2),vessel_measurements{i,2}(half,3), ...
    %                 vessel_measurements{i,1})
    %         end
    %     end
    %     figure(112233); hold on;
    %     for ii=vessels_included{network_id}
    %         half = round(size(vessel_measurements{ii,2},1)./2);
    %         plot3(vessel_measurements{ii,2}(:,1),vessel_measurements{ii,2}(:,2),vessel_measurements{ii,2}(:,3),'ko')
    %         text(vessel_measurements{ii,2}(half,1),vessel_measurements{ii,2}(half,2),vessel_measurements{ii,2}(half,3), ...
    %             vessel_measurements{ii,1})
    %     end
    %
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(10000 + network_id); clf; hold on;
    for i=2:max(size(vessel_measurements))
        %%
        half = round(size(vessel_measurements{i,2},1)./2);
        plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'o')
        text(vessel_measurements{i,2}(half,1),vessel_measurements{i,2}(half,2),vessel_measurements{i,2}(half,3), ...
            vessel_measurements{i,1})
    %     if vessel_measurements{i,4} < rmax && vessel_measurements{i,4} > rmin
    %             plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'ko')
    %     end
    end
    
    % Plot on the full network
    figure(10000 + network_id); hold on;
    for i=vessels_included{network_id}(17)
        half = round(size(vessel_measurements{i,2},1)./2);
        plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'ko')
        text(vessel_measurements{i,2}(half,1),vessel_measurements{i,2}(half,2),vessel_measurements{i,2}(half,3), ...
            vessel_measurements{i,1})
    end
    
    % Plot separately
    figure(20000 + network_id); clf; hold on;
    for i=vessels_included{network_id}
        half = round(size(vessel_measurements{i,2},1)./2);
        plot3(vessel_measurements{i,2}(:,1),vessel_measurements{i,2}(:,2),vessel_measurements{i,2}(:,3),'ko')
        text(vessel_measurements{i,2}(half,1),vessel_measurements{i,2}(half,2),vessel_measurements{i,2}(half,3), ...
            vessel_measurements{i,1})
    end
    
    %% For the sake of connectivity check, we need to order the connectivity in a way that
    % renumbers that connectivity in a better manner (and gives us bifurcations
    % near each other). Try doing it by generation
    % note: per generation, vessels increase (at most) by 2i. One vessel
    % will hence go to 2*1 = 2 new vessels, then at generation 2 we get 4.
    % Similarly, the size of the connectivity goes 1,3,7,15 (so up by 2 4 8
    % ect).
    generation = {};
    generation{end+1} = simple_connectivity(1,1);
    num_conn = 1;
    generation_find = {1,2:3,4:7,8:15,16:31,32:63, 64:127, 128:255, 256:511,512:1023,1024:2047};
    terminal_cell   = {};
    terminal_cell{end+1} = 1;
    new_daughters   = [2, 4, 8, 16, 32,64,128,256, 512, 1024];
    for i=1:11%length(simple_connectivity)
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% PICK HOW MANY GENERATIONS TO USE IN THE MODEL
    gen_ID=10%[2:10]
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
    dlmwrite('connectivity.txt',test_network-1,'\t');
    dlmwrite('terminal_vessels.txt',test_terminal-1,'\t');
    net{network_id} = test_network;
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
    dlmwrite('Dimensions.txt',dim_mat,'\t')
    
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
    %% Add a loop here to do the following: we want to reorder the
    % connectivity matrix and the terminal vessels so we get the
    % largest values first (i.e. vessel 27 before 1) so the C code can
    % parse it correctly.
    temp_terminal = sort(temp_terminal);
    [who,where] = sort(temp_network(:,1));
    temp_network = temp_network(where,:);
    dlmwrite('connectivity.txt',temp_network-1,'\t');
    dlmwrite('terminal_vessels.txt',temp_terminal-1,'\t');
    dlmwrite('Dimensions.txt',dim_mat,'\t')
    %Save the dimensions separately
    dlmwrite(strcat('Connectivity_',num2str(theta1(network_id)),'_',num2str(theta2(network_id)),'.txt'),temp_network-1,'\t');
    dlmwrite(strcat('Dimensions_',num2str(theta1(network_id)),'_',num2str(theta2(network_id)),'.txt'),dim_mat,'\t');
    
    
    
    starts = zeros(size(temp_network,1).*2,1);
    ends   = zeros(size(temp_network,1).*2,1);
    starts(1:size(temp_network,1),1) = temp_network(:,1)+1;
    ends(1:size(temp_network,1),1) = temp_network(:,2)+1;
    starts(size(temp_network,1)+1:end,1) = temp_network(:,1)+1;
    ends(size(temp_network,1)+1:end,1) = temp_network(:,3)+1;
    starts = [1; starts];
    ends   = [2; ends];
    G = digraph(starts,ends);
    %         figure; hold on;
    %         digraph_plot = subplot(1,2,1);
    %         cla(digraph_plot);
    %         hold on;
    %         h = plot(G);
    %         h.NodeColor = 'red';
    %         h.LineWidth = 3;
    %         h.MarkerSize = 8;
    %         h.EdgeAlpha = 0.8;
    %         set(gca,'FontSize',30);
    %         hold off;
    figure(1000+network_id); clf;
    h2 = plot(G,'Layout','layered','Direction','down');
    h2.NodeColor = 'red';
    h2.LineWidth = 3;
    h2.MarkerSize = 8;
    h2.EdgeAlpha = 0.8;
    h2.NodeLabel = {};
    h2.EdgeLabel = {};
    xticklabels({})
    yticklabels({})
    set(gca,'FontSize',30);
    
    
    
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
    % Added step to check if we are conserving resistance
    conserved_mat = zeros(length(temp_network(:,1)),6);
    for k=1:length(temp_network(:,1))
        conserved_mat(k,1) = Rtotal(temp_network(k,1));
        conserved_mat(k,2) = Rtotal(temp_network(k,2));
        conserved_mat(k,3) = Rtotal(temp_network(k,3));
        conserved_mat(k,4) = 1./( (1./conserved_mat(k,2)) + (1./conserved_mat(k,3)));
        conserved_mat(k,5) = CT(temp_network(k,1));
        conserved_mat(k,6) = CT(temp_network(k,2)) + CT(temp_network(k,3));
    end
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
    dlmwrite(strcat('WK_',num2str(theta1(network_id)),'_',num2str(theta2(network_id)),'.txt'),dim_mat,'\t');
    cross_area = sum(pi.*R(1).^2);
    Ehr0 = con_factor.*((0.8)*(cross_area.^2)*(Pnd./Qnd).^2./rho);
    f3=round(unifrnd(log(Ehr0),log(6e8),100,1),1); %% Generally from 1e4 to 1e7
    f3 = exp(f3);
    bestfit = f3(1);
    cost = 10^6;
    simulation = zeros(4,7,1024);
    tic
    f3 = 5e+05;%[6e+04:5000:1e+7];
    
    %%%%%%% THIS IS FOR A SIMPLE BIFURCATION!!!!! %%%%%%%%%%%
    %% MANUAL BIFURCATION
    % dim_mat = dim_mat(simple_connectivity,:);
    % dlmwrite('Dimensions.txt',dim_mat,'\t');
    % simple_connectivity = [0 1 2];
    % terminal = [1;2];
    % dlmwrite('connectivity.txt',simple_connectivity,'\t');
    % dlmwrite('terminal_vessels.txt',terminal','\t');
    % num_vessels = 3;
    % num_terminal = 2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        first_iteration_flag = 0;
        %%
        %     unix(sprintf('make clean'));
        %     unix(sprintf('make'));
        param_curr = param(:,1);
        p = num2cell(param_curr); % Tells you how many geometries have satisfied your constraint.
        
        %% Inputs are sor06, # vessels, # terminal, and stiffness
        tic
%         unix(sprintf( strcat('./sor06',sprintf(' %f %f %g ', num_vessels, num_terminal, f3) ) ) );
        toc
%         dataV1 = load ('pu1_C.2d');
        if 0==0%isempty(dataV1)
            warning('Code crashed\n')
        else
            %plot the first vessel
            [t,x,pressure,q,A,C] = gnuplot(dataV1);
            P1 = pressure(:,floor((end)/2));  Q1 = q(:,floor((end)/2)); ...
                A1 = A(:,floor((end)/2)); C1 = C(:,floor((end)/2));
            figure(101); hold on;
            plot(P1,'LineWidth',3);
            set(gca,'FontSize',30);
            hold off;
            figure(1000);hold on;
            subplot(1,2,2);
            plot(P1,'LineWidth',3);
            axis([0 1024 8 max(P1)+2])
            set(gca,'FontSize',30);
            print('-depsc',strcat('Network',num2str(graph_pressure_id-19),'.eps'));
            hold off;
            figure(102); hold on;
            plot(Q1,'LineWidth',3);
            set(gca,'FontSize',30);
            hold off;
            figure(103); hold on;
            plot(A1,'LineWidth',3);
            set(gca,'FontSize',30);
            hold off;
            figure(104); hold on;
            strain = (1 - sqrt(min(A1)./A1));
            plot(P1,strain,'LineWidth',3);
            set(gca,'FontSize',30);
            hold off;
            %plot the second and third vessels
            dataV1 = load ('pu2_C.2d');
            if~isempty(dataV1)
                [t,x,pressure,q,A,C] = gnuplot(dataV1);
                P2 = pressure(:,floor((end)/2));  Q2 = q(:,floor((end)/2)); ...
                    A2 = A(:,floor((end)/2)); C2 = C(:,floor((end)/2));
                figure(201); hold on;
                plot(P2,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(202); hold on;
                plot(Q2,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(203); hold on;
                plot(A2,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(204); hold on;
                strain = (1 - sqrt(min(A2)./A2));
                plot(P2,strain,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                dataV1 = load ('pu3_C.2d');
                [t,x,pressure,q,A,C] = gnuplot(dataV1);
                P3 = pressure(:,floor((end)/2));  Q3 = q(:,floor((end)/2)); ...
                    A3 = A(:,floor((end)/2)); C3 = C(:,floor((end)/2));
                figure(301); hold on;
                plot(P3,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(302); hold on;
                plot(Q3,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(303); hold on;
                plot(A3,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
                figure(304); hold on;
                strain = (1 - sqrt(min(A3)./A3));
                plot(P3,strain,'LineWidth',3);
                set(gca,'FontSize',30);
                hold off;
            end
            graph_pressure_id = graph_pressure_id+1;
        end
        
    
%     pressures{save_id,1} = P1; pressures{save_id,2} = P2; pressures{save_id,3} = P3;
%     flows{save_id,1} = Q1; flows{save_id,2} = Q2; flows{save_id,3} = Q3;
%     areas{save_id,1} = A1; areas{save_id,2} = A2; areas{save_id,3} = A3;
%     wavespeeds{save_id,1} = C1; wavespeeds{save_id,2} = C2; wavespeeds{save_id,3} = C3;
    %
%     BC_save{end+1} = BC_matrix;
%     RT_CT{end+1}   = [Rtotal CT];
%     save_id = save_id + 1;
end
% save('Network25_BCs_fullgenerations.mat','BC_save');
% save('Network25_RTCT_fullgenerations.mat','RT_CT');
% save('Network25_Simulations_fullgenerations.mat','pressures','flows','areas','wavespeeds','BC_matrix')
figure(101); axis tight;%([0 1000 8 32]);
% print('-depsc','All_pressures1_stiffmed.png');
figure(201);axis tight;%([0 1000 8 32]);
% print('-depsc','All_pressures2_stiffmed.png');
figure(301);axis tight;%([0 1000 8 32]);
% print('-depsc','All_pressures3_stiffmed.png');
figure(102); axis tight;%([0 1000 -0.03 0.6]);
% print('-depsc','All_flows1_stiffmed.png');
figure(202);axis tight;%([0 1000 -0.03 0.5]);
% print('-depsc','All_flows2_stiffmed.png');
figure(302);axis tight;%([0 1000 -0.03 0.15]);
% print('-depsc','All_flows3_stiffmed.png');
toc


