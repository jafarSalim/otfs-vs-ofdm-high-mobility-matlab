function out = exp2_ber_vs_snr(frames)
%EXP2_BER_VS_SNR  Uncoded QPSK BER against SNR at 500 km/h (and at 0 km/h for reference).
if nargin < 1, frames = 600; end
p = otfs_params();  c = neon();  rng(2);
snrs = 0:3:21;
B500 = zeros(numel(snrs), 3);  B0 = zeros(numel(snrs), 3);
for i = 1:numel(snrs)
    [B500(i,:), nb] = ber_point(p, 500, snrs(i), frames);
    B0(i,:) = ber_point(p, 0, snrs(i), round(frames/2));
    fprintf('  SNR %2d dB: 500 km/h %s | 0 km/h %s\n', snrs(i), mat2str(B500(i,:), 3), mat2str(B0(i,:), 3));
end
floorv = 1 / nb;                                  % one error in all simulated bits
h = figure('visible', 'off', 'position', [0 0 1000 640]);
mk = {'o', 's', 'd'};  cl = {c.ofdm, c.mmse, c.mp};
for j = 1:3
    y = max(B500(:,j), floorv/2);
    semilogy(snrs, y, ['-' mk{j}], 'color', cl{j}, 'linewidth', c.lw, 'markersize', 9, 'markerfacecolor', cl{j}); hold on;
end
for j = 1:3
    y = max(B0(:,j), floorv/2);
    semilogy(snrs, y, [':' mk{j}], 'color', cl{j}, 'linewidth', 1.6, 'markersize', 7);
end
semilogy([snrs(1) snrs(end)], [floorv floorv], '-', 'color', c.grey, 'linewidth', 1);
text(snrs(1)+0.3, floorv*1.6, sprintf('1 error in %.1e bits', nb), 'color', c.grey, 'fontsize', 10);
grid on; box on; set(gca, 'fontsize', 13, 'linewidth', 1.1);
xlabel('SNR [dB]'); ylabel('bit error rate');
title(sprintf('Uncoded QPSK, %dx%d frame, 6-path channel, 4 GHz', p.M, p.N));
legend({'OFDM one-tap, 500 km/h', 'OTFS LMMSE, 500 km/h', 'OTFS message passing, 500 km/h', ...
        'OFDM, 0 km/h', 'OTFS LMMSE, 0 km/h', 'OTFS MP, 0 km/h'}, 'location', 'southwest');
ylim([floorv/3 1]);
save_figure(h, 'fig2_ber_vs_snr');
write_csv('exp2_ber_vs_snr', 'snr_dB,ofdm_500,otfs_lmmse_500,otfs_mp_500,ofdm_0,otfs_lmmse_0,otfs_mp_0', [snrs' B500 B0]);
out.snrs = snrs;  out.B500 = B500;  out.B0 = B0;  out.nbits = nb;
end
