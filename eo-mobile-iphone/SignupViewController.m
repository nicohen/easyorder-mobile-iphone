//
//  SignupViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginService.h"
#import "ReachabilityService.h"
#import "ProductListViewController.h"
#import "User.h"
#import "StringUtils.h"

@implementation SignupViewController

@synthesize storeId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// If the user press DONE button or ENTER
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)signup:(id)sender {
    NSString* genderStr = @"M";
    
    switch (gender.selectedSegmentIndex) {
        case 0:
            genderStr = @"M";
            break;
        case 1:
            genderStr = @"F";
            break;
        default:
            break;
    }
    
    if([StringUtils isNil:name.text] || [StringUtils isNil:surname.text] || [StringUtils isNil:email.text] || [StringUtils isNil:password.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Los campos deben contener valores" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    [LoginService signup:self:name.text:surname.text:email.text:password.text:genderStr:[NSNumber numberWithLong:(long)[datePicked timeIntervalSince1970]]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];

    //Signin button definition
    UIBarButtonItem *buttonSignin = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" style:UIBarButtonItemStyleDone target:self action:@selector(signup:)];
    self.navigationItem.rightBarButtonItem = buttonSignin;
    [buttonSignin release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        UIDatePicker *date = [[actionSheet subviews] objectAtIndex:2];
        datePicked = [[date date] retain];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"MMM dd yyyy"];
        dateField.text = [formatter stringFromDate:datePicked];
        [formatter release];
    }
}

- (IBAction)showDatePicker:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancelar"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Aceptar", nil];
    
    // Add the picker
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    pickerView.datePickerMode = UIDatePickerModeDate;
    if(datePicked) {
        pickerView.date = datePicked;
    } else {
        pickerView.date = [NSDate date];
    }
    [menu addSubview:pickerView];
    [menu showInView:self.view];
    
    [menu setBounds:CGRectMake(0,0,320, 570)];
    [pickerView setFrame:CGRectMake(0, 150, 320, 216)];        
    
    [pickerView release];
    [menu release];        
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
