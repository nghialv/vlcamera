//
//  NAViewController.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIAlertView.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import "NADB5.h"

@interface NAViewController : UIViewController

@property (strong, nonatomic) FUIAlertView *alertView;

- (UIView *) errorView;
- (UIView *) loadingView;
- (void) showLoadingAnimated:(BOOL) animated;
- (void) hideLoadingAnimated:(BOOL) animated;
- (void) showErrorViewAnimated:(BOOL) animated;
- (void) hideErrorViewAnimated:(BOOL) animated;
- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andDelegate:(id)delegate;

@end
