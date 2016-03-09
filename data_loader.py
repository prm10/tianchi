# -*- coding: utf-8 -*-
__author__ = 'prm14'

import csv


class songClass:
    song_artist_dict = {}
    artist_song_dict = {}
    def songInfoLoader(self):
        reader = csv.reader(open("data/mars_tianchi_songs.csv"))
        for song_id, artist_id, publish_time, song_init_plays, Language, Gender in reader:
            self.song_artist_dict.setdefault(song_id,set()).add(artist_id)
            self.artist_song_dict.setdefault(artist_id,set()).add(song_id)
        print len(self.song_artist_dict), ' songs recorded'
        print len(self.artist_song_dict), ' artists recorded'

class userClass:
    val_result = {}

    def userInfoLoader(self):
        reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
        user_info = []
        for user_id, song_id, gmt_create, action_type, ds in reader:
            x = (user_id, song_id, gmt_create, action_type, ds)
            print(x)
            break

    def getValidation(self,sad):
        reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
        for user_id, song_id, gmt_create, action_type, ds in reader:
            if(action_type=='1' and ds<'20150901' and ds>='20150701'):
                artists=sad[song_id]
                for artist in artists:
                    self.val_result.setdefault(artist,{}).setdefault(ds,0)
                    self.val_result[artist][ds]=self.val_result[artist][ds]+1
        print 'records of %d artists of validation has generated.'%len(self.val_result)

    def showResult(self,result):
        for (artist,ds_num) in result.items():
            ds_num=sorted(ds_num.iteritems(),key=lambda d:d[0])
            for ds,num in ds_num:
                print artist,'\t',ds,'\t',num
