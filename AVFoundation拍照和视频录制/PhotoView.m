//
//  PhotoView.m
//  AVFoundation拍照和视频录制
//
//  Created by 白衣卿相 on 2017/7/12.
//  Copyright © 2017年 白衣卿相. All rights reserved.
//

#import "PhotoView.h"
#import <AVFoundation/AVFoundation.h>



typedef void(^CompleteHandle)(void);
@interface PhotoView ()<AVCapturePhotoCaptureDelegate>

@property (nonatomic, strong) AVCaptureSession * captureSession;
/**AVCaptureDeviceInput*/
@property (nonatomic, strong)AVCaptureDeviceInput * deviceInput;
/**AVCaptureOutput*/
@property (nonatomic, strong)AVCapturePhotoOutput * photoOutput;
@property (nonatomic, copy)CompleteHandle completeHandle;
@end


@implementation PhotoView

- (instancetype)initWithFrame:(CGRect)frame completeHandle:(void (^)())completeHandle
{
    if (self = [super initWithFrame:frame]) {
        self.completeHandle = completeHandle;
        [self configCamera];
        [self setUserInterface];
    }
    return self;
}


- (void)setUserInterface
{
    UIButton *takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    takeButton.frame = CGRectMake((self.bounds.size.width - 70) / 2, self.bounds.size.height - 90, 70, 70);
    takeButton.layer.masksToBounds = YES;
    takeButton.layer.cornerRadius = takeButton.frame.size.height / 2;
    takeButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    [takeButton setTitle:@"拍照" forState:UIControlStateNormal];
    takeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    takeButton.titleLabel.numberOfLines = 0;
    [takeButton setTitleColor:[UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:0.9] forState:UIControlStateNormal];
    [takeButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:takeButton];
}

- (void)configCamera
{
    self.captureSession = [[AVCaptureSession alloc] init];
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
        self.completeHandle();
    
    }
    
}

@end
