//
//  StoreService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StoreService.h"
#import "Store.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation StoreService

+ (void) getStores:(id)sender {
    RKObjectMapping* storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping mapAttributes:@"address", @"category", @"city", @"country", @"description", @"email", @"hours", @"name", @"phone", @"state", @"web", nil];
    [storeMapping mapKeyPath:@"id" toAttribute:@"storeId"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:storeMapping forKeyPath:@"store"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:@"/stores" delegate:sender];
}

+ (void) getStore:(id)sender:(long)storeId {
    RKObjectMapping* storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping mapAttributes:@"address", @"category", @"city", @"country", @"description", @"email", @"hours", @"name", @"phone", @"state", @"web", nil];
    [storeMapping mapKeyPath:@"id" toAttribute:@"storeId"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:storeMapping forKeyPath:@"store"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/stores/%d", storeId] delegate:sender];
}

+ (void) getStoreByName:(id)sender:(NSString*)storeName {
    RKObjectMapping* storeMapping = [RKObjectMapping mappingForClass:[Store class]];
    [storeMapping mapAttributes:@"address", @"category", @"city", @"country", @"description", @"email", @"hours", @"name", @"phone", @"state", @"web", nil];
    [storeMapping mapKeyPath:@"id" toAttribute:@"storeId"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:storeMapping forKeyPath:@"store"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/stores/%@", storeName] delegate:sender];
}

@end
