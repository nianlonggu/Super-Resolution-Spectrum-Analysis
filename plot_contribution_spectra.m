function contrib_spec = plot_contribution_spectra( error_spec1, error_spec2 )
% function contrib_spec = plot_contribution_spectra( esnr_spec1 , esnr_spec2,  weight_spec1, weight_spec2 )
%PLOT_CONTRIBUTION_SPECTRA Summary of this function goes here
%   Detailed explanation goes here

overall_error_change = sum(error_spec2)- sum(error_spec1);

diff_error_change = error_spec2-error_spec1;

contrib_spec = diff_error_change/overall_error_change;


contrib_spec_positive= max(contrib_spec, 0);
contrib_spec_negative= min(contrib_spec,0);


x=(1:numel(contrib_spec))/numel(contrib_spec);

bar(x, contrib_spec_positive , 'r');
hold on;
bar(x, contrib_spec_negative , 'b');
hold off;
xlabel('\pi/sample');
ylabel('contribution spectrum' );


end

