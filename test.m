clear;
clc;
close all;

fs=1000;
fin=466.459655762;
t=1:65536;
d=sin(2*pi*fin/fs*t);
subplot(2,1,1);
plot(d,'-*')
subplot(2,1,2);
plot(abs(fft(d)),'-*');

w=hanning(length(t));
w=w';
figure;
subplot(2,1,1);
plot(w.*d,'-*');
subplot(2,1,2);
plot(abs(fft(w.*d)),'-*');

w=hamming(length(t));
w=w';
figure;
subplot(2,1,1);
plot(w.*d,'-*');
subplot(2,1,2);
plot(abs(fft(w.*d)),'-*');