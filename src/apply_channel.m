function r = apply_channel(s, ch, fs, t0)
%APPLY_CHANNEL  Pass a sampled signal through a time-varying multipath channel:
%   r[n] = sum_i h_i exp(j 2 pi nu_i (n + t0)/fs) s[n - l_i]
%   (the Doppler phase keeps running across the whole signal, including the CP).
if nargin < 4, t0 = 0; end
s = s(:);  n = (0:numel(s)-1)';
r = zeros(size(s));
for i = 1:numel(ch.h)
    shifted = [zeros(ch.l(i), 1); s(1:end-ch.l(i))];
    r = r + ch.h(i) * exp(1j*2*pi*ch.nu(i)*(n + t0)/fs) .* shifted;
end
end
