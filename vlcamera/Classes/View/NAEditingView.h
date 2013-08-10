//
//  NAEditingView.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAView.h"

@protocol NAEditingViewDelegate <NAViewDelegate>

- (void)doneBtnPressedDel;

- (void)undoBtnPressedDel;
- (void)addBtnPressedDel;
- (void)flipBtnPressedDel;
- (void)trashBtnPressedDel;

- (void)panGestureActionDel:(UIPanGestureRecognizer *)sender currentSticker:(UIView *)sticker;
- (void)pinchGestureAction:(UIPinchGestureRecognizer *)sender currentSticker:(UIView *)sticker;
- (void)rotationGestureAction:(UIRotationGestureRecognizer *)sender currentSticker:(UIView *)sticker;

@end

@interface NAEditingView : NAView

@property (strong, nonatomic) UIImageView *currentImageView;
@property (strong, nonatomic) UIView *currentSticker;

@property (strong, nonatomic) NSMutableArray *stickerArray;

- (void)setCurrentImage:(UIImage *)image;
- (void)initNavigationBar:(UINavigationItem *)navigationItem;

- (void)addSticker:(UIImage *)image;
- (void)addTextView:(UIColor *)color;
- (void)removeCurrentSticker;

@end
