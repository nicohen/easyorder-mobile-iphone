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
    NSNumber* productId;
    NSString* accessToken;
    NSString* accessCode;
    NSString* status;
    NSNumber* quantity;
    float price;
    NSString* comment;
}

@property (nonatomic,retain) NSNumber* orderId;
@property (nonatomic,retain) NSNumber* productId;
@property (nonatomic,retain) NSString* accessToken;
@property (nonatomic,retain) NSString* status;
@property (nonatomic,retain) NSString* accessCode;
@property (nonatomic,retain) NSNumber* quantity;
@property (nonatomic,assign) float price;
@property (nonatomic,retain) NSString* comment;

@end
