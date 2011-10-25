//
//  Product.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 24/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
    NSNumber* productId;
    NSString* category;
    NSString* name;
    NSString* descr;
    NSNumber* price;
    NSNumber* store_id;
}

@property (nonatomic,retain) NSNumber* productId;
@property (nonatomic,retain) NSString* category;
@property (nonatomic,retain) NSString* descr;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSNumber* price;
@property (nonatomic,retain) NSNumber* store_id;

@end
