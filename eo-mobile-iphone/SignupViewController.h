//
//  SignupViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate> {
    NSDate *datePicked;
    IBOutlet UITextField* name;
    IBOutlet UITextField* surname;
    IBOutlet UITextField* email;
    IBOutlet UITextField* password;
    IBOutlet UITextField* dateField;
    IBOutlet UISegmentedControl* gender;
    NSNumber* storeId;
}

@property (nonatomic,retain) NSNumber* storeId;

@end
