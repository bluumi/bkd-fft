clear all
close all

fIDn = fopen('2020_05_30-NOISE.txt');
fIDrec = fopen('2020_05_30-M4.txt');
x=1186;
deg = 25; %% PARALELI CELAM!
shutter=1/100;
h_dist = 2.3;

noise = textscan(fIDn, '%s','delimiter','\n');
    noise = str2double(noise{1});
recData = textscan(fIDrec, '%s','delimiter','\n');
    recData = str2double(recData{1});
    recData = interp1(1:length(recData), recData, 1:1023)';
    maxVal = recData(1);
    recData(1) = 0;
    recData = recData(1:512);

[peaks, locs] = findpeaks(recData(2:512), 2:512, 'MinPeakHeight', maxVal/4);
peak = max(peaks);
loc = find(recData(1:512) == peak);

% h_sensor_size = 0.0223;
px_hor=2000;
% px_size = h_sensor_size/px_hor;

% prompt1 = 'Radar received speed (km/h): ';
% speed = input(prompt1);

% prompt2 = 'Shutter speed: ';
% shutter = input(prompt2);
% prompt4 = 'Approx. distance to middle of the lane (m): ';
% h_dist = input(prompt4);
% prompt5 = 'Focal length (mm): ';
% fcl = input(prompt5);
fcl = 18*1e-3;
fov18 = 66;
% prompt6 = 'Approx. angle, parallel to road: ';
% deg = input(prompt6);

fdop = loc*4.46;
c = 299792458; % m/s
f0=24.125e9;
speed = (fdop*c)/(2*f0*cosd(deg)); % m/s

if h_dist == 0 || deg ==0
% if deg == 0
    sensor_blur = 0;
else
    dist_to_obj = (h_dist)/cosd(90-deg);
    
    m_hor=(2*dist_to_obj*tand(fov18/2));
    vis_dist = 2*m_hor*cosd(deg);
    m_px=vis_dist/px_hor;
    
    act_speed = speed*cosd(deg); 
    distance = act_speed*shutter;
    
    sensor_blur = distance/m_px;
%     sensor_blur = (distance*fcl)/(px_size*dist_to_obj);
%     sensor_blur = sensor_blur*m_px;
    sensor_blur = sensor_blur*(2.1^(-2+x/500));
    sensor_blur = round(sensor_blur);
end

fprintf('Motion blur distance in px: %d\n', sensor_blur);

