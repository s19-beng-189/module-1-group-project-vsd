%This script is the main script of the model for whole body circulation
%utilized for BENG 189 Module 1 Project

%Model adapted from Frank C. Hoppensteadt and Charles S. Peskin, Modeling 
%and Simulation in Medicine and the Life Sciences?Second Edition

clear all % clear all variables 
clf %and figures
global T TS tauS tauD;
global G dt CHECK N;
in_circ %initialize
for klok=1:klokmax
    t=klok*dt;
    P_old=P;
    C_old=C;
%find current values of left and right
%ventricular compliance and store each
%of them in the appropriate slot in the array C:

%introducing arrhythmia by if structure:

%    { 
%     if(t>0.0625 && t<0.125)
%         C(iLV)=CV_now2(t,CLVS,CLVD); 
%         C(iRV)=CV_now2(t,CRVS,CRVD);
%     else
%         C(iLV)=CV_now(t,CLVS,CLVD); 
%         C(iRV)=CV_now(t,CRVS,CRVD);
%     end 
% }

   C(iLV)=CV_now(t,CLVS,CLVD); 
   C(iRV)=CV_now(t,CRVS,CRVD);
%find self-consistent valve states and pressures: 
    set_valves
%store variables in arrays for future plotting: 
    t_plot(klok)=t;
    C_plot(:,klok)=C;
    P_plot(:,klok)=P;
    V_plot(:,klok)=Vd+C.*P;
    Pdiff=P(iU)-P(iD); %pressure differences
%for flows of interest: 
    Q_plot(:,klok)=(Gf.*(Pdiff>0)+Gr.*(Pdiff<0)).*Pdiff;
%(the net flow is computed in each case) 
end

%the rest of the script calculates average heart rate for each 
%300 time steps
pp = P_plot(isa,:)-P_plot(isv,:);
PP = zeros(1,5);
qq = Q_plot(js,:);
QQ = zeros(1,5);
F = zeros(1,5);

%section the time steps
range1 = 1:300;
range2 = 301:600;
range3 = 601:900;
range4 = 901:1200;
range5 = 1201:1500;

PP(1) = mean(pp(range1));
PP(2) = mean(pp(range2));
PP(3) = mean(pp(range3));
PP(4) = mean(pp(range4));
PP(5) = mean(pp(range5));

QQ(1) = mean(qq(range1));
QQ(2) = mean(qq(range2));
QQ(3) = mean(qq(range3));
QQ(4) = mean(qq(range4));
QQ(5) = mean(qq(range5));

%calculate heart rate and load to plotting vector
for i =1:5
    F(i) = PP(i)*Csv/((PP(i)/QQ(i))*0.5*CRVD*(5.2-Csa*PP(i)));
end

%plot results for the entire script:
circ_out