function MODEL=MITGCM_get_mode_1_OBCs(MODEL)
EWG=load('/import/wrkdir10/jpender/dataDir/levitus_ewg')
%%

% z-grid
% Nominal depth of model (meters)

% Density (Temperature)
clear N2* p*
%%
if 0
	f2;clf;
	imagesc(EWG.lon-360,EWG.lat,sq(EWG.S(1,1,:,:)));axis xy;hold on;caxis([33,36]);colorbar
	contour(MODEL.Lon,MODEL.Lat,MODEL.H,[0:100:1000],'k');axis equal
	contour(MODEL.Lon,MODEL.Lat,MODEL.H,[1500:500:5000],'b');axis equal
	ylim([(min(MODEL.Lat(:))-1) (max(MODEL.Lat(:))+1)])
	xlim([(min(MODEL.Lon(:))-1) (max(MODEL.Lon(:))+1)]);grid on
end
%%
%keyboard
idx = nearest(EWG.lon,MODEL.lon_strat);
jdx = nearest(EWG.lat,MODEL.lat_strat);
S=EWG.S(1,:,jdx,idx);T = EWG.T(1,:,jdx,idx);P=sw_pres(EWG.z,MODEL.reflat)';
%rho2=sw_pden(S,T,P,2000);

Ti=interp1(EWG.z,T,MODEL.Z,'spline');Si=interp1(EWG.z,S,MODEL.Z,'spline');Pi=sw_pres(MODEL.Z,MODEL.reflat);
[N2a,~,p_avea]     =sw_bfrq(Si ,Ti ,Pi                ,-45);
[N2ewg,~,p_ave_ewg]=sw_bfrq(S' ,T' ,sw_pres(EWG.z,-45),-45);
N2ai=interp1(p_avea,N2a,sw_pres(MODEL.Z,-45));
N2ewgi=interp1(p_ave_ewg,N2ewg,sw_pres(MODEL.Z,-45),'spline');

N2ai(N2ai<MODEL.minN2)=MODEL.minN2;N2=N2ai;
ind=find(isnan(N2));
N2(1)=N2(2);N2(end)=N2(end-1);
MODEL.N2   =N2;
MODEL.Tref =Ti  ;

f=sw_f(MODEL.lat_strat);
omega=2*pi/(12.42*3600);

if 0
    figure(5);clf;
	semilogx(N2ewg,p_ave_ewg,'ko-');axis ij;hold on
	semilogx(N2ai,sw_pres(MODEL.Z,-45),'r.-');axis ij;hold on
	legend('raw N2 from EWG','N2, splined EWG data',4);axis tight
	xlabel('N2');ylabel('depth')
end
%%

%% Vertical structure for boundary conditions
if 0
figure(6);clf;%hformat(12)
plot(imag(MODEL.u),MODEL.Z,'k-');hold on;axis ij
plot(real(MODEL.v),MODEL.Z,'r-');legend('u','v');title(['u v eigenfunctions, ',num2str(MODEL.flux_mag),' kW/m'])
plot(0*imag(MODEL.u),MODEL.Z,'k--');
xlabel('velocity (m/s)')
%pdfprint('../FIGURES/EWG_uv_eigenfunctions')
end
%%
