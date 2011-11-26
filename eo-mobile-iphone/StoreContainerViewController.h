//
//  StoreContainerViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreContainerViewController : UIViewController {
    IBOutlet UITabBarController* tabBar;
    NSNumber *storeId;
}

@property (nonatomic,retain) NSNumber* storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId;

@end
