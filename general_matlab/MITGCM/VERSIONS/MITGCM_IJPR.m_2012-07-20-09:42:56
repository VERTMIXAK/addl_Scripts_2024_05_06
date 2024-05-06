function MODEL=MITGCM_IJPR(MODEL)
files=MODEL.files;
time=nc_varget(files.u,'T');
%%
%tdx=length(time)
IJPRu=nan*ones(length(time),length(MODEL.YC(:,1)),length(MODEL.XC(1,:)));
IJPRv=nan*ones(length(time),length(MODEL.YC(:,1)),length(MODEL.XC(1,:)));
sz=[length(MODEL.RC) size(MODEL.H)];

% set up ocean/earth mask
mask = ones(sz);
for ii = 1:sz(3);for jj = 1:sz(2)
    mask(find(-MODEL.RC>MODEL.H(jj,ii)),jj,ii)=nan;
end;end

for tdx = 1:length(time);disp([num2str(tdx),' of ',num2str(length(time))])
rhop = nc_varget(files.rhop,'RHOAnoma',[tdx-1,0,0,0],[1,-1,-1,-1]);
u    = nc_varget(files.u   ,'UVEL'    ,[tdx-1,0,0,0],[1,-1,-1,-1]);u(u==0)=nan; % possibly dangerous approach to masking
u    = (u(:,:,1:end-1)+u(:,:,2:end))/2; % Am I on the rho pts here? 
v    = nc_varget(files.v   ,'VVEL'    ,[tdx-1,0,0,0],[1,-1,-1,-1]);v(v==0)=nan; % possibly dangerous approach to masking
v    = (v(:,1:end-1,:)+v(:,2:end,:))/2; % Am I on the rho pts here?
%
% improvements to be made:
% put everything to the appropriate C-grid location: 
% make sure I really have the non-ocean points identified properly. 

% --------------------------------------------------
% mask out non-ocean points (in the sea-bed)
%--------------------------------------------------
rhop=rhop.*mask;
% -------------------------------------------------
ubt = squeeze(nansum(u.*MODEL.DZ)./sum(MODEL.DZ)); uBT = (permute(repmat(ubt,[1,1,sz(1)]),[3,1,2]));uPR=u-uBT;
vbt = squeeze(nansum(v.*MODEL.DZ)./sum(MODEL.DZ)); vBT = (permute(repmat(vbt,[1,1,sz(1)]),[3,1,2]));vPR=v-vBT;
p_anom = 9.8*cumsum(rhop.*MODEL.DZ);
pbt = squeeze(nansum(p_anom.*MODEL.DZ)./sum(MODEL.DZ)); pBT = (permute(repmat(pbt,[1,1,sz(1)]),[3,1,2]));pPR=p_anom-pBT;
IJPRu(tdx,:,:) = sq(nansum(uPR.*pPR.*MODEL.DZ));
IJPRv(tdx,:,:) = sq(nansum(vPR.*pPR.*MODEL.DZ));
end
keyboard
MODEL.IJPRu=IJPRu;
MODEL.IJPRv=IJPRv;

Need to add in creation of netcdf output here
%%
for tdx=1:4:length(time);
    clf;imagesc(sq(IJPRu(tdx,:,:))/1e3);axis xy;caxis([-1,1]*5);hold on
    contour(medfilt2(MODEL.H),16,'k')
    drawnow;end

