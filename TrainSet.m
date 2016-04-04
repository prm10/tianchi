clc;clear;close all;
idx_train_x=1:92;
idx_train_y=93:137;
idx_test_x=46:137;
idx_test_y=138:183;

data_song=double(importdata('data/song_times.mat'));
data_artist=double(importdata('data/artist_times.mat'));
artist_song=importdata('data/artist_song_mat.mat');
song_info=double(importdata('data/song_info_mat.mat'));

data0=data_song;
train_x=squeeze(mean(data0(:,idx_train_x,:),2));
train_y=squeeze(mean(data0(:,idx_train_y,1),2))./max(train_x(:,1),ones(size(train_x(:,1))));

test_x=squeeze(mean(data0(:,idx_test_x,:),2));
test_y=squeeze(mean(data0(:,idx_test_y,1),2))./max(test_x(:,1),ones(size(test_x(:,1))));
xbins=[0:0.1:5,max(train_y)];
hist(train_y,xbins);
