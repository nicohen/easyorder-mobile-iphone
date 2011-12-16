//
//  AlertsService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AlertsService.h"
#import "Alert.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation AlertsService

+ (void) orderBill:(id)sender:(long)storeId:(long)orderId {
    Alert* alert = [[Alert alloc] init];
    alert.alertType = @"bill";
    alert.storeId = [NSNumber numberWithLong:storeId];
    alert.orderId = [NSNumber numberWithLong:orderId];
    
    RKObjectMapping* alertMapping = [RKObjectMapping mappingForClass:[Alert class]];
    [alertMapping mapKeyPath:@"id" toAttribute:@"alertId"];
    [alertMapping mapKeyPath:@"alert_type" toAttribute:@"alertType"];
    [alertMapping mapKeyPath:@"store_id" toAttribute:@"storeId"];
    [alertMapping mapKeyPath:@"order_id" toAttribute:@"orderId"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:alertMapping forKeyPath:@"alert"]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[alertMapping inverseMapping] forClass:[Alert class]]; 
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:alert delegate:sender];
    [alert release];
}

+ (void) callTheWaiter:(id)sender:(long)storeId:(long)orderId {
    Alert* alert = [[Alert alloc] init];
    alert.alertType = @"waiter";
    alert.storeId = [NSNumber numberWithLong:storeId];
    alert.orderId = [NSNumber numberWithLong:orderId];
    
    RKObjectMapping* alertMapping = [RKObjectMapping mappingForClass:[Alert class]];
    [alertMapping mapKeyPath:@"id" toAttribute:@"alertId"];
    [alertMapping mapKeyPath:@"alert_type" toAttribute:@"alertType"];
    [alertMapping mapKeyPath:@"store_id" toAttribute:@"storeId"];
    [alertMapping mapKeyPath:@"order_id" toAttribute:@"orderId"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:alertMapping forKeyPath:@"alert"]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[alertMapping inverseMapping] forClass:[Alert class]]; 
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:alert delegate:sender];
    [alert release];
}

@end
