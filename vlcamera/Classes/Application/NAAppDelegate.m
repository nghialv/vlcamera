//
//  NAAppDelegate.m
//  vlcamera
//
//  Created by iNghia on 8/10/13.
//  Copyright (c) 2013 nghialv. All rights reserved.
//

#import "NAAppDelegate.h"
#import <SHKConfiguration.h>
#import "NAShareKitConfigurator.h"

@implementation NAAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // config sharekit
    NAShareKitConfigurator *sharekitConfig = [[NAShareKitConfigurator alloc] init];
    [SHKConfiguration sharedInstanceWithConfigurator:sharekitConfig];
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    self.topViewController = [[NATopViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.topViewController];
    //navController.navigationBar.tintColor = [[NADB5 theme] colorForKey:@"navbar_color"];
    if (IS_IPAD) {
        [navController.navigationBar setBackgroundImage:[[NADB5 theme] imageForKey:@"ipad_navbar_bg_image"]
                                          forBarMetrics:0];
    } else {
        [navController.navigationBar setBackgroundImage:[[NADB5 theme] imageForKey:@"navbar_bg_image"]
                                      forBarMetrics:0];
    }
    [[UIBarButtonItem appearance] setTintColor:[[NADB5 theme] colorForKey:@"bar_btn_color"]];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
