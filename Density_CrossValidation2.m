%% Do cross validation on the bandwidth parameter 

%% Step one: Maximize the bandwidth for the whole set of density
clear; clc; close all;
addpath('from Mihaela/')
plot_sym = {'ks','rs','bs','cs','k*','r*','b*','c*','k+','r+','b+','c+','ko',...
            'ro','bo','co','kd','rd','bd','cd','k^','r^','b^','c^','k<','r<','b<','c<'};
conn_name = 'Connectivity_';
dim_name  = 'Dimensions_';
theta1 = [22 25 26  26   26   27  28  29.9 30  30  30  31  31  32  33   33    34  34  35  35  35  36  36  37  43.6];
theta2 = [5   6 4.7 4.8  5.1  5.8 6   4.6 5.7 6.5  8  5.6 6.1 4.1 4.2  5.1   3.3 3.4 3.6 4.8 6.8  4  4.1 3.9 7.62];
num_par = length(theta1);
%%%%%%%%%% LOAD SCALING IF YOU WANT TO CONVERT TO PIXELS
load('ScalingValues.mat');
%% 1 or 0, if you want to scale;
scale_flag = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Vessels to compare
name1 = 'M1P4_lower';
name2 = '_smooth';
name3 = '_Data.mat';
% THIS IS NEW
%% THIS IS OLD
% vessels_included{1}  =  [0 1   31 151 71 32 90  89 109 91  179 219 182 224 220 225 244 231 226] + 2;
% vessels_included{2}  =  [0 1   97 2   155 98 193  156 194 247 282 330 283 338 333 339 386 347 340] + 2;
% vessels_included{3}  =  [0 1   107 2  108 228 109 195 110 168 283 327 284 328 429 390 329 398 391] + 2;
% vessels_included{4}  =  [0 170 171 358 172 299 208 173 209 271 1   50   2  57  53 58 100 59 93] + 2;
% vessels_included{5}  =  [0 169 170 361 171 298 205 172 206 268 1   50   2  52 164 53 94 54 89] + 2;
% vessels_included{6}  =  [0 181 182 373 183 312 221 184 251 222 1   54   2 57 177 58 103 59 96] + 2;
% vessels_included{7} = [0 134 198  135 242 199 270 243 298 271 1  38   2   44 39   45 77 53 46] + 2;
% vessels_included{8} = [0 1   72    2  114 73  144 115 172 145 231 269 232 273 270 274 296 280 275] + 2;
% vessels_included{9}  =  [0 181 182 388 183 321 224 184 256 225 1 54   2  60  56   61 110 69 62] + 2;
% vessels_included{10}  =  [0 183 184 393 185 326 186 285 187 253 1 56   2  58 178   59 112 60 103] + 2;
% vessels_included{11} = [0 1   60    2  96  61  114 97 137 115  189 223 190 227 224 228 251 234 229] + 2;
% vessels_included{12}  = [0 183 286 184 348 287 349 448 381 350 1  52   2  59  55 60 109 61 100] + 2;
% vessels_included{13}  = [0 127 128 259 129 220 153 130 154 197 1  38   2  39 122 40 71 41 64] + 2;
% vessels_included{14}  = [0 166 261 167 262 382 263 349 295 264 1  48   2 55 51 123 56 131 124] + 2;
% vessels_included{15}  = [0 175 176 375 177 312 217 178 218 283  1  50   2 56 52 130 57 131 168] + 2;
% vessels_included{16}  = [0 196 197 416 198 345 240 199 241 313  1   56  2 63 59 144 64 145 186] + 2;
% vessels_included{17}  = [0 1 117 2 118 260 119 216 120 184 331 381 332 388 384 389 438 399 390] + 2;
% vessels_included{18}  = [0 183 184 380 185 319 221 186 222 286 1 56 2 63 59 64 108 65 101 ] + 2;
% vessels_included{19}  = [0 1   105 2   169 106 170 268 206 171 305 355 306 356 470 357 403 358 394] + 2;
% vessels_included{20}  = [0 182 183 379 184 312 185 277 186 246  1  56   2  64   59 133 65 143 134] + 2;
% vessels_included{21}  = [0 150 151 326 203 152 241 204 269 242 1    46   2  52  48 114  53 122 115] + 2;
% vessels_included{22}  = [0 1  102  2   160 103 200 161 232 201 297 343 298 349 344 350 385 358 351] + 2;
% vessels_included{23} = [0 146 147 305  148 258 176 149 206 177 1   42   2   48 44   49 85 50 80] + 2;
% vessels_included{24} = [0 1   36    2  58  37  72  59 82 73  105 123 106 125 124 126 141 130 127] + 2;
% vessels_included{25} = [0 1   38   2   62  39 78   63 90 79 120 138 121 140 139 141 162 147 142] + 2;
%% BRAND NEW 34 VESSEL SYSTEM
% vessels_included{1}  =  [0 1   31 151 71 32 90    89 109 91  179 219 182 224 220 225 244 231 226 193 197 196 110 111 112      135 186 216 216 243 237 53 66 63 94] + 2;
% vessels_included{2}  =  [0 1   97 2   155 98 193  156 194 247 282 330 283 338 333 339 387 347 340 298 299 301 195 197 196     226 296 327 382 365 130 147 142 275] + 2;
% vessels_included{3}  =  [0 1   107 2  108 228 109 195 110 168 283 327 284 328 429 390 329 398 391 296 300 299 165 166 167     148 289 308 400 419 275 253 264 190] + 2;
% vessels_included{4}  =  [0 170 171 358 172 299 208 173 209 271 1   50   2  57  53 58  100   59 93  44  48  47  268 269 270    263 9   29   89 76  335 314 325 292] + 2;
% vessels_included{5}  =  [0 169 170 361 171 298 205 172 206 268 1   50   2  52 164 53  94    54 89  17  21  19  265 267 266    216 13  36   78  72 352 332 343 291] + 2;
% vessels_included{6}  =  [0 181 182 373 183 312 221 184 251 222 1   54   2  57 177 58  103   59 96  17  21  19  308 310 309    279  9  41   85  77 348 326 337 224] + 2;
% vessels_included{7}  =  [0 134 198 135 242 199 270 243 298 271 1   38   2  44  39 45  77    53 46  6   7    9  299 300 301    345 35  29   61  65 237 227 234 274] + 2;
% vessels_included{8}  =  [0 1   100 2   158 101 198 159 230 199 295 339 296 345 340 346 387  354 347 311 312 314 231 232 233   261 309 336 384 381 155 146 141 204] + 2;
% vessels_included{9}  =  [0 181 182 388 183 321 224 184 256 225 1   54  2   60  56  61  110  69  62  48  52  51  257 258 259   291 9   30  109 87  365 336 331 227] + 2;
% vessels_included{10} =  [0 183 184 393 185 326 186 285 187 253 1   56  2   58  178 59  112  60  103 17  21  20  250 252 251   227 9   39  90  78  366 341 352 255] + 2;
% vessels_included{11} =  [0 1   98  2   152 99  188 153 222 189 281 323 282 329 324 330 369 340 331 297 298  300 223 224 225   244 288 320 366 365 149 137 146 194] + 2;
% vessels_included{12} =  [0 183 286 184 348 287 349 448 381 350 1   52  2   59  55  60  109 61  100 46  50   49  382 383 384   420 8   32  71  76  294 313 324 353] + 2;
% vessels_included{13}  = [0 127 128 259 129 220 153 130 154 197 1   38  2   39  122 40  71  41  64  32  36   35  155 157 156   188 8   23  63  57  243 231 236 199] + 2;
% vessels_included{14}  = [0 166 261 167 262 382 263 349 295 264 1   48  2   55  51  123 56  131 124 42  46   45  346 348 347   319 8   33  161 145 415 397 392 288] + 2;
% vessels_included{15}  = [0 175 176 375 177 312 217 178 218 283 1   50  2   56  52  130 57  131 168 17  21   20  279 281 280   262 9   36  165 146 365 338 349 306] + 2;
% vessels_included{16}  = [0 198 199 418 200 347 242 201 243 315 1   56  2   63  59  144 64  145 186 50  51   53  310 312 311   262 10  38  147 152 355 373 384 338] + 2;
% vessels_included{17}  = [0 1   117 2   118 261 120 217 121 185 332 333 384 385 387 391 442 402 393 379 383  381 182 184 183   151 342 365 405 413 270 286 297 210] + 2;
% vessels_included{18}  = [0 193 194 388 195 330 232 196 233 297 1   56  2   63  59  64  110 65 103  9   13   11  294 296 295   244 49  33  77  82  350 358 369 323] + 2;
% vessels_included{19}  = [0 1   105 2   169 106 170 268 206 171 305 356 307 357 475 358 404 359 395 339 343  341 207 208 209   240 352 318 391 366 115 131 126 174] + 2;
% vessels_included{20}  = [0 184 185 382 186 313 187 277 188 246 1   56  2   64  59  135 65  145 136 8   12   10  243 245 244   217 48  26  180 149 320 339 334 249] + 2;
% vessels_included{21}  = [0 149 150 330 203 151 243 204 271 244 1   46  2   52  48  113 53  121 114 15  19   17  272 273 274   304 9   27  146 141 184 168 163 246] + 2;
% vessels_included{22}  = [0 1  102  2   160 103 200 161 232 201 297 343 298 349 344 350 385 358 351 302 306  305 233 234 235   259 342 329 382 371 156 147 144 206] + 2;
% vessels_included{23} = [0 149 150  305 151 260 179 152 207 180 1   42  2   48  44  49  86  85  80  13  17   16  256 258 257   242 10  30  77  73  300 282 293 201] + 2;
% vessels_included{24} = [0 1   94   2   150 95  188 151 222 189 285 331 286 337 332  338 373 346 339 301 302 304 223 224 225   253 299 323 370 357 147 123 120 194] + 2;
% vessels_included{25} = [0 1   38   2   62  39  78  63  90  79  120 138 121 140 139  141 162 147 142 128 130 129 91  92  93    119 125 137 148 156 50  59  58  81] + 2;

