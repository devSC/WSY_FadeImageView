//
//  WSYImageView.h
//  WSYImageView
//
//  Created by 袁仕崇 on 15/5/9.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSYImageView : UIView

- (void)setImageWithUrlString: (NSString *)urlString;
- (void)setWSImageViewContentMode:(UIViewContentMode)contentMode;
- (void)setImageWithImageName: (NSString *)name;
- (void)setImage: (UIImage *)image;

- (void)setDefaultImageWithImageName: (NSString *)name;
- (void)setDefaultImage: (UIImage *)image;
@end
