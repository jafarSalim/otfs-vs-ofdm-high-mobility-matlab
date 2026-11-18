function [x_mp, x_mmse, Hdd, y] = otfs_link(X, ch, p, snr_lin)
%OTFS_LINK  One OTFS frame through the channel, detected two ways:
%   x_mmse: block LMMSE on the full delay-Doppler matrix
%   x_mp:   message passing (Raviteja et al. 2018)
[M, N] = size(X);
s = otfs_mod(X, p.cp);
r = apply_channel(s, ch, p.fs);
sigma2 = 1/snr_lin;
r = r + sqrt(sigma2/2) * (randn(size(r)) + 1j*randn(size(r)));
y = otfs_demod(r, M, N, p.cp);
Hdd = otfs_channel_matrix(ch, M, N, p.fs, p.cp);
x_mmse = (Hdd'*Hdd + sigma2*eye(M*N)) \ (Hdd'*y);
x_mp = mp_detector(y, Hdd, sigma2, 20, 0.6, 0.03);
end
