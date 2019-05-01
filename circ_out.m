%script to plot results of computer simulation
%of the entire circulation.

%left ventricular compliance, pressures, and flows: 
figure(1)
subplot(3,1,1),plot(t_plot,C_plot(iLV ,:)) ,title("LV Compliance")
subplot(3,1,2),plot(t_plot,P_plot([ipv,iLV,isa],:)),title("LV Pressure"),
legend('pv','LV','sa')
subplot(3,1,3),plot(t_plot,Q_plot([jMi,jAo],:)),title("LV Flows"),legend('Mi','Ao')

%right ventricular compliance, pressures, and flows: 
figure(2)
title("RV Compliance, Pressure and Flows")
subplot(3,1,1),plot(t_plot,C_plot(iRV ,:)) ,title("RV Compliance")
subplot(3,1,2),plot(t_plot,P_plot([isv,iRV,ipa],:)) ,title("RV Pressure"),
legend('sv','RV','pa')
subplot(3,1,3),plot(t_plot,Q_plot([jTr,jPu],:)) ,title("RV Flows"),legend('Tr','Pu')

%systemic and pulmonary flows:
figure(3)
plot(t_plot,Q_plot([js,jp],:)) ,title("Systemic and Pulmonary Flows")
legend('Systemic','Pulmonary')

%pressure-volume loops for both ventricles 
figure(4)
subplot(2,1,1),plot(V_plot(iLV ,:),P_plot(iLV ,:)) ,title("PV Loops for Left Ventricle"),xlim([0,0.15])
subplot(2,1,2),plot(V_plot(iRV,:),P_plot(iRV,:)),title("PV Loops for Right Ventricle"),xlim([0,0.15])
