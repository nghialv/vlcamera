//
//  NAEditingView.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAEditingView.h"
#import <QuartzCore/QuartzCore.h>

@interface NAEditingView() <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    CGAffineTransform mTextFieldTrans;
    CGPoint mTextFieldCenter;
}

@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation NAEditingView

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
    self.backgroundColor = [UIColor whiteColor];
    // init stickerArray
    self.stickerArray = [[NSMutableArray alloc] init];
    /*** TOOLBAR ***/
    float toolbarHeight = 50.f;
    float navBarHeight = 44.f;
    float topMargin = 5.f;
    float leftMargin = 12.f;
    float btnWidth = 40.f;
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,
                                                               self.bounds.size.height - toolbarHeight - navBarHeight,
                                                               self.bounds.size.width,
                                                               toolbarHeight)];
    //self.toolbar.backgroundColor = [[NADB5 theme] colorForKey:@"toolbar_color"];
    [self.toolbar setBackgroundImage:[[NADB5 theme] imageForKey:@"toolbar_bg_image"]
                  forToolbarPosition:0
                          barMetrics:0];
    
    // trash button
    UIButton *trashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [trashBtn setImage:[[NADB5 theme] imageForKey:@"trash_toolbar_btn_image"] forState:UIControlStateNormal];
    trashBtn.frame = CGRectMake(leftMargin, topMargin, btnWidth, btnWidth);
    [trashBtn addTarget:self action:@selector(trashBtnPressed) forControlEvents:UIControlEventTouchDown];
    // add button
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[[NADB5 theme] imageForKey:@"add_toolbar_btn_image"] forState:UIControlStateNormal];
    addBtn.frame = CGRectMake(self.toolbar.center.x - btnWidth/2, topMargin, btnWidth, btnWidth);
    [addBtn addTarget:self action:@selector(addBtnPressed) forControlEvents:UIControlEventTouchDown];
    // flip button
    float marginx = self.toolbar.bounds.size.width*3.f/4;
    UIButton *flipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [flipBtn setImage:[[NADB5 theme] imageForKey:@"flip_toolbar_btn_image"] forState:UIControlStateNormal];
    flipBtn.frame = CGRectMake(marginx - btnWidth/2 - leftMargin/2, topMargin, btnWidth, btnWidth);
    [flipBtn addTarget:self action:@selector(flipBtnPressed) forControlEvents:UIControlEventTouchDown];
    // undo button
    UIButton *undoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [undoBtn setImage:[[NADB5 theme] imageForKey:@"undo_toolbar_btn_image"] forState:UIControlStateNormal];
    undoBtn.frame = CGRectMake(self.toolbar.bounds.size.width - btnWidth - leftMargin, topMargin, btnWidth, btnWidth);
    [undoBtn addTarget:self action:@selector(undoBtnPressed) forControlEvents:UIControlEventTouchDown];
    
    [self.toolbar addSubview:trashBtn];
    [self.toolbar addSubview:addBtn];
    [self.toolbar addSubview:flipBtn];
    [self.toolbar addSubview:undoBtn];
    [self.toolbar setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth];
    [self addSubview:self.toolbar];
    
    // image view
    self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          self.bounds.size.width,
                                                                          self.bounds.size.height - toolbarHeight - navBarHeight)];
    [self.currentImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:self.currentImageView];
    
    /*** SET GESTURE RECOGNIZER ***/
    // tap ges
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapGes];
    // pan ges
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                             action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGes];
    // pinch ges
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(pinchGestureAction:)];
    pinchGes.delegate = self;
    [self addGestureRecognizer:pinchGes];
    // rotation ges
    UIRotationGestureRecognizer *rotationGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(rotationGestureAction:)];
    rotationGes.delegate = self;
    [self addGestureRecognizer:rotationGes];
}

- (void)setCurrentImage:(UIImage *)image
{
    [self.currentImageView setImage:image];
}

- (void)initNavigationBar:(UINavigationItem *)navigationItem
{
    /*** NAVIGATION BAR ***/
    // done button
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self
                                                                             action:@selector(doneBtnPressed)];
    navigationItem.rightBarButtonItem = doneBtn;
    [navigationItem.rightBarButtonItem setTintColor:[[NADB5 theme] colorForKey:@"bar_btn_color"]];
}

