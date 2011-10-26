//
//  LoginService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginService : NSObject

// POST /users
+ (void) signup:(id)sender:(NSString*)name:(NSString*)surname:(NSString*)email:(NSString*)password:(NSString*)gender:(NSNumber*)birthdate;

// PUT /users/signin
+ (void) signin:(id)sender:(NSString*)email:(NSString*)password:(NSString*)code;

@end
