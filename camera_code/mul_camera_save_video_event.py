# -*- coding: utf-8 -*-
"""
Created on Sun Oct 27 21:53:29 2019

@author: chen
@modifyed: hyn
"""


#import logging
#import scipy.misc
import cv2                                # state of the art computer vision algorithms library
import numpy as np                        # fundamental package for scientific computing
#import matplotlib.pyplot as plt           # 2D plotting library producing publication quality figures
import pyrealsense2 as rs                 # Intel RealSense cross-platform open-source API
import time
import os
import serial

#%% init event box
triger_flag = 1
if triger_flag == 1:
    portx = "COM4"
    bps = 115200
    timex=None
    ser_event=serial.Serial(portx,bps,timeout=timex)
    print("串口详情参数：", ser_event) 

def mkdir(path):
    folder = os.path.exists(path)
    if not folder:  # 判断是否存在文件夹如果不存在则创建为文件夹
        os.makedirs(path)  # makedirs 创建文件时如果路径不存在会创建这个路径
        print("---  new folder...  ---")
        print("---  OK  ---")
    else:
        print("---  There is this folder!  ---")


print("Environment Ready")

video_count = '7'
minute = 15
date = '20240103'


mkdir('G:\\RS_Camera\\raw_videos\\raw_video_' + date)


frame_stop = minute * 30 * 60 + 1
count = 1
frame_count = 1
fourcc = cv2.VideoWriter_fourcc(*'MJPG')
out1 = cv2.VideoWriter('G:\\RS_Camera\\raw_videos\\raw_video_' +date + '\\seg-'+video_count+'-mouse-day1-camera-1.avi',fourcc, 30.0, (640,480))
out2 = cv2.VideoWriter('G:\\RS_Camera\\raw_videos\\raw_video_' +date + '\\seg-'+video_count+'-mouse-day1-camera-2.avi',fourcc, 30.0, (640,480))
out3 = cv2.VideoWriter('G:\\RS_Camera\\raw_videos\\raw_video_' +date + '\\seg-'+video_count+'-mouse-day1-camera-3.avi',fourcc, 30.0, (640,480))
out4 = cv2.VideoWriter('G:\\RS_Camera\\raw_videos\\raw_video_' +date + '\\seg-'+video_count+'-mouse-day1-camera-4.avi',fourcc, 30.0, (640,480))
et_f = open('G:\\RS_Camera\\raw_videos\\raw_video_'+date + '\\seg-'+video_count+'-mouse-day1-event.txt',"w",encoding="utf-8")

# Configure depth and color streams...
# ...from Camera 1
pipeline_1 = rs.pipeline()
config_1 = rs.config()
config_1.enable_device('838212070904')
config_1.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 2
pipeline_2 = rs.pipeline()
config_2 = rs.config()
config_2.enable_device('838212073846')
config_2.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 3
pipeline_3 = rs.pipeline()
config_3 = rs.config()
config_3.enable_device('745412071534')
config_3.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 4
pipeline_4 = rs.pipeline()
config_4 = rs.config()
config_4.enable_device('838212070925')
config_4.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)


# Start streaming from both cameras
setlp = 0
pipeline_1.start(config_1)
sensor_1 = pipeline_1.get_active_profile().get_device().first_depth_sensor()
lp1 = sensor_1.get_option(rs.option.laser_power)
print(lp1)
lp1 = sensor_1.set_option(rs.option.laser_power,setlp)
print(lp1)
pipeline_2.start(config_2)
sensor_2 = pipeline_2.get_active_profile().get_device().first_depth_sensor()
lp2 = sensor_2.get_option(rs.option.laser_power)
print(lp2)
lp2 = sensor_2.set_option(rs.option.laser_power,setlp)
print(lp2)
pipeline_3.start(config_3)
sensor_3 = pipeline_3.get_active_profile().get_device().first_depth_sensor()
lp3 = sensor_3.get_option(rs.option.laser_power)
print(lp3)
lp3 = sensor_3.set_option(rs.option.laser_power,setlp)
print(lp3)
pipeline_4.start(config_4)
sensor_4 = pipeline_4.get_active_profile().get_device().first_depth_sensor()
lp4 = sensor_4.get_option(rs.option.laser_power)
print(lp4)
lp4 = sensor_4.set_option(rs.option.laser_power,setlp)
print(lp4)

    
print('start')
#time_start=time.time()
cv2.namedWindow('RealSense', cv2.WINDOW_NORMAL)

total_time = 0

framecount = 0

while True:
    time_start=time.time()
    
    if frame_count == frame_stop:
        break
   
    frames_1 = pipeline_1.wait_for_frames()
    frames_2 = pipeline_2.wait_for_frames()
    frames_3 = pipeline_3.wait_for_frames()
    frames_4 = pipeline_4.wait_for_frames()
   
    
    # Camera 1
    # Wait for a coherent pair of frames: depth and color

    color_frame_1 = frames_1.get_color_frame()
    if not color_frame_1:
        continue
    # Convert images to numpy arrays
    color_image_1 = np.asanyarray(color_frame_1.get_data())
    
    # Camera 2
    # Wait for a coherent pair of frames: depth and color

    color_frame_2 = frames_2.get_color_frame()
    if not color_frame_2:
        continue
    # Convert images to numpy arrays
    color_image_2 = np.asanyarray(color_frame_2.get_data())

    # Camera 3
    # Wait for a coherent pair of frames: depth and color
    
    color_frame_3 = frames_3.get_color_frame()
    if not color_frame_3:
        continue
    # Convert images to numpy arrays
    color_image_3 = np.asanyarray(color_frame_3.get_data())       
    
    # Camera 4
    # Wait for a coherent pair of frames: depth and color
    
    color_frame_4 = frames_4.get_color_frame()
    if not color_frame_4:
        continue
    # Convert images to numpy arrays
    color_image_4 = np.asanyarray(color_frame_4.get_data())   
    
    
    


    # Stack all images horizontally
    images = np.hstack((color_image_1[::2,::2,:],color_image_2[::2,::2,:],color_image_3[::2,::2,:],color_image_4[::2,::2,:]))





    out1.write(color_image_1)  # 保存视频
    out2.write(color_image_2)  # 保存视频
    out3.write(color_image_3)  # 保存视频
    out4.write(color_image_4)  # 保存视频   
    

    # Show images from both cameras
    
    cv2.imshow('RealSense', images)
    #cv2.waitKey(1)
    
    key = cv2.waitKey(1)
    
    
    framecount = framecount + 1
    
    if framecount == 1:
        ser_event.write(chr(0x31).encode("utf-8")) # Start event, TPM counting channel 2
        et_f.write('1\n')
    else:
        et_f.write('0\n')
        
    if framecount == 150:# Event latency 150 frames
        framecount = 0
    
    

    # Press esc or 'q' to close the image window 按esc或q退出程序
    if key & 0xFF == ord('q') or key == 27:
        break        
    
    frame_count = frame_count + 1
   
    
    time_end=time.time()
    
    total_time = total_time + (time_end-time_start)
    
    print(frame_count-1,'  time:',time_end-time_start,'s')    

#%%
# Stop streaming
# time_end=time.time()
print("stop")
cv2.destroyAllWindows()
out1.release()
out2.release()
out3.release()
out4.release()
pipeline_1.stop()
pipeline_2.stop()
pipeline_3.stop()
pipeline_4.stop()
et_f.close()
print('time cost',total_time,'s')