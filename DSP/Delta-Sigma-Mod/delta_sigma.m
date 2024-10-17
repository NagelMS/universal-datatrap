% Author: Nagel Mejía Segura
% Delta-Sigma Modulation (Applied to a Sine Wave)

pkg load signal

% Fs: Sample Rate
% t: time interval
Fs = 50000;
t = 0:1/Fs:(1*Fs-1)/Fs;

% fn: Signal Frequency
% Tn: Period of the Signal
% x: Signal
fn = 2000;
Tn = 1/fn;
x = sin(2*pi*fn*t);

% Ns: length of the Signal 
Ns = length(x);

% y: Output vector (Initialized with zeros)
% v: Output of integrator (Initialized with zeros)
y = zeros(1,Ns);
v = zeros(1,Ns+1);

% ya: 1 bit DAC value
ya = 0;

% Loop to generate the Delta-Sigma Modulator (First Order)
for n = 1:Ns
    % w: Parameter to provide the feedback error
    w = x(n) - ya;

    % Integrator
    v(n+1) = v(n) + w;

    % Comparator Defines y => Output 
    % 1 Bit DAC defines ya value
    if v(n+1) >= 0
        y(n) = 1;
        ya = 1.5;
    else
        y(n) = 0;
        ya = -1.5;
    end

end

% Cutoff Frequency (Low-Pass Filter)
fcut = 2100;

% Parameters of the filter
[B A] = butter(8, fcut/(Fs/2),'low');

% Filtering the output signal of the demodulator
y_filtered = filter(B,A,y);

% Figure showing all the stages 
figure(1)

subplot(3,1,1);
plot(t, x, '-r','Linewidth',3);
title('Original Input Signal');
xlabel('Time [s]');
ylabel('Amplitude');
xlim([100*Tn, 102*Tn]);
ylim([-1.5 1.5]);

subplot(3,1,2);
stairs(t, y,'Linewidth',2);  
title('Delta-Sigma Modulator Bitstream');
xlabel('Time [s]');
ylabel('Quantized Value');
xlim([100*Tn, 102*Tn]);
ylim([-0.5 1.5]);

subplot(3,1,3);
stairs(t, y_filtered,'-k','Linewidth',2);  
title('Reconstructed Signal (Low-Pass Filter)');
xlabel('Time [s]');
ylabel('Amplitude');
xlim([100*Tn, 102*Tn]);
ylim([-0.1 1.1]);

