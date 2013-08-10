//
//  NADB5.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NADB5.h"

@implementation NADB5

+ (NADB5 *)sharedInstance
{
    __strong static NADB5 *sharedDB5 = nil;
    static dispatch_once_t onceQueue = 0;
    dispatch_once(&onceQueue, ^{
        sharedDB5 = [[NADB5 alloc] init];
        sharedDB5.themeLoader = [VSThemeLoader new];
        sharedDB5.theme = sharedDB5.themeLoader.defaultTheme;
    });

    return sharedDB5;
}

+ (VSTheme *)theme
{
    return [[self sharedInstance] theme];
}

@end
