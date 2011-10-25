//
//  ProductService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductService : NSObject

// GET /stores/{store_id}/products
+ (void) getStoreProducts:(id)sender:(long)storeId;

// GET /store/{store_id}/products/{product_id}
+ (void) getStoreProduct:(id)sender:(long)storeId:(long)productId;

@end
