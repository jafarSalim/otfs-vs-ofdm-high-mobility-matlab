function y = otfs_demod(r, M, N, cp)
%OTFS_DEMOD  Remove the frame CP and go back to the delay-Doppler domain: y = vec(R F_N).
r = r(cp+1:cp+M*N);
R = reshape(r, M, N);
F = exp(-1j*2*pi*(0:N-1)'*(0:N-1)/N) / sqrt(N);
Y = R * F.';
y = Y(:);
end
