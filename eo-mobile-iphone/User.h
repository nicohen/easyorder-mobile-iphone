//
//  User.h
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 29/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString* name;
    NSString* surname;
    NSString* email;
    NSString* password;
    NSString* gender;
    NSNumber* birthdate;
    NSString* accessToken;
}

@property (nonatomic,retain) NSString* name;
@property (nonatomic,retain) NSString* surname;
@property (nonatomic,retain) NSString* email;
@property (nonatomic,retain) NSString* password;
@property (nonatomic,retain) NSString* gender;
@property (nonatomic,retain) NSNumber* birthdate;
@property (nonatomic,retain) NSString* accessToken;

+ (void) initUser;

@end