%% only 32 vessels
vessels_included{1}  =  [0 1   31 151 71 32 90    89 109 91  179 219 182 224 220 225 244 231 226 193 196 110 111 112      135 186 216 243 237 66 63 94] + 2;
vessels_included{2}  =  [0 1   97 2   155 98 193  156 194 247 282 330 283 338 333 339 387 347 340 298 301 195 197 196     226 296 327 382 365 147 142 275] + 2;
vessels_included{3}  =  [0 1   107 2  108 228 109 195 110 168 283 327 284 328 429 390 329 398 391 296 299 165 166 167     148 289 308 400 419 253 264 190] + 2;
vessels_included{4}  =  [0 170 171 358 172 299 208 173 209 271 1   50   2  57  53 58  100   59 93  44  47  268 269 270    263 9   29   89 76  314 325 292] + 2;
vessels_included{5}  =  [0 169 170 361 171 298 205 172 206 268 1   50   2  52 164 53  94    54 89  17  19  265 267 266    216 13  36   78  72 332 343 291] + 2;
vessels_included{6}  =  [0 181 182 373 183 312 221 184 251 222 1   54   2  57 177 58  103   59 96  17  19  308 310 309    279  9  41   85  77 326 337 224] + 2;
vessels_included{7}  =  [0 134 198 135 242 199 270 243 298 271 1   38   2  44  39 45  77    53 46  6    9  299 300 301    345 35  29   61  65 227 234 274] + 2;
vessels_included{8}  =  [0 1   100 2   158 101 198 159 230 199 295 339 296 345 340 346 387  354 347 311 314 231 232 233   261 309 336 384 381 146 141 204] + 2;
vessels_included{9}  =  [0 181 182 388 183 321 224 184 256 225 1   54  2   60  56  61  110  69  62  48  51  257 258 259   291 9   30  109 87  336 331 227] + 2;
vessels_included{10} =  [0 183 184 393 185 326 186 285 187 253 1   56  2   58  178 59  112  60  103 17  20  250 252 251   227 9   39  90  78  341 352 255] + 2;
vessels_included{11} =  [0 1   98  2   152 99  188 153 222 189 281 323 282 329 324 330 369 340 331 297  300 223 224 225   244 288 320 366 365 137 146 194] + 2;
vessels_included{12} =  [0 183 286 184 348 287 349 448 381 350 1   52  2   59  55  60  109 61  100 46   49  382 383 384   420 8   32  71  76  313 324 353] + 2;
vessels_included{13}  = [0 127 128 259 129 220 153 130 154 197 1   38  2   39  122 40  71  41  64  32   35  155 157 156   188 8   23  63  57  231 236 199] + 2;
vessels_included{14}  = [0 166 261 167 262 382 263 349 295 264 1   48  2   55  51  123 56  131 124 42   45  346 348 347   319 8   33  161 145 397 392 288] + 2;
vessels_included{15}  = [0 175 176 375 177 312 217 178 218 283 1   50  2   56  52  130 57  131 168 17   20  279 281 280   262 9   36  165 146 338 349 306] + 2;
vessels_included{16}  = [0 198 199 418 200 347 242 201 243 315 1   56  2   63  59  144 64  145 186 50   53  310 312 311   262 10  38  147 152 373 384 338] + 2;
vessels_included{17}  = [0 1   117 2   118 261 120 217 121 185 332 333 384 385 387 391 442 402 393 379  381 182 184 183   151 342 365 405 413 286 297 210] + 2;
vessels_included{18}  = [0 193 194 388 195 330 232 196 233 297 1   56  2   63  59  64  110 65 103  9    11  294 296 295   244 49  33  77  82  358 369 323] + 2;
vessels_included{19}  = [0 1   105 2   169 106 170 268 206 171 305 356 307 357 475 358 404 359 395 339  341 207 208 209   240 352 318 391 366 131 126 174] + 2;
vessels_included{20}  = [0 184 185 382 186 313 187 277 188 246 1   56  2   64  59  135 65  145 136 8    10  243 245 244   217 48  26  180 149 339 334 249] + 2;
vessels_included{21}  = [0 149 150 330 203 151 243 204 271 244 1   46  2   52  48  113 53  121 114 15   17  272 273 274   304 9   27  146 141 168 163 246] + 2;
vessels_included{22}  = [0 1  102  2   160 103 200 161 232 201 297 343 298 349 344 350 385 358 351 302  305 233 234 235   259 342 329 382 371 147 144 206] + 2;
vessels_included{23} = [0 149 150  305 151 260 179 152 207 180 1   42  2   48  44  49  86  85  80  13   16  256 258 257   242 10  30  77  73  282 293 201] + 2;
vessels_included{24} = [0 1   94   2   150 95  188 151 222 189 285 331 286 337 332  338 373 346 339 301 304 223 224 225   253 299 323 370 357 123 120 194] + 2;
vessels_included{25} = [0 1   38   2   62  39  78  63  90  79  120 138 121 140 139  141 162 147 142 128 129 91  92  93    119 125 137 148 156  59  58  81] + 2;


