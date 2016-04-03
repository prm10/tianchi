clc;clear;close all;
intervation=153;%122
train_idx=1:intervation;
val_idx=intervation+1:183;

data_song=double(importdata('data/song_times.mat'));
data_artist=double(importdata('data/artist_times.mat'));
artist_song=importdata('data/artist_song_mat.mat');

target=data_artist(:,val_idx,1);
data_train=data_artist(:,train_idx,:);
F0=calculateF(target,target);
%% 均值作为预测
%
mean_play=mean(data_train(:,:,1),2);
prediction=mean_play*ones(1,size(target,2));
F1=calculateF(target,prediction);
%}
%% 一阶多项式拟合
%
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
%
%检验数据
% for i1=1:10:50
%     song_idx=artist_song{i1}+1;
%     play_times=sum(data_song(song_idx,:,1));
%     figure;
%     plot(1:183,data_artist(i1,:,1),1:183,play_times);
% end
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
    song_idx=artist_song{i1}+1;
    prediction(i1,:)=sum(song_prediction(song_idx,:),1);
end
F3=calculateF(target,prediction);
%}
%% ARMAX模型

% model=my_arma(x,y);
% y=my_predict();

%% 梯度下降
model_gradient=my_arma(x,y,m);


