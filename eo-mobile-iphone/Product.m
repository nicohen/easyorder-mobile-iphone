//
//  Product.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize productId, category, name, price, store_id, descr;

- (void)dealloc {
    [productId release];
    [category release];
    [name release];
    [descr release];
    [price release];
    [store_id release];
    [super dealloc];
}

@end
