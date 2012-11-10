//
//  CookingCameraViewController.m
//  cookingcamera
//
//  Created by mochida rei on 2012/11/10.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "CookingCameraViewController.h"
#import "SendFormViewController.h"

@interface CookingCameraViewController ()
{
    AVCaptureSession *_session;;
    AVCaptureStillImageOutput *_stillImageOutput;
}

@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIImageView *frameView;

@end

@implementation CookingCameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSInteger height = 450;
    if (self.view.frame.size.width != 320) {
        height = 900;
    }
    CGSize baseViewSize = CGSizeMake(self.view.frame.size.width, height);

    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, baseViewSize.width, baseViewSize.height)];
    [self.view addSubview:self.baseView];
    
    // キャプチャセッションを作る
    _session = [[AVCaptureSession alloc]init];
    
    // ビデオの解像度 Midium
    if ([_session canSetSessionPreset:AVCaptureSessionPresetMedium]) {
        _session.sessionPreset = AVCaptureSessionPresetMedium;
    }
    
    // ビデオデバイスを取って
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 入力を作る
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    // セッションに入力を追加
    [_session addInput:input];
    
    // AVCaptureStillImageOutputで静止画出力を作る
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
    _stillImageOutput.outputSettings = outputSettings;
    //[outputSettings release];
    
    // セッションに出力を追加
    [_session addOutput:_stillImageOutput];
    
    // プレビューレイヤーを作って
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    // リサイズ形式を設定して
    videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // フレームサイズを設定して
    videoPreviewLayer.frame = self.view.bounds;
    // ビューのサブレイヤーにビデオ出力レイヤーを追加
    [self.baseView.layer addSublayer:videoPreviewLayer];
    
    [_session startRunning];
    
    // フレーム
    self.frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame"]];
    //[self.frameView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.frameView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"shutter" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shutterDownAction) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [self.view addSubview:button];
}

- (void)shutterDownAction {
    // コネクションを検索
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection)
            break;
    }
    
    // 静止画をキャプチャする
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler:
     ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
         if (imageSampleBuffer != NULL) {
             // キャプチャしたデータを取る
             NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
             // 押されたボタンにキャプチャした静止画を設定する
             
             SendFormViewController *nextView = [[SendFormViewController alloc] initWithNibName:@"SendFormViewController" bundle:nil];
             [nextView setImage:[UIImage imageWithData:data]];
             [self.navigationController pushViewController:nextView animated:NO];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
