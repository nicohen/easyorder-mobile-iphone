//
//  StoreSearchViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    NSMutableArray* storeArray;
    UITableViewCell* storeCell;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *table;
}

@property (nonatomic,retain) NSMutableArray *storeArray;
@property (nonatomic,retain) UITableViewCell *storeCell;

@end
