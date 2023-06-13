clear;
clc;
close all;

fs = 1000;                      % the sampling freq is 1024MHz
N_fft= 65536;                   % FFT point is 32768
start_ch = 30583;%6550;%30500;               % start channel    
%start_ch =4608;
N_channels = 4;               % the number of output channels is 256
px = 2;
py = 4;
f_valid = fs/N_fft*N_channels;  % convert the channels to frequency
TAPS = 8;
N = 32768;
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
re_tmp = zeros(1,N_channels);
im_tmp = zeros(1,N_channels);
j = 1;

while ~feof(fp)                       
    data = fread(fp, N_channels*2,'int8');   % read data out from the data file, we need to read RE and IM parts
    if(length(data)<2*N_channels)
        break;
    end
    for i= 1:N_channels
        re_tmp(i) = data(2*i-1);
        im_tmp(i) = data(2*i);
    end
    re(j,:) = re_tmp;
    im(j,:) = im_tmp;
    j = j + 1;
    if(j==65537)
        break;
    end
end
fclose(fp);
voltage = re+1j*im;

df = 1000/65536;
fine_df = df/N;

for i=1:N_channels
    subplot(px,py,i);
    check_n=i;
    fine_start_freq = df *(check_n+start_ch-1) + 1000 - fine_df * N/2;
    x = (1:N)*fine_df + fine_start_freq;  
    cyc = floor(j/N);
    spec = zeros(N,1);
    for i = 1:cyc
%         spec = spec + abs(fft(voltage((i-1)*N+1:i*N,check_n)));
        spec = abs(fft(voltage((i-1)*N+1:i*N,check_n)));
    end
    tmp = spec(1:N/2);
    spec(1:N/2) = spec(N/2+1:N);
    spec(N/2+1:N)=tmp;
    plot(x,20*log10(spec));
    xlabel('MHz');
    ylabel('dB')
end


