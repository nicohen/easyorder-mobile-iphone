//
//  eo_mobile_iphoneAppDelegate.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "eo_mobile_iphoneAppDelegate.h"
#import "StoreSearchViewController.h"
#import "ReachabilityService.h"
#import "User.h"
#import "OrderProduct.h"
#import "Alert.h"
#import <RestKit/RestKit.h>

@implementation eo_mobile_iphoneAppDelegate

@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Initialize objectManager for all the application with the base url
    [RKObjectManager objectManagerWithBaseURL:@"http://127.0.0.1:9095/eo-services/api"];
    [User initUser];
    [OrderProduct initOrderProduct];
    [Alert initAlert];
    
    //Start reachability observer for all the application
    [[ReachabilityService sharedService] setup];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"access_token"];
    [prefs setObject:@"" forKey:@"access_code"];
    [prefs setInteger:0 forKey:@"order_id"];
    [prefs setInteger:0 forKey:@"store_id"];
    [prefs setObject:@"http://localhost:9095/eo-services/api" forKey:@"base_url"];

    //Calls the LoginViewController
    viewController = [[StoreSearchViewController alloc] initWithNibName:@"StoreSearchViewController" bundle:nil];

    [viewController setTitle:@"EasyOrder"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];

    [window setRootViewController:navController];
    [window makeKeyAndVisible];
    [navController release];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [viewController release];
    [super dealloc];
}

@end
