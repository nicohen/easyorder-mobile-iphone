//
//  eo_mobile_iphoneAppDelegate.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoreSearchViewController;

@interface eo_mobile_iphoneAppDelegate : NSObject <UIApplicationDelegate> {
    StoreSearchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
