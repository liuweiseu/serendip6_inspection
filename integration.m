clear;
clc;
close all;

fs = 1000;                      % the sampling freq is 1024MHz
N_fft= 65536;                   % FFT point is 32768
start_ch = 27392;               % start channel    
%start_ch =4608;
N_channels = 256;               % the number of output channels is 256
f_valid = fs/N_fft*N_channels;  % convert the channels to frequency
TAPS = 8;
%--------------------Select data file-------------------------%
[filename0, pathname] = uigetfile( ...
    {'*.dat','data Files';...
    '*.*','All Files' },...
    'Please select the PSR data file',...
    './');
if isequal(filename0,0)
   disp('User selected Cancel')
   return;
else
   filename= fullfile(pathname, filename0);
end
%-------------------------------------------------------------%
x = f_valid/N_channels*(0:(N_channels - 1));        % cal the xlabel
start_freq = start_ch/N_fft*fs + 1000;
x = x + start_freq;
%-------------------------------------------------------------%
fp = fopen(filename,'r');    
data = fread(fp, N_channels*2*TAPS,'int8');

cho = 0;
frameno = 1;
re = zeros(1, N_channels);
im = zeros(1, N_channels);
spec = zeros(1, N_channels);
j = 0;
while ~feof(fp)                       
    data = fread(fp, N_channels*2,'int8');   % read data out from the data file, we need to read RE and IM parts
    if(length(data)<256)
        break;
    end
    for i = 1:N_channels
        re(i) = data(2*i-1);
        im(i) = data(2*i);
    end
    for i = 1:N_channels
        spec(i) = spec(i) + re(i)^2 + im(i)^2;      % cal power
    end
    j = j + 1;
end
fclose(fp);
plot(x, spec);
xlabel('Freq/MHz');