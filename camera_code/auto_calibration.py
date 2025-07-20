# -*- coding: utf-8 -*-
"""
Created on Sat Oct 26 14:32:08 2019

@author: chen
@modifyed: hyn 
"""


import cv2                                # state of the art computer vision algorithms library
import numpy as np                        # fundamental package for scientific computing
import pyrealsense2 as rs                 # Intel RealSense cross-platform open-source API
import time
import random
print("Environment Ready")
import os

def mkdir(path):
    folder = os.path.exists(path)
    if not folder:  # 判断是否存在文件夹如果不存在则创建为文件夹
        os.makedirs(path)  # makedirs 创建文件时如果路径不存在会创建这个路径
        print("---  new folder...  ---")
        print("---  OK  ---")
    else:
        print("---  There is this folder!  ---")


number_squence = '1'
nowdate = "20240103"

savepath = 'G:\\RS_Camera\\calibration_images'

file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence
mkdir(file)  # 调用函数
file =  savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary1'
mkdir(file)  # 调用函数
file =  savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary1\\Primary'
mkdir(file)  # 调用函数
file =  savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary1\\Secondary1'
mkdir(file)  # 调用函数

file =  savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary2'
mkdir(file)  # 调用函数
file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary2\\Primary'
mkdir(file)  # 调用函数
file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary2\\Secondary2'
mkdir(file)  # 调用函数

file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary3'
mkdir(file)  # 调用函数
file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary3\\Primary'
mkdir(file)  # 调用函数
file = savepath + '\\calibrationimages_' + nowdate + '_' + number_squence + '\\PrimarySecondary3\\Secondary3'
mkdir(file)  # 调用函数


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


#%%
checkerboard = cv2.imread('calibration_checkerboard_white_bigger_new.png')#size 26mm
rows, cols, _ = checkerboard.shape
checkerboard_win = "checkerboard_win"
cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
cv2.moveWindow(checkerboard_win, 3840,0) 
cv2.resizeWindow(checkerboard_win,1920,1920)
cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
#cv2.resizeWindow(checkerboard_win,480,320)
    
   
cv2.imshow(checkerboard_win, checkerboard)

k = cv2.waitKey(1)


times = 4
imgnum = 35

rotcolor = 255
bias = 50
randnum = 5

time.sleep(1)

#%%

total_count = 1
for temptime in range(times):
    for count in range(70):   
        #%%
        
        
        #cv2.resizeWindow(checkerboard_win,480,320)
        
        if count >= 0 and count <= 10:
            #%%
            i = count
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            
               
            cv2.imshow(checkerboard_win, rotation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 11 and count <= 20:
            #%%
            i = count - 10
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, 0 + random.randint(0, randnum)], [0, 1, -bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
                
            
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 21 and count <= 30:
            #%%
            i = count - 20
    
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, 0 + random.randint(0, randnum)], [0, 1,bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
        
               
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 31 and count <= 40:
            #%%
            i = count - 30
    
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, bias + random.randint(0, randnum)], [0, 1, bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
                
               
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 41 and count <= 50:
            #%%
            i = count - 40
    
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, -bias + random.randint(0, randnum)], [0, 1,-bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
               
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 51 and count <= 60:
            #%%
            i = count - 50
    
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, bias + random.randint(0, randnum)], [0, 1,-bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
                             
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)
            #%%
        if count >= 61 and count <= 70:
            #%%
            i = count - 60
    
    
            M_rotation = cv2.getRotationMatrix2D((cols / 2, rows / 2), i * 36 + random.randint(0, randnum), 1)
            rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #rotation = cv2.warpAffine(checkerboard, M_rotation, (cols, rows), borderValue=(255, 255, 255))
    
            M_translation = np.float32([[1, 0, -bias + random.randint(0, randnum)], [0, 1,bias + random.randint(0, randnum)]])
            translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(rotcolor, rotcolor, rotcolor))
            #translation = cv2.warpAffine(rotation, M_translation, (cols, rows), borderValue=(255, 255, 255))
    
            # checkerboard_win = "checkerboard_win"
            # cv2.namedWindow(checkerboard_win, cv2.WINDOW_NORMAL)
            # cv2.moveWindow(checkerboard_win, 3840,0) 
            # cv2.resizeWindow(checkerboard_win,1920,1920)
            # cv2.setWindowProperty(checkerboard_win, cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)
                
               
            cv2.imshow(checkerboard_win, translation)
    
            k = cv2.waitKey(1)
            time.sleep(0.2)   
            #%%
        # Camera 1
        # Wait for a coherent pair of frames: depth and color
        frames_1 = pipeline_1.wait_for_frames()
        color_frame_1 = frames_1.get_color_frame()
        if not color_frame_1:
            continue
        # Convert images to numpy arrays
        color_image_1 = np.asanyarray(color_frame_1.get_data())
        
        # Camera 2
        # Wait for a coherent pair of frames: depth and color
        frames_2 = pipeline_2.wait_for_frames()
        color_frame_2 = frames_2.get_color_frame()
        if not color_frame_2:
            continue
        # Convert images to numpy arrays
        color_image_2 = np.asanyarray(color_frame_2.get_data())
        
        # Camera 3
        # Wait for a coherent pair of frames: depth and color
        frames_3 = pipeline_3.wait_for_frames()
        color_frame_3 = frames_3.get_color_frame()
        if not color_frame_3:
            continue
        # Convert images to numpy arrays
        color_image_3 = np.asanyarray(color_frame_3.get_data())       
        
        # Camera 4
        # Wait for a coherent pair of frames: depth and color
        frames_4 = pipeline_4.wait_for_frames()
        color_frame_4 = frames_4.get_color_frame()
        if not color_frame_4:
            continue
        # Convert images to numpy arrays
        color_image_4 = np.asanyarray(color_frame_4.get_data())        
        
        
    
        count_str = str(total_count)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary1/Primary/frame"+count_str+".png",color_image_1)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary2/Primary/frame"+count_str+".png",color_image_1)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary3/Primary/frame"+count_str+".png",color_image_1)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary1/Secondary1/frame"+count_str+".png",color_image_2)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary2/Secondary2/frame"+count_str+".png",color_image_3)
        cv2.imwrite(savepath + "/calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary3/Secondary3/frame"+count_str+".png",color_image_4)
        print ("Save",total_count)
        
        total_count += 1
            
    




#%% Stop streaming
pipeline_1.stop()
pipeline_2.stop()
pipeline_3.stop()
pipeline_4.stop()    

    
    
cv2.destroyAllWindows() 
    

