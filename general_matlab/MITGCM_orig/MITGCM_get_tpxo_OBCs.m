    % The tides to extract
    tpxofile = '/home/hsimmons/DATA/OTIS_DATA/Model_tpxo7.2';
    A=[ones([1 length(OB.timeD)]); cos(OB.omegaD*OB.timeD); sin(OB.omegaD*OB.timeD)];
    
    % Time dependence to upload
    input=[cos(OB.omegaD*OB.timeD); sin(OB.omegaD*OB.timeD)];
    
    % Southern Boundary
    lat=MODEL.Lat(1,:);lon=MODEL.Lon(1,:);H0=MODEL.H(1,:);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    su=zeros([MODEL.Nx OB.Nt]);sv=zeros([MODEL.Nx OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            su(i,:)=input'*B(2:3);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            sv(i,:)=input'*B(2:3);
        end
    end
    
    
    % Northern Boundary
    lat=MODEL.Lat(end,:);lon=MODEL.Lon(end,:);H0=MODEL.H(end,:);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    nu=zeros([MODEL.Nx OB.Nt]);nv=zeros([MODEL.Nx OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            nu(i,:)=input'*B(2:3);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            nv(i,:)=input'*B(2:3);
        end
    end
        
    % Western boundary
    %%
    lat=MODEL.Lat(:,1);lon=MODEL.Lon(:,1);H0=MODEL.H(:,1);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    wu=zeros([MODEL.Ny OB.Nt]);wv=zeros([MODEL.Ny OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            wu(i,:)=input'*B(2:3);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            wv(i,:)=input'*B(2:3);
        end
    end
    clear u v
    %%
    % Eastern boundary
    lat=MODEL.Lat(:,end);lon=MODEL.Lon(:,end);H0=MODEL.H(:,end);
    [u]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'U',[nconsts],1);
    [v]=GET_TIDE_TPXO(tpxofile,OB.timeD,lon,lat,'V',[nconsts],1);
    eu=zeros([MODEL.Ny OB.Nt]);ev=zeros([MODEL.Ny OB.Nt]);
    for i=1:size(u,1)
        if ~any(isnan(u(i,:))) & H0(i)>1e-6
            B=regress(u(i,:)',A')/H0(i);
            eu(i,:)=input'*B(2:3);
        end
        if ~any(isnan(v(i,:))) & H0(i)>1e-6
            B=regress(v(i,:)',A')/H0(i);
            ev(i,:)=input'*B(2:3);
        end
    end

%%    

% rotate vectors

if rotateit
theta = atan2(nu,nv) + deg2rad(-MODEL.rotate_angle);
 tmpnu = nu.*cos(theta) + nv.*sin(theta);
 tmpnv = nv.*cos(theta) - nu.*sin(theta);
theta = atan2(su,sv) + deg2rad(-MODEL.rotate_angle);
 tmpsu = su.*cos(theta) + sv.*sin(theta);
 tmpsv = sv.*cos(theta) - su.*sin(theta);
theta = atan2(eu,ev) + deg2rad(-MODEL.rotate_angle);
 tmpeu = eu.*cos(theta) + ev.*sin(theta);
 tmpev = ev.*cos(theta) - eu.*sin(theta);
theta = atan2(wu,wv) + deg2rad(-MODEL.rotate_angle);
 tmpwu = wu.*cos(theta) + wv.*sin(theta);
 tmpwv = wv.*cos(theta) - wu.*sin(theta);

nu=tmpnu;
nv=tmpnv;
su=tmpsu;
nv=tmpsv;
eu=tmpeu;
ev=tmpev;
wu=tmpwu;
wv=tmpwv;
end % rotateit

% Calculate temp boundary
    OB.NT=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
    OB.ST=repmat(MODEL.Tref',[MODEL.Nx 1 OB.Nt]);
    OB.WT=repmat(MODEL.Tref',[MODEL.Ny 1 OB.Nt]);
    OB.ET=repmat(MODEL.Tref',[MODEL.Ny 1 OB.Nt]);

% Format for model
    OB.NU=permute(repmat(nu,[1 1 MODEL.Nz]),[1 3 2]);
    OB.NV=permute(repmat(nv,[1 1 MODEL.Nz]),[1 3 2]);
    OB.SU=permute(repmat(su,[1 1 MODEL.Nz]),[1 3 2]);
    OB.SV=permute(repmat(sv,[1 1 MODEL.Nz]),[1 3 2]);
    OB.WU=permute(repmat(wu,[1 1 MODEL.Nz]),[1 3 2]);
    OB.WV=permute(repmat(wv,[1 1 MODEL.Nz]),[1 3 2]);
    OB.EU=permute(repmat(eu,[1 1 MODEL.Nz]),[1 3 2]);
    OB.EV=permute(repmat(ev,[1 1 MODEL.Nz]),[1 3 2]);

