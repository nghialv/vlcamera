//
//  NAShareView.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAView.h"

@protocol NAShareViewDelegate <NAViewDelegate>

- (void)shareFacebookBtnPressedDel;
- (void)shareTwitterBtnPressedDel;

@end

@interface NAShareView : NAView

- (void)setImage:(UIImage *)image;

@end
