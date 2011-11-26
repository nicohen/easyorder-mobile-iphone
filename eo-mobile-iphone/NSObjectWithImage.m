//
//  NSObjectWithImage.m
//  Hunting Web
//
//  Created by Nicolás Cohen on 26/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObjectWithImage.h"

@implementation NSObjectWithImage

@synthesize image;

- (void) dealloc {
    [image release];
    [super dealloc];
}

@end
