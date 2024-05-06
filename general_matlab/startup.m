function startup

% startup -- User script configuration for Matlab.  It can set default
%            paths, define Handle Graphics defaults, or predefine
%            variables in your workspace.

% svn $Id: startup.m 647 2013-01-22 23:40:00Z arango $
%===========================================================================%
%  Copyright (c) 2002-2013 The ROMS/TOMS Group                              %
%    Licensed under a MIT/X style license                                   %
%    See License_ROMS.txt                           Hernan G. Arango        %
%===========================================================================%

global IPRINT
IPRINT=0;

format long g

% Change "my_root" to the appropriate path were these matlab scripts are
% installed in your computer.

my_root='/import/c/w/jpender/ROMS/MyMatlab';

path(path, fullfile(my_root, '4dvar', ''))
path(path, fullfile(my_root, 'bathymetry', ''))
path(path, fullfile(my_root, 'boundary', ''))
path(path, fullfile(my_root, 'coastlines', ''))
path(path, fullfile(my_root, 'forcing', ''))
path(path, fullfile(my_root, 'grid', ''))
path(path, fullfile(my_root, 'initial', ''))
path(path, fullfile(my_root, 'landmask', ''))
path(path, fullfile(my_root, 'mex', ''))
path(path, fullfile(my_root, 'netcdf', ''))
path(path, fullfile(my_root, 'roms_wilkin', ''))
path(path, fullfile(my_root, 'seagrid', ''))
path(path, fullfile(my_root, 'seagrid', 'presto', ''))
path(path, fullfile(my_root, 'seawater', ''))
path(path, fullfile(my_root, 't_tide', ''))
path(path, fullfile(my_root, 'tidal_ellipse', ''))
path(path, fullfile(my_root, 'utility', ''))
