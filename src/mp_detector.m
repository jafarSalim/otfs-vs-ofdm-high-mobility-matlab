function xhat = mp_detector(y, Hdd, sigma2, iters, damp, thr)
%MP_DETECTOR  Message-passing detection of QPSK in the delay-Doppler domain.
%
%   Raviteja, Phan, Hong, Viterbo, "Interference Cancellation and Iterative Detection
%   for Orthogonal Time Frequency Space Modulation", IEEE Trans. Wireless Commun., 2018.
%   Every observation y_d sees a few symbols x_c through the sparse matrix Hdd. Each
%   observation models the interference on a symbol as Gaussian (mean and variance from
%   the other symbols' current probabilities); each symbol node multiplies the evidence
%   from its observations. Probabilities are damped between iterations.
%   Entries of Hdd below thr * max|Hdd| are ignored (fractional Doppler leaks a little).
if nargin < 4, iters = 20; end
if nargin < 5, damp = 0.6; end
if nargin < 6, thr = 0.03; end
A = ((1 - 2*[0 0 1 1]) + 1j*(1 - 2*[0 1 0 1])) / sqrt(2);   % QPSK alphabet, Gray
Q = numel(A);
[d, cI] = find(abs(Hdd) > thr * max(abs(Hdd(:))));
h = Hdd(sub2ind(size(Hdd), d, cI));
E = numel(h);  MN = numel(y);
P = ones(E, Q) / Q;                         % P(e, a): message from symbol c(e) to observation d(e)
for it = 1:iters
    m  = P * A.';                           % mean of x_c as seen by edge e
    v  = P * (abs(A').^2) - abs(m).^2;      % its variance
    hm = h .* m;   hv = abs(h).^2 .* v;
    Sm = accumarray(d, hm, [MN 1]);         % totals per observation
    Sv = accumarray(d, hv, [MN 1]);
    mu = Sm(d) - hm;                        % interference mean, excluding the edge's own symbol
    s2 = Sv(d) - hv + sigma2;
    LL = -abs(y(d) - mu - h .* A).^2 ./ s2; % log-likelihood of each alphabet point, per edge
    T  = zeros(MN, Q);                       % sum of log-likelihoods per symbol node
    for q = 1:Q
        T(:, q) = accumarray(cI, LL(:, q), [MN 1]);
    end
    Lext = T(cI, :) - LL;                   % extrinsic: leave out the edge itself
    Lext = Lext - max(Lext, [], 2);
    Pn = exp(Lext);  Pn = Pn ./ sum(Pn, 2);
    P  = damp * Pn + (1 - damp) * P;
end
[~, k] = max(T, [], 2);
xhat = A(k).';
end
