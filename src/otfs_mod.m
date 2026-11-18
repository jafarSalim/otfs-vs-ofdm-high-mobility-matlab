function s = otfs_mod(X, cp)
%OTFS_MOD  OTFS transmitter with a rectangular pulse and one cyclic prefix per frame.
%   X: M-by-N grid of symbols in the delay-Doppler domain.
%   ISFFT + Heisenberg with rectangular pulses reduces to an inverse DFT along the
%   Doppler axis: each column of S = X * F_N^H is one block of M time samples.
[M, N] = size(X);
S = X * dftmtx_n(N)';                 % M-by-N, IFFT over the Doppler index
s = S(:);                             % N blocks of M samples
s = [s(end-cp+1:end); s];             % reduced CP for the whole frame
end

function F = dftmtx_n(N)
F = exp(-1j*2*pi*(0:N-1)'*(0:N-1)/N) / sqrt(N);
end
