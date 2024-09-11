function y = fd1(x,h)

TAM_B = length(h);
TEMP_NUM = zeros(TAM_B-1,1);

for n = 1:(length(x))
    v_actual = x(n);
    TEMP_NUM = [v_actual;TEMP_NUM(1:(TAM_B-1))];

    y(n) = h*TEMP_NUM;
end
end