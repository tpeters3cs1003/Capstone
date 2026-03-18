clc
clear all
close all

%% User inputs
filename = 'Run1'; % Designate your filename (DO NOT PUT '.csv')
% (NOTE: Matlab will overwrite savefiles)

sens_force = 22.57/10/1000/4.45; % input as V/N!
sens_accel1 = 10.13/1000/cosd(30); % input as V/(g)!
sens_accel2 = 10.30/1000; % input as V/(g)!

label_force ="Force Transducer (N)";
label_accel1 = "Accelerometer Tip (N)";
label_accel2 = "Accelerometer Base (N)";

%% Setting up DAQ
Fs = 10000;
dt = 1/Fs;
SampleTime = 10;
pause(3)
s=daq('ni'); % use daq.getDevices to determine connected devices
ch_force = addinput(s,'Dev1','ai0','Voltage'); % assigns DAQ input channel
ch_accel1 = addinput(s,'Dev1','ai1','Voltage'); % assigns DAQ input channel
ch_accel2 = addinput(s,'Dev1','ai2','Voltage'); % assigns DAQ input channel

N = Fs*SampleTime; % set number of samples
s.Rate=Fs; % assigns DAQ sample rate

%% Recording Data
disp('DAQ recording')
[data, time] = read(s,N,OutputFormat="Matrix"); % inputs from DAQ

%% Plotting Data
time_force = data(:,1)/sens_force; % apply shaker sensitivity
time_accel1 = data(:,2)/sens_accel1; % apply accelerometer sensitivity
time_accel2 = data(:,3)/sens_accel2; % apply accelerometer sensitivity

figure
ax1=subplot(3,1,1);
plot(time,time_force)
title('Force vs Time')
ylabel(label_force)
xlabel('Seconds(s)')

ax2=subplot(3,1,2);
plot(time,time_accel1)
title('Force vs Time') 
ylabel(label_accel1)
xlabel('Seconds(s)')

ax3=subplot(3,1,3);
plot(time,time_accel2)
title('Force vs Time') 
ylabel(label_accel2)
xlabel('Seconds(s)')
linkaxes([ax1, ax2, ax3], 'x');

%% Savind Data
save([filename,'.mat'])