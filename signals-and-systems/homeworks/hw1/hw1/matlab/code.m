hvsd = @(x) 0.5*(x == 0) + (x > 0);
part = 1;

%part 1

if part == 1
    t = -1 : 0.001 : 10;
    x = 2 .* exp(-3 * t) .* hvsd(t);
    h1 = figure(1);
    plot(t,x);
    saveas(h1 , 'Q1_1.png');
    x = exp(-2 * t) .* sin( 3 * t - 1 ) .* hvsd(t);
    h2 = figure(2);
    plot(t,x);
    saveas(h1 , 'Q1_2.png');
    x = exp(-1 * t) .* hvsd(t) + 4  .* cos( 2 * t - 2 );
    h3 = figure(3);
    plot(t,x);
    saveas(h3 , 'Q1_3.png');
    x = exp(-3 * t) - exp(-6 * t);
    h4 = figure(4);
    plot(t,x);
    saveas(h4 , 'Q1_4.png');
end

%part 2

if part == 2
    n = -10 : 1 : 50;
    x = power(0.5 , n) .* ( sin(pi * n / 4 ) + cos(pi * n / 4 ) );
    h1 = figure(1);
    stem(n,x);
    saveas(h1 , 'Q2_1.png');
    x = 3 * hvsd( n - 2 ) + ( 1 - exp(0.2 * n) ) .* hvsd( -1 * n + 1 );
    h2 = figure(2);
    stem(n,x);
    saveas(h2 , 'Q2_2.png');
end

%part 3

if part == 3
    min_m = 1;
    for m = 1:-0.001:-1000
        energy = 0.0; 
        for i = 0:1:100
            enery = energy + (5 * cos(pi*i/12) * exp(-1 * m * i))*(5 * cos(pi*i/12) * exp(-1 * m * i));     
        end
        %disp(energy);
        if enery > 300
            break
        end
        min_m = m;
    end
    disp('m :');
    disp(min_m);
    t = -150 : 0.001 : 150;
    h1 = figure(1);
    plot(t,(5 * cos(pi*t/12) .* exp(-1 * min_m) .* cos(-1 * min_m * t / 2)));
    saveas(h1 , 'Q3_1.png');
    h2 = figure(2);
    plot(t,(5 * cos(pi*t/12) .* exp(-1 * min_m) .* sin(-1 * min_m * t / 2)));
    saveas(h2 , 'Q3_2.png');
end

%part 4

if part == 4
    U = [ 1 2 3 4 5 1 2 3 5 6 9 2.6 9 -10 5 -90 5 9 3 5 4 8 2 5 66 99 88 2 5 4 8 55 66 663 22 14 5 -5 -550 -60 -98 ];
    [my_mean,my_median,my_mode,my_var,my_min,my_max] = q4(U);
    disp("results of my statistic functions:");
    disp(my_mean);
    disp(my_median);
    disp(my_mode);
    disp(my_var);
    disp(my_min);
    disp(my_max);
    disp("results of matlab statistic functions:")
    disp(mean(U));
    disp(median(U));
    disp(mode(U));
    disp(var(U));
    disp(min(U));
    disp(max(U));
end

%part 5

if part == 5
	uiopen('sound.mp3')
	my_var = 0.0000005;
	f1=1000;
	f2=20000;
	f3=40000;
	f4=100000;
	sound(data,f1);
	sound(data,f2);
	sound(data,f3);
	sound(data,f4);

	h1 = figure(1);
	subplot(2,1,1);
	plot(data(:,1));
	saveas(h1 , 'Q5_2_1.png');
	h2 = figure(2);
	subplot(2,1,2)
	plot(data(:,1))
	saveas(h2 , 'Q5_2_2.png');

	my_range=0:my_var:1-my_var;
	fs=44100;
	section_1=(data(2000001:4000000,1)).*(1-my_range)';
	section_2=(data(2000001:4000000,2)).*(1-my_range)';
	Data=[section_1,section_2];
end