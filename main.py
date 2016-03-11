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

pretreatment=encode.pretreatment()
pretreatment.encode(sc.song_artist_dict,sc.artist_song_dict)