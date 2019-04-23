%% Driver for UQ analysis
clear; clc; close all;
%% NEW FILES
FILE{1,1}  = 'M1P4_lower22_smooth5_cl.csv';
FILE{1,2}  = 'M1P4_lower22_smooth5_bv.csv';

FILE{2,1}  = 'M1P4_lower25_smooth6_cl.csv';
FILE{2,2}  = 'M1P4_lower25_smooth6_bv.csv';

FILE{3,1}  = 'M1P4_lower30_smooth8_cl.csv';
FILE{3,2}  = 'M1P4_lower30_smooth8_bv.csv';

FILE{4,1} = 'M1P4_lower33_smooth5.1_cl.csv';
FILE{4,2} = 'M1P4_lower22_smooth5_bv.csv'; %bad

FILE{5,1} = 'M1P4_lower34_smooth3.3_cl.csv';
FILE{5,2} = 'M1P4_lower22_smooth5_bv.csv';%bad

FILE{6,1} = 'M1P4_lower34_smooth3.4_cl.csv';
FILE{6,2} = 'M1P4_lower22_smooth5_bv.csv';%bad

FILE{7,1} = 'M1P4_lower35_smooth3.6_cl.csv';
FILE{7,2} = 'M1P4_lower22_smooth5_bv.csv';%bad

FILE{8,1} = 'M1P4_lower35_smooth4.8_cl.csv';
FILE{8,2} = 'M1P4_lower22_smooth5_bv.csv';%bad

FILE{9,1}  = 'M1P4_lower35_smooth6.8_cl.csv';
FILE{9,2}  = 'M1P4_lower35_smooth6.8_bv.csv';

FILE{10,1}  = 'M1P4_lower36_smooth4.1_cl.csv'; 
FILE{10,2}  = 'M1P4_lower36_smooth4.1_bv.csv';

FILE{11,1} = 'M1P4_lower37_smooth3.9_cl.csv';
FILE{11,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{12,1} = 'M1P4_lower36_smooth4_cl.csv';
FILE{12,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{13,1} = 'M1P4_lower29.9_smooth4.6_cl.csv';
FILE{13,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{14,1} = 'M1P4_lower36_smooth4_cl.csv';
FILE{14,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{15,1} = 'M1P4_lower26_smooth4.7_cl.csv';
FILE{15,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{16,1} = 'M1P4_lower26_smooth4.8_cl.csv';
FILE{16,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{17,1} = 'M1P4_lower26_smooth5.1_cl.csv';
FILE{17,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{18,1} = 'M1P4_lower27_smooth5.8_cl.csv';
FILE{18,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{19,1} = 'M1P4_lower30_smooth5.7_cl.csv';
FILE{19,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{20,1} = 'M1P4_lower30_smooth6.5_cl.csv';
FILE{20,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{21,1} = 'M1P4_lower31_smooth5.6_cl.csv';
FILE{21,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{22,1} = 'M1P4_lower28_smooth6_cl.csv';
FILE{22,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad


FILE{23,1} = 'M1P4_lower31_smooth6.1_cl.csv';
FILE{23,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{24,1} = 'M1P4_lower32_smooth4.1_cl.csv';
FILE{24,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad

FILE{25,1} = 'M1P4_lower33_smooth4.2_cl.csv';
FILE{25,2} = 'M1P4_lower43.6_smooth7.62_bv.csv'; %bad





%%
theta1 = [22 24 25 27 29 29.87 30 35  36  36  37  37.5  40  43.6];
theta2 = [5   3  6  3  3 4.56   8 6.8 4.0 4.1  6.8 5.15 5.7  7.62];
storage = cell(1,size(FILE,1));
scaling = zeros(1,size(FILE,1));
lineartaper = zeros(2,size(FILE,1));
expotaper = zeros(2,size(FILE,1));
linear_r0 = zeros(2,size(FILE,1));
expo_r0   = zeros(2,size(FILE,1));
for i=1:size(FILE,1)
    clc; disp(i);
   [storage{i},scaling(i),lineartaper(:,i), expotaper(:,i),linear_r0(:,i), expo_r0(:,i)] = Bif_Extract2(FILE{i,1},FILE{i,2});
end
% save('ScalingValues.mat','scaling')
%%%%%%% P RM S   M S  M  S  M  S  M LT RT     LM S  M  S  M  S  M  LT RT

% len_adj


