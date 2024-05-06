function [dthetadz,p_ave] = dthdz(S,T,P,LAT)
%function [dthetadz,p_ave] = dthdz(S,T,P,LAT)
% modified from  SW_BFRQ    Brunt-Vaisala Frequency Squared (N^2)

%-------------
% CHECK INPUTS
%-------------
if ~(nargin==3 | nargin==4) 
   error('dthdz.m: Must pass 3 or 4 parameters ')
end %if

if nargin == 3
  LAT = [];
end %if

% CHECK S,T,P dimensions and verify consistent
[ms,ns] = size(S);
[mt,nt] = size(T);
[mp,np] = size(P);

  
% CHECK THAT S & T HAVE SAME SHAPE
if (ms~=mt) | (ns~=nt)
   error('check_stp: S & T must have same dimensions')
end %if

% CHECK OPTIONAL SHAPES FOR P
if     mp==1  & np==1      % P is a scalar.  Fill to size of S
   P = P(1)*ones(ms,ns);
elseif np==ns & mp==1      % P is row vector with same cols as S
   P = P( ones(1,ms), : ); %   Copy down each column.
elseif mp==ms & np==1      % P is column vector
   P = P( :, ones(1,ns) ); %   Copy across each row
elseif mp==ms & np==ns     % PR is a matrix size(S)
   % shape ok 
else
   error('check_stp: P has wrong dimensions')
end %if
[mp,np] = size(P);
 

  
% IF ALL ROW VECTORS ARE PASSED THEN LET US PRESERVE SHAPE ON RETURN.
Transpose = 0;
if mp == 1  % row vector
   P       =  P(:);
   T       =  T(:);
   S       =  S(:);   

   Transpose = 1;
end %if
%***check_stp

% IF LAT PASSED THEN VERIFY DIMENSIONS
if ~isempty(LAT)
   [mL,nL] = size(LAT);
   if mL==1 & nL==1
      LAT = LAT*ones(size(S));
   end %if  

   if (ms~=mL) | (ns~=nL)              % S & LAT are not the same shape
       if (ns==nL) & (mL==1)           % copy LATS down each column
          LAT = LAT( ones(1,ms), : );  % s.t. dim(S)==dim(LAT)    
       else
          error('dthdz.m:  Inputs arguments have wrong dimensions')
       end %if
   end %if
end %if

   

%------
% BEGIN
%------
if ~isempty(LAT)
   % note that sw_g expects height as argument
   Z = sw_dpth(P,LAT);
   g = sw_g(LAT,-Z);
   f = sw_f(LAT);
else
   Z = P;
   g = 9.8*ones(size(P));
   f = NaN*ones(size(P));
end %if

[m,n] = size(P);
iup   = 1:m-1;
ilo   = 2:m;
p_ave = (P(iup,:)+P(ilo,:) )/2;
ptmp_up = sw_ptmp(S(iup,:),T(iup,:),P(iup,:),p_ave);
ptmp_lo = sw_ptmp(S(ilo,:),T(ilo,:),P(ilo,:),p_ave);
 
dif_ptmp = ptmp_lo - ptmp_up;
dif_z    = diff(Z);
dthetadz       = dif_ptmp ./ (dif_z);
if Transpose
  dthetadz    = dthetadz';
end %if
return
%-------------------------------------------------------------------
