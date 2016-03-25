# -*- coding: utf-8 -*-
__author__ = 'prm14'

import matplotlib.pyplot as plt
from pretreatment import data_loader
from pretreatment import encode

# sc = data_loader.SongClass()
# uc = data_loader.UserClass()

# uc.getValidation(sc.song_artist_dict)
# uc.showResult(uc.val_result)

# uc.songHeard(sc.song_artist_dict)
# uc.artistHeard(sc.song_artist_dict,sc.artist_song_dict)

ptr = encode.EncodeClass()

# 将artist, song, user编码
# ptr.encode(sc.song_artist_dict,sc.artist_song_dict)
# 读取编码信息
ptr.load_all()

# 扫描用户行为记录表
# data_loader.song_heard(ptr.song_dict)
# 加载用户行为矩阵
song_times = data_loader.load_mat('song_times')['song_times']

# 分析一首歌的趋势
i1 = 100
print 'choose the song: %s' % ptr.song_list[i1]
song = song_times[i1, :, :]
plt.figure()
x = range(data_loader.date_diff('20150831', '20150301'))
plt.plot(song,'-*')
plt.title('publish time: '+str(data_loader.date_diff(data_loader.get_song_publish_time(ptr.song_list[i1]), '20150301')))
plt.xlabel('days')
plt.show()