%Función de tendencia

function [R, ampR, S, ampS, Q, ampQ, P, ampP] = PQRS(ECG,t,Fs)

% Factor R
[ampR,R] = findpeaks(ECG,t,MinPeakHeight=0.7);

% Factor S
[ampS,S] = findpeaks(-ECG,t,MinPeakHeight=0.65);
ampS = -ampS;

% Factor Q  
[z,min_loc] = findpeaks(-ECG,t,MinPeakDistance=0.1);
muestra = round(min_loc*Fs);
Q = min_loc(ECG(muestra)>-0.4 & ECG(muestra)<-0.2);

if length(Q)==1       %Audio 5 
   [tt,min_loct] = findpeaks(-ECG,t,MinPeakDistance=0.09);
   muestrat = round(min_loct*Fs);
   Q = min_loct(ECG(muestrat)>-0.4 & ECG(muestrat)<-0.2);

elseif length(Q)==2 %Audio 4 IR
   [kk,min_lock] = findpeaks(-ECG,t,MinPeakDistance=0.07);
   muestrak = round(min_lock*Fs);
   Q = min_lock(ECG(muestrak)>-0.4 & ECG(muestrak)<-0.2);

elseif length(Q)==3 %Audio 4
   [qq,min_locQ] = findpeaks(-ECG,t,MinPeakDistance=0.08);
   muestraQ = round(min_locQ*Fs);
   Q = min_locQ(ECG(muestraQ)>-0.4 & ECG(muestraQ)<-0.2);
end



ampQ = ECG(round(Q*Fs));

% Factor P
for i = 1:1:length(R)
    if (i == 1)
        PrimerCorte = round(R(i)*Fs-3);
        [z,min_loc] = findpeaks(ECG(1:PrimerCorte),t(1:PrimerCorte),MinPeakDistance=0.1);
        muestra = round(min_loc*Fs);
        P(i) = min_loc(ECG(muestra)>0.14);
        ampP(i) = ECG(round(P*Fs));
     
    else
       PrimerCorte = round((R(i-1)+R(i))/2*Fs);
       SegundoCorte = round(R(i)*Fs-3);
       [z,min_loc] = findpeaks(ECG(PrimerCorte:SegundoCorte),t(PrimerCorte:SegundoCorte),MinPeakDistance=0.1);
       muestra = round(min_loc*Fs);
       P(i) = min_loc(ECG(muestra)>0.14);
       ampP(i) = ECG(round(P(i)*Fs)); 
    end
end

end