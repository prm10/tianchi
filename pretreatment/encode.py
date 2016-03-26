# -*- coding: utf-8 -*-
__author__ = 'prm14'

import csv
import cPickle


# 统计每个艺人和每首歌的播放次数，降序排列编码
# 序列化结果
class EncodeClass:
    def __init__(self):
        self.artist_dict = {}
        self.artist_list = []
        self.song_dict = {}
        self.song_list = []
        self.user_dict = {}
        self.user_list = []

    def encode(self, sad, asd):
        artist_times = dict.fromkeys(asd.keys(), 0)
        song_times = dict.fromkeys(sad.keys(), 0)
        user_times = {}

        i0 = 0
        reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
        for user_id, song_id, gmt_create, action_type, ds in reader:
            if action_type == '1':
                for artist_id in sad[song_id]:
                    artist_times[artist_id] += 1
                song_times[song_id] += 1
                user_times.setdefault(user_id, 0)
                user_times[user_id] += 1
                i0 += 1
                # if i0>1000:
                #     break
        print '%d users recorded' % len(user_times)
        print '%d records read.' % i0
        # 按频数降序排列
        self.artist_list = [k for k, v in sorted(artist_times.iteritems(), key=lambda d: d[1], reverse=True)]
        self.song_list = [k for k, v in sorted(song_times.iteritems(), key=lambda d: d[1], reverse=True)]
        self.user_list = [k for k, v in sorted(user_times.iteritems(), key=lambda d: d[1], reverse=True)]

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
        self.user_dict = dict.fromkeys(user_times.keys(), 0)
        i = 0
        for user_id in self.user_list:
            self.user_dict[user_id] = i
            i += 1
        self.save_pickle('artist_list')
        self.save_pickle('artist_dict')
        self.save_pickle('song_list')
        self.save_pickle('song_dict')
        self.save_pickle('user_list')
        self.save_pickle('user_dict')
        # for check
        # for artist_id,times in self.artist_list:
        #     print artist_id,'\t',times

    def load_all(self):
        self.load_pickle('artist_list')
        self.load_pickle('artist_dict')
        self.load_pickle('song_list')
        self.load_pickle('song_dict')
        self.load_pickle('user_list')
        self.load_pickle('user_dict')

    def save_pickle(self, filename):
        f = file('data/' + filename + '.pickle', 'w')
        cPickle.dump(getattr(self, filename), f)
        f.close()

    def load_pickle(self, filename):
        f = file('data/' + filename + '.pickle')
        setattr(self, filename, cPickle.load(f))
        f.close()
        print 'load %d records of ' % len(getattr(self, filename)), filename, ' done.'
        return getattr(self, filename)