%%

num_vessels = length(vessels_included{1});

% This is a vector identifying the parameter values that give crap output
% bad = [7 10 20];
bad = [];
%%


%%
L = zeros(num_vessels,num_par - length(bad));
R = zeros(num_vessels,num_par - length(bad));
R_vessel = cell(num_vessels,num_par - length(bad));
L_big = cell(num_vessels,num_par - length(bad));
R_big = cell(num_vessels,num_par - length(bad));
generation_analysis = {};
hsaveL = [];
hsaveR = [];

newname_ID = 1;
for i=1:num_par - length(bad)
    if ~any(i == bad)
        if scale_flag == 1
            scale = scaling(i);
        else
            scale = 1;
        end
        network = load(strcat(name1,num2str(theta1(i)),name2,num2str(theta2(i)),name3));
        connectivity = network.connectivity;
        dets = network.vessel_details;
        disp(i)
        sub_generation = {};
        for j=1:num_vessels
            L(j,i) = dets{vessels_included{i}(j),3}./scale;
            R(j,i) = dets{vessels_included{i}(j),4}./scale;
            R_vessel{j,i} = dets{vessels_included{i}(j),2}(:,4);
%             figure(j); hold on;
%             length_radius = length(dets{vessels_included{i}(j),2}(:,4));
%             plot(dets{vessels_included{i}(j),2}(:,4),'o');
%             max_rad = max(dets{vessels_included{i}(j),2}(:,4));
%             min_rad = min(dets{vessels_included{i}(j),2}(:,4));
%             plot(ones(100).*length_radius.*0.25,linspace(min_rad,max_rad,100),'k');
%             plot(ones(100).*length_radius.*0.75,linspace(min_rad,max_rad,100),'k');
            
        end
    end
