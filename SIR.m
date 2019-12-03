function SIR()
%Solving SIR pandemic model equations
% Reset everything
clc; home;
close all hidden
% Solve equations
options = odeset('RelTol',1e-10,'AbsTol',[1e-10 1e-10 1e-10]);
[t,y] = ode45(@rhs,[0 140],[1;0.000001;0], options);
[s1,s2] = size(t);
y=y(1:s1,:);
t=t(1:s1);
% Plot the results
figure('Position', [10,300,500,400]),
plot(t,y(:,1),'-b',t,y(:,2),'-r',t,y(:,3),'-g','LineWidth',2, 'LineSmoothing','on')
title('SIR model'); xlabel('time'); ylabel('Population fraction');
return;
%%%%%%%%%%%%%%%%%% Right-hand equation part
function dydt=rhs(t,y)
global A B
beta = 1/2;
gamma = 1/3;
ds = -beta*y(1)*y(2);
di = beta*y(1)*y(2)-gamma*y(2);
dr = -ds-di;
dydt = [ds; di; dr];
return;