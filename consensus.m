function [p, d] = consensus(N, L, t, dt)

% clc; clear;
close all;

%% parameters
param.delta_t = dt;
param.t = t;
param.N = N;
param.x = zeros(2*param.N, 1);

for i = 1:2*param.N
    
    param.x(i) = normrnd(0,5);
    
end

param.x0 = param.x;
target = [sum(param.x0(1:2:end))/N; sum(param.x0(2:2:end))/N];
param.ref = [target; target; target; target; target];
param.er = param.ref - param.x0;

% param.k = K;
% param.L = eye(param.N)*param.k*2;
param.L = L;

% for i = 1:param.N
%     for j = i-param.k:i+param.k
%         if j==i
%             continue;
%         elseif j<=0
%             temp = param.N + j;
%         elseif j>param.N
%             temp = j - param.N;
%         else
%             temp = j;
%         end
%         
%         param.L(i,temp) = -1;
%     end
% end

% param.P = eye(param.N) - param.delta_t*param.L;

%% simulation
data.t = [];
data.u = [];
data.x = [param.x];
data.er = [param.er];

for i = 0:param.delta_t:param.t
    
     % controller
    ctrl.u = -param.L*param.x;
    
    % integration
    tt = [i, i+param.delta_t];    
    [~, Temp] = ode45(@(t, X)dynamics(t, X, ctrl.u), tt, param.x, ...
        odeset('RelTol', 1e-6, 'AbsTol', 1e-6)); 
    %update
    param.x = Temp(end,:)';
    param.er = param.ref - param.x;
    
    data.u = [data.u, ctrl.u];
    data.x = [data.x, param.x];
    data.er = [data.er, param.er];
    data.t = [data.t, i];
    
end

%% plotting
% figure(1)
% n = size(data.t, 2);
% plot(data.t, data.x(:,1:n), 'LineWidth', 1); grid on;
% % axis equal;
% xlabel('time(sec)'); ylabel('states');

p = param;
d = data;

end