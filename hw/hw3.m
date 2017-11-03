prewitt_h = fliplr([-1, 0, 1; -1, 0, 1; -1, 0, 1]);
prewitt_v = flipud([-1, -1, -1; 0, 0, 0; 1, 1, 1]);

sobel_h = fliplr([-1, 0, 1; -2, 0, 2; -1, 0, 1]);
sobel_v = flipud([-1, -2, -1; 0, 0, 0; 1, 2, 1]);

x = 0:7;
y = 0:7;

f = zeros(8, 8);

for i = 1:length(x)
    for j = 1:length(y)
        f(i,j) = abs(x(i) - y(j));
    end
end

f_p_h = conv2(f, prewitt_h, 'valid');
f_p_v = conv2(f, prewitt_v, 'valid');

f_s_h = conv2(f, sobel_h, 'valid');
f_s_v = conv2(f, sobel_v, 'valid');

mag_p = sqrt(f_p_h.^2 + f_p_v.^2);
ang_p = atan(f_p_h ./ f_p_v);

mag_s = sqrt(f_s_h.^2 + f_s_v.^2);
ang_s = atan(f_s_h ./ f_s_v);
