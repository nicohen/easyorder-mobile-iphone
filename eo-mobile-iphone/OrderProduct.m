//
//  OrderProduct.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderProduct.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation OrderProduct

@synthesize orderProductId, orderId, product, userId, status, quantity, price, comment;

- (void)dealloc {
    [orderProductId release];
    [orderId release];
    [product release];
    [userId release];
    [status release];
    [quantity release];
    [price release];
    [comment release];
    [super dealloc];
}

+ (void) initOrder {
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[OrderProduct class] toResourcePath:@"/products/(productId)/order" forMethod:RKRequestMethodPOST];
}

@end
