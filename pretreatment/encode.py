# -*- coding: utf-8 -*-
__author__ = 'prm14'

import csv
import cPickle


# 统计每个艺人和每首歌的播放次数，降序排列编码
# 序列化结果
class EncodeClass:
    def __init__(self):
        print 'EncodeClass generating...'
        self.artist_dict = {}
        self.artist_list = []
        self.song_dict = {}
        self.song_list = []

    def encode(self, sad, asd):
        artist_times = dict.fromkeys(asd.keys(), 0)
        song_times = dict.fromkeys(sad.keys(), 0)
        reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
        for user_id, song_id, gmt_create, action_type, ds in reader:
            for artist_id in sad[song_id]:
                artist_times[artist_id] += 1
            song_times[song_id] += 1
        # 按频数降序排列
        self.artist_list = sorted(artist_times.iteritems(), key=lambda d: d[1], reverse=True)
        self.song_list = sorted(song_times.iteritems(), key=lambda d: d[1], reverse=True)
        self.artist_dict = dict.fromkeys(asd.keys(), 0)
        i = 0
        for artist_id in self.artist_list:
            self.artist_dict[artist_id] = i
            i += 1
        self.song_dict = dict.fromkeys(sad.keys(), 0)
        i = 0
        for song_id in self.song_list:
            self.song_dict[song_id] = i
            i += 1
        self.save_pickle('artist_list')
        self.save_pickle('artist_dict')
        self.save_pickle('song_list')
        self.save_pickle('song_dict')
        # for check
        # for artist_id,times in self.artist_list:
        #     print artist_id,'\t',times

    def save_pickle(self, filename):
        f = file('data/' + filename + '.pickle', 'w')
        cPickle.dump(getattr(self, filename), f)
        f.close()

    def load_pickle(self, filename):
        f = file('data/' + filename + '.pickle')
        setattr(self, filename, cPickle.load(f))
        f.close()
        print 'load ', filename, ' done.'
        return getattr(self, filename)
