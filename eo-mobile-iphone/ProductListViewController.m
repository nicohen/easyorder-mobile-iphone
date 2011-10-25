//
//  ProductListViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductListViewController.h"
#import "ProductDetailsViewController.h"
#import "ProductService.h"
#import "Product.h"
#import "ReachabilityService.h"

#define IMAGE_TAG 1
#define TITLELABEL_TAG 2
#define DESCRLABEL_TAG 3
#define PRICELABEL_TAG 4

@implementation ProductListViewController

@synthesize productListCell, productListArray, storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
    
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    [self.navigationController setToolbarItems:[NSArray arrayWithObject:backItem]];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];

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
    return 80;
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
    
    /*
    //Lazy load for the image
    if(!product.image) {
        if (table.dragging == NO && table.decelerating == NO) {
            [self startImageDownload:bate forIndexPath:indexPath];
        }
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[UIImage imageNamed:[ImageUtils logoMini]]];
    } else {
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:bate.image];
    }
    */
    
    //Set the labels
    [(UILabel *)[cell viewWithTag:TITLELABEL_TAG] setText:product.name];
    [(UILabel *)[cell viewWithTag:DESCRLABEL_TAG] setText:product.descr];
    
    NSNumberFormatter *format=[[NSNumberFormatter alloc] init];
    [format setCurrencyGroupingSeparator:@","];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *convertNumber = [format stringFromNumber:product.price];
    [(UILabel *)[cell viewWithTag:PRICELABEL_TAG] setText:[NSString stringWithFormat:@"$%@", convertNumber]];
    
    cell.tag = [[[productListArray objectAtIndex:indexPath.row] productId] longValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    ProductDetailsViewController *detailController = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil productId:cell.tag];
    
    detailController.title = [[productListArray objectAtIndex:indexPath.row] name];
    
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {    
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
    [productListArray release];
    [super dealloc];
}

@end
