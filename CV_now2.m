%file used in alternating the heartbeats 
function CV=CV_now2(t,CVS,CVD)
%filename: CV_now2.m   

T2 =0.02;  %alternate the heartbeats 
TS2=0.008; 
tauS2 = 0.0008;
tauD2 = 0.0024;

tc=rem(t,T2); %tc=time in the current cycle, 
             %measured from start of systole.
if(tc<TS2)
  e=(1-exp(-tc/tauS2))/(1-exp(-TS2/tauS2));
  CV=CVD*(CVS/CVD)^e;
else
  e=(1-exp(-(tc-TS2)/tauD2))/(1-exp(-(T2-TS2)/tauD2));
  CV=CVS*(CVD/CVS)^e;
end