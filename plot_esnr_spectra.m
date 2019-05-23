function esnr_spec = plot_esnr_spectra(rawspec, input_spec , L, show_spectra, tag )
%RING_SPECTRA Summary of this function goes here
%   Detailed explanation goes here
%  here input_spec is the error spectrum
spec= rawspec;
[H,W] = size(spec);

esnr_spec = zeros( 1,L );
% get the center position
CP = ceil((size(spec)+1)/2);
stride = floor((size(spec)-CP)/L);
for i = 1 :L
    
    % This methods works best!
    inner_vertex_1= max( CP - (ceil(CP*(i-1)/L)+( ceil(CP*( i-1)/L) == CP*( i-1)/L ))+2, [1,1] );
    inner_vertex_2= min( CP + (ceil(CP*(i-1)/L)+( ceil(CP*( i-1)/L) == CP*( i-1)/L ))-2, size(spec) );
    
    outer_vertex_1= max( CP - (ceil(CP*(i)/L)+( ceil(CP*( i)/L) == CP*( i)/L ))+2, [1,1] );
    outer_vertex_2= min( CP + (ceil(CP*(i)/L)+( ceil(CP*( i)/L) == CP*( i)/L ))-2, size(spec) );
    
    spec(inner_vertex_1(1):inner_vertex_2(1), inner_vertex_1(2):inner_vertex_2(2)) = 0;
    spec_tmp = spec( outer_vertex_1(1):outer_vertex_2(1), outer_vertex_1(2):outer_vertex_2(2) );
    spec_tmp = abs(spec_tmp);
    spec_tmp = spec_tmp(:);
    
    input_spec(inner_vertex_1(1):inner_vertex_2(1), inner_vertex_1(2):inner_vertex_2(2)) = 0;
    input_spec_tmp = input_spec( outer_vertex_1(1):outer_vertex_2(1), outer_vertex_1(2):outer_vertex_2(2) );
    input_spec_tmp = abs(input_spec_tmp);
    input_spec_tmp = input_spec_tmp(:);
    
    esnr_spec(i) = 10*log10( sum( spec_tmp.^2 )/sum( input_spec_tmp.^2 )  );
    
   
    
end

if show_spectra
   x= 1:L;
   x= x/L;
   plot(x,esnr_spec,tag);
    
end


end

