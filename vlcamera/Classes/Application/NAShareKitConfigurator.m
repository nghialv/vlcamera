//
//  NAShareKitConfigurator.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAShareKitConfigurator.h"

@implementation NAShareKitConfigurator

- (NSString *)appName {
    return @"vlcamera";
}

- (NSString *)appURL {
    return @"http://nghialv.com";
}

- (NSNumber *)isUsingCocoaPods {
    return [NSNumber numberWithBool:YES];
}

@end
