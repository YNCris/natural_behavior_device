# -*- coding: utf-8 -*-
"""
Created on Thu Oct 24 10:02:03 2019

@author: chen
"""


import logging
import scipy.misc
import cv2                                # state of the art computer vision algorithms library
import numpy as np                        # fundamental package for scientific computing
import matplotlib.pyplot as plt           # 2D plotting library producing publication quality figures
import pyrealsense2 as rs                 # Intel RealSense cross-platform open-source API
print("Environment Ready")



ctx = rs.context()
for d in ctx.query_devices():
    print(d)




