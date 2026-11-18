function [ber, nbits] = ber_point(p, speed, snr_dB, frames)
%BER_POINT  Bit error rate of OFDM (one-tap), OTFS (LMMSE) and OTFS (message passing)
%   over the same random channels and the same transmitted bits.
snr = 10^(snr_dB/10);
err = zeros(1, 3);  nbits = 0;
MN = p.M * p.N;
for f = 1:frames
    ch = draw_channel(p, speed);
    [x, bits] = qpsk(MN);
    X = reshape(x, p.M, p.N);
    xo = ofdm_link(X, ch, p, snr);
    [xmp, xmm] = otfs_link(X, ch, p, snr);
    err(1) = err(1) + sum(sum(qpsk_bits(xo) ~= bits));
    err(2) = err(2) + sum(sum(qpsk_bits(xmm) ~= bits));
    err(3) = err(3) + sum(sum(qpsk_bits(xmp) ~= bits));
    nbits = nbits + numel(bits);
end
ber = err / nbits;
end
