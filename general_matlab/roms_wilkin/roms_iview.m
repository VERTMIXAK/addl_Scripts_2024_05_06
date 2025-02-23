function [Data,han] = roms_iview(file,var,time,iindex,grd,dateformat)
% $Id: roms_iview.m 406 2012-02-16 15:42:35Z wilkin $
% [data,han] = roms_iview(file,var,time,iindex,grd,dateformat)
%
% file   = roms his/avg/rst etc nc file
%      or ctl structure from jgr_timectl
%
% var    = variable to plot
%
% time  = time index into nc FILE
%      or string giving date/time (in DATESTR format) in which case the
%         function finds the closest time index to that time
%
% iindex = iindex for slice
%        if iindex < 0  the x-axis coordinate will be lon instead of lat
%
% grd can be 
%       grd structure (from roms_get_grid)
%       grd_file name
%       [] (will attempt to get grid from roms file)
%
% John Wilkin

if nargin == 0
  help roms_iview
  return
end

if ~isstruct(file)
  % check only if input TIME is in datestr format, and if so find the 
  % time index in FILE that is the closest
  if isstr(time)
    fdnums = roms_get_date(file,-1);
    dnum = datenum(time);
    if dnum >= fdnums(1) & dnum <= fdnums(end)
      [tmp,time] = min(abs(dnum-fdnums));
      time = time(1);
    else
      warning(' ')
      disp(['Requested date ' time ' is not between the dates in '])
      disp([file ' which are ' datestr(fdnums(1),0) ' to ' ])
      disp(datestr(fdnums(end),0))
      thedata = -1;
      return
    end
  end
else
  % assume input FILE is actually ctl structure from e.g. jge_timctl
  % treat TIME as the index into the time variable in ctl
  % but allowing for TIME being in datestr format in which case the 
  % appropriate nearest time index is sought  
  [file,time] = roms_filetime_fromctl(file,time);
end

if nargin < 5
  grd = [];
end

xcoord = 'lat';
if iindex<0
  xcoord = 'lon';
  iindex = abs(iindex);
end

[data,z,lon,lat] = roms_islice(file,var,time,iindex,grd);
data = double(data);

% pcolor plot of the variable
switch xcoord
  case 'lon'
    labstr = [' - MeanLat ' num2str(mean(lat(:)),4)];
    hant = pcolorjw(lon,z,data);
  case 'lat'
    labstr = [' - MeanLon ' num2str(mean(lon(:)),4)];
    hant = pcolorjw(lat,z,data);
end

% time information
try
  if nargin < 6
    dateformat = 1;
  end
  [dnum,dstr] = roms_get_date(file,time,dateformat);
  tstr = [' - Date ' dstr];
  % tunits = nc_attget(file,'ocean_time','units');
  % tstr = [' - Date ' datestr(t+datenum(parsetnc(tunits)),dateformat) ];
catch
  warning([ 'Problem parsing date from file ' file ' for time index ' time]) 
end

titlestr = ...
    {['file: ' strrep_(file) ],...
    [upper(strrep_(var)) tstr labstr]};

title(titlestr)

if nargout > 0
  Data.var = data;
  Data.lon = lon;
  Data.lat = lat;
  Data.z = z;
  Data.t = dnum;
end

if nargout > 1
  han = hant;
end
