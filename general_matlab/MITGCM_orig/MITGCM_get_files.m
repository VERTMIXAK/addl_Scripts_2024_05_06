function MODEL=MITGCM_get_files(MODEL)

MODEL.files.rhop  = [MODEL.base,'/',MODEL.exp,'/saves/',MODEL.output_dir,'/RHOAnoma.t001.nc'];
MODEL.files.u     = [MODEL.base,'/',MODEL.exp,'/saves/',MODEL.output_dir,'/UVEL.t001.nc'];
MODEL.files.v     = [MODEL.base,'/',MODEL.exp,'/saves/',MODEL.output_dir,'/VVEL.t001.nc'];
MODEL.files.theta = [MODEL.base,'/',MODEL.exp,'/saves/',MODEL.output_dir,'/THETA.t001.nc'];
MODEL.files.grid  = [MODEL.base,'/',MODEL.exp,'/saves/',MODEL.output_dir,'/grid.t001.nc'];

names=fieldnames(MODEL.files);
for ii = 1:length(names)
    fname = eval(['MODEL.files.',char(names(ii))]);
    eval(['a=exist(fname);'])
    if a==0;disp([fname,' does not exist']);end
end
