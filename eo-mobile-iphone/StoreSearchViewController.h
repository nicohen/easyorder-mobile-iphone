//
//  StoreSearchViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate> {
    NSMutableArray* storeArray;
    UITableViewCell* storeCell;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *table;
    IBOutlet UISearchBar* search;
}

@property (nonatomic,retain) NSMutableArray *storeArray;
@property (nonatomic,retain) UITableViewCell *storeCell;

@end
