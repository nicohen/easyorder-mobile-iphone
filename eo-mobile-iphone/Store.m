//
//  Store.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Store.h"

@implementation Store

@synthesize storeId, address, category, city, country, description, email, hours, name, phone, state, web;

- (void)dealloc {
    [storeId release];
    [address release];
    [category release];
    [city release];
    [country release];
    [description release];
    [email release];
    [hours release];
    [name release];
    [phone release];
    [state release];
    [web release];
    [super dealloc];
}

@end