end
%%


%% Now do the cross validation
total_samp = 25*25;
LOO_samp = 25*24;
% Simple KDE
phi = @(x) exp(-.5*x.^2)/sqrt(2*pi);
% kernel_L = @(x,h) mean(phi((x-L_bin)/h)/h);
% kernel_R = @(x,h) mean(phi((x-R_bin)/h)/h);

% Leave-one-out KDE (LOO)
% We want to FIX xj, and adjust xi
KDE_LOO = @(xj,xi,h) phi((xj-xi)./h);
f_LOO = @(xj,xi,h) (1./((LOO_samp - 1).*h)).*sum(KDE_LOO(xj,xi,h));
f2_LOO = @(xj,xi,h) sum(KDE_LOO(xj,xi,h));
% Define the Maximum Likelihood Cross-Validation (MLCV)
% pars = [n, xj, xi]
% MLCV_f = @(h,pars) -1.*((1./pars{1}).*sum(log((pars{1}-1)*h)*f_LOO_L(pars{2},pars{3},h))...
%                   - log((pars{1}-1)*h));

MLCV_f = @(h,pars) ((1./pars{1}).*sum(log((pars{1}-1)*h)*f_LOO(pars{2},pars{3},h))...
                  - log((pars{1}-1)*h));

%% Now call the cross validation in a loop
fun = @(h) MLCV(h,pars)
[usedata,leavedata] = CrossValidation_Data(100,100,L,R);
H_L = [];
MLCV_L = [];
H_R = [];
MLCV_R = [];
n = 25*32;
root2pi = 1./sqrt(2*pi);
hspace = linspace(0,2,1000);
% for hi=hspace
%     mlcv_l = 0;
%     mlcv_r = 0;
%     for ves=1:32 %22 vessels
%         for seg=1:25 %25 segmentations
%             [usedata,leavedata] = CrossValidation_Data(ves,seg,L,R);
%             inner_sum_l = 0;
%             inner_sum_r = 0;
%             for i=1:n-1
%                 inner_sum_l = inner_sum_l + root2pi.*KDE_LOO(usedata(i,1),leavedata(1),hi);
%                 inner_sum_r = inner_sum_r + root2pi.*KDE_LOO(usedata(i,2),leavedata(2),hi);
%             end
%             mlcv_l = mlcv_l + log(inner_sum_l);
%             mlcv_r = mlcv_r + log(inner_sum_r);
%         end
%     end
%     mlcv_l = (1./n)*mlcv_l - log(hi*(n-1));
%     mlcv_r = (1./n)*mlcv_r - log(hi*(n-1));
%     MLCV_L(end+1) = mlcv_l;
%     MLCV_R(end+1) = mlcv_r;
% end
% max_mlcvL = max(MLCV_L)
% max_mlcvR = max(MLCV_R)
% h_L = hspace(find(MLCV_L == max_mlcvL))
% h_R = hspace(find(MLCV_R == max_mlcvR))
% 
% figure(1); hold on; 
% plot(hspace,MLCV_L,'b');
% plot(h_L,max_mlcvL,'*r','MarkerSize',10,'LineWidth',1.5);
% 
% figure(2); hold on;
% plot(hspace,MLCV_R,'b');
% plot(h_R,max_mlcvR,'*r','MarkerSize',10,'LineWidth',1.5);
% 
% save('MLCV_Results_32vessels2.mat');
%% Now use the results to plot the density with nominal smoothing vs.
%  the MLCV smoothness density.
load('MLCV_Results_32vessels2.mat')
addpath('GPstuff-4.7/');
startup
max_mlcvL = max(MLCV_L)
max_mlcvR = max(MLCV_R)
h_L = hspace(find(MLCV_L == max_mlcvL))
h_R = hspace(find(MLCV_R == max_mlcvR))


