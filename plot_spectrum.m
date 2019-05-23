function [im_plotted, spectrum_plotted] = plot_spectrum(im,mode, isShowSpectrum)
%PLOT_SPECTRUM Summary of this function goes here
%   Detailed explanation goes here
% mode = 0, no padding, no windowing, directly plot spectrum
% mode = 1, add fadding pading, then plot spectrum and crop
% mode = 2, add pure hamming window, and then plot spectrum
% mode = 3, only add intra filtering near border, then plot spectrum
% mode = 4, plot the lower half spectrum
% mode = 5, plot the upper half spectrum
switch mode
    case 0
        F = fftshift(fft2(im));
        S = log(1+abs(F));
%         imshow(S,[]);
        im_plotted= im;
        spectrum_plotted = F;
    case 1
        w_func ='hann';   
        img_H = size(im,1);
        img_W = size(im,2);
        percent=0.1;
        padding_H = int32(img_H*percent);
        padding_W = int32(img_W * percent);
        %generate window with fadding padding
        w_H= window(w_func, 1+2*padding_H);
        w_H= [w_H(1:padding_H); ones(img_H,1); w_H(padding_H +2:end)];
        w_W = window(w_func, 1+2*padding_W);
        w_W = [w_W(1:padding_W); ones(img_W,1); w_W(padding_W+2:end)];
        [mask_W, mask_H] = meshgrid(w_W, w_H);
        w= mask_W .* mask_H;
        %generate image with replicated padding.
        im_pad = padarray(im, [double(padding_H), double(padding_W)], 'replicate');
        im_with_fadding_pad =  double( im_pad) .* w;
        % plot spectrum
        F = fftshift(fft2(im_with_fadding_pad));
        S = log(1+ abs(F));
        % do crop to the spetrum to get original size
        S = S(padding_H+1:end-padding_H, padding_W+1:end-padding_W );
%         imshow(S,[]);
        im_plotted= im_with_fadding_pad;
        spectrum_plotted =  F(padding_H+1:end-padding_H, padding_W+1:end-padding_W );
    case 2
        img_H = size(im,1);
        img_W = size(im,2);
        w_func= 'hann';
        % generate hamming filter window
        w_H = window(w_func, img_H);
        w_W = window(w_func, img_W);
        [mask_W, mask_H] = meshgrid(w_W, w_H);
        w= mask_W .* mask_H;
        % generate hamming window filtered image
        im_filtered = double(im) .* w;
        F = fftshift(fft2(im_filtered));
        S = log(1+abs(F));
%         imshow(S,[]);
        im_plotted= im_filtered;
        spectrum_plotted = F;
    case 3   
        w_func ='hann';   
        img_H = size(im,1);
        img_W = size(im,2);
        percent=0.1;
        intra_padding_H = int32(img_H*percent);
        intra_padding_W = int32(img_W * percent);
        %generate window with fadding padding
        w_H= window(w_func, 1+2*intra_padding_H);
        w_H= [w_H(1:intra_padding_H); ones(img_H-2*intra_padding_H,1); w_H(intra_padding_H+2:end)];
        w_W = window(w_func, 1+2*intra_padding_W);
        w_W = [w_W(1:intra_padding_W); ones(img_W-2*intra_padding_W,1); w_W(intra_padding_W+2:end)];
        [mask_W, mask_H] = meshgrid(w_W, w_H);
        w= mask_W .* mask_H;
        %generate image with replicated padding.
        im_with_intra_fadding_pad =  double( im) .* w;
        % plot spectrum
        F = fftshift(fft2(im_with_intra_fadding_pad));
        S = log(1+ abs(F));
%         imshow(S,[]);
        im_plotted= im_with_intra_fadding_pad;
        spectrum_plotted = F;
   
    case 4
        F = fftshift(fft2(im));
        %{
        centerPos = ceil((size(F)+1)/2);
        F( centerPos(1)-floor(size(F,1)/4):centerPos(1)+ceil(size(F,1)/4)-1, ...
                centerPos(2)-floor(size(F,2)/4):centerPos(2)+ceil(size(F,2)/4)-1)= ...
                zeros( floor(size(F,1)/4) + ceil(size(F,1)/4), floor(size(F,2)/4) + ceil(size(F,2)/4));
        %}
        factor=2;
        F(size(F,1)/factor+1+size(F,1)/(2*factor):end,:) = 0;
        F(:,size(F,2)/factor+1+size(F,2)/(2*factor):end) = 0;
        F(1:size(F,1)/factor+1-size(F,1)/(2*factor),:) = 0;
        F(:,1:size(F,2)/factor+1-size(F,2)/(2*factor)) = 0;
        
        S = log(1+abs(F));
%         imshow(S,[]);
        im_high_pass = ifft2(ifftshift(F), 'symmetric');
        im_plotted=im_high_pass;
        spectrum_plotted = F;
        
    case 5
        
        F = fftshift(fft2(im));
        %{
        centerPos = ceil((size(F)+1)/2);
        tempF = zeros(size(F,1), size(F,2));
        tempF( centerPos(1)-floor(size(F,1)/4):centerPos(1)+ceil(size(F,1)/4)-1, ...
                centerPos(2)-floor(size(F,2)/4):centerPos(2)+ceil(size(F,2)/4)-1)= ...
           F( centerPos(1)-floor(size(F,1)/4):centerPos(1)+ceil(size(F,1)/4)-1, ...
              centerPos(2)-floor(size(F,2)/4):centerPos(2)+ceil(size(F,2)/4)-1);
        F = tempF;
        %}
        factor=2;
        F( size(F,1)/factor+1-size(F,1)/(2*factor)+1:size(F,1)/factor+size(F,1)/(2*factor),  ...
            size(F,2)/factor+1-size(F,2)/(2*factor)+1:size(F,2)/factor+size(F,2)/(2*factor))=0;
        
        S = log(1+abs(F));
%         imshow(S,[]);
        im_low_pass = ifft2(ifftshift(F),'symmetric');
        im_plotted=  im_low_pass;
        spectrum_plotted = F;
        
end

if isShowSpectrum
    imshow(S,[] );
end

end

