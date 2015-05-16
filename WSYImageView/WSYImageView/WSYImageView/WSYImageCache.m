//
//  WSYImageCache.m
//  WSYImageView
//
//  Created by YSC on 15/5/13.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSYImageCache.h"

@implementation WSYImageCache

+ (WSYImageCache *)sharedImageCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
- (id)init {
    return [self initWithNamespace:@"default"];
}

- (id)initWithNamespace:(NSString *)ns {
    if ((self = [super init])) {
        self.cache = [[NSCache alloc] init];
        _cache.name = @"WSYImageCache";
    }
    
    return self;
}

- (BOOL)objectIsExistForKey: (NSString *)key
{
    return [_cache objectForKey:key];
}

- (void)storeImage:(UIImage *)image forKey:(NSString *)key {
    [_cache setObject:image forKey:key];
}
- (UIImage *)imageWithUrl: (NSString *)urlStr
{
    return [_cache objectForKey:urlStr];
}

- (void)removeAllCache
{
    [_cache removeAllObjects];
}


@end
