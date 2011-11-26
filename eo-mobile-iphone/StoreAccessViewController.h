//
//  StoreAccessViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreAccessDelegate
- (void)didMatchAccessCode;
@end

@interface StoreAccessViewController : UIViewController {
    id <StoreAccessDelegate> delegate;
    IBOutlet UITextField* code;
    NSNumber* storeId;
    IBOutlet UIScrollView* scrollView;
}

@property (assign) id <StoreAccessDelegate> delegate;
@property (nonatomic,assign) NSNumber* storeId;

- (void)scrollViewToCenterOfScreen:(UIView *)theView;

@end
