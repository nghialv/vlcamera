//
//  NATopView.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NATopView.h"

@implementation NATopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initView
{
    float logoWidth = self.bounds.size.width - 40;
    float logoTopMargin = 15.f;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(20, logoTopMargin, logoWidth, logoWidth)];
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logo];
    // take pic btn
    float topMargin = logoTopMargin * 2 + logoWidth;
    float btnWidth = IS_IPAD ? 150.f : 130.f;
    float btnHeight = 80.f;
    float rightMargin = IS_IPAD ? 50.f : 10.f;
    float leftMargin = self.bounds.size.width/2 - btnWidth - rightMargin;
    FUIButton *takePicBtn = [[FUIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                        topMargin,
                                                                        btnWidth,
                                                                        btnHeight)];
    [takePicBtn setTitle:[[NADB5 theme] stringForKey:@"take_picture_label"] forState:UIControlStateNormal];
    takePicBtn.buttonColor = [[NADB5 theme] colorForKey:@"top_screen_btn_color"];
    takePicBtn.cornerRadius = 4.0f;
    takePicBtn.shadowColor = [[NADB5 theme] colorForKey:@"top_screen_btn_shadow_color"];
    takePicBtn.shadowHeight = 3.5f;
    [takePicBtn addTarget:self action:@selector(takePicBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:takePicBtn];
    
    // choose pic btn
    float leftMargin2 = self.bounds.size.width/2 + rightMargin;
    FUIButton *selectPicBtn = [[FUIButton alloc] initWithFrame:CGRectMake(leftMargin2,
                                                                          topMargin,
                                                                          btnWidth,
                                                                          btnHeight)];
    [selectPicBtn setTitle:[[NADB5 theme] stringForKey:@"choose_picture_label"] forState:UIControlStateNormal];
    selectPicBtn.buttonColor = [[NADB5 theme] colorForKey:@"top_screen_btn_color"];
    selectPicBtn.cornerRadius = 4.0f;
    selectPicBtn.shadowColor = [[NADB5 theme] colorForKey:@"top_screen_btn_shadow_color"];
    selectPicBtn.shadowHeight = 3.5f;
    [selectPicBtn addTarget:self action:@selector(choosePicBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:selectPicBtn];
}

- (void)takePicBtnPressed
{
    [self.delegate takePicBtnPressedDel];
}

- (void)choosePicBtnPressed
{
    [self.delegate choosePicBtnPressedDel];
}

@end
