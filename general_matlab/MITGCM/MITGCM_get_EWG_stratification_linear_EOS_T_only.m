function MODEL=MITGCM_get_mode_1_OBCs(MODEL)
EWG=load('/import/c/w/jpender/dataDir/levitus_ewg');
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
if 0 % do or dont fit an exponential to the stratification
 S=EWG.S(1,:,jdx,idx);T = EWG.T(1,:,jdx,idx);P=sw_pres(EWG.z,MODEL.reflat)';
 Ti=interp1(EWG.z,T,MODEL.Z,'spline');Si=interp1(EWG.z,S,MODEL.Z,'spline');Pi=sw_pres(MODEL.Z,MODEL.reflat);
 [N2a,~,p_avea]     =sw_bfrq(Si ,Ti ,Pi                ,-45);
 [N2ewg,~,p_ave_ewg]=sw_bfrq(S' ,T' ,sw_pres(EWG.z,-45),-45);
 N2ai=interp1(p_avea,N2a,sw_pres(MODEL.Z,-45));
 N2ewgi=interp1(p_ave_ewg,N2ewg,sw_pres(MODEL.Z,-45),'spline');
 N2ai(N2ai<MODEL.minN2)=MODEL.minN2;N2=N2ai;
 N2(1)=N2(2);N2(end)=N2(end-1);
 MODEL.N2   =N2;
 MODEL.Tref =Ti  ;
else
	idx
	jdx
S = sq(EWG.S(1,:,jdx-1:jdx+1,idx-1:idx+1));
T = sq(EWG.T(1,:,jdx-1:jdx+1,idx-1:idx+1));
P = sw_pres(EWG.z,MODEL.reflat)';
S=lowpass(sq(mean(mean(S,2),3)),1);
T=lowpass(sq(mean(mean(T,2),3)),1);
sig0ewg = sw_pden(S,T,P',0);Pi=linspace(P(1),P(end),500);
sig0ewgi=interp1(P,sig0ewg,Pi);
[N2ewg,~,p_ave]=sw_bfrq(S ,T ,sw_pres(EWG.z,MODEL.reflat),MODEL.reflat);
x=p_ave;y = lowpass(log10(N2ewg),1);p=polyfit(x,y,2); % fit a second order poly to the log of stratification
N2_fit = 10.^(p(3)+p(2)*x+p(1)*x.^2); N2_fit=N2_fit-min(N2_fit)+10^-6.5;%shift minimum to 10e-6

N2 = interp1(p_ave,N2_fit,sw_pres(MODEL.Z,MODEL.reflat)); N2(1)=N2(2);N2(end)=N2(end-1);
dT = MODEL.delZ.*N2/9.8/MODEL.alphaT;
Tnew = -cumsum([dT]);
% rescale because fit is not quite right
scale = [T(end)-T(1)]/Tnew(end);
MODEL.Tref=scale*Tnew+T(1);
MODEL.N2=N2;

%%
% find best exponential to describe density that matches bottom and upper 200m using simple search
bs = 100:10:2000;cmap=jet(length(bs));stds=[];
surfidx=find(Pi<=100);
sigbot = sig0ewgi(end);sigsurf=mean(sig0ewg(surfidx));
for bdx = 1:length(bs)
	stds(bdx) = rms(sig0ewgi'-(sigbot-(sigbot-sigsurf)*exp(-Pi'/bs(bdx))));
end
b = bs(find(stds==min(stds)));
sigfit = sigbot-(sigbot-sigsurf)*exp(-Pi'/b);
figure(200);clf
plot(sig0ewgi,Pi,'k');axis ij;hold on
plot(sigfit,Pi);axis ij;hold on
N2_fit2 = interp1(sw_dpth(Pi',MODEL.reflat),(9.8/1030)*gradient(sigfit)./gradient(Pi'),sw_pres(MODEL.Z,MODEL.reflat));
N2_fit2=N2_fit2-N2_fit2(end)+10.^-6.5;
%%
end


%keyboard
%%
if 0
figure(201);clf;
subplot(1,4,1);plot(S,P);axis ij tight;title('Sewg')
subplot(1,4,2);plot(T,P);axis ij tight;title('Tewg')
subplot(1,4,3);plot(lowpass(log10(N2ewg),3),sw_dpth(p_ave_ewg,MODEL.reflat),'k');hold on
               plot(log10(N2_fit),x,'r.-')
               plot(log10(N2_fit2),MODEL.Z,'b.-');title('N2');axis ij tight;
			   subplot(1,4,4);
			   plot(N2ewg ,sw_dpth(p_avea,MODEL.reflat),'k');axis ij tight;hold on
               plot(N2_fit,sw_dpth(p_avea,MODEL.reflat),'r.-');title('N2')
%               plot(N2_fit2,MODEL.Z,'b.-');title('N2')
figure(201);clf
plot(T,EWG.z);axis ij;hold on
plot(MODEL.Tref,MODEL.Z,'r.-');axis ij;hold on;
legend('Tewg','Tref')
end
%%


f=sw_f(MODEL.lat_strat);
omega=2*pi/(12.42*3600);

if 0
    figure(5);clf;
	semilogx(N2ewg,p_ave_ewg,'ko-');axis ij;hold on
	semilogx(N2ai,sw_pres(MODEL.Z,-45),'r.-');axis ij;hold on
	legend('raw N2 from EWG','N2, splined EWG data',4);axis tight
	xlabel('N2');ylabel('depth')
	
%% Vertical structure for boundary conditions
figure(6);clf;%hformat(12)
plot(imag(MODEL.u),MODEL.Z,'k-');hold on;axis ij
plot(real(MODEL.v),MODEL.Z,'r-');legend('u','v');title(['u v eigenfunctions, ',num2str(MODEL.flux_mag),' kW/m'])
plot(0*imag(MODEL.u),MODEL.Z,'k--');
xlabel('velocity (m/s)')
%pdfprint('../FIGURES/EWG_uv_eigenfunctions')
end
%%
