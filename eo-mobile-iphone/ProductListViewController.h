//
//  ProductListViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *table;
    UITableViewCell *productListCell;
    NSMutableArray *productListArray;
    NSNumber* storeId;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,assign) IBOutlet UITableViewCell *productListCell;
@property (nonatomic,retain) NSMutableArray *productListArray;

@end
