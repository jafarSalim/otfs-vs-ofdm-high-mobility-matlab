function Htf = tf_response(ch, p, M, N)
%TF_RESPONSE  Time-frequency channel H(t, f) at the centre of each symbol of the frame (M-by-N).
Htf = zeros(M, N);
f = (0:M-1)';
for k = 1:N
    t = ((k-1)*M + M/2) / p.fs;
    for i = 1:numel(ch.h)
        Htf(:, k) = Htf(:, k) + ch.h(i) * exp(1j*2*pi*ch.nu(i)*t) * exp(-1j*2*pi*f*ch.l(i)/M);
    end
end
end
