//
//  OrderProductViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderProductViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
    NSInteger productQty;
    NSString* descr;
    IBOutlet UITextField* productQtyField;
}

@property (nonatomic,retain) NSString* descr;
@property (nonatomic, retain) UIPickerView *myPickerView;

@end
