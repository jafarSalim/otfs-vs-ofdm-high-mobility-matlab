function out = exp1_two_views()
%EXP1_TWO_VIEWS  The same 500 km/h channel seen in time-frequency and in delay-Doppler.
%   In time-frequency it fades and rotates from one symbol to the next (what OFDM sees).
%   In delay-Doppler the same channel is a handful of fixed taps (what OTFS sees).
p = otfs_params();  rng(7);
ch = draw_channel(p, 500);
M = p.M;  N = p.N;
Htf = tf_response(ch, p, M, N);
Hdd = otfs_channel_matrix(ch, M, N, p.fs, p.cp);
resp = reshape(abs(Hdd(:, 1)), M, N);            % response to a pulse at (delay 0, Doppler 0)
resp = fftshift(resp, 2);                         % Doppler axis centred on 0
h = figure('visible', 'off', 'position', [0 0 1500 600]);
subplot(1, 2, 1);
surf(1:N, (0:M-1)*p.df/1e3, abs(Htf), 'edgecolor', [0.2 0.2 0.25], 'linewidth', 0.3);
colormap(gca, hot_cool(256)); view(-40, 40); grid on; box on; set(gca, 'fontsize', 12);
xlabel('OFDM symbol'); ylabel('subcarrier frequency [kHz]'); zlabel('|H(t,f)|');
title('time-frequency: what OFDM sees');
subplot(1, 2, 2);
dop = (-N/2:N/2-1) / (N*p.T);
bar3c(resp(1:10, :), dop, 0:9);
colormap(gca, hot_cool(256)); view(-40, 40); grid on; set(gca, 'fontsize', 12);
xlabel('Doppler [Hz]'); ylabel('delay [samples]'); zlabel('|h(\tau,\nu)|');
title(sprintf('delay-Doppler: what OTFS sees (\\nu_{max} = %.0f Hz)', ch.nu_max));
save_figure(h, 'fig1_two_views');
out.nu_max = ch.nu_max;
out.k_max = ch.nu_max * N * p.T;
out.tf_var = std(abs(Htf(:))) / mean(abs(Htf(:)));
fprintf('exp1: nu_max = %.0f Hz = %.2f Doppler bins = %.3f of the subcarrier spacing\n', ch.nu_max, out.k_max, ch.nu_max/p.df);
end

function bar3c(Z, xv, yv)
% coloured 3D bars drawn with patches (bar3 colouring differs between MATLAB and Octave)
[ny, nx] = size(Z);
dx = 0.4 * (xv(2) - xv(1));  dy = 0.4;
zmax = max(Z(:));  cm = colormap(gca);
hold on;
for i = 1:ny
    for j = 1:nx
        z = Z(i, j);
        if z < 0.02*zmax, continue; end
        x0 = xv(j);  y0 = yv(i);
        X = x0 + [-dx dx dx -dx];  Y = y0 + [-dy -dy dy dy];
        col = cm(max(1, round(z/zmax*size(cm,1))), :);
        fill3(X, Y, z*[1 1 1 1], col, 'edgecolor', 'k', 'linewidth', 0.3);
        fill3([X(1) X(2) X(2) X(1)], [Y(1) Y(2) Y(2) Y(1)], [0 0 z z], col*0.85, 'edgecolor', 'k', 'linewidth', 0.3);
        fill3([X(2) X(3) X(3) X(2)], [Y(2) Y(3) Y(3) Y(2)], [0 0 z z], col*0.7, 'edgecolor', 'k', 'linewidth', 0.3);
        fill3([X(3) X(4) X(4) X(3)], [Y(3) Y(4) Y(4) Y(3)], [0 0 z z], col*0.85, 'edgecolor', 'k', 'linewidth', 0.3);
        fill3([X(4) X(1) X(1) X(4)], [Y(4) Y(1) Y(1) Y(4)], [0 0 z z], col*0.7, 'edgecolor', 'k', 'linewidth', 0.3);
    end
end
xlim([xv(1) xv(end)] + [-1 1]*dx*2);  ylim([yv(1)-1 yv(end)+1]);
caxis([0 zmax]);
end

function m = hot_cool(n)
k = [0.05 0.05 0.15; 0.12 0.25 0.65; 0.0 0.70 0.80; 0.0 0.78 0.59; 0.98 0.80 0.20; 0.96 0.26 0.21];
xi = linspace(0, 1, size(k,1));  t = linspace(0, 1, n);
m = [interp1(xi, k(:,1), t)' interp1(xi, k(:,2), t)' interp1(xi, k(:,3), t)'];
end
