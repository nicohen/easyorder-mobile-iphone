//
//  CategoryListViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSNumber* storeId;

    NSMutableArray* categoryArray;
    NSMutableDictionary *categoryMap;
    IBOutlet UITableView *table;
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,retain) NSMutableArray *categoryArray;

@end
