# -*- coding: utf-8 -*-
__author__ = 'prm14'

import data_loader

sc=data_loader.songClass()
sc.songInfoLoader()

uc=data_loader.userClass()
# uc.userInfoLoader()
uc.getValidation(sc.song_artist_dict)
uc.showResult(uc.val_result)
