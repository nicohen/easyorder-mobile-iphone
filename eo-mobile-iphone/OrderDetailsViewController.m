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

@implementation OrderDetailsViewController

@synthesize orderCell, orderArray, orderId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back:(id)sender {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    //Start animating the spinner with the network activity
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [OrderService getOrderedProducts:self:[orderId longValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [pendingArray count];
    } else if(section == 1) {
        return [inprogressArray count];
    } else {
        return [doneArray count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Pendientes";
    } else if(section == 1) {
        return @"En curso";
    } else {
        return @"Finalizados";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderDetailsCell"];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"OrderDetailsTableCell" owner:self options:nil];
        cell = orderCell;
        self.orderCell = nil;
    }
    
    UIImageView *imageView;
    imageView = (UIImageView *)[cell viewWithTag:IMAGE_TAG];
    
    OrderProduct *orderProduct = nil;
    switch (indexPath.section) {
        case 0:
            orderProduct = [pendingArray objectAtIndex:indexPath.row];
            break;
        case 1:
            orderProduct = [inprogressArray objectAtIndex:indexPath.row];
            break;
        case 2:
            orderProduct = [doneArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    Product* product = orderProduct.product;

    bool imageError = NO;
    //Lazy load for the image
    if(!product.imagePath) {
        [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[UIImage imageNamed:[ImageUtils noImageThumb]]];
    } else {
        NSString *url = [NSString stringWithFormat:@"%@", [product imagePath]];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (imageData==nil) {
            imageError = YES;
        } else {
            UIImage* myImage = [UIImage imageWithData:imageData];
            [(UIImageView *)[cell viewWithTag:IMAGE_TAG] setImage:[ImageUtils imageByScalingAndCroppingForSize:myImage:CGSizeMake(60,60)]];
        }
    }

    [(UILabel *)[cell viewWithTag:TITLE_TAG] setText:product.name];
    [(UILabel *)[cell viewWithTag:DESCR_TAG] setText:product.descr];
    [(UILabel *)[cell viewWithTag:PRICE_TAG] setText:[NSString stringWithFormat:@"$%@", [orderProduct.price stringValue]]];
     
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Nothing to do
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
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
    
    for (OrderProduct *myProduct in objects) {
        if ([myProduct.status isEqualToString:@"pending"]) {
            [pendingArray addObject:myProduct];
        } else if([myProduct.status isEqualToString:@"in_progress"]) {
            [inprogressArray addObject:myProduct];
        } else {
            [doneArray addObject:myProduct];
        }
    }
    
    [table reloadData];                     
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    //Start animating the spinner with the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Projects error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

#pragma mark - Memory managment

- (void)dealloc {
    [orderCell release];
    [pendingArray release];
    [inprogressArray release];
    [doneArray release];
    [orderArray release];
    [activityIndicator release];
    [table release];
    [super dealloc];    
}

@end
