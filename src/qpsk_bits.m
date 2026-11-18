function bits = qpsk_bits(x)
%QPSK_BITS  Hard decisions of Gray-mapped QPSK: 2-by-numel(x) bits.
x = x(:).';
bits = [real(x) < 0; imag(x) < 0];
end
