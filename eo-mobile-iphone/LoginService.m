//
//  LoginService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 25/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LoginService.h"

@implementation LoginService

+ (void) signup:(id)sender:(NSString*)name:(NSString*)surname:(NSString*)email:(NSString*)password:(NSString*)gender:(NSNumber*)birthdate {
/*
    RKObjectMapping* signMapping = [RKObjectMapping mappingForClass:[Store class]];
    [signMapping mapAttributes:@"name", @"surname", @"email", @"password", @"gender", @"birthdate", nil];

    [projectMapping mapKeyPath:@"id" toAttribute:@"projId"];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:projectMapping forKeyPath:@""]; 
    [[RKObjectManager sharedManager].mappingProvider setSerializationMapping:[projectMapping inverseMapping] forClass:[Project class]];
    
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    
    [[RKObjectManager sharedManager].router routeClass:[Project class] toResourcePath:@"/todos/create"];    
    
    [[RKObjectManager sharedManager] postObject:project delegate:sender];
*/
}

+ (void) signin:(id)sender:(NSString*)email:(NSString*)password:(NSString*)code {
    
}

@end
