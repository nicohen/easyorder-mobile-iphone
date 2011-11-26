//
//  ProductDetailsViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailsViewController : UIViewController {
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSNumber* storeId;
    NSNumber* productId;
    IBOutlet UILabel* productTitle;
    IBOutlet UILabel* productPrice;
    IBOutlet UIImageView* image;
    IBOutlet UITextView* description;
    IBOutlet UIScrollView *scrollView;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,assign) NSNumber* productId;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId productId:(NSInteger)myProductId;

@end
