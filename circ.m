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
   %{ 
    if(t>0.0625 && t<0.125)
        C(iLV)=CV_now2(t,CLVS,CLVD); 
        C(iRV)=CV_now2(t,CRVS,CRVD);
    else
        C(iLV)=CV_now(t,CLVS,CLVD); 
        C(iRV)=CV_now(t,CRVS,CRVD);
    end 
%}

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
%plot results:
circ_out