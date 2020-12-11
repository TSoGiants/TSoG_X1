function [aero_data,foil] = X1_Custom_xfoil(chord,varargin)
% Run XFoil and return the results.
% [polar,foil] = xfoil(coord,alpha,Re,Mach,{extra commands})
%
% Xfoil.exe needs to be in the same directory as this m function.
% For more information on XFoil visit these websites;
%  http://web.mit.edu/drela/Public/web/xfoil
%
% Inputs:
%    coord: Normalised foil co-ordinates (n by 2 array, of x & y
%           from the TE-top passed the LE to the TE bottom)
%           or a filename of the XFoil co-ordinate file
%           or a NACA 4 or 5 digit descriptor (e.g. 'NACA0012')
%    alpha: Angle-of-attack, can be a vector for an alpha polar
%       Re: Reynolds number (use Re=0 for inviscid mode)
%     Mach: Mach number
% extra commands: Extra XFoil commands
%           The extra XFoil commands need to be proper xfoil commands
%           in a character array. e.g. 'oper/iter 150'
%
% The transition criterion Ncrit can be specified using the
% 'extra commands' option as follows,
% foil = xfoil('NACA0012',10,1e6,0.2,'oper/vpar n 12')
%
%   Situation           Ncrit
%   -----------------   -----
%   sailplane           12-14
%   motorglider         11-13
%   clean wind tunnel   10-12
%   average wind tunnel    9 <= standard "e^9 method"
%   dirty wind tunnel    4-8
%
% A flap deflection can be added using the following command,
% 'gdes flap {xhinge} {yhinge} {flap_defelction} exec'
%
% Outputs:
%  polar: structure with the polar coefficients (alpha,CL,CD,CDp,CM,
%          Top_Xtr,Bot_Xtr)
%   foil: stucture with the specific aoa values (s,x,y,UeVinf,
%          Dstar,Theta,Cf,H,cpx,cp) each column corresponds to a different
%          angle-of-attack.
%         If only one left hand operator is specified, only the polar will be parsed and output
%
% If there are different sized output arrays for the different incidence
% angles then they will be stored in a structured array, foil(1),foil(2)...
%
% If the output array does not have all alphas in it, that indicates a convergence failure in Xfoil.
% In that event, increase the iteration count with 'oper iter ##;
%
% Examples:
%    % Single AoA with a different number of panels
%    [pol foil] = xfoil('NACA0012',10,1e6,0.0,'panels n 330')
%
%    % Change the maximum number of iterations
%    [pol foil] = xfoil('NACA0012',5,1e6,0.2,'oper iter 50')
%
%    % Deflect the trailing edge by 20deg at 60% chord and run multiple incidence angles
%    [pol foil] = xfoil('NACA0012',[-5:15],1e6,0.2,'oper iter 150','gdes flap 0.6 0 5 exec')
%    % Deflect the trailing edge by 20deg at 60% chord and run multiple incidence angles and only
%    parse or output a polar.
%    pol = xfoil('NACA0012',[-5:15],1e6,0.2,'oper iter 150','gdes flap 0.6 0 5 exec')
%    % Plot the results
%    figure;
%    plot(pol.alpha,pol.CL); xlabel('alpha [\circ]'); ylabel('C_L'); title(pol.name);
%    figure; subplot(3,1,[1 2]);
%    plot(foil(1).xcp(:,end),foil(1).cp(:,end)); xlabel('x');
%    ylabel('C_p'); title(sprintf('%s @ %g\\circ',pol.name,foil(1).alpha(end)));
%    set(gca,'ydir','reverse');
%    subplot(3,1,3);
%    I = (foil(1).x(:,end)<=1);
%    plot(foil(1).x(I,end),foil(1).y(I,end)); xlabel('x');
%    ylabel('y'); axis('equal');
%

%% Get the
[NACA_AF_1,NACA_AF_2,AF_ratio] = getNACAAFRatio(chord);

%% Set the alpha range and increment
alphas ={'-10','10'};
alpha_inc = '.1';

%% Calculate Reynolds Number (Re) and Mach Number at: 15 m/s (33.6 mph), Standard Day, 0 m altitude (sea level)

% Reynolds number calculation
rho = 1.225;        % kg/m^3, Density of Air
mew = 1.81E-5;      % kg/(m*s), Dynamic viscosity of Air
L   = chord/1000;   % m, Characteristic linear dimension
v   = 15;            % m/s, Airspeed

Re = num2str((rho*v*L)/mew);

% Speed of Sound Calculation
gamma = 1.4;        % none, Adiabatic Index
R     = 287;        % m^2/(K*s^2), Gas Constant
T     = 15+273.15;  % K, Absolute Air Temperature

a = sqrt(gamma*R*T); % m/s, Speed of Sound

% Mach Number Calculation
Mach = num2str(v/a);    % none, Mach Number

%% Setup file and names
% default foil name
foil_name = 'xfoil';

% default filenames
wd = fileparts(which('xfoil')); % working directory, where xfoil.exe needs to be
fname = 'xfoil';
file_coord= [foil_name '.foil'];

