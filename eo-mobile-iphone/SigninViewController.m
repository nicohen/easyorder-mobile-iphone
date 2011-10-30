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
#import "User.h"
#import "StringUtils.h"

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
    if([StringUtils isNil:email.text] || [StringUtils isNil:password.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Los campos deben contener valores" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

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
    
    [email becomeFirstResponder];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    User* user = object;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:user.accessToken forKey:@"access_token"];
    
    ProductListViewController *productListController = [[ProductListViewController alloc] initWithNibName:@"ProductListViewController" bundle:nil];
    productListController.storeId = storeId;
    
    [self.navigationController pushViewController:productListController animated:YES];
    [productListController release];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
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
