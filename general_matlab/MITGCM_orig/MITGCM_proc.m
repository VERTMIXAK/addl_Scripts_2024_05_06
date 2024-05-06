
%%
clear
MODEL.base = '/home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/'
MODEL.exp  = 'TEST_WAVE_8kmx8km_for_HBS_12_June_2012/';MODEL.output_dir = 'output0001';
MODEL=MITGCM_get_files(MODEL);MODEL=MITGCM_get_grid(MODEL);
%%
%% regress model against M2
load('/home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/test/matlab/data');MODEL.data=data;
time=nc_varget(MODEL.files.u,'T')/3600;tdx=length(time)-24:length(time);% last 25 records
 MITGCM_calc_regress(MODEL.files.u   ,'UVEL'    ,1,MODEL,1/12.4206,outfile,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.v   ,'VVEL'    ,2,MODEL,1/12.4206,outfile,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.rhop,'RHOAnoma',0,MODEL,1/12.4206,outfile,tdx,'M2')

%%
clear
MODEL.base = '/home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/';MODEL.output_dir = 'output0001'; 

MODEL.exp  = 'TEST_WAVE_8kmx8km';MODEL=MITGCM_get_files(MODEL);MODEL=MITGCM_get_grid(MODEL);
%load('/home/hsimmons/PROJ/MODELS/MITgcm/EXP/TASMAN/test/matlab/data');MODEL.data=data;
outfile='test'
time=nc_varget(MODEL.files.u,'T')/3600;tdx=length(time)-24:length(time);% last 25 records
 MITGCM_calc_regress(MODEL.files.u   ,'UVEL'    ,1,MODEL,1/12.4206,outfile,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.v   ,'VVEL'    ,2,MODEL,1/12.4206,outfile,tdx,'M2')
 MITGCM_calc_regress(MODEL.files.rhop,'RHOAnoma',0,MODEL,1/12.4206,outfile,tdx,'M2')