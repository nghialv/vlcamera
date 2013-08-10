//
//  NAShareView.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAShareView.h"
#import <iAd/iAd.h>

@interface NAShareView() <ADBannerViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) ADBannerView *customAdView;
@property (assign, nonatomic) BOOL bannerIsVisible;

@end

@implementation NAShareView

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
    float iadHeight = IS_IPAD ? [[NADB5 theme] floatForKey:@"iad_height_ipad"] : [[NADB5 theme] floatForKey:@"iad_height_iphone"];
    int btnWidth = 120;
    int btnHeight = 50;
    float margin = IS_IPAD ? 20.f : 10.f;
    float topMargin = margin;
    float width = self.bounds.size.width;
    float height = self.bounds.size.height - iadHeight - 4*margin - btnHeight - 44.f;
    float leftMargin = (self.bounds.size.width - width)/2;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    topMargin += height + margin;
    leftMargin = (self.bounds.size.width/2 - btnWidth)/2;
    FUIButton *facebookBtn = [[FUIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                         topMargin,
                                                                         btnWidth,
                                                                         btnHeight)];
    [facebookBtn setTitle:@"Facebook" forState:UIControlStateNormal];
    facebookBtn.buttonColor = RGB(24, 116, 205);
    facebookBtn.cornerRadius = 3.0f;
    facebookBtn.shadowColor = [UIColor greenSeaColor];
    facebookBtn.shadowHeight = 1.5f;
    [facebookBtn addTarget:self action:@selector(shareFacebookBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:facebookBtn];
    
    //twitter
    leftMargin += self.bounds.size.width/2;
    FUIButton *twitterBtn = [[FUIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                        topMargin,
                                                                        btnWidth,
                                                                        btnHeight)];
    [twitterBtn setTitle:@"Twitter" forState:UIControlStateNormal];
    twitterBtn.buttonColor = RGB(0, 229, 238);
    twitterBtn.cornerRadius = 3.0f;
    twitterBtn.shadowColor = RGB(0, 134, 139);
    twitterBtn.shadowHeight = 1.5f;
    [twitterBtn addTarget:self action:@selector(shareTwitterBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:twitterBtn];
    
    // config iAd
    self.bannerIsVisible = NO;
    self.customAdView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, iadHeight)];
    self.customAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    self.customAdView.delegate = self;
    [self addSubview:self.customAdView];
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

- (void)shareFacebookBtnPressed
{
    [self.delegate shareFacebookBtnPressedDel];
}

- (void)shareTwitterBtnPressed
{
    [self.delegate shareTwitterBtnPressedDel];
}

#pragma mark - iAd delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"OK");
    if (!self.bannerIsVisible) {
        float iadHeight = IS_IPAD ? [[NADB5 theme] floatForKey:@"iad_height_ipad"] : [[NADB5 theme] floatForKey:@"iad_height_iphone"];
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.customAdView.center = CGPointMake(self.center.x, self.bounds.size.height - iadHeight/2);                      }
                         completion:nil];
        self.bannerIsVisible = YES;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Did fail to receive ad with error");
    if (self.bannerIsVisible) {
        float iadHeight = IS_IPAD ? [[NADB5 theme] floatForKey:@"iad_height_ipad"] : [[NADB5 theme] floatForKey:@"iad_height_iphone"];
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.customAdView.center = CGPointMake(self.center.x, self.bounds.size.height + iadHeight/2);                      }
                         completion:nil];
        self.bannerIsVisible = NO;
    }
}

@end
