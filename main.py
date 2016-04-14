# -*- coding: utf-8 -*-
__author__ = 'prm14'

import matplotlib.pyplot as plt
import numpy
from pretreatment import data_loader
from pretreatment import encode
from model import x_model

sc = data_loader.SongClass()
uc = data_loader.UserClass()

ptr = encode.EncodeClass()

# 将artist, song, user编码
# ptr.encode(sc.song_artist_dict, sc.artist_song_dict)
# 读取编码信息
ptr.load_all()

# 生成mat数据
# data_loader.song_heard(ptr.song_dict)
# data_loader.artist_heard(ptr.artist_dict, sc.song_artist_dict)
# data_loader.artist_song_mat_gen(sc.artist_song_dict, ptr.artist_list, ptr.song_dict)
# data_loader.song_info_mat_gen(ptr.song_dict)
# 加载mat数据
song_times = data_loader.load_mat('song_times')['song_times']
song_info = data_loader.load_mat('song_info_mat')['song_info_mat']

# 分析一首歌的趋势
# x = range(data_loader.date_diff('20150831', '20150301'))
# for i1 in range(0, len(ptr.song_list)):
# mean_song=song_times[:,:,:].mean(axis=1)
'''
for i1 in range(0, 100, 20):
	# print 'choose the song: %s' % ptr.song_list[i1]
	print(str(i1) + ':' + ptr.song_list[i1])
	song = song_times[i1, :, 0:2]
	plt.figure()
	plt.plot(song / song.mean(axis=0), '-*')
	plt.title(
		str(song_info[i1, 0]) + ',' + str(song_info[i1, 1]) + ',' + str(song_info[i1, 2]) + ',' + str(song_info[i1, 3]))
	plt.xlabel('days')
	plt.legend(['play', 'download', 'collect'])
plt.show()
'''
for i1 in range(0, 10, 3):
	print(str(i1) + ':' + ptr.song_list[i1])
	uc.get_data(ptr.song_list[i1], ptr.user_dict)
	fea = uc.feature_with_ds()
	song = song_times[i1, :, 0]
	plt.figure()
	plt.subplot(211)
	plt.plot(song, '-*')
	plt.title(
		str(song_info[i1, 0]) + ',' + str(song_info[i1, 1]) + ',' + str(song_info[i1, 2]) + ',' + str(
			song_info[i1, 3]))
	plt.xlabel('days')
	plt.subplot(212)
	plt.plot(fea, '-*')
	plt.xlabel('days')
	# plt.legend(['f1', 'f2', 'f3'])
plt.show()
# 分析一个artist的歌曲热度
'''
n = data_loader.date_diff('20150831', '20150301')
for i1 in range(10):
	songs = sc.artist_song_dict[ptr.artist_list[i1]]
	y = numpy.zeros([n, len(songs)], numpy.uint16)
	print(str(i1) + ':' + ptr.artist_list[i1])
	song_index = []
	for song_id in songs:
		song_index.append(ptr.song_dict[song_id])
	song_index = sorted(song_index)
	i = 0
	for i2 in song_index:
		y[:, i] = song_times[i2, :, 1]
		i += 1
	plt.figure()
	plt.plot(numpy.append(y[:, range(10)], y.sum(axis=1).reshape((y.shape[0], 1)), axis=1), '-*')
	lg = map(str, range(10))
	lg.append('sum')
	plt.legend(lg)
	plt.title(str(i1) + ':' + str(y.sum()))
plt.show()
'''

'''
# train model
mc = x_model.ModelClass()
# mc.cv()
mc.train()
mc.test()
'''
