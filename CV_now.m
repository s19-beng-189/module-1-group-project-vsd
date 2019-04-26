function CV=CV_now(t,CVS,CVD)
%filename: CV_now.m
global T TS tauS tauD;
tc=rem(t,T); %tc=time in the current cycle, 
             %measured from start of systole.
if(tc<TS)
  e=(1-exp(-tc/tauS))/(1-exp(-TS/tauS));
  CV=CVD*(CVS/CVD)^e;
else
  e=(1-exp(-(tc-TS)/tauD))/(1-exp(-(T-TS)/tauD));
  CV=CVS*(CVD/CVS)^e;
end
