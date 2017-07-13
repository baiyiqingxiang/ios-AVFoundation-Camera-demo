//
//  ViewController.m
//  AVFoundation拍照和视频录制
//
//  Created by 白衣卿相 on 2017/7/12.
//  Copyright © 2017年 白衣卿相. All rights reserved.
//

#import "ViewController.h"
#import "PhotoView.h"



@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

   
    
    
    [self setUserInterface];
   
}


- (void)setUserInterface
{
    PhotoView * view = [[PhotoView alloc] initWithFrame:self.view.bounds completeHandle:^(UIImage * photo){
        NSLog(@"%@",photo);
    }];
    [self.view addSubview:view];
    [view start];
}

@end
