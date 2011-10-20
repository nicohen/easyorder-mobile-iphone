//
//  ReachabilityService.m
//  eo-mobile-iphone
//
//  Created by Nicolás Cohen on 20/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReachabilityService.h"

@implementation ReachabilityService

static ReachabilityService *singleton = nil;

+ (ReachabilityService *)sharedService {
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedService] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(id)init {
	self = [super init];
	if (self != nil) {
        
	}
    
	return self;
}

- (void)setup {
    isNetworkServiceAvailable = NO;
    
    _observer = [[RKReachabilityObserver alloc] initWithHostname:@"mittjaktlag.se"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:RKReachabilityStateChangedNotification
                                               object:_observer];    
}

- (BOOL)isNetworkServiceAvailable {
    return isNetworkServiceAvailable;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_observer release];    
    [super dealloc];
}

- (void)notifyNetworkUnreachable {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Internet connection" message:@"Network unreachable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)reachabilityChanged:(NSNotification*)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver*)[notification object];
    
    isNetworkServiceAvailable = YES;
    
    if (![observer isNetworkReachable]) {
        //[self notifyNetworkUnreachable];
        isNetworkServiceAvailable = NO;
    }
}

@end