# -*- coding: utf-8 -*-
__author__ = 'prm14'

from pretreatment import data_loader
from pretreatment import encode

sc = data_loader.SongClass()
uc = data_loader.UserClass()
# uc.userInfoLoader()

# uc.getValidation(sc.song_artist_dict)
# uc.showResult(uc.val_result)

# uc.songHeard(sc.song_artist_dict)
# uc.artistHeard(sc.song_artist_dict,sc.artist_song_dict)

ptr=encode.EncodeClass()
# 将artist, song, user编码
# ptr.encode(sc.song_artist_dict,sc.artist_song_dict)
# 读取编码信息
ptr.load_all()
# 分析一首歌的趋势
i1=100
print 'choose the song: %s'%ptr.song_list[i1]
