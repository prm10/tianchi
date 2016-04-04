clc;clear;close all;
intervation=122;%122,153
train_idx=1:intervation;
val_idx=intervation+1:183;

data_song=double(importdata('data/song_times.mat'));
data_artist=double(importdata('data/artist_times.mat'));
artist_song=importdata('data/artist_song_mat.mat');

target=data_artist(:,val_idx,1);
data_train=data_artist(:,train_idx,:);
F0=calculateF(target,target);
%% 均值作为预测
%{
mean_play=mean(data_train(:,:,1),2);
prediction=mean_play*ones(1,size(target,2));
F1=calculateF(target,prediction);
%}
%% 一阶多项式拟合
%{
n=size(data_train,2);
x=1:n;
y=data_train(:,:,1);

s1=sum(x);
s2=sum(y,2);
s3=sum(ones(size(data_train,1),1)*x.*y,2);
s4=sum(x.^2);

a=(n*s3-s1*s2)/(n*s4-s1*s1);
b=(s4*s2-s3*s1)/(n*s4-s1*s1);
m=val_idx;
prediction=a*m+b*ones(size(m));
F2=calculateF(target,prediction);

% for i1=1:10
% figure;
% plot(train_idx,data_train(i1,:,1));
% hold on;
% plot(val_idx,target(i1,:),val_idx,prediction(i1,:));
% end
%}
%% 基于song的预测
%{
% 检验数据
%{
for i1=1:10:50
    song_idx=artist_song{i1};
    play_times=sum(data_song(song_idx,:,1));
    figure;
    plot(1:183,data_artist(i1,:,1),1:183,play_times);
end
%}
song_train=data_song(:,train_idx,:);
song_target=data_song(:,val_idx,1);

n=size(song_train,2);
x=train_idx;
y=song_train(:,:,1);

s1=sum(x);
s2=sum(y,2);
s3=sum(ones(size(song_train,1),1)*x.*y,2);
s4=sum(x.^2);

a=(n*s3-s1*s2)/(n*s4-s1*s1);
b=(s4*s2-s3*s1)/(n*s4-s1*s1);
m=val_idx;
song_prediction=a*m+b*ones(size(m));
prediction=zeros(50,length(val_idx));
for i1=1:50
    song_idx=artist_song{i1};
    prediction(i1,:)=sum(song_prediction(song_idx,:),1);
end
F3=calculateF(target,prediction);
%}
%% ARMAX模型

% model=my_arma(x,y);
% y=my_predict();

%% 梯度下降
prediction=zeros(50,61);
for artist_idx=1:50
    disp(artist_idx);
    y=data_train(artist_idx,:,1)';
    m=15;
    n1=10;
    [theta,bias,S,L]=my_arma(y,m,n1);
%     figure;
%     subplot(211);
%     plot(L);
%     title('L');
%     subplot(212);
%     plot(theta);
%     title('\theta')

    %预测
    y0=y(end+1-m:end);
    n2=size(target,2);
    P=my_predict(theta,bias,n2,y0);
    prediction(artist_idx,:)=P;
end
F4=calculateF(target,prediction);
%     figure;
%     plot(1:183,data_artist(artist_idx,:,1),intervation-n1+1:intervation,S,intervation+1:183,P);
%% gradient check
%{
n=length(y)-sta;
y0=y(sta+1-m:sta);
T=y(sta+1:end);
e=1e-9;
i1=1;
S=my_predict(theta,bias,n,y0);
[grad_theta,grad_bias,~]=my_gradient(S,T,y0,theta);
theta(i1)=theta(i1)+e;
S=my_predict(theta,bias,n,y0);
[~,~,L1]=my_gradient(S,T,y0,theta);
theta(i1)=theta(i1)-2*e;
S=my_predict(theta,bias,n,y0);
[~,~,L2]=my_gradient(S,T,y0,theta);
cal_g=(L1-L2)/2/e;
acc_g=grad_theta(i1);
%}

