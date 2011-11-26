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
#import "ProductListViewController.h"
#import "SigninViewController.h"
#import "SignupViewController.h"
#import "ImageUtils.h"
#import "StoreAccessViewController.h"

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

- (void)didSignin {
    //Logout button definition
    UIBarButtonItem *buttonLogout = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar sesión" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = buttonLogout;
    [buttonLogout release];
}

- (void)back:(id)sender{
    //Cancel downloads
    [[RKRequestQueue requestQueue] cancelAllRequests];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        SigninViewController *signinController = [[SigninViewController alloc] initWithNibName:@"SigninViewController" bundle:nil];
        
        signinController.delegate = self;
        [signinController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:signinController];
        [self presentModalViewController:navigationController animated:YES];
        
        signinController.storeId = [storeId retain];
        signinController.title = @"Usuario existente";
        [navigationController release];
        [signinController release];

    } else if (buttonIndex == 1) {
        SignupViewController *signupController = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
        signupController.title = @"Nuevo usuario";
        signupController.storeId = storeId;
        [self.navigationController pushViewController:signupController animated:YES];
        [signupController release];    
    } 
}

- (void)login:(id)sender{
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Usuario existente", @"Nuevo usuario", nil];
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];
    [popupQuery release];
}

- (void)logout:(id)sender{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"access_token"];
    [prefs setInteger:0 forKey:@"order_id"];
    [prefs setInteger:0 forKey:@"store_id"];
    
    //Login button definition
    UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Iniciar sesión" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = buttonLogin;
    [buttonLogin release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];
    
    table.backgroundColor = [UIColor clearColor];
    
    [scrollView setScrollEnabled:YES];
    [table setScrollEnabled:NO];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[StringUtils nilValue:[prefs objectForKey:@"access_token"]] isEqualToString:@""]) {
        //Login button definition
        UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Iniciar sesión" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
        self.navigationItem.rightBarButtonItem = buttonLogin;
        [buttonLogin release];
    } else {
        //Logout button definition
        UIBarButtonItem *buttonLogout = [[UIBarButtonItem alloc] initWithTitle:@"Cerrar sesión" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
        self.navigationItem.rightBarButtonItem = buttonLogout;
        [buttonLogout release];
    }

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

- (IBAction)accessToOrder:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if(![[StringUtils nilValue:[prefs objectForKey:@"access_token"]] isEqualToString:@""]) {

        if([prefs integerForKey:@"order_id"] == 0 || ([prefs integerForKey:@"order_id"] > 0 && [prefs integerForKey:@"store_id"] != [storeId integerValue])) {
            StoreAccessViewController *accessController = [[StoreAccessViewController alloc] initWithNibName:@"StoreAccessViewController" bundle:nil];
            accessController.storeId = store.storeId;
            accessController.title = @"Acceder";
        
            [self.navigationController pushViewController:accessController animated:YES];
        
            [accessController release];
        } else {
            ProductListViewController *productListController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
            productListController.storeId = storeId;
            productListController.title = store.name;
            
            [self.navigationController pushViewController:productListController animated:YES];
            
            [productListController release];
        }
    } else {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Acceso denegado" message:@"Para realizar un pedido, debes iniciar sesión" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
    }
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
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
    
    CGFloat deltaOrigin = 0.0;

    CGRect descFrame = description.frame;
    deltaOrigin += description.contentSize.height - description.frame.size.height;
    descFrame.size.height = description.contentSize.height;
    description.frame = descFrame;

    CGRect tableFrame = table.frame;
    tableFrame.origin.y += deltaOrigin;
    tableFrame.size.height = table.contentSize.height;
    table.frame = tableFrame;
    
    bool imageError = NO;
    UIImage* myImage = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@/stores/%d/image", [prefs objectForKey:@"base_url"], [[store storeId] longValue]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (imageData==nil) {
        imageError = YES;
    } else {
        myImage = [UIImage imageWithData:imageData];
        [image setImage:[ImageUtils imageByScalingAndCroppingForSize:myImage:CGSizeMake(60,60)]];
    }
    
    if(imageError) {
        myImage = [UIImage imageNamed:[ImageUtils noImageThumb]];
        [image setImage:[ImageUtils imageByScalingAndCroppingForSize:myImage:CGSizeMake(60,60)]];
    }

    [scrollView setContentSize:(CGSizeMake(320, tableFrame.origin.y+tableFrame.size.height+40))];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [store retain];
    [table reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error obteniendo los detalles del restaurant" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
