% clear all; close all; clc

% Kuramoto-Sivashinsky equation (from Trefethen)
% u_t = -u*u_x - u_xx - u_xxxx,  periodic BCs 

N = 512;
x = 16*pi*(1:N)'/N;
u = cos(x/16).*(sin(x/16)); 
v = fft(u);

fprintf('size(x) is %s\n', mat2str(size(x)))
%fprintf('size(tt) is %s\n', mat2str(size(tt)))
fprintf('size(u) is %s\n', mat2str(size(u)))


% % % % % %
%Spatial grid and initial condition:
h = 0.025;
k = [0:N/2-1 0 -N/2+1:-1]'/16;
L = k.^2 - k.^4;
E = exp(h*L); E2 = exp(h*L/2);
M = 16;
r = exp(1i*pi*((1:M)-.5)/M);
LR = h*L(:,ones(M,1)) + r(ones(N,1),:);
Q = h*real(mean( (exp(LR/2)-1)./LR ,2)); 
f1 = h*real(mean( (-4-LR+exp(LR).*(4-3*LR+LR.^2))./LR.^3 ,2)); 
f2 = h*real(mean( (2+LR+exp(LR).*(-2+LR))./LR.^3 ,2));
f3 = h*real(mean( (-4-3*LR-LR.^2+exp(LR).*(4-LR))./LR.^3 ,2));

% Main time-stepping loop:
uu = u; tt = 0;
npoints = 4001;
tmax = 1600; 
nmax = round(tmax/h)
nplt = 16;%floor((tmax/250)/h)
g = -0.5i*k;

for n = 1:nmax
    t = n*h;
    Nv = g.*fft(real(ifft(v)).^2);
    a = E2.*v + Q.*Nv;
    Na = g.*fft(real(ifft(a)).^2);
    b = E2.*v + Q.*Na;
    Nb = g.*fft(real(ifft(b)).^2);
    c = E2.*a + Q.*(2*Nb-Nv);
    Nc = g.*fft(real(ifft(c)).^2);
    v = E.*v + Nv.*f1 + 2*(Na+Nb).*f2 + Nc.*f3; 
    if mod(n,nplt)==0
        u = real(ifft(v));
        uu = [uu,u]; tt = [tt,t]; 
    end
end
% Plot results:
surf(tt,x,uu), shading interp, colormap(hot), axis tight 
xlabel('tt')
ylabel('x')
zlabel('uu')
% view([-90 90]), colormap(autumn); 
% set(gca,'zlim',[-5 50]) 

fprintf('size(x) is %s\n', mat2str(size(x)))
fprintf('size(tt) is %s\n', mat2str(size(tt)))
fprintf('size(u) is %s\n', mat2str(size(uu)))

uu = uu + normrnd(0,0.6 ,size(uu));


save('kuramoto_sivishinky_new_noise_0.6.mat','x','tt','uu')

%%
figure(2), pcolor(x,tt,uu.'),shading interp, colormap(hot),axis off

