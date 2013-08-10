//
//  NAStickerListViewController.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAStickerListViewController.h"
#import "NAStickerListView.h"

@interface NAStickerListViewController () <NAStickerListViewDelegate>

@property (strong, nonatomic) NAStickerListView *myView;
@property (strong, nonatomic) NSMutableArray *stickerList;

@end

@implementation NAStickerListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.stickerList = [[NSMutableArray alloc] init];
    
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* stickerDir = [resourcePath stringByAppendingPathComponent:@"icons"];
    NSError * error;
    NSArray * stickerFolders = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:stickerDir error:&error];
    for (NSString *t in stickerFolders){
        NSString *path = [stickerDir stringByAppendingPathComponent:t];
        BOOL isDir = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
        if(isDir) {
            NSString *dir = [NSString stringWithFormat:@"icons/%@", t];
            NSArray *files = [[NSBundle mainBundle] pathsForResourcesOfType:@".png" inDirectory:dir];            NSDictionary *stickerGroup = [[NSDictionary alloc] initWithObjectsAndKeys:t, @"name",
                                          [files objectAtIndex:0], @"logo",
                                          files, @"stickers", nil];
            [self.stickerList addObject:stickerGroup];
        }
    }
    
    self.myView = [[NAStickerListView alloc] initWithFrame:self.view.bounds andDelegate:self];
    [self.myView setDataSource:self.stickerList andNavigationItem:self.navigationItem];
    self.view = self.myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NAStickerListViewDelegate
- (void)closeBtnPressedDel:(NSString *)imageName
{
    if (imageName) {
        [self.delegate didSelectSticker:imageName];
    }
    [self dismissModalViewControllerAnimated:YES];
}

@end
