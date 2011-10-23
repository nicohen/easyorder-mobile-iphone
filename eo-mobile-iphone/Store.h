//
//  Store.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject {
    NSNumber* storeId;
    NSString* address;
    NSString* category;
    NSString* city;
    NSString* country;
    NSString* description;
    NSString* email;
    NSString* hours;
    NSString* name;
    NSString* phone;
    NSString* state;
    NSString* web;
}

@property (nonatomic,retain) NSNumber* storeId;
@property (nonatomic,retain) NSString* address;
@property (nonatomic,retain) NSString* category;
@property (nonatomic,retain) NSString* city;
@property (nonatomic,retain) NSString* country;
@property (nonatomic,retain) NSString* description;
@property (nonatomic,retain) NSString* email;
@property (nonatomic,retain) NSString* hours;
@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* phone;
@property (nonatomic,retain) NSString* state;
@property (nonatomic,retain) NSString* web;

@end
