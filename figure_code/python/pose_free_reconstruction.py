'''
build up low dimensional embeddings 
'''
import sys

import matplotlib.pyplot as plt
import cebra.data
import cebra.datasets
import cebra.integrations
from cebra import CEBRA
import matplotlib.pyplot as plt
import pickle
import joblib as jl
import torch
import h5py
import numpy as np
from tqdm import tqdm
import scipy.io as scio
import os
import copy

def file_name(file_dir,fileformat):
  L=[]
  for root, dirs, files in os.walk(file_dir):
    for file in files:
      if os.path.splitext(file)[1] == fileformat:
        L.append(os.path.join(root, file))
  return L
#%%
rootpath = r'D:\paper\jove_20250321\data'
savepath = rootpath

if not os.path.exists(savepath):
    os.mkdir(savepath)
#%% load pose and tpmm data
rootname = 'free-seg1-3tpmss-5wt-20220227'

savename = rootname + '-pose-free-cebra'

tempneu = scio.loadmat(\
           rootpath + r'\\' + rootname + r'-neu.mat')['dff_smo_Fc'].transpose()
    
temppose = scio.loadmat(\
           rootpath + r'\\' + rootname + r'-pose-free.mat')['coords3d']
    
labels = temppose

#%% load embeddings
#% Transform each session with the right model, by providing the corresponding session ID
multi_embeddings = scio.loadmat(rootpath + '/' + savename + '.mat')['cebra']

#%% fit cebra knn decoder, prediction, and calculate the reconstruction error

train_time = 9000

#%
cebra_decoder = cebra.KNNDecoder(n_neighbors=1,metric="cosine")
cebra_decoder.fit(multi_embeddings[0:train_time,:], labels[0:train_time,:])

cebra_pred = cebra_decoder.predict(multi_embeddings)

tempdata = labels
tempdist = np.sqrt(np.sum( \
    (tempdata - cebra_pred) * \
    (tempdata - cebra_pred), axis=1)) / \
           np.size(cebra_pred, axis=1)
mean_dist = np.mean(tempdist)
#% append data

cebra_decoder_list = copy.deepcopy(cebra_decoder)
decode_list = copy.deepcopy(cebra_pred)

error_list = mean_dist

error_list_all = tempdist

#%% save to mat
tempsavename = savename + "-reconstruction_error.mat"

save_mat_data = {
    'decode_pred': decode_list,
    'dist_error': error_list,
    'dist_error_all': error_list_all}
scio.savemat(rootpath + '/' + tempsavename,save_mat_data)

print('save')
print(tempsavename)







