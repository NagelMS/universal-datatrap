% Author: Nagel Mejía Segura
% Double-SideBand Supressed Carrier
% Single Tone Message

pkg load signal

% Fs: Sample Rate [Hz]
% fc: Carrier Frequency [Hz]
% fm: Tone Frequency [Hz]
Fs = 800e3;
fc = 100e3;
fm = 5.5e3;

% duration: Tone duration [s]
duration = 2;

% t: time interval
t = 0:1/Fs:(duration*Fs - 1)/(Fs);

% msg: Tone Message
% carrier: Sine Wave Carrier
msg = cos(2*pi*fm*t);
carrier = cos(2*pi*fc*t);

% modul: Modulated Signal
modul = msg.*carrier;

% max_time: Maximum time to show
% index: Interval of t from zero to the max_time
max_time = 3/fm;
index = (t <= max_time);

% First figure (Signals in Time Domain)
figure(1)

subplot(3,1,1);
plot(t(index),msg(index));
xlabel('Time [s]');
ylabel('Voltage [V]');
xlim([0 max_time])
grid on;
title('Sine Wave Message');

subplot(3,1,2);
plot(t(index),carrier(index));
xlabel('Time [s]');
ylabel('Voltage [V]');
xlim([0 max_time])
grid on;
title('Carrier Signal');


subplot(3,1,3);
plot(t(index),modul(index));
hold on;
plot(t(index),msg(index));
xlabel('Time [s]');
ylabel('Voltage [V]');
xlim([0 max_time])
grid on;
title('Modulated Signal');
hold off;

% N: Length of the message's vector
N = length(msg);

% f: Frequency interval
f = ((-(N/2):(N/2)-1)*Fs/N);

% MSG-CARRIER-MOD: Fourier Transform of the signals
MSG = fft(msg,N);
CARRIER = fft(carrier,N);
MOD = fft(modul,N);

% Second figure (Signals in Time Domain)
figure(2)

subplot(3,1,1);
plot(f,20*log10(abs(fftshift(MSG))))
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;
title('Sine Wave Message');

subplot(3,1,2);
plot(f,20*log10(abs(fftshift(CARRIER))))
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;
title('Sine Wave Carrier');

subplot(3,1,3);
plot(f,20*log10(abs(fftshift(MOD))))
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;
title('Amplitude Modulation');

% Message Recovery

% delta_fm-phase: Possible Changes on frequency or phase of the carrier
% Synchronous detection
delta_fm = 0;
delta_phase = 0;

% local_osc: Local Oscillator
local_osc = cos(2*pi*(fc+delta_fm)*t+delta_phase);

% msg_tmp - MSG_TMP: Temporary Message Received before filtering
msg_tmp = modul.*local_osc;
MSG_TMP = fft(msg_tmp,N);

% fcut: Cutoff Frequency of the Filter
fcut = 15e3;

% B-A: numerator and Denominator of the Butterworth Filter
[B,A] = butter(8,fcut/(Fs/2));

% msg_rx: Applying the filter to the message
msg_rx = filter(B,A,msg_tmp);
MSG_RX = fft(msg_rx,N);

figure(3)

subplot(2,2,1);
plot(t(index),msg_tmp(index));
xlabel('Time [s]');
ylabel('Voltage [V]');
xlim([0 max_time])
grid on;
title('Message Received (Before Filter)');

subplot(2,2,2);
plot(f,20*log10(abs(fftshift(MSG_TMP))))
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;
title('Message Received (Before Filter)');

subplot(2,2,3);
plot(t(index),msg_rx(index));
xlabel('Time [s]');
ylabel('Voltage [V]');
xlim([0 max_time])
grid on;
title('Message Received (Filtered)');

subplot(2,2,4);
plot(f,20*log10(abs(fftshift(MSG_RX))))
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;
title('Message Received (Filtered)');
