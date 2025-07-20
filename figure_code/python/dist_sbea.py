# -*- coding: utf-8 -*-
"""
Created on Sat Mar 22 16:01:23 2025

@author: yanin
"""

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

savename = rootname + '-rel_dist-cebra'

tempneu = scio.loadmat(\
           rootpath + r'\\' + rootname + r'-neu.mat')['dff_smo_Fc'].transpose()
    
temppose = scio.loadmat(\
           rootpath + r'\\' + rootname + r'-rel_dist.mat')['rel_dist']

#%% train model
datas = tempneu.copy()
labels = temppose.copy()

max_iterations = 15000

# single session training, cebra cannot be used in the 离散时间多动物
cebra_model_list = []

multi_cebra_model = CEBRA(model_architecture='offset10-model',
                    batch_size=1024,
                    learning_rate=3e-4,
                    temperature=1,
                    output_dimension=3,
                    max_iterations=max_iterations,
                    distance='cosine',
                    conditional='time_delta',
                    device='cuda',
                    verbose=True,
                    time_offsets=10)

# Provide a list of data, i.e. datas = [data_a, data_b, ...]
multi_cebra_model.fit(datas, labels)
#%%

multi_cebra_model.save(savepath + "\\"+ savename +".pt")

print('save')
#%% Transform each session with the right model, by providing the corresponding session ID
multi_embeddings = multi_cebra_model.transform(datas)
plt.plot(multi_embeddings[:,0],\
         multi_embeddings[:,1],
         multi_embeddings[:,2],'-')
plt.show()
#%% save data
save_mat_data = {'cebra': multi_embeddings}
scio.savemat(rootpath + '/' + savename + '.mat',save_mat_data)

print('save')
print(savename)









