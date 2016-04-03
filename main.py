# -*- coding: utf-8 -*-
__author__ = 'prm14'

import matplotlib.pyplot as plt
import numpy
from pretreatment import data_loader
from pretreatment import encode

sc = data_loader.SongClass()
# uc = data_loader.UserClass()

# uc.getValidation(sc.song_artist_dict)
# uc.showResult(uc.val_result)
# uc.songHeard(sc.song_artist_dict)
# uc.artistHeard(sc.song_artist_dict,sc.artist_song_dict)

ptr = encode.EncodeClass()

# 将artist, song, user编码
ptr.encode(sc.song_artist_dict, sc.artist_song_dict)
# 读取编码信息
ptr.load_all()

# 生成mat数据
# data_loader.song_heard(ptr.song_dict)
# data_loader.artist_heard(ptr.artist_dict, sc.song_artist_dict)
# data_loader.artist_song_mat_gen(sc.artist_song_dict, ptr.artist_list, ptr.song_dict)
# 加载用户行为矩阵
# song_times = data_loader.load_mat('song_times')['song_times']

# 分析一首歌的趋势
# x = range(data_loader.date_diff('20150831', '20150301'))
# for i1 in range(0, len(ptr.song_list)):
'''
for i1 in range(0, 10):
    # print 'choose the song: %s' % ptr.song_list[i1]
    print(str(i1) + ':' + ptr.song_list[i1])
    song = song_times[i1, :, :]
    plt.figure()
    plt.plot(song, '-*')
    plt.title(
        'publish time: ' + str(data_loader.date_diff(data_loader.get_song_publish_time(ptr.song_list[i1]), '20150301')))
    plt.xlabel('days')
plt.show()
'''
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
