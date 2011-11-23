//
//  Order.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 01/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Order.h"

@implementation Order
    
@synthesize orderId, storeId, tableId, status, accessCode, price;

- (void)dealloc {
    [orderId release];
    [storeId release];
    [tableId release];
    [status release];
    [accessCode release];
    [super dealloc];
}

@end
