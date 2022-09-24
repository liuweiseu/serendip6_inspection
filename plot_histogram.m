clear;
clc;
close all;

fs = 1000;                                          % sampling freq is 1000MSps
N_fft= 65536;                                       % FFT point is 32768

start_ch = 27392;                                   % start channel    
N_channels = 256;                                   % the number of output channels is 256
f_valid = fs/N_fft*N_channels;                      % convert the channels to frequency
TAPS = 8;
dt = N_fft/(fs*1024*1024);
t = 0.005;
n_frame = round(t/dt);
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

re = zeros(1, N_channels*n_frame);
im = zeros(1, N_channels*n_frame);
power = zeros(1, N_channels*n_frame);

re_tmp = zeros(1,N_channels);
im_tmp = zeros(1,N_channels);

for i=1:n_frame
    d = fread(fp, N_channels*2,'int8');
    for j = 1:N_channels
        re_tmp(j) = data(2*j-1);
        im_tmp(j) = data(2*j);
    end
    re((i-1)*N_channels+1 : i*N_channels) = re_tmp;
    im((i-1)*N_channels+1 : i*N_channels) = im_tmp;
end
mean_re = mean(re);
mean_im = mean(im);
rms_re = rms(re);
rms_im = rms(im);

subplot(2,1,1);
hist(re,100);
re_title = ['Re    mean: ' , num2str(mean_re),', ','rms: ',num2str(rms_re)];
title(re_title,'FontSize',16);
subplot(2,1,2);
hist(im,100);
im_title = ['Im    mean: ' , num2str(mean_im),', ','rms: ',num2str(rms_im)];
title(im_title,'FontSize',16);

