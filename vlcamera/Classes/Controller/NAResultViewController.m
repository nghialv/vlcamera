//
//  NAResultViewController.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAResultViewController.h"
#import "NAShareViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NAResultViewController ()

@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation NAResultViewController

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
    [SVProgressHUD dismiss];
    
    [[self.navigationController navigationBar] setHidden:NO];
    self.view.backgroundColor = [UIColor blackColor];
    // save button
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(saveBtnPressed)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   self.view.bounds.size.width,
                                                                   self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height)];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.imageView.image = self.currentImage;
    [self.view addSubview:self.imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveBtnPressed
{
    UIImageWriteToSavedPhotosAlbum(self.currentImage, nil, nil, nil);
    NAShareViewController *shareViewController = [[NAShareViewController alloc] init];
    shareViewController.currentImage = self.currentImage;
    [self.navigationController pushViewController:shareViewController animated:YES];
}


@end
