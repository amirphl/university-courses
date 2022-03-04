uiopen('signals&systems/hw1/sound.mp3' , 1);
reduce_amp = 1:-(1/175727):0;
len = length(reduce_amp);
reduce_amp = transpose(reduce_amp);

% data(length(data(:, 1))- len + 1: length(data(:,1)), 1) = data(length(data(:,1))- len + 1: length(data(:,1)), 1) .* reduce_amp;
% data(length(data(:, 1))- len + 1: length(data(:,1)), 2) = data(length(data(:,1))- len + 1: length(data(:,1)), 2) .* reduce_amp;
new1 = data(length(data(:,1))- len + 1: length(data(:,1)), 1) .* reduce_amp;
new2 = data(length(data(:,1))- len + 1: length(data(:,1)), 2) .* reduce_amp;
new = [new1, new2];

figure;hold on

subplot(2, 2, 1);
plot(data(:, 1));

subplot(2, 2, 2);
plot(data(:, 2));

subplot(2, 2, 3);
plot(new(:, 1));


subplot(2, 2, 4);
plot(new(:, 2));


sound(new, freq);
end




