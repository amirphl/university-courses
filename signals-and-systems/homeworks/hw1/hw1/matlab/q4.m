function [my_mean,my_median,my_mode,my_var,my_min,my_max] = q4(my_X)
my_max = 'NaN';
my_min = 'NaN';
my_mean = 'NaN';
my_var = 'NaN';
my_mode = 'NaN';
my_median = 'NaN';

x_size = max([size(my_X,1),size(my_X,2)]);

if x_size ~= 0
    my_max = my_X(1);
    my_min = my_X(1);
    %my_mean = my_X(1);
    %my_var = 0;
    %my_mode = my_X(1);
    %my_median = my_X(1);
    sum = 0.0;
    for i = 1:x_size
        sum = sum + my_X(i);
        if my_min > my_X(i)
            my_min = my_X(i);
        end
        if my_max < my_X(i)
            my_max = my_X(i);
        end
    end
    my_mean = sum / x_size;
    temp = 0;
    for i = 1:x_size
        temp = temp + (my_X(i) - my_mean)*(my_X(i) - my_mean);
    end
    my_var = temp / (x_size - 1);
    my_median = median(my_X);
    my_mode = mode(my_X);
end
end