//
//  ProductService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ProductService.h"
#import "Product.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@implementation ProductService

+ (void) getStoreProducts:(id)sender:(long)storeId {
    RKObjectMapping* productMapping = [RKObjectMapping mappingForClass:[Product class]];
    [productMapping mapAttributes:@"category", @"name", @"descr", @"price", @"store_id", nil];
    [productMapping mapKeyPath:@"id" toAttribute:@"productId"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:productMapping forKeyPath:@"product"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"/stores/%d/products", storeId] delegate:sender];
}

+ (void) getStoreProduct:(id)sender:(long)storeId:(long)productId {
    RKObjectMapping* productMapping = [RKObjectMapping mappingForClass:[Product class]];
    [productMapping mapAttributes:@"category", @"name", @"descr", @"price", @"store_id", nil];
    [productMapping mapKeyPath:@"id" toAttribute:@"productId"];
    [[RKObjectManager sharedManager].mappingProvider setMapping:productMapping forKeyPath:@"product"];
    
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:[NSString stringWithFormat:@"products/%d", productId] delegate:sender];
}

@end
