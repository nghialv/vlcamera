//
//  NAEditingViewController.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAEditingViewController.h"
#import "NAStickerListViewController.h"
#import "NAResultViewController.h"
#import "NAEditingView.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface NAEditingViewController () <NAEditingViewDelegate, NAStickerListViewControllerDelegate> {
    NSUndoManager *mUndoManager;
}

@property (strong, nonatomic) NAEditingView *myView;

//@property (strong, nonatomic) NSUndoManager *undoManager;

@property (assign, nonatomic) float lastScale;
@property (assign, nonatomic) float lastRotation;
@property (assign, nonatomic) CGPoint lastPosition;

@end

@implementation NAEditingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.lastRotation = 0.f;
        self.lastScale = 1.f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mUndoManager = [[NSUndoManager alloc] init];
    [mUndoManager setLevelsOfUndo:20];
    // myView
    self.myView = [[NAEditingView alloc] initWithFrame:self.view.bounds andDelegate:self];
    [self.myView initNavigationBar:self.navigationItem];
    [self.myView setCurrentImage:self.currentImage];
    self.view = self.myView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - undo action
- (void)undoTransform:(CGAffineTransform)sender
{
    [self.myView.currentSticker setTransform:sender];
}

- (void)undoCenter:(CGPoint)sender
{
    [self.myView.currentSticker setCenter:sender];
}

#pragma mark - NAEditingViewDelegate
- (void)doneBtnPressedDel
{
    [SVProgressHUD showWithStatus:[[NADB5 theme] stringForKey:@"processing_label"]];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        UIImage *resultImage = [self imageProcessing];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            NAResultViewController *resultViewController = [[NAResultViewController alloc] init];
            [resultViewController setCurrentImage:resultImage];
            [self.navigationController pushViewController:resultViewController animated:YES];
        });
    });
}

