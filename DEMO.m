
% Compare the performance of the two SISR models via contribution spectrum

rawimage= imread('data/CNNmodels/Autoencoder/Set5/epoch38_woman_GT_0raw.png');
autoencoder_up_image= imread('data/CNNmodels/Autoencoder/Set5/epoch38_woman_GT_1sr.png');
VDSR_up_image= imread('data/CNNmodels/VDSR/Set5/epoch37_woman_GT_1sr.png');

% first get the spectrum of these three images.
% the first 0 represents the mode, mode=0 means no Hanning window is
% applied; The second 0 means not showing the spectrum.
[ raw_img , raw_spec]= plot_spectrum( uint8(rawimage), 0, 0 );
[ auto_up_img,auto_up_spec] = plot_spectrum( uint8(autoencoder_up_image), 0, 0 );
[ vdsr_up_img,vdsr_up_spec] = plot_spectrum( uint8(VDSR_up_image),0 ,0 );

% the 2-D error spectrum of the autoencoder model and the vdsr model
error_spec_auto_2D= auto_up_spec-raw_spec;
error_spec_vdsr_2D= vdsr_up_spec-raw_spec;

L=40; % the number of rings in the rectangular ring spectrum

% get the esnr spectrum of the autoencoder model and the vdsr model
esnr_spectrum_auto = plot_esnr_spectra( raw_spec, error_spec_auto_2D, L ,0 ,'' );
esnr_spectrum_vdsr = plot_esnr_spectra( raw_spec, error_spec_vdsr_2D, L, 0, '' );

% get the weight spectrum
weight_spectrum_auto = plot_weight_spectra( error_spec_auto_2D, L, 0, '' );
weight_spectrum_vdsr = plot_weight_spectra( error_spec_vdsr_2D, L, 0, '' );

% get the error rectangular ring spectrum
error_spectrum_auto = plot_error_spectra( error_spec_auto_2D, L ,0 ,'' );
error_spectrum_vdsr = plot_error_spectra( error_spec_vdsr_2D, L ,0 ,'' );


% get the contribution spectrum of the auto encoder model against vdsr
% model
contrib_spec=plot_contribution_spectra( error_spectrum_vdsr, error_spectrum_auto  );

% The sum of the contribution spectrum should be 1
SumOfContributionSpectrum =  sum(contrib_spec)





