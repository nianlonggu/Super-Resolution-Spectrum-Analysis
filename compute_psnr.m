function [psnr,betaratio]=compute_psnr(im1,im2, mode)
% im1 must be raw image!

if size(im1, 3) == 3
    im1 = rgb2ycbcr(im1);
    im1 = im1(:, :, 1);
end

if size(im2, 3) == 3
    im2 = rgb2ycbcr(im2);
    im2 = im2(:, :, 1);
end
factor=2;
betaratio=0;
switch mode
    case 'psnr_overall'
        imdff = double(im1) - double(im2);
        imdff = imdff(:);
        rmse = sqrt(mean(imdff.^2));
        psnr = 20*log10(255/rmse);
    case 'psnr_lowerhalf'
        F = fftshift(fft2(im1));
        F(size(F,1)/factor+1+size(F,1)/(2*factor):end,:) = 0;
        F(:,size(F,2)/factor+1+size(F,2)/(2*factor):end) = 0;
        F(1:size(F,1)/factor+1-size(F,1)/(2*factor),:) = 0;
        F(:,1:size(F,2)/factor+1-size(F,2)/(2*factor)) = 0;
        
        F1= F;
        
        F = fftshift(fft2(im2));
        F(size(F,1)/factor+1+size(F,1)/(2*factor):end,:) = 0;
        F(:,size(F,2)/factor+1+size(F,2)/(2*factor):end) = 0;
        F(1:size(F,1)/factor+1-size(F,1)/(2*factor),:) = 0;
        F(:,1:size(F,2)/factor+1-size(F,2)/(2*factor)) = 0;
        
        F2=F;
        
        fdiff = abs(F1-F2);
        fdiff = fdiff(:);
        rmse = sqrt (  1/((size(im1,1)*size(im1,2))^2) * sum( fdiff.^2 )  );
        psnr = 20*log10(255/rmse);
    case 'psnr_upperhalf'
        F = fftshift(fft2(im1));
        F( size(F,1)/factor+1-size(F,1)/(2*factor)+1:size(F,1)/factor+size(F,1)/(2*factor),  ...
            size(F,2)/factor+1-size(F,2)/(2*factor)+1:size(F,2)/factor+size(F,2)/(2*factor))=0;
        F1=F;
        F = fftshift(fft2(im2));
        F( size(F,1)/factor+1-size(F,1)/(2*factor)+1:size(F,1)/factor+size(F,1)/(2*factor),  ...
            size(F,2)/factor+1-size(F,2)/(2*factor)+1:size(F,2)/factor+size(F,2)/(2*factor))=0;
        F2=F;
        
        fdiff = abs(F1-F2);
        fdiff = fdiff(:);
        rmse = sqrt (  1/((size(im1,1)*size(im1,2))^2) * sum( fdiff.^2 )  );
        psnr = 20*log10(255/rmse);
    case 'esnr_upperhalf'
        F1 = fftshift(fft2(im1));  
        F2 = fftshift(fft2(im2));
        fdiff_all = abs(F1-F2);
        fdiff_all = fdiff_all(:);
        
        F = fftshift(fft2(im1));
        F( size(F,1)/factor+1-size(F,1)/(2*factor)+1:size(F,1)/factor+size(F,1)/(2*factor),  ...
            size(F,2)/factor+1-size(F,2)/(2*factor)+1:size(F,2)/factor+size(F,2)/(2*factor))=0;
        
        HF1 = F;
        F = fftshift(fft2(im2));
        F( size(F,1)/factor+1-size(F,1)/(2*factor)+1:size(F,1)/factor+size(F,1)/(2*factor),  ...
            size(F,2)/factor+1-size(F,2)/(2*factor)+1:size(F,2)/factor+size(F,2)/(2*factor))=0;
        
        HF2 = F;
        fdiff = abs(HF1-HF2);
        fdiff = fdiff(:);
        
        hfraw = abs(HF1);
        hfraw=hfraw(:);
        psnr = 10 * log10(  sum( hfraw.^2 )/sum(fdiff.^2) );
        
        betaratio=  sum(fdiff.^2)/ sum(fdiff_all.^2);
     
    case 'esnr_lowerhalf'
        
        F = fftshift(fft2(im1));
        F(size(F,1)/factor+1+size(F,1)/(2*factor):end,:) = 0;
        F(:,size(F,2)/factor+1+size(F,2)/(2*factor):end) = 0;
        F(1:size(F,1)/factor+1-size(F,1)/(2*factor),:) = 0;
        F(:,1:size(F,2)/factor+1-size(F,2)/(2*factor)) = 0;
        
        LF1= F;
        
        F = fftshift(fft2(im2));
        F(size(F,1)/factor+1+size(F,1)/(2*factor):end,:) = 0;
        F(:,size(F,2)/factor+1+size(F,2)/(2*factor):end) = 0;
        F(1:size(F,1)/factor+1-size(F,1)/(2*factor),:) = 0;
        F(:,1:size(F,2)/factor+1-size(F,2)/(2*factor)) = 0;
        
        LF2= F;
        
        fdiff = abs(LF1-LF2);
        fdiff = fdiff(:);
        lfraw = abs(LF1);
        lfraw=lfraw(:);
        psnr = 10 * log10( sum(lfraw.^2)/sum(fdiff.^2) );
        
        
        
        
    case 'esnr_overall'
        F1 = fftshift(fft2(im1));  
        F2 = fftshift(fft2(im2));
        fdiff = abs(F1-F2);
        fdiff = fdiff(:);
        fraw = abs(F1);
        fraw=fraw(:);
        psnr = 10 * log10( sum(fraw.^2)/sum(fdiff.^2) );
    
        
        
end