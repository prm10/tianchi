function [theta,bias,S,L]=my_arma(y,m,n)
%y长N,利用y的第1~m，预测第m+1~m+n个；到最后，用第N-n-m+1~N-n个，预测N-n+1~N，模型长度为m+1
y=max(y,ones(size(y)));
theta=normrnd(0,0.1,[m,1]);%zeros(m+1,1);
bias=normrnd(0,0.1,1);
loops=5e3;
lr=0.5e-2;
N=length(y);
batch=N-n-m+1;
L=zeros(loops,1);

for i1=1:loops
    i2=mod(i1,batch);
    y0=y(i2+1:i2+m);
    T=y(i2+m+1:i2+m+n);
    S=my_predict(theta,bias,n,y0);
    [grad_theta,grad_bias,L(i1)]=my_gradient(S,T,y0,theta);
    theta=theta-lr*grad_theta;
    bias=bias-lr*grad_bias;
end
y0=y(batch:batch-1+m);
S=my_predict(theta,bias,n,y0);