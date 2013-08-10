//
//  NAStickerList.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAStickerListView.h"
#import <PSCollectionView/PSCollectionView.h>
#import <iAd/iAd.h>

@interface NAStickerListView() <PSCollectionViewDelegate, PSCollectionViewDataSource, ADBannerViewDelegate>

@property (strong, nonatomic)NSArray *data;
@property (strong, nonatomic)UIScrollView *topScrollView;
@property (strong, nonatomic)PSCollectionView *gridView;
@property (strong, nonatomic)NSDictionary *curStickerDic;
@property (strong, nonatomic)NSArray *stickers;
@property (strong, nonatomic)UIButton *curGroupBtn;

@property (strong, nonatomic) ADBannerView *customAdView;
@property (assign, nonatomic) BOOL bannerIsVisible;

@end

@implementation NAStickerListView
@synthesize topScrollView = mTopScrollView;
@synthesize gridView = mGridView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDataSource:(NSArray *)data andNavigationItem:(UINavigationItem *)navItem
{
    self.data = data;
    
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                              target:self
                                                                              action:@selector(closeBtnPressed)];
    navItem.rightBarButtonItem = closeBtn;
    [navItem.rightBarButtonItem setTintColor:[[NADB5 theme] colorForKey:@"bar_btn_color"]];
    
    self.curStickerDic = [self.data objectAtIndex:0];
    self.stickers = [self.curStickerDic objectForKey:@"stickers"];
    
    // top scrollview
    float topViewHeight = 60.f;
    float btnWidth = 50.f;
    float margin = 5.f;
    mTopScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topViewHeight)];
    mTopScrollView.backgroundColor = RGB(208, 222, 255);
    [self addSubview:mTopScrollView];
    
    [self.data enumerateObjectsUsingBlock:^(NSDictionary *group, NSUInteger i, BOOL *stop) {
        float x = i*(btnWidth + 3*margin) + margin;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, margin, btnWidth, btnWidth)];
        NSString *logo = [group objectForKey:@"logo"];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:logo] forState:UIControlStateNormal];
        [btn setTag:i];
        [btn addTarget:self action:@selector(stickerGroupSelected:) forControlEvents:UIControlEventTouchDown];
        if (i == 0) {
            [self groupBtnSelected:btn];
            self.curGroupBtn = btn;
        }
        [mTopScrollView addSubview:btn];
    }];
    
    float contentWidth = (btnWidth + 3*margin) *[self.data count] + margin;
    mTopScrollView.contentSize = CGSizeMake(contentWidth, topViewHeight);
    
    // grid view
    mGridView = [[PSCollectionView alloc] initWithFrame:CGRectMake(0,
                                                                   topViewHeight,
                                                                   self.bounds.size.width,
                                                                   self.bounds.size.height -  topViewHeight)];
    mGridView.collectionViewDataSource = self;
    mGridView.collectionViewDelegate = self;
    mGridView.delegate = (id<UIScrollViewDelegate>)self;
    mGridView.backgroundColor = [UIColor whiteColor];
    mGridView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    int k = IS_IPAD ? 4 : 2;
    mGridView.numColsPortrait = k;
    [self addSubview:mGridView];
    
    // config iAd
    self.bannerIsVisible = NO;
    float iadHeight = IS_IPAD ? [[NADB5 theme] floatForKey:@"iad_height_ipad"] : [[NADB5 theme] floatForKey:@"iad_height_iphone"];
    self.customAdView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, iadHeight)];
    self.customAdView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    self.customAdView.delegate = self;
    [self addSubview:self.customAdView];
}

- (void)groupBtnUnselected:(UIButton *)btn
{
    [UIView animateWithDuration:0.2f
                     animations:^(void) {
                         CGRect f = CGRectMake(btn.frame.origin.x,
                                               btn.frame.origin.y - 5,
                                               btn.frame.size.width,
                                               btn.frame.size.height);
                         btn.frame = f;
                         btn.backgroundColor = [UIColor clearColor];
                     }
                     completion:nil];
}

- (void)groupBtnSelected:(UIButton *)btn
{
    [UIView animateWithDuration:0.2f
                     animations:^(void) {
                         CGRect f = CGRectMake(btn.frame.origin.x,
                                               btn.frame.origin.y + 5,
                                               btn.frame.size.width,
                                               btn.frame.size.height);
                         btn.frame = f;
                         btn.backgroundColor = [UIColor whiteColor];
                     }
                     completion:nil];
}

- (void)stickerGroupSelected:(id)btn
{
    [self groupBtnUnselected:self.curGroupBtn];
    self.curGroupBtn = (UIButton *)btn;
    int index = self.curGroupBtn.tag;
    [self groupBtnSelected:self.curGroupBtn];
    self.curStickerDic = [self.data objectAtIndex:index];
    self.stickers = [self.curStickerDic objectForKey:@"stickers"];
    [self.gridView reloadData];
}

- (void)closeBtnPressed
{
    [self.delegate closeBtnPressedDel:nil];
}

#pragma mark - CollectionView delegate
- (Class)collectionView:(PSCollectionView *)collectionView cellClassForRowAtIndex:(NSInteger)index {
    return [PSCollectionViewCell class];
}

- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView {
    return [self.stickers count];
}

- (UIView *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index {
    NSString *fileName = [self.stickers objectAtIndex:index];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
        dispatch_async(dispatch_get_main_queue(), ^{
            // switch back to the main thread to update your UI
            imageView.image = image;
        });
    });
    return imageView;
}

- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index {
    int k = IS_IPAD ? 5 : 3;
    return self.bounds.size.width/k;
}

- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    NSString *fileName = [self.stickers objectAtIndex:index];
    [self.delegate closeBtnPressedDel:fileName];
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
