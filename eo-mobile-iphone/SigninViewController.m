//
//  SigninViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SigninViewController.h"
#import "LoginService.h"
#import "ReachabilityService.h"
#import "ProductListViewController.h"

@implementation SigninViewController

@synthesize storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)login:(id)sender {
    [LoginService signin:self:email.text:password.text:code.text];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Signin button definition
    UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" style:UIBarButtonItemStylePlain target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = buttonLogin;
    [buttonLogin release];
}

#pragma mark - Rest service

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {  
    if ([request isGET]) {  
        if ([response isOK]) {  
            ProductListViewController *productListController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
            productListController.storeId = storeId;
            
            [self.navigationController pushViewController:productListController animated:YES];
            [productListController release];
        }  
    }
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        [password setText:@""];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error en datos ingresados" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

@end
