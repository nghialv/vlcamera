//
//  NAView.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIButton.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import "NADB5.h"

@protocol NAViewDelegate <NSObject>

@end

@interface NAView : UIView

@property (weak, nonatomic) id delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id) delegate;
- (void)initView;
- (void)updateContent;

@end
