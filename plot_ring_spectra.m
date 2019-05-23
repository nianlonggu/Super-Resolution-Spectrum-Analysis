function ring_spec = plot_ring_spectra(myspec, L, show_spectra, tag )
%RING_SPECTRA Summary of this function goes here
%   Detailed explanation goes here
spec= myspec;
[H,W] = size(spec);

ring_spec = zeros(L,1);
% get the center position
CP = ceil((size(spec)+1)/2);
stride = floor((size(spec)-CP)/L)
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
    ring_spec(i) = sum( spec_tmp.^2 );
    %{
    % This method does not work properly
    if i ~= L
        spec_tmp =  spec(  CP(1)- i*stride(1)+1: CP(1)+i*stride(1)-1, CP(2)-i*stride(2)+1:CP(2)+i*stride(2)-1 );
    else
        spec_tmp = spec;
    end
    
    CP_tmp = ceil((size(spec_tmp)+1)/2);
    spec_tmp(CP_tmp(1)-(i-1)*stride(1)+1:CP_tmp(1)+(i-1)*stride(1)-1,CP_tmp(2)-(i-1)*stride(2)+1:CP_tmp(2)+(i-1)*stride(2)-1  )= zeros( 2*(i-1)*stride(1)-1, 2*(i-1)*stride(2)-1 );
    
    spec_tmp = abs(spec_tmp);
    spec_tmp = spec_tmp(:);
    ring_spec(i) = sum( spec_tmp.^2 );
    %}  
    
    %{
    % This method works, but it's too slow!
    spec_tmp =[];
    for h = 1:H
        for w =1:W
            if   (abs(CP(1)-h)+1)/CP(1) <= i/L && (abs(CP(2)-w)+1)/CP(2) <= i/L && ((abs(CP(2)-w)+1)/CP(2) > (i-1)/L  ...
                      ||  (abs(CP(1)-h)+1)/CP(1) > (i-1)/L )
                  
                spec_tmp =[spec_tmp, spec(h,w)];
         
            end
        end
    end
    spec_tmp = abs(spec_tmp);
    ring_spec(i) = sum(spec_tmp.^2);
    %}
    
end

if show_spectra
   x= 1:L;
   x= x/L;
   plot(x,10*log10(ring_spec),tag);
    
end


end

