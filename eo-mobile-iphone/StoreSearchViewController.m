//
//  StoreSearchViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreSearchViewController.h"
#import "StoreService.h"
#import "Store.h"
#import "StringUtils.h"
#import "ReachabilityService.h"
#import "StoreDetailsViewController.h"

@implementation StoreSearchViewController

@synthesize storeCell, storeArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //Sets the table hidden and shows the animator
    [table setHidden:YES];

    //Start animating the spinner with the network activity
    [activityIndicator startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    //Looses textbox focus and hides the keyboard
    [searchBar resignFirstResponder];

    //Calls the service to retrieve the stands list
    [StoreService getStoreByName:self:[searchBar text]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [search becomeFirstResponder];
    
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [storeArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Store *store = [storeArray objectAtIndex:indexPath.row];
    
    NSString *standName = [store name];
    NSString *standDesc = [store description];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [StringUtils nilValue:standName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [StringUtils nilValue:standDesc]];

    /*
    if(!stand.image) {
        if (table.dragging == NO && table.decelerating == NO) {
            [self startImageDownload:stand forIndexPath:indexPath];
        }
        cell.imageView.image = [UIImage imageNamed:[ImageUtils logoMini]];
    } else {
        cell.imageView.image = stand.image;
    }
    */
    cell.tag = [[[storeArray objectAtIndex:indexPath.row] storeId] longValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];

    StoreDetailsViewController *detailController = [[StoreDetailsViewController alloc] initWithNibName:@"StoreDetailsViewController" bundle:nil storeId:cell.tag];
    
    Store *myStore = [storeArray objectAtIndex:indexPath.row];
    if([StringUtils nilValue:[myStore name]] != @"") {
        detailController.title = [myStore name];
    }
    
    [self.navigationController pushViewController:detailController animated:YES];
    [detailController release];
}

#pragma mark Table cell image support
/*
- (void)startImageDownload:(Stand*)stand forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader == nil) {
        imageDownloader = [[ImageDownloader alloc] init];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *url = [NSString stringWithFormat:@"%@/%@", [prefs objectForKey:@"fileServerUrl"], [NSString stringWithFormat:@"%d", [prefs integerForKey:@"teamId"]]];
        
        imageDownloader.imageFilename = [stand imageFilename];
        imageDownloader.imageBaseUrl = url;
        imageDownloader.object = stand;
        imageDownloader.indexPathInTableView = indexPath;
        imageDownloader.delegate = self;
        [imageDownloadsInProgress setObject:imageDownloader forKey:indexPath];
        
        [imageDownloader startDownload];
        [imageDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app images yet
- (void)loadImagesForOnscreenRows {
    
    if ([standArray count] > 0) {
        NSArray *visiblePaths = [table indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Stand *stand = [standArray objectAtIndex:indexPath.row];
            
            // avoid the app image download if the app already has an image
            if (!stand.image) {
                [self startImageDownload:stand forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an image is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    
    ImageDownloader *imageDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (imageDownloader != nil) {
        UITableViewCell *cell = [table cellForRowAtIndexPath:imageDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = imageDownloader.object.image;
    }
}

// called by our ImageDownloader when an image fail to be displayed
- (void)appImageDidFailLoad:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[ImageUtils logoMini]];
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

#pragma mark - Rest service

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    NSLog(@"Retrieved XML: %@", [response bodyAsString]);  
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    //[imageDownloadsInProgress removeAllObjects];
    
    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //Shows the table again
    [table setHidden:NO];
    
    //Fill the table
	storeArray = [NSMutableArray arrayWithArray:objects];
    [storeArray retain];
    [table reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Stores error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

- (void)dealloc {
	[activityIndicator release];
    [storeArray release];
    [storeCell release];
    [super dealloc];
}

@end