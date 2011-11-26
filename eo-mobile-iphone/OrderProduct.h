//
//  OrderProduct.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 03/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "NSObjectWithImage.h"

@interface OrderProduct : NSObjectWithImage {
    NSNumber* orderProductId;
    NSNumber* orderId;
    NSNumber* productId;
    Product* product;
    NSNumber* userId;
    NSString* status;
    NSNumber* quantity;
    NSNumber* price;
    NSString* comment;
    NSString* accessToken;
}

@property (nonatomic,retain) NSNumber* orderProductId;
@property (nonatomic,retain) NSNumber* orderId;
@property (nonatomic,retain) NSNumber* productId;
@property (nonatomic,retain) Product* product;
@property (nonatomic,retain) NSNumber* userId;
@property (nonatomic,retain) NSString* status;
@property (nonatomic,retain) NSNumber* quantity;
@property (nonatomic,retain) NSNumber* price;
@property (nonatomic,retain) NSString* comment;
@property (nonatomic,retain) NSString* accessToken;

+ (void) initOrderProduct;

@end
