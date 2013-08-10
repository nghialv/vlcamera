//
//  NATopView.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAView.h"

@protocol NATopViewDelegate <NAViewDelegate>

- (void) takePicBtnPressedDel;
- (void) choosePicBtnPressedDel;

@end

@interface NATopView : NAView

@end
