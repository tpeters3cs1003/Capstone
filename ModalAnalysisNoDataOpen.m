
%% Data processing

TrigLevel = 0.1; % set trigger level
Start = find(time_force-mean(time_force)>=TrigLevel*max(time_force),1,'first')-5; %set trigger start
cutoff_time=8;
time_force_short = time_force(Start:Start+cutoff_time/dt-1); % cut off data
time_short = time(Start:Start+cutoff_time/dt-1)-time(Start); % cut off data
time_accel1_short = time_accel1(Start:Start+cutoff_time/dt-1); % cut off data
time_accel2_short = time_accel2(Start:Start+cutoff_time/dt-1); % cut off data

N = length(time_short); %measure new data length

FFT_force = 2*fft(time_force_short,N)/N; %fft of shaker
FFT_accel1 = 2*fft(time_accel1_short,N)/N; %fft of accel end
FFT_accel2 = 2*fft(time_accel2_short,N)/N; %fft of accel middle

FRF_accel1 = FFT_accel1./FFT_force; %FRF of accel end
FRF_accel2 = FFT_accel2./FFT_force; %FRF of accel middle

dF=Fs/N; %setting dF
Freq=0:dF:Fs-dF; %generating frequency vector
FRF_disp1 = FRF_accel1./Freq'.^2;
FRF_disp2 = FRF_accel2./Freq'.^2;

%% PLOTTING

figure

plot(Freq,abs(FFT_accel1),Freq,abs(FFT_accel2)); xlim([0 2000]); legend(label_accel1,label_accel2)
xlabel('Frequency (Hz)')
ylabel('Acceleration (g)')
title('Acceleration vs Frequency')

%%
subplot(4,1,2:4)
semilogy(Freq,abs(FRF_accel1),'LineWidth',2.0) %FRF end
hold on
semilogy(Freq,abs(FRF_accel2),'LineWidth',2.0) %FRF middle
xlabel('Frequency (Hz)'); ylabel('Acceleration/Force [(g)/N]'); xlim([0 2000])
legend(label_accel1,label_accel2)

figure
semilogy(Freq,abs(FFT_accel1./FFT_accel2),'LineWidth',2.0) %FRF middle
xlabel('Frequency (Hz)'); ylabel('Acceleration/Force [g/g]'); xlim([0 2000])
legend(label_accel1,label_accel2)
%%