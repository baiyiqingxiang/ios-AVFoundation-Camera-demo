//
//  PhotoView.m
//  AVFoundation拍照和视频录制
//
//  Created by 白衣卿相 on 2017/7/12.
//  Copyright © 2017年 白衣卿相. All rights reserved.
//

#import "PhotoView.h"
#import <AVFoundation/AVFoundation.h>



typedef void(^CompleteHandle)(UIImage * photo);
@interface PhotoView ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) AVCaptureSession * captureSession;
/**AVCaptureDeviceInput*/
@property (nonatomic, strong)AVCaptureDeviceInput * deviceInput;
/**AVCaptureOutput*/
@property (nonatomic, strong)AVCapturePhotoOutput * photoOutput;
@property (nonatomic, copy)CompleteHandle completeHandle;
@end


@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame completeHandle:(void (^)(UIImage *))completeHandle{
    if (self = [super initWithFrame:frame]) {
        self.completeHandle = completeHandle;
        [self configCamera];
        [self setUserInterface];
    }
    return self;
}


- (void)setUserInterface
{
    NSArray * leftBtnTitles = @[@"auto",@"open",@"close"];
    CGFloat btnSize = 30.f;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat margin = 30.f;

    for (int i = 0; i < leftBtnTitles.count; i ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10, (margin + btnSize) * i + margin , btnSize, btnSize)];
        [button setImage:[UIImage imageNamed:leftBtnTitles[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [self addSubview:button];
    }
    NSArray * rightBtnTitles = @[@"change"];
    for (int i = 0; i < rightBtnTitles.count; i ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(width - btnSize - 10, (margin + btnSize) * i + margin , btnSize, btnSize)];
        [button setImage:[UIImage imageNamed:rightBtnTitles[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
         button.tag = 200 + i;
        [self addSubview:button];
    }
    
    
    
    UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takeButton.frame = CGRectMake((width - 60) / 2, height - 70, 60, 60);
    [takeButton setImage:[UIImage imageNamed:@"carema"] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:takeButton];
}

- (void)configCamera
{
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    
    AVCaptureDevice * device = [self cameraDeviceWithPosition:AVCaptureDevicePositionBack];
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    
    
    if ([self.captureSession canAddInput:self.deviceInput]) {
        [self.captureSession addInput:self.deviceInput];
    }
    if ([self.captureSession canAddOutput:self.photoOutput]) {
        [self.captureSession addOutput:self.photoOutput];
    }
    
    AVCaptureVideoPreviewLayer * previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previewLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self.layer addSublayer:previewLayer];
}


- (AVCaptureDevice *)cameraDeviceWithPosition:(AVCaptureDevicePosition)position
{
    
    AVCaptureDeviceDiscoverySession * dev_dis_session = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position];
    if (dev_dis_session.devices.count > 0) {
        return [dev_dis_session.devices firstObject];
    }
    return nil;
    
    
}

- (void)start
{
    [self.captureSession startRunning];
}
- (void)stop
{
    [self.captureSession stopRunning];
}



- (void)takePhoto
{
    NSDictionary * output_set = @{AVVideoCodecKey:AVVideoCodecJPEG};
    AVCapturePhotoSettings * photoset = [AVCapturePhotoSettings photoSettingsWithFormat:output_set];
    [self.photoOutput capturePhotoWithSettings:photoset delegate:self ];
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    if(!error){
        self.completeHandle(image);
    
    }
    
}


- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        // 自动
    }
    if (sender.tag == 101) {
        // 开启
    }
    if (sender.tag == 102) {
        // 关闭
    }
    if (sender.tag == 200) {
        // 调换摄像头
        [self changeCaremaMode];
    }
}



- (void)changeCaremaMode
{

    AVCaptureDevicePosition currentPosition =  self.deviceInput.device.position;

    AVCaptureDevice * device;
    
    if (currentPosition == AVCaptureDevicePositionBack) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
        }
        device = [self cameraDeviceWithPosition:AVCaptureDevicePositionFront];
    }
    if (currentPosition ==  AVCaptureDevicePositionFront) {
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]) {
            [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
        }
        device = [self cameraDeviceWithPosition:AVCaptureDevicePositionBack];
    }
    AVCaptureDeviceInput * deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.deviceInput];
    if ([self.captureSession canAddInput:deviceInput]) {

        [self.captureSession addInput:deviceInput];
        self.deviceInput = deviceInput;
    }
    [self.captureSession commitConfiguration];

}
@end
