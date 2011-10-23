//
//  StringUtils.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringUtils.h"

@implementation StringUtils

+ (NSString*) nilValue:(NSString*)value {
    return value==nil?@"":value;
}

+ (BOOL) isNil:(NSString*)value {
    return value==nil;
}

@end