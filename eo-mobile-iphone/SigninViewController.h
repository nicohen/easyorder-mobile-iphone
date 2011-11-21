//
//  SigninViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SigninViewController : UIViewController {
    IBOutlet UITextField* email;
    IBOutlet UITextField* password;
    NSNumber* storeId;
}

@property (nonatomic,retain) NSNumber* storeId;

@end
