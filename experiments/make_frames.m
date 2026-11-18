function make_frames()
%MAKE_FRAMES  Animation frames: the same six paths seen in delay-Doppler as the speed rises.
p = otfs_params();
here = fileparts(mfilename('fullpath'));
fdir = fullfile(here, '..', 'figures', 'frames');
if ~exist(fdir, 'dir'), mkdir(fdir); end
rng(7);
ch = draw_channel(p, 500);
dirs = ch.nu / ch.nu_max;                 % keep the angles, scale the speed
speeds = [linspace(0, 500, 30) linspace(500, 0, 30)];
bg = [0.04 0.05 0.09];
dop = (-p.N/2:p.N/2-1) / (p.N*p.T);
[DX, DY] = meshgrid(dop, 0:9);
for f = 1:numel(speeds)
    c2 = ch;  c2.nu = dirs * speeds(f)/3.6*p.fc/p.c;
    Hdd = otfs_channel_matrix(c2, p.M, p.N, p.fs, p.cp);
    resp = fftshift(reshape(abs(Hdd(:,1)), p.M, p.N), 2);
    Htf = abs(tf_response(c2, p, p.M, p.N));
    h = figure('visible', 'off', 'position', [0 0 1000 430], 'color', bg, 'inverthardcopy', 'off');
    ax1 = axes('position', [0.05 0.12 0.4 0.75], 'color', bg, 'xcolor', [0.7 0.7 0.8], 'ycolor', [0.7 0.7 0.8]);
    imagesc(1:p.N, (0:p.M-1)*p.df/1e3, Htf); caxis([0 2.5]); set(gca, 'ydir', 'normal', 'fontsize', 10);
    colormap(ax1, parula_like(128));
    set(ax1, 'color', bg, 'xcolor', [0.7 0.7 0.8], 'ycolor', [0.7 0.7 0.8]);
    xlabel('OFDM symbol'); ylabel('frequency [kHz]');
    title('|H(t,f)|  (OFDM view)', 'color', [0.92 0.94 1]);
    ax2 = axes('position', [0.56 0.12 0.40 0.75]);
    imagesc(dop/1e3, 0:9, sqrt(resp(1:10,:)));  caxis([0 0.75]);  set(gca, 'ydir', 'normal', 'fontsize', 10);
    colormap(ax2, neon(128));
    set(ax2, 'color', bg, 'xcolor', [0.7 0.7 0.8], 'ycolor', [0.7 0.7 0.8]);
    xlabel('Doppler [kHz]'); ylabel('delay [samples]');
    title(sprintf('|h(delay, Doppler)|  (OTFS view) at %3.0f km/h', speeds(f)), 'color', [0.92 0.94 1]);
    set(h, 'PaperPositionMode', 'auto');
    print(h, fullfile(fdir, sprintf('f%03d.png', f)), '-dpng', '-r100');
    close(h);
end
end

function m = parula_like(n)
k = [0.24 0.15 0.66; 0.15 0.45 0.98; 0.05 0.72 0.80; 0.45 0.82 0.40; 0.98 0.85 0.15];
xi = linspace(0, 1, size(k,1));  t = linspace(0, 1, n);
m = [interp1(xi, k(:,1), t)' interp1(xi, k(:,2), t)' interp1(xi, k(:,3), t)'];
end

function m = neon(n)
k = [0.04 0.05 0.09; 0.20 0.05 0.45; 0.85 0.10 0.65; 1.00 0.55 0.20; 1.00 0.95 0.70];
xi = linspace(0, 1, size(k,1));  t = linspace(0, 1, n);
m = [interp1(xi, k(:,1), t)' interp1(xi, k(:,2), t)' interp1(xi, k(:,3), t)'];
end
