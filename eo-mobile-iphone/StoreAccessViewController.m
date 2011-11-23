//
//  StoreAccessViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreAccessViewController.h"
#import "LoginService.h"
#import "ReachabilityService.h"
#import "ProductListViewController.h"
#import "Order.h"

@implementation StoreAccessViewController

@synthesize storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];
}

- (IBAction)accessStore:(id)sender {
    [LoginService access:self:[storeId longValue]:code.text];
}

// If the user press DONE button or ENTER
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self scrollViewToCenterOfScreen:textField];     
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{    
    [textField resignFirstResponder];       
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];

    return YES;
}

- (void)scrollViewToCenterOfScreen:(UIView *)theView {  
    CGFloat viewCenterY = theView.center.y;  
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];  
    
    CGFloat availableHeight = applicationFrame.size.height - 200;   
    
    CGFloat y = viewCenterY - availableHeight / 2.0;  
    if (y < 0) {  
        y = 0;  
    }  
    [scrollView setContentOffset:CGPointMake(0, y) animated:YES];  
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    Order* order = object;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:[order.orderId intValue] forKey:@"order_id"];
    [prefs setInteger:[order.storeId intValue] forKey:@"store_id"];
    
    ProductListViewController *productListController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    productListController.storeId = storeId;
    productListController.title = @"TEST";
    
    [self.navigationController pushViewController:productListController animated:YES];
    
    [productListController release];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error de acceso" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [alert show];
        NSLog(@"Hit error: %@", error);
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

@end
