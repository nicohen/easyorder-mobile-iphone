//
//  User.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 29/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation User

@synthesize name, surname, email, password, gender, birthdate, accessToken;

- (void)dealloc {
    [name release];
    [surname release];
    [email release];
    [password release];
    [gender release];
    [birthdate release];
    [accessToken release];
    [super dealloc];
}

+ (void) initUser {
    // Grab the reference to the router from the manager
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[User class] toResourcePath:@"/users" forMethod:RKRequestMethodPOST];
    [router routeClass:[User class] toResourcePath:@"/users/signin" forMethod:RKRequestMethodPUT];
}

@end
