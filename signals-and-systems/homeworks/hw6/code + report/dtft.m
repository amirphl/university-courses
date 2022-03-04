function X = dtft(x)
% Discrete Time Fourier Transform
% input x[n], output X(jw)
m = size(x);
step = 0.1;                         % step size for plotting X(jw)
lower_bound = -10;                  % lower bound domain of X(jw)
upper_bound = 10;                   % upper bound domain of X(jw)
X = zeros((upper_bound - lower_bound)/step + 1,1);      % stores X(jw) range
domain = zeros((upper_bound - lower_bound)/step + 1,1);   % stores X(jw) domain
counter = 1;

for i = lower_bound:step:upper_bound
    temp = 0;
    for k = 1:m
       temp = temp + x(k) .* exp(-1j * i * k); 
    end
    X(counter) = temp;
    domain(counter) = i;
    counter = counter + 1;
end

figure(1);
plot(domain,real(X));
title('dtft real part');
xlabel('w');
ylabel('real(X(jw))');

figure(2);
plot(domain,imag(X));
title('dtft imaginary part')
xlabel('w');
ylabel('imag(X(jw))');

figure(3);
plot(domain,angle(X));
title('dtft phase part')
xlabel('w');
ylabel('angle(X(jw))');

end