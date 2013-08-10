//
//  NAStickerListView.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAView.h"

@protocol NAStickerListViewDelegate <NAViewDelegate>

- (void)closeBtnPressedDel:(NSString *)imageName;

@end

@interface NAStickerListView : NAView

- (void)setDataSource:(NSArray *)data andNavigationItem:(UINavigationItem *)navItem;

@end
