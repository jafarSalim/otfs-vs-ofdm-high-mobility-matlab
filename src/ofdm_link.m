function [xhat, Xeq] = ofdm_link(X, ch, p, snr_lin)
%OFDM_LINK  N OFDM symbols of M subcarriers, each with its own CP, through the channel.
%   Receiver: per-symbol one-tap MMSE equalizer with perfect knowledge of the channel at
%   the middle of each symbol. At high speed the channel changes within a symbol, the
%   subcarriers stop being orthogonal, and the leftover inter-carrier interference
%   (ICI) cannot be removed by a one-tap equalizer.
[M, N] = size(X);
Fm = exp(-1j*2*pi*(0:M-1)'*(0:M-1)/M) / sqrt(M);
blk = M + p.cp;
s = zeros(N*blk, 1);
for k = 1:N
    t = Fm' * X(:, k);
    s((k-1)*blk + (1:blk)) = [t(end-p.cp+1:end); t];
end
r = apply_channel(s, ch, p.fs);
sigma2 = 1/snr_lin;
r = r + sqrt(sigma2/2) * (randn(size(r)) + 1j*randn(size(r)));
Xeq = zeros(M, N);
for k = 1:N
    seg = r((k-1)*blk + p.cp + (1:M));
    Y = Fm * seg;
    tm = (k-1)*blk + p.cp + M/2;                    % middle of the useful part
    Hk = zeros(M, 1);
    for i = 1:numel(ch.h)
        Hk = Hk + ch.h(i) * exp(1j*2*pi*ch.nu(i)*tm/p.fs) * exp(-1j*2*pi*(0:M-1)'*ch.l(i)/M);
    end
    Xeq(:, k) = conj(Hk) .* Y ./ (abs(Hk).^2 + sigma2);
end
xhat = Xeq(:);
end
