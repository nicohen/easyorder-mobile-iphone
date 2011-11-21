//
//  LoginService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginService.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "User.h"

@implementation LoginService

+ (void) signup:(id)sender:(NSString*)name:(NSString*)surname:(NSString*)email:(NSString*)password:(NSString*)gender:(NSNumber*)birthdate {
    User* user = [[User alloc] init];
    user.name = name; 
    user.surname = surname; 
    user.email = email; 
    user.password = password;
    user.gender = gender;
    user.birthdate = birthdate;
    
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapAttributes:@"name", @"surname", @"email", @"password", @"gender", @"birthdate", nil];
    [userMapping mapKeyPath:@"access_token" toAttribute:@"accessToken"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"user"]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userMapping inverseMapping] forClass:[User class]]; 
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] postObject:user delegate:sender];
}

+ (void) signin:(id)sender:(NSString*)email:(NSString*)password {
    User* user = [[User alloc] init];
    user.email = email; 
    user.password = password;

    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping mapAttributes:@"name", @"surname", @"email", @"password", @"gender", @"birthdate", nil];
    [userMapping mapKeyPath:@"access_token" toAttribute:@"accessToken"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:userMapping forKeyPath:@"user"]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[userMapping inverseMapping] forClass:[User class]]; 
    [[RKObjectManager sharedManager] setSerializationMIMEType:RKMIMETypeJSON];
    
    [[RKObjectManager sharedManager] putObject:user delegate:sender];
}

@end
