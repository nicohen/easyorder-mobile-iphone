//
//  OrderDetailsViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderDetailsViewController.h"
#import "OrderService.h"
#import "ReachabilityService.h"
#import "ImageUtils.h"

#define IMAGE_TAG 1
#define TITLE_TAG 2
#define DESCR_TAG 3
#define PRICE_TAG 4
#define QUANTITY_TAG 5

@implementation OrderDetailsViewController

@synthesize orderCell, orderArray, totalCell, emptyCell, orderId;//, imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}
*/

- (void)back:(id)sender {
    //Cancel downloads
    [[RKRequestQueue requestQueue] cancelAllRequests];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark Table cell image support

- (void)startImageDownload:(Product*)product forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) {
        imageDownloader = [[ImageDownloader alloc] init];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/products/%d/image/thumb", [prefs objectForKey:@"base_url"], [product.productId longValue]];
        
        imageDownloader.imageUrl = url;
        imageDownloader.object = product;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app images yet
- (void)loadImagesForOnscreenRows {
    
    if ([pendingArray count] > 0 || [inprogressArray count] > 0 || [doneArray count] > 0) {
        NSArray *visiblePaths = [table indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            NSLog(@"ROW: %@",[NSString stringWithFormat:@"%d",indexPath.row]);
            
            Product *product = [pendingArray objectAtIndex:indexPath.row];
            
            // avoid the app image download if the app already has an image
            if (!product.image) {
                [self startImageDownload:product forIndexPath:indexPath];
            }
            
        }
    }
}

// called by our ImageDownloader when an image is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    
    NSLog(@"ROW: %@",[NSString stringWithFormat:@"%d", indexPath.row]);
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil) {
        UITableViewCell *cell = [table cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:imageDownloader.object.image];
    }
}

// called by our ImageDownloader when an image fail to be displayed
- (void)appImageDidFailLoad:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    // Display the newly loaded image
    [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[UIImage imageNamed:[ImageUtils noImageThumb]]];
}

