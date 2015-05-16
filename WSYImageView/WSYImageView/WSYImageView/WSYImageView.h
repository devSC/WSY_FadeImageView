//
//  WSYImageView.h
//  WSYImageView
//
//  Created by 袁仕崇 on 15/5/9.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYImageView : UIView

@property (assign, nonatomic) NSInteger duration; //default is 1.0s
@property (assign, nonatomic) NSInteger blurRadius; //default is 3.0
@property (assign, nonatomic) UIViewContentMode imageViewContentModel; //default is UIViewContentModeScaleAspectFill
@property (assign, nonatomic) BOOL alwaysAnimation; //default is no just for first set

- (void)ws_setImageWithUrlString:(NSString *)urlString placeholderImage: (UIImage *)placeholder;
- (void)ws_setImageWithImageName: (NSString *)name placeholderImage: (UIImage *)placeholder;

- (void)ws_setImageBlurWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder; //blur
- (void)ws_setImageBlurWithImageName: (NSString *)name placeholderImage: (UIImage *)placeholder;//blur

@end