% Write xfoil command file
fid = fopen([wd filesep fname '.inp'],'w');
if (fid<=0)
    error([mfilename ':io'],'Unable to create xfoil.inp file');
end

%% Write NACA airfoil blending commands
% Commands for first airfoil
fprintf(fid,'NACA %s\n',NACA_AF_1);
file1 = ['naca_' NACA_AF_1 '.dat'];
if exist(file1,'file')
    delete(file1);
end
fprintf(fid,'PSAV %s\n',file1);

% Commands for second airfoil
fprintf(fid,'NACA %s\n',NACA_AF_2);
file2 = ['naca_' NACA_AF_2 '.dat'];
if exist(file2,'file')
    delete(file2);
end
fprintf(fid,'PSAV %s\n',file2);

% Commands for INTE
fprintf(fid,'INTE\nF\n');
fprintf(fid,'naca_%s.dat\nF\n',NACA_AF_1);
fprintf(fid,'naca_%s.dat\n%s\n',NACA_AF_2,AF_ratio);
fprintf(fid,'blended_%s_%s\n',NACA_AF_1,NACA_AF_2);

% Command to make new blended airfoil the current airfoil
fprintf(fid,'PCOP\n');
file3 = ['blended_' NACA_AF_1 '_' NACA_AF_2 '.dat'];
if exist(file3,'file')
    delete(file3);
end
fprintf(fid,'PSAV %s\n',file3);

% Commands to change paneling to larger value
fprintf(fid,'PPAR\nN\n300\n\n\n');

% Commands to start operation set Re, Mach, and iteration limit
% NOTE: MACH is not changed and left at 0, doesn't converge otherwise
fprintf(fid,'OPER\nVISC\n%s\nITER\n100\n',Re);

% Command to start polar accumulation
fprintf(fid,'PACC\n\n\n');

% Command to run sequence of alphas
fprintf(fid,'ASEQ %s %s %s\n',alphas{1},alphas{2},alpha_inc);

% Command to write polar output to file
if exist('xfoil_polar.dat','file')
    delete('xfoil_polar.dat');
end
fprintf(fid,'PWRT\nxfoil_polar.dat\nplis\n\n');

% Command to quit
fprintf(fid,'quit\n');
fclose(fid);

% Execute xfoil using generated input file xfoil.inp
cmd = sprintf('cd %s && xfoil.exe < xfoil.inp > xfoil.out',wd);
[status,result] = system(cmd);
if (status~=0)
    disp(result);
    error([mfilename ':system'],'Xfoil execution failed! %s',cmd);
end

% Read in blended airfoil data
foil = readtable(file3);
foil.Properties.VariableNames = {'X','Y'};

% Read in aerodynamic data
aero_data = importfile('xfoil_polar.dat');

end
%% Sub Functions

function [NACA_AF_1,NACA_AF_2,AF_ratio] = getNACAAFRatio(chord)
% Since NACA 4 digit airfoils only have 1 digit precision for the first two
% parameters and 2 digit precision for the third parameter, I have created
% a function in order to find two 4-Digit airfoils and determine the ratio
% between the two to use Xfoil's INTE function in order to interpret the
% airfoil in between.
% chord is in  mm, the chord length
t = 5;  % mm, the thickness of the board

% Calculate desired NACA values for the 3 parameters
NACA_Digits(1) = 100*(0.5*t)/chord; % Max camber of the airfoil
NACA_Digits(2) = 10*0.25;      % The max camber position is always set to 25% of the chord
NACA_Digits(3) = 100*(3*t)/chord;   % The max thickness is always 3 times the board's thickness

NACA_AF_1 = '';
NACA_AF_2 = '';

for i=1:length(NACA_Digits)
    % Convert desired NACA digit to whole numbers
    digit_lower = floor(NACA_Digits(i));
    digit_upper = ceil(NACA_Digits(i));
    
    % Calculate the ratio for each desired digit
    diff1 = NACA_Digits(i) - digit_lower;
    if digit_upper > digit_lower
        ratio(i) = diff1/(digit_upper - digit_lower);
    else
        ratio(i) = 0.5;
    end
    
    % Write digits to output
    if i < 3
        NACA_AF_1 = [NACA_AF_1 num2str(digit_lower)];
        NACA_AF_2 = [NACA_AF_2 num2str(digit_upper)];
    else
        NACA_AF_1 = [NACA_AF_1 num2str(digit_lower,'%02.f')];
        NACA_AF_2 = [NACA_AF_2 num2str(digit_upper,'%02.f')];
    end
end

% Get the desired ratio using the average of the 3 parameters
AF_ratio = num2str(mean(ratio));
end

% This function is generated using the import data function
function xfoilpolar = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   XFOILPOLAR = IMPORTFILE(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   XFOILPOLAR = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   xfoilpolar = importfile('xfoil_polar.dat', 13, 42);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/12/07 23:11:23

%% Initialize variables.
if nargin<=2
    startRow = 13;
    endRow = inf;
end

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%8f%9f%10f%10f%9f%9f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
xfoilpolar = table(dataArray{1:end-1}, 'VariableNames', {'alpha','CL','CD','CDp','CM','Top_Xtr','Bot_Xtr'});

end