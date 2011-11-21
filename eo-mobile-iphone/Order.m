//
//  Order.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 01/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Order.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation Order
    
@synthesize orderId, productId, accessToken, accessCode, status, quantity, price, comment;

- (void)dealloc {
    [orderId release];
    [productId release];
    [accessToken release];
    [accessCode release];
    [status release];
    [quantity release];
    [comment release];
    [super dealloc];
}

+ (void) initOrder {
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[Order class] toResourcePath:@"/products/(productId)/order" forMethod:RKRequestMethodPOST];
}

@end
