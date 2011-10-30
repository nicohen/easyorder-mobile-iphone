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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initialize and starts the activity indicator
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
	activityIndicator.center = self.view.center;
	[self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [scrollView setScrollEnabled:YES];
    
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
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
    Product* product = object;
    
    [productTitle setText:product.name];
    [description setText:product.descr];
    
    description.layer.borderWidth = 1;
    description.layer.borderColor = [[UIColor grayColor] CGColor];
    description.layer.cornerRadius = 8;
    
    CGFloat deltaOrigin = 0.0;
    
    CGRect descFrame = description.frame;
    deltaOrigin += description.contentSize.height - description.frame.size.height;
    descFrame.size.height = description.contentSize.height;
    description.frame = descFrame;
    
    [scrollView setContentSize:(CGSizeMake(320, descFrame.origin.y+descFrame.size.height+40))];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Product error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
