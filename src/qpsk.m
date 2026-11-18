function [x, bits] = qpsk(nsym)
%QPSK  Gray-mapped QPSK symbols with unit average energy, and the bits they carry.
bits = randi([0 1], 2, nsym);
x = ((1 - 2*bits(1,:)) + 1j*(1 - 2*bits(2,:))) / sqrt(2);
x = x(:);
end
