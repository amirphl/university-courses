function x = idtfs(AK)
% Inverse Discrete Time Fourier Series
m = size(AK,1);            
lower_bound = -30;  % x[n] lower bound domain
upper_bound = 30;   % x[n] upper bound domain
x = zeros(1,(upper_bound - lower_bound)+ 1);        %stores x[n]
domain = zeros(1,(upper_bound - lower_bound)+ 1);   %stores x[n] domain
counter = 1;

for i = lower_bound:upper_bound
    temp = 0;
    for k = 1:m
       temp = temp + AK(k) * exp(1j * (k-1) * i * 2 * pi / m);
    end
    x(counter) = temp;
    domain(counter) = i;
    counter = counter + 1;
end

figure(4);
plot(domain,real(x),'*');
title('IDTFS real part');
xlabel('n');
ylabel('real(x[n])');

figure(5);
plot(domain,imag(x),'*');
title('IDTFS imaginary part')
xlabel('n');
ylabel('imag(x[n])');

end