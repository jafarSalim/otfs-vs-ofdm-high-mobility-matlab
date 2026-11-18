function out = exp4_constellations()
%EXP4_CONSTELLATIONS  Equalized symbols at 500 km/h and 30 dB SNR: the noise is negligible,
%   so what remains in OFDM is inter-carrier interference.
p = otfs_params();  c = neon();  rng(4);
snr = 10^(30/10);
xo = [];  xm = [];  xt = [];
for f = 1:8
    ch = draw_channel(p, 500);
    [x, ~] = qpsk(p.M*p.N);
    X = reshape(x, p.M, p.N);
    xo = [xo; ofdm_link(X, ch, p, snr)]; %#ok<AGROW>
    [~, x2] = otfs_link(X, ch, p, snr);
    xm = [xm; x2]; %#ok<AGROW>
    xt = [xt; x]; %#ok<AGROW>
end
evm = @(y) 100*sqrt(mean(abs(y - xt).^2) / mean(abs(xt).^2));
h = figure('visible', 'off', 'position', [0 0 1300 620], 'color', 'w');
data = {xo, xm};  ttl = {sprintf('OFDM one-tap: EVM %.1f%%', evm(xo)), sprintf('OTFS LMMSE: EVM %.1f%%', evm(xm))};
cl = {c.ofdm, c.mmse};
for k = 1:2
    subplot(1, 2, k);
    plot(real(data{k}), imag(data{k}), '.', 'color', cl{k}, 'markersize', 5); hold on;
    plot([-1 1 -1 1]/sqrt(2), [-1 -1 1 1]/sqrt(2), '+', 'color', c.ink, 'markersize', 14, 'linewidth', 2);
    axis([-1.6 1.6 -1.6 1.6]); axis square; grid on; box on; set(gca, 'fontsize', 13);
    xlabel('in-phase'); ylabel('quadrature');
    title(ttl{k});
end
save_figure(h, 'fig4_constellations');
out.evm_ofdm = evm(xo);  out.evm_otfs = evm(xm);
fprintf('exp4: EVM OFDM %.1f%%, OTFS %.1f%% at 500 km/h, 30 dB\n', out.evm_ofdm, out.evm_otfs);
end
