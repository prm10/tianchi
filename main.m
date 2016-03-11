clc;clear;close all;

% data=importdata('data/song_times.mat');
% [r,in]=sort(sum(data,2),1,'descend');
% plot(data(in(14),:))

data=importdata('data/artist_times.mat');
[r,in]=sort(sum(data,2),1,'descend');
plot(data(in(13),:))