%%
[usedata,leavedata] = CrossValidation_Data(100,100,L,R);

lspace = linspace(-4,4,500);
rspace = linspace(-4,4,500);


figure(1); hold on; 
plot(hspace,MLCV_L,'b','LineWidth',3);
plot(h_L,max_mlcvL,'*r','MarkerSize',10,'LineWidth',1.5);

figure(2); hold on;
plot(hspace,MLCV_R,'b','LineWidth',3);
plot(h_R,max_mlcvR,'*r','MarkerSize',10,'LineWidth',1.5);


%%
open('length_density_GP2.fig');
figure(3); %clf;
% Extract data from the GP
h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
xdata = get(dataObjs, 'XData');  %data from low-level grahics objects
ydata = get(dataObjs, 'YData');
gp_L = [xdata{2,1}' ydata{2,1}'];
LCB_L = [xdata{3,1}(1:400) ydata{3,1}(1:400)];
UCB_L = [xdata{3,1}(end:-1:401) ydata{3,1}(end:-1:401)];
%
close 3;
figure(3); hold on;
curve1a_L = flipud(LCB_L(:,2));
curve2a_L = flipud(UCB_L(:,2));
inbetween1 = [gp_L(:,2)' curve1a_L' ];
inbetween2 = [gp_L(:,2)' curve2a_L'];
X_L1       = [LCB_L(:,1)' fliplr(gp_L(:,1)')];
X_L2       = [gp_L(:,1)' fliplr(UCB_L(:,1)')];
f1a = fill(X_L1,inbetween1,[0.85 0.85 0.85]);
f1a.EdgeColor = [0.85 0.85 0.85];
f2a = fill(X_L2,inbetween2,[0.85 0.85 0.85]);
f2a.EdgeColor = [0.85 0.85 0.85];
plot(gp_L(:,1),gp_L(:,2),'Color',[0.3 0.3 0.3],'LineWidth',4);

