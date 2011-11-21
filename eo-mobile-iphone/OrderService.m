//
//  OrderService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 01/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "OrderService.h"
#import "Order.h"
#import "OrderProduct.h"
#import "Product.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation OrderService

+ (void) getOrder:(id)sender:(long)orderId {

}

+ (void) getOrderedProducts:(id)sender:(long)orderId {
    RKObjectMapping* productMapping = [RKObjectMapping mappingForClass:[Product class]];
    [productMapping mapAttributes:@"category", @"name", @"descr", @"price", @"store_id", nil];
    [productMapping mapKeyPath:@"id" toAttribute:@"productId"];

    RKObjectMapping* orderProductMapping = [RKObjectMapping mappingForClass:[OrderProduct class]];
    [orderProductMapping mapAttributes:@"status", @"quantity", @"price", @"comment", nil];
    [orderProductMapping mapKeyPath:@"order_id" toAttribute:@"orderId"];
    [orderProductMapping mapKeyPath:@"user_id" toAttribute:@"userId"];
    [orderProductMapping mapRelationship:@"product" withMapping:productMapping];
    [[RKObjectManager sharedManager].mappingProvider setMapping:orderProductMapping forKeyPath:@"orderProduct"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/orders/%d/products", orderId] delegate:sender];
}

+ (void) orderProduct:(id)sender accessToken:(NSString*)accessToken productId:(long)productId orderId:(long)orderId accessCode:(NSString*)accessCode quantity:(int)quantity comment:(NSString*)comment {
    Order* order = [[Order alloc] init];
    order.accessToken = accessToken;
    order.productId = [NSNumber numberWithLong:productId]; 
    order.orderId = [NSNumber numberWithLong:orderId]; 
    order.accessCode = accessCode;
    order.quantity = [NSNumber numberWithInt:quantity];
    order.comment = comment;
    
    RKObjectMapping* orderMapping = [RKObjectMapping mappingForClass:[Order class]];
    [orderMapping mapAttributes:@"quantity", @"comment", nil];
    [orderMapping mapKeyPath:@"access_code" toAttribute:@"accessCode"];
    [orderMapping mapKeyPath:@"order_id" toAttribute:@"orderId"];
    [orderMapping mapKeyPath:@"product_id" toAttribute:@"productId"];
    [orderMapping mapKeyPath:@"access_token" toAttribute:@"accessToken"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:orderMapping forKeyPath:@"orderProduct"]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[orderMapping inverseMapping] forClass:[Order class]]; 
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:order delegate:sender];
}

@end
