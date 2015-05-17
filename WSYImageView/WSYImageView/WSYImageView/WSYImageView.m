//
//  WSYImageView.m
//  WSYImageView
//
//  Created by 袁仕崇 on 15/5/9.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSYImageView.h"
#import "WSYImageCache.h"
#import "SDWebImageDownloader.h"
#import "UIImage+imageEffects.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCacheOperation.h"
#import "SDWebImageCompat.h"

#pragma mark - WSYImageView
@interface WSYImageView ()

@property (nonatomic, strong) UIImageView *foreImageView;
@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation WSYImageView
{
    BOOL _animationSwitch;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib
{
    [self setUp];
}




#pragma mark -
- (void)setImageViewContentModel:(UIViewContentMode)imageViewContentModel
{
    [self.foreImageView setContentMode:imageViewContentModel];
    [self.backImageView setContentMode:imageViewContentModel];
}

- (void)ws_setPlaceholderImage: (UIImage *)placeholder
{
    if (!_placeholder) {
        self.placeholder = placeholder;
        [self.foreImageView setImage:placeholder];
    }
}


- (void)ws_setImageBlurWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder
{
    if (!_placeholder) {
        [self.foreImageView setImage:placeholder];
        self.placeholder = placeholder;
    }
    [self setImageUrl:urlString];
    
}

- (void)ws_setImageBlurWithImageName: (NSString *)name placeholderImage: (UIImage *)placeholder
{
    if (!_placeholder) {
        [self.foreImageView setImage:placeholder];
        self.placeholder = placeholder;
    }
    [self setImageName:name];
    
}

- (void)ws_setImageWithImageName: (NSString *)name placeholderImage: (UIImage *)placeholder
{
    [self.foreImageView setImage:placeholder];
    self.placeholder = placeholder;
    [self setImageName:name];
}

- (void)ws_setImageWithUrlString:(NSString *)urlString placeholderImage: (UIImage *)placeholder
{
    //    [self resetView];
    self.placeholder = placeholder;
    [self setImageUrl:urlString];
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
        [self setImage:[UIImage imageNamed:imageName] animation:YES];
    }else {
        UIImage *image = [[WSYImageCache sharedImageCache] imageWithUrl:imageName];
        if (image) {
            [self setImage:image animation:_alwaysAnimation];
        }
    }
    
}
- (void)ws_cancelCurrentImageLoad {
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}

- (void)setImageUrl:(NSString *)imageUrl
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];;
        if (image) {
            [self setImage:image animation:NO];
            return;
        }
        {
            [self ws_cancelCurrentImageLoad];
            dispatch_main_async_safe(^{
                self.foreImageView.image = _placeholder;
            });
            
            if (imageUrl) {
                __weak UIImageView *wself = self.foreImageView;
                __weak __typeof(self) weakSelf = self;
                
                id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (!wself) return;
                    dispatch_main_sync_safe(^{
                        if (!wself) return;
                        if (image) {
                            //                        wself.image = image;
                            [weakSelf setImage:image animation:YES];
                            [wself setNeedsLayout];
                        } else {
                            [weakSelf setImage:_placeholder animation:NO];
                            [wself setNeedsLayout];
                        }
                    });
                }];
                [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
            } else {
                [self setImage:_placeholder animation:NO];
            }
        }
    });
}

- (void)setImage: (UIImage *)image animation: (BOOL)animation
{
    if (!animation) {
        dispatch_main_sync_safe(^{
            [self.foreImageView setImage:image];
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backImageView setAlpha:1.0];
        [self.foreImageView setAlpha:0.0];
        [self.backImageView setImage:self.foreImageView.image];
        [self.foreImageView setImage:image];
        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            [self.backImageView setAlpha:0.0];
            [self.foreImageView setAlpha:1.0];
        } completion:^(BOOL finished) {
            //                _animationSwitch = NO;
        }];
    });
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(),^(void) {
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    /*
//                     UIImage* bluredImage = nil;
//                     if(image == nil)
//                     bluredImage = [self getBlurredImage:_placeholder];
//                     else
//                     bluredImage = [self getBlurredImage:image];
//                     bluredImage = image;
//                     */
//                    
//                    //cache
//                    //                    [[WSYImageCache sharedImageCache] storeImage:bluredImage forKey:key];
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.backImageView setAlpha:1.0];
//                        [self.foreImageView setAlpha:0.0];
//                        [self.backImageView setImage:self.foreImageView.image];
//                        [self.foreImageView setImage:image];
//                        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                            [self.backImageView setAlpha:0.0];
//                            [self.foreImageView setAlpha:1.0];
//                        } completion:^(BOOL finished) {
//                            _animationSwitch = NO;
//                        }];
//                    });
//                });
//        });
}

#pragma mark - init
- (void)setUp
{
    self.foreImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.foreImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_foreImageView];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:_backImageView];
    //default
    [self setImageViewContentModel:UIViewContentModeScaleAspectFill];
    self.foreImageView.layer.masksToBounds = YES;
    self.backImageView.layer.masksToBounds = YES;
    self.alwaysAnimation = NO;
    self.blurRadius = 3.;
    self.duration =1.0;
}

- (UIImage *)getBlurredImage:(UIImage *)imageToBlur {
    CGSize  imageSize = imageToBlur.size;
    return [imageToBlur applyBlurWithCrop:CGRectMake(0,0,imageSize.width,imageSize.height) resize:imageSize blurRadius:_blurRadius tintColor:[UIColor clearColor] saturationDeltaFactor:1.0 maskImage:nil];
}
- (void)resetView {
    [self.backImageView setImage:nil];
    [self.foreImageView setImage:nil];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end