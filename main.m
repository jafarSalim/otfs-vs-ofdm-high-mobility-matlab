%MAIN  OTFS against OFDM in high-mobility channels. Writes figures/ and results/.
%   Works in MATLAB (R2016b or newer, no toolboxes) and GNU Octave (6 or newer).
%   About 25 minutes with the default number of frames; lower 'frames' for a quick look.
clear; close all;
here = fileparts(mfilename('fullpath'));
if isempty(here), here = pwd; end
addpath(fullfile(here, 'src'), fullfile(here, 'experiments'));
t0 = tic;
r1 = exp1_two_views();
r4 = exp4_constellations();
r2 = exp2_ber_vs_snr(600);
r3 = exp3_ber_vs_speed(400, 15);
make_frames();
fid = fopen(fullfile(here, 'results', 'summary.txt'), 'w');
fprintf(fid, 'Max Doppler at 500 km/h: %.0f Hz = %.2f Doppler bins of the %dx%d frame\n', r1.nu_max, r1.k_max, 32, 16);
fprintf(fid, 'EVM at 500 km/h, 30 dB: OFDM %.1f%%, OTFS LMMSE %.1f%%\n', r4.evm_ofdm, r4.evm_otfs);
fprintf(fid, 'BER at 500 km/h (OFDM, OTFS LMMSE, OTFS MP), %.2g bits per point:\n', r2.nbits);
for i = 1:numel(r2.snrs)
    fprintf(fid, '  %2d dB: %.3g  %.3g  %.3g\n', r2.snrs(i), r2.B500(i,:));
end
fprintf(fid, 'BER at 15 dB against speed (OFDM, OTFS LMMSE, OTFS MP):\n');
for i = 1:numel(r3.v)
    fprintf(fid, '  %3d km/h: %.3g  %.3g  %.3g\n', r3.v(i), r3.B(i,:));
end
fprintf(fid, 'Run time: %.0f s\n', toc(t0));
fclose(fid);
type(fullfile(here, 'results', 'summary.txt'));
