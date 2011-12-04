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

@synthesize orderProductId, orderId, storeId, product, userId, status, quantity, price, comment, accessToken, accessCode, productId;

- (void)dealloc {
    [orderProductId release];
    [orderId release];
    [storeId release];
    [product release];
    [userId release];
    [status release];
    [quantity release];
    [price release];
    [comment release];
    [accessToken release];
    [accessCode release];
    [productId release];
    [super dealloc];
}

+ (void) initOrderProduct {
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[OrderProduct class] toResourcePath:@"/products/:productId/order" forMethod:RKRequestMethodPOST];
}

@end
