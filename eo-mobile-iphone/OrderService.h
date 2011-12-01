//
//  OrderService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 01/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderService : NSObject

// GET /orders/{order_id}
+ (void) getOrder:(id)sender:(long)orderId;

// GET /orders/{order_id}/products
+ (void) getOrderedProducts:(id)sender:(long)orderId;

// POST /products/{product_id}/order
+ (void) orderProduct:(id)sender accessToken:(NSString*)accessToken productId:(long)productId accessCode:(NSString*)accessCode quantity:(int)quantity comment:(NSString*)comment;

@end
