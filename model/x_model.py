# -*- coding: utf-8 -*-
__author__ = 'prm14'

import scipy.io as sio
import numpy
import xgboost as xgb


def get_data_from_mat():
	data = sio.loadmat('data/regression_data.mat')
	train_f = data['train_f']
	train_y = data['train_y']
	train_w = data['train_w']
	test_f = data['test_f']
	test_y = data['test_y']
	test_w = data['test_w']
	return xgb.DMatrix(train_f, label=train_y, weight=train_w, feature_names=data_name,
	                   feature_types=data_type), xgb.DMatrix(test_f, label=test_y, weight=test_w,
	                                                         feature_names=data_name, feature_types=data_type)


# data_name = ['col' + str(i+1) for i in range(32)]
# # 1:int, 4:int, 3:float ,8*3:float
# data_type = ['int' for i in range(5)] + ['float' for i in range(27)]

data_name = ['col' + str(i + 1) for i in range(81)]
# 50:int, 4:int, 3:float ,8*3:float
data_type = ['i' for i in range(50)] + ['int' for i in range(4)] + ['float' for i in range(27)


class ModelClass:
	def __init__(self):
		self.param = {
			'max_depth': 6,
			'eta': 0.3,
			# 'subsample': 1,
			'min_child_weight': 100,
			# 'colsample_bytree': 0.9,
			'silent': 1,
			'objective': 'reg:linear'}
		self.d_train, self.d_test = get_data_from_mat()
		self.eval_list = [(self.d_test, 'eval'), (self.d_train, 'train')]
		self.bst = xgb.Booster()

	def cv(self):
		result = xgb.cv(self.param, self.d_train, num_boost_round=10, nfold=3)

	def train(self):
		plst = self.param.items()
		num_round = 20
		self.bst = xgb.train(plst, self.d_train, num_round, self.eval_list)

	def test(self):
		predict = self.bst.predict(self.d_test)
		sio.savemat('data/predict_xgb.mat', {'predict': predict})

	def save_model(self):
		self.bst.save_model('model/xgb.model')

	def load_model(self):
		self.bst.load_model('model/xgb.model')

	def dump_model(self):
		self.bst.dump_model('model/xgb.txt', 'model/feature_map.txt')
