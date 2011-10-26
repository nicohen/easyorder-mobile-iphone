//
//  StoreDetailsViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 22/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate> {
    IBOutlet UIImageView *image;
    IBOutlet UILabel* name;
    IBOutlet UITableView *table;
    NSNumber *storeId;
    Store* store;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITextView* description;
    IBOutlet UITextView* address;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,retain) Store* store;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UITextView* description;
@property (nonatomic,retain) IBOutlet UITextView* address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId;

@end
