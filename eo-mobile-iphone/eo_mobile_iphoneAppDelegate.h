//
//  eo_mobile_iphoneAppDelegate.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class eo_mobile_iphoneViewController;

@interface eo_mobile_iphoneAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet eo_mobile_iphoneViewController *viewController;

@end
