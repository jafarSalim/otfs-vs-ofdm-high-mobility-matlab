function ch = draw_channel(p, speed_kmh)
%DRAW_CHANNEL  One realization of the doubly-dispersive channel at a given speed.
%   ch.h:  complex path gains (sum of powers = 1)
%   ch.l:  integer delays [samples]
%   ch.nu: Doppler shifts [Hz], Jakes model nu_i = nu_max cos(theta_i)
nu_max = speed_kmh/3.6 * p.fc / p.c;
P = numel(p.delays);
pw = 10.^(p.pdp_dB/10);  pw = pw / sum(pw);
ch.h  = sqrt(pw/2) .* (randn(1, P) + 1j*randn(1, P));
ch.l  = p.delays;
ch.nu = nu_max * cos(2*pi*rand(1, P));
ch.nu_max = nu_max;
end
