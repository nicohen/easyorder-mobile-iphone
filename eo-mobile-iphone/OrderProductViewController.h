//
//  OrderProductViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"

@interface OrderProductViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate> {
    NSInteger productQty;
    NSString* descr;
    IBOutlet UITextField* productQtyField;
    NSNumber* productId;
    Order* order;
}

@property (nonatomic,retain) NSString* descr;
@property (nonatomic,retain) Order* order;
@property (nonatomic,retain) NSNumber* productId;
@property (nonatomic, retain) UIPickerView *myPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productId:(NSInteger)myProductId;

@end
