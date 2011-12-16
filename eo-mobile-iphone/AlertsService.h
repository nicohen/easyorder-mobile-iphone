//
//  AlertsService.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertsService : NSObject

// POST /alerts/bill/store/{store_id}/order/{order_id}
+ (void) orderBill:(id)sender:(long)storeId:(long)orderId;

// POST /alerts/waiter/store/{store_id}/order/{order_id}
+ (void) callTheWaiter:(id)sender:(long)storeId:(long)orderId;

@end