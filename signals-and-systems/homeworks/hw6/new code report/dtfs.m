function AK = dtfs(x)
% Discrete Time Fourier Series
% input x[n], output AK
m = size(x,2);
AK = zeros(m,1);
domain = zeros(m,1);
counter = 1;

for i = 1:m
    temp = 0;
    for k = 1:m
       temp = temp + x(k) .* exp(-1j * (i-1) * (k-1) * 2 * pi / m); 
    end
    temp = temp / m;
    AK(counter) = temp;
    domain(counter) = counter - 1;
    counter = counter + 1;
end

figure(1);
plot(domain,real(AK),'*');
title('DTFS real part');
xlabel('0 to N-1');
ylabel('real(AK)');

figure(2);
plot(domain,imag(AK),'*');
title('DTFS imaginary part')
xlabel('0 to N-1');
ylabel('imag(AK)');

figure(3);
plot(domain,angle(AK),'*');
title('DTFS phase part')
xlabel('0 to N-1');
ylabel('angle(AK)');

end