%% Construct CDF
GP_CDF_L = zeros(400,1);
GP_CDF_LLB = zeros(400,1);
GP_CDF_LUB = zeros(400,1);
for i=1:399
    GP_CDF_L(i+1) = (gp_L(i+1,1)-gp_L(i,1))*gp_L(i,2)+GP_CDF_L(i);
    GP_CDF_LLB(i+1) = (LCB_L(i+1,1)-LCB_L(i,1))*LCB_L(i,2)+GP_CDF_LLB(i);
    GP_CDF_LUB(i+1) = (UCB_L(i+1,1)-UCB_L(i,1))*UCB_L(i,2)+GP_CDF_LUB(i);
end
figure(4); hold on;
curve1_L = flipud(UCB_L(:,1));
curve2_L = flipud(LCB_L(:,1));
inbetween1 = [gp_L(:,1)' curve1_L' ];
inbetween2 = [gp_L(:,1)' curve2_L'];
X_L1       = [GP_CDF_LUB' fliplr(GP_CDF_L')];
X_L2       = [GP_CDF_L' fliplr(GP_CDF_LLB')];
f1 = fill(X_L1,inbetween1,[0.85 0.85 0.85]);
f1.EdgeColor = [0.85 0.85 0.85];
f2 = fill(X_L2,inbetween2,[0.85 0.85 0.85]);
f2.EdgeColor = [0.85 0.85 0.85];
plot(GP_CDF_L,gp_L(:,1),'Color',[0.3 0.3 0.3],'LineWidth',4);
% plot(GP_CDF_LLB,LCB_L(:,1),'--r','LineWidth',3);
% plot(GP_CDF_LUB,UCB_L(:,1),'--r','LineWidth',3);
% plot(ones(100,1),linspace(-5,5,100),'--k');
axis([0 1 min(gp_L(:,1)) max(gp_L(:,1))]);


