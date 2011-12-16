//
//  Category.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Category.h"

@implementation Category

@synthesize name, quantity;

- (void)dealloc {
    [name release];
    [quantity release];
    [super dealloc];
}

@end
