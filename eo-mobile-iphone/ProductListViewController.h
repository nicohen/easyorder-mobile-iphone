//
//  ProductListViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "StoreAlertsDelegate.h"

@interface ProductListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, ImageDownloaderDelegate, UIActionSheetDelegate> {
    
    id<StoreAlertsDelegate> delegate;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *table;
    UITableViewCell *productListCell;
    NSMutableArray *productListArray;
    NSNumber* storeId;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic,assign) NSNumber* storeId;
@property (nonatomic,assign) IBOutlet UITableViewCell *productListCell;
@property (nonatomic,retain) NSMutableArray *productListArray;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
