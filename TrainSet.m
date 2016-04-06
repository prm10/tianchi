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
train_norm=max(train_x(:,1),ones(size(train_x(:,1))));
train_y=squeeze(mean(data0(:,idx_train_y,1),2));

test_x=squeeze(mean(data0(:,idx_test_x,:),2));
test_norm=max(test_x(:,1),ones(size(test_x(:,1))));
test_y=squeeze(mean(data0(:,idx_test_y,1),2));

% xbins=[0:0.1:5,max(train_y)];
% hist(train_y,xbins);

train_y=train_y./train_norm;
test_y=test_y./test_norm;

%% special artist:song plays rate between trainset and testset with different artist 
%{
artist_idx=11;
mean_train1=train_x(artist_song{artist_idx},1);
mean_train2=train_y(artist_song{artist_idx},1);
mean_test1=test_x(artist_song{artist_idx},1);
mean_test2=test_y(artist_song{artist_idx},1);

figure;
subplot(121);
plot([0,max(mean_train1)],[0,max(mean_train1)],mean_train1,mean_train2,'*');
title(strcat('song ',num2str(artist_idx),':trainset'));
subplot(122);
plot([0,max(mean_test1)],[0,max(mean_test1)],mean_test1,mean_test2,'*');
title(strcat('song ',num2str(artist_idx),':testset'));
xlabel('train');ylabel('test');
%}
%% x: feature; y: trend of songs
some_f=song_info(:,2);
figure;
plot(some_f,train_y,'*');
title('find rules');
xlabel('feature');
ylabel('trend of songs');

%% average plays of last k days
%{
k=[1:3:10,15:15:60];
train_f=zeros(size(train_x,1),3*length(k));
test_f=zeros(size(test_x,1),3*length(k));
for i1=1:length(k)
    train_f(:,3*(i1-1)+1:3*i1)=mean(data0(:,idx_train_x(end-k(i1)+1:end),:),2);
    test_f(:,3*(i1-1)+1:3*i1)=mean(data0(:,idx_test_x(end-k(i1)+1:end),:),2);
end
% artist feature
% f1=zeros(size(song_info,1),1);
% for i1=1:50
%     f1(artist_song{i1})=i1;
% end
f1=zeros(size(song_info,1),50);
for i1=1:50
    f1(artist_song{i1},i1)=1;
end
%3类特征：基本信息，热度，最近热度///加入artist特征   1:int, 4:int, 3:float ,8*3:float
train_f=[f1,song_info(:,1)-idx_train_x(end),song_info(:,2:end),train_x,train_f];
test_f=[f1,song_info(:,1)-idx_test_x(end),song_info(:,2:end),test_x,test_f];
% train_y=train_y./train_norm;
% test_y=test_y./test_norm;
train_w=train_x(:,1);
test_w=test_x(:,1);
save('data/regression_data.mat','train_f','train_y','train_w','test_f','test_y','test_w','-v7');
%}

