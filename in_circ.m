%This script initializes the model for whole body simulation in circ.m

T = 0.0125     %Duration of heartbeat (minutes)
TS = 0.0040    %Duration of systole (minutes)
dt = 0.01*T    %Time step duration (minutes)
%This choice implies 100 timesteps per cardiac cycle. 
klokmax = 15*T/dt %Total number of timesteps
%This choice implies simulation of 15 cardiac cycles. 

tauS = 0.0008  %CLV time constant during systole (minutes) %originally 0.0025
tauD = 0.0024  %CLV time constant during diastole (minutes) %originally 0.0075

Rs = 17.5      %Systemic resistance (mmHg/(liter/minute))
Rp = 1.79      %Pulmonary resistance (mmHg/(liter/minute))

%Unrealistic valve resistances,
%Chosen small enough to be negligible.
RMi = 0.01     %Mitral valve resistance (mmHg/(liter/minute)) 
RAo = 0.01     %aortic valve resistance (mmHg/(liter/minute)) 
RTr = 0.01     %tricuspid valve resistance (mmHg/(liter/minute)) 
RPu = 0.01     %pulmonic valve resistance (mmHg/(liter/minute)) 

%The following values of Csa and Cpa are approximate.
%They will need adjustment to make the systemic
%blood pressure be roughly 120/80 mmHg
%and to make the pulmonary
%blood pressure be roughly 25/8 mmHg.
Csa = 0.00175     %Systemic arterial compliance (liters/mmHg) 
Cpa = 0.00412  %Pulmonary arterial compliance (liters/mmHg) 
Csv = 1.75     %Systemic venous compliance (liters/mmHg) 
Cpv = 0.08     %Pulmonary venous compliance (liters/mmHg) 

CLVS = 0.0002 %Min (systolic) value of CLV (liters/mmHg) %originally 0.00003
CLVD = 0.02  %Max (diastolic) value of CLV (liters/mmHg) %originally 0.0146
CRVS = 0.0016  %Min (systolic) value of CRV (liters/mmHg) %originally 0.0002
CRVD = 0.05  %Max (diastolic) value of CRV (liters/mmHg) %originally 0.0365

Vsad = 0.825   %Systemic arterial volume at P = O (liters) 
Vpad = 0.0382  %Pulmonary arterial volume at P = O (liters)
Vsvd = 0       %Systemic venous volume at P = O (liters)
Vpvd = 0       %Pulmonary venous volume at P = O (liters)
VLVd = 0.027   %Left ventricular volume at P = O (liters)
VRVd = 0.027   %Right ventricular volume at P = O (liters) 

%Assign an index to each compliance vessel
%of the model circulation:
iLV = 1;
isa = 2;
isv = 3;
iRV = 4;
ipa = 5;
ipv = 6;
N = 6;

%Enter parameters and initial values into correct slots in arrays.
%Note that the code that follows is independent 
%of the specific numbering scheme chosen above. 
%Compliance vector:
C = zeros(N,1);
%This makes C a column vector of length N. 
C(iLV) = CV_now(0,CLVS,CLVD); %initial value
C(isa) = Csa;
C(isv) = Csv;
C(iRV) = CV_now(0,CRVS,CRVD); %initial value
C(ipa) = Cpa;
C(ipv) = Cpv;
C  %This writes the result on the screen.

%Pressure vector (initial values) at end of diastole: 
P = zeros(N,1);
%This makes P a column vector of length N. 
P(iLV) =  5;
P(isa) = 80;
P(isv) =  2;
P(iRV) =  2;
P(ipa) =  8;
P(ipv) =  5;
P %This writes the result on the screen.

%Vector of dead volumes (volume at zero pressure);
%Note: Vd is only needed for output purposes.
%It drops out of the equations we solve for P, 
%but we need it if we want to output (e.g., plot) 
%the volume of any compliance vessel.
Vd = zeros(N,1);
%This makes Vd a column vector of length N. 
Vd(iLV) = VLVd;
Vd(isa) = Vsad;
Vd(isv) = Vsvd;
Vd(iRV) = VRVd;
Vd(ipa) = Vpad;
Vd(ipv) = Vpvd;
Vd
%This writes the results on the screen. 

%Conductance matrix:
G = zeros(N,N);
%This makes G an NxN matrix filled with zeros. 
%Any element of G that is not explicitly
%made nonzero remains zero,
%thus modeling an infinite resistance connection, that is, no connection at all.
G(iLV,isa) = 1/RAo;       %But G(isa,iLV) = O (no leak) 
G(isa,isv) = 1/Rs;        %no valve
G(isv,isa) = 1/Rs;        %no valve
G(isv,iRV) = 1/RTr;       %But G(iRV,isv) = O (no leak)
G(iRV,ipa) = 1/RPu;       %But G(ipa,iRV) = O (no leak)
G(ipa,ipv) = 1/Rp;        %no valve
G(ipv,ipa) = 1/Rp;        %no valve
G(ipv,iLV) = 1/RMi;       %But G(iLV,ipv) = O (no leak)
G(iLV,iRV) = 2;           %LV/RV conductance 
G(iRV,iLV) = 2;
G %This writes the result on the screen. 

%matrix of initial valve states: 
S = zeros(N,N)
%This makes S an NxN matrix filled with zeros %(and writes it on the screen).
%Start with all valves closed.
%Valves will adjust to pressures
%during first time step.

%Initialize arrays to store data for plotting: 
t_plot = zeros(1,klokmax); 
C_plot = zeros(N,klokmax); 
P_plot = zeros(N,klokmax);
%Other variables that we might want to plot 
%can be found from these.

%For self-checking in P_new, set CHECK = 1.
%To skip self-checking set CHECK = O.
%(should be much faster with CHECK = O)

CHECK = 0;
%Initialize flow computation (for output purposes only)
%assign an index to each flow of interest:
jAo = 1;
js  = 2;
jTr = 3;
jPu = 4;
jp  = 5;
jMi = 6;
jFo = 7;
Nflows = 7;
%note index of upstream and downstream chamber
%for each flow:
iU = zeros(Nflows,1);
iD = zeros(Nflows,1);
iU(jAo) = iLV;
iD(jAo) = isa;
iU(js)  = isa;
iD(js) = isv;
iU(jTr) = isv;
iD(jTr) = iRV;
iU(jPu) = iRV;
iD(jPu) = ipa;
iU(jp) = ipa;
iD(jp) = ipv;
iU(jMi) = ipv;
iD(jMi) = iLV;
iU(jFo)  = iRV;
iD(jFo)  = iLV;
%extract the conductances from the matrix G: 
Gf = zeros(Nflows,1);
Gr = zeros(Nflows,1);
for j = 1:Nflows
    Gf(j) = G(iU(j),iD(j)); %forward conductance
    Gr(j) = G(iD(j),iU(j)); %reverse conductance 
end
%create arrays to store current pressure differences 
%and history over time of the net flows: 
Pdiff = zeros(Nflows,1);
Q_plot = zeros(Nflows,klokmax);

