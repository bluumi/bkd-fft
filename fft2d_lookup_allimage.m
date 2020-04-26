clear all
close all

f = imread('skyline.jpg');
%f = imresize(f, 0.25);
f = im2double(f);

%figure; imshow(f, []);
hold on;

size_y = size(f,1);
size_x = size(f,2);
%n_colors = size(img,3);

xc=size_x/2; % center of x
yc=size_y/2; % center of y

f_cut=rgb2gray(f(1:size_y,1:size_x,:));
    N=length(f_cut);
    
w12=blackman(N)';

f_cut_win=(f_cut.*w12).*w12';


f_cut_fft = fft2(f_cut_win);
log_f_cut = log(0.25+abs(fftshift(f_cut_fft)));

theta=[0:180];
[f_cut_rad,xp]=radon(log_f_cut,theta);
figure;
f_cut_rad = f_cut_rad - min(f_cut_rad(:));
f_cut_rad = f_cut_rad / max(f_cut_rad(:));
imshow(f_cut_rad, [],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
xlabel('\theta (degrees)')
ylabel('L')
% 
% f_cut_irad=iradon(f_cut_rad,0:180);
% figure;
% imshow(f_cut_irad);

% figure(4);
% for i=182
% plot(0:180,f_cut_rad(i,:));
% end

% SUBPLOTS KOPIGAM SKATAM:
subplot1=figure;
set(subplot1, 'Name', 'All images together');

subplot(2,2,[1,3]);
    imshow(f, []);
    title('Sample image')
    
subplot(2,2,2)
    imshow(f_cut, []);
    title('Cut-out of sample')
    
subplot(2,2,4);
    imshow(log_f_cut, []);
    title('First log-spectrum of cut-out');