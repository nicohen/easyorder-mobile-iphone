//
//  OrderProductViewController.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 31/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderProductViewController.h"
#import "ReachabilityService.h"
#import "OrderService.h"
#import "OrderProduct.h"

@implementation OrderProductViewController

@synthesize descr, order, productId; //, myPickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil productId:(NSInteger)myProductId
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        productId = [[NSNumber alloc] initWithInt:myProductId];
    }
    return self;
}

/*
#pragma mark -
#pragma mark UIPickerView

// return the picker frame based on its size, positioned at the bottom of the page
- (CGRect)pickerFrameWithSize:(CGSize)size
{
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect pickerRect = CGRectMake(	0.0,
                                   screenRect.size.height - 42.0 - size.height,
                                   size.width,
                                   size.height);
	return pickerRect;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0) {
        if(productQty > 0) {
            productQtyField.text = [NSString stringWithFormat:@"%d", productQty];
        } else {
            productQtyField.text = @"1";
        }
    }
}

- (IBAction)createPicker {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                      delegate:self
                                             cancelButtonTitle:@"Cancelar"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"Aceptar", nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    
	myPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
	
	myPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	CGSize pickerSize = [myPickerView sizeThatFits:CGSizeZero];
	myPickerView.frame = [self pickerFrameWithSize:pickerSize];
    
	myPickerView.showsSelectionIndicator = YES;	// note this is default to NO
	
	// this view controller is the data source and delegate
	myPickerView.delegate = self;
	myPickerView.dataSource = self;
    
	// add this picker to our view controller
	[actionSheet addSubview:myPickerView];

    [actionSheet showInView:self.view];
    
    [actionSheet setBounds:CGRectMake(0,0,320, 570)];
    [myPickerView setFrame:CGRectMake(0, 150, 320, 216)];        
    
    [myPickerView release];
    [actionSheet release];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[NSNumber numberWithInt:row+1] stringValue];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return 99;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    productQty = [pickerView selectedRowInComponent:0]+1;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}
*/

- (void)cancelOrder:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)placeOrder:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [OrderService orderProduct:sender accessToken:[prefs objectForKey:@"access_token"] productId:[productId longValue] orderId:[prefs objectForKey:@"order_id"] quantity:productQty comment:productDescr.text];

    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)increaseQuantity {
    productQty += 1;
    productQtyField.text = [[NSNumber numberWithInt:productQty] stringValue];
}

- (IBAction)decreaseQuantity {
    if(productQty > 1) {
        productQty -= 1;
        productQtyField.text = [[NSNumber numberWithInt:productQty] stringValue];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Textures 78.jpg"]];
    
    productQty = 1;
    
    //Order button definition
    UIBarButtonItem *buttonSave = [[UIBarButtonItem alloc] initWithTitle:@"Aceptar" style:UIBarButtonItemStyleDone target:self action:@selector(placeOrder:)];
    self.navigationItem.rightBarButtonItem = buttonSave;
    [buttonSave release];
    
    //Cancel button definition
    UIBarButtonItem *buttonCancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancelar" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelOrder:)];
    self.navigationItem.leftBarButtonItem = buttonCancel;
    [buttonCancel release];

}

#pragma mark - Rest service

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObject:(id)object {
    //OrderProduct* orderProduct = object;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error realizando pedido" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [[ReachabilityService sharedService] notifyNetworkUnreachable];
    }
}

@end
