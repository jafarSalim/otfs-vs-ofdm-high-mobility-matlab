function out = exp3_ber_vs_speed(frames, snr_dB)
%EXP3_BER_VS_SPEED  BER against speed at a fixed SNR: OFDM degrades as the channel
%   changes within a symbol (ICI); OTFS improves, because more Doppler spread means
%   more resolvable paths in the delay-Doppler grid, i.e. more diversity.
if nargin < 1, frames = 400; end
if nargin < 2, snr_dB = 15; end
p = otfs_params();  c = neon();  rng(3);
v = 0:50:500;
B = zeros(numel(v), 3);
for i = 1:numel(v)
    [B(i,:), nb] = ber_point(p, v(i), snr_dB, frames);
    fprintf('  %3d km/h: %s\n', v(i), mat2str(B(i,:), 3));
end
floorv = 1/nb;
h = figure('visible', 'off', 'position', [0 0 1000 600]);
mk = {'o', 's', 'd'};  cl = {c.ofdm, c.mmse, c.mp};
for j = 1:3
    semilogy(v, max(B(:,j), floorv/2), ['-' mk{j}], 'color', cl{j}, 'linewidth', c.lw, 'markersize', 9, 'markerfacecolor', cl{j}); hold on;
end
semilogy([0 500], [floorv floorv], '-', 'color', c.grey);
nu = v/3.6*p.fc/p.c;
for s = [120 300 500]
    plot([s s], [floorv/3 1], ':', 'color', c.grey);
end
text(122, 0.5, 'highway', 'fontsize', 10, 'color', c.grey);
text(302, 0.5, 'high-speed rail', 'fontsize', 10, 'color', c.grey);
text(440, 0.5, 'maglev', 'fontsize', 10, 'color', c.grey);
grid on; box on; set(gca, 'fontsize', 13, 'linewidth', 1.1);
xlabel(sprintf('speed [km/h]   (max Doppler at 500 km/h: %.0f Hz = %.1f%% of the subcarrier spacing)', nu(end), 100*nu(end)/p.df));
ylabel('bit error rate');
title(sprintf('BER against speed at SNR = %d dB', snr_dB));
legend({'OFDM one-tap', 'OTFS LMMSE', 'OTFS message passing'}, 'location', 'southwest');
ylim([floorv/3 1]);
save_figure(h, 'fig3_ber_vs_speed');
write_csv('exp3_ber_vs_speed', 'speed_kmh,ofdm,otfs_lmmse,otfs_mp', [v' B]);
out.v = v;  out.B = B;  out.nbits = nb;
end
