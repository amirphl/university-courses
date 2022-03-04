function x = idtft(X)
% Inverse Discrete Time Fourier Transform
% input X(jw), output x[n] in domain -10 , 10
m = size(X);            
step = 1;
dtft_step = 0.1;    % same as step parameter used in dtft function
lower_bound = -10;  % x[n] lower bound domain
upper_bound = 10;   % x[n] upper bound domain
x = zeros(((upper_bound - lower_bound)/step) + 1,1);        %stores x[n]
domain = zeros(((upper_bound - lower_bound)/step) + 1,1);   %stores x[n] domain
counter = 1;

for i = lower_bound:step:upper_bound
    temp = 0;
    omega = 0;
    for k = 1:2*pi/dtft_step
       z = ceil(k + m / 2);
       temp = temp + X(z(1)) * exp(-1j * i * omega);
       omega = omega + dtft_step;
    end
    temp = temp / (2*pi);
    temp = temp * dtft_step;
    x(counter) = temp;
    domain(counter) = i;
    counter = counter + 1;
end

figure(4);
plot(domain,real(x));
title('idtft real part');
xlabel('n');
ylabel('real(x[n])');

figure(5);
plot(domain,imag(x));
title('idtft imaginary part')
xlabel('n');
ylabel('imag(x[n])');

end