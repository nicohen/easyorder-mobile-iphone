//
//  ProductDetailsViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ProductService.h"
#import "Product.h"
#import "ReachabilityService.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderProductViewController.h"
#import "ImageUtils.h"

@implementation ProductDetailsViewController

@synthesize storeId, productId, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil storeId:(NSInteger)myStoreId productId:(NSInteger)myProductId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        storeId = [[NSNumber alloc] initWithInt:myStoreId];
        productId = [[NSNumber alloc] initWithInt:myProductId];
    }
    return self;
}

- (void)back:(id)sender{
    //Cancel downloads
    [[RKRequestQueue requestQueue] cancelAllRequests];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)orderProduct:(id)sender {
    //Calls OrderProductViewController
    OrderProductViewController *targetController = [[OrderProductViewController alloc] initWithNibName:@"OrderProductViewController" bundle:nil productId:[productId longValue]];

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:targetController];
    [targetController release];
    [self presentModalViewController:navController animated:YES];
    [navController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];

    //Initialize and starts the activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [scrollView setScrollEnabled:YES];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs integerForKey:@"order_id"] > 0) {
        //Order button definition
        UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Pedir" style:UIBarButtonItemStyleDone target:self action:@selector(orderProduct:)];
        self.navigationItem.rightBarButtonItem = buttonLogin;
        [buttonLogin release];
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

    [ProductService getStoreProduct:self:[storeId intValue]:[productId intValue]];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    //Stops the spinner and the network activity
    [activityIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    Product* product = object;
    
    [productTitle setText:product.name];
    [description setText:product.descr];
    
    NSNumberFormatter *format=[[NSNumberFormatter alloc] init];
    [format setCurrencyGroupingSeparator:@","];
    [format setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *convertNumber = [format stringFromNumber:product.price];
    [productPrice setText:convertNumber];
    
    bool imageError = NO;
    UIImage* myImage = nil;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *url = [NSString stringWithFormat:@"%@/products/%d/image", [prefs objectForKey:@"base_url"], [productId longValue]];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (imageData==nil) {
        imageError = YES;
    } else {
        myImage = [UIImage imageWithData:imageData];
        [image setImage:[ImageUtils imageByScalingAndCroppingForSize:myImage:CGSizeMake(264,198)]];
    }
    
    if(imageError) {
        [image setHidden:YES];
    }
    
    description.layer.borderWidth = 1;
    description.layer.borderColor = [[UIColor grayColor] CGColor];
    description.layer.cornerRadius = 8;
    
    CGRect descFrame = description.frame;
    descFrame.size.height = description.contentSize.height;
    description.frame = descFrame;
    
    [scrollView setContentSize:(CGSizeMake(320, descFrame.origin.y+descFrame.size.height+40))];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];    
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error obteniendo los detalles del producto" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

#pragma mark - Memory management

- (void) dealloc {
    [activityIndicator release];
    [storeId release];
    [productId release];
    [productTitle release];
    [image release];
    [description release];
    [scrollView release];
    [super dealloc];
}

@end
