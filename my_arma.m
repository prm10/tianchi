function [theta,bias,S,L]=my_arma(y,sta,m)
%从y的第sta+1个开始，预测至结尾,模型长度为m+1; sta>=m
n=length(y)-sta;
y0=y(sta+1-m:sta);
T=y(sta+1:end);
theta=normrnd(0,0.1,[m,1]);%zeros(m+1,1);
bias=normrnd(0,0.1,[1]);
loops=2e4;
L=zeros(loops,1);
lr=1e-2;
for i1=1:loops
    S=my_predict(theta,bias,n,y0);
    [grad_theta,grad_bias,L(i1)]=my_gradient(S,T,y0,theta);
    theta=theta-lr*grad_theta;
    bias=bias-lr*grad_bias;
%     disp(strcat(num2str(i1),': ',num2str(L)));
end
