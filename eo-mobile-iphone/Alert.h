//
//  Alert.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 09/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject {
    NSNumber* alertId;
    NSString* alertType;
    NSNumber* storeId;
    NSNumber* orderId;
}

@property (nonatomic,retain) NSNumber* alertId;
@property (nonatomic,retain) NSString* alertType;
@property (nonatomic,retain) NSNumber* storeId;
@property (nonatomic,retain) NSNumber* orderId;

+ (void) initAlert;

@end
