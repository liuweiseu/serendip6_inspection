clear;
clc;
close all;

fs = 1024;                  % the sampling freq is 1024MHz
N_fft= 65536;                  % FFT point is 32768
SPECTRA = 4096;
start_ch = 0;               % start channel    
%start_ch =4608;
N_channels = 256;           % the number of output channels is 256
f_valid = fs/N_fft*N_channels;    % convert the channels to frequency
TAPS = 8;
%--------------------Select data file-------------------------%
cmd = 'scp weiliu@s6h0:/home/weiliu/CUDA_test/gpu_test/test.dat ./';
system(cmd);
filename = 'test.dat';
%-------------------------------------------------------------%
x = f_valid/N_channels*(0:(N_channels - 1));        % cal the xlabel
start_freq = start_ch/N_fft*fs;
x = x + start_freq;
%-------------------------------------------------------------%
fp = fopen(filename,'r');  

cho = 0;
frameno = 1;
while cho ~=1
    re = zeros(1, N_channels);
    im = zeros(1, N_channels);
    spec = zeros(1, N_channels);
                       
    data = fread(fp, N_channels*2,'float');   % read data out from the data file, we need to read RE and IM parts
    for i = 1:N_channels
        re(i) = data(2*i-1);
        im(i) = data(2*i);
    end
    for i = 1:N_channels
        spec(i) = re(i)^2 + im(i)^2;      % cal power
    end
    y_log = log10(spec+1);
    plot(x, spec);
%     plot(x, y_log);
    xlabel('Freq/MHz');
    title(['Freq domain data', '(FrameNo:',int2str(frameno),')']);
    frameno = frameno + 1;
    cho = input('Pls input choice: 0(or none) for next;1 for exit:');
    if(cho == 1)
        cho = 1;
    else
        cho = 0;
    end
end
fclose(fp);

fp = fopen(filename,'r'); 
d = fread(fp, N_channels*2*SPECTRA, 'float');
plot(d);
