% part 1
h1 = [4 3 2 1];
x1 = [-3 7 4];
r1 = conv(h1,x1);
disp(r1);

% plotting q1 part 1 result
t = 0:1:max([length(h1)+length(x1)-1,length(h1),length(x1)]) - 1;
f1 = figure(1);
plot(t,r1);
saveas(f1 , 'Q1_1.png');

% part 2
x = @(t) hsvd(t+2) -3.*hsvd(t-10);
h = @(t) (0.8.^t).*(hsvd(t-2)-2.*hsvd(t-3));
t = 0:1:5;
a = x(t);
b = h(t);
r2 = conv(a,b);

% plotting q1 part 2 result
t = 0:1:max([length(a)+length(b)-1,length(a),length(b)]) - 1;
f2 = figure(2);
plot(t,r2);
saveas(f2 , 'Q1_2.png');

function [output] = hsvd(t)
    output = t >= 0;
end