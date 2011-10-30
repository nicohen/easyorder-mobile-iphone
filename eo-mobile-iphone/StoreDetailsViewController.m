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
#import <QuartzCore/QuartzCore.h>
#import "ProductListViewController.h"
#import "SigninViewController.h"
#import "SignupViewController.h"

@implementation StoreDetailsViewController

@synthesize store, storeId, scrollView, description, address;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        storeId = [[NSNumber alloc] initWithInt:myStoreId];
    }
    return self;
}

- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        SigninViewController *signinController = [[SigninViewController alloc] initWithNibName:@"SigninViewController" bundle:nil];
        signinController.title = @"Ingresar";
        signinController.storeId = [storeId retain];
        [self.navigationController pushViewController:signinController animated:YES];
        [signinController release];    
    } else if (buttonIndex == 1) {
        SignupViewController *signupController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
        signupController.title = @"Regístrate";
        signupController.storeId = storeId;
        [self.navigationController pushViewController:signupController animated:YES];
        [signupController release];    
    } 
}

- (void)login:(id)sender{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ingresar", @"Regístrate", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [scrollView setScrollEnabled:YES];
    [table setScrollEnabled:NO];

    //Login button definition
    UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Acceder" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = buttonLogin;
    [buttonLogin release];

    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Atras" forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    [self.navigationController setToolbarItems:[NSArray arrayWithObject:backItem]];
    self.navigationItem.leftBarButtonItem = backItem;
    [backItem release];

    [StoreService getStore:self:[storeId longValue]];
}

- (IBAction)showProducts:(id)sender {
    ProductListViewController *productListController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    productListController.storeId = store.storeId;
    productListController.title = [store name];
    
    [self.navigationController pushViewController:productListController animated:YES];
    
    [productListController release];

}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title = nil;
	switch (section) {
		case 0:
			title = @"Ubicación";
			break;
		case 1:
			title = @"General";
			break;
		default:
			break;
	}
	return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (section == 0) return 3;
	if (section == 1) return 4;
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
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.textLabel.text = @"País";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 150.0, 20.0)];
            [lbl setFont:[UIFont boldSystemFontOfSize:14]];
            lbl.text = [store country];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.section == 0 && indexPath.row == 1) {
            cell.textLabel.text = @"Provincia";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 150.0, 20.0)];
            lbl.text = [store state];
            [lbl setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.section == 0 && indexPath.row == 2) {
            cell.textLabel.text = @"Ciudad";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 150.0, 20.0)];
            lbl.text = [store city];
            [lbl setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.section == 1 && indexPath.row == 0) {
            cell.textLabel.text = @"Horario";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 150.0, 20.0)];
            lbl.text = [store hours];
            [lbl setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.section == 1 && indexPath.row == 1) {
            cell.textLabel.text = @"Teléfono";
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 10, 150.0, 20.0)];
            lbl.text = [store phone];
            [lbl setFont:[UIFont boldSystemFontOfSize:14]];
            [cell.contentView addSubview:lbl];
            [lbl release];
        } else if(indexPath.section == 1 && indexPath.row == 2) {
            cell.textLabel.text = [store email];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        } else if(indexPath.section == 1 && indexPath.row == 3) {
            cell.textLabel.text = [store web];
            [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        }
    }
    return cell;
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    store = [objects objectAtIndex:0];
    
    [name setText:store.name];
    [description setText:store.description];
    [address setText:store.address];
    
    description.layer.borderWidth = 1;
    description.layer.borderColor = [[UIColor grayColor] CGColor];
    description.layer.cornerRadius = 8;
    address.layer.borderWidth = 1;
    address.layer.borderColor = [[UIColor grayColor] CGColor];
    address.layer.cornerRadius = 8;
    
    CGFloat deltaOrigin = 0.0;

    CGRect descFrame = description.frame;
    deltaOrigin += description.contentSize.height - description.frame.size.height;
    descFrame.size.height = description.contentSize.height;
    description.frame = descFrame;

    CGRect tableFrame = table.frame;
    tableFrame.origin.y += deltaOrigin;
    tableFrame.size.height = table.contentSize.height;
    table.frame = tableFrame;
    
    [scrollView setContentSize:(CGSizeMake(320, tableFrame.origin.y+tableFrame.size.height+40))];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    [scrollView release];
    [super dealloc];
}

@end
