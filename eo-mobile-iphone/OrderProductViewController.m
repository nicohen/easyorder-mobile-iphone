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

- (void)cancelOrder:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)placeOrder:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    [OrderService orderProduct:self accessToken:[prefs objectForKey:@"access_token"] productId:[productId longValue] storeId:[prefs integerForKey:@"store_id"] accessCode:[prefs stringForKey:@"access_code"] quantity:productQty comment:productDescr.text];
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
    if(objectLoader.response.statusCode == 401) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Usted no está autorizado a realizar un pedido" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        if([[ReachabilityService sharedService] isNetworkServiceAvailable]) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error realizando pedido" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            [[ReachabilityService sharedService] notifyNetworkUnreachable];
        }
    }
}

@end