%%
figure(3);
hold on;
for i=1:n
%     plot(lspace,KDE_LOO(lspace, usedata(i,1), h_L)./10,'k');
      plot(ones(20,1).*usedata(i,1),linspace(-0.02,0,20),'k');
end
hold on;
[F_nom,XI_nom,U_nom]=ksdensity(usedata(:,1));
scott_L = U_nom
% lgpdens(usedata(:,1),XI_nom'); 
% [P,PQ,XT] = lgpdens(usedata(:,1),XI_nom');
% h2 = plot(XT,P,'color',[0.3 0.3 0.3],'LineWidth',2);%GP
h1 = plot(XI_nom,F_nom,'-.k','LineWidth',4); % Nominal Estimate
[F_mlcv,XI_mlcv]=ksdensity(usedata(:,1),'Bandwidth',h_L);
h3 = plot(XI_mlcv,F_mlcv,'--','Color',[0.6 0.6 0.6],'LineWidth',4); %MLCV
% legend([h1 h2 h3],{'Scott`s Rule','Gaussian Process (Laplace)','MLCV'},'Box','off','Location','northwest');
% legend([h1 h3],{'Scott`s Rule','MLCV'},'Box','off','Location','northwest');
set(gca,'FontSize',30);
axis tight

%icdf
figure(4); hold on;
[F_nom_icdf,XI_nom_icdf,U_nom_icdf]=ksdensity(usedata(:,1),'function','cdf');
[F_mlcv_icdf,XI_mlcv_icdf]=ksdensity(usedata(:,1),'Bandwidth',h_L,'function','cdf');
plot(F_nom_icdf,XI_nom_icdf,'-.k','LineWidth',4); % Nominal Estimate
plot(F_mlcv_icdf,XI_mlcv_icdf,'--','Color',[0.6 0.6 0.6],'LineWidth',4); %MLCV
set(gca,'FontSize',30);
xlim([0 1]);

clear h1 h2 h3


open('radius_density_GP2.fig');
figure(5); %clf; 
% Extract data from the GP
h = gcf;
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes
objTypes = get(dataObjs, 'Type');  %type of low-level graphics object
xdata = get(dataObjs, 'XData');  %data from low-level grahics objects
ydata = get(dataObjs, 'YData');
gp_R = [xdata{2,1}' ydata{2,1}'];
LCB_R = [xdata{3,1}(1:400) ydata{3,1}(1:400)];
UCB_R = [xdata{3,1}(end:-1:401) ydata{3,1}(end:-1:401)];
close 5;
figure(5);
hold on;
curve1a_R = flipud(LCB_R(:,2));
curve2a_R = flipud(UCB_R(:,2));
inbetween1 = [gp_R(:,2)' curve1a_R' ];
inbetween2 = [gp_R(:,2)' curve2a_R'];
X_R1       = [LCB_R(:,1)' fliplr(gp_R(:,1)')];
X_R2       = [gp_R(:,1)' fliplr(UCB_R(:,1)')];
f1a = fill(X_R1,inbetween1,[0.85 0.85 0.85]);
f1a.EdgeColor = [0.85 0.85 0.85];
f2a = fill(X_R2,inbetween2,[0.85 0.85 0.85]);
f2a.EdgeColor = [0.85 0.85 0.85];
plot(gp_R(:,1),gp_R(:,2),'Color',[0.3 0.3 0.3],'LineWidth',4);
%% Construct CDF
GP_CDF_R = zeros(400,1);
GP_CDF_RLB = zeros(400,1);
GP_CDF_RUB = zeros(400,1);
for i=1:399
    GP_CDF_R(i+1) = (gp_R(i+1,1)-gp_R(i,1))*gp_R(i,2)+GP_CDF_R(i);
    GP_CDF_RLB(i+1) = (LCB_R(i+1,1)-LCB_R(i,1))*LCB_R(i,2)+GP_CDF_RLB(i);
    GP_CDF_RUB(i+1) = (UCB_R(i+1,1)-UCB_R(i,1))*UCB_R(i,2)+GP_CDF_RUB(i);
