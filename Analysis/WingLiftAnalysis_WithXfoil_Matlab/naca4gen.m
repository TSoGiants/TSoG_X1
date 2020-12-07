function af = naca4gen(input)
%
% "naca4gen" Generates the NACA 4 digit airfoil coordinates with desired no.
% of panels (line elements) on it.
%      Original Author : Divahar Jayaraman (j.divahar@yahoo.com)
%      Original Source : https://www.mathworks.com/matlabcentral/fileexchange/19915-naca-4-digit-airfoil-generator
%      Changed Design  : Raul Maldonado (raul.maldonado83@gmail.com)
% 
% INPUTS-------------------------------------------------------------------
%                 input.m = Max camber as a percentage of chord
%                 input.p = Position of max camber as percentage of chord
%                 input.t = Thickness of airfoil as a percentage of chord
%                 input.n = no of panels (line elements) PER SIDE (upper/lower)
% input.HalfCosineSpacing = 1 for "half cosine x-spacing" 
%                         = 0 to give "uniform x-spacing"
%          input.wantFile = 1 for creating airfoil data file (eg. 'naca2412.dat')
%                       = 0 to suppress writing into a file
%       input.datFilePath = Path where the data  file has to be created
%                         (eg. 'af_data_folder/naca4digitAF/') 
%                         use only forward slash '/' (Just for OS portability)
% 
% OUTPUTS------------------------------------------------------------------
% Data:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%       af.x = x cordinate (nx1 array)
%       af.y = y cordinate (nx1 array)
%      af.xU = x cordinate of upper surface (nx1 array)
%      af.yU = y cordinate of upper surface (nx1 array)
%      af.xL = x cordinate of lower surface (nx1 array)
%      af.yL = y cordinate of lower surface (nx1 array)
%      af.xC = x cordinate of camber line (nx1 array)
%      af.yC = y cordinate of camber line (nx1 array)
%    af.name = Name of the airfoil
%  af.header = Airfoil name ; No of panels ; Type of spacing
%              (eg. 'NACA4412 : [50 panels,Uniform x-spacing]')
% 
% 
% File:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% First line : Header eg. 'NACA4412 : [50 panels,Half cosine x-spacing]'
% Subsequent lines : (2*input.n+1) rows of x and y values
% 
% Typical Inputs:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% input.designation='2312';
% input.n=56;
% input.HalfCosineSpacing=1;
% input.wantFile=1;
% input.datFilePath='./'; % Current folder
% input.is_finiteTE=0;
% % [[Calculating key parameters-----------------------------------------]]
a0= 0.2969;
a1=-0.1260;
a2=-0.3516;
a3= 0.2843;
if input.is_finiteTE ==1
    a4=-0.1015; % For finite thick TE
else
    a4=-0.1036;  % For zero thick TE
end
% % [[Giving x-spacing---------------------------------------------------]]
if input.HalfCosineSpacing==1
    beta=linspace(0,pi,input.n+1)';
    x=(0.5*(1-cos(beta))); % Half cosine based spacing 
else
    x=linspace(0,1,input.n+1)';
end
yt=(input.t/0.2)*(a0*sqrt(x)+a1*x+a2*x.^2+a3*x.^3+a4*x.^4);
xc1=x(find(x<=input.p));
xc2=x(find(x>input.p));
xc=[xc1 ; xc2];
if input.p==0
    xu=x;
    yu=yt;
    xl=x;
    yl=-yt;
    
    yc=zeros(size(xc));
else
    yc1=(input.m/input.p^2)*(2*input.p*xc1-xc1.^2);
    yc2=(input.m/(1-input.p)^2)*((1-2*input.p)+2*input.p*xc2-xc2.^2);
    yc=[yc1 ; yc2];
    dyc1_dx=(input.m/input.p^2)*(2*input.p-2*xc1);
    dyc2_dx=(input.m/(1-input.p)^2)*(2*input.p-2*xc2);
    dyc_dx=[dyc1_dx ; dyc2_dx];
    theta=atan(dyc_dx);
    xu=x-yt.*sin(theta);
    yu=yc+yt.*cos(theta);
    xl=x+yt.*sin(theta);
    yl=yc-yt.*cos(theta);
end
af.x=[flipud(xu) ; xl(2:end)];
af.y=[flipud(yu) ; yl(2:end)];
indx1=1:min( find(af.x==min(af.x)) );  % Upper surface indices
indx2=min( find(af.x==min(af.x)) ):length(af.x); % Lower surface indices
af.xU=af.x(indx1); % Upper Surface x
af.yU=af.y(indx1); % Upper Surface y
af.xL=af.x(indx2); % Lower Surface x
af.yL=af.y(indx2); % Lower Surface y
    
af.xC=xc;
af.yC=yc;
lecirFactor=0.8;
af.rLE=0.5*(a0*input.t/0.2)^2;
le_offs=0.5/100;
dyc_dx_le=(input.m/input.p^2)*( 2*input.p-2*le_offs );
theta_le=atan(dyc_dx_le);
af.xLEcenter=af.rLE*cos(theta_le);
af.yLEcenter=af.rLE*sin(theta_le);
% % [[Writing input data into file------------------------------------------]]
if input.wantFile==1
    F=num2str([af.x af.y]);
    fileName='XfoilAirfoilData.dat';
    dlmwrite(fileName,F,'delimiter','')
end