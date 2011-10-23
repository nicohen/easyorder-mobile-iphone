//
//  StringUtils.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject

//Always returns a NSString, avoiding the nil value
+ (NSString*) nilValue:(NSString*)value;

//Returns if the current value is nil
+ (BOOL) isNil:(NSString*)value;

@end
