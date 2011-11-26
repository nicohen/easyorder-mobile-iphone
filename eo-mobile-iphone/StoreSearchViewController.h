//
//  StoreSearchViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownloader.h"
#import "Store.h"

@interface StoreSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UISearchBarDelegate, ImageDownloaderDelegate> {
    NSMutableArray* storeArray;
    UITableViewCell* storeCell;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITableView *table;
    IBOutlet UISearchBar* search;
    NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic,retain) NSMutableArray *storeArray;
@property (nonatomic,retain) UITableViewCell *storeCell;
@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end
