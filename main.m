clc;clear;close all;
% data=importdata('data/song_times.mat');

data0=double(importdata('data/artist_times.mat'));
train_idx=1:122;
val_idx=123:183;

target=data0(:,val_idx,1);
data_train=data0(:,train_idx,:);

%% 均值作为预测
mean_play=mean(data_train(:,:,1),2);
prediction=mean_play*ones(1,size(target,2));
F1=calculateF(target,prediction);

%% 一阶多项式拟合
n=size(data_train,2);
x=1:n;
y=data_train(:,:,1);

s1=sum(x);
s2=sum(y,2);
s3=sum(ones(size(data_train,1),1)*x.*y,2);
s4=sum(x.^2);

a=(n*s3-s1*s2)/(n*s4-s1*s1);
b=(s4*s2-s3*s1)/(n*s4-s1*s1);
m=123:183;
prediction=a*m+b*ones(size(m));
F2=calculateF(target,prediction);

for i1=1:10
figure;
plot(train_idx,data_train(i1,:,1));
hold on;
plot(val_idx,target(i1,:),val_idx,prediction(i1,:));
end