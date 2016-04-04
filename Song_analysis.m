clc;clear;close all;
intervation=137;%122,153,137
train_idx=1:intervation;
val_idx=intervation+1:183;

artist_song=importdata('data/artist_song_mat.mat');
song_info=double(importdata('data/song_info_mat.mat'));

%统计时间分布
hist(song_info(:,1),100);