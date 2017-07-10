//
//  ViewController.m
//  webp
//
//  Created by 北极星 on 2017/7/10.
//  Copyright © 2017年 aa. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *mg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [mg sd_setImageWithURL:[NSURL URLWithString:@"http://p1.pstatp.com/origin/2deb0004d84d0b5c6192.webp"]];
    [self.view addSubview:mg];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
