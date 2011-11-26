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

@synthesize delegate, storeId;

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

    [LoginService signin:self:email.text:password.text];
}

- (IBAction)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];

    //Signin button definition
    UIBarButtonItem *buttonLogin = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" style:UIBarButtonItemStyleDone target:self action:@selector(login:)];
    self.navigationItem.rightBarButtonItem = buttonLogin;
    [buttonLogin release];
    
    //Cancel button definition
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    [buttonCancel release];
    
    [email becomeFirstResponder];
}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    User* user = object;
    
    if(![[StringUtils nilValue:user.accessToken] isEqualToString:@""]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:user.accessToken forKey:@"access_token"];
    
        [self dismissModalViewControllerAnimated:YES];
        [self.delegate didSignin];
    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        [password setText:@""];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Email o contraseña inválidos" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

@end
