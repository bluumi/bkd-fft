clear all
close all

f = imread('newyork-car.jpg');

f = im2double(f);

figure; imshow(f, []);
hold on;

[xes, yes] = ginput(2)

xc = xes(1)
yc = yes(1)
%halfside = max(abs(xes(2)-xc), abs(yes(2)-yc));
halfside = 256;                                     % iegust (izgriez) apgabalu, kura veiks FFT


f_cut = rgb2gray(f(yc-halfside+1:yc+halfside, xc-halfside+1:xc+halfside, :));
    %figure;
    %imshow(f_cut, []);
    N=length(f_cut);

subplot2=figure();
    set(subplot2, 'Name', 'All spectrums');
    
% LOGI
for i = 1:4
        w12 = [blackman(N)';bartlett(N)';hann(N)';hamming(N)'];
        f_cut_win = (f_cut.*w12(i)).*w12(i)';
        f_cut_fft = fft2(f_cut_win);
        log_f_cut = fftshift(log(abs(f_cut_fft)));
        subplot(2,2,i);
            imshow(log_f_cut, []);
            titles = {'BLACKMAN';'BARTLETT';'HANN';'HAMMING'};
            title(titles(i));
end

%f_cut_win=(f_cut.*w12).*w12';

%f_cut_fft = fft2(f_cut_win);
%log_f_cut = fftshift(log(abs(f_cut_fft)));


%figure;
%mesh(log_f_cut);

% SUBPLOTS KOPIGAM SKATAM:
subplot1=figure;
set(subplot1, 'Name', 'All images together');

subplot(2,2,[1,3]);
    imshow(f, []);
    title('Sample image')
    
subplot(2,2,2)
    imshow(f_cut, []);
    title('Cut-out of sample')
    
%subplot(2,2,4);
   % imshow(log_f_cut, []);
   % title('First log-spectrum of cut-out');


    