- (void)addSticker:(UIImage *)image
{
    // unhighlight current sticker
    [self unhighlightSticker:self.currentSticker];
    // create new sticker
    self.currentSticker = [[UIImageView alloc] initWithImage:image];
    [self highlightSticker:self.currentSticker];
    self.currentSticker.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    self.currentSticker.center = self.currentImageView.center;
    [self.currentSticker setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.currentSticker addGestureRecognizer:tapGes];
    // add new sticker to view and sticker array
    [self.stickerArray addObject:self.currentSticker];
    [self addSubview:self.currentSticker];
    // bring new sticker to from
    [self bringStickerToFront:self.currentSticker];
}

- (void)addTextView:(UIColor *)color
{
    // unhighlight current sticker
    [self unhighlightSticker:self.currentSticker];
    // create new textField
    float width = self.bounds.size.width*4.f/5;
    float height = IS_IPAD ? 150.f : 80.f;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.currentSticker = textField;
    [self highlightSticker:self.currentSticker];
//    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//    [self.currentSticker addGestureRecognizer:tapGes];
    textField.delegate = self;
    textField.center = self.currentImageView.center;
    textField.textColor = color;
    textField.backgroundColor = [UIColor clearColor];
    textField.layer.cornerRadius = 3.f;
    
    // setting for textField
    [textField setText:@"input text"];
    textField.font = TEXTFONT(DEFAULT_FONT_SIZE);
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // add textview in stickerarray
    [self.stickerArray addObject:self.currentSticker];
    [self addSubview:self.currentSticker];
    // bring new sticker to from
    [self bringStickerToFront:self.currentSticker];
}

- (void)removeCurrentSticker
{
    if(self.currentSticker) {
        [self.stickerArray removeObject:self.currentSticker];
        [self.currentSticker removeFromSuperview];
    }
    self.currentSticker = nil;
    if([self.stickerArray count] > 0) {
        self.currentSticker = [self.stickerArray objectAtIndex:0];
        [self highlightSticker:self.currentSticker];
    }
}

- (void)bringStickerToFront:(UIView *)sticker
{
    [self bringSubviewToFront:sticker];
    [self bringSubviewToFront:self.toolbar];
}

- (void)highlightSticker:(UIView *)sticker
{
    sticker.layer.borderColor = [UIColor greenColor].CGColor;
    sticker.layer.borderWidth = 1.5f;
}

- (void)unhighlightSticker:(UIView *)sticker
{
    sticker.layer.borderWidth = 0.f;
}

#pragma mark - textviewdelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self unhighlightSticker:self.currentSticker];
    self.currentSticker = textField;
    [self highlightSticker:self.currentSticker];
    [self bringStickerToFront:self.currentSticker];
    
    // animation
    [UIView animateWithDuration:0.2f
                     animations:^(void){
                         // save center and transform
                         mTextFieldCenter = textField.center;
                         mTextFieldTrans = textField.transform;
                         // change center and transform
                         textField.center = CGPointMake(self.center.x, self.center.y - 100.f);
                         // rotate
                         CGFloat angle = atan2f(textField.transform.b, textField.transform.a);
                         CGFloat cosAlpha = cosf(angle);
                         // scale
                         CGAffineTransform tran = CGAffineTransformMakeScale(textField.transform.a/cosAlpha, textField.transform.d/cosAlpha);
                         textField.transform = tran;
                     }
                     completion:nil];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    // animation
    [UIView animateWithDuration:0.25f
                     animations:^(void){
                         // change center and transform
                         textField.center = mTextFieldCenter;
                         textField.transform = mTextFieldTrans;                     }
                     completion:nil];
    return YES;
}

#pragma mark - navigation bar
- (void)doneBtnPressed
{
    [self.delegate doneBtnPressedDel];
}

#pragma mark - toolbar
- (void)trashBtnPressed
{
    [self.delegate trashBtnPressedDel];
}

- (void)addBtnPressed
{
    [self.delegate addBtnPressedDel];
}

- (void)flipBtnPressed
{
    [self.delegate flipBtnPressedDel];
}

- (void)undoBtnPressed
{
    [self.delegate undoBtnPressedDel];
}

#pragma mark - gesture action
- (void)tapGestureAction:(UITapGestureRecognizer *)sender
{
    [self endEditing:YES];
    if (sender.view != self) {
        [self unhighlightSticker:self.currentSticker];
        self.currentSticker = (UIView *)sender.view;
        [self highlightSticker:self.currentSticker];
        [self bringStickerToFront:self.currentSticker];
    }
}

- (void)panGestureAction:(UIPanGestureRecognizer *)sender
{
    [self.delegate panGestureActionDel:sender currentSticker:self.currentSticker];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)sender
{
    [self.delegate pinchGestureAction:sender currentSticker:self.currentSticker];
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer *)sender
{
    [self.delegate rotationGestureAction:sender currentSticker:self.currentSticker];
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
