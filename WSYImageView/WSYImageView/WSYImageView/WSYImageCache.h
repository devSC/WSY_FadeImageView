//
//  WSYImageCache.h
//  WSYImageView
//
//  Created by YSC on 15/5/13.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WSYImageCache : NSObject
@property (strong, nonatomic)  NSCache *cache;

+ (WSYImageCache *)sharedImageCache;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageWithUrl: (NSString *)urlStr;
- (void)removeAllCache;


@end
