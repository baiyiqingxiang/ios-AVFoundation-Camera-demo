//
//  PhotoView.h
//  AVFoundation拍照和视频录制
//
//  Created by 白衣卿相 on 2017/7/12.
//  Copyright © 2017年 白衣卿相. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 使用 AVFoundation 拍照好而录制视频的一般步骤
 * 1、创建AVCaptureSession对象。AVCaptureSession：媒体捕捉会话，负责把捕获的音视频数据输出到输出设备中，一个AVCaptureSession可以有多个输入输出。
 * 2、使用AVCaptureDevice的静态方法获得需要使用的设备。AVCaptureDevice：输入设备，包括麦克风、摄像头等，通过该对象可以设置物理设备的属性，如相机聚焦、白平衡。
 * 3、利用输入设备AVCaptureDevice初始化AVCaptureDeviceInput对象。AVCaptureDeviceInput：设备输入数据管理对象，可以根据AVCaptureDevice创建对应的AVCaptureDeviceInput对象，该对象会被添加到AVCaptureSeeeion中管理。
 * 4、初始化输出数据管理对象AVCaptureOutput，如果拍照就初始化AVCapturePhotoOutput对象，如果视频录制就初始化AVCaptureMovieFileOutput对象。AVCaptureOutput：用于接受各类的输出数据，通常使用对应的子类，如AVCaptureAudioDataOutput、AVCapturePhotoOutput、AVCaptureVideoDataOutput、AVCaptureFileOutput。该对象也会被添加到AVCaptureSession管理。
 * 5、将数据输入对象AVCaptureDeviceInput和数据输出对象AVCaptureOutput添加到AVCaptureSession管理。
 * 6、创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示器中，挑用AVCaptureSession 的 startRuning 方法开始捕获。AVCaptureVideoPreviewLayer：相机拍摄预览图层，是CALayer的子类，使用该对象可以实时查看拍照或视频录制效果，创建该对象需要指定对应的AVCaptureSession对象。
 * 7、将捕获的音频或视频数据输出到指定文件。
 */

@interface PhotoView : UIView


- (instancetype)initWithFrame:(CGRect)frame completeHandle:(void (^)(UIImage * photo))completeHandle;



- (void)start;
- (void)stop;
@end
