//
//  ProductListViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductDetailsViewController.h"
#import "OrderDetailsViewController.h"
#import "ProductService.h"
#import "Product.h"
#import "ReachabilityService.h"
#import "ImageUtils.h"

#define IMAGE_TAG 1
#define TITLELABEL_TAG 2
#define DESCRLABEL_TAG 3
#define PRICELABEL_TAG 4

@implementation ProductListViewController

@synthesize productListCell, productListArray, storeId, imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)back:(id)sender {
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];

    //Cancel downloads
    [[RKRequestQueue requestQueue] cancelAllRequests];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewOrder:(id)sender {
    OrderDetailsViewController *viewOrder = [[OrderDetailsViewController alloc] initWithNibName:@"OrderDetailsViewController" bundle:nil];
    viewOrder.orderId = [NSNumber numberWithInt:1];
    viewOrder.title = @"Pedido";
    [self.navigationController pushViewController:viewOrder animated:YES];
    [viewOrder release];
}

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
    
    if ([productListArray count] > 0) {
        NSArray *visiblePaths = [table indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Product *product = [productListArray objectAtIndex:indexPath.row];
            
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
    
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Atras" forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    [self.navigationController setToolbarItems:[NSArray arrayWithObject:backItem]];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"order_id"] > 0) {
        //Order button definition
        UIBarButtonItem *buttonOrder = [[UIBarButtonItem alloc] initWithTitle:@"Mi pedido" style:UIBarButtonItemStyleBordered target:self action:@selector(viewOrder:)];
        self.navigationItem.rightBarButtonItem = buttonOrder;
        [buttonOrder release];
    }
    
    //Sets the table hidden and shows the animator
    [table setHidden:YES];
    
    //Start animating the spinner with the network activity
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [ProductService getStoreProducts:self:[storeId longValue]];       
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [productListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productListTableCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"productListTableCell" owner:self options:nil];
        cell = productListCell;
        self.productListCell = nil;
    }
    
    //Get the row for the Bate
    Product *product = [productListArray objectAtIndex:indexPath.row];
    
    //Lazy load for the image
    if(!product.image) {
        if (table.dragging == NO && table.decelerating == NO) {
            [self startImageDownload:product forIndexPath:indexPath];
        }
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[UIImage imageNamed:[ImageUtils noImageThumb]]];
    } else {
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:product.image];
    }
    
    //Set the labels
    [(UILabel *)[cell viewWithTag:TITLELABEL_TAG] setText:product.name];
    [(UILabel *)[cell viewWithTag:DESCRLABEL_TAG] setText:product.descr];
    
    NSNumberFormatter *format=[[NSNumberFormatter alloc] init];
    [format setCurrencyGroupingSeparator:@","];
    [format setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *convertNumber = [format stringFromNumber:product.price];
    [(UILabel *)[cell viewWithTag:PRICELABEL_TAG] setText:[NSString stringWithFormat:@"%@", convertNumber]];
    [format release];
    
    cell.tag = [[[productListArray objectAtIndex:indexPath.row] productId] longValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    ProductDetailsViewController *detailController = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil storeId:[storeId intValue] productId:cell.tag];
    
    detailController.title = [[productListArray objectAtIndex:indexPath.row] name];
    
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {    
    [imageDownloadsInProgress removeAllObjects];

    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Shows the table again
    [table setHidden:NO];
    
    productListArray = [NSMutableArray arrayWithArray:objects];
    [productListArray retain];
    [table reloadData];                     
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Feeding Station error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

#pragma mark - Memory management
- (void)dealloc {
	[activityIndicator release];
    [table release];
    [productListCell release];
    [productListArray release];
    [storeId release];
    [imageDownloadsInProgress release];
    [super dealloc];
}

@end
