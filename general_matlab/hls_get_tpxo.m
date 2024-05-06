function tpxo = hls_get_tpxo(model,consts,params,bb)
%usage:
% model = '~/DATA/OTIS_DATA/Model_tpxo7.2';consts={'m2';'s2';'o1';'k1'};params={'u' ;'v';'U';'V';'z'};bb = [130 150 5 20];tpxo = hls_get_tpxo(model,consts,params,bb)
% consts ={'m2'                };
% %params={'u' ;'v';'U';'V';'z'};
% %params={'u' ;'v';        'z'};
% params ={                 'z'};
   
for cdx = 1:length(consts)
for pdx = 1:length(params)
	param = char(params(pdx));
	const = char(consts(cdx));
	disp([param,' ',const])
	[x,y,amp.(const).(param),pha.(const).(param)]=tmd_get_coeff(model,param,const);
    if min(bb(1:2))<0;x=x-360;end
    %[min(x) max(x)]
idx = find(x>=bb(1)&x<=bb(2));
jdx = find(y>=bb(3)&y<=bb(4));
tpxo.lon=x(idx);
tpxo.lat=y(jdx);
tpxo.amp.(const).(param)=amp.(const).(param)(jdx,idx);
tpxo.pha.(const).(param)=pha.(const).(param)(jdx,idx);
end
end
whos idx jdx
clear tmp* cdx pdx
%[long,latg,H]=tmd_get_bathy(model);
