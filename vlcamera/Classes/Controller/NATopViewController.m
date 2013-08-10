//
//  NATopViewController.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NATopViewController.h"
#import "NAEditingViewController.h"
#import "NATopView.h"

@interface NATopViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, NATopViewDelegate>

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) NATopView *myView;

@end

@implementation NATopViewController

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
    self.myView = [[NATopView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
    // create imagePickerController
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - NATopViewDelegate
- (void)takePicBtnPressedDel
{
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    self.imagePickerController.navigationBarHidden = YES;
    [self presentViewController:self.imagePickerController animated:NO completion:nil];
}

- (void)choosePicBtnPressedDel
{
    [self.imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    if(IS_IPAD) {
        if(!self.popover) {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        }
        [self.popover presentPopoverFromRect:CGRectMake(self.view.bounds.size.width/4,
                                                        self.view.bounds.size.height/4,
                                                        self.view.bounds.size.width/2,
                                                        self.view.bounds.size.height/2)
                                      inView:self.myView
                    permittedArrowDirections:NO
                                    animated:YES];
    } else {
        [self presentViewController:self.imagePickerController animated:NO completion:nil];
    }
}

#pragma imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(IS_IPAD && [picker sourceType] == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self.popover dismissPopoverAnimated:YES];
    } else {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    NAEditingViewController *editingController = [[NAEditingViewController alloc] init];
    editingController.currentImage = info[UIImagePickerControllerOriginalImage];
    [self.navigationController pushViewController:editingController animated:NO];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
