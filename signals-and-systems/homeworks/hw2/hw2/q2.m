% first load original signal
t=1:1:length(origSignal);
f1 = figure(1);
plot(t,origSignal);

% median filter . w = 5
w=2;
r1=median_smoother(origSignal,w);
f2 = figure(2);
plot(t,r1);
saveas(f2 , 'Q2_median_w=5.png');

% guassian filter . w = 5
w=2;
r1=guassian_smoother(origSignal,w);
f3 = figure(3);
plot(t,r1);
saveas(f3 , 'Q2_guassian_w=5.png');

% median filter . w = 10
w=5;
r1=median_smoother(origSignal,w);
f4 = figure(4);
plot(t,r1);
saveas(f4 , 'Q2_median_w=10.png');

% guassian filter . w = 10
w=5;
r1=guassian_smoother(origSignal,w);
f5 = figure(5);
plot(t,r1);
saveas(f5 , 'Q2_guassian_w=10.png');

% median filter . w = 100
w=50;
r1=median_smoother(origSignal,w);
f6 = figure(6);
plot(t,r1);
saveas(f6 , 'Q2_median_w=100.png');

% guassian filter . w = 100
w=50;
r1=guassian_smoother(origSignal,w);
f7 = figure(7);
plot(t,r1);
saveas(f7 , 'Q2_guassian_w=100.png');

function [filteredSignal] = median_smoother(signal,w)
    n=size(signal,2);
    filteredSignal=zeros(1,n);
    for i=1:w
        filteredSignal(i)=signal(i);
    end
    for i=w+1:n-w-1
        filteredSignal(i) = median(signal(i-w:i+w));
    end
    for i=n-w:n
        filteredSignal(i)=signal(i);
    end
end

function [filteredSignal] = guassian_smoother(signal,w)
    n=size(signal,2);
    filteredSignal=zeros(1,n);
    
    for i=1:w
        filteredSignal(i)=signal(i);
    end
    for i=w+1:n-w-1
        cofficients=guassian_filter(signal(i-w:i+w));
        filteredSignal(i)=cofficients*signal(i-w:i+w)';
    end
    for i=n-w:n
        filteredSignal(i)=signal(i);
    end
end

function [output] = guassian_filter(X)
    u=mean(X);
    dev=std(X);    
    output=(1/(dev.*sqrt(2.*pi))).*(exp((-((X-u).^2)./(2.*dev.*dev))));
end
