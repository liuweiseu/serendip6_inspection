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
%---------------------Set data path---------------------------%
data_path='data/20230511/last_target/';
%--------------------Select data file-------------------------%
files = dir(data_path);
%-------------------------------------------------------------%
x = f_valid/N_channels*(0:(N_channels - 1));        % cal the xlabel
start_freq = start_ch/N_fft*fs + 1000;
x = x + start_freq;
%-------------------------------------------------------------%
for fn=1:38
    filename = files(fn+2).name;
    filename = [data_path, filename];
    disp(filename);
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
    subplot(4,10,fn);
    fsplit = strsplit(filename,'_');
    p_title = [fsplit{3},'-Pol',num2str(fsplit{7})];
    plot(x, spec);
    title(p_title);
    xlabel('Freq/MHz');
end
sgt = sgtitle('Hydrogen Line from FAST(20230511-Target 15)','Color','black');
sgt.FontSize = 20;