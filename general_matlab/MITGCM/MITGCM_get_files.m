function MODEL=MITGCM_get_files(MODEL)

MODEL.files.etan  = [MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/ETAN'    ,MODEL.suffix1,MODEL.suffix2,'.nc'];
MODEL.files.rhop  = [MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/RHOAnoma',MODEL.suffix1,MODEL.suffix2,'.nc'];
MODEL.files.u     = [MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/UVEL'    ,MODEL.suffix1,MODEL.suffix2,'.nc'];
MODEL.files.v     = [MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/VVEL'    ,MODEL.suffix1,MODEL.suffix2,'.nc'];
MODEL.files.theta = [MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/THETA'   ,MODEL.suffix1,MODEL.suffix2,'.nc'];

MODEL.files.IFufile = [MODEL.base,MODEL.exp,'/',MODEL.output_dir,'/IuPR_PPR.mat'];
MODEL.files.IFvfile = [MODEL.base,MODEL.exp,'/',MODEL.output_dir,'/IvPR_PPR.mat'];

gfile1=[MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/grid'    ,MODEL.suffix1 ,'.nc']
gfile2=[MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/grid'    ,'.glob.'      ,'.nc']
gfile3=[MODEL.base,'/',MODEL.exp,'/',MODEL.output_dir,'/grid'    ,               '.nc']

if exist(gfile1)
 MODEL.files.grid  = gfile1;
elseif exist(gfile2)
 MODEL.files.grid  = gfile2;    
elseif exist(gfile3)
 MODEL.files.grid  = gfile3;    
else
    error('gfile does not exist')
end    

names=fieldnames(MODEL.files);
for ii = 1:length(names)
    fname = eval(['MODEL.files.',char(names(ii))]);
    eval(['a=exist(fname);'])
    if a==0;disp([fname,' does not exist']);end
end
