//
//  Alert.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Alert.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation Alert

@synthesize alertId, alertType, storeId, orderId;

- (void)dealloc {
    [alertId release];
    [alertType release];
    [storeId release];
    [orderId release];
    [super dealloc];
}

+ (void) initAlert {
    RKObjectRouter *router = [RKObjectManager sharedManager].router;
    [router routeClass:[Alert class] toResourcePath:@"/alerts" forMethod:RKRequestMethodPOST];
    [router routeClass:[Alert class] toResourcePath:@"/alerts" forMethod:RKRequestMethodPUT];
}

@end
