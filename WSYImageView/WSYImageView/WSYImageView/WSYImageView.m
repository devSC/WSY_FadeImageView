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
    [self.foreImageView setImage:placeholder];
    self.placeholder = placeholder;
    [self setImageUrl:urlString];
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName) {
        _imageName = imageName;
        [self setImage:[UIImage imageNamed:imageName] animation:YES storeKey:imageName];
    }else {
        UIImage *image = [[WSYImageCache sharedImageCache] imageWithUrl:imageName];
        if (image) {
            [self setImage:image animation:_alwaysAnimation storeKey:imageName];
        }
    }
    
}
- (void)setImageUrl:(NSString *)imageUrl
{
    //    [self.foreImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:_placeholder];
    //    return;
    {
        if (imageUrl) {
            __weak UIImageView *wself = self.foreImageView;
            __weak WSYImageView *weakSelf = self;
            id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (!wself) return;
                dispatch_main_sync_safe(^{
                    if (!wself) return;
                    if (image) {
                        [weakSelf setImage:image animation:YES storeKey:imageUrl];
                        //                        weakSelf.foreImageView.layer.contents = (__bridge id)image.CGImage;
                        [wself setNeedsLayout];
                    } else {
                        //                        if ((options & SDWebImageDelayPlaceholder)) {
                        //                            wself.image = placeholder;
                        //                            [wself setNeedsLayout];
                        //                        }
                    }
                });
            }];
            [self.foreImageView sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
        } else {
            dispatch_main_async_safe(^{
                //                NSError *error = [NSError errorWithDomain:@"SDWebImageErrorDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
                //                if (completedBlock) {
                //                    completedBlock(nil, error, SDImageCacheTypeNone, url);
                //                }
            });
        }
    }
    
    return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];;
        if (image) {
            [self setImage:image animation:YES storeKey:imageUrl];
            return;
        }
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        //    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
        [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    // do something with image
                                    //                                NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime*1000);
                                    //                                    [self setImage:image animation:YES storeKey:imageUrl];
                                    self.foreImageView.layer.contents = (__bridge id)image.CGImage;
                                }
                            }];
    });
    
    /*
     if (_imageUrl != imageUrl) {
     _imageUrl = imageUrl;
     
     dispatch_async(dispatch_get_global_queue(0, 0), ^{
     UIImage *image = [[WSYImageCache sharedImageCache] imageWithUrl:imageUrl];
     if (!image) {
     NSDate* tmpStartData = [NSDate date];
     //You code here...
     //                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:imageUrl] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     //                // progression tracking code
     //            }
     //            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
     //                if (image) {
     //                    // do something with image
     //                }
     //            }];
     //            options:<#(SDWebImageDownloaderOptions)#>
     //            progress:<#^(NSInteger receivedSize, NSInteger expectedSize)progressBlock#>
     //            completed:<#^(UIImage *image, NSData *data, NSError *error, BOOL finished)completedBlock#>
     
     SDWebImageManager *manager = [SDWebImageManager sharedManager];
     double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
     [manager downloadImageWithURL:[NSURL URLWithString:imageUrl]
     options:0
     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
     // progression tracking code
     }
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
     if (image) {
     // do something with image
     NSLog(@">>>>>>>>>>cost time = %f ms", deltaTime*1000);
     [self setImage:image animation:YES storeKey:imageUrl];
     }
     }];
     
     
     //                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
     }else {
     [self setImage:image animation:_alwaysAnimation storeKey:imageUrl];
     }
     });
     }else {
     UIImage *image = [[WSYImageCache sharedImageCache] imageWithUrl:imageUrl];
     if (image) {
     [self setImage:image animation:_alwaysAnimation storeKey:imageUrl];
     }
     }
     */
}

- (void)setImage: (UIImage *)image animation: (BOOL)animation storeKey: (NSString *)key
{
    if (!animation) {
        [self.foreImageView setImage:image];
        return;
    }
    if (!_animationSwitch) {
        double delayInSeconds = 0.1;
        _animationSwitch = YES;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(),^(void) {
            @autoreleasepool {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    /*
                     UIImage* bluredImage = nil;
                     if(image == nil)
                     bluredImage = [self getBlurredImage:_placeholder];
                     else
                     bluredImage = [self getBlurredImage:image];
                     bluredImage = image;
                     */
                    
                    //cache
                    //                    [[WSYImageCache sharedImageCache] storeImage:bluredImage forKey:key];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.backImageView setAlpha:1.0];
                        [self.foreImageView setAlpha:0.0];
                        [self.backImageView setImage:self.foreImageView.image];
                        [self.foreImageView setImage:image];
                        [UIView animateWithDuration:_duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                            [self.backImageView setAlpha:0.0];
                            [self.foreImageView setAlpha:1.0];
                        } completion:^(BOOL finished) {
                            _animationSwitch = NO;
                        }];
                    });
                });
            }
        });
    }
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