#pragma mark - Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}
*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
    
    //Start animating the spinner with the network activity
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Atras" forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    [self.navigationController setToolbarItems:[NSArray arrayWithObject:backItem]];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    //Sets the table hidden and shows the animator
    [table setHidden:YES];
    
    [OrderService getOrderedProducts:self:[orderId longValue]];
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadTable) userInfo:nil repeats:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if([pendingArray count] > 0) {
            return 83;
        } else {
            return 44;
        }
    } else if(indexPath.section == 1) {
        if([inprogressArray count] > 0) {
            return 83;
        } else {
            return 44;
        }
    } else if(indexPath.section == 2) {
        if([doneArray count] > 0) {
            return 83;
        } else {
            return 44;
        }
    } else {
        return 83;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if([pendingArray count] > 0) {
            return [pendingArray count];
        } else {
            return 1;
        }
    } else if(section == 1) {
        if([inprogressArray count] > 0) {
            return [inprogressArray count];
        } else {
            return 1;
        }
    } else if(section == 2) {
        if([doneArray count] > 0) {
            return [doneArray count];
        } else {
            return 1;
        }
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Pendientes";
    } else if(section == 1) {
        return @"En curso";
    } else if(section == 2) {
        return @"Entregados";
    } else {
        return @"Total";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderTotalCell"];
        if(cell==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"OrderTotalTableCell" owner:self options:nil];
            cell = totalCell;
            totalCell = nil;
        }

        NSNumberFormatter *format=[[NSNumberFormatter alloc] init];
        [format setCurrencyGroupingSeparator:@","];
        [format setNumberStyle:NSNumberFormatterCurrencyStyle];
        NSString *convertNumber = [format stringFromNumber:[NSNumber numberWithDouble:totalPrice]];
        [(UILabel *)[cell viewWithTag:PRICE_TAG] setText:[NSString stringWithFormat:@"%@", convertNumber]];
        [format release];
        return cell;
    }

    OrderProduct *orderProduct = nil;
    switch (indexPath.section) {
        case 0:
            if([pendingArray count] > 0) {
                orderProduct = [pendingArray objectAtIndex:indexPath.row];
            }
            break;
        case 1:
            if([inprogressArray count] > 0) {
                orderProduct = [inprogressArray objectAtIndex:indexPath.row];
            }
            break;
        case 2:
            if([doneArray count] > 0) {
                orderProduct = [doneArray objectAtIndex:indexPath.row];
            }
            break;
        default:
            break;
    }

    //This section doesn't have products
    if(orderProduct == nil) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell"];
        if(cell==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"OrderEmptyProductsTableCell" owner:self options:nil];
            cell = emptyCell;
            emptyCell = nil;
        }
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailsCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderDetailsTableCell" owner:self options:nil];
        cell = orderCell;
        self.orderCell = nil;
    }

    Product* product = orderProduct.product;

    bool imageError = NO;
    //Lazy load for the image
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@/products/%d/image/thumb", [prefs objectForKey:@"base_url"], [product.productId longValue]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (imageData==nil) {
        imageError = YES;
    } else {
        UIImage* myImage = [UIImage imageWithData:imageData];
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[ImageUtils imageByScalingAndCroppingForSize:myImage:CGSizeMake(80,80)]];
    }

    if([orderProduct.comment isEqualToString:@""]) {
        [commentImage setHidden:YES];
    } else {
        [commentImage setHidden:NO];
    }
    
    [(UILabel *)[cell viewWithTag:TITLE_TAG] setText:product.name];
    [(UILabel *)[cell viewWithTag:DESCR_TAG] setText:product.descr];
    [(UILabel *)[cell viewWithTag:QUANTITY_TAG] setText:[NSString stringWithFormat:@"%@u",[orderProduct.quantity stringValue]]];

    NSNumberFormatter *format=[[NSNumberFormatter alloc] init];
    [format setCurrencyGroupingSeparator:@","];
    [format setNumberStyle:NSNumberFormatterCurrencyStyle];
    double subtotal = [orderProduct.price doubleValue] * [orderProduct.quantity intValue];
    NSString *convertNumber = [format stringFromNumber:[NSNumber numberWithDouble:subtotal]];
    [(UILabel *)[cell viewWithTag:PRICE_TAG] setText:[NSString stringWithFormat:@"%@", convertNumber]];
    [format release];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderProduct *orderProduct = nil;
    if (indexPath.section == 0) {
        if([pendingArray count] > 0) {
            orderProduct = [pendingArray objectAtIndex:indexPath.row];
        }
    } else if(indexPath.section == 1) {
        if([inprogressArray count] > 0) {
            orderProduct = [inprogressArray objectAtIndex:indexPath.row];
        }
    } else if(indexPath.section == 2) {
        if([doneArray count] > 0) {
            orderProduct = [doneArray objectAtIndex:indexPath.row];
        }
    }
    
    if(orderProduct != nil && ![orderProduct.comment isEqualToString:@""]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Comentario" message:orderProduct.comment delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)reloadTable {
    [pendingArray removeAllObjects];
    [inprogressArray removeAllObjects];
    [doneArray removeAllObjects];

    //Start animating the spinner with the network activity
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [OrderService getOrderedProducts:self:[orderId longValue]];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //[imageDownloadsInProgress removeAllObjects];
    
    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Shows the table again
    [table setHidden:NO];
    
    orderArray = [NSMutableArray arrayWithArray:objects];
    [orderArray retain];
    
    if (!pendingArray) {
        pendingArray = [[NSMutableArray alloc] init];
    }
    if (!inprogressArray) {
        inprogressArray = [[NSMutableArray alloc] init];
    }
    if (!doneArray) {
        doneArray = [[NSMutableArray alloc] init];
    }
    
    totalPrice = 0.0;
    for (OrderProduct *myProduct in objects) {
        if ([myProduct.status isEqualToString:@"pending"]) {
            [pendingArray addObject:myProduct];
        } else if([myProduct.status isEqualToString:@"in_progress"]) {
            [inprogressArray addObject:myProduct];
        } else {
            [doneArray addObject:myProduct];
        }
        totalPrice += [myProduct.price doubleValue] * [myProduct.quantity intValue];
    }
    [table reloadData];                     
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //Start animating the spinner with the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error en pedido" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

#pragma mark - Memory managment

- (void)dealloc {
    [orderCell release];
    [totalCell release];
    [emptyCell release];
    [pendingArray release];
    [inprogressArray release];
    [doneArray release];
    [orderArray release];
    [activityIndicator release];
    [table release];
    //[imageDownloadsInProgress release];
    [super dealloc];    
}

@end
