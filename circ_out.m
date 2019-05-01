%script to plot results of computer simulation
%of the entire circulation.

%left ventricular compliance, pressures, and flows: 
figure(1)
subplot(3,1,1),plot(t_plot,C_plot(iLV ,:)) 
subplot(3,1,2),plot(t_plot,P_plot([ipv,iLV,isa],:)) 
subplot(3,1,3),plot(t_plot,Q_plot([jMi,jAo],:)) 

%right ventricular compliance, pressures, and flows: 
figure(2)
subplot(3,1,1),plot(t_plot,C_plot(iRV ,:)) 
subplot(3,1,2),plot(t_plot,P_plot([isv,iRV,ipa],:)) 
subplot(3,1,3),plot(t_plot,Q_plot([jTr,jPu],:)) 

%systemic and pulmonary flows:
figure(3)
plot(t_plot,Q_plot([js,jp],:)) 

%pressure-volume loops for both ventricles 
figure(4)
subplot(2,1,1),plot(V_plot(iLV ,:),P_plot(iLV ,:)) 
subplot(2,1,2),plot(V_plot(iRV,:),P_plot(iRV,:))
