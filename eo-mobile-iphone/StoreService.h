//
//  StoreService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreService : NSObject

// GET /stores
+ (void) getStores:(id)sender;

// GET /store/{store_id}
+ (void) getStore:(id)sender:(long)storeId;

// GET /store/{store_name}
+ (void) getStoreByName:(id)sender:(NSString*)storeName;

@end
