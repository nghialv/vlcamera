//
//  NAStickerListViewController.h
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAViewController.h"

@protocol NAStickerListViewControllerDelegate <NSObject>

- (void)didSelectSticker:(NSString *)imageName;

@end

@interface NAStickerListViewController : NAViewController

@property (weak, nonatomic) id<NAStickerListViewControllerDelegate> delegate;

@end
