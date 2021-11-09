clc
clear
close all

%% example #1
fs = 1e4;
t = 0:1/fs:1; 

x = 2.5 + cos(2*pi*203*t) + sin(2*pi*721*t) + cos(2*pi*1001*t);

hx = hilbert(x);

figure(1);
subplot(1, 2, 1);
plot(t, x, 'LineWidth', 2);
xlim([0.01 0.03]);
ylim([-4 6]);
xlabel('t');
ylabel('x(t)');
title('original signal');

subplot(1, 2, 2);
plot(t, real(hx), t, imag(hx), 'LineWidth', 2);
xlim([0.01 0.03]);
ylim([-4 6]);
xlabel('t');
ylabel('hilbert(x(t))');
legend('real', 'imaginary');
title('hilbert function');

%% example #2a
fs = 100;
t = 0:1/fs:5-1/fs;
x = chirp(t, 100, 100, 200);

figure(2);
plot(t, x, 'LineWidth', 2);
xlabel('t');
ylabel('x(t)');
title('chirp signal');

%% example #2b
fs = 1000;
t = 0:1/fs:2-1/fs;
x = chirp(t, 100, 1, 200);

figure(3);
subplot(2, 2, 1);
pspectrum(x, fs, 'spectrogram'); % short-time power spectrum 

subplot(2, 2, 2);
instfreq(x, fs, 'Method', 'hilbert');

subplot(2, 2, 3);
pspectrum(x, fs, 'spectrogram'); % short-time power spectrum 
hold on;
instfreq(x, fs, 'Method', 'hilbert');
hold off

%% example #3
fs = 1023;
t = 0:1/fs:2-1/fs;
%x = sin(2*pi*60*t)+sin(2*pi*90.*t);
x = sin(2*pi*60*t)+sin(2*pi*90*sin(2*pi*0.1*t).*t);
  
[power_spectrum, corresponding_frequencies, time_instants] = pspectrum(x, fs, 'spectrogram');

% 'tfridge' extracts the maximum-energy time-frequency ridge from power_spectrum matrix
% fridge: time-dependent frequency
% lridge: values of power_spectrum along the maximum-energy ridge.
%penalty = 0.01;
 penalty = 0;
[fridge, ~, lridge] = tfridge(power_spectrum, corresponding_frequencies, penalty, 'NumRidges', 2);

figure(4);
subplot(2, 2, 1);
pspectrum(x, fs, 'spectrogram');
yticks([0 30 60 90 120 150 180]);

subplot(2, 2, 2);
pspectrum(x, fs, 'spectrogram');
hold on;
plot3(time_instants, fridge, abs(power_spectrum(lridge)), 'LineWidth', 2);
hold off;
yticks([0 30 60 90 120 150 180]);

subplot(2, 2, 3);
plot(time_instants, fridge, 'LineWidth', 2);
ylim([min(fridge(:))-10, max(fridge(:))+10]);
xlabel('t');
ylabel('freq');
