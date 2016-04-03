%% 统计所有artist在训练集和验证集上的情况
clc;clear;close all;
train_idx=1:122;
val_idx=123:183;

data_artist=double(importdata('data/artist_times.mat'));
for i1=1:size(data_artist,1)
    h=figure;
    info=strcat(num2str(i1),'-artist-',num2str(sum(data_artist(i1,:,1))));
    plot(train_idx,data_artist(i1,train_idx,1),'b.',val_idx,data_artist(i1,val_idx,1),'r.');
    title(info);
    saveas(gcf,strcat('fig/',info,'.jpg'),'jpg');
    close(h);
end