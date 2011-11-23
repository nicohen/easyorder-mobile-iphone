//
//  Order.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 01/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject {
    NSNumber* orderId;
    NSNumber* storeId;
    NSNumber* tableId;
    NSString* status;
    float price;
    NSString* accessCode;
}

@property (nonatomic,retain) NSNumber* orderId;
@property (nonatomic,retain) NSNumber* storeId;
@property (nonatomic,retain) NSNumber* tableId;
@property (nonatomic,retain) NSString* status;
@property (nonatomic,assign) float price;
@property (nonatomic,retain) NSString* accessCode;

@end
