function p = otfs_params()
%OTFS_PARAMS  Frame and channel parameters: a 4 GHz link with 15 kHz subcarriers (NR numerology 0).
p.M      = 32;          % subcarriers (delay bins)
p.N      = 16;          % symbols per frame (Doppler bins)
p.df     = 15e3;        % subcarrier spacing [Hz]
p.T      = 1/p.df;      % symbol duration [s]
p.fc     = 4e9;         % carrier [Hz]
p.c      = 3e8;
p.fs     = p.M * p.df;  % sampling rate [Hz]
p.cp     = 8;           % cyclic prefix [samples] >= largest path delay
% 6-path channel with an exponential power-delay profile (integer delays in samples,
% 2.08 us per sample), Jakes Doppler: nu_i = nu_max cos(theta_i), theta_i uniform.
p.delays = [0 1 2 3 4 5];
p.pdp_dB = [0 -1.5 -3 -4.5 -6 -7.5];
p.Q      = 4;           % QPSK
end
