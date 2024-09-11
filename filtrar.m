function y = filtrar(x,B,A)

%B coeficientes del Numerador
%A coeficientes del Denominador
TAM_B = length(B); %Cantidad de coeficientes numerador
TAM_A = length(A); %Cantidad de coeficientes denomidador

%Verificando si tiene retroalimentación

if(TAM_A>1)
    AA=-A(2:TAM_A);     %Cambio de signo a los coeficientes
    TEMP_DEM = zeros(TAM_A-1,1);
end

TEMP_NUM = zeros(TAM_B-1,1);
y = x.*0;

for n = 1:length(x)-1
    ya = 0;     %La salida solo existe si tiene retroalimentación 

    if(TAM_A>1)
        ya = AA*TEMP_DEM;   %Coeficientes del denomidador por salidas pasadas
    end

    TEMP_NUM = [x(n); TEMP_NUM(1:(TAM_B-1))];
    xa = B*TEMP_NUM;

    y(n) = xa + ya; %Sumo todo

    if(TAM_A>1)
        TEMP_DEM = [y(n); TEMP_DEM(1:(TAM_A-2))];
    end
end





