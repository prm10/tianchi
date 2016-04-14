# -*- coding: utf-8 -*-
__author__ = 'prm14'

import csv
import datetime
import numpy
import scipy.io as sio


# from pretreatment.data_loader import *
# date_diff('20150830', '20150301')+1


def date_idx(str1):
	date1 = datetime.datetime.strptime(str1, "%Y%m%d")
	date2 = datetime.datetime.strptime('20150301', "%Y%m%d")
	return (date1 - date2).days


def user_info_loader():
	reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
	for user_id, song_id, gmt_create, action_type, ds in reader:
		x = (user_id, song_id, gmt_create, action_type, ds)
		print(x)
		break


def show_result(result):
	for (artist, ds_num) in result.items():
		ds_num = sorted(ds_num.iteritems(), key=lambda d: d[0])
		for ds, num in ds_num:
			print artist, '\t', ds, '\t', num


def load_mat(filename):
	return sio.loadmat('data/' + filename + '.mat')


def song_heard(song_dict):
	# 统计song的次数：歌曲序号、时间序号、行为种类
	song_times = numpy.zeros([len(song_dict), date_idx('20150831'), 3], numpy.uint32)
	reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
	for user_id, song_id, gmt_create, action_type, ds in reader:
		# if action_type == '1' and '20150301' <= ds < '20150701':
		song_times[song_dict[song_id], date_idx(ds), int(action_type) - 1] += 1
	sio.savemat('data/song_times.mat', {'song_times': song_times})
	print('save song_times done.')


def artist_heard(artist_dict, sad):
	# 统计artist的次数：歌曲序号、时间序号、行为种类
	artist_times = numpy.zeros([len(artist_dict), date_idx('20150831'), 3], numpy.uint32)
	reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
	for user_id, song_id, gmt_create, action_type, ds in reader:
		for artist_id in sad[song_id]:
			artist_times[artist_dict[artist_id], date_idx(ds), int(action_type) - 1] += 1
	sio.savemat('data/artist_times.mat', {'artist_times': artist_times})
	print('save artist_times done.')


def artist_song_mat_gen(artist_song_dict, artist_list, song_dict):
	# 每个artist的序号对应的每首song的序号
	artist_temp = []
	for artist_id in artist_list:
		song_temp = []
		for song_id in artist_song_dict[artist_id]:
			# start from 1
			song_temp.append(song_dict[song_id] + 1)
		song_temp = sorted(song_temp)
		artist_temp.append(song_temp)
	artist_song_mat = numpy.array(artist_temp, dtype=object)
	sio.savemat('data/artist_song_mat.mat', {'artist_song_mat': artist_song_mat})
	print('save artist_song_mat done.')


def song_info_mat_gen(song_dict):
	# publish_time, song_init_plays, language, gender
	song_info_mat = numpy.zeros([len(song_dict), 4], dtype=long)
	reader = csv.reader(open("data/mars_tianchi_songs.csv"))
	for song_id, artist_id, publish_time, song_init_plays, language, gender in reader:
		# 0301=1
		song_info_mat[song_dict[song_id], 0] = date_idx(publish_time) + 1
		song_info_mat[song_dict[song_id], 1] = long(song_init_plays)
		song_info_mat[song_dict[song_id], 2] = int(language)
		song_info_mat[song_dict[song_id], 3] = int(gender)
	sio.savemat('data/song_info_mat.mat', {'song_info_mat': song_info_mat})
	print('save song_info_mat done.')


class SongClass:
	def __init__(self):
		self.song_artist_dict = {}
		self.artist_song_dict = {}
		self.song_info_loader()

	def song_info_loader(self):
		reader = csv.reader(open("data/mars_tianchi_songs.csv"))
		for song_id, artist_id, publish_time, song_init_plays, language, gender in reader:
			self.song_artist_dict.setdefault(song_id, set()).add(artist_id)
			self.artist_song_dict.setdefault(artist_id, set()).add(song_id)
		print len(self.artist_song_dict), ' artists recorded'
		print len(self.song_artist_dict), ' songs recorded'
		for song_id, song_set in self.song_artist_dict.iteritems():
			if len(song_set) > 1:
				print(song_id + ' have ' + str(len(song_set)) + ' artists')


class UserClass:
	def __init__(self):
		# ds, user_id, action_type
		self.d_u_t = numpy.zeros([date_idx('20150831'), 349946, 3], dtype=numpy.bool)

	def get_data(self, song0, user_dict):
		self.d_u_t[:] = False
		reader = csv.reader(open("data/mars_tianchi_user_actions.csv"))
		for user_id, song_id, gmt_create, action_type, ds in reader:
			if song_id == song0:
				self.d_u_t[date_idx(ds), user_dict[user_id], int(action_type) - 1] = True

	def feature_with_ds(self):
		# 每天的独立用户
		# stat = self.d_u_t.sum(axis=1)
		# return stat
		# 每天的新用户
		data = self.d_u_t[:, :, 0]
		now = data[0, :]
		now[:] = False
		temp1 = 0
		sta = numpy.zeros([date_idx('20150831'), 1], dtype=int)
		for i in range(date_idx('20150831')):
			temp2 = temp1
			now = now | data[i, :]
			temp1 = now.sum()
			sta[i] = temp1 - temp2
		return sta
