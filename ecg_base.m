clear variables;
close all;
clc;

load ecg_raw6.mat

Fs = 500;
T = 1/Fs;
n = 0:length(x)-1;
t = n*T;

%Análisis en Tiempo
figure ();
plot(t,x); title("Señal Adquirida");xlabel("tiempo (S)");
ylabel("Amplitud (mV)");grid on;

%Análisis en frecuencia 
[X,FREC] = fourier(x,Fs);
figure();plot(FREC,abs(X));title("Espectro Señal Adquirida");xlabel("Frecuencia (Hz)");
ylabel("Amplitud");


%Filtrado de la señal
Fc = 35;
wcn = Fc/(Fs/2);
[b,a] = butter(15,wcn,'low');

[H,FREC2] = freqz(b,a,8192,Fs);
figure();plot(FREC2,abs(H));title("Respuesta en Frecuencia");xlabel("Frecuencia (Hz)");
ylabel("Amplitud");

x_fil = filtrar(x,b,a);
figure();
plot(t,x_fil);title('Señal Filtrada');xlabel("Tiempo (S)");
ylabel("Amplitud (mV)");grid on;

%Normalizando la Señal
[p s mu] = polyfit(t,x_fil,9);
tendencia = polyval(p,t,[],mu);

figure();plot(t,x_fil);title("Señal Filtrada");xlabel("Tiempo(S)");
ylabel("Amplitud (mV)");grid on;hold on;
plot(t,tendencia);

%Elimimando la tendencia
ECG = x_fil-tendencia;

figure();plot(t,ECG);title("Señal ECG");xlabel("Tiempo (S)");
ylabel("Amplitud (mV)"); grid on; hold on;

%Obteniendo complejo QRS
%Factor R 
figure();findpeaks(ECG,t,MinPeakHeight=0.7);xlabel("Tiempo (S)");      %Solo graficado
ylabel('Amplitud (mV)');    grid on;    hold on;    title("Pico R");

[ampR,R] = findpeaks(ECG,t,MinPeakHeight=0.7);              %Saca los valores

%Factor S   Invertido de R
figure();findpeaks(-ECG,t,MinPeakHeight=0.7);xlabel("Tiempo (s)");
ylabel("Amplitud (mV)");  grid on;  hold on;    title("Pico S");

[ampS,S] = findpeaks(-ECG,t,MinPeakHeight=0.7);
apmS = -ampS;

%Factor Q 
figure();findpeaks(-ECG,t,MinPeakDistance=0.1);xlabel("Tiempo (S)");      %Solo graficado
ylabel('Amplitud (mV)');    grid on;    hold on;    title("Posibles Picos Q");

[z,min_loc] = findpeaks(-ECG,t,MinPeakDistance=0.1); %Distancias mayores a 0.1 para poder calcular los posiles Q
muestra = round(min_loc*Fs);    %Posiciones de muestra
Q = min_loc(ECG(muestra)>-0.4 & ECG(muestra)<0.2);  %Minimos locales con if
ampQ = ECG(round(Q*Fs));    %Amplitud en la posición 

% %Factor Q     Se puede trabajar con todos los picos
% figure();findpeaks(-ECG,t);xlabel("Tiempo (S)");      %Solo graficado
% ylabel('Amplitud (mV)');    grid on;    hold on;    title("Posibles Picos Q");
% [z,min_loc] = findpeaks(-ECG,t); %Distancias mayores a 0.1 para poder calcular los posiles Q
% muestra = round(min_loc*Fs);    %Posiciones de muestra
% Q = min_loc(ECG(muestra)>-0.4 & ECG(muestra)<0.2);  %Minimos locales con if
% ampQ = ECG(round(Q*Fs));    %Amplitud en la posición 
 

%Complejo QRS
figure();plot(t,ECG);title("Complejo QRS"); hold on
plot(Q,ECG(round(Q*Fs)),"s");
plot(R,ECG(round(R*Fs)),"*");
plot(S,ECG(round(S*Fs)),"V");
legend("ECG","Q","R","S");

%Acomodar señales de acuerdo a cada señal


%Frecuencias Instantaneas 
disp("Las Frecuencias Instantaneas son: ")
Tins = zeros(1,length(R)-1);
Fins = zeros(1,length(R)-1);

for i = 1:(length(R)-1)
    Tins(i) = R(i+1)-R(i);
    Fins(i) = round(Tins(i)*60);
    fprintf("\t #%2d %2d bpm \n",i,Fins(i));
end

%Frecuencia cardiaca
TCar = R(end)-R(1);
FCar = round(((length(R)-1)/TCar)*60);
disp("Frecuencia Cardiaca");
fprintf("La frecuencia cardiaca es de %d bmp\n",FCar);

if FCar < 60
    disp("El paciente tiene una bradicardia");
elseif (FCar >=60 && FCar <95)
    disp("El paciente tiene un ritmo cardiaco normal");
else
    disp("El paciente tiene taquicardia");
end


%Análisis Ritmo Cardiaco
arritmia = [];
for i = length(Tins)-1
    dT = abs(Tins(i+1)-Tins(i));
    if dT >=0.004
        arritmia = [arritmia ,dT];
    end
end

cant_arritmias = length(arritmia);
if(cant_arritmias>=1)
    disp("El paciente tiene arritmias")
else 
    disp("El paciente no tiene arritmias")
end










