//
//  ViewController.m
//  WSYImageView
//
//  Created by 袁仕崇 on 15/5/9.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"
#import "WSYImageView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet WSYImageView *img1;

@end

@implementation ViewController
{
    BOOL change;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_img1 setAlwaysAnimation:NO];
    [_img1 ws_setImageWithImageName:@[@"tu4.jpg", @"tu5.jpg", @"tu6.jpg", @"tu8.jpg"][arc4random()%4] placeholderImage:[UIImage imageNamed:@"tu8.jpg"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    [_img1 ws_setImageWithImageName:@[@"tu4.jpg", @"tu5.jpg", @"tu6.jpg", @"tu8.jpg"][change ? 1 : 0] placeholderImage:[UIImage imageNamed:@"tu8.jpg"]];
    change = !change;
}

@end