end
figure(6); hold on;
curve1_R = flipud(UCB_R(:,1));
curve2_R = flipud(LCB_R(:,1));
inbetween1 = [gp_R(:,1)' curve1_R' ];
inbetween2 = [gp_R(:,1)' curve2_R'];
X_R1       = [GP_CDF_RUB' fliplr(GP_CDF_R')];
X_R2       = [GP_CDF_R' fliplr(GP_CDF_RLB')];
f3 = fill(X_R1,inbetween1,[0.85 0.85 0.85]);
f3.EdgeColor = [0.85 0.85 0.85];
f4 = fill(X_R2,inbetween2,[0.85 0.85 0.85]);
f4.EdgeColor = [0.85 0.85 0.85];
plot(GP_CDF_R,gp_R(:,1),'Color',[0.3 0.3 0.3],'LineWidth',4);
% plot(GP_CDF_RLB,LCB_R(:,1),'--r','LineWidth',3);
% plot(GP_CDF_RUB,UCB_R(:,1),'--r','LineWidth',3);
% plot(ones(100,1),linspace(-5,5,100),'--k');
axis([0 1 min(gp_R(:,1)) max(gp_R(:,1))]);




%%
figure(5);
hold on;
for i=1:n
    %plot(lspace,KDE_LOO(lspace, usedata(i,1), h_L)./10,'k');
      plot(ones(20,1).*usedata(i,2),linspace(-0.02,0,20),'k');
end
[F_nom,XI_nom,U_nom]=ksdensity(usedata(:,2));
scott_R = U_nom
% lgpdens(usedata(:,2),XI_nom'); 
% [P,PQ,XT] = lgpdens(usedata(:,2),XI_nom');
% h2 = plot(XT,P,'color',[0.3 0.3 0.3],'LineWidth',2);%GP
h1 = plot(XI_nom,F_nom,'-.k','LineWidth',4); % Nominal Estimate
[F_mlcv,XI_mlcv]=ksdensity(usedata(:,2),'Bandwidth',h_R);
h3 = plot(XI_mlcv,F_mlcv,'--','Color',[0.6 0.6 0.6],'LineWidth',4); %MLCV
% legend([h1 h2 h3],{'Scott`s Rule','Gaussian Process (Laplace)','MLCV'},'Box','off','Location','northwest');
set(gca,'FontSize',30);
axis tight


%icdf
figure(6); hold on;
[F_nom_icdf,XI_nom_icdf,U_nom_icdf]=ksdensity(usedata(:,2),'function','cdf');
[F_mlcv_icdf,XI_mlcv_icdf]=ksdensity(usedata(:,2),'Bandwidth',h_L,'function','cdf');
plot(F_nom_icdf,XI_nom_icdf,'-.k','LineWidth',4); % Nominal Estimate
plot(F_mlcv_icdf,XI_mlcv_icdf,'--','Color',[0.6 0.6 0.6],'LineWidth',4); %MLCV
set(gca,'FontSize',30);
xlim([0 1]);

%% Make the plots pretty

for i=3:6
   a = figure(i);
   grid on;
   set(gca,'FontSize',40);
   a.Position = [300 740 900 600];
   if i==3
       title('Density: Length')
      lp1 = plot(nan,nan,'-.k','LineWidth',4);
      lp2 = plot(nan,nan,'--r','LineWidth',4);
      lp3 = plot(nan,nan,'Color',[0.3 0.3 0.3],'LineWidth',4); 
      lp4 = plot(nan,nan,'Color',[0.85 0.85 0.85],'LineWidth',4);
      legend([lp1 lp2 lp3 lp4],{'Silverman`s Rule','MLCV','GP Mean','95% CI'});
   elseif i==4
       title('Inverse CDF: Length')
   elseif i==5
       title('Density: Radius')
   else
       title('Inverse CDF: Radius')
   end
end

