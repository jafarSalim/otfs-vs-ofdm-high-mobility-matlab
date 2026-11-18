function Hdd = otfs_channel_matrix(ch, M, N, fs, cp)
%OTFS_CHANNEL_MATRIX  Effective delay-Doppler channel of one OTFS frame (MN-by-MN).
%   In the time domain, after removing the frame CP, each path is a cyclic delay
%   (permutation Pi^l) times a Doppler ramp (diagonal Delta), so
%       r = H s,  H = sum_i h_i Delta_i Pi^{l_i},  Delta_i = diag(exp(j 2 pi nu_i (n + cp)/fs)).
%   The DD-domain input-output relation is y = (F_N kron I_M) H (F_N^H kron I_M) x.
%   For integer Doppler it is sparse (P non-zeros per row); fractional Doppler spreads
%   each path over neighbouring Doppler bins.
MN = M*N;  n = (0:MN-1)';
H = zeros(MN);
I = eye(MN);
for i = 1:numel(ch.h)
    Pi = circshift(I, ch.l(i), 1);
    H = H + ch.h(i) * (exp(1j*2*pi*ch.nu(i)*(n + cp)/fs) .* Pi);
end
F = exp(-1j*2*pi*(0:N-1)'*(0:N-1)/N) / sqrt(N);
A = kron(F, eye(M));
Hdd = A * H * A';
end
