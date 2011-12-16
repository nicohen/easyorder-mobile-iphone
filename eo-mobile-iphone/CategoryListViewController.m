//
//  CategoryListViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryListViewController.h"
#import "ReachabilityService.h"
#import "ProductService.h"
#import "ProductListViewController.h"
#import "Product.h"
#import "Category.h"

@implementation CategoryListViewController

@synthesize categoryArray, storeId;

- (void)back:(id)sender{
    //Cancel downloads from bates
    [[RKRequestQueue requestQueue] cancelAllRequests];
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
    [activityIndicator setHidden:NO];
    
    //Start animating the spinner with the network activity
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [ProductService getStoreProducts:self:[storeId longValue]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [categoryArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[[categoryArray objectAtIndex:indexPath.row] category]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    ProductListViewController *productsController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    //productsController.title = [[categoryArray objectAtIndex:indexPath.row] title];
    [self.navigationController pushViewController:productsController animated:YES];
    [table deselectRowAtIndexPath:indexPath animated:NO];
    [productsController release];
    
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Shows the table again
    [table setHidden:NO];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    Category* category;
    for(Product *product in objects) {
        category = [dictionary objectForKey:[product category]];
        if([category quantity] > 0) {
            [category setQuantity:[NSNumber numberWithInt:[[category quantity] intValue]+1]];
            [dictionary setObject:category forKey:[product category]];
        } else {
            category = [[Category alloc] init];
            [category setName:[product category]];
            [category setQuantity:[NSNumber numberWithInt:1]];
            [dictionary setObject:category forKey:[product category]];
        }
    }
    
	categoryArray = [NSMutableArray arrayWithArray:[dictionary allValues]];

    [categoryArray retain];   
    [table reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

- (void)dealloc{
    [categoryArray release];
    [table release];
    [activityIndicator release];
    [super dealloc];
}


@end
