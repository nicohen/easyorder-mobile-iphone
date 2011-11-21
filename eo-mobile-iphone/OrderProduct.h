//
//  OrderProduct.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface OrderProduct : NSObject {
    NSNumber* orderProductId;
    NSNumber* orderId;
    Product* product;
    NSNumber* userId;
    NSString* status;
    NSNumber* quantity;
    NSNumber* price;
    NSString* comment;
}

@property (nonatomic,retain) NSNumber* orderProductId;
@property (nonatomic,retain) NSNumber* orderId;
@property (nonatomic,retain) Product* product;
@property (nonatomic,retain) NSNumber* userId;
@property (nonatomic,retain) NSString* status;
@property (nonatomic,retain) NSNumber* quantity;
@property (nonatomic,retain) NSNumber* price;
@property (nonatomic,retain) NSString* comment;

@end
