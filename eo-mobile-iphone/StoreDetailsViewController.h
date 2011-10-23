//
//  StoreDetailsViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 22/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"

@interface StoreDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIImageView *image;
    IBOutlet UILabel* name;
    IBOutlet UITableView *table;
    NSNumber *storeId;
    Store* store;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,retain) Store* store;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId;

@end
