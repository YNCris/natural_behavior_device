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
rootpath = r'D:\paper\jove_20250321\data_revise'
savepath = rootpath

if not os.path.exists(savepath):
    os.mkdir(savepath)
#%% load pose and tpmm data
rootname_list = ['free-seg1-1tpmss-1wt-20220226',
                 'free-seg4-2tpmss-4wt-20220226',
                 'free-seg1-3tpmss-5wt-20220227']

#%%
for k in range(len(rootname_list)):
    rootname = rootname_list[k]
    
    savename = rootname + '-neu-cebra'
    
    tempneu = scio.loadmat(\
               rootpath + r'\\' + rootname + r'-neu.mat')['dff_smo_Fc'].transpose()
        
    
    #%% train model
    datas = tempneu.copy()
    
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
    multi_cebra_model.fit(datas)
    #%%
    
    multi_cebra_model.save(savepath + "\\"+ savename +".pt")
    
    print('save')
    #%% Transform each session with the right model, by providing the corresponding session ID
    multi_embeddings = multi_cebra_model.transform(datas)
    
    x = multi_embeddings[:,0]
    y = multi_embeddings[:,1]
    z = multi_embeddings[:,2]
    
    # 开始画图
    fig = plt.figure(figsize=(10, 8))
    ax = fig.add_subplot(111, projection='3d')
    scatter = ax.scatter(x, y, z, s=1, alpha=0.6)
    
    # 设置标签
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    plt.title("3D Scatter Plot of Your Data")
    
    plt.show()
    #%% save data
    save_mat_data = {'cebra': multi_embeddings}
    scio.savemat(rootpath + '/' + savename + '.mat',save_mat_data)
    
    print('save')
    print(savename)









