//
//  StoreDetailsViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 22/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreDetailsViewController.h"
#import "StoreService.h"
#import "ReachabilityService.h"
#import "StringUtils.h"

@implementation StoreDetailsViewController

@synthesize store, storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        storeId = [[NSNumber alloc] initWithInt:myStoreId];
        NSLog(@"%@", [NSString stringWithFormat:@"S: %@", storeId]);
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    [self.navigationController setToolbarItems:[NSArray arrayWithObject:backItem]];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];

    [StoreService getStore:self:[storeId longValue]];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 4) {
        return 60;
    }
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	switch (section) {
		case 0:
			title = @"Ubicación";
			break;
		case 1:
			title = @"";
			break;
		case 2:
			title = @"General";
			break;
		default:
			break;
	}
	return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) return 4;
	if (section == 1) return 1;
	if (section == 2) return 4;
	else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (store) {
        UILabel *lbl = nil;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Country";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, 110.0, 20.0)];
            lbl.text = [store country];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.row == 1) {
            cell.textLabel.text = @"State";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 0, 110.0, 20.0)];
            lbl.text = [store state];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else {
            cell.textLabel.text = @"City";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(170.0, 0, 110.0, 20.0)];
            lbl.text = [store city];
            [cell.contentView addSubview:lbl];
            [lbl release];
        }
    }
    return cell;
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    store = [objects objectAtIndex:0];
    [store retain];
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

#pragma mark - Memory management

- (void) dealloc {
    [image release];
    [name release];
    [table release];
    [storeId release];
    [store release];
    [super dealloc];
}

@end
