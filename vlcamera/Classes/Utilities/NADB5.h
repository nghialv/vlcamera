//
//  NADB5.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <VSTheme.h>
#import <VSThemeLoader.h>

@interface NADB5 : NSObject

@property (strong, nonatomic) VSThemeLoader *themeLoader;
@property (strong, nonatomic) VSTheme *theme;

+ (NADB5 *)sharedInstance;
+ (VSTheme *)theme;

@end
