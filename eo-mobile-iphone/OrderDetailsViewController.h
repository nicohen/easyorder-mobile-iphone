//
//  OrderDetailsViewController.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderProduct.h"
#import "Product.h"

@interface OrderDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    UITableViewCell *orderCell;
    UITableViewCell *totalCell;
    UITableViewCell *emptyCell;
    NSMutableArray *orderArray;
    NSMutableArray *pendingArray;
    NSMutableArray *inprogressArray;
    NSMutableArray *doneArray;
    IBOutlet UITableView *table;
    UIActivityIndicatorView *activityIndicator;
    double totalPrice;
    IBOutlet UIImageView* commentImage;
    //NSMutableDictionary *imageDownloadsInProgress;
}

@property (nonatomic,assign) IBOutlet UITableViewCell* orderCell;
@property (nonatomic,assign) IBOutlet UITableViewCell* totalCell;
@property (nonatomic,assign) IBOutlet UITableViewCell* emptyCell;
@property (nonatomic,retain) NSMutableArray* orderArray;

/*@property (nonatomic,retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)appImageDidLoad:(NSIndexPath *)indexPath;
*/

@end
