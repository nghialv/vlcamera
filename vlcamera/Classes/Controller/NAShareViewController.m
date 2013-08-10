//
//  NAShareViewController.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAShareViewController.h"
#import <SHK.h>
#import <SHKFacebook.h>
#import <SHKTwitter.h>
#import "NAShareView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NAShareViewController () <NAShareViewDelegate>

@property (strong, nonatomic) NAShareView *myView;

@end

@implementation NAShareViewController
@synthesize currentImage = mCurrentImage;

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
    [SVProgressHUD showSuccessWithStatus:[[NADB5 theme] stringForKey:@"save_success_label"]];
    
	// Do any additional setup after loading the view.
    self.myView = [[NAShareView alloc] initWithFrame:self.view.bounds andDelegate:self];
    [self.myView setImage:self.currentImage];
    self.view = self.myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NAShareViewDelegate
- (void)shareFacebookBtnPressedDel
{
    SHKItem *item = [SHKItem image:self.currentImage title:@"vlcamera"];
    [SHKFacebook shareItem:item];
}

- (void)shareTwitterBtnPressedDel
{
    SHKItem *item = [SHKItem image:self.currentImage title:@"vlcamera"];
    [SHKTwitter shareItem:item];
}

@end
