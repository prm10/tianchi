clc;clear;close all;
intervation=137;%122,153,137
train_idx=1:intervation;
val_idx=intervation+1:183;

artist_song=importdata('data/artist_song_mat.mat');
song_info=double(importdata('data/song_info_mat.mat'));
hist(song_info(:,1),100);
%artist
% data_artist=double(importdata('data/artist_times.mat'));
% target=data_artist(:,val_idx,1);
% data_train=data_artist(:,train_idx,:);

%song
data_song=double(importdata('data/song_times.mat'));
target=data_song(:,val_idx,1);
data_train=data_song(:,train_idx,:);

mean_train=mean(data_train(:,:,1),2);
mean_test=mean(target,2);
figure;
plot([0,max(mean_train)],[0,max(mean_train)],mean_train,mean_test,'*');
title('trainset and testset distribution of average day plays');
xlabel('train');ylabel('test');
axis equal;
%% special artist
artist_idx=5;
mean_train1=mean_train(artist_song{artist_idx});
mean_test1=mean_test(artist_song{artist_idx});
figure;
plot([0,max(mean_train1)],[0,max(mean_train1)],mean_train1,mean_test1,'*');
title(strcat('song ',num2str(artist_idx),': distribution of average day plays'));
xlabel('train');ylabel('test');
axis equal;

