%%--------------------------------
% Blur convolution example with FFT images
%%--------------------------------

clear all
close all

%% Original Image
f = imread('f1_car.jpg');
f = im2double(f);

figure; imshow(f, []);

[xes, yes] = size(squeeze(f(:,:,1)));

xc = xes(1)/2+128;
yc = yes(1)/2-128;

%halfside = max(abs(xes(2)-xc), abs(yes(2)-yc));
halfside = 96;     % iegust (izgriez) apgabalu, kura veiks FFT


f_cut = rgb2gray(f(yc-halfside+1:yc+halfside, xc-halfside+1:xc+halfside, :));
%figure;
    %imshow(f_cut, []);
    N=length(f_cut);
    
w12=hann(N)';
f_cut_win=(f_cut.*w12).*w12';

f_cut_fft = fft2(f_cut_win);
log_f_cut = log(1+abs(fftshift(f_cut_fft)));
    
%% PSF
lenkis = 30;
psf_name = (['deg',num2str(lenkis),'.jpg']);
h = imread(psf_name);		% PSF filename
h = im2double(h);

if lenkis == 0
    lenkis = 1;
elseif lenkis == 45
    lenkis = lenkis + 1;
end

[hxes, hyes] = size(squeeze(h(:,:,1)));
hxc = hxes(1)/2;
hyc = hyes(1)/2;

%h_cut = rgb2gray(h(hyc-halfside/2+1:hyc+halfside/2, hxc-halfside/2+1:hxc+halfside/2, :));
h_cut=rgb2gray(h(1:hyes(1),1:hxes(1),:));
    N_h=length(h_cut);
    
% w12=hann(N_h)';
% h_cut_win=(h_cut.*w12).*w12';

h_cut_fft = ifft2(h_cut);
log_h_cut = log(0.25+abs(fftshift(h_cut_fft)));

%% CONVOLUTED IMAGE
% Specify distortion parameters:
number_of_quantization_levels = 2^16;
noise_energy = 0.0; % use range 0 to 1

h = (h(:,:,1) + h(:,:,2) + h(:,:,3)) / 3;
yhc = ceil(size(h,1)/2);
xhc = ceil(size(h,2)/2);

g = zeros(size(f));
g(:,:,1) = imfilter(f(:,:,1), h, 'replicate');
g(:,:,2) = imfilter(f(:,:,2), h, 'replicate');
g(:,:,3) = imfilter(f(:,:,3), h, 'replicate');

% Applying some quantization noise and white noise:
g = g - min(min(min(g)));
g = g / max(max(max(g)));
g = round(g * (number_of_quantization_levels - 1)) / (number_of_quantization_levels - 1);
g = g + randn(size(g)) * noise_energy;


bb = add_mask_to_image(g, []);
figure; imshow(bb, []);

b_cut = rgb2gray(bb(yc-halfside+1:yc+halfside, xc-halfside+1:xc+halfside, :));
    N_b=length(b_cut);
    
w12=hann(N_b)';
b_cut_win=(b_cut.*w12).*w12';

b_cut_fft = fft2(b_cut_win);
log_b_cut = log(1+abs(fftshift(b_cut_fft)));
    log_b_cut = log_b_cut - min(log_b_cut(:));
    log_b_cut = log_b_cut / max(log_b_cut(:));  

theta=[0:180];
[b_cut_rad,xp]=radon(log_b_cut,theta);
figure;
b_cut_rad = b_cut_rad - min(b_cut_rad(:));
b_cut_rad = b_cut_rad / max(b_cut_rad(:));
imshow(b_cut_rad, [],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
axis normal
xlabel('\theta (degrees)')

figure('Name', 'Radona transformacijas likne kustibas izpludumam'),
plot(-(length(b_cut_rad)-1)/2:(length(b_cut_rad)-1)/2,b_cut_rad(:,lenkis),'LineWidth', 1.25)
    xlim([-(length(b_cut_rad)-1)/2 (length(b_cut_rad)-1)/2])
    xticks([-(length(b_cut_rad)-1)/2 0 (length(b_cut_rad)-1)/2])
    grid on, grid minor
    ylim([0 1.1])
    xlabel(['pixels']), ylabel('Amplitude')
    
N=length((b_cut_rad(:,lenkis)));
F=fft(b_cut_rad(:,lenkis));
    F=F-min(F);
    F=F/max(F);
Fr=(-N/2:N/2-1)*length(b_cut(:,1))/N;
figure('Name', 'FFT of RT'),
    plot(Fr-Fr(round(N/2)),abs(fftshift(F)),'LineWidth',1.25)
    ylim([0 1.1])
    grid on, grid minor
    xlabel(['pixels']), ylabel('Amplitude')
%% ALL IMAGES TOGETHER

subplot3=figure;
set(subplot3, 'Name', 'Images and their FFTs');
set(subplot3, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

subplot(2,3,1);
    imshow(f_cut, []);
    title('Sample image')
    
subplot(2,3,4);
    imshow(log_f_cut, []);

subplot(2,3,2);
    imshow(h_cut, []);
    title('Sample PSF')
    
subplot(2,3,5);
    imshow(log_h_cut, []);
    
subplot(2,3,3);
    imshow(b_cut,[]);
    title('Final image')
    
subplot(2,3,6);
    imshow(log_b_cut, []);