- (UIImage *)imageProcessing
{
    //-- sort array
    NSArray *sortedIconArray = [self.myView.stickerArray sortedArrayUsingComparator:^(id obj1, id obj2){
        int index1 = [[self.myView subviews] indexOfObject:obj1];
        int index2 = [[self.myView subviews] indexOfObject:obj2];
        if(index1 > index2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedAscending;
    }];
    //-->
    UIImageView *currentImageView = self.myView.currentImageView;
    float rH = self.currentImage.size.height/currentImageView.bounds.size.height;
    float rW = self.currentImage.size.width/currentImageView.bounds.size.width;
    float r = MAX(rH, rW);
    float mdx = (currentImageView.bounds.size.width - self.currentImage.size.width/r)/2;
    float mdy = (currentImageView.bounds.size.height - self.currentImage.size.height/r)/2;
    CGSize newSize = self.currentImage.size;
    
    UIGraphicsBeginImageContext(newSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw current image
    [self.currentImage drawInRect:CGRectMake(0, 0, self.currentImage.size.width, self.currentImage.size.height)];
    // scale
    CGContextScaleCTM(context, r, r);
    CGContextTranslateCTM(context, currentImageView.bounds.size.width/2 - mdx, currentImageView.bounds.size.height/2 - mdy);
    
    // --> FROM HERE
    for (UIView *curSticker in sortedIconArray) {
        CGContextSaveGState(context);
        
        // translate
        CGContextTranslateCTM(context,
                              curSticker.center.x - currentImageView.center.x,
                              curSticker.center.y - currentImageView.center.y);
        // rotate
        CGFloat angle = atan2f(curSticker.transform.b, curSticker.transform.a);
        CGContextRotateCTM(context, angle);
        CGFloat cosAlpha = cosf(angle);
        // scale
        CGContextScaleCTM(context, curSticker.transform.a/cosAlpha, curSticker.transform.d/cosAlpha);
        // draw
        if ([curSticker isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)curSticker;
            [imageView.image drawInRect:CGRectMake(-curSticker.bounds.size.width/2,
                                                   -curSticker.bounds.size.height/2,
                                                   curSticker.bounds.size.width,
                                                   curSticker.bounds.size.height)
                              blendMode:kCGBlendModeNormal
                                  alpha:curSticker.alpha];
        } else {
            UITextField *textView = (UITextField *)curSticker;
            CGRect rect = CGRectMake(-curSticker.bounds.size.width/2,
                                     -curSticker.bounds.size.height/2,
                                     curSticker.bounds.size.width,
                                     curSticker.bounds.size.height);
            
            CGSize stringSize = [textView.text sizeWithFont:textView.font constrainedToSize:rect.size];
            rect.origin.y = rect.origin.y + ((rect.size.height - stringSize.height)/2);
            CGContextSetFillColorWithColor(context, textView.textColor.CGColor);
            [textView.text drawInRect:rect withFont:textView.font];
        }
        CGContextRestoreGState(context);
    }
    // --->
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (void)addBtnPressedDel
{
    NAStickerListViewController *stickerListViewController = [[NAStickerListViewController alloc] init];
    stickerListViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:stickerListViewController];
    if (IS_IPAD) {
        [navController.navigationBar setBackgroundImage:[[NADB5 theme] imageForKey:@"ipad_navbar_bg_image"]
                                          forBarMetrics:0];
    } else {
        [navController.navigationBar setBackgroundImage:[[NADB5 theme] imageForKey:@"navbar_bg_image"]
                                          forBarMetrics:0];
    }
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:navController animated:YES];
}

- (void)trashBtnPressedDel
{
    if (!self.myView.currentSticker) {
        [SVProgressHUD showErrorWithStatus:[[NADB5 theme] stringForKey:@"please_select_remove_item_label"]];
        return;
    }
    [self.myView removeCurrentSticker];
    [self.undoManager removeAllActions];
}

- (void)flipBtnPressedDel
{
    if (!self.myView.currentSticker) {
        [SVProgressHUD showErrorWithStatus:[[NADB5 theme] stringForKey:@"please_select_flip_item_label"]];
        return;
    }
    [UIView animateWithDuration:0.2f
                     animations:^(void){
                         CGAffineTransform curTran = self.myView.currentSticker.transform;
                         CGAffineTransform newTran = CGAffineTransformScale(curTran, -1.f, 1.f);
                         self.myView.currentSticker.transform = newTran;
                     }
                     completion:nil];
}

- (void)undoBtnPressedDel
{
    if([mUndoManager canUndo]) {
        [mUndoManager undo];
    } else {
        [SVProgressHUD showErrorWithStatus:[[NADB5 theme] stringForKey:@"cannt_undo_label"]];
    }
}

#pragma mark - NAEditingViewDelegate
- (void)panGestureActionDel:(UIPanGestureRecognizer *)sender currentSticker:(UIView *)sticker
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        self.lastPosition = [sender translationInView:self.myView];
        // undo manager
        [[mUndoManager prepareWithInvocationTarget:self] undoCenter:sticker.center];
    }
    CGPoint dp = CGPointMake([sender translationInView:self.myView].x - self.lastPosition.x,
                             [sender translationInView:self.myView].y - self.lastPosition.y);
    
    CGPoint center = sticker.center;
    center.x += dp.x;
    center.y += dp.y;
    sticker.center = center;
    self.lastPosition = [sender translationInView:self.myView];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)sender currentSticker:(UIView *)sticker
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        self.lastScale = 1.0;
        // undo manager
        [[mUndoManager prepareWithInvocationTarget:self] undoTransform:sticker.transform];
    }
    CGFloat scale = 1.0 - (self.lastScale - [sender scale]);
    
    CGAffineTransform currentTransform = sticker.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [sticker setTransform:newTransform];
    
    self.lastScale = [sender scale];
    // set font
    float currentScale = sqrt(newTransform.a * newTransform.a + newTransform.c * newTransform.c);
    if ([sticker isKindOfClass:[UITextField class]]) {
        UITextView *textView = (UITextView *)sticker;
        textView.font = TEXTFONT(DEFAULT_FONT_SIZE*currentScale);
    }
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer *)sender currentSticker:(UIView *)sticker
{
    if([sender state] == UIGestureRecognizerStateBegan) {
        self.lastRotation = 0.f;
        // undo manager
        [[mUndoManager prepareWithInvocationTarget:self] undoTransform:sticker.transform];
    }
    CGFloat rotation = 0.0 - (self.lastRotation - [sender rotation]);
    CGAffineTransform currentTransform = sticker.transform;
    // for flip case
    if (currentTransform.a < 0) {
        rotation = -rotation;
    }
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    [sticker setTransform:newTransform];
    self.lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
}

#pragma mark - NAStickerListViewControllerDelegate
- (void)didSelectSticker:(NSString *)imageName
{
    BOOL isText = NO;
    NSString *colorCode;
    if ([imageName rangeOfString:@"/00/"].location != NSNotFound) {
        colorCode = [[imageName lastPathComponent] stringByDeletingPathExtension];
        if ([colorCode rangeOfString:@"text_acc"].location == NSNotFound) {
            isText = YES;
        }
    }
    if (isText) {
        [self.myView addTextView:[self colorFromHexString:colorCode]];
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        [self.myView addSticker:image];
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:1.0];
}

@end
