//
//  SigninViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SigninDelegate
- (void)didSignin;
@end

@interface SigninViewController : UIViewController {
    id <SigninDelegate> delegate;
    IBOutlet UITextField* email;
    IBOutlet UITextField* password;
    NSNumber* storeId;
}

@property (assign) id <SigninDelegate> delegate;
@property (nonatomic,retain) NSNumber* storeId;

@end
