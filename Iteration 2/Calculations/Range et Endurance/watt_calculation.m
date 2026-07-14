watt_input = [18, 40, 77, 130, 191, 265, 360]; % watts
thrust = [240, 467, 724, 1040, 1357, 1685, 2048]; % grams

xq = 0:1:2048;

vq = interp1(thrust, watt_input, xq, 'linear', 'extrap');

plot(thrust, watt_input, 'o', xq, vq, ':.');