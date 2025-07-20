# -*- coding: utf-8 -*-
"""
Created on Sat Oct 26 14:32:08 2019

@author: chen
@modifyed: hyn
"""


import cv2                                # state of the art computer vision algorithms library
import numpy as np                        # fundamental package for scientific computing
import pyrealsense2 as rs                 # Intel RealSense cross-platform open-source API
print("Environment Ready")


count = 1


# Configure depth and color streams...
# ...from Camera 1
pipeline_1 = rs.pipeline()
config_1 = rs.config()
config_1.enable_device('142122071916')
config_1.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 2
pipeline_2 = rs.pipeline()
config_2 = rs.config()
config_2.enable_device('141722071801')
config_2.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 3
pipeline_3 = rs.pipeline()
config_3 = rs.config()
config_3.enable_device('143322070350')
config_3.enable_stream(rs.stream.color, 640, 480, rs.format.bgr8, 30)

# ...from Camera 4
pipeline_4 = rs.pipeline()
config_4 = rs.config()
config_4.enable_device('141722070811')
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




while True:

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
    
    
    
    
    # Stack all images horizontally
    images = np.hstack((color_image_1,color_image_2,color_image_3,color_image_4))
    
    
    
    


    # Show images from both cameras
    cv2.namedWindow('RealSense', cv2.WINDOW_NORMAL)
    cv2.imshow('RealSense', images)
    cv2.waitKey(1)
    

    # Save images and depth maps from both cameras by pressing 's'
    key = cv2.waitKey(1)
    if key==115:
        count_str = str(count)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary1/Primary/frame"+count_str+".png",color_image_1)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary2/Primary/frame"+count_str+".png",color_image_1)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary3/Primary/frame"+count_str+".png",color_image_1)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary1/Secondary1/frame"+count_str+".png",color_image_2)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary2/Secondary2/frame"+count_str+".png",color_image_3)
        # cv2.imwrite("calibrationimages_" + nowdate + '_'+ number_squence +"/PrimarySecondary3/Secondary3/frame"+count_str+".png",color_image_4)
        # print ("Save",count)

        count = count + 1
        
# Press esc or 'q' to close the image window 按esc或q退出程序
    if key & 0xFF == ord('q') or key == 27:
        cv2.destroyAllWindows()
        break        




# Stop streaming
pipeline_1.stop()
pipeline_2.stop()
pipeline_3.stop()
pipeline_4.stop()    

    
    
    
    

