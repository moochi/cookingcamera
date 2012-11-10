//
//  SendFormViewController.m
//  cookingcamera
//
//  Created by mochida rei on 2012/11/10.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "SendFormViewController.h"

@interface SendFormViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImageView *frameView;

@end

@implementation SendFormViewController

- (void) sendButtonAction {
    NSInteger height = 450;
    if (self.view.frame.size.width != 320) {
        height = 900;
    }
    CGSize resizedSize = CGSizeMake(self.view.frame.size.width, height);
    UIGraphicsBeginImageContext(resizedSize);
    [self.imageView.image drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    [self.frameView.image drawAtPoint:CGPointMake(0, 0)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.view addSubview:[[UIImageView alloc] initWithImage:resizeImage]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.imageView setImage:self.image];
    //[self.imageView setFrame:CGRectMake(0, 0, self.image.size.width, self.image.size.height)];
    
    self.frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame"]];
    [self.view addSubview:self.frameView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sendButton setTitle:@"send" forState:UIControlStateNormal];
    [sendButton sizeToFit];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.image = nil;
}

@end
