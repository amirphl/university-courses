x = 1:13;
disp(x);
x = x .* (pi / 6);
x = cos(x);
disp(x);
AK = dtfs(x);
idtfs(AK);