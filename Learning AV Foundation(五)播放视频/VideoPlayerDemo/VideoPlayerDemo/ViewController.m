//
//  ViewController.m
//  VideoPlayerDemo
//
//  Created by SUNYAZHOU on 2018/3/4.
//  Copyright © 2018年 sunyazhou. All rights reserved.
//

#import "ViewController.h"
#import "PlayerController.h"
@interface ViewController ()
@property (nonatomic, strong) PlayerController *controller;
@property (nonatomic, strong) NSURL *localURL;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.localURL = [[NSBundle mainBundle] URLForResource:@"hubblecast" withExtension:@"m4v"];
    self.controller = [[PlayerController alloc] initWithURL:self.localURL];
    UIView *playerView = self.controller.view;
    playerView.frame = self.view.frame;
    [self.view addSubview:playerView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
