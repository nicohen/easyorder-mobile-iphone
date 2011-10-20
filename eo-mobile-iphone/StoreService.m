//
//  StoreService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreService.h"
#import "Store.h"

@implementation StoreService

+ (void) getStores:(id)sender {
    RKObjectMapping* storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping mapAttributes:@"address", @"category", @"city", @"country", @"description", @"email", @"hours", @"name", @"phone", @"state", @"web", nil];
    [storeMapping mapKeyPath:@"id" toAttribute:@"storeId"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/stores" objectMapping:storeMapping delegate:sender];
}

@end
