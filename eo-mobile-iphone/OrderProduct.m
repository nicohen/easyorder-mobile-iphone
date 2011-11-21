//
//  OrderProduct.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderProduct.h"

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

@end
