function [p, d] = position_based_formation(N, L, t, dt)

close all;

%% parameters
param.delta_t = dt;
param.t = t;
param.N = N;
param.kp = 1;
param.x = zeros(2*param.N, 1);

for i = 1:2*param.N
    
    param.x(i) = normrnd(0,1);
    
end

param.x0 = param.x;

param.ref = zeros(2*param.N, 1);
param.er = param.ref - param.x;
param.radius = 20;

for i = 1:param.N
    
    param.ref(2*i-1) = param.radius*cos(2*pi/param.N*i);
    param.ref(2*i) = param.radius*sin(2*pi/param.N*i);
    
%     param.ref(2*i-1) = normrnd(0,8);
%     param.ref(2*i) = normrnd(0,8);
    
end

param.circle = [];
for i = 0:0.01:2*pi
    
    x_pos = param.radius*cos(i);
    y_pos = param.radius*sin(i);
    param.circle = [param.circle; [x_pos, y_pos]];
    
end

% param.k = K;
% param.L = eye(2*param.N)*param.k*2;
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
%         param.L(2*i-1,2*temp-1) = -1;
%         param.L(2*i, 2*temp) = -1;
%     end
% end

% param.P = eye(2*param.N) - param.delta_t*param.L;

%% simulation and plotting
data.t = [];
data.u = [];
data.x = [param.x];
data.er = [param.er];

% figure(1)
% plot(param.ref(1:2:end), param.ref(2:2:end), 'ro'); hold on;
% plot(param.x(1:2:end), param.x(2:2:end), 'k*'); hold on;

for i = 0:param.delta_t:param.t
    
    % controller
    ctrl.u = (param.kp+param.L)*param.er;
    
    % integration
    tt = [i, i+param.delta_t];    
    [~, Temp] = ode45(@(t, X)dynamics(t, X, ctrl.u), tt, param.x, ...
        odeset('RelTol', 1e-6, 'AbsTol', 1e-6)); 
    %update
    param.x = Temp(end,:)';
    param.er = param.ref - param.x;
    
    %saving data
    data.u = [data.u, ctrl.u];
    data.x = [data.x, param.x];
    data.er = [data.er, param.er];
    data.t = [data.t, i];
    
%     for j = 1:param.N
%     
%         param.ref(2*j-1) = param.radius*cos(2*pi/param.N*j+0.01*pi*i);
%         param.ref(2*j) = param.radius*sin(2*pi/param.N*j + 0.01*pi*i);
%         
%     end
    
end

% for i = 1:param.N
%     
%     plot(data.x(2*i-1,:), data.x(2*i,:), 'LineWidth', 1); hold on;
%         
% end
% plot(param.x(1:2:end), param.x(2:2:end), 'ko'); hold on;
% plot(param.circle(:,1), param.circle(:,2), 'LineWidth', 1, 'Color', 'm');
% grid on;
% b = param.radius+1;
% axis([-b, b, -b, b]);
% axis equal;
% xlabel('x position'); ylabel('y position');
% 
% figure(2)
% plot(param.x0(1:2:end), param.x0(2:2:end), 'r*'); hold on;
% plot(param.x(1:2:end), param.x(2:2:end), 'ko'); hold on;
% 
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
%         plot([param.x0(2*i-1); param.x0(2*temp-1)],...
%             [param.x0(2*i); param.x0(2*temp)],...
%             'LineWidth', 1, 'Color', 'b');
%         hold on;
%         plot([param.x(2*i-1); param.x(2*temp-1)],...
%             [param.x(2*i); param.x(2*temp)],...
%             'LineWidth', 1, 'Color', 'm');
%         hold on;
%     end
%     plot(data.x(2*i-1,:), data.x(2*i,:), 'LineWidth', 1); hold on;
% end
% grid on;
% axis([-b, b, -b, b]);
% axis equal;
% xlabel('x position'); ylabel('y position');
% 
% figure(3)
% n = size(data.t, 2);
% plot(data.t, data.u(:,1:n), 'LineWidth', 1); grid on;
% xlabel('time(sec)'); ylabel('control');
% 
% figure(4)
% n = size(data.t, 2);
% plot(data.t, data.er(:,1:n), 'LineWidth', 1); grid on;
% axis equal;
% xlabel('time(sec)'); ylabel('error');

p = param;
d = data;

end
