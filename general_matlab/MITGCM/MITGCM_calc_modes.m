function c=calc_modes(efile,gfile,datfile,datvar,outfile,psifile,modeidx,verbose)
%        c=calc_modes(efile,gfile,datfile,datvar,outfile,psifile,modeidx,verbose)
%        
% calculate mode fits to BC modes modeidx
%  

%keyboard
sz=nc_varsize(efile,'e');
szd=nc_varsize(datfile,datvar);
zi=nc_varget(efile,'zi');xh=nc_varget(efile,'xh');yh=nc_varget(efile,'yh');Time=nc_varget(efile,'Time');%Time = Time(1:3);
rho=0.5*(zi(2:end)+zi(1:end-1));



D   = nc_varget(gfile,'D');lath= nc_varget(gfile,'lath');lonh= nc_varget(gfile,'lonh');wet = nc_varget(gfile,'wet');mask=wet./wet;
%keyboard
outfile = [outfile(1:end-3),'.nc']

if verbose;disp(['loading ',psifile]);end
eval(['load ',psifile]);
if verbose;disp(['done']);end

if verbose;disp(['writing to ',outfile]);end
setup_cdf_file_time_plus_3d(outfile,[datvar,'_c'],'Time','modeidx','yh','xh',[(length(modeidx)) szd([3,4])])
nc_varput(outfile,'modeidx',modeidx);nc_varput(outfile,'xh',xh(1:szd(4)));nc_varput(outfile,'yh',yh(1:szd(3)))

psi = psi(:,modeidx,:,:);
%keyboard
tic
for tdx = 1:length(Time)
  tmpc2= nan*ones(1,length(modeidx),szd(3),sz(4));
  dat = sq(nc_varget(datfile,datvar,[tdx(1)-1,0,0,0],[1,-1,-1,-1])); 
  date = sq(nc_varget(efile,'e',[tdx(1)-1,0,0,0],[1,-1,-1,-1])); 
  for i = 1:szd(4)
    for j = 1:szd(3)
      if D(j,i)>100
        tmppsi=sq(psi(:,:,j,i));tmpc = tmppsi\sq(dat(:,j,i));%tmpsi is dimensioned  tmpsi(nz,nmodes), c is dimensioned c(nmodes,ntime);
        tmpc2(1,:,j,i)=tmpc;
      else
        tmpc2(1,:,j,i)=nan;
      end
    end;
  end
  
%keyboard

% to reconstruct the map of the time series at a given depth index,
% kdx, time index tdx and mode index modeidx
% modeidx=2;kdx=1;tdx=100;imagesc(sq(c(100,:,:)).*sq(psi(kdx,:,:)));


tnew=[];t=0;
%keyboard
  start = [tdx-1,0,0,0];count = [1,length(modeidx),szd(3),szd(4)];stride = [1,1,1,1];
  nc_varput(outfile,[datvar,'_c'],tmpc2,start,count)
  tnew=toc;t=t+tnew;
  if verbose
    disp(['writing ',outfile,' tdx = ',num2str(tdx),' times per tdx = ',num2str(round(tnew)),'s total elapsed time ',num2str(round(t)/60),' min'])
  end
end
nc_varput(outfile,'Time',Time)
disp(['wrote ',outfile])
c=tmpc2;
%keyboard